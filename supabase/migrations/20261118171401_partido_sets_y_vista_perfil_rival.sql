-- Sets de cada partido (el marcador "6-4 3-6 7-6(5)" se guarda set por set)
create table public.partido_sets (
  id bigint generated always as identity primary key,
  partido_id bigint not null references public.partidos(id) on delete cascade,
  numero_set smallint not null check (numero_set between 1 and 5),
  games_jugador smallint not null check (games_jugador between 0 and 7),
  games_rival smallint not null check (games_rival between 0 and 7),
  tiebreak_puntos smallint check (tiebreak_puntos >= 0),
  gano_jugador boolean generated always as (games_jugador > games_rival) stored,
  unique (partido_id, numero_set),
  check (games_jugador <> games_rival)
);

alter table public.partido_sets enable row level security;

create policy "sets de partidos propios" on public.partido_sets for all to authenticated
  using (exists (select 1 from public.partidos p
                 where p.id = partido_id and p.owner_id = (select auth.uid())))
  with check (exists (select 1 from public.partidos p
                      where p.id = partido_id and p.owner_id = (select auth.uid())));

-- Perfil de scouting por rival (equivale a getRivalProfiles de la app)
create view public.perfil_rival with (security_invoker = true) as
select
  r.id as rival_id,
  r.owner_id,
  r.nombre as rival,
  count(p.id) as total,
  count(p.id) filter (where p.resultado = 'victoria') as victorias,
  count(p.id) filter (where p.resultado = 'derrota') as derrotas,
  round(avg(p.errores_no_forzados))::int as promedio_errores,
  max(p.fecha) as ultimo,
  coalesce(mode() within group (order by ld.nombre), 'Sin datos') as lado_debil,
  coalesce(mode() within group (order by pj.descripcion), 'Sin datos') as patron_rival,
  (select count(*) from public.partido_sets s join public.partidos p2 on p2.id = s.partido_id
    where p2.rival_id = r.id and s.gano_jugador) as sets_ganados,
  (select count(*) from public.partido_sets s join public.partidos p2 on p2.id = s.partido_id
    where p2.rival_id = r.id and not s.gano_jugador) as sets_perdidos,
  (select count(*) from public.partido_sets s join public.partidos p2 on p2.id = s.partido_id
    where p2.rival_id = r.id and s.tiebreak_puntos is not null) as tiebreaks
from public.rivales r
left join public.partidos p on p.rival_id = r.id
left join public.lados_debiles ld on ld.id = p.lado_debil_id
left join public.patrones_juego pj on pj.id = p.patron_rival_id
group by r.id, r.owner_id, r.nombre;
