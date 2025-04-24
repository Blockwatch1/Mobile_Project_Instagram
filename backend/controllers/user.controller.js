import bcryptjs from 'bcryptjs';
import { PrismaClient } from '../lib/generated/prisma/client.js';
import { generateJWT } from '../helpers/auth/jwt.js';

const prisma = new PrismaClient();

const numberRegex = /\d/;
const uppercaseRegex = /[A-Z]/;
const specialCharacterRegex = /[@$!%*?&]/;

export const signUp = async (req, res) => {
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
};

export const logIn = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await prisma.user.findUnique({
      where: { email },
    });

    if (!user) {
      return res.status(401).json({
        //Unauthorized
        message: 'Invalid email or password',
        success: false,
      });
    }

    //compare this password with the hashed password in the database
    const isPasswordValid = await bcryptjs.compare(password, user.password);

    if (!isPasswordValid) {
      return res.status(401).json({
        message: 'Invalid email or password',
        success: false,
      });
    }

    //now that the credentials are valid, we can generate a JWT to send to the client
    const token = generateJWT(user);

    //update the lastLogin value in the database
    await prisma.user.update({
      where: { userId: user.userId },
      data: {
        lastLogin: new Date(),
      },
    });

    return res.status(200).json({
      message: 'Login successful',
      success: true,
      token: token,
      user: {
        userId: user.userId,
        username: user.username,
        email: user.email,
        bio: user.bio,
      },
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      error: {
        details: err,
        description: 'Could not log in',
      },
      data: null,
    });
  }
};

export const getUserProfileInfo = async (req, res) => {
  try {
    const { userId } = req.params;

    const myUserId = req?.user;

    const couldNotFetchUserObj = {
      message: 'Could not fetch user',
      success: false,
      data: null,
    };

    const fetchedData = {
      message: 'Retreived user successfully',
      success: true,
      data: null,
    };

    if (myUserId && myUserId === userId) {
      const me = await prisma.user.findUnique({
        where: { userId: myUserId },
      });

      if (!me) return res.status(200).json(couldNotFetchUserObj);

      fetchedData.data = me;
      return res.status(200).json(fetchedData);
    } else {
      const user = await prisma.user.findUnique({
        where: { userId },
        select: {
          email: true,
          bio: true,
          createdAt: true,
          followedBy: true,
          following: true,
          name: true,
          username: true,
          posts: true,
        },
      });

      if (!user) return couldNotFetchUserObj;

      fetchedData.data = user;
      return res.status(200).json(fetchedData);
    }
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      error: {
        details: err,
        description: 'Could not retreive user information',
      },
      data: null,
    });
  }
};

export const getUsersListOnSearch = async (req, res) => {
  try {
    const { nameusername } = req.params;

    //you can search a user using either a username or a name
    const getUsersOnSearch = await prisma.user.findMany({
      where: {
        OR: [{ username: nameusername }, { name: nameusername }],
      },
      select: {
        userId: true,
        bio: true,
        pfpPath: true,
        name: true,
        username: true,
      },
    });

    if (!getUsersOnSearch) {
      return res.status(200).json({
        message: 'Could not search for users',
        success: false,
        data: null,
      });
    }

    return res.status(200).json({
      message: 'Retreived users successfully',
      success: true,
      data: getUsersOnSearch,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      error: {
        details: err,
        description: 'Could not retreive users',
      },
      data: null,
    });
  }
};

export const savePost = async (req, res) => {
  const postId = req.params;
  const user = req?.user;
  try {
    const savePost = await prisma.user.update({
      where: { userId: user?.userId },
      data: {
        savedPosts: {
          connect: {
            postId,
          },
        },
      },
    });

    if (!savePost) {
      return res.status(200).json({
        message: 'Could not save post',
        success: false,
        data: null,
      });
    }

    return res.status(200).json({
      message: 'Saved post successfully',
      success: true,
      data: savePost,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      error: {
        details: err,
        description: 'Could not save post',
      },
      data: null,
    });
  }
};
