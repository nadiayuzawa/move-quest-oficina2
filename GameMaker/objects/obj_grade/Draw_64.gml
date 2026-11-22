draw_set_color(c_white);

// Linhas internas, bem suaves
draw_set_alpha(0.2);

for (var i = 0; i <= grid_cols; i++)
{
    var lx = grid_left + i * cell_size;
    draw_line(lx, grid_top, lx, grid_bottom);
}

for (var j = 0; j <= grid_rows; j++)
{
    var ly = grid_top + j * cell_size;
    draw_line(grid_left, ly, grid_right, ly);
}

// Contorno da área jogável, mais forte
draw_set_alpha(0.6);
draw_rectangle(grid_left, grid_top, grid_right, grid_bottom, true);

// Volta ao padrão para não afetar outros objetos
draw_set_alpha(1);
draw_set_color(c_white);