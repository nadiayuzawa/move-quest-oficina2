if (!click_lock)
{
    with (obj_game)
    {
        array_push(commands, "down");
    }

    click_lock = true;
}