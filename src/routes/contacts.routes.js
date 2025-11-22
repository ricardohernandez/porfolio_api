import express from 'express';
import { 
  getAllContacts, 
  getContactById, 
  createContact, 
  updateContact, 
  deleteContact 
} from '../controllers/contactsController.js';
import { authenticateToken } from '../middlewares/auth.middleware.js';

const router = express.Router();

router.get('/', authenticateToken, getAllContacts);
router.get('/:id', authenticateToken, getContactById);
router.post('/', createContact); // Public route
router.put('/:id', authenticateToken, updateContact);
router.delete('/:id', authenticateToken, deleteContact);

export default router;
