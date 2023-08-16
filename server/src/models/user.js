import mongoose from 'mongoose';
import { v4 as uuidv4 } from 'uuid';

const userSchema = new mongoose.Schema(
  {
    _id: { type: String, default: uuidv4 },
    username: {
      type: String,
      unique: true,
      required: true,
    },
    name: {
      type: String,
      required: true,
    }
  },
  { timestamps: true },
);

const User = mongoose.model('User', userSchema);

export default User;
