const express = require("express");
const dotenv = require("dotenv");
const cors = require("cors");
const morgan = require("morgan");
const helmet = require("helmet");

dotenv.config();

require("./invoice_api/config/db");

const app = express();

// Middlewares
app.use(express.json());
app.use(cors()); // ✅ FIXED
app.use(morgan("dev"));
app.use(helmet());

// Test route (IMPORTANT for checking)
app.get("/", (req, res) => {
  res.send("Backend is working 🚀");
});

// Routes
app.use("/api/auth", require("./invoice_api/routes/auth"));
app.use("/api/clients", require("./invoice_api/routes/client_routes"));
app.use("/api/invoices", require("./invoice_api/routes/invoice_routes"));
app.use("/uploads", express.static("uploads"));

// Error middleware
app.use(require("./invoice_api/middleware/error_middleware"));

app.listen(process.env.PORT || 3000, () => {
  console.log("Server running on port", process.env.PORT);
});