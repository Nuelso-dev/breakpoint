-- ===== Catálogos (src/constants/tennis.js) =====
create table public.superficies (
  codigo text primary key,
  nombre text not null
);
insert into public.superficies (codigo, nombre) values
  ('arcilla','Arcilla'),('dura','Dura'),('cesped','Césped'),('indoor','Indoor');

create table public.patrones_juego (
  id smallint generated always as identity primary key,
  descripcion text not null unique
);
insert into public.patrones_juego (descripcion) values
  ('Saque abierto + derecha invertida'),
  ('Revés cruzado profundo y espera'),
  ('Sube a la red tras el servicio'),
  ('Dejada en punto largo'),
  ('Segundo saque siempre al revés'),
  ('Devolución bloqueada al centro');

create table public.lados_debiles (
  id smallint generated always as identity primary key,
  nombre text not null unique
);
insert into public.lados_debiles (nombre) values
  ('Revés'),('Derecha'),('Segundo saque'),('Volea'),('Devolución'),('Físico');

-- ===== Usuario (AuthContext / authService) =====
create table public.perfiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique,
  first_name text not null default '',
  last_name text not null default '',
  email text,
  image_url text,
  created_at timestamptz not null default now()
);

-- ===== Rivales y torneos (antes texto libre en matches) =====
create table public.rivales (
  id bigint generated always as identity primary key,
  owner_id uuid not null references public.perfiles(id) on delete cascade,
  nombre text not null,
  created_at timestamptz not null default now(),
  unique (owner_id, nombre)
);

create table public.torneos (
  id bigint generated always as identity primary key,
  owner_id uuid not null references public.perfiles(id) on delete cascade,
  nombre text not null,
  created_at timestamptz not null default now(),
  unique (owner_id, nombre)
);

-- ===== Partidos (tabla matches de SQLite) =====
create table public.partidos (
  id bigint generated always as identity primary key,
  owner_id uuid not null references public.perfiles(id) on delete cascade,
  rival_id bigint not null references public.rivales(id) on delete restrict,
  torneo_id bigint not null references public.torneos(id) on delete restrict,
  superficie text not null references public.superficies(codigo),
  fecha date not null,
  resultado text not null check (resultado in ('victoria','derrota')),
  marcador text not null default '',
  primer_saque_pct smallint not null default 0 check (primer_saque_pct between 0 and 100),
  puntos_ganados_saque smallint not null default 0 check (puntos_ganados_saque between 0 and 100),
  winners integer not null default 0 check (winners >= 0),
  errores_no_forzados integer not null default 0 check (errores_no_forzados >= 0),
  patron_rival_id smallint references public.patrones_juego(id),
  lado_debil_id smallint references public.lados_debiles(id),
  notas text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index idx_partidos_owner_fecha on public.partidos (owner_id, fecha desc);
create index idx_partidos_rival on public.partidos (rival_id);
create index idx_partidos_torneo on public.partidos (torneo_id);
create index idx_partidos_patron on public.partidos (patron_rival_id);
create index idx_partidos_lado on public.partidos (lado_debil_id);
create index idx_partidos_superficie on public.partidos (superficie);
create index idx_rivales_owner on public.rivales (owner_id);
create index idx_torneos_owner on public.torneos (owner_id);

-- updated_at automático
create or replace function public.set_updated_at()
returns trigger language plpgsql set search_path = '' as $$
begin
  new.updated_at := now();
  return new;
end $$;
create trigger trg_partidos_updated_at before update on public.partidos
  for each row execute function public.set_updated_at();

-- Perfil automático al registrarse
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  insert into public.perfiles (id, email) values (new.id, new.email)
  on conflict (id) do nothing;
  return new;
end $$;
create trigger on_auth_user_created after insert on auth.users
  for each row execute function public.handle_new_user();

-- ===== Seguridad (RLS): cada jugador ve solo lo suyo =====
alter table public.superficies enable row level security;
alter table public.patrones_juego enable row level security;
alter table public.lados_debiles enable row level security;
alter table public.perfiles enable row level security;
alter table public.rivales enable row level security;
alter table public.torneos enable row level security;
alter table public.partidos enable row level security;

create policy "catalogo lectura" on public.superficies for select to authenticated using (true);
create policy "catalogo lectura" on public.patrones_juego for select to authenticated using (true);
create policy "catalogo lectura" on public.lados_debiles for select to authenticated using (true);

create policy "perfil propio" on public.perfiles for all to authenticated
  using ((select auth.uid()) = id) with check ((select auth.uid()) = id);
create policy "rivales propios" on public.rivales for all to authenticated
  using ((select auth.uid()) = owner_id) with check ((select auth.uid()) = owner_id);
create policy "torneos propios" on public.torneos for all to authenticated
  using ((select auth.uid()) = owner_id) with check ((select auth.uid()) = owner_id);
create policy "partidos propios" on public.partidos for all to authenticated
  using ((select auth.uid()) = owner_id) with check ((select auth.uid()) = owner_id);
