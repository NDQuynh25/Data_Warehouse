import express from "express";
import salesRouter from "./routes/sales.route";
import { connectToDB } from "./config/dbConfig";
import cors from "cors";

const app = express();
// Cấu hình CORS
app.use(cors({
  origin: "http://localhost:5173", // hoặc '*' để cho phép tất cả các domain
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],
}));
const PORT = process.env.PORT || 8000;

async function startServer() {
  try {
    await connectToDB();

    app.use(express.json());
    app.use("/sales", salesRouter);

    app.listen(PORT, () => {
      console.log(`Server running at http://localhost:${PORT}`);
    });
  } catch (error) {
    console.error("Failed to start server:", error);
  }
}

startServer();
