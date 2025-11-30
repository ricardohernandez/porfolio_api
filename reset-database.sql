-- CLEAN RESET: Eliminar y recrear todo desde cero
-- Ejecutar en Railway: railway connect postgres < reset-database.sql

DROP TABLE IF EXISTS skill_items CASCADE;
DROP TABLE IF EXISTS skills CASCADE;
DROP TABLE IF EXISTS contacts CASCADE;
DROP TABLE IF EXISTS portfolio_projects CASCADE;
DROP TABLE IF EXISTS sliders CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Create users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create contacts table
CREATE TABLE contacts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create sliders table
CREATE TABLE sliders (
    id SERIAL PRIMARY KEY,
    slider_key VARCHAR(100) UNIQUE NOT NULL,
    title VARCHAR(255),
    heading VARCHAR(255),
    highlight_text VARCHAR(255),
    description TEXT,
    roles JSONB,
    proposal_text TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create portfolio_projects table
CREATE TABLE portfolio_projects (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    long_description TEXT,
    image_url VARCHAR(500),
    technologies JSONB,
    demo_url VARCHAR(500),
    github_url VARCHAR(500),
    category VARCHAR(100),
    featured BOOLEAN DEFAULT FALSE,
    status VARCHAR(50) DEFAULT 'published',
    display_order INTEGER DEFAULT 0,
    challenge TEXT,
    solution TEXT,
    impact TEXT,
    features JSONB,
    tags JSONB,
    gradient VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create skills table (icon como TEXT para soportar SVG paths largos)
CREATE TABLE skills (
    id SERIAL PRIMARY KEY,
    category VARCHAR(100) NOT NULL,
    color VARCHAR(100),
    items JSONB NOT NULL DEFAULT '[]'::jsonb,
    icon TEXT,
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create skill_items table
CREATE TABLE skill_items (
    id SERIAL PRIMARY KEY,
    skill_id INTEGER NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_contacts_status ON contacts(status);
CREATE INDEX idx_contacts_created_at ON contacts(created_at DESC);
CREATE INDEX idx_sliders_active ON sliders(is_active);
CREATE INDEX idx_sliders_order ON sliders(display_order);
CREATE INDEX idx_portfolio_status ON portfolio_projects(status);
CREATE INDEX idx_portfolio_featured ON portfolio_projects(featured);
CREATE INDEX idx_portfolio_category ON portfolio_projects(category);
CREATE INDEX idx_skills_active ON skills(is_active);
CREATE INDEX idx_skill_items_skill_id ON skill_items(skill_id);

-- Triggers for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_contacts_updated_at BEFORE UPDATE ON contacts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_sliders_updated_at BEFORE UPDATE ON sliders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_portfolio_updated_at BEFORE UPDATE ON portfolio_projects
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_skills_updated_at BEFORE UPDATE ON skills
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_skill_items_updated_at BEFORE UPDATE ON skill_items
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insertar datos FINALES
INSERT INTO users (email, password, name) VALUES
('ricardo.hernandez.esp@gmail.com', '$2a$10$xw1iMB.fHncxhU6Q6V6Tt.R6YkC22OTX5gtsDbrlQlYuvbJq8Fsv.', 'Ricardo Hernandez');

INSERT INTO sliders (slider_key, title, heading, highlight_text, description, roles, proposal_text, is_active, display_order) VALUES
('general', 'Desarrollo Agil de Soluciones Hechas a Medida', 'Desarrollo Agil de Soluciones Hechas a Medida', 'Soluciones Hechas a Medida', 'Desarrollo soluciones web agiles que impulsan el crecimiento de tu negocio con entregas rapidas y resultados medibles.', '["Desarrollo Agil", "Soluciones Hechas a Medida", "Apps Empresariales", "Consultoria Tecnica"]', 'Desarrollo soluciones web agiles que impulsan el crecimiento de tu negocio con entregas rapidas y resultados medibles.', FALSE, 1),
('startup', 'Impulsa tu Startup con Desarrollo Rapido y Escalable', 'Impulsa tu Startup con Desarrollo Rapido y Escalable', 'Desarrollo Rapido y Escalable', 'Transformo ideas de startup en productos digitales funcionales que atraen inversores y usuarios rapidamente.', '["Desarrollo Agil", "Soluciones Hechas a Medida", "Apps Empresariales", "Consultoria Tecnica"]', 'Transformo ideas de startup en productos digitales funcionales que atraen inversores y usuarios rapidamente.', TRUE, 2),
('enterprise', 'Transformacion para Empresas: Eficiencia y Resultados', 'Transformacion para Empresas: Eficiencia y Resultados', 'Eficiencia y Resultados', 'Digitalizacion de procesos empresariales complejos en sistemas web confiables que generan ahorros inmediatos.', '["Desarrollo Agil", "Soluciones Hechas a Medida", "Apps Empresariales", "Consultoria Tecnica"]', 'Digitalizacion de procesos empresariales complejos en sistemas web confiables que generan ahorros inmediatos.', TRUE, 3);

INSERT INTO portfolio_projects (title, description, long_description, image_url, technologies, demo_url, github_url, category, featured, status, display_order, challenge, solution, impact, features, tags, gradient) VALUES
('Chiletaller', 'Plataforma integral de servicios automotrices que conecta usuarios con talleres certificados. Sistema de cotizaciones dinamicas, contratos inteligentes, sistema de ratings, pagos integrados con Transbank, sistema de agendamiento en tiempo real, etc.', 'Plataforma web completa con Laravel + Vue.js que permite cotizaciones automatizadas, sistema de ratings, contratos digitales, pagos seguros. Implemente Redis para cache de consultas frecuentes.', '/uploads/portfolio/project-1763963884869-415343751.png', '["Laravel","Vue.js","MySQL","Redis","Docker","Inertia.js"]', NULL, NULL, 'Web', TRUE, 'active', 1, 'Los usuarios tenian dificultad para encontrar talleres confiables y comparar precios de forma transparente. Los talleres perdian clientes potenciales por falta de visibilidad.', 'Desarrolle una plataforma web completa con Laravel + Vue.js que permite cotizaciones automatizadas, sistema de ratings, contratos digitales, pagos seguros. Implemente Redis para cache de consultas frecuentes.', 'Usuarios ahora encuentran talleres confiables con transparencia total de precios. Los talleres ganaron visibilidad y acceso directo a clientes potenciales. El sistema de ratings genera confianza entre usuarios y talleres.', '["Cotizaciones dinamicas y automaticas","Envio de correos automaticos","Sistema de pagos integrado","Notificaciones en tiempo real con Redis","Contratos inteligentes digitales","Sistema de agendamiento en tiempo real","Gestor de talleres certificados","Rating y resenas de usuarios"]', '["Laravel", "Vue.js", "MySQL", "Redis", "Docker", "Inertia"]', 'from-blue-500 to-cyan-500'),
('SLDD - Gestion de Infraestructura', 'Plataforma web integral para la gestion completa de proyectos de infraestructura de telecomunicaciones. Centraliza control de obra, mediciones, certificaciones, facturacion, seguimiento de personal con generacion automatica de reportes y trazabilidad de proyecto, etc.', 'Sistema web centralizado que unifica control de obra, certificaciones, mediciones, gestion de pagos con roles diferenciados y reportes automaticos.', '/uploads/portfolio/project-1763963991023-204659253.png', '["CodeIgniter","MySQL","JavaScript","Bootstrap"]', NULL, NULL, 'Web', TRUE, 'active', 2, 'Empresa de telecomunicaciones gestionaba proyectos de infraestructura con Excel y correos, causando errores de facturacion y perdida de informacion critica de avances.', 'Disene e implemente un sistema web centralizado que unifica control de obra, certificaciones, mediciones, gestion de pagos con roles diferenciados y reportes automaticos.', 'Sistema centralizado elimina errores en facturacion. Informacion de proyectos accesible y trazable en tiempo real. Administrativos trabajan mas eficientemente sin dependencia de correos. Reportes automaticos garantizan precision en datos.', '["Control de construccion y avances","Gestion de mediciones y certificaciones","Sistema de pagos integrado","Seguimiento de personal de obra","Reportes detallados por fase","Control de proveedores y materiales"]', '["CodeIgniter", "MySQL", "JavaScript", "Bootstrap"]', 'from-green-500 to-emerald-500'),
('Chiletaller Mobile', 'Aplicacion movil PWA para iOS y Android desarrollada con Quasar Framework. Permite a usuarios y talleres gestionar solicitudes de servicios, cotizaciones, contratos y pagos desde dispositivos moviles con interfaz optimizada.', 'PWA con Quasar Framework + Capacitor que compila a iOS/Android nativamente, con estado global en Pinia, notificaciones push, y modo offline para consultas.', '/uploads/portfolio/project-1763968343602-462475248.jpg', '["Quasar Framework","Vue 3","Capacitor","Pinia","Tailwind CSS","PWA","Axios"]', NULL, NULL, 'Mobile', TRUE, 'active', 3, 'Se requeria una aplicacion movil nativa instalable para acceder rapidamente sin necesidad de navegador.', 'Construi una PWA con Quasar Framework + Capacitor que compila a iOS/Android nativamente, con estado global en Pinia, notificaciones push, y modo offline para consultas.', 'App movil proporciona experiencia rapida y fluida en dispositivos. Los usuarios pueden gestionar servicios en cualquier momento sin navegador. Notificaciones push mantienen a usuarios siempre informados.', '["Compilacion nativa para iOS y Android","Gestion de solicitudes de servicios","Cotizaciones en tiempo real","Envio de notificaciones automaticas por correo","Sistema de notificaciones push en tiempo real con Redis","Pagos integrados","Notificaciones push en tiempo real"]', '["Quasar", "Vue 3", "Capacitor", "Pinia", "Tailwind CSS", "Axios"]', 'from-orange-500 to-red-500');

INSERT INTO skills (category, color, items, icon, display_order, is_active) VALUES
('Base de Datos', 'from-indigo-500 to-blue-500', '[]'::jsonb, 'M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4', 1, TRUE),
('Backend', 'from-purple-500 to-pink-500', '[]'::jsonb, 'M5 12h14M5 12a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v4a2 2 0 01-2 2M5 12a2 2 0 00-2 2v4a2 2 0 002 2h14a2 2 0 002-2v-4a2 2 0 00-2-2m-2-4h.01M17 16h.01', 2, TRUE),
('Frontend', 'from-blue-500 to-cyan-500', '[]'::jsonb, 'M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z', 3, TRUE),
('DevOps & Tools', 'from-orange-500 to-red-500', '[]'::jsonb, 'M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z', 4, TRUE);

INSERT INTO skill_items (skill_id, name, display_order) VALUES
(1, 'Mysql', 1),
(1, 'Postgrees', 2),
(1, 'redis', 3),
(2, 'Laravel', 1),
(2, 'Node.js', 2),
(2, 'Codeigniter', 3),
(2, 'WordPress', 4),
(2, 'WooCommerce', 5),
(2, 'RESTful APIs', 6),
(2, 'express.js', 7),
(3, 'Vue.js', 1),
(3, 'React', 2),
(3, 'Quasar', 3),
(3, 'Tailwind CSS', 4),
(3, 'HTML5/CSS3', 5),
(4, 'Git', 1),
(4, 'Docker', 2),
(4, 'AWS , DO', 3),
(4, 'CI/CD', 4),
(4, 'Linux', 5);

INSERT INTO contacts (name, email, phone, message, is_read, status) VALUES
('Juan Perez', 'juan@example.com', '+56912345678', 'Hola! Me interesa tu trabajo', TRUE, 'pending'),
('Maria Garcia', 'maria@example.com', '+56987654321', 'Necesito cotizacion para un proyecto', TRUE, 'responded'),
('Juan Perez', 'juan@example.com', NULL, 'Hola Ricardo, me gustaria saber sobre tus servicios...', TRUE, 'pending');
