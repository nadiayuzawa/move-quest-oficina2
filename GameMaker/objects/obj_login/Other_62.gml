
var request_id = async_load[? "id"];
var status_code = async_load[? "http_status"];


// =====================================
// 1. RESPOSTA DO INÍCIO DO LOGIN
// =====================================


if (request_id == request_start) {

    if (status_code >= 200 && status_code < 300) {

        var response = json_parse(
            async_load[? "result"]
        );

        flow_id = response.flow_id;

        // Abre o navegador para login Google
        url_open(response.login_url);

        // Agenda consulta de status
        alarm[0] = 30;

    } else {

        login_state = LoginState.ERROR;
        login_message = "Erro ao iniciar login.";

        show_debug_message(
            "Erro ao iniciar login: " +
            string(status_code)
        );
    }
}

// =====================================
// 2. RESPOSTA DA CONSULTA DE STATUS
// =====================================

if (request_id == request_status) {

    if (status_code >= 200 && status_code < 300) {
		
		var result = async_load[? "result"];

		show_debug_message("HTTP STATUS: " + string(status_code));
		show_debug_message("RESPOSTA DO BACKEND: " + result);

        var response = json_parse(
            async_load[? "result"]
        );

        if (response.status == "success") {

            // Login concluído
            login_state = LoginState.AUTHENTICATED;

            player_name = response.player.display_name;

            // Compartilha os dados com o objeto menu
            global.logged_in = true;
            global.player_name = response.player.display_name;
            global.player_id = response.player.id;
			
			global.flow_id = flow_id;

            login_message = "Login realizado com sucesso!";

            show_debug_message(
                "Jogador autenticado: " + player_name
            );

        }
        else if (response.status == "pending") {

            // Continua aguardando autenticação
            alarm[0] = 30;

        }
        else {

            login_state = LoginState.ERROR;
            login_message = "Falha na autenticacao.";

        }

    } else {

        login_state = LoginState.ERROR;
        login_message = "Erro ao consultar login.";

        show_debug_message(
            "Erro ao consultar status: " +
            string(status_code)
        );
    }
}
