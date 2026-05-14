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
    Integer adminId = (Integer) session.getAttribute("userId");
    
    // Handle task creation
    if ("create".equals(action) && request.getMethod().equals("POST")) {
        String profileIdStr = request.getParameter("profileId");
        String assignedToStr = request.getParameter("assignedTo");
        String taskType = request.getParameter("taskType");
        String description = request.getParameter("description");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = getConnection();
            
            String sql = "INSERT INTO TASKS (task_id, profile_id, assigned_to, task_type, task_status, description) " +
                       "VALUES (task_seq.NEXTVAL, ?, ?, ?, 'PENDING', ?)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(profileIdStr));
            pstmt.setInt(2, assignedToStr != null && !assignedToStr.isEmpty() ? Integer.parseInt(assignedToStr) : adminId);
            pstmt.setString(3, taskType);
            pstmt.setString(4, description);
            
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                message = "Task created successfully!";
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
    
    // Fetch all tasks
    List<Map<String, Object>> tasks = new ArrayList<>();
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = getConnection();
        
        String sql = "SELECT t.task_id, t.task_type, t.task_status, t.description, " +
                   "t.created_date, t.updated_date, " +
                   "p.profile_id, p.name as profile_name, " +
                   "u.email as assigned_email " +
                   "FROM TASKS t " +
                   "JOIN PROFILES p ON t.profile_id = p.profile_id " +
                   "LEFT JOIN USERS u ON t.assigned_to = u.user_id " +
                   "ORDER BY t.created_date DESC";
        
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> task = new HashMap<>();
            task.put("taskId", rs.getInt("task_id"));
            task.put("taskType", rs.getString("task_type"));
            task.put("taskStatus", rs.getString("task_status"));
            task.put("description", rs.getString("description"));
            task.put("createdDate", rs.getTimestamp("created_date"));
            task.put("updatedDate", rs.getTimestamp("updated_date"));
            task.put("profileId", rs.getInt("profile_id"));
            task.put("profileName", rs.getString("profile_name"));
            task.put("assignedEmail", rs.getString("assigned_email"));
            tasks.add(task);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        closeResources(conn, pstmt, rs);
    }
    
    long pendingCount = tasks.stream().filter(t -> "PENDING".equals(t.get("taskStatus"))).count();
    long inProgressCount = tasks.stream().filter(t -> "IN_PROGRESS".equals(t.get("taskStatus"))).count();
    long completedCount = tasks.stream().filter(t -> "COMPLETED".equals(t.get("taskStatus"))).count();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task Management - Admin</title>
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
        <h1 class="mt-30" style="color: #e91e63;">Task Management</h1>

        <% if (!message.isEmpty()) { %>
            <div class="alert alert-<%= messageType %> mt-20">
                <%= message %>
            </div>
        <% } %>

        <div class="stats-grid mt-30">
            <div class="stat-card">
                <div class="stat-icon primary">📝</div>
                <div class="stat-content">
                    <h3><%= tasks.size() %></h3>
                    <p>Total Tasks</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon warning">⏳</div>
                <div class="stat-content">
                    <h3><%= pendingCount %></h3>
                    <p>Pending</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon info">🔄</div>
                <div class="stat-content">
                    <h3><%= inProgressCount %></h3>
                    <p>In Progress</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon success">✓</div>
                <div class="stat-content">
                    <h3><%= completedCount %></h3>
                    <p>Completed</p>
                </div>
            </div>
        </div>

        <div class="card mt-30">
            <div class="card-header">
                <h2>Task System</h2>
            </div>
            <p>Use the admin profiles page to verify profiles and automatically create tasks for staff.</p>
            <a href="admin-profiles.jsp?filter=pending" class="btn btn-primary">Go to Profile Verification</a>
        </div>

        <% if (!tasks.isEmpty()) { %>
            <div class="table-container mt-30">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Profile</th>
                            <th>Type</th>
                            <th>Status</th>
                            <th>Description</th>
                            <th>Assigned To</th>
                            <th>Created</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, Object> task : tasks) { %>
                            <tr>
                                <td><%= task.get("taskId") %></td>
                                <td><%= task.get("profileName") %></td>
                                <td><span class="badge badge-info"><%= task.get("taskType") %></span></td>
                                <td>
                                    <% 
                                        String status = (String) task.get("taskStatus");
                                        String badgeClass = "PENDING".equals(status) ? "badge-warning" :
                                                          "IN_PROGRESS".equals(status) ? "badge-info" :
                                                          "badge-success";
                                    %>
                                    <span class="badge <%= badgeClass %>"><%= status %></span>
                                </td>
                                <td><%= task.get("description") %></td>
                                <td><%= task.get("assignedEmail") != null ? task.get("assignedEmail") : "Unassigned" %></td>
                                <td><%= task.get("createdDate") %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>

    <footer>
        <p>&copy; 2026 MatrimonyHub. All Rights Reserved.</p>
    </footer>
</body>
</html>
