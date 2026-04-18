const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const rateLimit = require("express-rate-limit");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const morgan = require("morgan");

dotenv.config();

const logger = require("./utils/logger");

const authRoutes = require("./routes/auth");
const destinationsRoutes = require("./routes/destinations");
const bookingsRoutes = require("./routes/bookings");
const favoritesRoutes = require("./routes/favorites");
const userRoutes = require("./routes/user");

const app = express();
const CLIENT_URL = process.env.CLIENT_URL || "http://localhost:5173";
const PORT = process.env.PORT || 5000;

// Global error handler
process.on("uncaughtException", (err) => {
  logger.error("Uncaught Exception:", err);
  process.exit(1);
});

process.on("unhandledRejection", (reason, promise) => {
  logger.error("Unhandled Rejection at:", promise, "reason:", reason);
  process.exit(1);
});

// Middleware
app.use(helmet());
app.use(morgan("combined", { stream: logger.stream }));
app.use(express.json({ limit: "10kb" }));

// CORS configuration - allow all origins for development
app.use(cors({
  origin: true, // Allow all origins
  credentials: true,
  optionsSuccessStatus: 200
}));

app.use(rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 120,
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res) => {
    logger.warn(`Rate limit exceeded for IP: ${req.ip}, URL: ${req.url}`);
    res.status(429).json({ error: "Too many requests, please try again later." });
  }
}));

// Request logging middleware
app.use((req, res, next) => {
  const start = Date.now();
  res.on("finish", () => {
    const duration = Date.now() - start;
    logger.info(`${req.method} ${req.originalUrl} ${res.statusCode} - ${duration}ms`);
  });
  next();
});

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/destinations", destinationsRoutes);
app.use("/api/bookings", bookingsRoutes);
app.use("/api/favorites", favoritesRoutes);
app.use("/api/user", userRoutes);

app.get("/api/status", (req, res) => {
  logger.debug("Health check requested");
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});

// 404 handler
app.use((req, res) => {
  logger.warn(`404 - Route not found: ${req.originalUrl}`);
  res.status(404).json({ error: "Route not found" });
});

// Global error handler
app.use((err, req, res, next) => {
  logger.error("Global error handler:", {
    error: err.message,
    stack: err.stack,
    url: req.url,
    method: req.method,
    ip: req.ip,
    userAgent: req.get("User-Agent")
  });

  // Don't leak error details in production
  const isDevelopment = process.env.NODE_ENV !== "production";
  res.status(err.status || 500).json({
    error: isDevelopment ? err.message : "Internal server error",
    ...(isDevelopment && { stack: err.stack })
  });
});

// Database connection
const connectDB = async () => {
  try {
    // Try Atlas connection first
    await mongoose.connect(process.env.MONGO_URI);
    logger.info("Connected to MongoDB Atlas successfully");
  } catch (atlasError) {
    logger.warn(`MongoDB Atlas connection failed, trying local MongoDB: ${atlasError.message}`);

    try {
      // Fallback to local MongoDB
      const localUri = 'mongodb://localhost:27017/travel-platform';
      await mongoose.connect(localUri);
      logger.info("Connected to local MongoDB successfully");
    } catch (localError) {
      logger.error("Both MongoDB Atlas and local MongoDB connections failed:");
      logger.error(`Atlas error: ${atlasError.message}`);
      logger.error(`Local error: ${localError.message}`);
      logger.error("Please ensure MongoDB is running locally or check your Atlas connection.");
      process.exit(1);
    }
  }
};

connectDB().then(() => {
  app.listen(PORT, () => {
    logger.info(`Server running on port ${PORT} in ${process.env.NODE_ENV || 'development'} mode`);
  });
}).catch((error) => {
  logger.error(`Database connection setup failed: ${error.message}`);
  process.exit(1);
});
