const express = require("express");
const User = require("../models/User");
const Destination = require("../models/Destination");
const { verifyToken } = require("../middleware/auth");

const router = express.Router();

router.get("/", verifyToken, async (req, res) => {
  try {
    const user = await User.findById(req.userId).populate("favorites");
    res.json(user?.favorites || []);
  } catch (error) {
    res.status(500).json({ error: "Could not load favorites" });
  }
});

router.post("/:id", verifyToken, async (req, res) => {
  try {
    const destination = await Destination.findById(req.params.id);
    if (!destination) {
      return res.status(404).json({ error: "Destination not found" });
    }

    const user = await User.findById(req.userId);
    const exists = user.favorites.some((id) => id.toString() === destination._id.toString());
    if (!exists) {
      user.favorites.push(destination._id);
      await user.save();
    }
    await user.populate("favorites");
    res.json(user.favorites);
  } catch (error) {
    res.status(500).json({ error: "Could not add favorite" });
  }
});

router.delete("/:id", verifyToken, async (req, res) => {
  try {
    const user = await User.findById(req.userId);
    user.favorites = user.favorites.filter((id) => id.toString() !== req.params.id);
    await user.save();
    await user.populate("favorites");
    res.json(user.favorites);
  } catch (error) {
    res.status(500).json({ error: "Could not remove favorite" });
  }
});

module.exports = router;
