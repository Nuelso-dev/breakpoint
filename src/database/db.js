import { Platform } from 'react-native';
import * as SQLite from 'expo-sqlite';
import { DATABASE_NAME } from '../constants/config';

let dbPromise = null;

// Abre la base y crea el esquema UNA sola vez. Cualquier consulta espera a que
// la tabla exista, así ninguna pantalla puede adelantarse (antes salía
// "no such table: matches" cuando una pantalla consultaba demasiado pronto).
export function getDatabase() {
  if (!dbPromise) {
    dbPromise = (async () => {
      const db = await SQLite.openDatabaseAsync(DATABASE_NAME);
      await createSchema(db);
      return db;
    })().catch((error) => {
      dbPromise = null; // permite reintentar si falló al abrir
      throw error;
    });
  }
  return dbPromise;
}

export async function initDatabase() {
  return getDatabase();
}

// Esquema local. Se separa el id local (clave primaria) del remote_id de la API.
async function createSchema(db) {
  // WAL mejora el rendimiento en el celular; en web (WebAssembly) no aplica.
  if (Platform.OS !== 'web') {
    await db.execAsync('PRAGMA journal_mode = WAL;');
  }
  await db.execAsync(`
    CREATE TABLE IF NOT EXISTS matches (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      remote_id TEXT,
      owner TEXT NOT NULL,
      rival TEXT NOT NULL,
      torneo TEXT NOT NULL,
      superficie TEXT NOT NULL,
      fecha TEXT NOT NULL,
      resultado TEXT NOT NULL,
      marcador TEXT NOT NULL DEFAULT '',
      primer_saque_pct INTEGER NOT NULL DEFAULT 0,
      puntos_ganados_saque INTEGER NOT NULL DEFAULT 0,
      winners INTEGER NOT NULL DEFAULT 0,
      errores_no_forzados INTEGER NOT NULL DEFAULT 0,
      patron_rival TEXT NOT NULL DEFAULT '',
      lado_debil TEXT NOT NULL DEFAULT '',
      notas TEXT NOT NULL DEFAULT '',
      sync_status TEXT NOT NULL DEFAULT 'synced',
      pending_action TEXT,
      remote_simulated INTEGER NOT NULL DEFAULT 0,
      last_error TEXT,
      updated_at TEXT NOT NULL,
      synced_at TEXT
    );

    CREATE INDEX IF NOT EXISTS idx_matches_owner ON matches (owner);
    CREATE INDEX IF NOT EXISTS idx_matches_remote ON matches (owner, remote_id);
    CREATE INDEX IF NOT EXISTS idx_matches_status ON matches (owner, sync_status);
  `);
}

export async function resetDatabase() {
  const db = await getDatabase();
  await db.execAsync('DROP TABLE IF EXISTS matches;');
  await createSchema(db);
}
