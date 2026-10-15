var c = global.celula;
var meio = c / 2;

// ---------- Fantasma: sprite encaixado na célula ----------
if (sprite_index == spr_ghost)
{
    var bl = sprite_get_bbox_left(sprite_index);
    var bt = sprite_get_bbox_top(sprite_index);
    var bw = sprite_get_bbox_right(sprite_index) - bl + 1;
    var bh = sprite_get_bbox_bottom(sprite_index) - bt + 1;

    var escala = (c * 0.75) / max(bw, bh);

    var dx = x - (bl + bw / 2 - sprite_get_xoffset(sprite_index)) * escala;
    var dy = y - (bt + bh / 2 - sprite_get_yoffset(sprite_index)) * escala;

    draw_sprite_ext(sprite_index, image_index, dx, dy, escala, escala, 0, c_white, 1);
    exit;
}

// ---------- Parede: linha que se liga às paredes vizinhas ----------
var h = c / 10;                             // metade da espessura da parede
var cor = make_color_rgb(46, 49, 146);      // mesma cor do sprite de parede

var viz_dir = false, viz_esq = false, viz_baixo = false, viz_cima = false;
var mx = x, my = y;

with (obj_obstaculo)
{
    if (sprite_index != spr_ghost)
    {
        if (x == mx + c && y == my) viz_dir   = true;
        if (x == mx - c && y == my) viz_esq   = true;
        if (x == mx && y == my + c) viz_baixo = true;
        if (x == mx && y == my - c) viz_cima  = true;
    }
}

// Parede sozinha: usa a direção do sprite (deitada ou em pé)
if (!viz_dir && !viz_esq && !viz_baixo && !viz_cima)
{
    if (sprite_index == spr_paredeX) { viz_dir = true; viz_esq = true; }
    else { viz_baixo = true; viz_cima = true; }
}

draw_set_color(cor);
draw_circle(x, y, h, false);

if (viz_dir)   draw_line_width(x, y, x + meio, y, h * 2);
if (viz_esq)   draw_line_width(x, y, x - meio, y, h * 2);
if (viz_baixo) draw_line_width(x, y, x, y + meio, h * 2);
if (viz_cima)  draw_line_width(x, y, x, y - meio, h * 2);

// Ponta da parede: estica até a borda da célula e arredonda
if (viz_dir + viz_esq + viz_baixo + viz_cima == 1)
{
    var px = x + (viz_esq - viz_dir) * (meio - h);
    var py = y + (viz_cima - viz_baixo) * (meio - h);
    draw_line_width(x, y, px, py, h * 2);
    draw_circle(px, py, h, false);
}

draw_set_color(c_white);