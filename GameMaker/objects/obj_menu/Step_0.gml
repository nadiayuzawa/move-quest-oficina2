
if (global.logged_in) {

    hover = point_in_rectangle(
        mouse_x,
        mouse_y,
        btn_x,
        btn_y,
        btn_x + btn_w,
        btn_y + btn_h
    );

    if (
        (hover && mouse_check_button_pressed(mb_left)) ||
        keyboard_check_pressed(vk_enter)
    ) {
        // T41 - Continua da última fase do jogador (fase 1 se for novo)
        ir_para_fase(progresso_fase_inicial());
    }

} else {
    hover = false;
}
