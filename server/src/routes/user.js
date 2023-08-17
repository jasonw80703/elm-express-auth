import { Router } from 'express';
import User from '../models/user';
import userSerializer from '../serializers/user';
import jwt from 'jsonwebtoken';

const router = Router();

// GET all users
// router.get('/', async (req, res) => {
//   const users = await User.find();
//   return res.status(200).json(
//     users.map(userSerializer)
//   );
// });

// GET user by id
// router.get('/:userId', async (req, res) => {
//   const user = await User.findById(req.params.userId);
//   if (!user) { return res.status(404).send({ message: 'User not found!' })}

//   return res.status(200).send(userSerializer(user));
// });

// Login with username and password
// TODO: move to index?
router.post('/login', async (req, res) => {
  let errors = [];
  if (!req.body.username) {
    errors.push({
      field: 'username',
      message: 'Username is required.',
    });
  }

  if (!req.body.password) {
    errors.push({
      field: 'password',
      message: 'Password is required.',
    });
  }

  if (errors.length > 0) { return res.status(400).json({ errors }) }

  const user = await User.findOne({ username: req.body.username });
  if (!user) { return res.status(404).send({ message: 'User not found!' })}

  user.comparePassword(req.body.password, (err, isMatch) => {
    if (err) {
      return res.status(500).send(err);
    }

    if (isMatch) {
      return res.status(200).send(userSerializer(user));
    } else {
      return res.status(401).send({ message: 'Invalid username or password.' })
    }
  });
});

// POST Create User
// curl -X POST -H "Content-Type:application/json" http://localhost:3000/api/users/sign-up -d '{"username":"juice","name":"Jason"}'
router.post('/sign-up', async (req, res) => {
  let errors = [];
  if (!req.body.username) {
    errors.push({
      field: 'username',
      message: 'Username is required.',
    });
  }

  if (!req.body.name) {
    errors.push({
      field: 'name',
      message: 'Name is required.',
    });
  }

  if (!req.body.password) {
    errors.push({
      field: 'password',
      message: 'Password is required.',
    });
  }

  if (errors.length > 0) { return res.status(400).json({ errors }) }

  if (await User.findOne({ username: req.body.username })) {
    return res.status(400).json({
      errors: [{
        field: 'username',
        message: 'Username already exists.',
      }]
    });
  }

  const user = new User({
    ...req.body
  });
  const saved = await user.save();
  const token = generateAccessToken({ username: user.username });
  return res.status(201).json({
    token: token
  });
});

// https://www.digitalocean.com/community/tutorials/nodejs-jwt-expressjs
const generateAccessToken = (username) => {
  return jwt.sign(username, process.env.SECRET_TOKEN, { expiresIn: '1800s' });
}

export default router;
