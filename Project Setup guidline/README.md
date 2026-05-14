# Matrimony Website - Complete Project Documentation

## 📋 Project Overview

A comprehensive web-based Matrimony Website built using **JSP**, **JDBC**, and **Oracle Database**. This platform enables users to register, create profiles, browse potential matches, and upgrade to premium memberships. The system includes admin and staff management capabilities for profile verification, task management, payment processing, and reporting.

## 🎯 Key Features

### User Features
- ✅ User registration and secure login
- ✅ Create and manage personal profiles
- ✅ Browse verified profiles with advanced filtering
- ✅ Premium membership with enhanced features
- ✅ Secure payment processing (bKash, Nagad, Rocket, Bank Transfer)
- ✅ Profile verification status tracking
- ✅ Dashboard with statistics and quick actions

### Admin Features
- ✅ Complete user management (activate/deactivate accounts)
- ✅ Profile verification and management
- ✅ Task creation and assignment
- ✅ Payment verification and approval
- ✅ Comprehensive reporting module
- ✅ System statistics and monitoring

### Staff Features
- ✅ View assigned tasks
- ✅ Update task status (Pending → In Progress → Completed)
- ✅ Profile verification assistance

## 🛠️ Technology Stack

| Component | Technology |
|-----------|-----------|
| **Backend** | JSP (JavaServer Pages) with scriptlets only |
| **Frontend** | HTML5, CSS3 (Modern responsive design) |
| **Database** | Oracle Database 11g/12c/19c |
| **Connectivity** | JDBC (Oracle JDBC Driver) |
| **Server** | Apache Tomcat 9.0+ |

## 📁 Project Structure

```
matrimony-website/
│
├── webapp/
│   ├── index.jsp                    # Home page
│   ├── register.jsp                 # User registration
│   ├── login.jsp                    # User login
│   ├── logout.jsp                   # Logout handler
│   ├── db-config.jsp               # Database configuration
│   ├── styles.css                   # Modern CSS stylesheet
│   │
│   ├── create-profile.jsp          # Profile creation
│   ├── edit-profile.jsp            # Profile editing
│   ├── view-profile.jsp            # View individual profile
│   ├── browse-profiles.jsp         # Browse all profiles
│   │
│   ├── user-dashboard.jsp          # User dashboard
│   ├── premium.jsp                  # Premium membership plans
│   │
│   ├── admin-dashboard.jsp         # Admin dashboard
│   ├── admin-users.jsp             # User management
│   ├── admin-profiles.jsp          # Profile management
│   ├── admin-tasks.jsp             # Task management
│   ├── admin-payments.jsp          # Payment management
│   ├── admin-reports.jsp           # Reports module
│   │
│   └── staff-dashboard.jsp         # Staff dashboard
│
├── sql/
│   └── schema.sql                   # Database schema
│
└── documentation/
    ├── README.md                    # This file
    ├── SETUP_GUIDE.md              # Installation guide
    └── USER_MANUAL.md              # User manual
```

## 🗄️ Database Schema

### Tables

#### 1. USERS
Stores user account information.

| Column | Type | Description |
|--------|------|-------------|
| user_id | NUMBER | Primary key (auto-increment) |
| email | VARCHAR2(100) | Unique email address |
| password | VARCHAR2(255) | User password |
| role | VARCHAR2(20) | USER/ADMIN/STAFF |
| status | VARCHAR2(20) | ACTIVE/INACTIVE/SUSPENDED |
| created_date | TIMESTAMP | Account creation date |
| last_login | TIMESTAMP | Last login timestamp |

#### 2. PROFILES
Stores detailed user profile information.

| Column | Type | Description |
|--------|------|-------------|
| profile_id | NUMBER | Primary key |
| user_id | NUMBER | Foreign key to USERS |
| name | VARCHAR2(100) | Full name |
| age | NUMBER | Age (18-100) |
| gender | VARCHAR2(10) | MALE/FEMALE/OTHER |
| religion | VARCHAR2(50) | Religion |
| education | VARCHAR2(200) | Educational qualification |
| occupation | VARCHAR2(100) | Profession |
| marital_status | VARCHAR2(20) | Marital status |
| height | NUMBER | Height in cm |
| weight | NUMBER | Weight in kg |
| city | VARCHAR2(100) | City |
| state | VARCHAR2(100) | State/Division |
| country | VARCHAR2(100) | Country (default: Bangladesh) |
| phone | VARCHAR2(20) | Contact number |
| about_me | CLOB | Personal description |
| preferences | CLOB | Partner preferences |
| family_details | CLOB | Family information |
| is_verified | VARCHAR2(3) | YES/NO |
| is_premium | VARCHAR2(3) | YES/NO |
| created_date | TIMESTAMP | Profile creation date |
| updated_date | TIMESTAMP | Last update date |

#### 3. TASKS
Manages verification and review tasks.

| Column | Type | Description |
|--------|------|-------------|
| task_id | NUMBER | Primary key |
| profile_id | NUMBER | Foreign key to PROFILES |
| assigned_to | NUMBER | Foreign key to USERS (staff) |
| task_type | VARCHAR2(50) | VERIFICATION/REVIEW/APPROVAL |
| task_status | VARCHAR2(20) | PENDING/IN_PROGRESS/COMPLETED |
| description | CLOB | Task description |
| created_date | TIMESTAMP | Task creation date |
| updated_date | TIMESTAMP | Last update date |
| completed_date | TIMESTAMP | Completion date |
| notes | CLOB | Task notes |

#### 4. PAYMENTS
Tracks premium membership payments.

| Column | Type | Description |
|--------|------|-------------|
| payment_id | NUMBER | Primary key |
| user_id | NUMBER | Foreign key to USERS |
| amount | NUMBER(10,2) | Payment amount |
| payment_method | VARCHAR2(50) | BKASH/NAGAD/ROCKET/BANK_TRANSFER |
| plan_type | VARCHAR2(20) | MONTHLY/QUARTERLY/YEARLY |
| payment_status | VARCHAR2(20) | PAID/PENDING/FAILED |
| payment_date | TIMESTAMP | Payment date |
| transaction_id | VARCHAR2(100) | Transaction reference |
| verified_by | NUMBER | Admin who verified |
| verified_date | TIMESTAMP | Verification date |
| plan_start_date | DATE | Membership start date |
| plan_end_date | DATE | Membership end date |
| notes | CLOB | Payment notes |

#### 5. REPORT_LOGS
Stores generated report information.

| Column | Type | Description |
|--------|------|-------------|
| report_id | NUMBER | Primary key |
| report_type | VARCHAR2(50) | Report category |
| generated_date | TIMESTAMP | Generation date |
| generated_by | NUMBER | Admin who generated |
| details | CLOB | Report details |
| total_count | NUMBER | Total count |
| verified_count | NUMBER | Verified count |
| pending_count | NUMBER | Pending count |
| paid_count | NUMBER | Paid count |
| unpaid_count | NUMBER | Unpaid count |

## 🚀 Installation & Setup

### Prerequisites

1. **Oracle Database** (11g/12c/19c or XE)
2. **Apache Tomcat** 9.0 or higher
3. **JDK** 8 or higher
4. **Oracle JDBC Driver** (ojdbc8.jar or similar)

### Step-by-Step Setup

#### 1. Database Setup

```sql
-- Connect to Oracle as SYSDBA
sqlplus sys as sysdba

-- Create database user
CREATE USER matrimony IDENTIFIED BY matrimony123;
GRANT CONNECT, RESOURCE, CREATE VIEW TO matrimony;
GRANT UNLIMITED TABLESPACE TO matrimony;

-- Connect as the new user
CONNECT matrimony/matrimony123;

-- Run the schema.sql file
@path/to/schema.sql
```

#### 2. Configure Database Connection

Edit `webapp/db-config.jsp` and update the database connection details:

```java
private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:xe";
private static final String DB_USER = "matrimony";
private static final String DB_PASSWORD = "matrimony123";
```

#### 3. Deploy to Tomcat

1. Copy the entire `webapp` folder to Tomcat's `webapps` directory
2. Rename it to `matrimony` (or your preferred context path)
3. Place Oracle JDBC driver (`ojdbc8.jar`) in `tomcat/lib/` directory
4. Start Tomcat server

#### 4. Access the Application

Open your browser and navigate to:
```
http://localhost:8080/matrimony/
```

## 👤 Default Accounts

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@matrimony.com | admin123 |
| Staff | staff@matrimony.com | staff123 |
| User | john@email.com | user123 |
| User | sarah@email.com | user123 |

## 🎨 UI Design Features

### Modern CSS Design
- ✨ Gradient backgrounds and cards
- 🎯 Responsive grid layouts
- 🔄 Smooth transitions and animations
- 📱 Mobile-friendly responsive design
- 🎨 Professional color scheme (Pink/Purple primary)
- 💳 Card-based layouts
- 🔘 Beautiful form controls
- 📊 Statistics cards with icons

### Color Palette
- **Primary**: `#e91e63` (Pink)
- **Secondary**: `#673ab7` (Purple)
- **Success**: `#4caf50` (Green)
- **Warning**: `#ff9800` (Orange)
- **Danger**: `#f44336` (Red)
- **Info**: `#2196f3` (Blue)

## 📱 Application Workflow

### User Registration Flow
1. User visits home page → Clicks "Register"
2. Fills registration form (email, password)
3. System validates and creates account
4. Auto-login after successful registration
5. Redirected to create profile page

### Profile Creation Flow
1. User fills comprehensive profile form
2. Personal info, education, occupation
3. Physical attributes, location
4. About me, preferences, family details
5. Profile created with "Not Verified" status
6. Admin receives notification for verification

### Premium Membership Flow
1. User selects membership plan (Monthly/Quarterly/Yearly)
2. Chooses payment method
3. Completes payment via mobile banking
4. Submits transaction ID
5. Payment status: PENDING
6. Admin verifies payment
7. Premium features activated

### Admin Verification Flow
1. Admin reviews new profiles
2. Creates verification task
3. Assigns task to staff member
4. Staff completes verification
5. Admin approves profile
6. Profile marked as "Verified"

## 🔒 Security Features

- ✅ Session-based authentication
- ✅ Role-based access control (USER/ADMIN/STAFF)
- ✅ SQL injection prevention (PreparedStatement)
- ✅ Email uniqueness validation
- ✅ Account status management
- ✅ Premium feature restrictions
- ⚠️ **Note**: For production, implement password hashing (BCrypt/SHA-256)

## 📊 Premium Membership Benefits

| Feature | Free | Premium |
|---------|------|---------|
| Browse Profiles | ✅ | ✅ |
| Create Profile | ✅ | ✅ |
| View Contact Details | ❌ | ✅ |
| Send Messages | Limited | Unlimited |
| Priority Listing | ❌ | ✅ |
| Advanced Filters | ❌ | ✅ |
| Profile Insights | ❌ | ✅ |
| Premium Badge | ❌ | ✅ |

## 💰 Pricing Plans

| Plan | Duration | Price | Savings |
|------|----------|-------|---------|
| Monthly | 1 Month | ৳999 | - |
| Quarterly | 3 Months | ৳2,499 | ৳498 (17%) |
| Yearly | 12 Months | ৳7,999 | ৳3,989 (33%) |

## 🧪 Testing Checklist

- [ ] User registration with email validation
- [ ] Login with correct/incorrect credentials
- [ ] Profile creation and editing
- [ ] Browse profiles with filters
- [ ] Premium membership purchase
- [ ] Admin user management
- [ ] Profile verification by admin
- [ ] Task creation and assignment
- [ ] Payment verification
- [ ] Report generation
- [ ] Session management
- [ ] Role-based access

## 🔧 Troubleshooting

### Database Connection Issues
```
Error: ORA-01017: invalid username/password
Solution: Verify database credentials in db-config.jsp
```

### ClassNotFoundException: oracle.jdbc.driver.OracleDriver
```
Solution: Add ojdbc8.jar to tomcat/lib directory
```

### Page Not Found (404)
```
Solution: Check deployment directory name matches URL context path
```

## 📈 Future Enhancements

- [ ] Password hashing and encryption
- [ ] Email verification
- [ ] Forgot password functionality
- [ ] Profile photo upload
- [ ] Real-time chat messaging
- [ ] Advanced search filters
- [ ] Email notifications
- [ ] SMS integration
- [ ] Social media login
- [ ] Mobile app version

## 👨‍💻 Development Notes

### JSP Best Practices Used
- ✅ Separated database configuration
- ✅ Reusable database connection methods
- ✅ PreparedStatement for SQL queries
- ✅ Proper resource cleanup (Connection, Statement, ResultSet)
- ✅ Session management
- ✅ Error handling with try-catch
- ✅ User-friendly error messages

### Code Structure
- All backend logic in JSP scriptlets (`<% %>`)
- No separate Java classes or servlets
- Database operations directly in JSP
- Session-based authentication
- Inline SQL queries with JDBC

## 📞 Support

For issues or questions:
- Check the troubleshooting section
- Review database connection settings
- Verify Tomcat deployment
- Check Oracle Database status

## 📄 License

This project is created for educational purposes.

## 🙏 Acknowledgments

- Oracle Database for robust data management
- Apache Tomcat for reliable servlet container
- JSP/JDBC for server-side programming

---

**Created with ❤️ for MatrimonyHub Project**
