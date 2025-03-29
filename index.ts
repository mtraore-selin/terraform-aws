import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";

// Load environment variables from a .env file into process.env
dotenv.config();

// Initialize Express app
const app = express();
app.use(express.json());

// MongoDB connection
const mongoURI = process.env.MONGO_URI || "mongodb://localhost:27017/todo-app";
mongoose
  .connect(mongoURI)
  .then(() => console.log("MongoDB connected"))
  .catch((err) => console.log(err));

// Define Todo schema and model
interface ITodo {
  title: string;
  completed: boolean;
}

const todoSchema = new mongoose.Schema<ITodo>({
  title: { type: String, required: true },
  completed: { type: Boolean, default: false },
});

const Todo = mongoose.model<ITodo>("Todo", todoSchema);

// CRUD endpoints
app.get("/todos", async (req, res) => {
  const todos = await Todo.find();
  res.json(todos);
});

app.post("/todos", async (req, res) => {
  const newTodo = new Todo(req.body);
  const savedTodo = await newTodo.save();
  res.json(savedTodo);
});

app.put("/todos/:id", async (req, res) => {
  const updatedTodo = await Todo.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
  });
  res.json(updatedTodo);
});

app.delete("/todos/:id", async (req, res) => {
  await Todo.findByIdAndDelete(req.params.id);
  res.json({ message: "Todo deleted" });
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
