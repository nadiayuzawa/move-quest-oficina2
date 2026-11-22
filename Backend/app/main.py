
import os
import uuid
import json
from datetime import datetime, timedelta, timezone

from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from fastapi.responses import HTMLResponse
from pydantic import BaseModel
from supabase import create_client, Client

# =====================================================
# CONFIGURAÇÕES
# =====================================================

load_dotenv()

SUPABASE_URL = os.environ["SUPABASE_URL"]
SUPABASE_KEY = os.environ["SUPABASE_KEY"]
SERVICE_KEY = os.environ["SUPABASE_SERVICE_ROLE_KEY"]

BACKEND_URL = os.getenv(
    "BACKEND_URL",
    "http://127.0.0.1:8000"
).rstrip("/")

FLOW_EXPIRATION_MINUTES = 10

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
    title="Game Authentication API",
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


# =====================================================
# PÁGINA INICIAL
# =====================================================

@app.get("/", response_class=HTMLResponse)
def home():

    return """
    <!DOCTYPE html>
    <html lang="pt-br">

    <head>
        <meta charset="UTF-8">
        <title>Servidor de Login</title>
    </head>

    <body>

        <h1>Servidor de Login Online!</h1>

        <p>Backend funcionando corretamente.</p>

        <a href="/docs">Acessar API</a>

    </body>
    </html>
    """


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

    # Valores seguros para inserir no JavaScript.
    supabase_url_js = json.dumps(SUPABASE_URL)
    supabase_key_js = json.dumps(SUPABASE_KEY)
    flow_id_js = json.dumps(flow_id)
    backend_url_js = json.dumps(BACKEND_URL)

    callback_js = json.dumps(
        f"{BACKEND_URL}/auth/callback"
    )

    html = f"""
    <!DOCTYPE html>

    <html lang="pt-br">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1">

        <title>Login do Jogo</title>

    </head>

    <body>

        <h2>Login com Google</h2>

        <p id="status">
            Conectando sua conta Google...
        </p>

        <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>

        <script>

            const SUPABASE_URL = {supabase_url_js};
            const SUPABASE_KEY = {supabase_key_js};
            const FLOW_ID = {flow_id_js};
            const BACKEND_URL = {backend_url_js};
            const CALLBACK = {callback_js};

            const client = window.supabase.createClient(
                SUPABASE_URL,
                SUPABASE_KEY,
                {{
                    auth: {{
                        flowType: "pkce",
                        detectSessionInUrl: false,
                        persistSession: true
                    }}
                }}
            );

            async function run() {{

                const statusElement =
                    document.getElementById("status");

                const params = new URLSearchParams(
                    location.search
                );

                // Verifica erros retornados pelo OAuth.
                const oauthError = params.get("error_description")
                    || params.get("error");

                if (oauthError) {{
                    throw new Error(oauthError);
                }}

                const code = params.get("code");

                // =====================================
                // TROCAR CÓDIGO PELA SESSÃO
                // =====================================

                if (code) {{

                    const {{ error }} =
                        await client.auth.exchangeCodeForSession(
                            code
                        );

                    if (error) throw error;

                }} else {{

                    // =================================
                    // INICIAR LOGIN GOOGLE
                    // =================================

                    const {{ error }} =
                        await client.auth.signInWithOAuth({{
                            provider: "google",

                            options: {{
                                redirectTo:
                                    CALLBACK +
                                    "?flow_id=" +
                                    encodeURIComponent(FLOW_ID)
                            }}
                        }});

                    if (error) throw error;

                    return;
                }}

                // =====================================
                // RECUPERAR SESSÃO
                // =====================================

                const {{ data, error }} =
                    await client.auth.getSession();

                if (error) throw error;

                if (!data.session) {{
                    throw new Error(
                        "Sessão não encontrada."
                    );
                }}

                // =====================================
                // ENVIAR TOKEN AO BACKEND
                // =====================================

                const response = await fetch(
                    BACKEND_URL + "/auth/complete",
                    {{
                        method: "POST",

                        headers: {{
                            "Content-Type": "application/json"
                        }},

                        body: JSON.stringify({{
                            flow_id: FLOW_ID,

                            access_token:
                                data.session.access_token
                        }})
                    }}
                );

                if (!response.ok) {{

                    const result = await response.json();

                    throw new Error(
                        result.detail ||
                        "Não foi possível concluir o login."
                    );
                }}

                statusElement.innerText =
                    "Login concluído! Você pode voltar ao jogo.";

            }}

            run().catch(error => {{

                console.error(error);

                document.getElementById("status").innerText =
                    "Erro no login: " + error.message;

            }});

        </script>

    </body>

    </html>
    """

    return HTMLResponse(html)


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
# EXECUTAR SERVIDOR
# =====================================================

# Execute pelo terminal:
# uvicorn main:app --reload
