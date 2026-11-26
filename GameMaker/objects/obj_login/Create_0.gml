
enum LoginState {
    IDLE,
    WAITING_BROWSER,
    AUTHENTICATED,
    ERROR
}

login_state = LoginState.IDLE;

backend_url = "http://127.0.0.1:8000";

// Compartilha o endereço com o restante do jogo (scr_progresso)
global.backend_url = backend_url;

flow_id = "";
login_token = "";
player_name = "";

request_start = -1;
request_status = -1;

login_message = "Entre com sua conta Google";


// Variáveis compartilhadas com obj_menu
if (!variable_global_exists("logged_in")) {
    global.logged_in = false;
}

if (!variable_global_exists("player_name")) {
    global.player_name = "";
}

if (!variable_global_exists("player_id")) {
    global.player_id = "";
}


// Controle de conclusão de todas as fases
if (!variable_global_exists("todas_fases_concluidas")) {
    global.todas_fases_concluidas = false;
}
