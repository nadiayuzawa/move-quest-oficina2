commands = [];
commands_index = 0;

playing = false;

if (!variable_global_exists("total_fases")) {
    global.total_fases = 3; // TROQUE 10 pela quantidade real de fases
}