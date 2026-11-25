var editavel = sequencia_editavel();
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// ---------- Comandos da sequência ----------
// T15: com o mouse em cima, o comando fica vermelho (clique remove)
var hover_i = editavel ? comando_em(mx, my) : -1;

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
        var w = sprite_get_width(sprite) * 2;
        var h = sprite_get_height(sprite) * 2;

        // Centraliza a seta na posição dela dentro da barra
        var ix = start_x + i * spacing + (icon_size - w) / 2;
        var iy = start_y - h / 2;

        // Comando em execução fica destacado; os outros normais
        var cor = c_white;
        if (i == hover_i)                       cor = make_color_rgb(255, 110, 110);
        else if (playing && i == command_index) cor = make_color_rgb(255, 230, 90);

        draw_sprite_ext(sprite, 0, ix, iy, 2, 2, 0, cor, 1);
    }
}

// ---------- Botão Limpar (T15) ----------
var sobre_limpar = editavel && point_in_rectangle(mx, my, limpar_x1, limpar_y1, limpar_x2, limpar_y2);
var tem_comandos = array_length(commands) > 0;

draw_set_alpha((editavel && tem_comandos) ? 1 : 0.4);
draw_set_color(sobre_limpar ? make_color_rgb(235, 110, 110) : make_color_rgb(200, 70, 70));
draw_roundrect(limpar_x1, limpar_y1, limpar_x2, limpar_y2, false);

draw_set_color(c_white);
draw_set_font(fnt_texto);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text((limpar_x1 + limpar_x2) / 2, (limpar_y1 + limpar_y2) / 2, "Limpar");
draw_set_alpha(1);

// ---------- Mensagem de vitória / derrota (T20 / T21) ----------
if (resultado != "")
{
    var gw = display_get_gui_width();
    var gh = display_get_gui_height();
    var cx = gw / 2;
    var cy = gh / 2;

    // Escurece a tela
    draw_set_color(c_black);
    draw_set_alpha(0.6);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);

    // Caixa da mensagem
    var vitoria = (resultado == "vitoria");
    draw_set_color(vitoria ? make_color_rgb(40, 120, 60) : make_color_rgb(140, 40, 40));
    draw_roundrect(cx - 300, cy - 110, cx + 300, cy + 110, false);

    draw_set_color(c_white);
    draw_set_font(fnt_titulo);
    draw_text(cx, cy - 40, vitoria ? "VITÓRIA!" : "DERROTA");

    draw_set_font(fnt_texto);
    draw_text(cx, cy + 30, mensagem);
    var rodape = "Tentando de novo...";
    if (vitoria)
    {
        rodape = (global.fase >= array_length(global.salas_fases)) ? "Voltando ao menu..." : "Indo para a próxima fase...";
    }
    draw_text(cx, cy + 70, rodape);
}

// Volta tudo ao padrão para não afetar outros objetos
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
