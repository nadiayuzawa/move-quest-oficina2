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
        
        // SOLUÇÃO DA PAREDE INVISÍVEL:
        // Força a colisão física a ficar restrita estritamente dentro da célula atual,
        // impedindo que as paredes compridas invadam e bloqueiem o corredor de passagem!
        ob.mask_index = spr_ghost;
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


// ---------- Sequência de comandos (T15) ----------

/// A sequência só pode ser alterada antes do Play e com a fase em andamento
function sequencia_editavel()
{
    return instance_exists(obj_game) && !obj_game.playing && obj_game.resultado == "";
}

/// Adiciona um comando ("up", "down", "left", "right") ao fim da sequência
function adicionar_comando(_cmd)
{
    if (!sequencia_editavel()) return false;
    if (array_length(obj_game.commands) >= obj_game.max_commands) return false;

    array_push(obj_game.commands, _cmd);
    return true;
}

/// Remove o comando na posição _i (0 = primeiro)
function remover_comando(_i)
{
    if (!sequencia_editavel()) return false;
    if (_i < 0 || _i >= array_length(obj_game.commands)) return false;

    array_delete(obj_game.commands, _i, 1);
    return true;
}

/// Apaga toda a sequência
function limpar_comandos()
{
    if (!sequencia_editavel()) return false;

    obj_game.commands = [];
    return true;
}


// ---------- Vitória e derrota (T20 / T21) ----------

/// Encerra a fase. _resultado = "vitoria" ou "derrota".
/// Mostra a mensagem por alguns segundos e depois avança (vitória)
/// ou reinicia a fase (derrota). Chamadas repetidas são ignoradas.
function terminar_fase(_resultado, _motivo)
{
    if (!instance_exists(obj_game) || obj_game.resultado != "") return;

    obj_game.resultado = _resultado;
    obj_game.mensagem  = _motivo;
    obj_game.playing   = false;
    obj_game.timer_resultado = game_get_speed(gamespeed_fps) * 2;

    if (_resultado == "derrota" && instance_exists(obj_player))
    {
        obj_player.moving = false;
        obj_player.sprite_index = spr_playerDead;
        obj_player.image_index = 0;
    }
}
