// Fase 3 - armadilha em U (10 comandos, solução única)
posicionar_fase(0, 1, 5, 2);

criar_obstaculos([
    // teto do U
    [3, 1, spr_paredeX], [4, 1, spr_paredeX], [5, 1, spr_paredeX],
    [6, 1, spr_paredeX], [7, 1, spr_paredeX],
    // laterais do U
    [3, 2, spr_paredeY], [3, 3, spr_paredeY],
    [7, 2, spr_paredeY], [7, 3, spr_paredeY],
    // parede da esquerda
    [1, 2, spr_paredeY], [1, 3, spr_paredeY], [1, 4, spr_paredeY],
    // fantasmas
    [4, 2, spr_ghost], [5, 4, spr_ghost], [2, 5, spr_ghost], [7, 5, spr_ghost]
]);