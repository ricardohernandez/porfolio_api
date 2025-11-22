import pool from '../config/database.js';

export const getAllProjects = async (req, res, next) => {
  try {
    const { category, featured, status } = req.query;
    
    let query = 'SELECT * FROM portfolio_projects WHERE 1=1';
    const params = [];
    let paramCount = 1;

    if (category) {
      query += ` AND category = $${paramCount}`;
      params.push(category);
      paramCount++;
    }

    if (featured !== undefined) {
      query += ` AND featured = $${paramCount}`;
      params.push(featured === 'true');
      paramCount++;
    }

    if (status) {
      query += ` AND status = $${paramCount}`;
      params.push(status);
      paramCount++;
    }

    query += ' ORDER BY display_order ASC, created_at DESC';

    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (error) {
    next(error);
  }
};

export const getProjectById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM portfolio_projects WHERE id = $1', [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Project not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    next(error);
  }
};

export const createProject = async (req, res, next) => {
  try {
    const { title, description, long_description, image_url, technologies, demo_url, github_url, category, featured, status, display_order } = req.body;

    if (!title) {
      return res.status(400).json({ message: 'Title is required' });
    }

    const result = await pool.query(
      `INSERT INTO portfolio_projects (title, description, long_description, image_url, technologies, demo_url, github_url, category, featured, status, display_order) 
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11) RETURNING *`,
      [title, description, long_description, image_url, JSON.stringify(technologies), demo_url, github_url, category, featured ?? false, status ?? 'published', display_order ?? 0]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    next(error);
  }
};

export const updateProject = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { title, description, long_description, image_url, technologies, demo_url, github_url, category, featured, status, display_order } = req.body;

    const result = await pool.query(
      `UPDATE portfolio_projects SET 
        title = COALESCE($1, title),
        description = COALESCE($2, description),
        long_description = COALESCE($3, long_description),
        image_url = COALESCE($4, image_url),
        technologies = COALESCE($5, technologies),
        demo_url = COALESCE($6, demo_url),
        github_url = COALESCE($7, github_url),
        category = COALESCE($8, category),
        featured = COALESCE($9, featured),
        status = COALESCE($10, status),
        display_order = COALESCE($11, display_order)
       WHERE id = $12 RETURNING *`,
      [title, description, long_description, image_url, technologies ? JSON.stringify(technologies) : null, demo_url, github_url, category, featured, status, display_order, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Project not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    next(error);
  }
};

export const deleteProject = async (req, res, next) => {
  try {
    const { id } = req.params;
    const result = await pool.query('DELETE FROM portfolio_projects WHERE id = $1 RETURNING id', [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Project not found' });
    }

    res.json({ message: 'Project deleted successfully' });
  } catch (error) {
    next(error);
  }
};
