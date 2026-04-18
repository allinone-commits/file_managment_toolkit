const mongoose = require("mongoose");

const bookingSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  destination: { type: mongoose.Schema.Types.ObjectId, ref: "Destination", required: true },
  startDate: { type: Date, required: true },
  endDate: { type: Date, required: true },
  guests: { type: Number, default: 1, min: 1 },
  status: { type: String, default: "confirmed" },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model("Booking", bookingSchema);
