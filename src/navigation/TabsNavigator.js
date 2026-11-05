import React from 'react';
import { Text, Pressable } from 'react-native';
import { DrawerActions } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import MatchesStack from './MatchesStack';
import StatsStack from './StatsStack';
import RivalsStack from './RivalsStack';
import { useAppTheme } from '../hooks/useAppTheme';
import { useMatches } from '../context/MatchesContext';

const Tabs = createBottomTabNavigator();

function TabIcon({ symbol, color, focused }) {
  return (
    <Text style={{ fontSize: focused ? 20 : 18, color }} accessibilityElementsHidden importantForAccessibility="no">
      {symbol}
    </Text>
  );
}

// Botón ☰ para abrir el Drawer. En el celular también se puede deslizar desde
// el borde, pero en web el deslizamiento no existe y el menú quedaba inaccesible.
function MenuButton({ navigation, color }) {
  return (
    <Pressable
      onPress={() => navigation.dispatch(DrawerActions.openDrawer())}
      accessibilityRole="button"
      accessibilityLabel="Abrir menú"
      accessibilityHint="Muestra configuración, acerca de y cerrar sesión"
      hitSlop={12}
      style={({ pressed }) => ({ paddingHorizontal: 16, paddingVertical: 6, opacity: pressed ? 0.5 : 1 })}
    >
      <Text style={{ fontSize: 22, color, fontWeight: '700' }}>☰</Text>
    </Pressable>
  );
}

// Tres secciones principales mediante Bottom Tabs, cada una con su propio Stack.
export default function TabsNavigator() {
  const { palette } = useAppTheme();
  const { counters } = useMatches();

  return (
    <Tabs.Navigator
      screenOptions={({ navigation }) => ({
        headerLeft: () => <MenuButton navigation={navigation} color={palette.text} />,
        headerStyle: { backgroundColor: palette.background },
        headerTintColor: palette.text,
        headerTitleStyle: { fontWeight: '800' },
        tabBarActiveTintColor: palette.primary,
        tabBarInactiveTintColor: palette.textMuted,
        tabBarStyle: { backgroundColor: palette.surface, borderTopColor: palette.border, height: 62, paddingBottom: 8, paddingTop: 6 },
        tabBarLabelStyle: { fontSize: 11.5, fontWeight: '600' },
      })}
    >
      <Tabs.Screen
        name="Partidos"
        component={MatchesStack}
        options={{
          title: 'Partidos',
          headerTitle: 'BreakPoint',
          tabBarBadge: counters.pending > 0 ? counters.pending : undefined,
          tabBarAccessibilityLabel: 'Partidos registrados',
          tabBarIcon: ({ color, focused }) => <TabIcon symbol="🎾" color={color} focused={focused} />,
        }}
      />
      <Tabs.Screen
        name="Analisis"
        component={StatsStack}
        options={{
          title: 'Análisis',
          headerTitle: 'Análisis',
          tabBarAccessibilityLabel: 'Análisis de tu rendimiento',
          tabBarIcon: ({ color, focused }) => <TabIcon symbol="📊" color={color} focused={focused} />,
        }}
      />
      <Tabs.Screen
        name="Rivales"
        component={RivalsStack}
        options={{
          title: 'Rivales',
          headerTitle: 'Rivales',
          tabBarAccessibilityLabel: 'Perfiles de rivales',
          tabBarIcon: ({ color, focused }) => <TabIcon symbol="👤" color={color} focused={focused} />,
        }}
      />
    </Tabs.Navigator>
  );
}
