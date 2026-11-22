
var cx = display_get_gui_width() / 2;
var cy = display_get_gui_height() / 2;

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Dimensões do botão
var button_width = 260;
var button_height = 55;

var x1 = cx - button_width / 2;
var y1 = cy - button_height / 2;
var x2 = cx + button_width / 2;
var y2 = cy + button_height / 2;


// Verifica se todas as fases foram concluídas
if (!global.todas_fases_concluidas) {

    // LOGIN NÃO INICIADO
    if (login_state == LoginState.IDLE) {

        draw_set_color(c_blue);
        draw_rectangle(x1, y1, x2, y2, false);

        draw_set_color(c_white);
        draw_text(cx, cy, "Entrar com Google");

    }

    // LOGIN COM ERRO
    else if (login_state == LoginState.ERROR) {

        draw_set_color(c_blue);
        draw_rectangle(x1, y1, x2, y2, false);

        draw_set_color(c_white);
        draw_text(cx, cy, "Tentar novamente");

        draw_set_color(c_red);
        draw_text(cx, cy + 65, login_message);

    }

    // AGUARDANDO LOGIN
    else if (login_state == LoginState.WAITING_BROWSER) {

        draw_set_color(c_white);
        draw_text(cx, cy, "Aguardando login...");

        draw_text(cx, cy + 40, "Finalize no navegador.");

    }

    // LOGIN CONCLUÍDO
    else if (login_state == LoginState.AUTHENTICATED) {

        draw_set_color(c_lime);
        draw_text(cx, cy - 5, "Login realizado!");

        draw_set_color(c_white);
        draw_text(cx, cy + 35, "Bem-vindo, " + player_name);

    }
}


// Restaura configurações de desenho
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
