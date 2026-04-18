const jwt = require("jsonwebtoken");

const verifyToken = (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ error: "Authentication token missing" });
  }

  const token = authHeader.split(" ")[1];
  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET);
    req.userId = payload.userId;
    req.isAdmin = payload.isAdmin;
    next();
  } catch (error) {
    return res.status(401).json({ error: "Invalid or expired token" });
  }
};

const requireAdmin = (req, res, next) => {
  if (!req.isAdmin) {
    return res.status(403).json({ error: "Admin access required" });
  }
  next();
};

module.exports = { verifyToken, requireAdmin };
