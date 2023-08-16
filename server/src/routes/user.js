import { Router } from 'express';
import User from '../models/user';

const router = Router();

router.get('/', async (req, res) => {
  const users = await User.find();
  return res.status(200).json(users);
});

router.get('/:userId', (req, res) => {
  return res.send(`User ${req.params.userId}`);
});

export default router;
