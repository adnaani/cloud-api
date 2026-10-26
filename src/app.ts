
import express from "express";

const app: express.Application = express();

app.get("/", (req, res) => {
  res.json({ message: "Welcome to Cloud API" });
});

app.get("/health", (req, res) => {
  res.json({
    status: "healthy",
    service: "cloud-api",
    timestamp: new Date().toISOString()
  });
});

app.get("/info", (req, res) => {
  res.json({
    name: "Cloud API",
    version: "1.0.0"
  });
});

export default app;
