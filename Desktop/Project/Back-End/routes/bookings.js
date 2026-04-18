const express = require("express");
const { body, validationResult } = require("express-validator");
const Booking = require("../models/Booking");
const Destination = require("../models/Destination");
const { verifyToken } = require("../middleware/auth");
const logger = require("../utils/logger");

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

  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      logger.warn("Booking creation validation failed", { errors: errors.array(), userId: req.userId });
      return res.status(400).json({ errors: errors.array() });
    }

    const { destinationId, startDate, endDate, guests } = req.body;
    try {
      logger.info(`Creating booking for user: ${req.userId}, destination: ${destinationId}`);

      const destination = await Destination.findById(destinationId);
      if (!destination) {
        logger.warn(`Booking failed - destination not found: ${destinationId} for user: ${req.userId}`);
        return res.status(404).json({ error: "Destination not found" });
      }

      const start = new Date(startDate);
      const end = new Date(endDate);
      if (end < start) {
        logger.warn(`Booking failed - invalid dates for user: ${req.userId}, start: ${startDate}, end: ${endDate}`);
        return res.status(400).json({ error: "End date must be after start date" });
      }

      const booking = await Booking.create({
        user: req.userId,
        destination: destination._id,
        startDate: start,
        endDate: end,
        guests: guests || 1,
      });

      logger.info(`Booking created successfully: ${booking._id} for user: ${req.userId}`);
      res.json(booking);
    } catch (error) {
      logger.error("Error creating booking:", { error: error.message, stack: error.stack, userId: req.userId, destinationId });
      res.status(500).json({ error: "Booking creation failed" });
    }
  }
  }
);

router.get("/mine", verifyToken, async (req, res) => {
  try {
    const bookings = await Booking.find({ user: req.userId })
      .populate("destination")
      .sort("-createdAt");
    logger.info(`Retrieved ${bookings.length} bookings for user: ${req.userId}`);
    res.json(bookings);
  } catch (error) {
    logger.error("Error fetching user bookings:", { error: error.message, stack: error.stack, userId: req.userId });
    res.status(500).json({ error: "Could not load bookings" });
  }
});

module.exports = router;
