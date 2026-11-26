// Reenvia as fases que falharam ao salvar
var lista = pendentes;
pendentes = [];

for (var i = 0; i < array_length(lista); i++)
{
    enviar_fase(lista[i]);
}
