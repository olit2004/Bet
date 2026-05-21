const test = require('node:test');
const assert = require('node:assert');
const http = require('http');
const express = require('express');
const jwt = require('jsonwebtoken');
const prisma = require('../src/shared/db');
const app = require('../src/app');

const JWT_SECRET = process.env.JWT_SECRET || 'bet_jwt_super_secret_key_12345';

let server;
let port;
let baseUrl;

// Helper to make fetch requests
async function makeRequest(path, method = 'GET', headers = {}, body = null) {
  const options = { method, headers: { ...headers } };
  if (body) {
    options.headers['Content-Type'] = 'application/json';
    options.body = JSON.stringify(body);
  }
  
  const res = await fetch(`${baseUrl}${path}`, options);
  const status = res.status;
  const text = await res.text();
  let json = {};
  try {
    json = JSON.parse(text);
  } catch (e) {
    // ignore
  }
  return { status, body: json };
}

let sellerUser, buyer1User, buyer2User;
let sellerToken, buyer1Token, buyer2Token;
let testProperty;

test.before(async () => {
  server = http.createServer(app);
  await new Promise((resolve) => {
    server.listen(0, '127.0.0.1', () => {
      port = server.address().port;
      baseUrl = `http://127.0.0.1:${port}`;
      resolve();
    });
  });

  // Clean up existing DB artifacts based on emails
  await prisma.user.deleteMany({
    where: { email: { in: ['seller@test.com', 'buyer1@test.com', 'buyer2@test.com'] } }
  });

  // Create Users & Roles
  sellerUser = await prisma.user.create({
    data: { email: 'seller@test.com', passwordHash: 'hash', role: 'SELLER' }
  });
  await prisma.seller.create({ data: { id: sellerUser.id, company: 'Test Corp' } });

  buyer1User = await prisma.user.create({
    data: { email: 'buyer1@test.com', passwordHash: 'hash', role: 'BUYER' }
  });
  await prisma.buyer.create({ data: { id: buyer1User.id } });

  buyer2User = await prisma.user.create({
    data: { email: 'buyer2@test.com', passwordHash: 'hash', role: 'BUYER' }
  });
  await prisma.buyer.create({ data: { id: buyer2User.id } });

  // Create active auction property
  testProperty = await prisma.property.create({
    data: {
      title: 'Test Auction Mansion',
      description: 'A beautiful mansion',
      price: 100000, // Starting price
      listingType: 'AUCTION',
      latitude: 0,
      longitude: 0,
      type: 'SALE',
      status: 'ACTIVE',
      ownerId: sellerUser.id
    }
  });

  // Generate Tokens
  sellerToken = jwt.sign({ id: sellerUser.id }, JWT_SECRET, { expiresIn: '1h' });
  buyer1Token = jwt.sign({ id: buyer1User.id }, JWT_SECRET, { expiresIn: '1h' });
  buyer2Token = jwt.sign({ id: buyer2User.id }, JWT_SECRET, { expiresIn: '1h' });
});

test.after(async () => {
  await prisma.user.deleteMany({
    where: { email: { in: ['seller@test.com', 'buyer1@test.com', 'buyer2@test.com'] } }
  });
  await prisma.$disconnect();
  await new Promise((resolve) => server.close(resolve));
});

test('Bidding API Integration Tests', async (t) => {
  
  let bid1Id;
  let bid2Id;

  await t.test('1. Place a valid bid (Buyer 1)', async () => {
    const { status, body } = await makeRequest(
      `/api/properties/${testProperty.id}/bids`, 
      'POST', 
      { 'Authorization': `Bearer ${buyer1Token}` },
      { amount: 150000 }
    );
    assert.strictEqual(status, 201);
    assert.strictEqual(body.status, 'success');
    assert.strictEqual(body.data.amount, 150000);
    bid1Id = body.data.id;
  });

  await t.test('2. Place a bid that is too low (Buyer 2)', async () => {
    const { status, body } = await makeRequest(
      `/api/properties/${testProperty.id}/bids`, 
      'POST', 
      { 'Authorization': `Bearer ${buyer2Token}` },
      { amount: 120000 } // Lower than 150000
    );
    assert.strictEqual(status, 400);
    assert.match(body.message, /must be greater/);
  });

  await t.test('3. Place a higher bid and trigger OUTBID notification (Buyer 2)', async () => {
    const { status, body } = await makeRequest(
      `/api/properties/${testProperty.id}/bids`, 
      'POST', 
      { 'Authorization': `Bearer ${buyer2Token}` },
      { amount: 200000 }
    );
    assert.strictEqual(status, 201);
    bid2Id = body.data.id;

    // Check notification for Buyer 1
    const notifs = await prisma.notification.findMany({ where: { userId: buyer1User.id } });
    assert.strictEqual(notifs.length, 1);
    assert.strictEqual(notifs[0].type, 'OUTBID');
  });

  await t.test('4. Seller tries to place a bid (Should fail - Role Restrict)', async () => {
    const { status, body } = await makeRequest(
      `/api/properties/${testProperty.id}/bids`, 
      'POST', 
      { 'Authorization': `Bearer ${sellerToken}` },
      { amount: 250000 }
    );
    assert.strictEqual(status, 403);
    assert.match(body.message, /do not have permission/);
  });

  await t.test('5. Retract bid (Buyer 1 retracts their outbid bid)', async () => {
    const { status, body } = await makeRequest(
      `/api/bids/${bid1Id}/retract`, 
      'PATCH', 
      { 'Authorization': `Bearer ${buyer1Token}` }
    );
    assert.strictEqual(status, 200);
    assert.strictEqual(body.data.status, 'RETRACTED');
  });

  await t.test('6. Accept highest bid (Seller accepts Buyer 2)', async () => {
    const { status, body } = await makeRequest(
      `/api/bids/${bid2Id}/accept`, 
      'PATCH', 
      { 'Authorization': `Bearer ${sellerToken}` }
    );
    assert.strictEqual(status, 200);
    assert.strictEqual(body.data.status, 'ACCEPTED');

    // Verify property status changed to ENDED
    const prop = await prisma.property.findUnique({ where: { id: testProperty.id } });
    assert.strictEqual(prop.status, 'ENDED');
  });

});
