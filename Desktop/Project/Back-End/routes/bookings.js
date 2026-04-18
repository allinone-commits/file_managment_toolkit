const express = require("express");
const { body, validationResult } = require("express-validator");
const Booking = require("../models/Booking");
const Destination = require("../models/Destination");
const { verifyToken } = require("../middleware/auth");

const router = express.Router();

router.post(
  "/",
  verifyToken,
  [
    body("destinationId").trim().notEmpty().isMongoId(),
    body("startDate").isISO8601(),
    body("endDate").isISO8601(),
    body("guests").optional().isInt({ min: 1 }),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { destinationId, startDate, endDate, guests } = req.body;
    try {
      const destination = await Destination.findById(destinationId);
      if (!destination) {
        return res.status(404).json({ error: "Destination not found" });
      }
      const start = new Date(startDate);
      const end = new Date(endDate);
      if (end < start) {
        return res.status(400).json({ error: "End date must be after start date" });
      }

      const booking = await Booking.create({
        user: req.userId,
        destination: destination._id,
        startDate: start,
        endDate: end,
        guests: guests || 1,
      });
      res.json(booking);
    } catch (error) {
      res.status(500).json({ error: "Booking creation failed" });
    }
  }
);

router.get("/mine", verifyToken, async (req, res) => {
  try {
    const bookings = await Booking.find({ user: req.userId })
      .populate("destination")
      .sort("-createdAt");
    res.json(bookings);
  } catch (error) {
    res.status(500).json({ error: "Could not load bookings" });
  }
});

module.exports = router;
