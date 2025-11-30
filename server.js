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
const PORT = process.env.PORT || 5000;

console.log('🚀 Intentando iniciar en puerto:', PORT);

// Middleware
const corsOrigins = process.env.CORS_ORIGIN 
  ? process.env.CORS_ORIGIN.split(',').map(origin => origin.trim())
  : [
      'http://localhost:5173', // Portfolio
      'http://localhost:5174', // Portfolio Admin
      'http://localhost:5001'  // Backend local
    ];

console.log('📋 CORS Origins:', corsOrigins);
console.log('🌍 NODE_ENV:', process.env.NODE_ENV);

// Función para validar origen (soporta wildcards para Vercel)
const validateOrigin = (origin) => {
  // Permitir requests sin origin (como requests desde mobile apps)
  if (!origin) return true;
  
  // Si está en la lista, permitir
  if (corsOrigins.includes(origin)) return true;
  
  // En desarrollo permitir localhost
  if (process.env.NODE_ENV !== 'production' && origin.includes('localhost')) return true;
  
  // Permitir cualquier subdominio de vercel.app en producción
  if (process.env.NODE_ENV === 'production' && origin.includes('vercel.app')) {
    console.log('✅ Permitiendo origen Vercel:', origin);
    return true;
  }
  
  console.log('❌ Bloqueando origen no permitido:', origin);
  return false;
};

// En desarrollo permitir todos, en producción ser restrictivo
const corsOptions = process.env.NODE_ENV === 'production'
  ? {
      origin: validateOrigin,
      credentials: true,
      methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
      allowedHeaders: ['Content-Type', 'Authorization']
    }
  : {
      origin: true, // En desarrollo permitir todos
      credentials: true,
      methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
      allowedHeaders: ['Content-Type', 'Authorization']
    };

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
