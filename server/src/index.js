import 'dotenv/config';
import cors from 'cors';
import express from 'express';
import routes from './routes';
import models, { connectDb } from './models';

const app = express();
app.use(cors());
app.use(express.json());
// app.use(express.urlencoded({ extended: true }));

app.use('/api', routes)

const eraseDatabaseOnSync = true;

connectDb().then(async () => {
  if (eraseDatabaseOnSync) {
    await Promise.all([
      models.User.deleteMany({}),
    ]);

    seedData();
  }

  app.listen(process.env.PORT, () =>
    console.log(`Example app listening on port ${process.env.PORT}!`),
  );
});

// Seed Data
const seedData = async () => {
  createUsers();
}

const createUsers = async () => {
  const user = new models.User({
    username: 'juice',
    name: 'Jason',
    password: 'Password123',
  });

  await user.save();
}
