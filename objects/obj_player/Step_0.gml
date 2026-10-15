if (obj_game.playing && !moving)
{
    if (obj_game.command_index < array_length(obj_game.commands))
    {
        var command = obj_game.commands[obj_game.command_index];
        var passo = global.celula;

        if (command == "right")
        {
            target_x = x + passo;
            target_y = y;
        }

        if (command == "left")
        {
            target_x = x - passo;
            target_y = y;
        }

        if (command == "up")
        {
            target_x = x;
            target_y = y - passo;
        }

        if (command == "down")
        {
            target_x = x;
            target_y = y + passo;
        }

        // Mantém o personagem dentro da malha (primeira e última célula)
        target_x = clamp(target_x, celula_x(0), celula_x(global.grade_cols - 1));
        target_y = clamp(target_y, celula_y(0), celula_y(global.grade_lins - 1));

        moving = true;
    }
    else
    {
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