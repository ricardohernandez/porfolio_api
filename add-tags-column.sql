-- Agregar columna tags a portfolio_projects en Railway
ALTER TABLE portfolio_projects
ADD COLUMN IF NOT EXISTS tags JSONB;

-- Actualizar los datos con los tags de la BD local
UPDATE portfolio_projects SET tags = '["Laravel", "Vue.js", "MySQL", "Redis", "Docker", "Inertia"]'::jsonb WHERE id = 1;
UPDATE portfolio_projects SET tags = '["CodeIgniter", "MySQL", "JavaScript", "Bootstrap"]'::jsonb WHERE id = 2;
UPDATE portfolio_projects SET tags = '["Quasar", "Vue 3", "Capacitor", "Pinia", "Tailwind CSS", "Axios"]'::jsonb WHERE id = 3;
