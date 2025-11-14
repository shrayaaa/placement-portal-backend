# 🚀 Free Deployment Guide - Render & Netlify

## Option 1: Render (Recommended for Node.js) - FREE PLAN

### Step 1: Prepare Your Repository
1. Push your code to GitHub if not already done:
```bash
git add .
git commit -m "Prepare for deployment"
git push origin main
```

### Step 2: Deploy to Render
1. Go to [render.com](https://render.com) and sign up/login
2. Click "New +" → "Web Service"
3. Connect your GitHub repository: `falgunikatekar/webway`
4. Configure the service:
   - **Name**: `webway-placement-portal`
   - **Environment**: `Node`
   - **Build Command**: `npm install`
   - **Start Command**: `npm start`
   - **Plan**: `Free` (0$/month)

### Step 3: Set Environment Variables
Add these in Render dashboard:
```
NODE_ENV=production
DB_HOST=your_database_host
DB_USER=your_database_user  
DB_PASSWORD=your_database_password
DB_NAME=placement_portal
JWT_SECRET=your_strong_secret_key_here
```

### Step 4: Free Database Options for Render
**Option A: Railway PostgreSQL (Free)**
1. Go to [railway.app](https://railway.app)
2. Create new project → Add PostgreSQL
3. Get connection details and use in Render

**Option B: PlanetScale MySQL (Free)**
1. Go to [planetscale.com](https://planetscale.com)
2. Create free database
3. Get connection string

**Option C: Aiven MySQL (Free)**
1. Go to [aiven.io](https://aiven.io)
2. Create free MySQL service
3. Use connection details

---

## Option 2: Netlify (For Static + Serverless) - FREE PLAN

### Step 1: Manual Netlify CLI Deployment
```bash
# Install Netlify CLI
npm install -g netlify-cli

# Login to Netlify
netlify login

# Deploy from your project directory
cd c:\Users\HP\Documents\GitHub\webway
netlify deploy

# For production deployment
netlify deploy --prod
```

### Step 2: Alternative - Netlify Dashboard
1. Go to [netlify.com](https://netlify.com) and login
2. Drag and drop your project folder
3. Or connect GitHub repository
4. Set build settings:
   - **Build command**: `npm install`
   - **Publish directory**: `.`
   - **Functions directory**: `netlify/functions`

### Step 3: Environment Variables for Netlify
In Netlify dashboard → Site settings → Environment variables:
```
NODE_ENV=production
DB_HOST=your_database_host
DB_USER=your_database_user
DB_PASSWORD=your_database_password
DB_NAME=placement_portal
JWT_SECRET=your_strong_secret_key
```

---

## 🎯 Quick Start Commands

### For Render:
```bash
# 1. Push to GitHub
git add .
git commit -m "Deploy to Render"
git push origin main

# 2. Go to render.com and follow steps above
```

### For Netlify:
```bash
# 1. Install and deploy
npm install -g netlify-cli
netlify login
netlify deploy --prod

# 2. Set environment variables in dashboard
```

---

## 🗄️ Free Database Solutions

### 1. Railway (Recommended)
- **Free Tier**: PostgreSQL with 500MB storage
- **Setup**: railway.app → New Project → Add PostgreSQL
- **Connection**: Get DATABASE_URL from Railway dashboard

### 2. PlanetScale
- **Free Tier**: MySQL with 1GB storage, 1 billion reads/month
- **Setup**: planetscale.com → Create database
- **Connection**: Get connection string from dashboard

### 3. Aiven
- **Free Tier**: MySQL with 1 month free trial
- **Setup**: aiven.io → Create service
- **Connection**: Get host, user, password from dashboard

### 4. Supabase (PostgreSQL)
- **Free Tier**: PostgreSQL with 500MB storage
- **Setup**: supabase.com → New project
- **Connection**: Get connection details from settings

---

## 🔧 Database Migration

Once you have a database, run these SQL commands:

```sql
-- Copy from your setup_db.sql file
CREATE DATABASE IF NOT EXISTS placement_portal;
USE placement_portal;

-- Run all your table creation scripts
-- (Copy from setup_db.sql, create_job_applications_table.sql, etc.)
```

---

## 🚨 Important Notes

### Render Free Plan Limitations:
- App sleeps after 15 minutes of inactivity
- 750 hours/month (enough for 24/7 if only one app)
- 512MB RAM, 0.1 CPU

### Netlify Free Plan Limitations:
- 100GB bandwidth/month
- 300 build minutes/month
- Functions: 125K requests/month, 100 hours runtime

### Database Considerations:
- Use connection pooling for better performance
- Consider read replicas for scaling
- Regular backups recommended

---

## 🎉 Deployment Checklist

- [ ] Code pushed to GitHub
- [ ] Environment variables configured
- [ ] Database created and connected
- [ ] SSL certificate (automatic on both platforms)
- [ ] Custom domain (optional, available on free plans)
- [ ] Test all functionality after deployment

---

## 🆘 Troubleshooting

### Common Issues:
1. **Build fails**: Check Node.js version compatibility
2. **Database connection**: Verify environment variables
3. **Functions timeout**: Optimize database queries
4. **CORS errors**: Update CORS settings in server.js

### Getting Help:
- Render: Check build logs in dashboard
- Netlify: Check function logs and build logs
- Database: Test connection strings locally first

---

**Choose Render for full Node.js apps, Netlify for static sites with serverless functions!**
