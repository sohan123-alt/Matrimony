<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db-config.jsp" %>
<%
    if (!isLoggedIn(session)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Integer userId = (Integer) session.getAttribute("userId");
    String message = "";
    String messageType = "";
    
    // Fetch current profile data
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    String name = "";
    int age = 0;
    String gender = "";
    String religion = "";
    String education = "";
    String occupation = "";
    String maritalStatus = "";
    int height = 0;
    int weight = 0;
    String city = "";
    String state = "";
    String phone = "";
    String aboutMe = "";
    String preferences = "";
    String familyDetails = "";
    String currentPhoto = "";
    boolean hasProfile = false;
    
    try {
        conn = getConnection();
        
        String sql = "SELECT * FROM PROFILES WHERE user_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, userId);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            hasProfile = true;
            name = rs.getString("name") != null ? rs.getString("name") : "";
            age = rs.getInt("age");
            gender = rs.getString("gender") != null ? rs.getString("gender") : "";
            religion = rs.getString("religion") != null ? rs.getString("religion") : "";
            education = rs.getString("education") != null ? rs.getString("education") : "";
            occupation = rs.getString("occupation") != null ? rs.getString("occupation") : "";
            maritalStatus = rs.getString("marital_status") != null ? rs.getString("marital_status") : "";
            height = rs.getInt("height");
            weight = rs.getInt("weight");
            city = rs.getString("city") != null ? rs.getString("city") : "";
            state = rs.getString("state") != null ? rs.getString("state") : "";
            phone = rs.getString("phone") != null ? rs.getString("phone") : "";
            aboutMe = rs.getString("about_me") != null ? rs.getString("about_me") : "";
            preferences = rs.getString("preferences") != null ? rs.getString("preferences") : "";
            familyDetails = rs.getString("family_details") != null ? rs.getString("family_details") : "";
            currentPhoto = rs.getString("profile_photo") != null ? rs.getString("profile_photo") : "";
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        closeResources(conn, pstmt, rs);
    }
    
    if (!hasProfile) {
        response.sendRedirect("create-profile.jsp");
        return;
    }
    
    // Handle form submission (WITHOUT multipart for now - simpler approach)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String newName = request.getParameter("name");
        String newAgeStr = request.getParameter("age");
        String newGender = request.getParameter("gender");
        String newReligion = request.getParameter("religion");
        String newEducation = request.getParameter("education");
        String newOccupation = request.getParameter("occupation");
        String newMaritalStatus = request.getParameter("maritalStatus");
        String newHeightStr = request.getParameter("height");
        String newWeightStr = request.getParameter("weight");
        String newCity = request.getParameter("city");
        String newState = request.getParameter("state");
        String newPhone = request.getParameter("phone");
        String newAboutMe = request.getParameter("aboutMe");
        String newPreferences = request.getParameter("preferences");
        String newFamilyDetails = request.getParameter("familyDetails");
        
        // Validate
        boolean isValid = true;
        
        if (newName == null || newName.trim().isEmpty()) {
            message = "Name is required!";
            messageType = "danger";
            isValid = false;
        } else if (newAgeStr == null || newAgeStr.trim().isEmpty()) {
            message = "Age is required!";
            messageType = "danger";
            isValid = false;
        } else if (newHeightStr == null || newHeightStr.trim().isEmpty()) {
            message = "Height is required!";
            messageType = "danger";
            isValid = false;
        }
        
        if (isValid) {
            conn = null;
            pstmt = null;
            
            try {
                conn = getConnection();
                
                String updateSql = "UPDATE PROFILES SET name = ?, age = ?, gender = ?, religion = ?, " +
                                 "education = ?, occupation = ?, marital_status = ?, height = ?, weight = ?, " +
                                 "city = ?, state = ?, phone = ?, about_me = ?, preferences = ?, " +
                                 "family_details = ?, updated_date = CURRENT_TIMESTAMP WHERE user_id = ?";
                
                pstmt = conn.prepareStatement(updateSql);
                pstmt.setString(1, newName.trim());
                pstmt.setInt(2, Integer.parseInt(newAgeStr.trim()));
                pstmt.setString(3, newGender != null ? newGender.trim() : "");
                pstmt.setString(4, newReligion != null ? newReligion.trim() : "");
                pstmt.setString(5, newEducation != null ? newEducation.trim() : "");
                pstmt.setString(6, newOccupation != null ? newOccupation.trim() : "");
                pstmt.setString(7, newMaritalStatus != null ? newMaritalStatus.trim() : "");
                pstmt.setInt(8, Integer.parseInt(newHeightStr.trim()));
                pstmt.setInt(9, (newWeightStr != null && !newWeightStr.trim().isEmpty()) ? Integer.parseInt(newWeightStr.trim()) : 0);
                pstmt.setString(10, newCity != null ? newCity.trim() : "");
                pstmt.setString(11, newState != null ? newState.trim() : "");
                pstmt.setString(12, newPhone != null ? newPhone.trim() : "");
                pstmt.setString(13, newAboutMe != null ? newAboutMe.trim() : "");
                pstmt.setString(14, newPreferences != null ? newPreferences.trim() : "");
                pstmt.setString(15, newFamilyDetails != null ? newFamilyDetails.trim() : "");
                pstmt.setInt(16, userId);
                
                int rows = pstmt.executeUpdate();
                
                if (rows > 0) {
                    message = "Profile updated successfully!";
                    messageType = "success";
                    
                    // Refresh data
                    name = newName.trim();
                    age = Integer.parseInt(newAgeStr.trim());
                    gender = newGender != null ? newGender.trim() : "";
                    religion = newReligion != null ? newReligion.trim() : "";
                    education = newEducation != null ? newEducation.trim() : "";
                    occupation = newOccupation != null ? newOccupation.trim() : "";
                    maritalStatus = newMaritalStatus != null ? newMaritalStatus.trim() : "";
                    height = Integer.parseInt(newHeightStr.trim());
                    weight = (newWeightStr != null && !newWeightStr.trim().isEmpty()) ? Integer.parseInt(newWeightStr.trim()) : 0;
                    city = newCity != null ? newCity.trim() : "";
                    state = newState != null ? newState.trim() : "";
                    phone = newPhone != null ? newPhone.trim() : "";
                    aboutMe = newAboutMe != null ? newAboutMe.trim() : "";
                    preferences = newPreferences != null ? newPreferences.trim() : "";
                    familyDetails = newFamilyDetails != null ? newFamilyDetails.trim() : "";
                }
            } catch (Exception e) {
                message = "Error updating profile: " + e.getMessage();
                messageType = "danger";
                e.printStackTrace();
            } finally {
                closeResources(conn, pstmt, null);
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - Matrimony Website</title>
    <link rel="stylesheet" href="CSS/styles.css">
</head>
<body>
    <header>
        <nav class="navbar">
            <a href="index.jsp" class="logo">MatrimonyHub</a>
            <ul>
                <li><a href="user-dashboard.jsp">Dashboard</a></li>
                <li><a href="browse-profiles.jsp">Browse Profiles</a></li>
                <li><a href="edit-profile.jsp">My Profile</a></li>
                <li><a href="premium.jsp">Premium</a></li>
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
                <h2>Edit Your Profile</h2>
            </div>

            <% if (!message.isEmpty()) { %>
                <div class="alert alert-<%= messageType %>">
                    <%= message %>
                </div>
            <% } %>

            <form method="POST" action="edit-profile.jsp">
                <h3 style="color: #e91e63; margin-bottom: 20px;">Personal Information</h3>
                
                <div class="form-group">
                    <label for="name">Full Name *</label>
                    <input type="text" id="name" name="name" class="form-control" 
                           value="<%= name %>" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="age">Age *</label>
                        <input type="number" id="age" name="age" class="form-control" 
                               value="<%= age %>" min="18" max="100" required>
                    </div>
                    <div class="form-group">
                        <label for="gender">Gender *</label>
                        <select id="gender" name="gender" class="form-control" required>
                            <option value="MALE" <%= "MALE".equals(gender) ? "selected" : "" %>>Male</option>
                            <option value="FEMALE" <%= "FEMALE".equals(gender) ? "selected" : "" %>>Female</option>
                            <option value="OTHER" <%= "OTHER".equals(gender) ? "selected" : "" %>>Other</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="religion">Religion *</label>
                        <select id="religion" name="religion" class="form-control" required>
                            <option value="Islam" <%= "Islam".equals(religion) ? "selected" : "" %>>Islam</option>
                            <option value="Hinduism" <%= "Hinduism".equals(religion) ? "selected" : "" %>>Hinduism</option>
                            <option value="Buddhism" <%= "Buddhism".equals(religion) ? "selected" : "" %>>Buddhism</option>
                            <option value="Christianity" <%= "Christianity".equals(religion) ? "selected" : "" %>>Christianity</option>
                            <option value="Other" <%= "Other".equals(religion) ? "selected" : "" %>>Other</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="maritalStatus">Marital Status *</label>
                        <select id="maritalStatus" name="maritalStatus" class="form-control" required>
                            <option value="NEVER_MARRIED" <%= "NEVER_MARRIED".equals(maritalStatus) ? "selected" : "" %>>Never Married</option>
                            <option value="DIVORCED" <%= "DIVORCED".equals(maritalStatus) ? "selected" : "" %>>Divorced</option>
                            <option value="WIDOWED" <%= "WIDOWED".equals(maritalStatus) ? "selected" : "" %>>Widowed</option>
                        </select>
                    </div>
                </div>

                <h3 style="color: #e91e63; margin: 30px 0 20px;">Educational & Professional Details</h3>

                <div class="form-group">
                    <label for="education">Education *</label>
                    <input type="text" id="education" name="education" class="form-control" 
                           value="<%= education %>" required>
                </div>

                <div class="form-group">
                    <label for="occupation">Occupation *</label>
                    <input type="text" id="occupation" name="occupation" class="form-control" 
                           value="<%= occupation %>" required>
                </div>

                <h3 style="color: #e91e63; margin: 30px 0 20px;">Physical Attributes</h3>

                <div class="form-row">
                    <div class="form-group">
                        <label for="height">Height (cm) *</label>
                        <input type="number" id="height" name="height" class="form-control" 
                               value="<%= height %>" min="100" max="250" required>
                    </div>
                    <div class="form-group">
                        <label for="weight">Weight (kg)</label>
                        <input type="number" id="weight" name="weight" class="form-control" 
                               value="<%= weight > 0 ? weight : "" %>" min="30" max="200">
                    </div>
                </div>

                <h3 style="color: #e91e63; margin: 30px 0 20px;">Location & Contact</h3>

                <div class="form-row">
                    <div class="form-group">
                        <label for="city">City *</label>
                        <input type="text" id="city" name="city" class="form-control" 
                               value="<%= city %>" required>
                    </div>
                    <div class="form-group">
                        <label for="state">State/Division *</label>
                        <input type="text" id="state" name="state" class="form-control" 
                               value="<%= state %>" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number *</label>
                    <input type="tel" id="phone" name="phone" class="form-control" 
                           value="<%= phone %>" required>
                </div>

                <h3 style="color: #e91e63; margin: 30px 0 20px;">About You</h3>

                <div class="form-group">
                    <label for="aboutMe">About Me *</label>
                    <textarea id="aboutMe" name="aboutMe" class="form-control" required><%= aboutMe %></textarea>
                </div>

                <div class="form-group">
                    <label for="preferences">Partner Preferences</label>
                    <textarea id="preferences" name="preferences" class="form-control"><%= preferences %></textarea>
                </div>

                <div class="form-group">
                    <label for="familyDetails">Family Details</label>
                    <textarea id="familyDetails" name="familyDetails" class="form-control"><%= familyDetails %></textarea>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">Update Profile</button>
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
