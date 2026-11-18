import React from 'react';
import { View, Text } from 'react-native';
import StatBar from './StatBar';
import { useAppTheme } from '../hooks/useAppTheme';
import { percent } from '../utils/format';

// Indicadores por set calculados con summarizeSets (utils/sets.js).
export default function SetsSummary({ resumen }) {
  const { palette } = useAppTheme();
  const totalSets = resumen ? resumen.setsGanados + resumen.setsPerdidos : 0;

  if (!resumen || resumen.partidos === 0 || totalSets === 0) {
    return (
      <Text className="text-[13px]" style={{ color: palette.textMuted }}>
        Registra el marcador de tus partidos para ver el análisis por sets.
      </Text>
    );
  }

  return (
    <View>
      <StatBar
        label={`Sets ganados · ${resumen.setsGanados}/${totalSets}`}
        value={percent(resumen.setsGanados, totalSets)}
        tone="ok"
      />
      <StatBar
        label={`Tiebreaks ganados · ${resumen.tiebreaksGanados}/${resumen.tiebreaksJugados}`}
        value={percent(resumen.tiebreaksGanados, resumen.tiebreaksJugados)}
        tone="accent"
      />
      <StatBar
        label={`Ganas el partido cuando ganas el 1er set · ${resumen.primerSetGanadoYPartido}/${resumen.primerSetGanado}`}
        value={percent(resumen.primerSetGanadoYPartido, resumen.primerSetGanado)}
      />
      <Text className="mt-1 text-[12.5px] leading-5" style={{ color: palette.textMuted }}>
        Remontadas (perdiste el 1er set y ganaste):{' '}
        <Text style={{ color: palette.text, fontWeight: '700' }}>{resumen.remontadas}</Text>
      </Text>
    </View>
  );
}
