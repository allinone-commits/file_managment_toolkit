const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  username: { type: String, required: true, trim: true, unique: true },
  email: { type: String, required: true, trim: true, lowercase: true, unique: true },
  phone: { type: String, trim: true, unique: true, sparse: true },
  password: { type: String, required: true },
  isAdmin: { type: Boolean, default: false },
  emailVerified: { type: Boolean, default: false },
  verificationCode: { type: String },
  favorites: [{ type: mongoose.Schema.Types.ObjectId, ref: "Destination" }],
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model("User", userSchema);
