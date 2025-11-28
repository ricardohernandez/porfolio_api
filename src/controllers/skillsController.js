import pool from '../config/database.js';

// GET all skills with their items
export const getAllSkills = async (req, res, next) => {
  try {
    const { search = '' } = req.query;
    
    let query = `SELECT 
      s.id,
      s.category,
      s.color,
      s.icon,
      s.display_order,
      s.is_active,
      s.created_at,
      s.updated_at,
      json_agg(
        json_build_object(
          'id', si.id,
          'name', si.name,
          'display_order', si.display_order
        ) ORDER BY si.display_order
      ) as items
     FROM skills s
     LEFT JOIN skill_items si ON s.id = si.skill_id`;
    
    const params = [];
    
    if (search && search.trim()) {
      const searchTerm = `%${search.trim()}%`;
      query += ` WHERE s.category ILIKE $1 
                 OR si.name ILIKE $1`;
      params.push(searchTerm);
    }
    
    query += ` GROUP BY s.id
              ORDER BY s.display_order`;
    
    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (error) {
    next(error);
  }
};

// GET single skill with items
export const getSkillById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      `SELECT 
        s.id,
        s.category,
        s.color,
        s.icon,
        s.display_order,
        s.is_active,
        s.created_at,
        s.updated_at,
        json_agg(
          json_build_object(
            'id', si.id,
            'name', si.name,
            'display_order', si.display_order
          ) ORDER BY si.display_order
        ) as items
       FROM skills s
       LEFT JOIN skill_items si ON s.id = si.skill_id
       WHERE s.id = $1
       GROUP BY s.id`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Skill not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    next(error);
  }
};

// CREATE skill
export const createSkill = async (req, res, next) => {
  try {
    const { category, color, icon, display_order = 0, items = [] } = req.body;

    // Validate required fields
    if (!category || !color || !icon) {
      return res.status(400).json({ 
        message: 'Missing required fields: category, color, icon' 
      });
    }

    // Insert skill
    const skillResult = await pool.query(
      `INSERT INTO skills (category, color, icon, display_order)
       VALUES ($1, $2, $3, $4)
       RETURNING *`,
      [category, color, icon, display_order]
    );

    const skill = skillResult.rows[0];

    // Insert skill items if provided
    if (items.length > 0) {
      for (let i = 0; i < items.length; i++) {
        await pool.query(
          `INSERT INTO skill_items (skill_id, name, display_order)
           VALUES ($1, $2, $3)`,
          [skill.id, items[i].name || items[i], i + 1]
        );
      }
    }

    // Fetch complete skill with items
    const completeSkill = await pool.query(
      `SELECT 
        s.id,
        s.category,
        s.color,
        s.icon,
        s.display_order,
        s.is_active,
        s.created_at,
        s.updated_at,
        json_agg(
          json_build_object(
            'id', si.id,
            'name', si.name,
            'display_order', si.display_order
          ) ORDER BY si.display_order
        ) as items
       FROM skills s
       LEFT JOIN skill_items si ON s.id = si.skill_id
       WHERE s.id = $1
       GROUP BY s.id`,
      [skill.id]
    );

    res.status(201).json(completeSkill.rows[0]);
  } catch (error) {
    if (error.code === '23505') {
      return res.status(409).json({ message: 'Category already exists' });
    }
    next(error);
  }
};

// UPDATE skill
export const updateSkill = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { category, color, icon, display_order, is_active, items = [] } = req.body;

    // Update skill
    const updateFields = [];
    const updateValues = [];
    let paramIndex = 1;

    if (category !== undefined) {
      updateFields.push(`category = $${paramIndex++}`);
      updateValues.push(category);
    }
    if (color !== undefined) {
      updateFields.push(`color = $${paramIndex++}`);
      updateValues.push(color);
    }
    if (icon !== undefined) {
      updateFields.push(`icon = $${paramIndex++}`);
      updateValues.push(icon);
    }
    if (display_order !== undefined) {
      updateFields.push(`display_order = $${paramIndex++}`);
      updateValues.push(display_order);
    }
    if (is_active !== undefined) {
      updateFields.push(`is_active = $${paramIndex++}`);
      updateValues.push(is_active);
    }

    updateFields.push(`updated_at = CURRENT_TIMESTAMP`);
    updateValues.push(id);

    if (updateFields.length > 1) {
      const result = await pool.query(
        `UPDATE skills SET ${updateFields.join(', ')} WHERE id = $${paramIndex} RETURNING *`,
        updateValues
      );

      if (result.rows.length === 0) {
        return res.status(404).json({ message: 'Skill not found' });
      }
    }

    // Update skill items if provided
    if (items.length > 0) {
      // Delete existing items
      await pool.query('DELETE FROM skill_items WHERE skill_id = $1', [id]);

      // Insert new items
      for (let i = 0; i < items.length; i++) {
        await pool.query(
          `INSERT INTO skill_items (skill_id, name, display_order)
           VALUES ($1, $2, $3)`,
          [id, items[i].name || items[i], i + 1]
        );
      }
    }

    // Fetch updated skill with items
    const updatedSkill = await pool.query(
      `SELECT 
        s.id,
        s.category,
        s.color,
        s.icon,
        s.display_order,
        s.is_active,
        s.created_at,
        s.updated_at,
        json_agg(
          json_build_object(
            'id', si.id,
            'name', si.name,
            'display_order', si.display_order
          ) ORDER BY si.display_order
        ) as items
       FROM skills s
       LEFT JOIN skill_items si ON s.id = si.skill_id
       WHERE s.id = $1
       GROUP BY s.id`,
      [id]
    );

    res.json(updatedSkill.rows[0]);
  } catch (error) {
    if (error.code === '23505') {
      return res.status(409).json({ message: 'Category already exists' });
    }
    next(error);
  }
};

// DELETE skill
export const deleteSkill = async (req, res, next) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      'DELETE FROM skills WHERE id = $1 RETURNING id',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Skill not found' });
    }

    res.json({ message: 'Skill deleted successfully', id: result.rows[0].id });
  } catch (error) {
    next(error);
  }
};

// Toggle skill active status
export const toggleSkillActive = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { is_active } = req.body;

    await pool.query(
      `UPDATE skills SET is_active = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2`,
      [is_active, id]
    );

    // Fetch the complete skill with items
    const result = await pool.query(
      `SELECT 
        s.id,
        s.category,
        s.color,
        s.icon,
        s.display_order,
        s.is_active,
        s.created_at,
        s.updated_at,
        json_agg(
          json_build_object(
            'id', si.id,
            'name', si.name,
            'display_order', si.display_order
          ) ORDER BY si.display_order
        ) as items
       FROM skills s
       LEFT JOIN skill_items si ON s.id = si.skill_id
       WHERE s.id = $1
       GROUP BY s.id`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Skill not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    next(error);
  }
};

// Reorder skill items
export const reorderSkillItems = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { items } = req.body;

    if (!Array.isArray(items)) {
      return res.status(400).json({ message: 'Items must be an array' });
    }

    // Update display_order for each item
    for (let i = 0; i < items.length; i++) {
      await pool.query(
        `UPDATE skill_items SET display_order = $1 WHERE id = $2`,
        [i + 1, items[i].id]
      );
    }

    // Fetch updated skill with items
    const updatedSkill = await pool.query(
      `SELECT 
        s.id,
        s.category,
        s.color,
        s.icon,
        s.display_order,
        s.is_active,
        s.created_at,
        s.updated_at,
        json_agg(
          json_build_object(
            'id', si.id,
            'name', si.name,
            'display_order', si.display_order
          ) ORDER BY si.display_order
        ) as items
       FROM skills s
       LEFT JOIN skill_items si ON s.id = si.skill_id
       WHERE s.id = $1
       GROUP BY s.id`,
      [id]
    );

    res.json(updatedSkill.rows[0]);
  } catch (error) {
    next(error);
  }
};
