if (global.logged_in) {

    // Hover do botão JOGAR
    hover = point_in_rectangle(
        mouse_x,
        mouse_y,
        btn_x,
        btn_y,
        btn_x + btn_w,
        btn_y + btn_h
    );

    // Hover do botão SAIR
    logout_hover = point_in_rectangle(
        mouse_x,
        mouse_y,
        logout_x,
        logout_y,
        logout_x + logout_w,
        logout_y + logout_h
    );

    // Clique em JOGAR
    if (
        (hover && mouse_check_button_pressed(mb_left)) ||
        keyboard_check_pressed(vk_enter)
    ) {
        ir_para_fase(1);
    }

    // Clique em SAIR
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

    hover = false;
    logout_hover = false;

}