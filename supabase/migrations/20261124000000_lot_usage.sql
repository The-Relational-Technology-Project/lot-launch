-- A daily call counter for the lot-plan function that survives restarts.
-- Only the function touches it (service role).
create table if not exists public.lot_usage (
  day date primary key,
  count integer not null default 0
);
alter table public.lot_usage enable row level security;

create or replace function public.lot_usage_bump()
returns integer
language sql
security definer
set search_path = public
as $$
  insert into public.lot_usage (day, count) values (current_date, 1)
  on conflict (day) do update set count = lot_usage.count + 1
  returning count;
$$;
revoke execute on function public.lot_usage_bump() from public, anon, authenticated;
grant execute on function public.lot_usage_bump() to service_role;
