import { Router } from 'express';

const router = Router();

router.get('/', (req, res) => {
  return res.send("Users");
});

router.get('/:userId', (req, res) => {
  return res.send(`User ${req.params.userId}`);
});

export default router;
