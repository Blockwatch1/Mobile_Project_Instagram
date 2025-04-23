import jwt from 'jsonwebtoken';

const jwtSecret = process.env.JWT_SECRET;

const authMiddleware = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (token == null) {
    return res.status(401).json({
      message: 'Authentication token required',
      success: false,
    });
  }

  jwt.verify(token, jwtSecret, (err, decodedPayload) => {
    if (err) {
      console.error('JWT Verification Error: ', err.message);

      return res.status(403).json({
        message: 'Invalid or expired token',
        success: false,
      });
    }

    req.user = decodedPayload;

    next();
  });
};

export default authMiddleware;
