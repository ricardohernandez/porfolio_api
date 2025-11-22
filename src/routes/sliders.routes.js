import express from 'express';
import { 
  getAllSliders, 
  getSliderById, 
  createSlider, 
  updateSlider, 
  deleteSlider 
} from '../controllers/slidersController.js';
import { authenticateToken } from '../middlewares/auth.middleware.js';

const router = express.Router();

router.get('/', getAllSliders);
router.get('/:id', getSliderById);
router.post('/', authenticateToken, createSlider);
router.put('/:id', authenticateToken, updateSlider);
router.delete('/:id', authenticateToken, deleteSlider);

export default router;
