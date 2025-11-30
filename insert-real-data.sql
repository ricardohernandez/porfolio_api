-- Script de datos reales para base de datos de producción
-- Incluye TODO: usuarios, sliders, proyectos (CON tags en el primer INSERT), skills e items
-- NO incluye TRUNCATE - usar solo después de database.sql
-- Ejecutar en Railway con: railway connect postgres < insert-real-data.sql

-- Insertar usuario admin
INSERT INTO users (email, password, name) VALUES
('ricardo.hernandez.esp@gmail.com', '$2a$10$xw1iMB.fHncxhU6Q6V6Tt.R6YkC22OTX5gtsDbrlQlYuvbJq8Fsv.', 'Ricardo Hernandez');

-- Insertar sliders
INSERT INTO sliders (slider_key, title, heading, highlight_text, description, roles, proposal_text, is_active, display_order) VALUES
('general', 'Desarrollo Agil de Soluciones Hechas a Medida', 'Desarrollo Agil de Soluciones Hechas a Medida', 'Soluciones Hechas a Medida', 'Desarrollo soluciones web agiles que impulsan el crecimiento de tu negocio con entregas rapidas y resultados medibles.', '["Desarrollo Agil", "Soluciones Hechas a Medida", "Apps Empresariales", "Consultoria Tecnica"]', 'Desarrollo soluciones web agiles que impulsan el crecimiento de tu negocio con entregas rapidas y resultados medibles.', FALSE, 1),
('startup', 'Impulsa tu Startup con Desarrollo Rapido y Escalable', 'Impulsa tu Startup con Desarrollo Rapido y Escalable', 'Desarrollo Rapido y Escalable', 'Transformo ideas de startup en productos digitales funcionales que atraen inversores y usuarios rapidamente.', '["Desarrollo Agil", "Soluciones Hechas a Medida", "Apps Empresariales", "Consultoria Tecnica"]', 'Transformo ideas de startup en productos digitales funcionales que atraen inversores y usuarios rapidamente.', TRUE, 2),
('enterprise', 'Transformacion para Empresas: Eficiencia y Resultados', 'Transformacion para Empresas: Eficiencia y Resultados', 'Eficiencia y Resultados', 'Digitalizacion de procesos empresariales complejos en sistemas web confiables que generan ahorros inmediatos.', '["Desarrollo Agil", "Soluciones Hechas a Medida", "Apps Empresariales", "Consultoria Tecnica"]', 'Digitalizacion de procesos empresariales complejos en sistemas web confiables que generan ahorros inmediatos.', TRUE, 3);

-- Insertar proyectos CON TAGS incluido en el PRIMER INSERT (como solicitado)
INSERT INTO portfolio_projects (title, description, long_description, image_url, technologies, demo_url, github_url, category, featured, status, display_order, challenge, solution, impact, features, tags, gradient) VALUES
('Chiletaller', 'Plataforma integral de servicios automotrices que conecta usuarios con talleres certificados. Sistema de cotizaciones dinamicas, contratos inteligentes, sistema de ratings, pagos integrados con Transbank, sistema de agendamiento en tiempo real, etc.', 'Plataforma web completa con Laravel + Vue.js que permite cotizaciones automatizadas, sistema de ratings, contratos digitales, pagos seguros. Implemente Redis para cache de consultas frecuentes.', '/uploads/portfolio/project-1763963884869-415343751.png', '["Laravel","Vue.js","MySQL","Redis","Docker","Inertia.js"]', NULL, NULL, 'Web', TRUE, 'active', 1, 'Los usuarios tenian dificultad para encontrar talleres confiables y comparar precios de forma transparente. Los talleres perdian clientes potenciales por falta de visibilidad.', 'Desarrolle una plataforma web completa con Laravel + Vue.js que permite cotizaciones automatizadas, sistema de ratings, contratos digitales, pagos seguros. Implemente Redis para cache de consultas frecuentes.', 'Usuarios ahora encuentran talleres confiables con transparencia total de precios. Los talleres ganaron visibilidad y acceso directo a clientes potenciales. El sistema de ratings genera confianza entre usuarios y talleres.', '["Cotizaciones dinamicas y automaticas","Envio de correos automaticos","Sistema de pagos integrado","Notificaciones en tiempo real con Redis","Contratos inteligentes digitales","Sistema de agendamiento en tiempo real","Gestor de talleres certificados","Rating y resenas de usuarios"]', '["Laravel", "Vue.js", "MySQL", "Redis", "Docker", "Inertia"]', 'from-blue-500 to-cyan-500'),
('SLDD - Gestion de Infraestructura', 'Plataforma web integral para la gestion completa de proyectos de infraestructura de telecomunicaciones. Centraliza control de obra, mediciones, certificaciones, facturacion, seguimiento de personal con generacion automatica de reportes y trazabilidad de proyecto, etc.', 'Sistema web centralizado que unifica control de obra, certificaciones, mediciones, gestion de pagos con roles diferenciados y reportes automaticos.', '/uploads/portfolio/project-1763963991023-204659253.png', '["CodeIgniter","MySQL","JavaScript","Bootstrap"]', NULL, NULL, 'Web', TRUE, 'active', 2, 'Empresa de telecomunicaciones gestionaba proyectos de infraestructura con Excel y correos, causando errores de facturacion y perdida de informacion critica de avances.', 'Disene e implemente un sistema web centralizado que unifica control de obra, certificaciones, mediciones, gestion de pagos con roles diferenciados y reportes automaticos.', 'Sistema centralizado elimina errores en facturacion. Informacion de proyectos accesible y trazable en tiempo real. Administrativos trabajan mas eficientemente sin dependencia de correos. Reportes automaticos garantizan precision en datos.', '["Control de construccion y avances","Gestion de mediciones y certificaciones","Sistema de pagos integrado","Seguimiento de personal de obra","Reportes detallados por fase","Control de proveedores y materiales"]', '["CodeIgniter", "MySQL", "JavaScript", "Bootstrap"]', 'from-green-500 to-emerald-500'),
('Chiletaller Mobile', 'Aplicacion movil PWA para iOS y Android desarrollada con Quasar Framework. Permite a usuarios y talleres gestionar solicitudes de servicios, cotizaciones, contratos y pagos desde dispositivos moviles con interfaz optimizada.', 'PWA con Quasar Framework + Capacitor que compila a iOS/Android nativamente, con estado global en Pinia, notificaciones push, y modo offline para consultas.', '/uploads/portfolio/project-1763968343602-462475248.jpg', '["Quasar Framework","Vue 3","Capacitor","Pinia","Tailwind CSS","PWA","Axios"]', NULL, NULL, 'Mobile', TRUE, 'active', 3, 'Se requeria una aplicacion movil nativa instalable para acceder rapidamente sin necesidad de navegador.', 'Construi una PWA con Quasar Framework + Capacitor que compila a iOS/Android nativamente, con estado global en Pinia, notificaciones push, y modo offline para consultas.', 'App movil proporciona experiencia rapida y fluida en dispositivos. Los usuarios pueden gestionar servicios en cualquier momento sin navegador. Notificaciones push mantienen a usuarios siempre informados.', '["Compilacion nativa para iOS y Android","Gestion de solicitudes de servicios","Cotizaciones en tiempo real","Envio de notificaciones automaticas por correo","Sistema de notificaciones push en tiempo real con Redis","Pagos integrados","Notificaciones push en tiempo real"]', '["Quasar", "Vue 3", "Capacitor", "Pinia", "Tailwind CSS", "Axios"]', 'from-orange-500 to-red-500');

-- Insertar skills con items vacios (se populan mediante skill_items)
INSERT INTO skills (category, color, items, display_order, is_active) VALUES
('Base de Datos', 'from-indigo-500 to-blue-500', '[]'::jsonb, 1, TRUE),
('Backend', 'from-purple-500 to-pink-500', '[]'::jsonb, 2, TRUE),
('Frontend', 'from-blue-500 to-cyan-500', '[]'::jsonb, 3, TRUE),
('DevOps & Tools', 'from-orange-500 to-red-500', '[]'::jsonb, 4, TRUE);

-- Insertar skill items (20 items distribuidos en 4 categorias)
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

-- Insertar contactos de ejemplo
INSERT INTO contacts (name, email, phone, message, is_read, status) VALUES
('Juan Perez', 'juan@example.com', '+56912345678', 'Hola! Me interesa tu trabajo', TRUE, 'pending'),
('Maria Garcia', 'maria@example.com', '+56987654321', 'Necesito cotizacion para un proyecto', TRUE, 'responded'),
('Juan Perez', 'juan@example.com', NULL, 'Hola Ricardo, me gustaria saber sobre tus servicios...', TRUE, 'pending');
