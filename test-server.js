import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5001;

app.use(cors());
app.use(express.json());

app.get('/health', (req, res) => {
  console.log('Health check requested');
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.get('/api/test', (req, res) => {
  console.log('Test endpoint requested');
  res.json({ message: 'Backend is working!' });
});

app.listen(PORT, () => {
  console.log(`🚀 Test server running on port ${PORT}`);
});
