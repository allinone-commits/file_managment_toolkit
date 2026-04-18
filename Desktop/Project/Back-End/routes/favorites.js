const express = require("express");
const User = require("../models/User");
const Destination = require("../models/Destination");
const { verifyToken } = require("../middleware/auth");
const logger = require("../utils/logger");

const router = express.Router();

router.get("/", verifyToken, async (req, res) => {
  try {
    const user = await User.findById(req.userId).populate("favorites");
    const favorites = user?.favorites || [];
    logger.info(`Retrieved ${favorites.length} favorites for user: ${req.userId}`);
    res.json(favorites);
  } catch (error) {
    logger.error("Error fetching favorites:", { error: error.message, stack: error.stack, userId: req.userId });
    res.status(500).json({ error: "Could not load favorites" });
  }
});

router.post("/:id", verifyToken, async (req, res) => {
  try {
    const destination = await Destination.findById(req.params.id);
    if (!destination) {
      logger.warn(`Add favorite failed - destination not found: ${req.params.id} for user: ${req.userId}`);
      return res.status(404).json({ error: "Destination not found" });
    }

    const user = await User.findById(req.userId);
    const exists = user.favorites.some((id) => id.toString() === destination._id.toString());
    if (!exists) {
      user.favorites.push(destination._id);
      await user.save();
      logger.info(`Added favorite: ${destination.name} for user: ${req.userId}`);
    } else {
      logger.debug(`Favorite already exists: ${destination.name} for user: ${req.userId}`);
    }
    await user.populate("favorites");
    res.json(user.favorites);
  } catch (error) {
    logger.error("Error adding favorite:", { error: error.message, stack: error.stack, userId: req.userId, destinationId: req.params.id });
    res.status(500).json({ error: "Could not add favorite" });
  }
});

router.delete("/:id", verifyToken, async (req, res) => {
  try {
    const user = await User.findById(req.userId);
    const originalCount = user.favorites.length;
    user.favorites = user.favorites.filter((id) => id.toString() !== req.params.id);
    await user.save();
    await user.populate("favorites");

    if (user.favorites.length < originalCount) {
      logger.info(`Removed favorite: ${req.params.id} for user: ${req.userId}`);
    } else {
      logger.debug(`Favorite not found for removal: ${req.params.id} for user: ${req.userId}`);
    }

    res.json(user.favorites);
  } catch (error) {
    logger.error("Error removing favorite:", { error: error.message, stack: error.stack, userId: req.userId, destinationId: req.params.id });
    res.status(500).json({ error: "Could not remove favorite" });
  }
});

module.exports = router;
