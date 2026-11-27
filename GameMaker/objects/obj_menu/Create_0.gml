btn_w = 260;
btn_h = 70;
btn_x = room_width / 2 - btn_w / 2;
btn_y = room_height / 2 + 40;

hover = false;

// Botão SAIR
logout_w = 260;
logout_h = 70;
logout_x = room_width / 2 - logout_w / 2;
logout_y = btn_y + btn_h + 20;

logout_hover = false;

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