create table if not exists public.people (
  id uuid primary key default gen_random_uuid(),
  name text not null unique check (char_length(name) between 1 and 20),
  created_at timestamptz not null default now()
);

create table if not exists public.meal_entries (
  meal_id text not null check (meal_id in ('0729d','0730b','0730l','0730d','0731b','0731l','0731d','0801b','0801l','0801d','0802b','0802l','0802d')),
  person_id uuid not null references public.people(id) on delete cascade,
  buyer text not null default '施展' check (buyer in ('施展', '刘馨遥')),
  food text not null default '' check (char_length(food) <= 80),
  cents integer not null default 0 check (cents >= 0 and cents <= 1000000),
  settled boolean not null default false,
  updated_at timestamptz not null default now(),
  primary key (meal_id, person_id)
);

create table if not exists public.meal_buyers (
  meal_id text primary key check (meal_id in ('0729d','0730b','0730l','0730d','0731b','0731l','0731d','0801b','0801l','0801d','0802b','0802l','0802d')),
  buyer text not null check (buyer in ('施展', '刘馨遥')),
  updated_at timestamptz not null default now()
);

alter table public.meal_entries add column if not exists buyer text check (buyer in ('施展', '刘馨遥'));
update public.meal_entries as entry
set buyer = coalesce(legacy.buyer, '施展')
from public.meal_buyers as legacy
where entry.meal_id = legacy.meal_id and entry.buyer is null;
update public.meal_entries set buyer = '施展' where buyer is null;
alter table public.meal_entries alter column buyer set default '施展';
alter table public.meal_entries alter column buyer set not null;

alter table public.people enable row level security;
alter table public.meal_entries enable row level security;
alter table public.meal_buyers enable row level security;

drop policy if exists "authenticated people access" on public.people;
drop policy if exists "authenticated entries access" on public.meal_entries;
drop policy if exists "authenticated buyers access" on public.meal_buyers;
drop policy if exists "temporary public people access" on public.people;
drop policy if exists "temporary public entries access" on public.meal_entries;
drop policy if exists "temporary public buyers access" on public.meal_buyers;
create policy "temporary public people access" on public.people for all to anon using (true) with check (true);
create policy "temporary public entries access" on public.meal_entries for all to anon using (true) with check (true);
create policy "temporary public buyers access" on public.meal_buyers for all to anon using (true) with check (true);

insert into public.people (name) values
  ('田皓畅'),('翟铭皓'),('黄业源'),('赵新源'),('刘东奇'),('张思捷'),('郭惠'),('宋怡萱'),('李曼琴'),('丁若涵'),('文庭羿'),('陈墨涵'),('曹馨予'),('韦庆池'),('王慧颖'),('宋张鹏'),('于沛伦'),('时星雨'),('陈智琦'),('王紫怡'),('吴优')
on conflict (name) do nothing;

do $$
begin
  if not exists (select 1 from pg_publication_rel where prpubid = (select oid from pg_publication where pubname = 'supabase_realtime') and prrelid = 'public.people'::regclass) then
    alter publication supabase_realtime add table public.people;
  end if;
  if not exists (select 1 from pg_publication_rel where prpubid = (select oid from pg_publication where pubname = 'supabase_realtime') and prrelid = 'public.meal_entries'::regclass) then
    alter publication supabase_realtime add table public.meal_entries;
  end if;
  if not exists (select 1 from pg_publication_rel where prpubid = (select oid from pg_publication where pubname = 'supabase_realtime') and prrelid = 'public.meal_buyers'::regclass) then
    alter publication supabase_realtime add table public.meal_buyers;
  end if;
end $$;
