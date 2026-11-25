commands = [];
command_index = 0;

playing = false;

// T20/T21 - estado da fase: "" (jogando), "vitoria" ou "derrota"
resultado = "";
mensagem = "";
timer_resultado = 0;

// Desenha por cima da malha e do HUD (mensagem de vitória/derrota)
depth = -100;

// ---------- Barra de comandos (usada no Draw GUI e nos cliques) ----------
bar_x = 310;
bar_y = 592;      // painel da barra no tileset: y 592 a 672
bar_width = 640;
bar_height = 80;

spacing = 42;
padding = 20;
icon_size = 36;

start_x = bar_x + padding;
start_y = bar_y + bar_height / 2;

max_commands = floor((bar_width - padding * 2) / spacing);

// ---------- Botão Limpar (T15), à esquerda da barra ----------
limpar_x1 = 170;
limpar_y1 = bar_y + 13;
limpar_x2 = 290;
limpar_y2 = bar_y + bar_height - 13;

/// Índice do comando da barra sob o ponto (_mx, _my) da GUI, ou -1
comando_em = function(_mx, _my)
{
    var total = min(array_length(commands), max_commands);

    for (var i = 0; i < total; i++)
    {
        var ix = start_x + i * spacing;

        if (point_in_rectangle(_mx, _my, ix, start_y - icon_size / 2, ix + icon_size, start_y + icon_size / 2))
        {
            return i;
        }
    }

    return -1;
};

if (!variable_global_exists("total_fases")) {
    global.total_fases = 3; // TROQUE 10 pela quantidade real de fases
}
