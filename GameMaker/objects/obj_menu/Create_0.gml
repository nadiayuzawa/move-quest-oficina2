// Botão NOVO JOGO
btn_novo_w = 260;
btn_novo_h = 70;
btn_novo_x = room_width / 2 - btn_novo_w - 10;
btn_novo_y = room_height / 2 + 80;
novo_hover = false;

// Botão CONTINUAR
btn_cont_w = 260;
btn_cont_h = 70;
btn_cont_x = room_width / 2 + 10;
btn_cont_y = btn_novo_y;
cont_hover = false;

// Botão SAIR
logout_w = 540;
logout_h = 70;
logout_x = room_width / 2 - logout_w / 2;
logout_y = btn_novo_y + btn_novo_h + 20;

logout_hover = false;

novo_pendente = false;
continuar_pendente = false;

// Estado inicial do login
if (!variable_global_exists("logged_in")) {
    global.logged_in = false;
    global.player_name = "";
    global.player_id = "";
}

// Configuração do logout
backend_url = "http://127.0.0.1:8000";

logout_pending = false;
logout_request = -1;
logout_hover = false;

novo_pendente = false;
continuar_pendente = false;