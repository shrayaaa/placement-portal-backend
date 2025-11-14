const mysql = require("mysql2");

// Create a connection pool (better than single connection)
const db = mysql.createPool({
  host: "localhost",     // MySQL server (localhost if installed locally)
  user: "root",          // Your MySQL username
  password: "yourpassword", // Your MySQL password
  database: "placement_portal" // Database name
});

module.exports = db;
