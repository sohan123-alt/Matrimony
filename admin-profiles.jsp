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
    String filter = request.getParameter("filter");
    
    // Handle profile verification
    if ("verify".equals(action) && request.getMethod().equals("POST")) {
        String profileIdStr = request.getParameter("profileId");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = getConnection();
            
            // Update profile verification status
            String sql = "UPDATE PROFILES SET is_verified = 'YES', updated_date = CURRENT_TIMESTAMP WHERE profile_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(profileIdStr));
            
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                message = "Profile verified successfully!";
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
    
    // Handle profile deletion
    if ("delete".equals(action) && request.getMethod().equals("POST")) {
        String profileIdStr = request.getParameter("profileId");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = getConnection();
            String sql = "DELETE FROM PROFILES WHERE profile_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(profileIdStr));
            
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                message = "Profile deleted successfully!";
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
    
    // Fetch profiles
    List<Map<String, Object>> profiles = new ArrayList<>();
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = getConnection();
        
        StringBuilder sql = new StringBuilder(
            "SELECT p.profile_id, p.user_id, p.name, p.age, p.gender, p.religion, " +
            "p.education, p.occupation, p.city, p.is_verified, p.is_premium, p.created_date, u.email " +
            "FROM PROFILES p JOIN USERS3 u ON p.user_id = u.user_id"
        );
        
        if ("pending".equals(filter)) {
            sql.append(" WHERE p.is_verified = 'NO'");
        } else if ("verified".equals(filter)) {
            sql.append(" WHERE p.is_verified = 'YES'");
        }
        
        sql.append(" ORDER BY p.created_date DESC");
        
        pstmt = conn.prepareStatement(sql.toString());
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> profile = new HashMap<>();
            profile.put("profileId", rs.getInt("profile_id"));
            profile.put("userId", rs.getInt("user_id"));
            profile.put("name", rs.getString("name"));
            profile.put("age", rs.getInt("age"));
            profile.put("gender", rs.getString("gender"));
            profile.put("religion", rs.getString("religion"));
            profile.put("education", rs.getString("education"));
            profile.put("occupation", rs.getString("occupation"));
            profile.put("city", rs.getString("city"));
            profile.put("isVerified", rs.getString("is_verified"));
            profile.put("isPremium", rs.getString("is_premium"));
            profile.put("createdDate", rs.getTimestamp("created_date"));
            profile.put("email", rs.getString("email"));
            profiles.add(profile);
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
    <title>Profile Management - Admin</title>
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
        <h1 class="mt-30" style="color: #e91e63;">Profile Management</h1>

        <% if (!message.isEmpty()) { %>
            <div class="alert alert-<%= messageType %> mt-20">
                <%= message %>
            </div>
        <% } %>

        <!-- Filter Buttons -->
        <div class="btn-group mt-20">
            <a href="admin-profiles.jsp" class="btn <%= filter == null ? "btn-primary" : "btn-secondary" %>">
                All Profiles
            </a>
            <a href="admin-profiles.jsp?filter=pending" class="btn <%= "pending".equals(filter) ? "btn-warning" : "btn-secondary" %>">
                Pending Verification
            </a>
            <a href="admin-profiles.jsp?filter=verified" class="btn <%= "verified".equals(filter) ? "btn-success" : "btn-secondary" %>">
                Verified Profiles
            </a>
        </div>

        <!-- Statistics -->
        <%
            long pendingCount = profiles.stream().filter(p -> "NO".equals(p.get("isVerified"))).count();
            long verifiedCount = profiles.stream().filter(p -> "YES".equals(p.get("isVerified"))).count();
            long premiumCount = profiles.stream().filter(p -> "YES".equals(p.get("isPremium"))).count();
        %>
        
        <div class="stats-grid mt-30">
            <div class="stat-card">
                <div class="stat-icon primary">📋</div>
                <div class="stat-content">
                    <h3><%= profiles.size() %></h3>
                    <p>Total Profiles</p>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon success">✓</div>
                <div class="stat-content">
                    <h3><%= verifiedCount %></h3>
                    <p>Verified</p>
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
                <div class="stat-icon info">💎</div>
                <div class="stat-content">
                    <h3><%= premiumCount %></h3>
                    <p>Premium</p>
                </div>
            </div>
        </div>

        <!-- Profiles Table -->
        <div class="table-container mt-30">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Age/Gender</th>
                        <th>Religion</th>
                        <th>Education</th>
                        <th>Location</th>
                        <th>Status</th>
                        <th>Created</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> profile : profiles) { %>
                        <tr>
                            <td><%= profile.get("profileId") %></td>
                            <td><strong><%= profile.get("name") %></strong></td>
                            <td><%= profile.get("email") %></td>
                            <td><%= profile.get("age") %> / <%= profile.get("gender") %></td>
                            <td><%= profile.get("religion") %></td>
                            <td><%= profile.get("education") %></td>
                            <td><%= profile.get("city") %></td>
                            <td>
                                <% if ("YES".equals(profile.get("isVerified"))) { %>
                                    <span class="badge badge-success">✓ Verified</span>
                                <% } else { %>
                                    <span class="badge badge-warning">⏳ Pending</span>
                                <% } %>
                                <% if ("YES".equals(profile.get("isPremium"))) { %>
                                    <br><span class="badge badge-premium">💎 Premium</span>
                                <% } %>
                            </td>
                            <td><%= profile.get("createdDate") %></td>
                            <td>
                                <div class="btn-group">
                                    <% if ("NO".equals(profile.get("isVerified"))) { %>
                                        <form method="POST" action="admin-profiles.jsp?action=verify" style="display: inline;">
                                            <input type="hidden" name="profileId" value="<%= profile.get("profileId") %>">
                                            <button type="submit" class="btn btn-success" style="padding: 5px 10px; font-size: 12px;">
                                                Verify
                                            </button>
                                        </form>
                                    <% } %>
                                    <a href="view-my-profile.jsp?id=<%= profile.get("profileId") %>" 
                                       class="btn btn-info" style="padding: 5px 10px; font-size: 12px;">
                                        View
                                    </a>
                                    <form method="POST" action="admin-profiles.jsp?action=delete" 
                                          style="display: inline;"
                                          onsubmit="return confirm('Are you sure you want to delete this profile?');">
                                        <input type="hidden" name="profileId" value="<%= profile.get("profileId") %>">
                                        <button type="submit" class="btn btn-danger" style="padding: 5px 10px; font-size: 12px;">
                                            Delete
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <% if (profiles.isEmpty()) { %>
            <div class="alert alert-info mt-20">
                No profiles found matching the selected filter.
            </div>
        <% } %>
    </div>

    <footer>
        <p>&copy; 2026 MatrimonyHub. All Rights Reserved.</p>
    </footer>
</body>
</html>
