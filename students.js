const express = require("express");
const bcrypt = require("bcryptjs");
const db = require("../db");

const router = express.Router();

// Register student
router.post("/register", (req, res) => {
  const { name, email, password } = req.body;

  // Hash password
  const hashedPassword = bcrypt.hashSync(password, 8);

  db.query(
    "INSERT INTO students (name, email, password) VALUES (?, ?, ?)",
    [name, email, hashedPassword],
    (err, result) => {
      if (err) return res.status(500).send(err);
      res.send("Student registered successfully ✅");
    }
  );
});

// Login student
router.post("/login", (req, res) => {
  const { email, password } = req.body;

  db.query("SELECT * FROM students WHERE email = ?", [email], (err, results) => {
    if (err) return res.status(500).send(err);
    if (results.length === 0) return res.status(404).send("Student not found");

    const student = results[0];
    const isValid = bcrypt.compareSync(password, student.password);

    if (!isValid) return res.status(401).send("Invalid password");

    res.send("Login successful 🎉");
  });
});

module.exports = router;
