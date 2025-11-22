-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create contacts table
CREATE TABLE IF NOT EXISTS contacts (
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
CREATE TABLE IF NOT EXISTS sliders (
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
CREATE TABLE IF NOT EXISTS portfolio_projects (
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

-- Seed data (password is 'admin123' - hash generado con bcrypt)
INSERT INTO users (email, password, name) VALUES
('ricardo.hernandez.esp@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Ricardo Hernández')
ON CONFLICT (email) DO NOTHING;

INSERT INTO sliders (slider_key, title, heading, highlight_text, description, roles, proposal_text, is_active, display_order) VALUES
('hero', 'Ricardo Hernández', 'Full Stack Developer', 'Creando experiencias digitales', 'Desarrollador con experiencia en React, Node.js y PostgreSQL', '["Frontend Developer", "Backend Developer", "UI/UX Designer"]'::jsonb, 'Transformo ideas en soluciones digitales', TRUE, 1),
('about', 'Sobre Mí', 'Pasión por el código', 'Clean Code', 'Me especializo en crear aplicaciones web modernas y escalables', '["React", "Node.js", "PostgreSQL", "MongoDB"]'::jsonb, 'Siempre aprendiendo nuevas tecnologías', TRUE, 2)
ON CONFLICT (slider_key) DO NOTHING;

INSERT INTO portfolio_projects (title, description, long_description, image_url, technologies, demo_url, github_url, category, featured, status, display_order) VALUES
('E-commerce Tintanic', 'Tienda online de papelería', 'Plataforma de e-commerce moderna con carrito de compras y pasarela de pagos', '/images/tintanic.jpg', '["React", "Tailwind CSS", "Vite"]'::jsonb, 'https://tintanic.vercel.app', 'https://github.com/usuario/tintanic', 'E-commerce', TRUE, 'published', 1),
('Portfolio Admin', 'Panel administrativo para portfolio', 'Sistema de gestión de contenido para administrar proyectos, slider y contactos', '/images/admin.jpg', '["React", "Node.js", "PostgreSQL", "JWT"]'::jsonb, NULL, 'https://github.com/usuario/portfolio-admin', 'Admin Panel', TRUE, 'published', 2),
('React Practice', 'Aplicación de práctica React', 'Proyecto educativo con implementación de hooks, pagination, search y themes', '/images/practice.jpg', '["React", "GitHub API", "LocalStorage"]'::jsonb, NULL, 'https://github.com/usuario/react-practice', 'Learning', FALSE, 'published', 3);

INSERT INTO contacts (name, email, phone, message, is_read, status) VALUES
('Juan Pérez', 'juan@example.com', '+56912345678', '¡Hola! Me interesa tu trabajo', FALSE, 'pending'),
('María García', 'maria@example.com', '+56987654321', 'Necesito cotización para un proyecto', TRUE, 'responded');
