# MatrimonyHub - Complete Setup Guide

## 🎯 Overview

This guide will walk you through setting up the MatrimonyHub matrimony website from scratch on your local machine or server.

## 📋 Prerequisites Checklist

Before starting, ensure you have:

- [ ] Oracle Database 11g/12c/19c or Oracle XE installed
- [ ] Apache Tomcat 9.0+ installed
- [ ] Java JDK 8 or higher installed
- [ ] Oracle JDBC Driver (ojdbc8.jar)
- [ ] Text editor or IDE (Eclipse, IntelliJ IDEA, VS Code)
- [ ] Web browser (Chrome, Firefox, Edge)

## 🗂️ Directory Structure Setup

Create the following directory structure:

```
C:\matrimony-project\          (or /home/user/matrimony-project/)
│
├── database\
│   └── schema.sql
│
├── webapp\
│   ├── *.jsp files
│   └── styles.css
│
└── documentation\
    ├── README.md
    └── SETUP_GUIDE.md
```

## 🔧 Part 1: Oracle Database Setup

### Step 1: Install Oracle Database

**For Windows:**
1. Download Oracle Database XE from oracle.com
2. Run the installer
3. Set SYS/SYSTEM password (e.g., `oracle123`)
4. Complete installation
5. Database will be available at `localhost:1521/XE`

**For Linux:**
```bash
# Download Oracle XE
wget https://download.oracle.com/otn-pub/otn_software/db-express/...

# Install
sudo dpkg -i oracle-xe*.deb

# Configure
sudo /etc/init.d/oracle-xe configure
```

### Step 2: Connect to Database

```bash
# Using SQL*Plus
sqlplus sys as sysdba
# Enter password: oracle123 (or your password)
```

### Step 3: Create Application User

```sql
-- Create user
CREATE USER matrimony IDENTIFIED BY matrimony123;

-- Grant privileges
GRANT CONNECT, RESOURCE TO matrimony;
GRANT CREATE SESSION TO matrimony;
GRANT CREATE TABLE TO matrimony;
GRANT CREATE VIEW TO matrimony;
GRANT CREATE SEQUENCE TO matrimony;
GRANT UNLIMITED TABLESPACE TO matrimony;

-- Verify user creation
SELECT username FROM all_users WHERE username = 'MATRIMONY';

-- Connect as matrimony user
CONNECT matrimony/matrimony123;
```

### Step 4: Run Database Schema

```sql
-- While connected as matrimony user
@C:\matrimony-project\database\schema.sql

-- Or copy-paste the content of schema.sql

-- Verify tables creation
SELECT table_name FROM user_tables;

-- Should show:
-- USERS
-- PROFILES
-- TASKS
-- PAYMENTS
-- REPORT_LOGS

-- Verify sample data
SELECT * FROM USERS;
SELECT * FROM PROFILES;
```

### Step 5: Test Database Connection

```sql
-- Check if sample data is loaded
SELECT COUNT(*) FROM USERS;
-- Should return: 4 (admin, staff, 2 users)

SELECT email, role FROM USERS;
-- Should show:
-- admin@matrimony.com (ADMIN)
-- staff@matrimony.com (STAFF)
-- john@email.com (USER)
-- sarah@email.com (USER)

-- Exit SQL*Plus
EXIT;
```

## ☕ Part 2: Java & Tomcat Setup

### Step 1: Install Java JDK

**Windows:**
1. Download JDK from oracle.com or adoptopenjdk.net
2. Run installer
3. Set JAVA_HOME environment variable
   - Right-click "This PC" → Properties
   - Advanced System Settings → Environment Variables
   - New System Variable:
     - Name: `JAVA_HOME`
     - Value: `C:\Program Files\Java\jdk-1.8.0`
   - Edit PATH: Add `%JAVA_HOME%\bin`

4. Verify installation:
```cmd
java -version
javac -version
```

**Linux:**
```bash
# Install OpenJDK
sudo apt update
sudo apt install openjdk-8-jdk

# Verify
java -version
javac -version
```

### Step 2: Install Apache Tomcat

**Windows:**
1. Download Tomcat 9 from tomcat.apache.org
2. Extract to `C:\tomcat9\`
3. Set CATALINA_HOME:
   - Environment Variables → New
   - Name: `CATALINA_HOME`
   - Value: `C:\tomcat9`

4. Start Tomcat:
```cmd
cd C:\tomcat9\bin
startup.bat
```

5. Verify: Open browser → `http://localhost:8080`

**Linux:**
```bash
# Download and extract
cd /opt
sudo wget https://downloads.apache.org/tomcat/tomcat-9/...
sudo tar xzvf apache-tomcat-9*.tar.gz
sudo mv apache-tomcat-9* tomcat9

# Start Tomcat
cd /opt/tomcat9/bin
sudo ./startup.sh

# Verify
curl http://localhost:8080
```

### Step 3: Configure Tomcat Users (Optional - For Manager App)

Edit `tomcat9/conf/tomcat-users.xml`:

```xml
<tomcat-users>
  <role rolename="manager-gui"/>
  <role rolename="admin-gui"/>
  <user username="admin" password="admin123" roles="manager-gui,admin-gui"/>
</tomcat-users>
```

Restart Tomcat to apply changes.

## 📚 Part 3: Oracle JDBC Driver Setup

### Step 1: Download JDBC Driver

1. Visit oracle.com/database/technologies/jdbc-drivers-download.html
2. Download `ojdbc8.jar` (for JDK 8)
3. Or use the one compatible with your Oracle DB version

### Step 2: Install JDBC Driver

**Method 1: Tomcat lib directory (Recommended)**
```
Copy ojdbc8.jar to:
C:\tomcat9\lib\ojdbc8.jar
```

**Method 2: Application WEB-INF/lib**
```
Copy ojdbc8.jar to:
C:\tomcat9\webapps\matrimony\WEB-INF\lib\ojdbc8.jar
```

### Step 3: Verify JDBC Driver

Create a test JSP file:

```jsp
<%@ page import="java.sql.*" %>
<%
try {
    Class.forName("oracle.jdbc.driver.OracleDriver");
    out.println("JDBC Driver loaded successfully!");
} catch (Exception e) {
    out.println("Error: " + e.getMessage());
}
%>
```

## 🌐 Part 4: Deploy Matrimony Application

### Step 1: Create Application Directory

```
C:\tomcat9\webapps\matrimony\
```

### Step 2: Copy Application Files

```
Copy all files from webapp\ to C:\tomcat9\webapps\matrimony\

Your structure should look like:
C:\tomcat9\webapps\matrimony\
├── index.jsp
├── login.jsp
├── register.jsp
├── db-config.jsp
├── styles.css
├── create-profile.jsp
├── browse-profiles.jsp
├── premium.jsp
├── user-dashboard.jsp
├── admin-dashboard.jsp
├── admin-users.jsp
└── ... (all other JSP files)
```

### Step 3: Configure Database Connection

Edit `matrimony/db-config.jsp`:

```jsp
private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:xe";
private static final String DB_USER = "matrimony";
private static final String DB_PASSWORD = "matrimony123";
```

**Important:** Update these values to match your Oracle setup:
- If using different port: change `1521`
- If using different SID: change `xe`
- If using different user/password: update accordingly

### Step 4: Create WEB-INF Directory

```
Create: C:\tomcat9\webapps\matrimony\WEB-INF\
```

Create `web.xml` inside WEB-INF:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee 
         http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
         version="3.1">
    
    <display-name>MatrimonyHub</display-name>
    
    <welcome-file-list>
        <welcome-file>index.jsp</welcome-file>
    </welcome-file-list>
    
    <session-config>
        <session-timeout>30</session-timeout>
    </session-config>
</web-app>
```

### Step 5: Restart Tomcat

```cmd
# Windows
cd C:\tomcat9\bin
shutdown.bat
startup.bat

# Linux
cd /opt/tomcat9/bin
sudo ./shutdown.sh
sudo ./startup.sh
```

## 🚀 Part 5: Testing the Application

### Step 1: Access Homepage

Open browser and navigate to:
```
http://localhost:8080/matrimony/
```

You should see the MatrimonyHub homepage.

### Step 2: Test User Login

1. Click "Login"
2. Use default credentials:
   - **Admin**: admin@matrimony.com / admin123
   - **Staff**: staff@matrimony.com / staff123
   - **User**: john@email.com / user123

### Step 3: Test Registration

1. Click "Register"
2. Enter new email and password
3. Complete profile creation
4. Verify profile appears in database

### Step 4: Test Admin Functions

1. Login as admin
2. Navigate to Admin Dashboard
3. Check all admin pages:
   - User Management
   - Profile Management
   - Tasks
   - Payments
   - Reports

### Step 5: Database Verification

```sql
-- Connect to database
sqlplus matrimony/matrimony123

-- Check new registrations
SELECT * FROM USERS ORDER BY created_date DESC;

-- Check profiles
SELECT * FROM PROFILES;

-- Check tasks
SELECT * FROM TASKS;

-- Check payments
SELECT * FROM PAYMENTS;
```

## 🔍 Part 6: Troubleshooting

### Issue 1: Database Connection Failed

**Error:** `Cannot connect to database`

**Solutions:**
1. Check Oracle database is running:
   ```cmd
   # Windows
   services.msc
   # Look for OracleServiceXE and start it
   ```

2. Verify connection details in db-config.jsp
3. Test connection with SQL*Plus:
   ```cmd
   sqlplus matrimony/matrimony123@localhost:1521/xe
   ```

### Issue 2: JDBC Driver Not Found

**Error:** `ClassNotFoundException: oracle.jdbc.driver.OracleDriver`

**Solutions:**
1. Ensure ojdbc8.jar is in tomcat/lib/
2. Restart Tomcat after adding JAR
3. Check JAR file is not corrupted

### Issue 3: JSP Compilation Error

**Error:** `Unable to compile class for JSP`

**Solutions:**
1. Verify JDK is installed (not just JRE)
2. Check JAVA_HOME is set correctly
3. Restart Tomcat

### Issue 4: 404 Page Not Found

**Error:** `404 - Page not found`

**Solutions:**
1. Check deployment directory: `webapps/matrimony/`
2. Verify files are in correct location
3. Check Tomcat is running
4. Verify URL: `http://localhost:8080/matrimony/`

### Issue 5: Blank Page or No Data

**Solutions:**
1. Check database has sample data:
   ```sql
   SELECT COUNT(*) FROM USERS;
   ```
2. Verify database connection in db-config.jsp
3. Check Tomcat logs: `tomcat/logs/catalina.out`

## 📊 Part 7: Performance Optimization

### Database Optimization

```sql
-- Create indexes for better performance
CREATE INDEX idx_users_email ON USERS(email);
CREATE INDEX idx_profiles_user_id ON PROFILES(user_id);
CREATE INDEX idx_profiles_verified ON PROFILES(is_verified);
CREATE INDEX idx_tasks_status ON TASKS(task_status);
CREATE INDEX idx_payments_status ON PAYMENTS(payment_status);
```

### Tomcat Optimization

Edit `tomcat/conf/server.xml`:

```xml
<Connector port="8080" protocol="HTTP/1.1"
           connectionTimeout="20000"
           maxThreads="200"
           minSpareThreads="25"
           maxConnections="200"
           redirectPort="8443" />
```

## 🔒 Part 8: Security Hardening (Production)

### 1. Password Hashing

Add password hashing library and update db-config.jsp:

```jsp
<%!
    // Add password hashing method
    public String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                hexString.append(String.format("%02x", b));
            }
            return hexString.toString();
        } catch (Exception e) {
            return password; // Fallback
        }
    }
%>
```

### 2. SQL Injection Prevention

Always use PreparedStatement (already implemented):

```jsp
// GOOD - Using PreparedStatement
String sql = "SELECT * FROM USERS WHERE email = ?";
pstmt = conn.prepareStatement(sql);
pstmt.setString(1, email);

// BAD - Direct concatenation (NEVER DO THIS)
// String sql = "SELECT * FROM USERS WHERE email = '" + email + "'";
```

### 3. Session Security

Add to web.xml:

```xml
<session-config>
    <session-timeout>30</session-timeout>
    <cookie-config>
        <http-only>true</http-only>
        <secure>true</secure>
    </cookie-config>
</session-config>
```

## 📱 Part 9: Testing Checklist

Test each functionality:

- [ ] Homepage loads correctly
- [ ] User registration works
- [ ] User login works
- [ ] Profile creation works
- [ ] Browse profiles with filters
- [ ] Premium membership purchase
- [ ] Admin can login
- [ ] Admin can view users
- [ ] Admin can activate/deactivate users
- [ ] Admin can verify profiles
- [ ] Admin can create tasks
- [ ] Admin can verify payments
- [ ] Staff can login
- [ ] Staff can view assigned tasks
- [ ] Staff can update task status
- [ ] Database stores all data correctly
- [ ] Session management works
- [ ] Logout works
- [ ] CSS styling is applied

## 🎓 Part 10: Next Steps

After successful setup:

1. **Customize the application:**
   - Update colors in styles.css
   - Add your logo
   - Customize email templates

2. **Add more features:**
   - Email verification
   - Photo upload
   - Advanced search
   - Chat messaging

3. **Deploy to production:**
   - Get a domain name
   - Set up SSL certificate
   - Configure production database
   - Use cloud hosting (AWS, Azure, etc.)

## 📞 Support & Resources

**Useful Links:**
- Oracle Database: https://www.oracle.com/database/
- Apache Tomcat: https://tomcat.apache.org/
- JDBC Tutorial: https://docs.oracle.com/javase/tutorial/jdbc/
- JSP Tutorial: https://www.javatpoint.com/jsp-tutorial

**Common Commands:**

```bash
# Check if Tomcat is running
netstat -an | find "8080"

# Check if Oracle is running
lsnrctl status

# View Tomcat logs
tail -f tomcat/logs/catalina.out

# Restart Oracle (Windows)
net stop OracleServiceXE
net start OracleServiceXE
```

## ✅ Completion Checklist

- [ ] Oracle Database installed and running
- [ ] Database user created (matrimony)
- [ ] Schema created successfully
- [ ] Sample data loaded
- [ ] Java JDK installed
- [ ] Apache Tomcat installed and running
- [ ] JDBC driver installed
- [ ] Application deployed to Tomcat
- [ ] Database connection configured
- [ ] Homepage accessible
- [ ] Login working with test accounts
- [ ] All pages loading correctly
- [ ] Database operations working

## 🎉 Congratulations!

If you've completed all steps, your MatrimonyHub application should be running successfully!

Access your application at: **http://localhost:8080/matrimony/**

---

**Happy Coding! 💻❤️**
