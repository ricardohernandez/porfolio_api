import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import morgan from 'morgan';
import path from 'path';
import { fileURLToPath } from 'url';

// Import routes
import authRoutes from './src/routes/auth.routes.js';
import contactsRoutes from './src/routes/contacts.routes.js';
import slidersRoutes from './src/routes/sliders.routes.js';
import portfolioRoutes from './src/routes/portfolio.routes.js';
import skillsRoutes from './src/routes/skills.js';

// Import middleware
import { errorHandler } from './src/middlewares/errorHandler.js';

// Import database
import pool from './src/config/database.js';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = process.env.PORT;

console.log('🚀 Intentando iniciar en puerto:', PORT);
console.log('📌 NODE_ENV:', process.env.NODE_ENV);

// Configurar CORS Origins desde variable de entorno
let corsOrigins = [
  'http://localhost:5173',     // Portfolio local
  'http://localhost:5174',     // Admin local
  'http://localhost:5001'      // Backend local
];

// En producción agregar dominios de Vercel y Railway
if (process.env.NODE_ENV === 'production' && process.env.CORS_ORIGIN) {
  const productionOrigins = process.env.CORS_ORIGIN
    .split(',')
    .map(origin => origin.trim())
    .filter(origin => origin.length > 0);
  corsOrigins = [...corsOrigins, ...productionOrigins];
}

console.log('📋 CORS Origins configurados:', corsOrigins);

// Configuración CORS para Railway y desarrollo
const corsOptions = {
  origin: corsOrigins,
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  optionsSuccessStatus: 200
};

console.log('✅ CORS configurado para:', corsOrigins);

app.use(cors(corsOptions));
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));
app.use(morgan('dev'));

// Responder a OPTIONS requests (CORS preflight)
app.options('*', cors(corsOptions));

// Servir archivos estáticos (imágenes subidas)
app.use('/uploads', express.static(path.join(__dirname, 'public/uploads')));

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/contacts', contactsRoutes);
app.use('/api/sliders', slidersRoutes);
app.use('/api/portfolio', portfolioRoutes);
app.use('/api/skills', skillsRoutes);

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Test BD connection
app.get('/api/test-db', async (req, res) => {
  try {
    const result = await pool.query('SELECT NOW()');
    res.json({ 
      status: 'ok', 
      database: 'connected',
      time: result.rows[0]
    });
  } catch (error) {
    res.status(500).json({ 
      status: 'error', 
      database: 'disconnected',
      error: error.message 
    });
  }
});

// Error handler (must be last)
app.use(errorHandler);

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📝 Environment: ${process.env.NODE_ENV}`);
  console.log(`✅ App initialized and ready to accept requests`);
});

// Manejo de errores no capturados
process.on('unhandledRejection', (reason, promise) => {
  console.error('🔥 Unhandled Rejection at:', promise, 'reason:', reason);
});

process.on('uncaughtException', (error) => {
  console.error('🔥 Uncaught Exception:', error);
  process.exit(1);
});
