<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db-config.jsp" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    if (!isLoggedIn(session)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String profileIdStr = request.getParameter("id");
    boolean userIsPremium = isPremium(session);
    boolean isAdminUser = isAdmin(session);
    
    if (profileIdStr == null) {
        response.sendRedirect("browse-profiles.jsp");
        return;
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    Map<String, Object> profile = new HashMap<>();
    boolean profileFound = false;
    
    try {
        conn = getConnection();
        
        String sql = "SELECT p.*, u.email FROM PROFILES p " +
                   "JOIN USERS3 u ON p.user_id = u.user_id " +
                   "WHERE p.profile_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(profileIdStr));
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            profileFound = true;
            profile.put("profileId", rs.getInt("profile_id"));
            profile.put("userId", rs.getInt("user_id"));
            profile.put("name", rs.getString("name"));
            profile.put("age", rs.getInt("age"));
            profile.put("gender", rs.getString("gender"));
            profile.put("religion", rs.getString("religion"));
            profile.put("education", rs.getString("education"));
            profile.put("occupation", rs.getString("occupation"));
            profile.put("maritalStatus", rs.getString("marital_status"));
            profile.put("height", rs.getInt("height"));
            profile.put("weight", rs.getInt("weight"));
            profile.put("city", rs.getString("city"));
            profile.put("state", rs.getString("state"));
            profile.put("country", rs.getString("country"));
            profile.put("phone", rs.getString("phone"));
            profile.put("aboutMe", rs.getString("about_me"));
            profile.put("preferences", rs.getString("preferences"));
            profile.put("familyDetails", rs.getString("family_details"));
            profile.put("isVerified", rs.getString("is_verified"));
            profile.put("isPremium", rs.getString("is_premium"));
            profile.put("email", rs.getString("email"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        closeResources(conn, pstmt, rs);
    }
    
    if (!profileFound) {
        response.sendRedirect("browse-profiles.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= profile.get("name") %> - Profile</title>
    <link rel="stylesheet" href="CSS/styles.css">
</head>
<body>
    <header>
        <nav class="navbar">
            <a href="index.jsp" class="logo">MatrimonyHub</a>
            <ul>
                <li><a href="<%= isAdminUser ? "admin-dashboard.jsp" : "user-dashboard.jsp" %>">Dashboard</a></li>
                <li><a href="browse-profiles.jsp">Browse Profiles</a></li>
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
            <!-- Profile Header -->
            <div style="background: linear-gradient(135deg, #e91e63 0%, #673ab7 100%); color: white; padding: 40px; border-radius: 8px 8px 0 0; text-align: center;">
                <div class="profile-avatar" style="width: 150px; height: 150px; margin: 0 auto 20px; font-size: 80px; border: 5px solid white;">
                    <%= "MALE".equals(profile.get("gender")) ? "👨" : 
                        "FEMALE".equals(profile.get("gender")) ? "👩" : "🧑" %>
                </div>
                <h1 style="font-size: 36px; margin-bottom: 10px;"><%= profile.get("name") %></h1>
                <p style="font-size: 20px; opacity: 0.9;">
                    <%= profile.get("age") %> years | <%= profile.get("gender") %>
                </p>
                <div style="margin-top: 20px;">
                    <% if ("YES".equals(profile.get("isVerified"))) { %>
                        <span class="badge" style="background: white; color: #4caf50; padding: 8px 20px; font-size: 14px;">
                            ✓ Verified Profile
                        </span>
                    <% } %>
                    <% if ("YES".equals(profile.get("isPremium"))) { %>
                        <span class="badge badge-premium" style="padding: 8px 20px; font-size: 14px;">
                            💎 Premium Member
                        </span>
                    <% } %>
                </div>
            </div>

            <!-- Profile Details -->
            <div style="padding: 40px;">
                <h2 style="color: #e91e63; margin-bottom: 25px; font-size: 28px;">Personal Information</h2>
                
                <div class="form-row">
                    <div style="margin-bottom: 20px;">
                        <h4 style="color: #666; margin-bottom: 5px;">Religion</h4>
                        <p style="font-size: 18px;"><%= profile.get("religion") %></p>
                    </div>
                    <div style="margin-bottom: 20px;">
                        <h4 style="color: #666; margin-bottom: 5px;">Marital Status</h4>
                        <p style="font-size: 18px;"><%= profile.get("maritalStatus") != null ? profile.get("maritalStatus").toString().replace("_", " ") : "" %></p>
                    </div>
                </div>

                <h2 style="color: #e91e63; margin: 30px 0 25px; font-size: 28px;">Education & Career</h2>
                
                <div style="margin-bottom: 20px;">
                    <h4 style="color: #666; margin-bottom: 5px;">Education</h4>
                    <p style="font-size: 18px;"><%= profile.get("education") %></p>
                </div>
                
                <div style="margin-bottom: 20px;">
                    <h4 style="color: #666; margin-bottom: 5px;">Occupation</h4>
                    <p style="font-size: 18px;"><%= profile.get("occupation") %></p>
                </div>

                <h2 style="color: #e91e63; margin: 30px 0 25px; font-size: 28px;">Physical Attributes</h2>
                
                <div class="form-row">
                    <div style="margin-bottom: 20px;">
                        <h4 style="color: #666; margin-bottom: 5px;">Height</h4>
                        <p style="font-size: 18px;"><%= profile.get("height") %> cm</p>
                    </div>
                    <div style="margin-bottom: 20px;">
                        <h4 style="color: #666; margin-bottom: 5px;">Weight</h4>
                        <p style="font-size: 18px;"><%= profile.get("weight") != null && (Integer)profile.get("weight") > 0 ? profile.get("weight") + " kg" : "Not specified" %></p>
                    </div>
                </div>

                <h2 style="color: #e91e63; margin: 30px 0 25px; font-size: 28px;">Location</h2>
                
                <div style="margin-bottom: 20px;">
                    <h4 style="color: #666; margin-bottom: 5px;">Address</h4>
                    <p style="font-size: 18px;">
                        <%= profile.get("city") %>, <%= profile.get("state") %>, <%= profile.get("country") %>
                    </p>
                </div>

                <% if (userIsPremium || isAdminUser) { %>
                    <h2 style="color: #e91e63; margin: 30px 0 25px; font-size: 28px;">Contact Information</h2>
                    
                    <div class="form-row">
                        <div style="margin-bottom: 20px;">
                            <h4 style="color: #666; margin-bottom: 5px;">Email</h4>
                            <p style="font-size: 18px;"><%= profile.get("email") %></p>
                        </div>
                        <div style="margin-bottom: 20px;">
                            <h4 style="color: #666; margin-bottom: 5px;">Phone</h4>
                            <p style="font-size: 18px;"><%= profile.get("phone") %></p>
                        </div>
                    </div>
                <% } else { %>
                    <div class="alert alert-warning mt-30">
                        <strong>🔒 Premium Feature:</strong> 
                        <a href="premium.jsp" style="color: #e91e63; font-weight: 600;">Upgrade to Premium</a> 
                        to view contact details and send unlimited messages.
                    </div>
                <% } %>

                <% if (profile.get("aboutMe") != null && !profile.get("aboutMe").toString().isEmpty()) { %>
                    <h2 style="color: #e91e63; margin: 30px 0 25px; font-size: 28px;">About Me</h2>
                    <div style="background: #f5f5f5; padding: 20px; border-radius: 8px; line-height: 1.8;">
                        <%= profile.get("aboutMe") %>
                    </div>
                <% } %>

                <% if (profile.get("preferences") != null && !profile.get("preferences").toString().isEmpty()) { %>
                    <h2 style="color: #e91e63; margin: 30px 0 25px; font-size: 28px;">Partner Preferences</h2>
                    <div style="background: #f5f5f5; padding: 20px; border-radius: 8px; line-height: 1.8;">
                        <%= profile.get("preferences") %>
                    </div>
                <% } %>

                <% if (profile.get("familyDetails") != null && !profile.get("familyDetails").toString().isEmpty()) { %>
                    <h2 style="color: #e91e63; margin: 30px 0 25px; font-size: 28px;">Family Details</h2>
                    <div style="background: #f5f5f5; padding: 20px; border-radius: 8px; line-height: 1.8;">
                        <%= profile.get("familyDetails") %>
                    </div>
                <% } %>

                <!-- Action Buttons -->
                <div class="btn-group mt-30">
                    <a href="browse-profiles.jsp" class="btn btn-secondary">Back to Profiles</a>
                    <% if (userIsPremium || isAdminUser) { %>
                        <button class="btn btn-primary" onclick="alert('Interest sent! (Feature coming soon)')">
                            Send Interest
                        </button>
                    <% } else { %>
                        <a href="premium.jsp" class="btn btn-warning">Upgrade to Connect</a>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 MatrimonyHub. All Rights Reserved.</p>
    </footer>
</body>
</html>
