const mongoose = require("mongoose");

const invoiceSchema = new mongoose.Schema({
  client: { type: mongoose.Schema.Types.ObjectId, ref: "Client" },
  amount: Number,
  status: { type: String, default: "pending" },
  pdf: String
});
module.exports = mongoose.model("Invoice", invoiceSchema);