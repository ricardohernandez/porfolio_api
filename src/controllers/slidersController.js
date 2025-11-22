import pool from '../config/database.js';

export const getAllSliders = async (req, res, next) => {
  try {
    const result = await pool.query(
      'SELECT * FROM sliders WHERE is_active = TRUE ORDER BY display_order ASC'
    );
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
