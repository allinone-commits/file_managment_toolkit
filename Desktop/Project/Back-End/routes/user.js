const express = require("express");
const { verifyToken } = require("../middleware/auth");
const Booking = require("../models/Booking");
const User = require("../models/User");
const logger = require("../utils/logger");

const router = express.Router();

router.get("/dashboard", verifyToken, async (req, res) => {
  try {
    const user = await User.findById(req.userId).select("-password").populate("favorites");
    if (!user) {
      logger.warn(`Dashboard access failed - user not found: ${req.userId}`);
      return res.status(404).json({ error: "User not found" });
    }
    const bookings = await Booking.find({ user: req.userId }).populate("destination").sort("-createdAt");
    logger.info(`Dashboard loaded for user: ${user.username} (${bookings.length} bookings, ${user.favorites.length} favorites)`);
    res.json({ user, bookings });
  } catch (error) {
    logger.error("Error loading dashboard:", { error: error.message, stack: error.stack, userId: req.userId });
    res.status(500).json({ error: "Could not load dashboard" });
  }
});

module.exports = router;
