-- Crear tabla de Skills
CREATE TABLE IF NOT EXISTS skills (
  id SERIAL PRIMARY KEY,
  category VARCHAR(100) NOT NULL UNIQUE,
  color VARCHAR(100) NOT NULL,
  icon TEXT NOT NULL,
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla de Items (habilidades dentro de cada categoría)
CREATE TABLE IF NOT EXISTS skill_items (
  id SERIAL PRIMARY KEY,
  skill_id INTEGER NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear índices para mejor rendimiento
CREATE INDEX IF NOT EXISTS idx_skills_display_order ON skills(display_order);
CREATE INDEX IF NOT EXISTS idx_skills_is_active ON skills(is_active);
CREATE INDEX IF NOT EXISTS idx_skill_items_skill_id ON skill_items(skill_id);
CREATE INDEX IF NOT EXISTS idx_skill_items_display_order ON skill_items(display_order);

-- Insertar datos iniciales
INSERT INTO skills (category, color, icon, display_order, is_active)
VALUES 
  ('Frontend', 'from-blue-500 to-cyan-500', 'M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z', 1, TRUE),
  ('Backend', 'from-purple-500 to-pink-500', 'M5 12h14M5 12a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v4a2 2 0 01-2 2M5 12a2 2 0 00-2 2v4a2 2 0 002 2h14a2 2 0 002-2v-4a2 2 0 00-2-2m-2-4h.01M17 16h.01', 2, TRUE),
  ('Base de Datos', 'from-indigo-500 to-blue-500', 'M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4', 3, TRUE),
  ('DevOps & Tools', 'from-orange-500 to-red-500', 'M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z', 4, TRUE)
ON CONFLICT (category) DO NOTHING;

-- Insertar items de Frontend
INSERT INTO skill_items (skill_id, name, display_order)
VALUES 
  ((SELECT id FROM skills WHERE category = 'Frontend'), 'Vue.js', 1),
  ((SELECT id FROM skills WHERE category = 'Frontend'), 'React', 2),
  ((SELECT id FROM skills WHERE category = 'Frontend'), 'Quasar', 3),
  ((SELECT id FROM skills WHERE category = 'Frontend'), 'Tailwind CSS', 4),
  ((SELECT id FROM skills WHERE category = 'Frontend'), 'HTML5/CSS3', 5)
ON CONFLICT DO NOTHING;

-- Insertar items de Backend
INSERT INTO skill_items (skill_id, name, display_order)
VALUES 
  ((SELECT id FROM skills WHERE category = 'Backend'), 'Laravel', 1),
  ((SELECT id FROM skills WHERE category = 'Backend'), 'Node.js', 2),
  ((SELECT id FROM skills WHERE category = 'Backend'), 'Codeigniter', 3),
  ((SELECT id FROM skills WHERE category = 'Backend'), 'WordPress', 4),
  ((SELECT id FROM skills WHERE category = 'Backend'), 'WooCommerce', 5),
  ((SELECT id FROM skills WHERE category = 'Backend'), 'RESTful APIs', 6)
ON CONFLICT DO NOTHING;

-- Insertar items de Base de Datos
INSERT INTO skill_items (skill_id, name, display_order)
VALUES 
  ((SELECT id FROM skills WHERE category = 'Base de Datos'), 'MySQL', 1),
  ((SELECT id FROM skills WHERE category = 'Base de Datos'), 'Redis', 2),
  ((SELECT id FROM skills WHERE category = 'Base de Datos'), 'PostgreSQL', 3)
ON CONFLICT DO NOTHING;

-- Insertar items de DevOps & Tools
INSERT INTO skill_items (skill_id, name, display_order)
VALUES 
  ((SELECT id FROM skills WHERE category = 'DevOps & Tools'), 'Git', 1),
  ((SELECT id FROM skills WHERE category = 'DevOps & Tools'), 'Docker', 2),
  ((SELECT id FROM skills WHERE category = 'DevOps & Tools'), 'AWS , DO', 3),
  ((SELECT id FROM skills WHERE category = 'DevOps & Tools'), 'CI/CD', 4),
  ((SELECT id FROM skills WHERE category = 'DevOps & Tools'), 'Linux', 5)
ON CONFLICT DO NOTHING;
