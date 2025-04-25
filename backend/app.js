import express from 'express';
import cors from 'cors';
import { router as userRouter } from './routes/user.route.js';
import { router as postRouter } from './routes/post.route.js';
import { router as commentRouter } from './routes/comment.route.js';

// --- Configuration ---
const app = express();
const port = process.env.PORT || 3000; //it must be 4001

// --- Middleware ---

app.use(cors());

app.use(express.json()); //this is to parse objects coming from the request to json to work with it in ts

app.use(express.urlencoded({ extended: true }));

// --- Routes ---
app.use('/user', userRouter);
app.use('/post', postRouter);
app.use('/comment', commentRouter);

// --- Server Startup ---
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
  console.log(`Access it at http://localhost:${port}`);
});
