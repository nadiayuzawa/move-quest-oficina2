-- =====================================================
-- Move Quest - Estrutura de progresso do jogador
-- T37: armazenamento do progresso do usuário
-- T38: armazenamento do status de conclusão das fases
--
-- Execute no Supabase: SQL Editor -> New query -> Run.
-- O script é idempotente (pode ser executado mais de uma vez).
-- Requer a tabela public.players (criada no login Google).
-- =====================================================


-- -----------------------------------------------------
-- T37 - Progresso geral: uma linha por jogador.
-- last_level = fase em que o jogador deve continuar
-- (a mais avançada que ele já liberou).
-- -----------------------------------------------------
create table if not exists public.player_progress (
    player_id   uuid primary key
                references public.players (id) on delete cascade,
    last_level  integer not null default 1
                check (last_level >= 1),
    updated_at  timestamptz not null default now()
);


-- -----------------------------------------------------
-- T38 - Status de conclusão: uma linha por jogador e fase.
-- A chave composta impede registrar a mesma fase duas vezes.
-- -----------------------------------------------------
create table if not exists public.level_progress (
    player_id     uuid not null
                  references public.players (id) on delete cascade,
    level         integer not null
                  check (level >= 1),
    completed     boolean not null default false,
    completed_at  timestamptz,
    primary key (player_id, level)
);

create index if not exists level_progress_player_idx
    on public.level_progress (player_id);


-- -----------------------------------------------------
-- Segurança: o jogo NUNCA acessa o banco diretamente.
-- Só o backend, com a chave de serviço (que ignora RLS).
-- Sem políticas, anon/authenticated ficam sem acesso.
-- -----------------------------------------------------
alter table public.player_progress enable row level security;
alter table public.level_progress  enable row level security;
