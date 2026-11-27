
if (global.logged_in) {

    // Hover NOVO JOGO
    novo_hover = point_in_rectangle(
        mouse_x, mouse_y,
        btn_novo_x, btn_novo_y,
        btn_novo_x + btn_novo_w,
        btn_novo_y + btn_novo_h
    );

    // Hover CONTINUAR
    cont_hover = point_in_rectangle(
        mouse_x, mouse_y,
        btn_cont_x, btn_cont_y,
        btn_cont_x + btn_cont_w,
        btn_cont_y + btn_cont_h
    );

    // Hover SAIR
    logout_hover = point_in_rectangle(
        mouse_x, mouse_y,
        logout_x, logout_y,
        logout_x + logout_w,
        logout_y + logout_h
    );

    // NOVO JOGO: começa na fase 1
    if (novo_hover && mouse_check_button_pressed(mb_left)) {
        ir_para_fase(1);
    }

    // CONTINUAR: recupera a última fase salva
    if (
        (cont_hover && mouse_check_button_pressed(mb_left)) ||
        keyboard_check_pressed(vk_enter)
    ) {
        ir_para_fase(progresso_fase_inicial());
    }

    // SAIR
    if (
        logout_hover &&
        mouse_check_button_pressed(mb_left) &&
        !logout_pending
    ) {

        if (global.flow_id != "") {

            var headers = ds_map_create();
            ds_map_add(headers, "Content-Type", "application/json");

            var body = json_stringify({
                flow_id: global.flow_id
            });

            logout_request = http_request(
                backend_url + "/auth/logout",
                "POST",
                headers,
                body
            );

            ds_map_destroy(headers);

            logout_pending = true;

        } else {
            show_debug_message("Flow ID não encontrado.");
        }
    }

} else {

    novo_hover = false;
    cont_hover = false;
    logout_hover = false;

}
