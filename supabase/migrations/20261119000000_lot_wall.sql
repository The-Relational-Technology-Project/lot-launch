-- The cohort wall for the Library of Things Launch Plan prototype.
-- Lives in the Relational Tech Project's Supabase project. Only the lot-plan
-- edge function reads or writes it (service role); row level security is on
-- with no policies, so nothing else can.
create table if not exists public.lot_wall (
  id uuid primary key default gen_random_uuid(),
  parent uuid references public.lot_wall (id) on delete cascade,
  team text not null,
  topic text,
  body text not null,
  sample boolean not null default false,
  hidden boolean not null default false,
  created_at timestamptz not null default now()
);
create index if not exists lot_wall_created_idx on public.lot_wall (created_at desc);
alter table public.lot_wall enable row level security;
