move_speed = 4;

moving = false;

target_x = x;
target_y = y;

scene_left   = 300;
scene_right  = 945;
scene_top    = 80;
scene_bottom = 570;

scene_margin = 32;


// Zoom: tamanho e velocidade acompanham a célula
image_xscale = global.celula / 32;
image_yscale = global.celula / 32;
move_speed   = global.celula / 8;