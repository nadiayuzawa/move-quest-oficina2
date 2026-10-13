if (obj_game.playing && !moving)
{
    if (obj_game.command_index < array_length(obj_game.commands))
    {
        var command = obj_game.commands[obj_game.command_index];

        if (command == "right")
        {
            target_x = x + 32;
            target_y = y;
        }
        
        if (command == "left")
        {
            target_x = x - 32;
            target_y = y;
        }
        
        if (command == "up")
        {
            target_x = x;
            target_y = y - 32;
        }
        
        if (command == "down")
        {
            target_x = x;
            target_y = y + 32;
        }
		
		var half_w = sprite_width / 2;
		var half_h = sprite_height / 2;

		target_x = clamp(
		    target_x,
		    scene_left + scene_margin + half_w,
		    scene_right - scene_margin - half_w
		);

		target_y = clamp(
		    target_y,
		    scene_top + scene_margin + half_h,
		    scene_bottom - scene_margin - half_h
		);

        moving = true;
    }else{
		obj_game.playing = false;
	    obj_game.commands = [];
	    obj_game.command_index = 0;
	}
}

if (moving)
{
    var distance = point_distance(x, y, target_x, target_y);

    if (distance <= move_speed)
    {
        x = target_x;
        y = target_y;

        moving = false;

        obj_game.command_index++;
    }
    else
    {
        var move_direction = point_direction(x, y, target_x, target_y);

        x += lengthdir_x(move_speed, move_direction);
        y += lengthdir_y(move_speed, move_direction);
    }
}