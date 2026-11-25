// T43 - Este evento ("Left Down") dispara a cada frame enquanto o mouse
// está pressionado. Antes ele zerava command_index no meio do movimento
// e o primeiro comando era executado duas vezes. Agora só inicia se a
// sequência ainda não estiver rodando.
with (obj_game)
{
    if (!playing && resultado == "" && array_length(commands) > 0)
    {
        command_index = 0;
        playing = true;
    }
}
