// T23 - Malha visível do tabuleiro
// Alinhada com o passo de 32 px do obj_player (centros em múltiplos de 32)
cell_size = 32;

grid_left = 336;   // borda esquerda da 1ª coluna jogável
grid_top  = 112;   // borda de cima da 1ª linha jogável
grid_cols = 18;
grid_rows = 13;

grid_right  = grid_left + grid_cols * cell_size;  // 912
grid_bottom = grid_top  + grid_rows * cell_size;  // 528

// Desenha acima do chão (profundidade 100) e abaixo do player e dos botões (0)
depth = 50;