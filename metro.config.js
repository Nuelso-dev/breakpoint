// Configuración de Metro (el empaquetador de Expo).
// IMPORTANTE: sin este archivo NativeWind no procesa las clases (className),
// y en el celular la pantalla queda en blanco porque "flex-1" no se aplica.
const { getDefaultConfig } = require('expo/metro-config');
const { withNativeWind } = require('nativewind/metro');

const config = getDefaultConfig(__dirname);

// expo-sqlite en web usa WebAssembly (.wasm).
if (!config.resolver.assetExts.includes('wasm')) {
  config.resolver.assetExts.push('wasm');
}

// expo-sqlite en web necesita estas cabeceras (SharedArrayBuffer) en el servidor de desarrollo.
config.server = config.server || {};
const previousEnhance = config.server.enhanceMiddleware;
config.server.enhanceMiddleware = (middleware, server) => {
  const base = previousEnhance ? previousEnhance(middleware, server) : middleware;
  return (req, res, next) => {
    res.setHeader('Cross-Origin-Embedder-Policy', 'credentialless');
    res.setHeader('Cross-Origin-Opener-Policy', 'same-origin');
    return base(req, res, next);
  };
};

module.exports = withNativeWind(config, { input: './global.css' });
