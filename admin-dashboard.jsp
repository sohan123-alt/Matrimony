<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db-config.jsp" %>
<%
    if (!isLoggedIn(session) || !isAdmin(session)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    int totalUsers = 0;
    int activeUsers = 0;
    int totalProfiles = 0;
    int verifiedProfiles = 0;
    int pendingTasks = 0;
    int totalPayments = 0;
    int paidPayments = 0;
    int pendingPayments = 0;
    
    try {
        conn = getConnection();
        
        // Total users
        pstmt = conn.prepareStatement("SELECT COUNT(*) FROM USERS3");
        rs = pstmt.executeQuery();
        if (rs.next()) totalUsers = rs.getInt(1);
        
        // Active users
        pstmt = conn.prepareStatement("SELECT COUNT(*) FROM USERS3 WHERE status = 'ACTIVE'");
        rs = pstmt.executeQuery();
        if (rs.next()) activeUsers = rs.getInt(1);
        
        // Total profiles
        pstmt = conn.prepareStatement("SELECT COUNT(*) FROM PROFILES");
        rs = pstmt.executeQuery();
        if (rs.next()) totalProfiles = rs.getInt(1);
        
        // Verified profiles
        pstmt = conn.prepareStatement("SELECT COUNT(*) FROM PROFILES WHERE is_verified = 'YES'");
        rs = pstmt.executeQuery();
        if (rs.next()) verifiedProfiles = rs.getInt(1);
        
        // Pending tasks
        pstmt = conn.prepareStatement("SELECT COUNT(*) FROM TASKS WHERE task_status = 'PENDING'");
        rs = pstmt.executeQuery();
        if (rs.next()) pendingTasks = rs.getInt(1);
        
        // Total payments
        pstmt = conn.prepareStatement("SELECT COUNT(*) FROM PAYMENTS");
        rs = pstmt.executeQuery();
        if (rs.next()) totalPayments = rs.getInt(1);
        
        // Paid payments
        pstmt = conn.prepareStatement("SELECT COUNT(*) FROM PAYMENTS WHERE payment_status = 'PAID'");
        rs = pstmt.executeQuery();
        if (rs.next()) paidPayments = rs.getInt(1);
        
        // Pending payments
        pstmt = conn.prepareStatement("SELECT COUNT(*) FROM PAYMENTS WHERE payment_status = 'PENDING'");
        rs = pstmt.executeQuery();
        if (rs.next()) pendingPayments = rs.getInt(1);
        
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        closeResources(conn, pstmt, rs);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Matrimony Website</title>
    <link rel="stylesheet" href="CSS/styles.css">

</head>
<body>
    <header>
        <nav class="navbar">
            <a href="index.jsp" class="logo">MatrimonyHub - Admin</a>
            <ul>
                <li><a href="admin-dashboard.jsp">Dashboard</a></li>
                <li><a href="admin-users.jsp">Users</a></li>
                <li><a href="admin-profiles.jsp">Profiles</a></li>
                <li><a href="admin-tasks.jsp">Tasks</a></li>
                <li><a href="admin-payments.jsp">Payments</a></li>
                <li><a href="admin-reports.jsp">Reports</a></li>
                <li>
                    <div class="user-info">
                        <span>👑 Admin</span>
                        <a href="logout.jsp" class="btn btn-danger">Logout</a>
                    </div>
                </li>
            </ul>
        </nav>
    </header>

    <div class="container">
        <h1 class="mt-30" style="color: #e91e63;">Admin Dashboard</h1>
        <p style="color: #666; font-size: 18px;">Welcome back! Here's your system overview.</p>

        <!-- Main Statistics -->
        <div class="stats-grid mt-30">
            <div class="stat-card">
                <div class="stat-icon primary">👥</div>
                <div class="stat-content">
                    <h3><%= totalUsers %></h3>
                    <p>Total Users</p>
                    <small style="color: #4caf50;"><%= activeUsers %> Active</small>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon success">📋</div>
                <div class="stat-content">
                    <h3><%= totalProfiles %></h3>
                    <p>Total Profiles</p>
                    <small style="color: #4caf50;"><%= verifiedProfiles %> Verified</small>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon warning">📝</div>
                <div class="stat-content">
                    <h3><%= pendingTasks %></h3>
                    <p>Pending Tasks</p>
                    <small style="color: #ff9800;">Needs Attention</small>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon info">💰</div>
                <div class="stat-content">
                    <h3><%= totalPayments %></h3>
                    <p>Total Payments</p>
                    <small style="color: #2196f3;"><%= paidPayments %> Paid, <%= pendingPayments %> Pending</small>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <h2 class="mt-30" style="color: #e91e63;">Quick Actions</h2>
        <div class="dashboard-grid mt-20">
            <div class="widget">
                <div class="widget-header">
                    <h3>👥 User Management</h3>
                </div>
                <p style="color: #666; margin-bottom: 20px;">
                    Manage user accounts, activate/deactivate users, and view user details.
                </p>
                <a href="admin-users.jsp" class="btn btn-primary">Manage Users</a>
            </div>

            <div class="widget">
                <div class="widget-header">
                    <h3>✓ Profile Verification</h3>
                </div>
                <p style="color: #666; margin-bottom: 20px;">
                    Review and verify user profiles to ensure authenticity.
                </p>
                <a href="admin-profiles.jsp?filter=pending" class="btn btn-warning">Verify Profiles</a>
            </div>

            <div class="widget">
                <div class="widget-header">
                    <h3>📝 Task Management</h3>
                </div>
                <p style="color: #666; margin-bottom: 20px;">
                    Create and assign verification tasks to staff members.
                </p>
                <a href="admin-tasks.jsp" class="btn btn-info">Manage Tasks</a>
            </div>

            <div class="widget">
                <div class="widget-header">
                    <h3>💰 Payment Verification</h3>
                </div>
                <p style="color: #666; margin-bottom: 20px;">
                    Review and approve pending premium membership payments.
                </p>
                <a href="admin-payments.jsp?filter=pending" class="btn btn-success">Review Payments</a>
            </div>
        </div>

        <!-- Recent Activity -->
        <h2 class="mt-30" style="color: #e91e63;">Recent Activity</h2>
        
        <div class="form-row mt-20">
            <!-- Recent Users -->
            <div class="widget">
                <div class="widget-header">
                    <h3>Recent Registrations</h3>
                </div>
                <%
                    conn = null;
                    pstmt = null;
                    rs = null;
                    try {
                        conn = getConnection();
                        pstmt = conn.prepareStatement(
                            "SELECT email, created_date FROM USERS ORDER BY created_date DESC FETCH FIRST 5 ROWS ONLY"
                        );
                        rs = pstmt.executeQuery();
                        
                        while (rs.next()) {
                %>
                    <div style="padding: 10px; border-bottom: 1px solid #ddd;">
                        <strong><%= rs.getString("email") %></strong><br>
                        <small style="color: #666;"><%= rs.getTimestamp("created_date") %></small>
                    </div>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        closeResources(conn, pstmt, rs);
                    }
                %>
            </div>

            <!-- Recent Profiles -->
            <div class="widget">
                <div class="widget-header">
                    <h3>Recent Profiles</h3>
                </div>
                <%
                    conn = null;
                    pstmt = null;
                    rs = null;
                    try {
                        conn = getConnection();
                        pstmt = conn.prepareStatement(
                            "SELECT name, is_verified, created_date FROM PROFILES ORDER BY created_date DESC FETCH FIRST 5 ROWS ONLY"
                        );
                        rs = pstmt.executeQuery();
                        
                        while (rs.next()) {
                %>
                    <div style="padding: 10px; border-bottom: 1px solid #ddd;">
                        <strong><%= rs.getString("name") %></strong>
                        <% if ("YES".equals(rs.getString("is_verified"))) { %>
                            <span class="badge badge-success">✓</span>
                        <% } else { %>
                            <span class="badge badge-warning">Pending</span>
                        <% } %><br>
                        <small style="color: #666;"><%= rs.getTimestamp("created_date") %></small>
                    </div>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        closeResources(conn, pstmt, rs);
                    }
                %>
            </div>
        </div>

        <!-- System Information -->
        <div class="card mt-30">
            <div class="card-header">
                <h2>System Information</h2>
            </div>
            <div class="form-row">
                <div>
                    <h4 style="color: #e91e63; margin-bottom: 10px;">Database Status</h4>
                    <p><span class="badge badge-success">✓ Connected</span></p>
                    <p style="color: #666; margin-top: 10px;">Oracle Database</p>
                </div>
                <div>
                    <h4 style="color: #e91e63; margin-bottom: 10px;">Application Status</h4>
                    <p><span class="badge badge-success">✓ Running</span></p>
                    <p style="color: #666; margin-top: 10px;">All systems operational</p>
                </div>
            </div>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 MatrimonyHub. All Rights Reserved.</p>
    </footer>
</body>
</html>
