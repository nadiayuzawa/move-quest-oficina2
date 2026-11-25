
// ---------- ATALHO DE DESENVOLVEDOR (Teste) ----------
// Pressionar a tecla N avança instantaneamente para a próxima fase!
if (keyboard_check_pressed(ord("N")))
{
    // Limpa a fila de comandos
    commands = [];
    command_index = 0;
    playing = false;

    // Avança para a próxima fase
    avancar_fase();
}


// ---------- VERIFICA CONCLUSÃO DAS FASES ----------
if (global.fase >= global.total_fases)
{
    global.todas_fases_concluidas = true;
}


// ---------- T15 - Remover e limpar a sequência ----------
// Clique em um comando da barra remove ele; botão Limpar apaga tudo.
// Teclado: Backspace remove o último, Delete limpa tudo.
if (mouse_check_button_pressed(mb_left))
{
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    if (point_in_rectangle(mx, my, limpar_x1, limpar_y1, limpar_x2, limpar_y2))
    {
        limpar_comandos();
    }
    else
    {
        remover_comando(comando_em(mx, my));
    }
}

if (keyboard_check_pressed(vk_backspace)) remover_comando(array_length(commands) - 1);
if (keyboard_check_pressed(vk_delete))    limpar_comandos();


// ---------- T20/T21 - Fim da fase ----------
// Espera a mensagem ficar na tela e então avança ou reinicia.
if (resultado != "")
{
    timer_resultado--;

    if (timer_resultado <= 0)
    {
        if (resultado == "vitoria") avancar_fase();
        else                        room_restart();
    }
}
