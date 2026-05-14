<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db-config.jsp" %>
<%
    String message = "";
    String messageType = "";
    
    if (request.getMethod().equals("POST")) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (email != null && password != null && confirmPassword != null) {
            if (!password.equals(confirmPassword)) {
                message = "Passwords do not match!";
                messageType = "danger";
            } else {
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                
                try {
                    conn = getConnection();
                    
                    // Check if email already exists
                    String checkSql = "SELECT user_id FROM USERS3 WHERE email = ?";
                    pstmt = conn.prepareStatement(checkSql);
                    pstmt.setString(1, email);
                    rs = pstmt.executeQuery();
                    
                    if (rs.next()) {
                        message = "Email already registered! Please use a different email.";
                        messageType = "danger";
                    } else {
                        // Insert new user
                        String insertSql = "INSERT INTO USERS3 (user_id, email, password, role, status) VALUES (user1_seq.NEXTVAL, ?, ?, 'USER', 'ACTIVE')";
                        pstmt = conn.prepareStatement(insertSql);
                        pstmt.setString(1, email);
                        pstmt.setString(2, password); // In production, use password hashing
                        
                        int rows = pstmt.executeUpdate();
                        
                        if (rows > 0) {
                            message = "Registration successful! Please login to continue.";
                            messageType = "success";
                            
                            // Auto-login after registration
                            String loginSql = "SELECT user_id, email, role FROM USERS3 WHERE email = ? AND password = ?";
                            pstmt = conn.prepareStatement(loginSql);
                            pstmt.setString(1, email);
                            pstmt.setString(2, password);
                            rs = pstmt.executeQuery();
                            
                            if (rs.next()) {
                                session.setAttribute("userId", rs.getInt("user_id"));
                                session.setAttribute("email", rs.getString("email"));
                                session.setAttribute("role", rs.getString("role"));
                                
                                // Redirect to create profile
                                response.sendRedirect("create-profile.jsp");
                                return;
                            }
                        }
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
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Matrimony Website</title>
    <link rel="stylesheet" href="CSS/styles.css">
</head>
<body>
    <div class="auth-container">
        <div class="auth-card fade-in">
            <div class="auth-header">
                <h1>Create Account</h1>
                <p>Join MatrimonyHub and find your perfect match</p>
            </div>

            <% if (!message.isEmpty()) { %>
                <div class="alert alert-<%= messageType %>">
                    <%= message %>
                </div>
            <% } %>

            <form method="POST" action="register.jsp">
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" 
                           placeholder="your.email@example.com" required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" 
                           placeholder="Create a strong password" required minlength="6">
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" 
                           class="form-control" placeholder="Re-enter your password" required minlength="6">
                </div>

                <button type="submit" class="btn btn-primary btn-block">Create Account</button>
            </form>

            <div class="auth-footer">
                <p>Already have an account? <a href="login.jsp" style="color: #e91e63; font-weight: 600;">Login here</a></p>
                <p><a href="index.jsp" style="color: #666;">Back to Home</a></p>
            </div>
        </div>
    </div>
</body>
</html>
