<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db-config.jsp" %>
<%
    // Check if user is logged in
    if (!isLoggedIn(session)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Integer userId = (Integer) session.getAttribute("userId");
    String message = "";
    String messageType = "";
    
    if (request.getMethod().equals("POST")) {
        String name = request.getParameter("name");
        String ageStr = request.getParameter("age");
        String gender = request.getParameter("gender");
        String religion = request.getParameter("religion");
        String education = request.getParameter("education");
        String occupation = request.getParameter("occupation");
        String maritalStatus = request.getParameter("maritalStatus");
        String heightStr = request.getParameter("height");
        String weightStr = request.getParameter("weight");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String phone = request.getParameter("phone");
        String aboutMe = request.getParameter("aboutMe");
        String preferences = request.getParameter("preferences");
        String familyDetails = request.getParameter("familyDetails");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            
            // Check if profile already exists
            String checkSql = "SELECT profile_id FROM PROFILES WHERE user_id = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                message = "You already have a profile! Redirecting to edit profile...";
                messageType = "warning";
                response.setHeader("Refresh", "2; URL=edit-profile.jsp");
            } else {
                // Validate required fields
                if (name == null || name.trim().isEmpty()) {
                    message = "Name is required!";
                    messageType = "danger";
                } else if (ageStr == null || ageStr.trim().isEmpty()) {
                    message = "Age is required!";
                    messageType = "danger";
                } else if (heightStr == null || heightStr.trim().isEmpty()) {
                    message = "Height is required!";
                    messageType = "danger";
                } else {
                    // Insert new profile
                    String insertSql = "INSERT INTO PROFILES (profile_id, user_id, name, age, gender, religion, " +
                                     "education, occupation, marital_status, height, weight, city, state, phone, " +
                                     "about_me, preferences, family_details, is_verified) " +
                                     "VALUES (profile_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'NO')";
                    
                    pstmt = conn.prepareStatement(insertSql);
                    pstmt.setInt(1, userId);
                    pstmt.setString(2, name);
                    pstmt.setInt(3, Integer.parseInt(ageStr));
                    pstmt.setString(4, gender != null ? gender : "");
                    pstmt.setString(5, religion != null ? religion : "");
                    pstmt.setString(6, education != null ? education : "");
                    pstmt.setString(7, occupation != null ? occupation : "");
                    pstmt.setString(8, maritalStatus != null ? maritalStatus : "");
                    pstmt.setInt(9, Integer.parseInt(heightStr));
                    pstmt.setInt(10, weightStr != null && !weightStr.trim().isEmpty() ? Integer.parseInt(weightStr) : 0);
                    pstmt.setString(11, city != null ? city : "");
                    pstmt.setString(12, state != null ? state : "");
                    pstmt.setString(13, phone != null ? phone : "");
                    pstmt.setString(14, aboutMe != null ? aboutMe : "");
                    pstmt.setString(15, preferences != null ? preferences : "");
                    pstmt.setString(16, familyDetails != null ? familyDetails : "");
                    
                    int rows = pstmt.executeUpdate();
                    
                    if (rows > 0) {
                        message = "Profile created successfully! Redirecting to dashboard...";
                        messageType = "success";
                        response.setHeader("Refresh", "2; URL=user-dashboard.jsp");
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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Profile - Matrimony Website</title>
    <link rel="stylesheet" href="CSS/styles.css">
</head>
<body>
    <header>
        <nav class="navbar">
            <a href="index.jsp" class="logo">MatrimonyHub</a>
            <ul>
                <li><a href="user-dashboard.jsp">Dashboard</a></li>
                <li>
                    <div class="user-info">
                        <span><%= session.getAttribute("email") %></span>
                        <a href="logout.jsp" class="btn btn-danger">Logout</a>
                    </div>
                </li>
            </ul>
        </nav>
    </header>

    <div class="container-medium">
        <div class="card mt-30 fade-in">
            <div class="card-header">
                <h2>Create Your Profile</h2>
            </div>

            <% if (!message.isEmpty()) { %>
                <div class="alert alert-<%= messageType %>">
                    <%= message %>
                </div>
            <% } %>

            <form method="POST" action="create-profile.jsp">
                <h3 style="color: #e91e63; margin-bottom: 20px;">Personal Information</h3>
                
                <div class="form-group">
                    <label for="name">Full Name *</label>
                    <input type="text" id="name" name="name" class="form-control" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="age">Age *</label>
                        <input type="number" id="age" name="age" class="form-control" min="18" max="100" required>
                    </div>
                    <div class="form-group">
                        <label for="gender">Gender *</label>
                        <select id="gender" name="gender" class="form-control" required>
                            <option value="">Select Gender</option>
                            <option value="MALE">Male</option>
                            <option value="FEMALE">Female</option>
                            <option value="OTHER">Other</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="religion">Religion *</label>
                        <select id="religion" name="religion" class="form-control" required>
                            <option value="">Select Religion</option>
                            <option value="Islam">Islam</option>
                            <option value="Hinduism">Hinduism</option>
                            <option value="Buddhism">Buddhism</option>
                            <option value="Christianity">Christianity</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="maritalStatus">Marital Status *</label>
                        <select id="maritalStatus" name="maritalStatus" class="form-control" required>
                            <option value="">Select Status</option>
                            <option value="NEVER_MARRIED">Never Married</option>
                            <option value="DIVORCED">Divorced</option>
                            <option value="WIDOWED">Widowed</option>
                        </select>
                    </div>
                </div>

                <h3 style="color: #e91e63; margin: 30px 0 20px;">Educational & Professional Details</h3>

                <div class="form-group">
                    <label for="education">Education *</label>
                    <input type="text" id="education" name="education" class="form-control" 
                           placeholder="e.g., Bachelor of Engineering" required>
                </div>

                <div class="form-group">
                    <label for="occupation">Occupation *</label>
                    <input type="text" id="occupation" name="occupation" class="form-control" 
                           placeholder="e.g., Software Engineer" required>
                </div>

                <h3 style="color: #e91e63; margin: 30px 0 20px;">Physical Attributes</h3>

                <div class="form-row">
                    <div class="form-group">
                        <label for="height">Height (cm) *</label>
                        <input type="number" id="height" name="height" class="form-control" 
                               min="100" max="250" placeholder="e.g., 170" required>
                    </div>
                    <div class="form-group">
                        <label for="weight">Weight (kg)</label>
                        <input type="number" id="weight" name="weight" class="form-control" 
                               min="30" max="200" placeholder="e.g., 70">
                    </div>
                </div>

                <h3 style="color: #e91e63; margin: 30px 0 20px;">Location & Contact</h3>

                <div class="form-row">
                    <div class="form-group">
                        <label for="city">City *</label>
                        <input type="text" id="city" name="city" class="form-control" 
                               placeholder="e.g., Dhaka" required>
                    </div>
                    <div class="form-group">
                        <label for="state">State/Division *</label>
                        <input type="text" id="state" name="state" class="form-control" 
                               placeholder="e.g., Dhaka Division" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number *</label>
                    <input type="tel" id="phone" name="phone" class="form-control" 
                           placeholder="+880 1712345678" required>
                </div>

                <h3 style="color: #e91e63; margin: 30px 0 20px;">About You</h3>

                <div class="form-group">
                    <label for="aboutMe">About Me *</label>
                    <textarea id="aboutMe" name="aboutMe" class="form-control" 
                              placeholder="Tell us about yourself..." required></textarea>
                </div>

                <div class="form-group">
                    <label for="preferences">Partner Preferences</label>
                    <textarea id="preferences" name="preferences" class="form-control" 
                              placeholder="What are you looking for in a life partner?"></textarea>
                </div>

                <div class="form-group">
                    <label for="familyDetails">Family Details</label>
                    <textarea id="familyDetails" name="familyDetails" class="form-control" 
                              placeholder="Tell us about your family..."></textarea>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">Create Profile</button>
                    <a href="user-dashboard.jsp" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 MatrimonyHub. All Rights Reserved.</p>
    </footer>
</body>
</html>
