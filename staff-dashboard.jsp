<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db-config.jsp" %>
<%@ page import="java.util.*" %>
<%
    if (!isLoggedIn(session) || !isStaff(session)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Integer staffId = (Integer) session.getAttribute("userId");
    String message = "";
    String messageType = "";
    
    // Handle task status update
    if (request.getMethod().equals("POST")) {
        String taskIdStr = request.getParameter("taskId");
        String newStatus = request.getParameter("status");
        String notes = request.getParameter("notes");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = getConnection();
            
            String sql = "UPDATE TASKS SET task_status = ?, notes = ?, updated_date = CURRENT_TIMESTAMP";
            if ("COMPLETED".equals(newStatus)) {
                sql += ", completed_date = CURRENT_TIMESTAMP";
            }
            sql += " WHERE task_id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newStatus);
            pstmt.setString(2, notes);
            pstmt.setInt(3, Integer.parseInt(taskIdStr));
            
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                message = "Task status updated successfully!";
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
    
    // Fetch assigned tasks
    List<Map<String, Object>> myTasks = new ArrayList<>();
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = getConnection();
        
        String sql = "SELECT t.task_id, t.task_type, t.task_status, t.description, " +
                   "t.created_date, t.notes, p.profile_id, p.name as profile_name " +
                   "FROM TASKS t JOIN PROFILES p ON t.profile_id = p.profile_id " +
                   "WHERE t.assigned_to = ? ORDER BY t.created_date DESC";
        
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, staffId);
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> task = new HashMap<>();
            task.put("taskId", rs.getInt("task_id"));
            task.put("taskType", rs.getString("task_type"));
            task.put("taskStatus", rs.getString("task_status"));
            task.put("description", rs.getString("description"));
            task.put("createdDate", rs.getTimestamp("created_date"));
            task.put("notes", rs.getString("notes"));
            task.put("profileId", rs.getInt("profile_id"));
            task.put("profileName", rs.getString("profile_name"));
            myTasks.add(task);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        closeResources(conn, pstmt, rs);
    }
    
    long pendingCount = myTasks.stream().filter(t -> "PENDING".equals(t.get("taskStatus"))).count();
    long inProgressCount = myTasks.stream().filter(t -> "IN_PROGRESS".equals(t.get("taskStatus"))).count();
    long completedCount = myTasks.stream().filter(t -> "COMPLETED".equals(t.get("taskStatus"))).count();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff Dashboard</title>
    <link rel="stylesheet" href="CSS/styles.css">
</head>
<body>
    <header>
        <nav class="navbar">
            <a href="staff-dashboard.jsp" class="logo">MatrimonyHub - Staff</a>
            <ul>
                <li><a href="staff-dashboard.jsp">My Tasks</a></li>
                <li><a href="browse-profiles.jsp">Browse Profiles</a></li>
                <li>
                    <div class="user-info">
                        <span>👨‍💼 Staff</span>
                        <a href="logout.jsp" class="btn btn-danger">Logout</a>
                    </div>
                </li>
            </ul>
        </nav>
    </header>

    <div class="container">
        <h1 class="mt-30" style="color: #e91e63;">Staff Dashboard</h1>

        <% if (!message.isEmpty()) { %>
            <div class="alert alert-<%= messageType %> mt-20">
                <%= message %>
            </div>
        <% } %>

        <div class="stats-grid mt-30">
            <div class="stat-card">
                <div class="stat-icon primary">📝</div>
                <div class="stat-content">
                    <h3><%= myTasks.size() %></h3>
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

        <h2 class="mt-30" style="color: #e91e63;">My Assigned Tasks</h2>

        <% if (myTasks.isEmpty()) { %>
            <div class="alert alert-info mt-20">
                No tasks assigned yet. Check back later!
            </div>
        <% } else { %>
            <div class="profile-grid mt-20">
                <% for (Map<String, Object> task : myTasks) { %>
                    <div class="card">
                        <div class="card-header">
                            <h3><%= task.get("profileName") %></h3>
                        </div>
                        <div class="card-body">
                            <p><strong>Type:</strong> <span class="badge badge-info"><%= task.get("taskType") %></span></p>
                            <p><strong>Status:</strong> 
                                <% 
                                    String status = (String) task.get("taskStatus");
                                    String badgeClass = "PENDING".equals(status) ? "badge-warning" :
                                                      "IN_PROGRESS".equals(status) ? "badge-info" : "badge-success";
                                %>
                                <span class="badge <%= badgeClass %>"><%= status %></span>
                            </p>
                            <p><strong>Description:</strong> <%= task.get("description") %></p>
                            <p><strong>Created:</strong> <%= task.get("createdDate") %></p>
                            
                            <% if (!"COMPLETED".equals(status)) { %>
                                <form method="POST" action="staff-dashboard.jsp" class="mt-20">
                                    <input type="hidden" name="taskId" value="<%= task.get("taskId") %>">
                                    <div class="form-group">
                                        <label>Update Status:</label>
                                        <select name="status" class="form-control">
                                            <option value="PENDING" <%= "PENDING".equals(status) ? "selected" : "" %>>Pending</option>
                                            <option value="IN_PROGRESS" <%= "IN_PROGRESS".equals(status) ? "selected" : "" %>>In Progress</option>
                                            <option value="COMPLETED">Completed</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Notes:</label>
                                        <textarea name="notes" class="form-control"><%= task.get("notes") != null ? task.get("notes") : "" %></textarea>
                                    </div>
                                    <div class="btn-group">
                                        <button type="submit" class="btn btn-primary">Update</button>
                                        <a href="view-profile.jsp?id=<%= task.get("profileId") %>" class="btn btn-info">View Profile</a>
                                    </div>
                                </form>
                            <% } else { %>
                                <div class="alert alert-success mt-20">✓ Task Completed</div>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <footer>
        <p>&copy; 2026 MatrimonyHub. All Rights Reserved.</p>
    </footer>
</body>
</html>
