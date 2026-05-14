<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db-config.jsp" %>
<%
    if (!isLoggedIn(session)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Integer userId = (Integer) session.getAttribute("userId");
    String userEmail = (String) session.getAttribute("email");
    
    // Fetch user profile
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    boolean hasProfile = false;
    String profileName = "";
    String profileGender = "";
    int profileAge = 0;
    String isVerified = "NO";
    String isPremiumUser = "NO";
    
    try {
        conn = getConnection();
        
        String sql = "SELECT name, age, gender, is_verified, is_premium FROM PROFILES WHERE user_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, userId);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            hasProfile = true;
            profileName = rs.getString("name");
            profileAge = rs.getInt("age");
            profileGender = rs.getString("gender");
            isVerified = rs.getString("is_verified");
            isPremiumUser = rs.getString("is_premium");
            session.setAttribute("isPremium", isPremiumUser);
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
    <title>Dashboard - Matrimony Website</title>
    <link rel="stylesheet" href="CSS/styles.css">
</head>
<body>
    <header>
        <nav class="navbar">
            <a href="index.jsp" class="logo">MatrimonyHub</a>
            <ul>
                <li><a href="user-dashboard.jsp">Dashboard</a></li>
                <li><a href="browse-profiles.jsp">Browse Profiles</a></li>
                <% if (hasProfile) { %>
                    <li><a href="edit-profile.jsp">My Profile</a></li>
                <% } else { %>
                    <li><a href="create-profile.jsp">Create Profile</a></li>
                <% } %>
                <li><a href="premium.jsp">Premium</a></li>
                <li>
                    <div class="user-info">
                        <span><%= userEmail %></span>
                        <a href="logout.jsp" class="btn btn-danger">Logout</a>
                    </div>
                </li>
            </ul>
        </nav>
    </header>

    <div class="container">
        <h1 class="mt-30" style="color: #e91e63;">Welcome to Your Dashboard</h1>
        
        <% if (!hasProfile) { %>
            <div class="alert alert-warning mt-20">
                <strong>Complete your profile!</strong> Create your profile to start connecting with potential matches.
                <a href="create-profile.jsp" class="btn btn-primary" style="margin-left: 20px;">Create Profile Now</a>
            </div>
        <% } else { %>
            <% if ("NO".equals(isVerified)) { %>
                <div class="alert alert-info mt-20">
                    <strong>Profile Under Review:</strong> Your profile is being verified by our team. This usually takes 24-48 hours.
                </div>
            <% } %>
            
            <% if ("NO".equals(isPremiumUser)) { %>
                <div class="alert alert-warning mt-20">
                    <strong>Upgrade to Premium!</strong> Get unlimited access to contact details and send unlimited messages.
                    <a href="premium.jsp" class="btn btn-primary" style="margin-left: 20px;">View Plans</a>
                </div>
            <% } %>
        <% } %>

        <!-- Quick Stats -->
        <div class="stats-grid mt-30">
            <div class="stat-card">
                <div class="stat-icon primary">👤</div>
                <div class="stat-content">
                    <h3><%= hasProfile ? "Active" : "Incomplete" %></h3>
                    <p>Profile Status</p>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon <%= "YES".equals(isVerified) ? "success" : "warning" %>">
                    <%= "YES".equals(isVerified) ? "✓" : "⏳" %>
                </div>
                <div class="stat-content">
                    <h3><%= "YES".equals(isVerified) ? "Verified" : "Pending" %></h3>
                    <p>Verification Status</p>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon <%= "YES".equals(isPremiumUser) ? "success" : "info" %>">💎</div>
                <div class="stat-content">
                    <h3><%= "YES".equals(isPremiumUser) ? "Premium" : "Free" %></h3>
                    <p>Membership Type</p>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon info">👥</div>
                <div class="stat-content">
                    <h3>0</h3>
                    <p>Profile Views</p>
                </div>
            </div>
        </div>

        <% if (hasProfile) { %>
        <!-- Profile Overview -->
        <div class="card mt-30">
            <div class="card-header">
                <h2>Your Profile</h2>
            </div>
            <div class="card-body">
    <div style="display: flex; align-items: center; gap: 30px;">
        <div class="profile-avatar" style="width: 120px; height: 120px; font-size: 60px;">
            <%-- 
               সমাধান: "MALE".equals(variable) ব্যবহার করুন। 
               এতে variable যদি null-ও হয়, তবুও কোড ক্রাশ করবে না, শুধু false রিটার্ন করবে।
            --%>
            <%= "MALE".equals(profileGender) ? "👨" : "FEMALE".equals(profileGender) ? "👩" : "🧑" %>
        </div>
        <div>
            <h2 style="color: #e91e63; margin-bottom: 10px;">
                <%= (profileName != null) ? profileName : "User" %>
            </h2>
            <p style="font-size: 18px; color: #666; margin-bottom: 5px;">
                <%= profileAge %> years old | <%= (profileGender != null) ? profileGender : "Gender Not Set" %>
            </p>
            <div style="margin-top: 15px;">
                <% if ("YES".equals(isVerified)) { %>
                    <span class="badge badge-success">✓ Verified Profile</span>
                <% } else { %>
                    <span class="badge badge-warning">⏳ Verification Pending</span>
                <% } %>
                <% if ("YES".equals(isPremiumUser)) { %>
                    <span class="badge badge-premium">💎 Premium Member</span>
                <% } %>
            
        
    
</div>
                        <h2 style="color: #e91e63; margin-bottom: 10px;"><%= profileName %></h2>
                        <p style="font-size: 18px; color: #666; margin-bottom: 5px;">
                            <%= profileAge %> years old | <%= profileGender %>
                        </p>
                        <div style="margin-top: 15px;">
                            <% if ("YES".equals(isVerified)) { %>
                                <span class="badge badge-success">✓ Verified Profile</span>
                            <% } else { %>
                                <span class="badge badge-warning">⏳ Verification Pending</span>
                            <% } %>
                            <% if ("YES".equals(isPremiumUser)) { %>
                                <span class="badge badge-premium">💎 Premium Member</span>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-footer">
                <a href="view-my-profile.jsp" class="btn btn-primary">View Full Profile</a>
                <a href="edit-profile.jsp" class="btn btn-secondary">Edit Profile</a>
            </div>
        </div>
        <% } %>

        <!-- Quick Actions -->
        <h2 class="mt-30" style="color: #e91e63;">Quick Actions</h2>
        <div class="dashboard-grid mt-20">
            <div class="widget">
                <div style="text-align: center; padding: 20px;">
                    <div style="font-size: 48px; margin-bottom: 15px;">🔍</div>
                    <h3 style="margin-bottom: 10px;">Browse Profiles</h3>
                    <p style="color: #666; margin-bottom: 20px;">Find compatible matches</p>
                    <a href="browse-profiles.jsp" class="btn btn-primary">Start Browsing</a>
                </div>
            </div>
            
            <div class="widget">
                <div style="text-align: center; padding: 20px;">
                    <div style="font-size: 48px; margin-bottom: 15px;">💎</div>
                    <h3 style="margin-bottom: 10px;">Upgrade to Premium</h3>
                    <p style="color: #666; margin-bottom: 20px;">Get unlimited access</p>
                    <a href="premium.jsp" class="btn btn-warning">View Plans</a>
                </div>
            </div>
            
            <div class="widget">
                <div style="text-align: center; padding: 20px;">
                    <div style="font-size: 48px; margin-bottom: 15px;">⚙️</div>
                    <h3 style="margin-bottom: 10px;">Account Settings</h3>
                    <p style="color: #666; margin-bottom: 20px;">Manage your account</p>
                    <a href="settings.jsp" class="btn btn-secondary">Settings</a>
                </div>
            </div>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 MatrimonyHub. All Rights Reserved.</p>
    </footer>
</body>
</html>
