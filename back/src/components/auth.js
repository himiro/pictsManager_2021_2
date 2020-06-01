import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';
import express from 'express';
const router = express.Router();

import config from '../config/index.js';
import db from '../services/database.js';
import { createDirectory } from './files.js';

const authMiddleware = async (req, res, next) => {
  const token = req.get('Authorization');
  console.log(token)
  if (!token || token.length === 0) {
    return res.status(401).send({ message: 'Missing JWT' });
  }
  try {
    let { email } = jwt.verify(token, config.jwtSecret);
    console.log(email);
    const matching = await db.find({ email });
    if (matching.length === 0) {
      return res.status(404).send({ message: 'JWT valid but user does not exist' });
    }
    res.locals.user = matching[0];
    return next();
  } catch (err) {
    return res.status(401).send({ message: 'Invalid JWT' });
  }
}

router.post('/signin', async (req, res, next) => {
  try {
    if (!req.body.email || typeof(req.body.email) !== 'string' || req.body.email.length <= 0) {
      return res.status(400).send({ message: 'Missing email' });
    }
    if (!req.body.password || typeof(req.body.password) !== 'string' || req.body.password.length <= 0) {
      return res.status(400).send({ message: 'Missing password' });
    }
    const matching = await db.find({ email: req.body.email });
    if (matching.length === 0) {
      return res.status(404).send({ message: 'No account found for this email address' });
    }
    const user = matching[0]
    const match = bcrypt.compareSync(req.body.password, user.password);
    if (match) {
      let token = jwt.sign({ email: user.email }, config.jwtSecret);
      return res.status(200).send({ token });
    } else {
      return res.status(401).send({ message: 'Incorrect password' });
    }
  } catch (err) {
    return res.status(500).send(err);
  }
})

router.post('/signup', async (req, res, next) => {
  try {
    if (!req.body.email || typeof(req.body.email) !== 'string' || req.body.email.length <= 0) {
      return res.status(400).send({ message: 'Missing email' });
    }
    if (!req.body.password || typeof(req.body.password) !== 'string' || req.body.password.length <= 0) {
      return res.status(400).send({ message: 'Missing password' });
    }
    const email = req.body.email.trim();
    const matching = await db.find({ email });
    if (matching.length > 0) {
      return res.status(401).send({ message: 'An account already exists for this email address' });
    }
    let password = await bcrypt.hash(req.body.password, config.authSaltRounds);
    await db.insert({
      email,
      password,
    })
    createDirectory(email);
    return res.status(201).send({ message: 'Account successfully created' });
  } catch (err) {
    return res.status(500).send(err);
  }
})

export default router;
export {
  authMiddleware,
}
