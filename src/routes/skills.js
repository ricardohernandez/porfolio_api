import { Router } from 'express';
import {
  getAllSkills,
  getSkillById,
  createSkill,
  updateSkill,
  deleteSkill,
  toggleSkillActive,
  reorderSkillItems
} from '../controllers/skillsController.js';

const router = Router();

// Public routes (no authentication required)
router.get('/', getAllSkills);
router.get('/:id', getSkillById);

// Protected routes (authentication required)
// Uncomment these lines if you add authentication middleware
// router.post('/', authenticateToken, createSkill);
// router.put('/:id', authenticateToken, updateSkill);
// router.delete('/:id', authenticateToken, deleteSkill);
// router.patch('/:id/toggle', authenticateToken, toggleSkillActive);
// router.patch('/:id/reorder-items', authenticateToken, reorderSkillItems);

// Unprotected routes for now (remove when adding auth)
router.post('/', createSkill);
router.put('/:id', updateSkill);
router.delete('/:id', deleteSkill);
router.patch('/:id/toggle', toggleSkillActive);
router.patch('/:id/reorder-items', reorderSkillItems);

export default router;
