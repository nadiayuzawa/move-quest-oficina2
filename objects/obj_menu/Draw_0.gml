draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Título
draw_set_color(c_white);
draw_set_font(fnt_titulo);
draw_text(room_width / 2, room_height / 2 - 130, "MOVE QUEST");

draw_set_font(fnt_texto);
draw_text(room_width / 2, room_height / 2 - 50, "Programe o caminho até o objetivo!");

// Botão (fica mais claro com o mouse em cima)
if (hover) draw_set_color(make_color_rgb(110, 180, 255));
else       draw_set_color(make_color_rgb(70, 140, 230));
draw_roundrect(btn_x, btn_y, btn_x + btn_w, btn_y + btn_h, false);

draw_set_color(c_white);
draw_text(btn_x + btn_w / 2, btn_y + btn_h / 2, "JOGAR");

// Volta tudo ao padrão para não afetar outros objetos
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);