// Controlador de progresso (persistente): faz as requisições ao backend e
// recebe as respostas, mesmo trocando de room.
// Criado por progresso_garantir_controlador() (scr_progresso).

req_carregar = -1;               // id da requisição de leitura em andamento
req_reset = -1;					 // id da requisição de reset
req_salvar = ds_map_create();    // id da requisição de gravação -> fase enviada
pendentes = [];                  // fases que falharam e serão reenviadas

max_tentativas = 5;
intervalo_retry = game_get_speed(gamespeed_fps) * 3;   // 3 segundos
tentativas_carregar = 0;
tentativas_salvar = 0;


/// GET /progress/{player_id}
carregar_progresso = function()
{
    req_carregar = http_get(global.backend_url + "/progress/" + global.player_id);

    if (req_carregar < 0) falha_carregar();
};

/// POST /progress/complete
enviar_fase = function(_fase)
{
    var headers = ds_map_create();
    ds_map_add(headers, "Content-Type", "application/json");

    var corpo = json_stringify({
        player_id: global.player_id,
        level: _fase
    });

    var id_req = http_request(global.backend_url + "/progress/complete", "POST", headers, corpo);
    ds_map_destroy(headers);

    if (id_req >= 0) req_salvar[? id_req] = _fase;
    else falha_salvar(_fase);
};

/// POST /progress/reset/{player_id}
resetar_progresso = function()
{
    var headers = ds_map_create();
    ds_map_add(headers, "Content-Type", "application/json");

    req_reset = http_request(
        global.backend_url + "/progress/reset/" + global.player_id,
        "POST",
        headers,
        ""
    );

    ds_map_destroy(headers);

    if (req_reset < 0)
	{
	    req_reset = -1;

	    show_debug_message("Progresso: não foi possível solicitar o reset.");

	    if (instance_exists(obj_menu))
	    {
	        with (obj_menu) {
	            novo_pendente = false;
	        }
	    }
	}
};

falha_carregar = function()
{
    if (tentativas_carregar < max_tentativas)
    {
        tentativas_carregar++;
        alarm[1] = intervalo_retry;
    }
    else
    {
        global.progresso_falhou = true;

        show_debug_message("Progresso: não foi possível carregar do backend.");
    }
};

falha_salvar = function(_fase)
{
    if (tentativas_salvar < max_tentativas)
    {
        tentativas_salvar++;
        array_push(pendentes, _fase);
        alarm[0] = intervalo_retry;
    }
    else
    {
        show_debug_message("Progresso: não foi possível salvar a fase " + string(_fase) + ".");
    }
};
