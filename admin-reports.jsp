<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db-config.jsp" %>
<%
    if (!isLoggedIn(session) || !isAdmin(session)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Fetch statistics
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    int totalUsers = 0, activeUsers = 0, totalProfiles = 0, verifiedProfiles = 0;
    int pendingProfiles = 0, totalPayments = 0, paidPayments = 0, pendingPayments = 0;
    int totalTasks = 0, completedTasks = 0;
    double totalRevenue = 0;
    
    try {
        conn = getConnection();
        
        pstmt = conn.prepareStatement("SELECT COUNT(*) FROM USERS3");
        rs = pstmt.executeQuery();
        if (rs.next()) totalUsers = rs.getInt(1);
        
        pstmt = conn.prepareStatement("SELECT COUNT(*) FROM USERS3 WHERE status = 'ACTIVE'");
        rs = pstmt.executeQuery();
        if (rs.next()) activeUsers = rs.getInt(1);
        
        pstmt = conn.prepareStatement("SELECT COUNT(*) FROM PROFILES");
        rs = pstmt.executeQuery();
        if (rs.next()) totalProfiles = rs.getInt(1);
        
        pstmt = conn.prepareStatement("SELECT COUNT(*) FROM PROFILES WHERE is_verified = 'YES'");
        rs = pstmt.executeQuery();
        if (rs.next()) verifiedProfiles = rs.getInt(1);
        
        pstmt = conn.prepareStatement("SELECT COUNT(*) FROM PROFILES WHERE is_verified = 'NO'");
        rs = pstmt.executeQuery();
        if (rs.next()) pendingProfiles = rs.getInt(1);
        
        pstmt = conn.prepareStatement("SELECT COUNT(*) FROM PAYMENTS");
        rs = pstmt.executeQuery();
        if (rs.next()) totalPayments = rs.getInt(1);
        
        pstmt = conn.prepareStatement("SELECT COUNT(*) FROM PAYMENTS WHERE payment_status = 'PAID'");
        rs = pstmt.executeQuery();
        if (rs.next()) paidPayments = rs.getInt(1);
        
        pstmt = conn.prepareStatement("SELECT COUNT(*) FROM PAYMENTS WHERE payment_status = 'PENDING'");
        rs = pstmt.executeQuery();
        if (rs.next()) pendingPayments = rs.getInt(1);
        
        pstmt = conn.prepareStatement("SELECT SUM(amount) FROM PAYMENTS WHERE payment_status = 'PAID'");
        rs = pstmt.executeQuery();
        if (rs.next()) totalRevenue = rs.getDouble(1);
        
        pstmt = conn.prepareStatement("SELECT COUNT(*) FROM TASKS");
        rs = pstmt.executeQuery();
        if (rs.next()) totalTasks = rs.getInt(1);
        
        pstmt = conn.prepareStatement("SELECT COUNT(*) FROM TASKS WHERE task_status = 'COMPLETED'");
        rs = pstmt.executeQuery();
        if (rs.next()) completedTasks = rs.getInt(1);
        
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        closeResources(conn, pstmt, rs);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reports - Admin</title>
    <link rel="stylesheet" href="CSS/styles.css">
</head>
<body>
    <header>
        <nav class="navbar">
            <a href="admin-dashboard.jsp" class="logo">MatrimonyHub - Admin</a>
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
        <h1 class="mt-30" style="color: #e91e63;">System Reports</h1>
        
        <div class="card mt-30">
            <div class="card-header"><h2>📊 User Registration Report</h2></div>
            <div class="form-row">
                <div>
                    <h3 style="color: #e91e63;"><%= totalUsers %></h3>
                    <p>Total Registered Users</p>
                </div>
                <div>
                    <h3 style="color: #4caf50;"><%= activeUsers %></h3>
                    <p>Active Users</p>
                </div>
                <div>
                    <h3 style="color: #f44336;"><%= totalUsers - activeUsers %></h3>
                    <p>Inactive Users</p>
                </div>
            </div>
        </div>

        <div class="card mt-30">
            <div class="card-header"><h2>✓ Profile Verification Report</h2></div>
            <div class="form-row">
                <div>
                    <h3 style="color: #e91e63;"><%= totalProfiles %></h3>
                    <p>Total Profiles</p>
                </div>
                <div>
                    <h3 style="color: #4caf50;"><%= verifiedProfiles %></h3>
                    <p>Verified Profiles</p>
                </div>
                <div>
                    <h3 style="color: #ff9800;"><%= pendingProfiles %></h3>
                    <p>Pending Verification</p>
                </div>
            </div>
        </div>

        <div class="card mt-30">
            <div class="card-header"><h2>💰 Payment Status Report</h2></div>
            <div class="form-row">
                <div>
                    <h3 style="color: #e91e63;"><%= totalPayments %></h3>
                    <p>Total Transactions</p>
                </div>
                <div>
                    <h3 style="color: #4caf50;"><%= paidPayments %></h3>
                    <p>Verified Payments</p>
                </div>
                <div>
                    <h3 style="color: #ff9800;"><%= pendingPayments %></h3>
                    <p>Pending Payments</p>
                </div>
                <div>
                    <h3 style="color: #2196f3;">BDT<%= String.format("%.2f", totalRevenue) %></h3>
                    <p>Total Revenue</p>
                </div>
            </div>
        </div>

        <div class="card mt-30">
            <div class="card-header"><h2>📝 Task Completion Report</h2></div>
            <div class="form-row">
                <div>
                    <h3 style="color: #e91e63;"><%= totalTasks %></h3>
                    <p>Total Tasks</p>
                </div>
                <div>
                    <h3 style="color: #4caf50;"><%= completedTasks %></h3>
                    <p>Completed Tasks</p>
                </div>
                <div>
                    <h3 style="color: #ff9800;"><%= totalTasks - completedTasks %></h3>
                    <p>Pending Tasks</p>
                </div>
                <div>
                    <h3 style="color: #2196f3;"><%= totalTasks > 0 ? Math.round((completedTasks * 100.0) / totalTasks) : 0 %>%</h3>
                    <p>Completion Rate</p>
                </div>
            </div>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 MatrimonyHub. All Rights Reserved.</p>
    </footer>
</body>
</html>
