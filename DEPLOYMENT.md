# 🚀 Webway Placement Portal - Deployment Guide

This guide covers multiple deployment options for the Webway Placement Portal.

## 📋 Prerequisites

- Node.js (v14 or higher)
- MySQL Database
- Git
- Basic knowledge of server administration

## 🏗️ Project Structure

```
webway/
├── server.js              # Main server file
├── package.json           # Dependencies and scripts
├── env.example           # Environment variables template
├── uploads/              # File uploads directory
├── *.html               # Frontend pages
└── DEPLOYMENT.md        # This file
```

## 🔧 Local Development Setup

### 1. Clone and Install
```bash
git clone https://github.com/falgunikatekar/webway.git
cd webway
npm install
```

### 2. Environment Configuration
```bash
# Copy environment template
cp env.example .env

# Edit .env with your settings
nano .env
```

### 3. Database Setup
```sql
-- Create database
CREATE DATABASE placement_portal;

-- Create user (optional)
CREATE USER 'webway_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON placement_portal.* TO 'webway_user'@'localhost';
FLUSH PRIVILEGES;
```

### 4. Run Development Server
```bash
npm run dev
```

## 🌐 Production Deployment Options

### Option 1: VPS/Cloud Server (Recommended)

#### A. DigitalOcean/AWS/Linode

1. **Server Setup**
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install MySQL
sudo apt install mysql-server -y
sudo mysql_secure_installation

# Install Nginx (for reverse proxy)
sudo apt install nginx -y

# Install PM2 (process manager)
sudo npm install -g pm2
```

2. **Deploy Application**
```bash
# Clone repository
git clone https://github.com/falgunikatekar/webway.git
cd webway

# Install dependencies
npm install --production

# Create environment file
cp env.example .env
nano .env
```

3. **Configure Environment (.env)**
```env
# Production Database
DB_HOST=localhost
DB_USER=webway_user
DB_PASSWORD=your_secure_password
DB_NAME=placement_portal

# Server Configuration
PORT=5000
NODE_ENV=production

# JWT Secret (generate strong secret)
JWT_SECRET=your_very_strong_jwt_secret_here

# File Upload
UPLOAD_DIR=uploads
MAX_FILE_SIZE=5242880

# CORS
CORS_ORIGIN=https://yourdomain.com
```

4. **Database Setup**
```sql
-- Create production database
CREATE DATABASE placement_portal;
CREATE USER 'webway_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON placement_portal.* TO 'webway_user'@'localhost';
FLUSH PRIVILEGES;
```

5. **Nginx Configuration**
```nginx
# /etc/nginx/sites-available/webway
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;

    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # Serve static files directly
    location /uploads {
        alias /path/to/webway/uploads;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

6. **Enable Site and Start Services**
```bash
# Enable Nginx site
sudo ln -s /etc/nginx/sites-available/webway /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# Start application with PM2
pm2 start server.js --name "webway-portal"
pm2 startup
pm2 save
```

### Option 2: Heroku Deployment

1. **Install Heroku CLI**
```bash
# Download from https://devcenter.heroku.com/articles/heroku-cli
```

2. **Prepare for Heroku**
```bash
# Create Procfile
echo "web: node server.js" > Procfile

# Update package.json scripts
# (Already done in package.json)
```

3. **Deploy to Heroku**
```bash
# Login to Heroku
heroku login

# Create Heroku app
heroku create webway-placement-portal

# Add MySQL addon (JawsDB)
heroku addons:create jawsdb:kitefin

# Set environment variables
heroku config:set NODE_ENV=production
heroku config:set JWT_SECRET=your_very_strong_jwt_secret

# Deploy
git add .
git commit -m "Deploy to Heroku"
git push heroku main
```

### Option 3: Railway Deployment

1. **Connect GitHub Repository**
   - Go to [Railway.app](https://railway.app)
   - Connect your GitHub account
   - Select the webway repository

2. **Configure Environment Variables**
   - Add all variables from `.env` file
   - Railway will provide database URL automatically

3. **Deploy**
   - Railway automatically deploys on git push
   - Get your live URL from Railway dashboard

### Option 4: Vercel Deployment

1. **Install Vercel CLI**
```bash
npm i -g vercel
```

2. **Create vercel.json**
```json
{
  "version": 2,
  "builds": [
    {
      "src": "server.js",
      "use": "@vercel/node"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "server.js"
    }
  ]
}
```

3. **Deploy**
```bash
vercel --prod
```

## 🔒 Security Considerations

### 1. Environment Variables
- Never commit `.env` files to version control
- Use strong, unique passwords
- Generate strong JWT secrets

### 2. Database Security
- Use strong database passwords
- Limit database user privileges
- Enable SSL for database connections

### 3. Server Security
- Keep system updated
- Configure firewall (UFW)
- Use HTTPS (Let's Encrypt)
- Regular security updates

### 4. File Upload Security
- Validate file types
- Limit file sizes
- Scan uploaded files
- Store uploads outside web root

## 📊 Monitoring and Maintenance

### 1. Process Management (PM2)
```bash
# Monitor processes
pm2 status
pm2 logs webway-portal
pm2 restart webway-portal

# Monitor resources
pm2 monit
```

### 2. Database Backups
```bash
# Create backup script
#!/bin/bash
mysqldump -u webway_user -p placement_portal > backup_$(date +%Y%m%d_%H%M%S).sql
```

### 3. Log Management
```bash
# View application logs
pm2 logs webway-portal --lines 100

# Rotate logs
pm2 install pm2-logrotate
```

## 🚨 Troubleshooting

### Common Issues

1. **Port Already in Use**
```bash
# Find process using port 5000
sudo lsof -i :5000
# Kill process
sudo kill -9 PID
```

2. **Database Connection Failed**
- Check MySQL service: `sudo systemctl status mysql`
- Verify credentials in `.env`
- Check firewall settings

3. **File Upload Issues**
- Check uploads directory permissions
- Verify disk space
- Check file size limits

4. **CORS Issues**
- Update CORS_ORIGIN in environment
- Check frontend URL configuration

### Performance Optimization

1. **Database Indexing**
```sql
-- Add indexes for better performance
CREATE INDEX idx_student_roll ON student_profiles(roll_number);
CREATE INDEX idx_job_status ON job_applications(status);
CREATE INDEX idx_message_status ON contact_messages(status);
```

2. **Caching**
- Implement Redis for session storage
- Use CDN for static assets
- Enable browser caching

3. **Load Balancing**
- Use multiple PM2 instances
- Implement Nginx load balancing
- Consider horizontal scaling

## 📈 Scaling Considerations

### Vertical Scaling
- Increase server resources (CPU, RAM)
- Optimize database queries
- Use connection pooling

### Horizontal Scaling
- Multiple application instances
- Load balancer (Nginx/HAProxy)
- Database replication
- Microservices architecture

## 🔄 CI/CD Pipeline

### GitHub Actions Example
```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Deploy to server
      run: |
        # Add your deployment commands here
```

## 📞 Support

For deployment issues:
1. Check server logs
2. Verify environment variables
3. Test database connectivity
4. Review firewall settings
5. Check resource usage

## 🎯 Next Steps

After successful deployment:
1. Set up SSL certificate (Let's Encrypt)
2. Configure domain name
3. Set up monitoring (Uptime Robot)
4. Implement backup strategy
5. Set up error tracking (Sentry)

---

**Happy Deploying! 🚀**



