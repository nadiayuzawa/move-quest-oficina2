// ---------- Malha do tabuleiro ----------
// Tamanho de cada célula em pixels. Todo o jogo usa este valor.
global.celula     = 64;
global.grade_x    = 336;  // canto esquerdo da malha
global.grade_y    = 104;  // canto de cima da malha
global.grade_cols = 9;
global.grade_lins = 7;

/// Centro (x) da coluna _c (0 = primeira coluna)
function celula_x(_c)
{
    return global.grade_x + _c * global.celula + global.celula / 2;
}

/// Centro (y) da linha _l (0 = primeira linha)
function celula_y(_l)
{
    return global.grade_y + _l * global.celula + global.celula / 2;
}

/// Posiciona personagem (coluna, linha) e objetivo (coluna, linha)
function posicionar_fase(_pc, _pl, _oc, _ol)
{
    obj_player.x = celula_x(_pc);
    obj_player.y = celula_y(_pl);
    obj_player.target_x = obj_player.x;
    obj_player.target_y = obj_player.y;

    obj_objetivo.x = celula_x(_oc);
    obj_objetivo.y = celula_y(_ol);
}

/// Cria obstáculos a partir de uma lista [coluna, linha, sprite]
function criar_obstaculos(_lista)
{
    for (var i = 0; i < array_length(_lista); i++)
    {
        var ob = instance_create_layer(celula_x(_lista[i][0]), celula_y(_lista[i][1]), "Instances", obj_obstaculo);
        ob.sprite_index = _lista[i][2];
    }
}

// ---------- Fases ----------
// Salas de cada fase, em ordem.
global.salas_fases = [Room1, rm_fase2, rm_fase3];
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