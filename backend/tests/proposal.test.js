const test = require('node:test');
const assert = require('node:assert');
const http = require('http');
const express = require('express');
const jwt = require('jsonwebtoken');
const prisma = require('../src/shared/db');
const app = require('../src/app');

// Using the CommonJS build to prevent issues if default import is odd
// But wait, app.js is an ES module. In Node 24+, you can require ES modules if they are synced, but it's better to use dynamic import if it fails.
// Since bid.test.js uses `require('../src/app')` and it works (due to node 24 or some magic in this setup), we'll do the same.

const JWT_SECRET = process.env.JWT_SECRET || 'bet_jwt_super_secret_key_12345';

let server;
let port;
let baseUrl;

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
  } catch (e) {}
  return { status, body: json };
}

let sellerUser, buyerUser;
let sellerToken, buyerToken;
let testProperty;

test.before(async () => {
  // To deal with ES modules, let's dynamically import app if require fails
  let loadedApp;
  try {
    loadedApp = require('../src/app').default || require('../src/app');
  } catch (err) {
    const mod = await import('../src/app.js');
    loadedApp = mod.default;
  }

  server = http.createServer(loadedApp);
  await new Promise((resolve) => {
    server.listen(0, '127.0.0.1', () => {
      port = server.address().port;
      baseUrl = `http://127.0.0.1:${port}`;
      resolve();
    });
  });

  await prisma.user.deleteMany({
    where: { email: { in: ['propseller@test.com', 'propbuyer@test.com'] } }
  });

  sellerUser = await prisma.user.create({
    data: { email: 'propseller@test.com', passwordHash: 'hash', role: 'SELLER' }
  });
  await prisma.seller.create({ data: { id: sellerUser.id, company: 'Prop Corp' } });

  buyerUser = await prisma.user.create({
    data: { email: 'propbuyer@test.com', passwordHash: 'hash', role: 'BUYER' }
  });
  await prisma.buyer.create({ data: { id: buyerUser.id } });

  testProperty = await prisma.property.create({
    data: {
      title: 'Test Rental Proposal Property',
      description: 'A beautiful rental',
      price: 15000,
      listingType: 'FIXED',
      latitude: 0,
      longitude: 0,
      type: 'RENT',
      status: 'ACTIVE',
      ownerId: sellerUser.id
    }
  });

  sellerToken = jwt.sign({ id: sellerUser.id }, JWT_SECRET, { expiresIn: '1h' });
  buyerToken = jwt.sign({ id: buyerUser.id }, JWT_SECRET, { expiresIn: '1h' });
});

test.after(async () => {
  await prisma.user.deleteMany({
    where: { email: { in: ['propseller@test.com', 'propbuyer@test.com'] } }
  });
  await prisma.$disconnect();
  await new Promise((resolve) => server.close(resolve));
});

test('Proposals API Integration Tests', async (t) => {
  
  let proposalId;

  await t.test('1. Place a valid proposal (Buyer)', async () => {
    const { status, body } = await makeRequest(
      `/api/proposals/property/${testProperty.id}`, 
      'POST', 
      { 'Authorization': `Bearer ${buyerToken}` },
      { amount: 14000, details: 'I would like to rent this for 14k.' }
    );
    assert.strictEqual(status, 201);
    assert.strictEqual(body.success, true);
    assert.strictEqual(body.data.amount, 14000);
    assert.strictEqual(body.data.status, 'PENDING');
    proposalId = body.data.id;
  });

  await t.test('2. Get my proposals (Buyer)', async () => {
    const { status, body } = await makeRequest(
      `/api/proposals/my-proposals`, 
      'GET', 
      { 'Authorization': `Bearer ${buyerToken}` }
    );
    assert.strictEqual(status, 200);
    assert.strictEqual(body.success, true);
    assert.strictEqual(body.data.length > 0, true);
    assert.strictEqual(body.data[0].id, proposalId);
  });

  await t.test('3. Get proposals for property (Seller)', async () => {
    const { status, body } = await makeRequest(
      `/api/proposals/property/${testProperty.id}`, 
      'GET', 
      { 'Authorization': `Bearer ${sellerToken}` }
    );
    assert.strictEqual(status, 200);
    assert.strictEqual(body.success, true);
    assert.strictEqual(body.data.length > 0, true);
    assert.strictEqual(body.data[0].id, proposalId);
  });

  await t.test('4. Buyer tries to update proposal status (Should fail)', async () => {
    const { status, body } = await makeRequest(
      `/api/proposals/${proposalId}/status`, 
      'PATCH', 
      { 'Authorization': `Bearer ${buyerToken}` },
      { status: 'ACCEPTED' }
    );
    assert.strictEqual(status, 403);
  });

  await t.test('5. Seller accepts the proposal', async () => {
    const { status, body } = await makeRequest(
      `/api/proposals/${proposalId}/status`, 
      'PATCH', 
      { 'Authorization': `Bearer ${sellerToken}` },
      { status: 'ACCEPTED' }
    );
    assert.strictEqual(status, 200);
    assert.strictEqual(body.success, true);
    assert.strictEqual(body.data.status, 'ACCEPTED');

    // Verify property status changed to ENDED
    const prop = await prisma.property.findUnique({ where: { id: testProperty.id } });
    assert.strictEqual(prop.status, 'ENDED');
  });

});
