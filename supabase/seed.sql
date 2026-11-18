-- Datos de ejemplo de BreakPoint.
-- Salen del código: usuario demo de LoginScreen.js (emilys) y los 24 partidos que
-- matchMapper.js deriva de los posts 1..24 de DummyJSON (REMOTE_PAGE_LIMIT = 24).
-- El usuario se crea sin contraseña: solo es dueño de los datos, no puede iniciar sesión.

insert into auth.users (instance_id, id, aud, role, email, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('00000000-0000-0000-0000-000000000000', '7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'authenticated', 'authenticated',
  'emily.johnson@x.dummyjson.com', now(),
  '{"provider":"email","providers":["email"]}', '{}', now(), now())
on conflict (id) do nothing;

insert into public.perfiles (id, username, first_name, last_name, email)
values ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'emilys', 'Emily', 'Johnson', 'emily.johnson@x.dummyjson.com')
on conflict (id) do update set username = excluded.username,
  first_name = excluded.first_name, last_name = excluded.last_name, email = excluded.email;

insert into public.rivales (owner_id, nombre) values
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Andrés Mejía'),
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Laura Restrepo'),
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Camilo Vélez'),
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Sofía Arango'),
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Julián Ospina'),
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Valeria Cardona'),
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Mateo Zapata'),
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Daniela Ruiz'),
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Sebastián Gil'),
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Paula Henao'),
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Tomás Bedoya'),
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Ana Betancur')
on conflict (owner_id, nombre) do nothing;

insert into public.torneos (owner_id, nombre) values
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Liga Municipal · Cancha 3'),
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Copa Antioquia'),
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Circuito Aburrá'),
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Torneo Interclubes'),
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Nocturno de Envigado'),
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Ranking Departamental'),
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Copa Apertura'),
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Amistoso de entrenamiento'),
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Torneo de Belén'),
  ('7b3c1e2a-0b1d-4e5f-9a6b-000000000001', 'Clasificatorio Regional')
on conflict (owner_id, nombre) do nothing;

with datos (n, rival, torneo, superficie, fecha, resultado, marcador, primer_saque, puntos_saque,
            winners, errores, patron, lado, notas, sets) as (values
  (1, 'Sofía Arango', 'Torneo Interclubes', 'arcilla', date '2026-04-16', 'derrota', '2-6 4-6', 43, 45, 12, 21, 'Sube a la red tras el servicio', 'Volea', 'Cerré bien en la red. Cuando subí después del saque, gané casi todos los puntos.', '[{"numero":1,"jugador":2,"rival":6,"tiebreak":null,"ganoJugador":false},{"numero":2,"jugador":4,"rival":6,"tiebreak":null,"ganoJugador":false}]'::jsonb),
  (2, 'Mateo Zapata', 'Amistoso de entrenamiento', 'arcilla', date '2026-06-03', 'derrota', '4-6 2-6', 45, 46, 16, 31, 'Devolución bloqueada al centro', 'Revés', 'Aguanté bien el peloteo largo, pero perdí varios puntos por querer cerrar antes de tiempo.', '[{"numero":1,"jugador":4,"rival":6,"tiebreak":null,"ganoJugador":false},{"numero":2,"jugador":2,"rival":6,"tiebreak":null,"ganoJugador":false}]'::jsonb),
  (3, 'Tomás Bedoya', 'Liga Municipal · Cancha 3', 'indoor', date '2026-07-19', 'derrota', '6-7(4) 3-6', 46, 48, 9, 12, 'Dejada en punto largo', 'Devolución', 'Mucho viento en contra en el segundo set. Bajé el ritmo y funcionó.', '[{"numero":1,"jugador":6,"rival":7,"tiebreak":4,"ganoJugador":false},{"numero":2,"jugador":3,"rival":6,"tiebreak":null,"ganoJugador":false}]'::jsonb),
  (4, 'Laura Restrepo', 'Nocturno de Envigado', 'indoor', date '2026-02-06', 'derrota', '3-6 6-7(4)', 48, 49, 18, 22, 'Saque abierto + derecha invertida', 'Derecha', 'Cerré bien en la red. Cuando subí después del saque, gané casi todos los puntos.', '[{"numero":1,"jugador":3,"rival":6,"tiebreak":null,"ganoJugador":false},{"numero":2,"jugador":6,"rival":7,"tiebreak":4,"ganoJugador":false}]'::jsonb),
  (5, 'Valeria Cardona', 'Amistoso de entrenamiento', 'cesped', date '2026-03-22', 'derrota', '1-6 3-6', 49, 51, 11, 18, 'Segundo saque siempre al revés', 'Físico', 'La cancha estaba lenta y eso me favoreció. Paciencia y altura fueron la clave.', '[{"numero":1,"jugador":1,"rival":6,"tiebreak":null,"ganoJugador":false},{"numero":2,"jugador":3,"rival":6,"tiebreak":null,"ganoJugador":false}]'::jsonb),
  (6, 'Sebastián Gil', 'Copa Antioquia', 'cesped', date '2026-05-09', 'derrota', '5-7 1-6', 51, 52, 15, 28, 'Revés cruzado profundo y espera', 'Segundo saque', 'Mucho viento en contra en el segundo set. Bajé el ritmo y funcionó.', '[{"numero":1,"jugador":5,"rival":7,"tiebreak":null,"ganoJugador":false},{"numero":2,"jugador":1,"rival":6,"tiebreak":null,"ganoJugador":false}]'::jsonb),
  (7, 'Andrés Mejía', 'Nocturno de Envigado', 'dura', date '2026-06-25', 'derrota', '4-6 5-7', 52, 54, 8, 24, 'Devolución bloqueada al centro', 'Revés', 'Arranqué dormido el primer set. Mejoré cuando empecé a variar alturas y a jugar más profundo.', '[{"numero":1,"jugador":4,"rival":6,"tiebreak":null,"ganoJugador":false},{"numero":2,"jugador":5,"rival":7,"tiebreak":null,"ganoJugador":false}]'::jsonb),
  (8, 'Sofía Arango', 'Torneo de Belén', 'dura', date '2026-01-12', 'derrota', '2-6 4-6', 54, 55, 17, 19, 'Sube a la red tras el servicio', 'Volea', 'La cancha estaba lenta y eso me favoreció. Paciencia y altura fueron la clave.', '[{"numero":1,"jugador":2,"rival":6,"tiebreak":null,"ganoJugador":false},{"numero":2,"jugador":4,"rival":6,"tiebreak":null,"ganoJugador":false}]'::jsonb),
  (9, 'Daniela Ruiz', 'Copa Antioquia', 'arcilla', date '2026-02-28', 'derrota', '3-6 2-6', 55, 57, 5, 15, 'Saque abierto + derecha invertida', 'Revés', 'Empecé nervioso, pero el plan de atacar su revés funcionó desde el tercer game.', '[{"numero":1,"jugador":3,"rival":6,"tiebreak":null,"ganoJugador":false},{"numero":2,"jugador":2,"rival":6,"tiebreak":null,"ganoJugador":false}]'::jsonb),
  (10, 'Tomás Bedoya', 'Ranking Departamental', 'arcilla', date '2026-03-15', 'derrota', '6-7(4) 3-6', 57, 58, 14, 25, 'Dejada en punto largo', 'Devolución', 'Arranqué dormido el primer set. Mejoré cuando empecé a variar alturas y a jugar más profundo.', '[{"numero":1,"jugador":6,"rival":7,"tiebreak":4,"ganoJugador":false},{"numero":2,"jugador":3,"rival":6,"tiebreak":null,"ganoJugador":false}]'::jsonb),
  (11, 'Camilo Vélez', 'Torneo de Belén', 'indoor', date '2026-05-03', 'derrota', '3-6 6-7(4)', 58, 38, 23, 36, 'Saque abierto + derecha invertida', 'Derecha', 'Se me fue el partido en los puntos importantes. Necesito trabajar el saque bajo presión.', '[{"numero":1,"jugador":3,"rival":6,"tiebreak":null,"ganoJugador":false},{"numero":2,"jugador":6,"rival":7,"tiebreak":4,"ganoJugador":false}]'::jsonb),
  (12, 'Valeria Cardona', 'Circuito Aburrá', 'indoor', date '2026-06-18', 'victoria', '6-1 7-5', 76, 59, 22, 15, 'Segundo saque siempre al revés', 'Físico', 'Empecé nervioso, pero el plan de atacar su revés funcionó desde el tercer game.', '[{"numero":1,"jugador":6,"rival":1,"tiebreak":null,"ganoJugador":true},{"numero":2,"jugador":7,"rival":5,"tiebreak":null,"ganoJugador":true}]'::jsonb),
  (13, 'Paula Henao', 'Ranking Departamental', 'cesped', date '2026-01-06', 'victoria', '7-5 6-1', 79, 55, 31, 19, 'Revés cruzado profundo y espera', 'Segundo saque', 'Me costó leer su segundo saque. Adelantarme dos pasos en la devolución cambió el partido.', '[{"numero":1,"jugador":7,"rival":5,"tiebreak":null,"ganoJugador":true},{"numero":2,"jugador":6,"rival":1,"tiebreak":null,"ganoJugador":true}]'::jsonb),
  (14, 'Andrés Mejía', 'Clasificatorio Regional', 'cesped', date '2026-02-21', 'victoria', '6-4 6-2', 58, 76, 24, 13, 'Devolución bloqueada al centro', 'Revés', 'Se me fue el partido en los puntos importantes. Necesito trabajar el saque bajo presión.', '[{"numero":1,"jugador":6,"rival":4,"tiebreak":null,"ganoJugador":true},{"numero":2,"jugador":6,"rival":2,"tiebreak":null,"ganoJugador":true}]'::jsonb),
  (15, 'Julián Ospina', 'Circuito Aburrá', 'dura', date '2026-04-09', 'victoria', '6-2 5-7 6-4', 61, 72, 21, 16, 'Sube a la red tras el servicio', 'Volea', 'Partido físico. Me faltó fondo en el tercer set y ahí se decidió todo.', '[{"numero":1,"jugador":6,"rival":2,"tiebreak":null,"ganoJugador":true},{"numero":2,"jugador":5,"rival":7,"tiebreak":null,"ganoJugador":false},{"numero":3,"jugador":6,"rival":4,"tiebreak":null,"ganoJugador":true}]'::jsonb),
  (16, 'Daniela Ruiz', 'Copa Apertura', 'arcilla', date '2026-05-24', 'victoria', '6-3 4-6 7-6(5)', 65, 67, 15, 11, 'Saque abierto + derecha invertida', 'Derecha', 'Me costó leer su segundo saque. Adelantarme dos pasos en la devolución cambió el partido.', '[{"numero":1,"jugador":6,"rival":3,"tiebreak":null,"ganoJugador":true},{"numero":2,"jugador":4,"rival":6,"tiebreak":null,"ganoJugador":false},{"numero":3,"jugador":7,"rival":6,"tiebreak":5,"ganoJugador":true}]'::jsonb),
  (17, 'Ana Betancur', 'Clasificatorio Regional', 'arcilla', date '2026-07-12', 'victoria', '7-6(5) 2-6 6-3', 68, 62, 23, 20, 'Dejada en punto largo', 'Devolución', 'Buen día de derecha. Cada vez que abrí la cancha con el saque, el punto siguiente fue mío.', '[{"numero":1,"jugador":7,"rival":6,"tiebreak":5,"ganoJugador":true},{"numero":2,"jugador":2,"rival":6,"tiebreak":null,"ganoJugador":false},{"numero":3,"jugador":6,"rival":3,"tiebreak":null,"ganoJugador":true}]'::jsonb),
  (18, 'Camilo Vélez', 'Circuito Aburrá', 'indoor', date '2026-01-27', 'victoria', '7-5 3-6 6-1', 72, 58, 17, 9, 'Revés cruzado profundo y espera', 'Segundo saque', 'Partido físico. Me faltó fondo en el tercer set y ahí se decidió todo.', '[{"numero":1,"jugador":7,"rival":5,"tiebreak":null,"ganoJugador":true},{"numero":2,"jugador":3,"rival":6,"tiebreak":null,"ganoJugador":false},{"numero":3,"jugador":6,"rival":1,"tiebreak":null,"ganoJugador":true}]'::jsonb),
  (19, 'Mateo Zapata', 'Copa Apertura', 'indoor', date '2026-03-15', 'victoria', '6-1 6-7(4) 7-5', 75, 79, 25, 18, 'Segundo saque siempre al revés', 'Físico', 'Aguanté bien el peloteo largo, pero perdí varios puntos por querer cerrar antes de tiempo.', '[{"numero":1,"jugador":6,"rival":1,"tiebreak":null,"ganoJugador":true},{"numero":2,"jugador":6,"rival":7,"tiebreak":4,"ganoJugador":false},{"numero":3,"jugador":7,"rival":5,"tiebreak":null,"ganoJugador":true}]'::jsonb),
  (20, 'Paula Henao', 'Clasificatorio Regional', 'cesped', date '2026-04-02', 'victoria', '6-2 3-6 6-4', 78, 75, 19, 7, 'Sube a la red tras el servicio', 'Volea', 'Buen día de derecha. Cada vez que abrí la cancha con el saque, el punto siguiente fue mío.', '[{"numero":1,"jugador":6,"rival":2,"tiebreak":null,"ganoJugador":true},{"numero":2,"jugador":3,"rival":6,"tiebreak":null,"ganoJugador":false},{"numero":3,"jugador":6,"rival":4,"tiebreak":null,"ganoJugador":true}]'::jsonb),
  (21, 'Andrés Mejía', 'Torneo Interclubes', 'cesped', date '2026-06-17', 'victoria', '6-4 1-6 6-2', 57, 70, 27, 16, 'Devolución bloqueada al centro', 'Revés', 'Cerré bien en la red. Cuando subí después del saque, gané casi todos los puntos.', '[{"numero":1,"jugador":6,"rival":4,"tiebreak":null,"ganoJugador":true},{"numero":2,"jugador":1,"rival":6,"tiebreak":null,"ganoJugador":false},{"numero":3,"jugador":6,"rival":2,"tiebreak":null,"ganoJugador":true}]'::jsonb),
  (22, 'Julián Ospina', 'Copa Apertura', 'dura', date '2026-07-05', 'victoria', '7-6(5) 5-7 6-3', 60, 66, 10, 5, 'Dejada en punto largo', 'Devolución', 'Aguanté bien el peloteo largo, pero perdí varios puntos por querer cerrar antes de tiempo.', '[{"numero":1,"jugador":7,"rival":6,"tiebreak":5,"ganoJugador":true},{"numero":2,"jugador":5,"rival":7,"tiebreak":null,"ganoJugador":false},{"numero":3,"jugador":6,"rival":3,"tiebreak":null,"ganoJugador":true}]'::jsonb),
  (23, 'Daniela Ruiz', 'Liga Municipal · Cancha 3', 'dura', date '2026-02-20', 'victoria', '6-3 4-6 7-6(5)', 64, 61, 18, 14, 'Saque abierto + derecha invertida', 'Derecha', 'Buen día de derecha. Cada vez que abrí la cancha con el saque, el punto siguiente fue mío.', '[{"numero":1,"jugador":6,"rival":3,"tiebreak":null,"ganoJugador":true},{"numero":2,"jugador":4,"rival":6,"tiebreak":null,"ganoJugador":false},{"numero":3,"jugador":7,"rival":6,"tiebreak":5,"ganoJugador":true}]'::jsonb),
  (24, 'Ana Betancur', 'Torneo Interclubes', 'arcilla', date '2026-03-08', 'victoria', '6-1 2-6 6-3', 67, 57, 12, 9, 'Segundo saque siempre al revés', 'Físico', 'Cerré bien en la red. Cuando subí después del saque, gané casi todos los puntos.', '[{"numero":1,"jugador":6,"rival":1,"tiebreak":null,"ganoJugador":true},{"numero":2,"jugador":2,"rival":6,"tiebreak":null,"ganoJugador":false},{"numero":3,"jugador":6,"rival":3,"tiebreak":null,"ganoJugador":true}]'::jsonb)
),
nuevos as (
  insert into public.partidos (owner_id, rival_id, torneo_id, superficie, fecha, resultado, marcador,
    primer_saque_pct, puntos_ganados_saque, winners, errores_no_forzados,
    patron_rival_id, lado_debil_id, notas)
  select '7b3c1e2a-0b1d-4e5f-9a6b-000000000001', r.id, t.id, d.superficie, d.fecha, d.resultado, d.marcador,
         d.primer_saque, d.puntos_saque, d.winners, d.errores, pj.id, ld.id, d.notas
  from datos d
  join public.rivales r on r.owner_id = '7b3c1e2a-0b1d-4e5f-9a6b-000000000001' and r.nombre = d.rival
  join public.torneos t on t.owner_id = '7b3c1e2a-0b1d-4e5f-9a6b-000000000001' and t.nombre = d.torneo
  left join public.patrones_juego pj on pj.descripcion = d.patron
  left join public.lados_debiles ld on ld.nombre = d.lado
  where not exists (select 1 from public.partidos where owner_id = '7b3c1e2a-0b1d-4e5f-9a6b-000000000001')
  order by d.n
  returning id, marcador, fecha, rival_id, torneo_id
)
insert into public.partido_sets (partido_id, numero_set, games_jugador, games_rival, tiebreak_puntos)
select nv.id, (s->>'numero')::smallint, (s->>'jugador')::smallint, (s->>'rival')::smallint,
       (s->>'tiebreak')::smallint
from nuevos nv
join datos d on d.marcador = nv.marcador and d.fecha = nv.fecha
join public.rivales r on r.id = nv.rival_id and r.nombre = d.rival
join public.torneos t on t.id = nv.torneo_id and t.nombre = d.torneo
cross join lateral jsonb_array_elements(d.sets) s;
