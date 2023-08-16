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
  },
  { timestamps: true },
);

userSchema.statics.findByLogin = async function (login) {
  let user = await this.findOne({
    username: login,
  });

  return user;
};

const User = mongoose.model('User', userSchema);

export default User;
