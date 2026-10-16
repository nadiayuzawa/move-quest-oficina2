draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);

// ---------- Título da fase ----------
draw_set_font(fnt_titulo);
draw_text(hud_x, 100, "FASE " + string(global.fase));


// ---------- Dica da fase ----------
draw_set_font(fnt_texto);

// Garante que o índice da lista de dicas esteja sempre correto com base na fase atual
var i = clamp(global.fase - 1, 0, array_length(dicas) - 1);
var texto_dica = dicas[i];

// Desenha o texto centralizado com quebra automática de linha a cada 220 pixels
draw_text_ext(hud_x, 190, texto_dica, 26, 220); 


// ---------- Quantidade de comandos na sequência ----------
if (instance_exists(obj_game))
{
    var total = array_length(obj_game.commands);
    draw_text(hud_x, 320, "Comandos: " + string(total));
}


// ---------- Reseta o padrão para não afetar outros objetos ----------
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
