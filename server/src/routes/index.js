import express from 'express';
import user from './user';

const router = express.Router();

router.use('/users', user)

module.exports = router
