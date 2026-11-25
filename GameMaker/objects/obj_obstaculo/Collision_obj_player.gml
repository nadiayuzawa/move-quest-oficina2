// T21 - Derrota ao encostar em fantasma ou parede
if (sprite_index == spr_ghost)
{
    terminar_fase("derrota", "Você encostou em um fantasma!");
}
else
{
    terminar_fase("derrota", "Você bateu na parede!");
}
