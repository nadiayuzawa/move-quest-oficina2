// T21 - Personagem derrotado: toca a animação uma vez e para
if (sprite_index == spr_playerDead)
{
    if (image_index >= image_number - 1)
    {
        image_speed = 0;
        image_index = image_number - 1;
    }
    exit;
}

if (obj_game.playing && !moving)
{
    if (obj_game.command_index < array_length(obj_game.commands))
    {
        var command = obj_game.commands[obj_game.command_index];
        var passo = global.celula;
        var dx = 0;
        var dy = 0;

        if (command == "right") dx =  1;
        if (command == "left")  dx = -1;
        if (command == "up")    dy = -1;
        if (command == "down")  dy =  1;

        target_x = x + dx * passo;
        target_y = y + dy * passo;

        // T21 - Se o passo sai da malha, anda só até a borda e perde
        saindo = (target_x < celula_x(0) || target_x > celula_x(global.grade_cols - 1)
               || target_y < celula_y(0) || target_y > celula_y(global.grade_lins - 1));

        if (saindo)
        {
            target_x = x + dx * passo / 2;
            target_y = y + dy * passo / 2;
        }

        moving = true;
    }
    else
    {
        // T21 - Acabaram os comandos e o objetivo não foi alcançado
        terminar_fase("derrota", "O personagem não chegou ao objetivo.");
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

        if (saindo)
        {
            terminar_fase("derrota", "O personagem saiu do tabuleiro!");
        }
    }
    else
    {
        var move_direction = point_direction(x, y, target_x, target_y);

        x += lengthdir_x(move_speed, move_direction);
        y += lengthdir_y(move_speed, move_direction);
    }
}
