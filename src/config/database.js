import pg from 'pg';
import dotenv from 'dotenv';

dotenv.config();

const { Pool } = pg;

const isProduction = process.env.NODE_ENV === 'production';

console.log('🔍 Iniciando configuración de Base de Datos...');
console.log('   NODE_ENV:', process.env.NODE_ENV);
console.log('   DATABASE_URL definida:', !!process.env.DATABASE_URL);

let poolConfig;

if (process.env.DATABASE_URL) {
  console.log('   ✅ Usando DATABASE_URL para conexión');
  poolConfig = {
    connectionString: process.env.DATABASE_URL,
    ssl: isProduction ? { rejectUnauthorized: false } : false
  };
} else {
  console.log('   ⚠️ No se encontró DATABASE_URL, intentando variables individuales');
  if (isProduction) {
    console.error('   🚨 ERROR CRÍTICO: En producción se requiere DATABASE_URL');
  }
  poolConfig = {
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    database: process.env.DB_NAME || 'portfolio_db',
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || '',
  };
}

const pool = new Pool(poolConfig);

console.log('🗄️  Pool de conexiones creado');

pool.on('connect', () => {
  console.log('✅ Conexión exitosa a PostgreSQL');
});

pool.on('error', (err) => {
  console.error('❌ Error inesperado en el cliente de PostgreSQL:', err);
  // No salir del proceso aquí, dejar que el servidor siga corriendo para logs
});

export default pool;
