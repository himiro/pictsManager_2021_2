import express from 'express';

import authRouter from './auth.js';
import { authMiddleware } from './auth.js';
import filesRouter from './files.js';

const router = express.Router();

router.get('/', async (req, res) => {
  return res.status(200).send({ message: 'Hello' });
});
router.use('/auth', authRouter);
router.use('/files', authMiddleware, filesRouter);

export default router;
