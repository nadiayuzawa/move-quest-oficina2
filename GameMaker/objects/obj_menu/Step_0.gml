
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
    // NOVO JOGO: reseta o progresso antes de iniciar
	// NOVO JOGO: reseta o progresso antes de iniciar
	if (novo_hover && mouse_check_button_pressed(mb_left))
	{
	    if (!novo_pendente)
	    {
	        progresso_garantir_controlador();

	        with (obj_progresso)
	        {
	            resetar_progresso();
	        }

	        novo_pendente = true;
	    }
	}

    // CONTINUAR: aguarda o carregamento do progresso
	if (
	    cont_hover &&
	    mouse_check_button_pressed(mb_left) &&
	    !continuar_pendente
	)
	{
	    continuar_pendente = true;
	}

// Verifica se o progresso foi carregado
	if (continuar_pendente)
	{
	    if (global.progresso_carregado)
	    {
	        continuar_pendente = false;
	        ir_para_fase(progresso_fase_inicial());
	    }
	    else if (global.progresso_falhou)
	    {
	        continuar_pendente = false;

	        show_message(
	            "Não foi possível carregar seu progresso. Verifique sua conexão e tente novamente."
	        );
	    }
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
