import { Router } from 'express';
import User from '../models/user';

const router = Router();

router.get('/', async (req, res) => {
  const users = await User.find();
  return res.status(200).json(users);
});

router.get('/:userId', async (req, res) => {
  const user = await User.findById(req.params.userId);
  return res.status(200).send(user);
});

// curl -X POST -H "Content-Type:application/json" http://localhost:3000/users -d '{"username":"Jason"}'
router.post('/', async (req, res) => {
  let errors = [];
  if (!req.body.username) {
    errors.push({
      field: 'username',
      message: 'Username is required.'
    });
  }

  if (errors.length > 0) { return res.status(400).json({ errors }) }

  const user = new User({
    ...req.body
  });
  const saved = await user.save();
  return res.status(201).json(saved);
});

export default router;
