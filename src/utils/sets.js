// Convierte el marcador de texto ("6-4 3-6 7-6(5)") en sets individuales.
// Es la misma estructura que la tabla partido_sets de Supabase:
// un registro por set con los games del jugador, los del rival y el tiebreak.
const SET_RE = /^(\d{1,2})-(\d{1,2})(?:\((\d{1,2})\))?$/;

export function parseMarcador(marcador) {
  const partes = String(marcador ?? '').trim().split(/\s+/).filter(Boolean);
  const sets = [];

  partes.forEach((parte) => {
    const m = SET_RE.exec(parte);
    if (!m) return;
    const jugador = Number(m[1]);
    const rival = Number(m[2]);
    sets.push({
      numero: sets.length + 1,
      jugador,
      rival,
      tiebreak: m[3] !== undefined ? Number(m[3]) : null,
      ganoJugador: jugador > rival,
    });
  });

  return sets;
}

// Resumen de sets para un conjunto de partidos (o de marcadores sueltos).
export function summarizeSets(items = []) {
  const resumen = {
    partidos: 0,
    setsGanados: 0,
    setsPerdidos: 0,
    tiebreaksJugados: 0,
    tiebreaksGanados: 0,
    primerSetGanado: 0,
    primerSetGanadoYPartido: 0,
    remontadas: 0,
  };

  items.forEach((item) => {
    const marcador = typeof item === 'string' ? item : item?.marcador;
    const sets = parseMarcador(marcador);
    if (sets.length === 0) return;

    resumen.partidos += 1;
    const ganados = sets.filter((s) => s.ganoJugador).length;
    const perdidos = sets.length - ganados;
    const ganoPartido = ganados > perdidos;

    resumen.setsGanados += ganados;
    resumen.setsPerdidos += perdidos;

    sets.forEach((s) => {
      // Un set 7-6 o 6-7 se definió en tiebreak.
      const esTiebreak = s.tiebreak !== null || Math.min(s.jugador, s.rival) === 6;
      if (esTiebreak) {
        resumen.tiebreaksJugados += 1;
        if (s.ganoJugador) resumen.tiebreaksGanados += 1;
      }
    });

    if (sets[0].ganoJugador) {
      resumen.primerSetGanado += 1;
      if (ganoPartido) resumen.primerSetGanadoYPartido += 1;
    } else if (ganoPartido) {
      resumen.remontadas += 1;
    }
  });

  return resumen;
}
