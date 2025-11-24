import express from 'express';
import { 
  getAllProjects, 
  getProjectById, 
  createProject, 
  updateProject, 
  deleteProject 
} from '../controllers/portfolioController.js';
import { authenticateToken } from '../middlewares/auth.middleware.js';
import { upload } from '../middlewares/upload.js';

const router = express.Router();

router.get('/', getAllProjects);
router.get('/:id', getProjectById);
router.post('/', authenticateToken, upload.single('image'), createProject);
router.put('/:id', authenticateToken, upload.single('image'), updateProject);
router.delete('/:id', authenticateToken, deleteProject);

export default router;
