var bar_x = 310;
var bar_y = 575;
var bar_width = 640;
var bar_height = 76;

var spacing = 42;

var padding = 20;

var start_x = bar_x + padding;
var start_y = bar_y + bar_height / 2;


var max_commands = floor((bar_width - padding * 2) / spacing);


for (var i = 0; i < array_length(commands); i++)
{
   
    if (i >= max_commands)
    {
        break;
    }

    var command = commands[i];
    var sprite = -1;

    if (command == "right")
    {
        sprite = spr_right;
    }
    else if (command == "left")
    {
        sprite = spr_left;
    }
    else if (command == "up")
    {
        sprite = spr_up;
    }
    else if (command == "down")
    {
        sprite = spr_down;
    }

    if (sprite != -1)
    {
        draw_sprite_ext(
            sprite,
            0,
            start_x + i * spacing,
            start_y,
            2,
            2,
            0,
            c_white,
            1
        );
    }
}