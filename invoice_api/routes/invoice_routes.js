const express = require("express");
const multer = require("multer");
const Invoice = require("../models/invoice");
const auth = require("../middleware/auth_middleware");

const router = express.Router();
const upload = multer({ dest: "uploads" });

// Create Invoice
router.post("/", auth, upload.single("pdf"), async (req, res) => {
  const invoice = await Invoice.create({
    ...req.body,
    pdf: req.file?.path
  });

  res.status(201).json(invoice);
});

// Get with filtering + pagination
router.get("/", auth, async (req, res) => {
  const { status, page = 1, limit = 5 } = req.query;

  let filter = {};
  if (status) filter.status = status;

  const invoices = await Invoice.find(filter)
    .skip((page - 1) * limit)
    .limit(Number(limit))
    .populate("client");

  res.json(invoices);
});

module.exports = router;