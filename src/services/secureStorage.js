// Almacenamiento seguro multiplataforma.
// - Celular (Android/iOS): expo-secure-store (Keychain / Keystore cifrado).
// - Web: expo-secure-store NO existe en el navegador, así que se usa localStorage.
//   Es la alternativa estándar en web; no está cifrado, por eso solo guardamos
//   el token de la API de prueba y los datos públicos del perfil.
import { Platform } from 'react-native';
import * as SecureStore from 'expo-secure-store';

const isWeb = Platform.OS === 'web';

function webStorage() {
  try {
    return typeof window !== 'undefined' ? window.localStorage : null;
  } catch {
    return null;
  }
}

export async function setItem(key, value) {
  if (isWeb) {
    webStorage()?.setItem(key, value);
    return;
  }
  await SecureStore.setItemAsync(key, value);
}

export async function getItem(key) {
  if (isWeb) {
    return webStorage()?.getItem(key) ?? null;
  }
  return SecureStore.getItemAsync(key);
}

export async function deleteItem(key) {
  if (isWeb) {
    webStorage()?.removeItem(key);
    return;
  }
  await SecureStore.deleteItemAsync(key);
}
