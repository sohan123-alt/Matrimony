<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome - Matrimony Website</title>
    <link rel="stylesheet" href="CSS/styles.css">
</head>
<body>
    <header>
        <nav class="navbar">
            <a href="index.jsp" class="logo">MatrimonyHub</a>
            <ul>
                <li><a href="index.jsp">Home</a></li>
                <li><a href="browse-profiles.jsp">Browse Profiles</a></li>
                <li><a href="about.jsp">About</a></li>
                <% if (session.getAttribute("userId") == null) { %>
                    <li><a href="login.jsp" class="btn btn-outline">Login</a></li>
                    <li><a href="register.jsp" class="btn btn-primary">Register</a></li>
                <% } else { %>
                    <li>
                        <div class="user-info">
                            <span>Welcome, <%= session.getAttribute("email") %></span>
                            <a href="logout.jsp" class="btn btn-danger">Logout</a>
                        </div>
                    </li>
                <% } %>
            </ul>
        </nav>
    </header>

    <div class="container">
        <!-- Hero Section -->
        <div class="card text-center mt-30 fade-in" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 60px;">
            <h1 style="font-size: 48px; margin-bottom: 20px;">Find Your Perfect Life Partner</h1>
            <p style="font-size: 20px; margin-bottom: 30px;">Trusted by thousands of families across Bangladesh</p>
            <div class="btn-group" style="justify-content: center;">
                <a href="register.jsp" class="btn" style="background: white; color: #667eea;">Get Started Free</a>
                <a href="browse-profiles.jsp" class="btn btn-outline" style="border-color: white; color: white;">Browse Profiles</a>
            </div>
        </div>

        <!-- Stats Section -->
        <div class="stats-grid mt-30">
            <div class="stat-card">
                <div class="stat-icon primary">👥</div>
                <div class="stat-content">
                    <h3>10,000+</h3>
                    <p>Active Members</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon success">💑</div>
                <div class="stat-content">
                    <h3>1,000+</h3>
                    <p>Success Stories</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon warning">✓</div>
                <div class="stat-content">
                    <h3>100%</h3>
                    <p>Verified Profiles</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon info">🔒</div>
                <div class="stat-content">
                    <h3>Secure</h3>
                    <p>Privacy Protected</p>
                </div>
            </div>
        </div>

        <!-- Features Section -->
        <h2 class="text-center mt-30" style="color: #e91e63; font-size: 36px;">Why Choose MatrimonyHub?</h2>
        
        <div class="dashboard-grid mt-30">
            <div class="widget">
                <div style="text-align: center; padding: 20px;">
                    <div style="font-size: 48px; margin-bottom: 15px;">🔍</div>
                    <h3 style="color: #e91e63; margin-bottom: 10px;">Advanced Search</h3>
                    <p style="color: #666;">Find matches based on religion, education, location, and preferences</p>
                </div>
            </div>
            
            <div class="widget">
                <div style="text-align: center; padding: 20px;">
                    <div style="font-size: 48px; margin-bottom: 15px;">✓</div>
                    <h3 style="color: #e91e63; margin-bottom: 10px;">Verified Profiles</h3>
                    <p style="color: #666;">All profiles are manually verified by our team for authenticity</p>
                </div>
            </div>
            
            <div class="widget">
                <div style="text-align: center; padding: 20px;">
                    <div style="font-size: 48px; margin-bottom: 15px;">🔒</div>
                    <h3 style="color: #e91e63; margin-bottom: 10px;">Privacy & Security</h3>
                    <p style="color: #666;">Your information is safe and secure with us</p>
                </div>
            </div>
            
            <div class="widget">
                <div style="text-align: center; padding: 20px;">
                    <div style="font-size: 48px; margin-bottom: 15px;">💎</div>
                    <h3 style="color: #e91e63; margin-bottom: 10px;">Premium Features</h3>
                    <p style="color: #666;">Unlock unlimited access with premium membership</p>
                </div>
            </div>
        </div>

        <!-- How It Works -->
        <div class="card mt-30">
            <h2 class="text-center" style="color: #e91e63; font-size: 36px; margin-bottom: 30px;">How It Works</h2>
            <div class="form-row-3">
                <div style="text-align: center;">
                    <div style="width: 80px; height: 80px; background: #e91e63; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 15px; color: white; font-size: 32px; font-weight: bold;">1</div>
                    <h4 style="margin-bottom: 10px;">Register Free</h4>
                    <p style="color: #666;">Create your account in minutes</p>
                </div>
                <div style="text-align: center;">
                    <div style="width: 80px; height: 80px; background: #673ab7; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 15px; color: white; font-size: 32px; font-weight: bold;">2</div>
                    <h4 style="margin-bottom: 10px;">Create Profile</h4>
                    <p style="color: #666;">Add your details and preferences</p>
                </div>
                <div style="text-align: center;">
                    <div style="width: 80px; height: 80px; background: #4caf50; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 15px; color: white; font-size: 32px; font-weight: bold;">3</div>
                    <h4 style="margin-bottom: 10px;">Find Match</h4>
                    <p style="color: #666;">Connect with compatible partners</p>
                </div>
            </div>
        </div>

        <!-- CTA Section -->
        <div class="card text-center mt-30" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); color: white; padding: 50px;">
            <h2 style="font-size: 36px; margin-bottom: 20px;">Ready to Find Your Soulmate?</h2>
            <p style="font-size: 18px; margin-bottom: 30px;">Join thousands of happy couples who found their perfect match</p>
            <a href="register.jsp" class="btn" style="background: white; color: #11998e; padding: 15px 40px; font-size: 18px;">Join Now - It's Free!</a>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 MatrimonyHub. All Rights Reserved.</p>
        <p>Find Your Perfect Match | Safe & Secure Platform</p>
    </footer>
</body>
</html>
