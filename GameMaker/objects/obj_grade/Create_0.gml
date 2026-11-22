// T23 - Malha visível do tabuleiro (valores vêm do scr_fases)
cell_size = global.celula;

grid_left = global.grade_x;
grid_top  = global.grade_y;
grid_cols = global.grade_cols;
grid_rows = global.grade_lins;

grid_right  = grid_left + grid_cols * cell_size;
grid_bottom = grid_top  + grid_rows * cell_size;

depth = 50;