// Fase 2 - parede com uma única passagem + fantasmas (10 comandos)
posicionar_fase(1, 3, 7, 3);

criar_obstaculos([
    [4, 0, spr_paredeY],
    [4, 2, spr_paredeY], [4, 3, spr_paredeY], [4, 4, spr_paredeY],
    [4, 5, spr_paredeY], [4, 6, spr_paredeY],
    [2, 2, spr_ghost], [6, 2, spr_ghost], [5, 4, spr_ghost]
]);