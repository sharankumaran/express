const express = require("express");
const Client = require("../models/client");  // Capital letter (model)
const auth = require("../middleware/auth_middleware");

const router = express.Router();

// Create client
router.post("/", auth, async (req, res) => {
  const newClient = await Client.create(req.body);
  res.status(201).json(newClient);
});

// Get clients
router.get("/", auth, async (req, res) => {
  const clients = await Client.find();
  res.json(clients);
});

module.exports = router;