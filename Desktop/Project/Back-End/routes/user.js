const express = require("express");
const { verifyToken } = require("../middleware/auth");
const Booking = require("../models/Booking");
const User = require("../models/User");

const router = express.Router();

router.get("/dashboard", verifyToken, async (req, res) => {
  try {
    const user = await User.findById(req.userId).select("-password").populate("favorites");
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }
    const bookings = await Booking.find({ user: req.userId }).populate("destination").sort("-createdAt");
    res.json({ user, bookings });
  } catch (error) {
    res.status(500).json({ error: "Could not load dashboard" });
  }
});

module.exports = router;
