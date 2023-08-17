import jwt from 'jsonwebtoken';

function authenticateToken(req, res, next) {
  // console.log('Authenticating token')
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (token == null) return res.sendStatus(401);

  jwt.verify(token, process.env.SECRET_TOKEN, (err, user) => {
    if (err) {
      console.log("error:", err);
      return res.sendStatus(403);
    }

    req.user = user;

    next();
  });
}

export default authenticateToken;
