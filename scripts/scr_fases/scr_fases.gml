// T26 - Controle das fases
// Salas de cada fase, em ordem. Ao criar a Fase 2 e a Fase 3, é só adicionar aqui.
global.salas_fases = [Room1];
global.fase = 1;

/// Vai para a fase _n (1 = primeira fase)
function ir_para_fase(_n)
{
    global.fase = _n;
    room_goto(global.salas_fases[_n - 1]);
}

/// Chamar quando o jogador vencer (T20).
/// Vai para a próxima fase ou volta ao menu se era a última.
function avancar_fase()
{
    if (global.fase < array_length(global.salas_fases))
    {
        ir_para_fase(global.fase + 1);
    }
    else
    {
        global.fase = 1;
        room_goto(rm_menu);
    }
}