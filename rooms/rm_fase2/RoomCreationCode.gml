// Fase 2 - parede com uma única passagem + fantasmas

// Parede vertical em x = 544, com passagem em y = 192
for (var py = 128; py <= 512; py += 32)
{
    if (py != 224)
    {
        var ob = instance_create_layer(544, py, "Instances", obj_obstaculo);
        ob.sprite_index = spr_paredeY;
    }
}

// Fantasmas
var fantasmas = [[480, 288], [608, 288], [640, 256]];

for (var i = 0; i < array_length(fantasmas); i++)
{
    var fa = instance_create_layer(fantasmas[i][0], fantasmas[i][1], "Instances", obj_obstaculo);
    fa.sprite_index = spr_ghost;
}