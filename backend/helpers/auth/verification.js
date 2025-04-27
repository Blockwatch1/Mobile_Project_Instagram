import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';
dotenv.config();

const jwtSecret = process.env.JWT_SECRET;

const authMiddleware = (req, res, next) => {
  const authHeader = req.header('Authorization');
  if (!authHeader) {
    console.log('Missing token');
    return res.status(401).json({ message: 'Unauthorized: Missing Token', success: false });
  }

  const [bearer, token] = authHeader.split(' ');

  if (bearer !== 'Bearer' || !token) {
    console.log('Invalid token');
    return res.status(401).json({ message: 'Invalid token format', success: false });
  }

  jwt.verify(token, jwtSecret, (err, user) => {
    if (err) {
      console.log('Invalid token')
      console.log(token)
      return res.status(403).json({ message: 'Forbidden: Invalid Token', success: false });
    }

    req.user = user;
    next();
  });
};

export default authMiddleware;
