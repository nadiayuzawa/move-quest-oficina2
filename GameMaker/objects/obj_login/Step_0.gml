
var cx = display_get_gui_width() / 2;
var cy = display_get_gui_height() / 2;

var button_width = 260;
var button_height = 55;

var x1 = cx - button_width / 2;
var y1 = cy - button_height / 2;
var x2 = cx + button_width / 2;
var y2 = cy + button_height / 2;

// Posição do mouse na interface
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Verifica o clique no botão
if (mouse_check_button_pressed(mb_left)) {

    if (point_in_rectangle(mx, my, x1, y1, x2, y2)) {

        if (login_state == LoginState.IDLE ||
            login_state == LoginState.ERROR) {

            login_state = LoginState.WAITING_BROWSER;
            login_message = "Iniciando login...";

            flow_id = "";

            request_start = http_get(
                backend_url + "/auth/start"
            );

            show_debug_message("CLIQUE NO LOGIN DETECTADO");

            if (request_start < 0) {
                login_state = LoginState.ERROR;
                login_message = "Erro ao iniciar login.";
            }
        }
    }
}
