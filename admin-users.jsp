<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db-config.jsp" %>
<%@ page import="java.util.*" %>
<%
    if (!isLoggedIn(session) || !isAdmin(session)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String message = "";
    String messageType = "";
    String action = request.getParameter("action");
    
    // Handle user status updates
    if ("updateStatus".equals(action) && request.getMethod().equals("POST")) {
        String userIdStr = request.getParameter("userId");
        String newStatus = request.getParameter("status");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = getConnection();
            String sql = "UPDATE USERS3 SET status = ? WHERE user_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, Integer.parseInt(userIdStr));
            
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                message = "User status updated successfully!";
                messageType = "success";
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
            messageType = "danger";
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
    }
    
    // Fetch all users
    List<Map<String, Object>> users = new ArrayList<>();
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = getConnection();
        String sql = "SELECT u.user_id, u.email, u.role, u.status, u.created_date, u.last_login, " +
                   "p.name, p.is_verified FROM USERS3 u LEFT JOIN PROFILES p ON u.user_id = p.user_id " +
                   "ORDER BY u.created_date DESC";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> user = new HashMap<>();
            user.put("userId", rs.getInt("user_id"));
            user.put("email", rs.getString("email"));
            user.put("role", rs.getString("role"));
            user.put("status", rs.getString("status"));
            user.put("createdDate", rs.getTimestamp("created_date"));
            user.put("lastLogin", rs.getTimestamp("last_login"));
            user.put("name", rs.getString("name"));
            user.put("isVerified", rs.getString("is_verified"));
            users.add(user);
        }
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
    <title>User Management - Admin</title>
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
        <h1 class="mt-30" style="color: #e91e63;">User Management</h1>

        <% if (!message.isEmpty()) { %>
            <div class="alert alert-<%= messageType %> mt-20">
                <%= message %>
            </div>
        <% } %>

        <!-- Statistics -->
        <div class="stats-grid mt-30">
            <div class="stat-card">
                <div class="stat-icon primary">👥</div>
                <div class="stat-content">
                    <h3><%= users.size() %></h3>
                    <p>Total Users</p>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon success">✓</div>
                <div class="stat-content">
                    <h3><%= users.stream().filter(u -> "ACTIVE".equals(u.get("status"))).count() %></h3>
                    <p>Active Users</p>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon warning">⏸</div>
                <div class="stat-content">
                    <h3><%= users.stream().filter(u -> "INACTIVE".equals(u.get("status"))).count() %></h3>
                    <p>Inactive Users</p>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon info">👑</div>
                <div class="stat-content">
                    <h3><%= users.stream().filter(u -> "ADMIN".equals(u.get("role"))).count() %></h3>
                    <p>Admins</p>
                </div>
            </div>
        </div>

        <!-- Users Table -->
        <div class="table-container mt-30">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Email</th>
                        <th>Name</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Profile Status</th>
                        <th>Created</th>
                        <th>Last Login</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> user : users) { %>
                        <tr>
                            <td><%= user.get("userId") %></td>
                            <td><%= user.get("email") %></td>
                            <td><%= user.get("name") != null ? user.get("name") : "No Profile" %></td>
                            <td>
                                <span class="badge <%= "ADMIN".equals(user.get("role")) ? "badge-info" : 
                                                       "STAFF".equals(user.get("role")) ? "badge-warning" : "badge-success" %>">
                                    <%= user.get("role") %>
                                </span>
                            </td>
                            <td>
                                <span class="badge <%= "ACTIVE".equals(user.get("status")) ? "badge-success" : "badge-danger" %>">
                                    <%= user.get("status") %>
                                </span>
                            </td>
                            <td>
                                <% if (user.get("name") != null) { %>
                                    <% if ("YES".equals(user.get("isVerified"))) { %>
                                        <span class="badge badge-success">✓ Verified</span>
                                    <% } else { %>
                                        <span class="badge badge-warning">Pending</span>
                                    <% } %>
                                <% } else { %>
                                    <span style="color: #999;">N/A</span>
                                <% } %>
                            </td>
                            <td><%= user.get("createdDate") %></td>
                            <td><%= user.get("lastLogin") != null ? user.get("lastLogin") : "Never" %></td>
                            <td>
                                <form method="POST" action="admin-users.jsp?action=updateStatus" style="display: inline;">
                                    <input type="hidden" name="userId" value="<%= user.get("userId") %>">
                                    <% if ("ACTIVE".equals(user.get("status"))) { %>
                                        <input type="hidden" name="status" value="INACTIVE">
                                        <button type="submit" class="btn btn-danger" style="padding: 5px 10px; font-size: 12px;">
                                            Deactivate
                                        </button>
                                    <% } else { %>
                                        <input type="hidden" name="status" value="ACTIVE">
                                        <button type="submit" class="btn btn-success" style="padding: 5px 10px; font-size: 12px;">
                                            Activate
                                        </button>
                                    <% } %>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 MatrimonyHub. All Rights Reserved.</p>
    </footer>
</body>
</html>
