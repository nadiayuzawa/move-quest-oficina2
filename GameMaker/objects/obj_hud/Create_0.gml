// T28 - HUD / indicador de fase
// global.fase guarda a fase atual. A T26 (avanço de fase) vai aumentar esse valor.
if (!variable_global_exists("fase"))
{
    global.fase = 1;
}

// Uma dica por fase (posição 0 = Fase 1, 1 = Fase 2, 2 = Fase 3)
dicas = [
    "Leve o personagem até a bolinha colorida!",
    "Desvie dos obstáculos no caminho!",
    "Planeje bem antes de apertar Play!"
];

hud_x = 150; // centro do painel à esquerda do tabuleiro