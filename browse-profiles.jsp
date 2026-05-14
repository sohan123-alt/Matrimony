<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db-config.jsp" %>
<%@ page import="java.util.*" %>
<%
    Integer userId = null;
    boolean userIsPremium = false;
    
    if (isLoggedIn(session)) {
        userId = (Integer) session.getAttribute("userId");
        userIsPremium = isPremium(session);
    }
    
    // Get filter parameters
    String genderFilter = request.getParameter("gender");
    String religionFilter = request.getParameter("religion");
    String ageFromStr = request.getParameter("ageFrom");
    String ageToStr = request.getParameter("ageTo");
    
    List<Map<String, Object>> profiles = new ArrayList<>();
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = getConnection();
        
        StringBuilder sql = new StringBuilder(
            "SELECT p.profile_id, p.name, p.age, p.gender, p.religion, p.education, " +
            "p.occupation, p.city, p.state, p.is_verified, p.is_premium " +
            "FROM PROFILES p WHERE p.is_verified = 'YES'"
        );
        
        // Add filters
        List<Object> params = new ArrayList<>();
        
        if (genderFilter != null && !genderFilter.isEmpty()) {
            sql.append(" AND p.gender = ?");
            params.add(genderFilter);
        }
        
        if (religionFilter != null && !religionFilter.isEmpty()) {
            sql.append(" AND p.religion = ?");
            params.add(religionFilter);
        }
        
        if (ageFromStr != null && !ageFromStr.isEmpty()) {
            sql.append(" AND p.age >= ?");
            params.add(Integer.parseInt(ageFromStr));
        }
        
        if (ageToStr != null && !ageToStr.isEmpty()) {
            sql.append(" AND p.age <= ?");
            params.add(Integer.parseInt(ageToStr));
        }
        
        sql.append(" ORDER BY p.created_date DESC");
        
        pstmt = conn.prepareStatement(sql.toString());
        
        for (int i = 0; i < params.size(); i++) {
            Object param = params.get(i);
            if (param instanceof String) {
                pstmt.setString(i + 1, (String) param);
            } else if (param instanceof Integer) {
                pstmt.setInt(i + 1, (Integer) param);
            }
        }
        
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> profile = new HashMap<>();
            profile.put("profileId", rs.getInt("profile_id"));
            profile.put("name", rs.getString("name"));
            profile.put("age", rs.getInt("age"));
            profile.put("gender", rs.getString("gender"));
            profile.put("religion", rs.getString("religion"));
            profile.put("education", rs.getString("education"));
            profile.put("occupation", rs.getString("occupation"));
            profile.put("city", rs.getString("city"));
            profile.put("state", rs.getString("state"));
            profile.put("isVerified", rs.getString("is_verified"));
            profile.put("isPremium", rs.getString("is_premium"));
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
    <title>Browse Profiles - Matrimony Website</title>
    <link rel="stylesheet" href="CSS/styles.css">
</head>
<body>
    <header>
        <nav class="navbar">
            <a href="index.jsp" class="logo">MatrimonyHub</a>
            <ul>
                <li><a href="index.jsp">Home</a></li>
                <li><a href="browse-profiles.jsp">Browse Profiles</a></li>
                <% if (isLoggedIn(session)) { %>
                    <li><a href="user-dashboard.jsp">Dashboard</a></li>
                    <li>
                        <div class="user-info">
                            <span><%= session.getAttribute("email") %></span>
                            <a href="logout.jsp" class="btn btn-danger">Logout</a>
                        </div>
                    </li>
                <% } else { %>
                    <li><a href="login.jsp" class="btn btn-outline">Login</a></li>
                    <li><a href="register.jsp" class="btn btn-primary">Register</a></li>
                <% } %>
            </ul>
        </nav>
    </header>

    <div class="container">
        <h1 class="mt-30" style="color: #e91e63;">Browse Profiles</h1>
        
        <!-- Search Filters -->
        <div class="card mt-20">
            <div class="card-header">
                <h2>Search Filters</h2>
            </div>
            <form method="GET" action="browse-profiles.jsp">
                <div class="form-row-3">
                    <div class="form-group">
                        <label for="gender">Gender</label>
                        <select id="gender" name="gender" class="form-control">
                            <option value="">All</option>
                            <option value="MALE" <%= "MALE".equals(genderFilter) ? "selected" : "" %>>Male</option>
                            <option value="FEMALE" <%= "FEMALE".equals(genderFilter) ? "selected" : "" %>>Female</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="religion">Religion</label>
                        <select id="religion" name="religion" class="form-control">
                            <option value="">All</option>
                            <option value="Islam" <%= "Islam".equals(religionFilter) ? "selected" : "" %>>Islam</option>
                            <option value="Hinduism" <%= "Hinduism".equals(religionFilter) ? "selected" : "" %>>Hinduism</option>
                            <option value="Buddhism" <%= "Buddhism".equals(religionFilter) ? "selected" : "" %>>Buddhism</option>
                            <option value="Christianity" <%= "Christianity".equals(religionFilter) ? "selected" : "" %>>Christianity</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label>Age Range</label>
                        <div style="display: flex; gap: 10px;">
                            <input type="number" name="ageFrom" class="form-control" placeholder="From" 
                                   value="<%= ageFromStr != null ? ageFromStr : "" %>" min="18" max="100">
                            <input type="number" name="ageTo" class="form-control" placeholder="To" 
                                   value="<%= ageToStr != null ? ageToStr : "" %>" min="18" max="100">
                        </div>
                    </div>
                </div>
                
                <div class="btn-group mt-20">
                    <button type="submit" class="btn btn-primary">Apply Filters</button>
                    <a href="browse-profiles.jsp" class="btn btn-secondary">Clear Filters</a>
                </div>
            </form>
        </div>

        <!-- Results -->
        <h2 class="mt-30" style="color: #e91e63;">
            <%= profiles.size() %> Profile<%= profiles.size() != 1 ? "s" : "" %> Found
        </h2>

        <% if (profiles.isEmpty()) { %>
            <div class="alert alert-info mt-20">
                No profiles found matching your criteria. Try adjusting your filters.
            </div>
        <% } else { %>
            <div class="profile-grid mt-20">
                <% for (Map<String, Object> profile : profiles) { %>
                    <div class="profile-card">
                        <div class="profile-header">
                            <div class="profile-avatar">
                                <%= "MALE".equals(profile.get("gender")) ? "👨" : 
                                    "FEMALE".equals(profile.get("gender")) ? "👩" : "🧑" %>
                            </div>
                            <div class="profile-name"><%= profile.get("name") %></div>
                            <p style="margin-top: 5px;">
                                <%= profile.get("age") %> years | <%= profile.get("gender") %>
                            </p>
                        </div>
                        
                        <div class="profile-details">
                            <div class="profile-detail-item">
                                <span class="profile-detail-label">Religion</span>
                                <span class="profile-detail-value"><%= profile.get("religion") %></span>
                            </div>
                            <div class="profile-detail-item">
                                <span class="profile-detail-label">Education</span>
                                <span class="profile-detail-value"><%= profile.get("education") %></span>
                            </div>
                            <div class="profile-detail-item">
                                <span class="profile-detail-label">Occupation</span>
                                <span class="profile-detail-value"><%= profile.get("occupation") %></span>
                            </div>
                            <div class="profile-detail-item">
                                <span class="profile-detail-label">Location</span>
                                <span class="profile-detail-value">
                                    <%= profile.get("city") %>, <%= profile.get("state") %>
                                </span>
                            </div>
                            
                            <div style="margin-top: 15px; text-align: center;">
                                <% if ("YES".equals(profile.get("isVerified"))) { %>
                                    <span class="badge badge-success">✓ Verified</span>
                                <% } %>
                                <% if ("YES".equals(profile.get("isPremium"))) { %>
                                    <span class="badge badge-premium">💎 Premium</span>
                                <% } %>
                            </div>
                        </div>
                        
                        <div style="padding: 20px;">
                            <% if (isLoggedIn(session)) { %>
                                <a href="view-my-profile.jsp?id=<%= profile.get("profileId") %>" 
                                   class="btn btn-primary btn-block">View Full Profile</a>
                                <% if (!userIsPremium) { %>
                                    <p style="text-align: center; margin-top: 10px; font-size: 12px; color: #666;">
                                        <a href="premium.jsp" style="color: #e91e63;">Upgrade to Premium</a> to view contact details
                                    </p>
                                <% } %>
                            <% } else { %>
                                <a href="login.jsp" class="btn btn-primary btn-block">Login to View Profile</a>
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
