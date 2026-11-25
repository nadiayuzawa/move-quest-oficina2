// T20 - Vitória: mostra a mensagem e o obj_game avança de fase depois
var ultima = global.fase >= array_length(global.salas_fases);

terminar_fase("vitoria", ultima ? "Você completou todas as fases!" : "Você chegou ao objetivo!");
instance_destroy();
