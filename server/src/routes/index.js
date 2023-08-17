import express from 'express';
import user from './user';
import User from '../models/user';
import userSerializer from '../serializers/user';
import authenticateToken from '../token';

const router = express.Router();

router.use('/users', user);

// GET /api/me
router.get('/me', authenticateToken, async (req, res) => {
  const username = req.user.username;

  const user = await User.findOne({ username: username })
  if (!user) { return res.status(404).send({ message: 'User not found!' })}

  return res.status(200).send(userSerializer(user));
});

module.exports = router;
