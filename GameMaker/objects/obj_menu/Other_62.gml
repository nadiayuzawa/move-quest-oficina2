var request_id = async_load[? "id"];
var status_code = async_load[? "http_status"];

// Verifica se a resposta pertence ao logout
if (request_id == logout_request) {

    logout_pending = false;

    if (status_code >= 200 && status_code < 300) {

        var response = json_parse(
            async_load[? "result"]
        );

        if (response.status == "success") {

            // Limpar dados da sessão
            global.logged_in = false;
            global.player_name = "";
            global.player_id = "";
            global.flow_id = "";

            show_debug_message(
                "Logout realizado com sucesso!"
            );
			
			room_goto(rm_menu);

        }

    } else {

        show_debug_message(
            "Erro ao realizar logout. HTTP: " +
            string(status_code)
        );

    }
}