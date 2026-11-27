// ---------- Progresso do jogador (T37 / T38 / T41 / T42) ----------
// O progresso fica no banco (via backend). Aqui existe uma cópia local
// para o jogo consultar sem esperar a rede.

// Endereço do backend (o obj_login sobrescreve com o valor dele).
global.backend_url = "http://127.0.0.1:8000";

global.progresso_ultima_fase = 1;      // fase em que o jogador deve continuar
global.progresso_concluidas  = [];     // números das fases já concluídas, ex.: [1, 2]
global.progresso_carregado   = false;  // true depois de ler o progresso do backend


/// Volta o progresso local ao estado inicial (use ao trocar de jogador / logout)
function progresso_resetar()
{
    global.progresso_ultima_fase = 1;
    global.progresso_concluidas  = [];
    global.progresso_carregado   = false;
}

/// T38 - A fase _n já foi concluída?
function progresso_fase_concluida(_n)
{
    for (var i = 0; i < array_length(global.progresso_concluidas); i++)
    {
        if (global.progresso_concluidas[i] == _n) return true;
    }

    return false;
}

/// T41 - Fase em que o jogo deve começar ao apertar JOGAR.
/// Última fase do jogador; se ele já zerou o jogo, recomeça da fase 1.
function progresso_fase_inicial()
{
    var total = array_length(global.salas_fases);

    if (array_length(global.progresso_concluidas) >= total) return 1;

    return clamp(global.progresso_ultima_fase, 1, total);
}

/// Guarda os dados recebidos do backend no estado local
function progresso_aplicar(_dados)
{
    global.progresso_ultima_fase = _dados.last_level;
    global.progresso_concluidas  = _dados.completed_levels;
    global.progresso_carregado   = true;
}

/// Cria o controlador que cuida das requisições (persiste entre as rooms)
function progresso_garantir_controlador()
{
    if (!instance_exists(obj_progresso))
    {
        instance_create_depth(0, 0, 0, obj_progresso);
    }
}

/// T41 - Busca no backend a última fase e as fases concluídas do jogador logado.
/// Chamado pelo obj_login logo após o login.
function progresso_carregar()
{
    if (global.player_id == "") return;

    progresso_garantir_controlador();

    with (obj_progresso)
    {
        tentativas_carregar = 0;
        carregar_progresso();
    }
}

/// T42 - Chamar quando o jogador concluir a fase _n.
/// Atualiza o progresso local na hora e envia ao backend em seguida.
function progresso_salvar_fase(_n)
{
    var total = array_length(global.salas_fases);

    if (!progresso_fase_concluida(_n))
    {
        array_push(global.progresso_concluidas, _n);
    }

    // Mesma regra do backend: continua na fase seguinte, sem regredir
    global.progresso_ultima_fase = max(global.progresso_ultima_fase, min(_n + 1, total));

    if (global.player_id == "") return;

    progresso_garantir_controlador();

    with (obj_progresso)
    {
        enviar_fase(_n);
    }
}
