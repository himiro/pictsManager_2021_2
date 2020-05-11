import express from 'express';

import filesRouter from './files.js';

const router = express.Router();

router.get('/', async (req, res) => {
  return res.status(200).send({ message: 'Hello' });
});
router.use('/files', filesRouter);

export default router;
