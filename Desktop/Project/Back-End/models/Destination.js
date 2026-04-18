const mongoose = require("mongoose");

const destinationSchema = new mongoose.Schema({
  name: { type: String, required: true, trim: true },
  location: { type: String, required: true, trim: true },
  description: { type: String, required: true, trim: true },
  image: { type: String, default: "https://via.placeholder.com/640x360" },
  price: { type: Number, required: true, min: 0 },
  duration: { type: String, default: "3 days" },
  tags: [{ type: String, trim: true }],
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model("Destination", destinationSchema);
