const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const rateLimit = require("express-rate-limit");
const mongoose = require("mongoose");
const dotenv = require("dotenv");

dotenv.config();

const authRoutes = require("./routes/auth");
const destinationsRoutes = require("./routes/destinations");
const bookingsRoutes = require("./routes/bookings");
const favoritesRoutes = require("./routes/favorites");
const userRoutes = require("./routes/user");

const app = express();
const CLIENT_URL = process.env.CLIENT_URL || "http://localhost:5173";
const PORT = process.env.PORT || 5000;

app.use(helmet());
app.use(express.json({ limit: "10kb" }));
app.use(cors({ origin: CLIENT_URL, credentials: true }));
app.use(rateLimit({ windowMs: 15 * 60 * 1000, max: 120, standardHeaders: true, legacyHeaders: false }));

app.use("/api/auth", authRoutes);
app.use("/api/destinations", destinationsRoutes);
app.use("/api/bookings", bookingsRoutes);
app.use("/api/favorites", favoritesRoutes);
app.use("/api/user", userRoutes);

app.get("/api/status", (req, res) => {
  res.json({ status: "ok" });
});

mongoose
  .connect(process.env.MONGO_URI, {
   
  })
  .then(() => {
    console.log("Connected to MongoDB");
    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });
  })
  .catch((error) => {
    console.error("MongoDB connection failed", error);
  });
