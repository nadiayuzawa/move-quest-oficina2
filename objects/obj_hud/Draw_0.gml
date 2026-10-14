draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);

// Título da fase
draw_set_font(fnt_titulo);
draw_text(hud_x, 100, "FASE " + string(global.fase));

// Dica da fase (quebra a linha sozinha em 240 px de largura)
draw_set_font(fnt_texto);
var i = clamp(global.fase - 1, 0, array_length(dicas) - 1);
draw_text_ext(hud_x, 190, dicas[i], 28, 240);

// Quantidade de comandos na sequência (só lê o obj_game)
if (instance_exists(obj_game))
{
    var total = array_length(obj_game.commands);
    draw_text(hud_x, 320, "Comandos: " + string(total));
}

// Volta tudo ao padrão para não afetar outros objetos
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);