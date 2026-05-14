-- ================================================
-- MATRIMONY WEBSITE - ORACLE DATABASE SCHEMA
-- ================================================

-- Drop tables if they exist (in reverse dependency order)
DROP TABLE REPORT_LOGS CASCADE CONSTRAINTS;
DROP TABLE PAYMENTS CASCADE CONSTRAINTS;
DROP TABLE TASKS CASCADE CONSTRAINTS;
DROP TABLE PROFILES CASCADE CONSTRAINTS;
DROP TABLE USERS3 CASCADE CONSTRAINTS;

-- Drop sequences if they exist
DROP SEQUENCE user1_seq;
DROP SEQUENCE profile_seq;
DROP SEQUENCE task_seq;
DROP SEQUENCE payment_seq;
DROP SEQUENCE report_seq;

-- ================================================
-- CREATE SEQUENCES
-- ================================================

CREATE SEQUENCE user1_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE profile_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE task_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE payment_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE report_seq START WITH 1 INCREMENT BY 1;

-- ================================================
-- USERS TABLE
-- ================================================
CREATE TABLE USERS3 (
    user_id NUMBER PRIMARY KEY,
    email VARCHAR2(100) UNIQUE NOT NULL,
    password VARCHAR2(255) NOT NULL,
    role VARCHAR2(20) DEFAULT 'USER' CHECK (role IN ('USER', 'ADMIN', 'STAFF')),
    status VARCHAR2(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'SUSPENDED')),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);

-- ================================================
-- PROFILES TABLE
-- ================================================
CREATE TABLE PROFILES (
    profile_id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    name VARCHAR2(100) NOT NULL,
    age NUMBER CHECK (age >= 18 AND age <= 100),
    gender VARCHAR2(10) CHECK (gender IN ('MALE', 'FEMALE', 'OTHER')),
    religion VARCHAR2(50),
    education VARCHAR2(200),
    occupation VARCHAR2(100),
    marital_status VARCHAR2(20) CHECK (marital_status IN ('NEVER_MARRIED', 'DIVORCED', 'WIDOWED')),
    height NUMBER,
    weight NUMBER,
    city VARCHAR2(100),
    state VARCHAR2(100),
    country VARCHAR2(100) DEFAULT 'Bangladesh',
    phone VARCHAR2(20),
    about_me CLOB,
    preferences CLOB,
    family_details CLOB,
    is_verified VARCHAR2(3) DEFAULT 'NO' CHECK (is_verified IN ('YES', 'NO')),
    is_premium VARCHAR2(3) DEFAULT 'NO' CHECK (is_premium IN ('YES', 'NO')),
    profile_photo VARCHAR2(255),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES USERS3(user_id) ON DELETE CASCADE
);

-- ================================================
-- TASKS TABLE
-- ================================================
CREATE TABLE TASKS (
    task_id NUMBER PRIMARY KEY,
    profile_id NUMBER NOT NULL,
    assigned_to NUMBER,
    task_type VARCHAR2(50) DEFAULT 'VERIFICATION' CHECK (task_type IN ('VERIFICATION', 'REVIEW', 'APPROVAL', 'INVESTIGATION')),
    task_status VARCHAR2(20) DEFAULT 'PENDING' CHECK (task_status IN ('PENDING', 'IN_PROGRESS', 'COMPLETED', 'REJECTED')),
    description CLOB,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_date TIMESTAMP,
    notes CLOB,
    CONSTRAINT fk_profile FOREIGN KEY (profile_id) REFERENCES PROFILES(profile_id) ON DELETE CASCADE,
    CONSTRAINT fk_assigned_user FOREIGN KEY (assigned_to) REFERENCES USERS3(user_id) ON DELETE SET NULL
);

-- ================================================
-- PAYMENTS TABLE
-- ================================================
CREATE TABLE PAYMENTS (
    payment_id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    amount NUMBER(10,2) NOT NULL,
    payment_method VARCHAR2(50) CHECK (payment_method IN ('BKASH', 'NAGAD', 'ROCKET', 'BANK_TRANSFER', 'CARD')),
    plan_type VARCHAR2(20) CHECK (plan_type IN ('MONTHLY', 'QUARTERLY', 'YEARLY')),
    payment_status VARCHAR2(20) DEFAULT 'PENDING' CHECK (payment_status IN ('PAID', 'PENDING', 'FAILED', 'REFUNDED')),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transaction_id VARCHAR2(100),
    verified_by NUMBER,
    verified_date TIMESTAMP,
    plan_start_date DATE,
    plan_end_date DATE,
    notes CLOB,
    CONSTRAINT fk_payment_user FOREIGN KEY (user_id) REFERENCES USERS3(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_verified_by FOREIGN KEY (verified_by) REFERENCES USERS3(user_id) ON DELETE SET NULL
);

-- ================================================
-- REPORT_LOGS TABLE
-- ================================================
CREATE TABLE REPORT_LOGS (
    report_id NUMBER PRIMARY KEY,
    report_type VARCHAR2(50) CHECK (report_type IN ('USER_REGISTRATION', 'PROFILE_VERIFICATION', 'TASK_STATUS', 'PAYMENT_STATUS', 'SYSTEM_ACTIVITY')),
    generated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    generated_by NUMBER,
    details CLOB,
    total_count NUMBER,
    verified_count NUMBER,
    pending_count NUMBER,
    paid_count NUMBER,
    unpaid_count NUMBER,
    CONSTRAINT fk_report_user FOREIGN KEY (generated_by) REFERENCES USERS3(user_id) ON DELETE SET NULL
);

-- ================================================
-- INSERT DEFAULT DATA
-- ================================================

-- Default Admin User (password: admin123)
INSERT INTO USERS3 (user_id, email, password, role, status) 
VALUES (user1_seq.NEXTVAL, 'admin@matrimony.com', 'admin123', 'ADMIN', 'ACTIVE');

-- Default Staff User (password: staff123)
INSERT INTO USERS3 (user_id, email, password, role, status) 
VALUES (user1_seq.NEXTVAL, 'staff@matrimony.com', 'staff123', 'STAFF', 'ACTIVE');

-- Sample Regular Users
INSERT INTO USERS3 (user_id, email, password, role, status) 
VALUES (user1_seq.NEXTVAL, 'john@email.com', 'user123', 'USER', 'ACTIVE');

INSERT INTO USERS3 (user_id, email, password, role, status) 
VALUES (user1_seq.NEXTVAL, 'sarah@email.com', 'user123', 'USER', 'ACTIVE');

-- Sample Profiles
INSERT INTO PROFILES (profile_id, user_id, name, age, gender, religion, education, occupation, marital_status, height, city, state, phone, about_me, is_verified)
VALUES (profile_seq.NEXTVAL, 3, 'John Doe', 28, 'MALE', 'Islam', 'Bachelor of Engineering', 'Software Engineer', 'NEVER_MARRIED', 175, 'Dhaka', 'Dhaka Division', '+8801712345678', 'Looking for a compatible life partner', 'YES');

INSERT INTO PROFILES (profile_id, user_id, name, age, gender, religion, education, occupation, marital_status, height, city, state, phone, about_me, is_verified)
VALUES (profile_seq.NEXTVAL, 4, 'Sarah Ahmed', 25, 'FEMALE', 'Islam', 'Master of Business Administration', 'Business Analyst', 'NEVER_MARRIED', 162, 'Dhaka', 'Dhaka Division', '+8801812345678', 'Family oriented and career focused', 'NO');

COMMIT;

-- ================================================
-- VERIFICATION QUERIES
-- ================================================

-- View all tables
SELECT table_name FROM user_tables ORDER BY table_name;

-- View all data
SELECT * FROM USERS3;
SELECT * FROM PROFILES;
SELECT * FROM TASKS;
SELECT * FROM PAYMENTS;
SELECT * FROM REPORT_LOGS;
