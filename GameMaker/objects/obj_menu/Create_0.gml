btn_w = 260;
btn_h = 70;
btn_x = room_width / 2 - btn_w / 2;
btn_y = room_height / 2 + 40;

hover = false;

// Estado inicial do login
if (!variable_global_exists("logged_in")) {
    global.logged_in = false;
    global.player_name = "";
    global.player_id = "";
}