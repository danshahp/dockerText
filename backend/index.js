const express = require('express');
const path = require('path');
const { Pool } = require('pg');

const app = express();
const PORT = process.env.PORT || 3000;

// PostgreSQL connection setup
const pool = new Pool({
  user: process.env.PG_USER || 'myuser',
  host: process.env.PG_HOST || 'postgres',
  database: process.env.PG_DATABASE || 'mydb',
  password: process.env.PG_PASSWORD || 'mypassword',
  port: process.env.PG_PORT || 5432,
  ssl: false // Set to true if using remote/secured Postgres
});

// Create users table if it doesn't exist
(async () => {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        name TEXT NOT NULL
      )
    `);
    console.log("✅ Users table ready.");
  } catch (err) {
    console.error("❌ Error setting up database:", err);
  }
})();

// Serve frontend files
const frontendPath = path.join(__dirname, '../frontend');
app.use(express.static(frontendPath));

// Example API
app.get('/api/users', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM users');
    res.json(result.rows);
  } catch (err) {
    console.error("❌ Query error:", err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.listen(PORT, () => {
  console.log(`🚀 Server running at http://localhost:${PORT}`);
});
