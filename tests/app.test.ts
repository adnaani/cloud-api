import { test } from "node:test";
import assert from "node:assert/strict";
import request from "supertest";
import app from "../src/app.js";

test("GET /health returns a healthy status", async () => {
  const response = await request(app).get("/health");

  assert.equal(response.status, 200);
  assert.equal(response.body.status, "healthy");
  assert.equal(response.body.service, "cloud-api");
  assert.equal(Number.isNaN(Date.parse(response.body.timestamp)), false);
});

test("GET / returns a welcome message", async () => {
  const response = await request(app).get("/");

  assert.equal(response.status, 200);
  assert.equal(response.body.message, "Welcome to Cloud API");
});

test("GET /info returns application information", async () => {
  const response = await request(app).get("/info");

  assert.equal(response.status, 200);
  assert.equal(response.body.name, "Cloud API");
  assert.equal(response.body.version, "1.0.0");
});
