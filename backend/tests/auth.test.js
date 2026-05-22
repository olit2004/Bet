const test = require('node:test');
const assert = require('node:assert');
const http = require('http');
const express = require('express');
const jwt = require('jsonwebtoken');
const prisma = require('../src/shared/db');
const { protect, restrictTo } = require('../src/auth/auth.middleware');
const errorMiddleware = require('../src/shared/error.middleware');

const JWT_SECRET = process.env.JWT_SECRET || 'bet_jwt_super_secret_key_12345';

// Define a test app with correct middleware order
const testApp = express();
testApp.use(express.json());

// Public health endpoint
testApp.get('/api/health', (req, res) => {
  res.status(200).json({ status: 'success', message: 'Bet API is running.' });
});

// Protected mock endpoints
testApp.get('/api/test-protected', protect, (req, res) => {
  res.status(200).json({ status: 'success', user: req.user });
});

testApp.get('/api/test-admin-only', protect, restrictTo('ADMIN'), (req, res) => {
  res.status(200).json({ status: 'success', message: 'Admin access granted' });
});

// Global error handler must be mounted AFTER all routes
testApp.use(errorMiddleware);

let server;
let port;
let baseUrl;

// Helper to make fetch requests
async function makeRequest(path, headers = {}) {
  const res = await fetch(`${baseUrl}${path}`, { headers });
  const status = res.status;
  const text = await res.text();
  let body = {};
  try {
    body = JSON.parse(text);
  } catch (e) {
    console.error(`Failed to parse response body as JSON. Text was: "${text}"`);
  }
  return { status, body };
}

test.before(async () => {
  // Start server on a random port
  server = http.createServer(testApp);
  await new Promise((resolve) => {
    server.listen(0, '127.0.0.1', () => {
      port = server.address().port;
      baseUrl = `http://127.0.0.1:${port}`;
      resolve();
    });
  });

  // Clean up any existing test users in DB (just in case)
  await prisma.user.deleteMany({
    where: { email: { in: ['test-guest@example.com', 'test-admin@example.com', 'test-buyer@example.com'] } }
  });
});

test.after(async () => {
  // Clean up database
  await prisma.user.deleteMany({
    where: { email: { in: ['test-guest@example.com', 'test-admin@example.com', 'test-buyer@example.com'] } }
  });
  await prisma.$disconnect();

  // Close server
  await new Promise((resolve) => server.close(resolve));
});

test('Auth Middleware Integration Tests', async (t) => {
  // Create some test users
  const guestUser = await prisma.user.create({
    data: {
      email: 'test-guest@example.com',
      passwordHash: 'dummyhash',
      role: 'GUEST',
    }
  });

  const adminUser = await prisma.user.create({
    data: {
      email: 'test-admin@example.com',
      passwordHash: 'dummyhash',
      role: 'ADMIN',
    }
  });

  // Generate tokens
  const validGuestToken = jwt.sign({ id: guestUser.id }, JWT_SECRET, { expiresIn: '1h' });
  const validAdminToken = jwt.sign({ id: adminUser.id }, JWT_SECRET, { expiresIn: '1h' });
  const expiredToken = jwt.sign({ id: guestUser.id }, JWT_SECRET, { expiresIn: '-1s' });
  const invalidToken = 'this.is.an.invalid.token';

  await t.test('1. Public Endpoint - Health Check (should pass without token)', async () => {
    const { status, body } = await makeRequest('/api/health');
    assert.strictEqual(status, 200);
    assert.strictEqual(body.status, 'success');
  });

  await t.test('2. Protected Endpoint - No token (should return 401)', async () => {
    const { status, body } = await makeRequest('/api/test-protected');
    assert.strictEqual(status, 401);
    assert.match(body.message, /not authorized/i);
  });

  await t.test('3. Protected Endpoint - Invalid token (should return 401)', async () => {
    const { status, body } = await makeRequest('/api/test-protected', {
      'Authorization': `Bearer ${invalidToken}`
    });
    assert.strictEqual(status, 401);
    assert.match(body.message, /invalid or expired/i);
  });

  await t.test('4. Protected Endpoint - Expired token (should return 401)', async () => {
    const { status, body } = await makeRequest('/api/test-protected', {
      'Authorization': `Bearer ${expiredToken}`
    });
    assert.strictEqual(status, 401);
    assert.match(body.message, /invalid or expired/i);
  });

  await t.test('5. Protected Endpoint - Valid token (should return 200)', async () => {
    const { status, body } = await makeRequest('/api/test-protected', {
      'Authorization': `Bearer ${validGuestToken}`
    });
    assert.strictEqual(status, 200);
    assert.strictEqual(body.status, 'success');
    assert.strictEqual(body.user.email, 'test-guest@example.com');
  });

  await t.test('6. Role Authorization - Insufficient role (should return 403)', async () => {
    const { status, body } = await makeRequest('/api/test-admin-only', {
      'Authorization': `Bearer ${validGuestToken}`
    });
    assert.strictEqual(status, 403);
    assert.match(body.message, /do not have permission/i);
  });

  await t.test('7. Role Authorization - Correct role (should pass with 200)', async () => {
    const { status, body } = await makeRequest('/api/test-admin-only', {
      'Authorization': `Bearer ${validAdminToken}`
    });
    assert.strictEqual(status, 200);
    assert.strictEqual(body.status, 'success');
    assert.strictEqual(body.message, 'Admin access granted');
  });
});
