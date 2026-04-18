const express = require("express");
const { body, validationResult } = require("express-validator");
const Destination = require("../models/Destination");
const { verifyToken, requireAdmin } = require("../middleware/auth");
const logger = require("../utils/logger");

const router = express.Router();

router.get("/", async (req, res) => {
  try {
    const list = await Destination.find().sort("name");
    logger.info(`Retrieved ${list.length} destinations`);
    res.json(list);
  } catch (error) {
    logger.error("Error fetching destinations:", { error: error.message, stack: error.stack });
    res.status(500).json({ error: "Could not load destinations" });
  }
});

router.get("/:id", async (req, res) => {
  try {
    const destination = await Destination.findById(req.params.id);
    if (!destination) {
      logger.warn(`Destination not found: ${req.params.id}`);
      return res.status(404).json({ error: "Destination not found" });
    }
    logger.debug(`Retrieved destination: ${destination.name} (ID: ${destination._id})`);
    res.json(destination);
  } catch (error) {
    logger.error("Error fetching destination:", { error: error.message, stack: error.stack, id: req.params.id });
    res.status(500).json({ error: "Destination fetch failed" });
  }
});

router.post(
  "/",
  verifyToken,
  requireAdmin,
  [
    body("name").trim().notEmpty().escape(),
    body("location").trim().notEmpty().escape(),
    body("description").trim().notEmpty().escape(),
    body("price").isFloat({ min: 0 }),
    body("duration").optional().trim().escape(),
    body("image").optional().trim(),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      logger.warn("Destination creation validation failed", { errors: errors.array(), userId: req.userId });
      return res.status(400).json({ errors: errors.array() });
    }

    const { name, location, description, price, duration, image, tags } = req.body;
    try {
      logger.info(`Creating destination: ${name} by user: ${req.userId}`);

      const destination = await Destination.create({
        name,
        location,
        description,
        price,
        duration: duration || "3 days",
        image: image || "https://via.placeholder.com/640x360",
        tags: Array.isArray(tags) ? tags.map((tag) => tag.trim()) : [],
      });

      logger.info(`Destination created successfully: ${destination.name} (ID: ${destination._id})`);
      res.json(destination);
    } catch (error) {
      logger.error("Error creating destination:", { error: error.message, stack: error.stack, name, userId: req.userId });
      res.status(500).json({ error: "Could not add destination" });
    }
  }
  }
);

module.exports = router;
