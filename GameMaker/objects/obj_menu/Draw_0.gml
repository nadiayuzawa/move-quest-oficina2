
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Título
draw_set_color(c_white);
draw_set_font(fnt_titulo);
draw_text(room_width / 2, room_height / 2 - 130, "MOVE QUEST");

// Descrição
draw_set_font(fnt_texto);
draw_text(room_width / 2, room_height / 2 - 50,
    "Programe o caminho até o objetivo!");

// Botão JOGAR: somente após login
// Botões: somente após login
if (global.logged_in) {

    // NOVO JOGO
    if (novo_hover) {
        draw_set_color(make_color_rgb(110, 180, 255));
    } else {
        draw_set_color(make_color_rgb(70, 140, 230));
    }

    draw_roundrect(
        btn_novo_x, btn_novo_y,
        btn_novo_x + btn_novo_w,
        btn_novo_y + btn_novo_h,
        false
    );

    draw_set_color(c_white);
    draw_set_font(fnt_texto);
    draw_text(
        btn_novo_x + btn_novo_w / 2,
        btn_novo_y + btn_novo_h / 2,
        "NOVO JOGO"
    );

    // CONTINUAR
    if (cont_hover) {
        draw_set_color(make_color_rgb(110, 180, 255));
    } else {
        draw_set_color(make_color_rgb(70, 140, 230));
    }

    draw_roundrect(
        btn_cont_x, btn_cont_y,
        btn_cont_x + btn_cont_w,
        btn_cont_y + btn_cont_h,
        false
    );

    draw_set_color(c_white);
    draw_text(
        btn_cont_x + btn_cont_w / 2,
        btn_cont_y + btn_cont_h / 2,
        "CONTINUAR"
    );

    // SAIR
    if (logout_hover) {
        draw_set_color(make_color_rgb(220, 90, 90));
    } else {
        draw_set_color(make_color_rgb(180, 55, 55));
    }

    draw_roundrect(
        logout_x, logout_y,
        logout_x + logout_w,
        logout_y + logout_h,
        false
    );

    draw_set_color(c_white);
    draw_text(
        logout_x + logout_w / 2,
        logout_y + logout_h / 2,
        "SAIR"
    );
}

// Restaura configurações
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
