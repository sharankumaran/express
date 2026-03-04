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
  try {
    const status = req.query.status;
    const page = Number(req.query.page) || 1;
    const limit = Number(req.query.limit) || 5;

    let filter = {};
    if (status) filter.status = status;

    const invoices = await Invoice.find(filter)
      .skip((page - 1) * limit)
      .limit(limit)
      .populate("client");

    res.json(invoices);

  } catch (err) {
    console.log("INVOICE GET ERROR:", err);
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;