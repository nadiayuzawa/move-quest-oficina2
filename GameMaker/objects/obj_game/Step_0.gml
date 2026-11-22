
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
