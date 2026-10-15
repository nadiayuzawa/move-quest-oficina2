// Fase 3 - armadilha em U (x, y, sprite)
var obstaculos = [
    // parede em pé à esquerda
    [480, 224, spr_paredeY], [480, 256, spr_paredeY], [480, 288, spr_paredeY],
    [480, 320, spr_paredeY], [480, 352, spr_paredeY], [480, 384, spr_paredeY],
    // teto do U
    [544, 256, spr_paredeX], [576, 256, spr_paredeX], [608, 256, spr_paredeX],
    [640, 256, spr_paredeX], [672, 256, spr_paredeX],
    // laterais do U
    [544, 288, spr_paredeY], [544, 320, spr_paredeY], [544, 352, spr_paredeY],
    [672, 288, spr_paredeY], [672, 320, spr_paredeY], [672, 352, spr_paredeY],
    // fantasmas
    [576, 320, spr_ghost], [608, 384, spr_ghost],
    [512, 416, spr_ghost], [640, 448, spr_ghost]
];

for (var i = 0; i < array_length(obstaculos); i++)
{
    var ob = instance_create_layer(obstaculos[i][0], obstaculos[i][1], "Instances", obj_obstaculo);
    ob.sprite_index = obstaculos[i][2];
}