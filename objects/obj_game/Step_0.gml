// ---------- ATALHO DE DESENVOLVEDOR (Teste) ----------
// Pressionar a tecla N avança instantaneamente para a próxima fase!
if (keyboard_check_pressed(ord("N")))
{
    // Limpa a fila de comandos para não bugar a próxima tela
    commands = [];
    command_index = 0;
    playing = false;
    
    // Executa a função do script que muda de sala com segurança
    avancar_fase();
}
