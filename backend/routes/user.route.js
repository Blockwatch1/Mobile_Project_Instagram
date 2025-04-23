import { Router } from 'express';
import bcryptjs from 'bcryptjs';
import { PrismaClient } from '../lib/generated/prisma/client.js';
const prisma = new PrismaClient();

const numberRegex = /\d/;
const uppercaseRegex = /[A-Z]/;
const specialCharacterRegex = /[@$!%*?&]/;

export const router = Router();

router.post('/signup', async (req, res) => {
  try {
    const { name, email, password, username } = req.body;

    let messages = [];

    if (!password) {
      messages.push(`Password is required`);
    } else {
      if (password.length < 8) {
        messages.push(`Password must be at least 8 characters long`);
      }
      if (!numberRegex.test(password)) {
        messages.push(`Password must contain at least one number`);
      }
      if (!uppercaseRegex.test(password)) {
        messages.push(`Password must contain at least one uppercase letter`);
      }
      if (!specialCharacterRegex.test(password)) {
        messages.push(`Password must contain at least one special character`);
      }
    }

    if (messages.length > 0) {
      return res.status(400).json({
        message: messages[0],
        success: false,
      });
    }

    const hashedPassword = await bcryptjs.hash(password, 10);
    const userExist = await prisma.user.findUnique({
      where: { email },
    });

    if (userExist) {
      console.log('User  already exists');
      return res.status(409).json({ message: 'User  already exists', success: false });
    }

    const newUser = await prisma.user.create({
      data: {
        name,
        username,
        email,
        password: hashedPassword,
      },
    });

    if (!newUser) {
      console.log('Could not create user');
      return res.status(400).json({
        message: 'Could not create user',
        success: false,
      });
    }

    res.status(201).json({
      message: 'User created',
      success: true,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      error: {
        details: err,
        description: 'Could not sign up',
      },
      data: null,
    });
  }
});
