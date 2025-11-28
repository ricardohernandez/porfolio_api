import pool from '../config/database.js';

export const getAllSliders = async (req, res, next) => {
  try {
    const { search, sortBy = 'display_order', sortOrder = 'ASC' , is_active = null } = req.query;
    let query = 'SELECT * FROM sliders';
    let params = [];

    if (search) {
      const searchTerm = `%${search}%`;
      query += ` WHERE title ILIKE $1 
                 OR heading ILIKE $1 
                 OR slider_key ILIKE $1`;
      params.push(searchTerm);
    }

    if (is_active !== null && is_active !== undefined && is_active !== '') {
      const isActiveBoolean = is_active === 'true';
      if (params.length === 0) {
        query += ' WHERE is_active = $1';
      } else {
        query += ` AND is_active = $${params.length + 1}`;
      }
      params.push(isActiveBoolean);
    }

    // Validar que sortBy sea un campo válido (seguridad)
    const validFields = ['id', 'slider_key', 'title', 'heading', 'is_active', 'display_order', 'created_at'];
    const field = validFields.includes(sortBy) ? sortBy : 'display_order';
    const order = sortOrder?.toUpperCase() === 'DESC' ? 'DESC' : 'ASC';

    query += ` ORDER BY ${field} ${order}`;

    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (error) {
    next(error);
  }
};

export const getSliderById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM sliders WHERE id = $1', [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Slider not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    next(error);
  }
};

export const createSlider = async (req, res, next) => {
  try {
    const { slider_key, title, heading, highlight_text, description, roles, proposal_text, is_active, display_order } = req.body;

    if (!slider_key) {
      return res.status(400).json({ message: 'slider_key is required' });
    }

    const result = await pool.query(
      `INSERT INTO sliders (slider_key, title, heading, highlight_text, description, roles, proposal_text, is_active, display_order) 
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *`,
      [slider_key, title, heading, highlight_text, description, JSON.stringify(roles), proposal_text, is_active ?? true, display_order ?? 0]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    next(error);
  }
};

export const updateSlider = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { title, heading, highlight_text, description, roles, proposal_text, is_active, display_order } = req.body;

    const result = await pool.query(
      `UPDATE sliders SET 
        title = COALESCE($1, title),
        heading = COALESCE($2, heading),
        highlight_text = COALESCE($3, highlight_text),
        description = COALESCE($4, description),
        roles = COALESCE($5, roles),
        proposal_text = COALESCE($6, proposal_text),
        is_active = COALESCE($7, is_active),
        display_order = COALESCE($8, display_order)
       WHERE id = $9 RETURNING *`,
      [title, heading, highlight_text, description, roles ? JSON.stringify(roles) : null, proposal_text, is_active, display_order, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Slider not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    next(error);
  }
};

export const deleteSlider = async (req, res, next) => {
  try {
    const { id } = req.params;
    const result = await pool.query('DELETE FROM sliders WHERE id = $1 RETURNING id', [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Slider not found' });
    }

    res.json({ message: 'Slider deleted successfully' });
  } catch (error) {
    next(error);
  }
};
