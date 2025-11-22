# Portfolio Backend API

Backend API para el sistema de portfolio, construido con Node.js, Express y PostgreSQL.

## 📁 Estructura del Proyecto

```
portfolio-backend/
├── src/
│   ├── config/
│   │   └── database.js          # Configuración PostgreSQL
│   ├── controllers/
│   │   ├── authController.js    # Login y autenticación
│   │   ├── contactsController.js
│   │   ├── slidersController.js
│   │   └── portfolioController.js
│   ├── middlewares/
│   │   ├── auth.middleware.js   # JWT authentication
│   │   └── errorHandler.js      # Manejo global de errores
│   └── routes/
│       ├── auth.routes.js
│       ├── contacts.routes.js
│       ├── sliders.routes.js
│       └── portfolio.routes.js
├── database.sql                  # Schema y seed data
├── server.js                     # Punto de entrada
├── package.json
├── .env.example
└── .gitignore
```

## 🚀 Instalación

### 1. Instalar dependencias
```powershell
cd c:\Users\ricardo\Herd\projects\portfolio-backend
npm install
```

### 2. Configurar variables de entorno
```powershell
copy .env.example .env
```

Edita `.env` con tus credenciales:
```env
PORT=5000
NODE_ENV=development

DB_HOST=localhost
DB_PORT=5432
DB_NAME=portfolio_db
DB_USER=postgres
DB_PASSWORD=tu_password_aqui

JWT_SECRET=tu_clave_secreta_jwt
JWT_EXPIRES_IN=7d

CORS_ORIGIN=http://localhost:5174
```

### 3. Crear base de datos PostgreSQL

```powershell
# Conectar a PostgreSQL
psql -U postgres

# Dentro de psql:
CREATE DATABASE portfolio_db;
\q
```

### 4. Ejecutar el script SQL
```powershell
psql -U postgres -d portfolio_db -f database.sql
```

### 5. Iniciar el servidor
```powershell
npm run dev
```

El servidor estará corriendo en `http://localhost:5000`

## 📡 API Endpoints

### Authentication
- `POST /api/auth/login` - Login (público)
  - Body: `{ email, password }`
  - Response: `{ token, user }`
- `GET /api/auth/me` - Obtener usuario actual (protegido)

### Contacts
- `GET /api/contacts` - Listar todos los contactos (protegido)
- `GET /api/contacts/:id` - Obtener contacto por ID (protegido)
- `POST /api/contacts` - Crear contacto (público - formulario web)
- `PUT /api/contacts/:id` - Actualizar contacto (protegido)
- `DELETE /api/contacts/:id` - Eliminar contacto (protegido)

### Sliders
- `GET /api/sliders` - Listar sliders activos (público)
- `GET /api/sliders/:id` - Obtener slider por ID (público)
- `POST /api/sliders` - Crear slider (protegido)
- `PUT /api/sliders/:id` - Actualizar slider (protegido)
- `DELETE /api/sliders/:id` - Eliminar slider (protegido)

### Portfolio Projects
- `GET /api/portfolio` - Listar proyectos (público)
  - Query params: `?category=valor&featured=true&status=published`
- `GET /api/portfolio/:id` - Obtener proyecto por ID (público)
- `POST /api/portfolio` - Crear proyecto (protegido)
- `PUT /api/portfolio/:id` - Actualizar proyecto (protegido)
- `DELETE /api/portfolio/:id` - Eliminar proyecto (protegido)

### Health Check
- `GET /health` - Estado del servidor

## 🔐 Autenticación

Las rutas protegidas requieren un token JWT en el header:
```
Authorization: Bearer <token>
```

### Credenciales por defecto
- Email: `ricardo.hernandez.esp@gmail.com`
- Password: `admin123`

## 🗃️ Base de Datos

### Tablas
- **users** - Usuarios del sistema
- **contacts** - Mensajes de contacto
- **sliders** - Contenido de sliders (hero, about, etc.)
- **portfolio_projects** - Proyectos del portfolio

### Características
- Triggers automáticos para `updated_at`
- Índices en campos frecuentemente consultados
- Campos JSONB para arrays (roles, technologies)
- Seed data incluida para pruebas

## 🛠️ Scripts NPM

```powershell
npm start       # Iniciar en producción
npm run dev     # Iniciar con auto-reload (Node --watch)
npm run db:setup # Ejecutar script SQL
```

## 📦 Dependencias

- **express** - Framework web
- **pg** - PostgreSQL client
- **dotenv** - Variables de entorno
- **cors** - CORS middleware
- **bcryptjs** - Hashing de passwords
- **jsonwebtoken** - JWT authentication
- **express-validator** - Validación de datos
- **morgan** - HTTP request logger

## 🔄 Próximos Pasos

1. ✅ Backend creado
2. ✅ Configurar `.env` con credenciales
3. ✅ Crear base de datos y ejecutar SQL
4. ✅ Probar endpoints - **TODOS FUNCIONANDO**
5. ⏳ Conectar portfolio-admin al nuevo backend
6. ⏳ Deploy a producción

## ✅ Estado Actual

**Backend funcionando correctamente en puerto 5001**

- Health Check: ✅ OK
- Sliders (público): ✅ 2 sliders
- Portfolio (público): ✅ 3 proyectos  
- Login: ✅ ricardo.hernandez.esp@gmail.com / admin123
- Contacts (protegido): ✅ 3 contactos

Para ejecutar pruebas: `.\test-api-clean.ps1`

## 🐛 Troubleshooting

### Error: "password authentication failed"
- Verifica que tu password de PostgreSQL esté correcto en `.env`

### Error: "database does not exist"
- Asegúrate de haber creado la base de datos: `CREATE DATABASE portfolio_db;`

### Error: "Cannot find module"
- Ejecuta `npm install` para instalar todas las dependencias

### Error de CORS
- Verifica que `CORS_ORIGIN` en `.env` coincida con tu frontend URL
