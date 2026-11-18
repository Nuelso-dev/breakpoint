import React from 'react';
import { View, Text } from 'react-native';
import { useAppTheme } from '../hooks/useAppTheme';
import { parseMarcador } from '../utils/sets';

// Tablero estilo transmisión: una columna por set, una fila por jugador.
// El set ganado se resalta y el tiebreak aparece como superíndice.
function Cell({ value, tiebreak, won, color, palette, header }) {
  return (
    <View style={{ width: 44, alignItems: 'center', justifyContent: 'center' }}>
      <Text
        style={{
          color: header ? palette.textMuted : won ? color : palette.textMuted,
          fontWeight: header ? '600' : won ? '900' : '500',
          fontSize: header ? 11 : 20,
          fontVariant: ['tabular-nums'],
        }}
      >
        {value}
        {tiebreak !== null && tiebreak !== undefined ? (
          <Text style={{ fontSize: 11, fontWeight: '700' }}>{` ${tiebreak}`}</Text>
        ) : null}
      </Text>
    </View>
  );
}

export default function SetsScoreboard({ marcador, rival }) {
  const { palette } = useAppTheme();
  const sets = parseMarcador(marcador);

  if (sets.length === 0) {
    return (
      <Text className="text-[13px]" style={{ color: palette.textMuted }}>
        Sin marcador registrado.
      </Text>
    );
  }

  const ganados = sets.filter((s) => s.ganoJugador).length;
  const perdidos = sets.length - ganados;

  const accessibilityLabel = sets
    .map((s) => `Set ${s.numero}: ${s.jugador} a ${s.rival}${s.tiebreak !== null ? `, tiebreak ${s.tiebreak}` : ''}`)
    .join('. ');

  const row = (nombre, isPlayer) => (
    <View className="flex-row items-center py-2" style={{ borderTopWidth: isPlayer ? 0 : 1, borderColor: palette.border }}>
      <Text
        numberOfLines={1}
        className="flex-1 pr-2 text-[14px] font-semibold"
        style={{ color: palette.text }}
      >
        {nombre}
      </Text>
      {sets.map((s) => {
        const won = isPlayer ? s.ganoJugador : !s.ganoJugador;
        const games = isPlayer ? s.jugador : s.rival;
        // El tiebreak ("7-6(5)") anota los puntos de quien perdió el desempate.
        const tb = s.tiebreak !== null && !won ? s.tiebreak : null;
        return (
          <Cell
            key={s.numero}
            value={games}
            tiebreak={tb}
            won={won}
            color={isPlayer ? palette.ok : palette.error}
            palette={palette}
          />
        );
      })}
    </View>
  );

  return (
    <View accessibilityRole="text" accessibilityLabel={accessibilityLabel}>
      <View className="flex-row items-center pb-1">
        <View className="flex-1" />
        {sets.map((s) => (
          <Cell key={s.numero} value={`SET ${s.numero}`} palette={palette} header />
        ))}
      </View>
      {row('Tú', true)}
      {row(rival || 'Rival', false)}
      <Text className="mt-2 text-[12.5px]" style={{ color: palette.textMuted }}>
        Sets: <Text style={{ color: palette.text, fontWeight: '700' }}>{ganados}</Text> ganados ·{' '}
        <Text style={{ color: palette.text, fontWeight: '700' }}>{perdidos}</Text> perdidos
      </Text>
    </View>
  );
}
