// Resposta HTTP do backend

// Download em andamento: espera terminar
if (async_load[? "status"] == 1) exit;

var id_req = async_load[? "id"];
var http = ds_map_exists(async_load, "http_status") ? async_load[? "http_status"] : -1;
var ok = (async_load[? "status"] == 0 && http >= 200 && http < 300);


// ---------- T41 - Leitura do progresso ----------
if (id_req == req_carregar)
{
    req_carregar = -1;

    if (ok)
    {
        progresso_aplicar(json_parse(async_load[? "result"]));
        tentativas_carregar = 0;

        show_debug_message("Progresso carregado. Última fase: " + string(global.progresso_ultima_fase));
    }
    else
    {
        show_debug_message("Erro ao carregar progresso: " + string(http));
        falha_carregar();
    }
}

// ---------- T42 - Gravação da fase concluída ----------
else if (ds_map_exists(req_salvar, id_req))
{
    var fase = req_salvar[? id_req];
    ds_map_delete(req_salvar, id_req);

    if (ok)
    {
        tentativas_salvar = 0;
        show_debug_message("Fase " + string(fase) + " salva no backend.");
    }
    else
    {
        show_debug_message("Erro ao salvar fase " + string(fase) + ": " + string(http));

        // Erro do jogador/da requisição (4xx) não adianta repetir
        if (http >= 400 && http < 500) exit;

        falha_salvar(fase);
    }
}
