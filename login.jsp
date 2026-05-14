<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db-config.jsp" %>
<%
    String message = "";
    String messageType = "";
    
    if (request.getMethod().equals("POST")) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        if (email != null && password != null) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                conn = getConnection();
                
                String sql = "SELECT u.user_id, u.email, u.role, u.status, p.is_premium " +
                           "FROM USERS3 u LEFT JOIN PROFILES p ON u.user_id = p.user_id " +
                           "WHERE u.email = ? AND u.password = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, email);
                pstmt.setString(2, password);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    String status = rs.getString("status");
                    
                    if ("INACTIVE".equals(status) || "SUSPENDED".equals(status)) {
                        message = "Your account has been " + status.toLowerCase() + ". Please contact admin.";
                        messageType = "danger";
                    } else {
                        // Login successful
                        session.setAttribute("userId", rs.getInt("user_id"));
                        session.setAttribute("email", rs.getString("email"));
                        session.setAttribute("role", rs.getString("role"));
                        session.setAttribute("isPremium", rs.getString("is_premium") != null ? rs.getString("is_premium") : "NO");
                        
                        // Update last login
                        String updateSql = "UPDATE USERS3 SET last_login = CURRENT_TIMESTAMP WHERE user_id = ?";
                        PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                        updateStmt.setInt(1, rs.getInt("user_id"));
                        updateStmt.executeUpdate();
                        updateStmt.close();
                        
                        // Redirect based on role
                        String role = rs.getString("role");
                        if ("ADMIN".equals(role)) {
                            response.sendRedirect("admin-dashboard.jsp");
                        } else if ("STAFF".equals(role)) {
                            response.sendRedirect("staff-dashboard.jsp");
                        } else {
                            response.sendRedirect("user-dashboard.jsp");
                        }
                        return;
                    }
                } else {
                    message = "Invalid email or password!";
                    messageType = "danger";
                }
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
                messageType = "danger";
                e.printStackTrace();
            } finally {
                closeResources(conn, pstmt, rs);
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Matrimony Website</title>
    <link rel="stylesheet" href="CSS/styles.css">
</head>
<body>
    <div class="auth-container">
        <div class="auth-card fade-in">
            <div class="auth-header">
                <h1>Welcome Back</h1>
                <p>Login to find your perfect match</p>
            </div>

            <% if (!message.isEmpty()) { %>
                <div class="alert alert-<%= messageType %>">
                    <%= message %>
                </div>
            <% } %>

            <form method="POST" action="login.jsp">
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" 
                           placeholder="your.email@example.com" required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" 
                           placeholder="Enter your password" required>
                </div>

                <button type="submit" class="btn btn-primary btn-block">Login</button>
            </form>

            <div class="auth-footer">
                <p>Don't have an account? <a href="register.jsp" style="color: #e91e63; font-weight: 600;">Register here</a></p>
                <p><a href="index.jsp" style="color: #666;">Back to Home</a></p>
            
        </div>
    </div>
</body>
</html>
