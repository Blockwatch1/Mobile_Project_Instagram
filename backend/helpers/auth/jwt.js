import jwt from 'jsonwebtoken';

export const generateJWT = (user) => {
  const token = jwt.sign(
    { userId: user.userId, email: user.email, username: user.username },
    process.env.JWT_SECRET,
    { expiresIn: '7d' },
  );

  return token;
};
