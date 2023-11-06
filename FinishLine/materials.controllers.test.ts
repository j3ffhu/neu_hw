const request = require('supertest');
const express = require('express');
const app = express();

app.use(express.urlencoded({ extended: false }));

test('materisal not found', async () => {
  const response = await request(app).post('/materials/10/delete').set('Authorization', 3);

  expect(response.statusCode).toBe(404);
});

test('Leadership required to delete', async () => {
  const response = await request(app).post('/materials/100/delete').set('Authorization', 7);

  expect(response.statusCode).toBe(403);
});
