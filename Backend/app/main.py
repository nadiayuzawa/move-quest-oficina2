
import os
import uuid
import json
from datetime import datetime, timedelta, timezone
from uuid import UUID
from pathlib import Path

from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from fastapi.responses import HTMLResponse
from pydantic import BaseModel, Field
from supabase import create_client, Client



# =====================================================
# CONFIGURAÇÕES
# =====================================================

BASE_DIR = Path(__file__).resolve().parent
BACKEND_DIR = BASE_DIR.parent

TEMPLATES_DIR = BASE_DIR / "templates"

load_dotenv(dotenv_path=BACKEND_DIR / ".env")

SUPABASE_URL = os.environ["SUPABASE_URL"]
SUPABASE_KEY = os.environ["SUPABASE_KEY"]
SERVICE_KEY = os.environ["SUPABASE_SERVICE_ROLE_KEY"]

BACKEND_URL = os.getenv(
    "BACKEND_URL",
    "http://127.0.0.1:8000"
).rstrip("/")

FLOW_EXPIRATION_MINUTES = 10
TOTAL_LEVELS = int(os.getenv("TOTAL_LEVELS", "3"))

# =====================================================
# CLIENTES SUPABASE
# =====================================================

# Cliente público: validação da identidade.
auth_client: Client = create_client(
    SUPABASE_URL,
    SUPABASE_KEY
)

# Cliente administrativo: operações no banco.
admin_client: Client = create_client(
    SUPABASE_URL,
    SERVICE_KEY
)


# =====================================================
# FASTAPI
# =====================================================

app = FastAPI(
    title="Move Quest Backend API",
    description="Autenticação Google com Supabase",
    version="1.0.0"
)

# Protótipo local.
# Em produção, utilizar Redis ou banco compartilhado.
login_flows = {}


# =====================================================
# MODELOS
# =====================================================

class CompleteLogin(BaseModel):
    flow_id: str
    access_token: str


class CompleteLevel(BaseModel):
    player_id: UUID
    level: int = Field(ge=1)


# =====================================================
# FUNÇÕES AUXILIARES
# =====================================================

def get_valid_flow(flow_id: str):

    flow = login_flows.get(flow_id)

    if not flow:
        raise HTTPException(
            404,
            "Tentativa de login não encontrada."
        )

    if datetime.now(timezone.utc) > flow["expires_at"]:

        login_flows.pop(flow_id, None)

        raise HTTPException(
            410,
            "Login expirado."
        )

    return flow


def read_html_file(filename: str) -> str:
    """
    Lê um arquivo HTML localizado na pasta templates.
    """

    html_path = TEMPLATES_DIR / filename

    if not html_path.exists():

        raise HTTPException(
            500,
            f"Arquivo {filename} não encontrado."
        )

    return html_path.read_text(encoding="utf-8")


# =====================================================
# PÁGINA INICIAL
# =====================================================

@app.get("/", response_class=HTMLResponse)
def home():

    html = read_html_file("home.html")

    return HTMLResponse(
        content=html
    )


# =====================================================
# INICIAR LOGIN
# =====================================================

@app.get("/auth/start")
def start_login():

    flow_id = str(uuid.uuid4())

    login_flows[flow_id] = {
        "status": "pending",
        "player": None,
        "expires_at": (
            datetime.now(timezone.utc)
            + timedelta(minutes=FLOW_EXPIRATION_MINUTES)
        )
    }

    return {
        "flow_id": flow_id,
        "login_url": f"{BACKEND_URL}/auth/login/{flow_id}"
    }


# =====================================================
# PÁGINA DE LOGIN GOOGLE
# =====================================================

@app.get(
    "/auth/login/{flow_id}",
    response_class=HTMLResponse
)
def login_page(flow_id: str):

    get_valid_flow(flow_id)

    html = read_html_file("login.html")

    # Serializa os valores para inserção segura no JavaScript.
    replacements = {
        "__SUPABASE_URL__": json.dumps(SUPABASE_URL),
        "__SUPABASE_KEY__": json.dumps(SUPABASE_KEY),
        "__FLOW_ID__": json.dumps(flow_id),
        "__BACKEND_URL__": json.dumps(BACKEND_URL),
        "__CALLBACK__": json.dumps(
            f"{BACKEND_URL}/auth/callback"
        )
    }

    for placeholder, value in replacements.items():

        html = html.replace(
            placeholder,
            value
        )

    return HTMLResponse(
        content=html
    )


# =====================================================
# CALLBACK GOOGLE
# =====================================================

@app.get(
    "/auth/callback",
    response_class=HTMLResponse
)
def auth_callback(flow_id: str):

    get_valid_flow(flow_id)

    # O JavaScript da página realiza a troca do código
    # OAuth pela sessão usando PKCE.
    return login_page(flow_id)


# =====================================================
# CONCLUIR LOGIN
# =====================================================

@app.post("/auth/complete")
def complete_login(data: CompleteLogin):

    flow = get_valid_flow(data.flow_id)

    # Impede reutilização do fluxo.
    if flow["status"] != "pending":

        raise HTTPException(
            400,
            "Este fluxo de login já foi utilizado."
        )

    try:

        # =============================================
        # VALIDAR TOKEN SUPABASE
        # =============================================

        response = auth_client.auth.get_user(
            data.access_token
        )

        user = response.user

        if not user:

            raise HTTPException(
                401,
                "Usuário inválido."
            )

        # =============================================
        # IDENTIFICAR CONTA GOOGLE
        # =============================================

        identities = user.identities or []

        google_identity = next(
            (
                identity
                for identity in identities
                if identity.provider == "google"
            ),
            None
        )

        if not google_identity:

            raise HTTPException(
                400,
                "Conta Google não encontrada."
            )

        identity_data = (
            google_identity.identity_data or {}
        )

        google_id = (
            identity_data.get("sub")
            or google_identity.id
        )

        if not google_id:

            raise HTTPException(
                400,
                "Google ID não encontrado."
            )

        # =============================================
        # DADOS DO JOGADOR
        # =============================================

        metadata = user.user_metadata or {}

        player = {

            "id": str(user.id),

            "google_id": str(google_id),

            "email": user.email,

            "display_name": (
                metadata.get("full_name")
                or metadata.get("name")
                or "Jogador"
            )
        }

        # =============================================
        # CADASTRAR OU ATUALIZAR JOGADOR
        # =============================================

        admin_client.table("players").upsert(
            player,
            on_conflict="id"
        ).execute()

        # =============================================
        # FINALIZAR FLUXO
        # =============================================

        flow["status"] = "success"
        flow["player"] = player

        return {
            "status": "success",
            "message": "Login concluído com sucesso."
        }

    except HTTPException:

        flow["status"] = "error"
        flow["player"] = None

        raise

    except Exception as error:

        print(
            "Erro ao concluir login:",
            str(error)
        )

        flow["status"] = "error"
        flow["player"] = None

        raise HTTPException(
            401,
            "Falha ao validar ou cadastrar jogador."
        )


# =====================================================
# CONSULTAR STATUS DO LOGIN
# =====================================================

@app.get("/auth/status/{flow_id}")
def login_status(flow_id: str):

    flow = get_valid_flow(flow_id)

    return {
        "status": flow["status"],
        "player": flow["player"]
    }


# =====================================================
# PROGRESSO DO JOGADOR (T37 / T38 / T41 / T42)
# =====================================================
#
# Tabelas (ver Backend/sql/progress.sql):
#   player_progress -> last_level por jogador
#   level_progress  -> status de conclusão de cada fase


def next_last_level(current: int, completed_level: int) -> int:
    """
    Fase em que o jogador deve continuar após concluir uma fase.

    Nunca regride (rejogar a fase 1 não volta o jogador da fase 3)
    e nunca passa do total de fases.
    """

    return max(
        current,
        min(completed_level + 1, TOTAL_LEVELS)
    )


def load_progress(player_id: str) -> dict:
    """
    Lê o progresso do jogador.
    Sem registro = início do jogo.
    """

    progress = (
        admin_client.table("player_progress")
        .select("last_level")
        .eq("player_id", player_id)
        .limit(1)
        .execute()
    )

    levels = (
        admin_client.table("level_progress")
        .select("level")
        .eq("player_id", player_id)
        .eq("completed", True)
        .execute()
    )

    last_level = (
        progress.data[0]["last_level"]
        if progress.data
        else 1
    )

    completed_levels = sorted(
        row["level"] for row in (levels.data or [])
    )

    return {
        "player_id": player_id,
        "last_level": last_level,
        "completed_levels": completed_levels,
        "total_levels": TOTAL_LEVELS,
        "all_completed": len(completed_levels) >= TOTAL_LEVELS
    }


def ensure_player_exists(player_id: str):

    result = (
        admin_client.table("players")
        .select("id")
        .eq("id", player_id)
        .limit(1)
        .execute()
    )

    if not result.data:

        raise HTTPException(
            404,
            "Jogador não encontrado."
        )


# =====================================================
# CONSULTAR PROGRESSO
# =====================================================

@app.get("/progress/{player_id}")
def get_progress(player_id: UUID):
    """
    T41 - Recupera a última fase e as fases concluídas.
    """

    player_id = str(player_id)

    ensure_player_exists(player_id)

    try:

        return load_progress(player_id)

    except Exception as error:

        print(
            "Erro ao consultar progresso:",
            str(error)
        )

        raise HTTPException(
            500,
            "Não foi possível consultar o progresso."
        )


# =====================================================
# CONCLUIR FASE
# =====================================================

@app.post("/progress/complete")
def complete_level(data: CompleteLevel):
    """
    T42 - Registra a conclusão de uma fase e salva o progresso.
    """

    if data.level > TOTAL_LEVELS:

        raise HTTPException(
            400,
            f"Fase inválida. O jogo possui {TOTAL_LEVELS} fases."
        )

    player_id = str(data.player_id)

    ensure_player_exists(player_id)

    try:

        now = datetime.now(timezone.utc).isoformat()

        # =============================================
        # T38 - MARCAR FASE COMO CONCLUÍDA
        # =============================================

        # ignore_duplicates mantém a data da primeira conclusão
        # caso o jogador repita a fase.

        admin_client.table("level_progress").upsert(
            {
                "player_id": player_id,
                "level": data.level,
                "completed": True,
                "completed_at": now
            },
            on_conflict="player_id,level",
            ignore_duplicates=True
        ).execute()

        # =============================================
        # T37 - ATUALIZAR ÚLTIMA FASE
        # =============================================

        current = (
            admin_client.table("player_progress")
            .select("last_level")
            .eq("player_id", player_id)
            .limit(1)
            .execute()
        )

        current_level = (
            current.data[0]["last_level"]
            if current.data
            else 1
        )

        admin_client.table("player_progress").upsert(
            {
                "player_id": player_id,
                "last_level": next_last_level(
                    current_level,
                    data.level
                ),
                "updated_at": now
            },
            on_conflict="player_id"
        ).execute()

        return load_progress(player_id)

    except Exception as error:

        print(
            "Erro ao salvar progresso:",
            str(error)
        )

        raise HTTPException(
            500,
            "Não foi possível salvar o progresso."
        )


# =====================================================
# EXECUTAR SERVIDOR
# =====================================================

# Execute pelo terminal:
# uvicorn main:app --reload --host 127.0.0.1 --port 8000
