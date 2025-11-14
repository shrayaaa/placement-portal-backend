# 🚀 PlanetScale MySQL Setup Guide

## Step 1: Create PlanetScale Account
1. Go to [planetscale.com](https://planetscale.com)
2. Click "Sign up" → "Continue with GitHub"
3. Authorize PlanetScale to access your GitHub

## Step 2: Create Database
1. Click "Create database"
2. Database name: `ccoew-placement-portal`
3. Region: Select closest to you (e.g., US East, Asia)
4. Click "Create database"

## Step 3: Get Connection Details
1. Go to your database dashboard
2. Click "Connect" button
3. Select "General" → "MySQL"
4. Copy the connection details:

```
Host: aws.connect.psdb.cloud
Username: [your_username]
Password: [your_password]
Database: ccoew-placement-portal
```

## Step 4: Your Environment Variables
Use these exact values in Render:

```
NODE_ENV=production
DB_HOST=aws.connect.psdb.cloud
DB_USER=[paste_your_username_here]
DB_PASSWORD=[paste_your_password_here]
DB_NAME=ccoew-placement-portal
JWT_SECRET=a1b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef123456789012345678901234567890abcdef1234567890abcdef12345678901234
```

## Step 5: Import Your Database Schema
1. In PlanetScale dashboard, click "Console"
2. Copy and paste your SQL files:
   - First: `setup_db.sql`
   - Then: `create_job_applications_table.sql`
3. Run each SQL script

## Step 6: Deploy to Render
1. Go to [render.com](https://render.com)
2. New → Web Service
3. Connect GitHub: `shrayaaa/T-and-P-CCOEWN`
4. Settings:
   - Build Command: `npm install`
   - Start Command: `npm start`
   - Plan: Free
5. Add the environment variables from Step 4

## ✅ Why PlanetScale?
- ✅ 1GB storage free
- ✅ 1 billion reads/month
- ✅ 10 million writes/month
- ✅ Built by ex-YouTube engineers
- ✅ Automatic backups
- ✅ SSL encryption
- ✅ No credit card required

Your website will be live in ~5 minutes after deployment!
