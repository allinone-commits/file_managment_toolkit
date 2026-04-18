const express = require("express");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { body, validationResult } = require("express-validator");
const User = require("../models/User");
const { verifyToken } = require("../middleware/auth");

const router = express.Router();

const createToken = (user) => {
  return jwt.sign(
    { userId: user._id.toString(), isAdmin: user.isAdmin },
    process.env.JWT_SECRET,
    { expiresIn: "7d" }
  );
};

router.post(
  "/signup",
  [
    body("username").trim().isLength({ min: 3 }).escape(),
    body("email").isEmail().normalizeEmail(),
    body("phone").optional().trim().escape(),
    body("password").isStrongPassword({
      minLength: 8,
      minLowercase: 1,
      minUppercase: 1,
      minNumbers: 1,
      minSymbols: 1,
    }),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { username, email, phone, password, adminCode } = req.body;
    try {
      const existingUser = await User.findOne({
        $or: [{ email }, { username }, { phone }],
      });
      if (existingUser) {
        return res.status(400).json({ error: "User already exists" });
      }

      const hash = await bcrypt.hash(password, 10);
      const isAdmin = adminCode && adminCode === process.env.ADMIN_CODE;

      const user = await User.create({
        username,
        email,
        phone,
        password: hash,
        isAdmin,
      });

      res.json({
        message: "Account created successfully",
        user: { id: user._id, username: user.username, email: user.email, isAdmin: user.isAdmin }
      });
    } catch (error) {
      res.status(500).json({ error: "Signup failed" });
    }
  }
);

router.post(
  "/login",
  [
    body("identifier").trim().notEmpty().escape(),
    body("password").notEmpty(),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { identifier, password } = req.body;
    try {
      const search = identifier.toLowerCase();
      const user = await User.findOne({
        $or: [
          { email: search },
          { username: identifier },
          { phone: identifier },
        ],
      });
      if (!user) {
        return res.status(400).json({ error: "Invalid credentials" });
      }

      const isMatch = await bcrypt.compare(password, user.password);
      if (!isMatch) {
        return res.status(400).json({ error: "Invalid credentials" });
      }

      const token = createToken(user);
      res.json({ token, user: { id: user._id, username: user.username, email: user.email, isAdmin: user.isAdmin } });
    } catch (error) {
      res.status(500).json({ error: "Login failed" });
    }
  }
);

router.get("/verify-token", verifyToken, async (req, res) => {
  try {
    const user = await User.findById(req.userId).select("-password");
    if (!user) {
      return res.status(401).json({ error: "Invalid session" });
    }
    res.json({ user });
  } catch (error) {
    res.status(500).json({ error: "Session verification failed" });
  }
});

module.exports = router;
