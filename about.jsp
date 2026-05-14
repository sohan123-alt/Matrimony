<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - MatrimonyHub</title>
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
        <div class="card text-center mt-30 fade-in" style="background: linear-gradient(135deg, #e91e63 0%, #673ab7 100%); color: white; padding: 60px;">
            <h1 style="font-size: 48px; margin-bottom: 20px;">About MatrimonyHub</h1>
            <p style="font-size: 20px; max-width: 800px; margin: 0 auto;">
                Connecting hearts, building families, and creating lifelong partnerships
            </p>
        </div>

        <!-- Our Story -->
        <div class="card mt-30">
            <div class="card-header">
                <h2>📖 Our Story</h2>
            </div>
            <div class="card-body">
                <p style="font-size: 18px; line-height: 1.8; color: #333;">
                    MatrimonyHub was founded with a simple yet powerful mission: to help people find their perfect life partner 
                    in a safe, secure, and dignified manner. In today's fast-paced world, finding the right person to spend 
                    your life with can be challenging. We understand the importance of compatibility, shared values, and family 
                    traditions in building a successful marriage.
                </p>
                <p style="font-size: 18px; line-height: 1.8; color: #333; margin-top: 20px;">
                    Since our inception, we have successfully connected thousands of individuals with their soulmates, creating 
                    countless happy families. Our platform combines traditional matchmaking values with modern technology to 
                    provide a comprehensive and user-friendly matrimonial service.
                </p>
            </div>
        </div>

        <!-- Mission & Vision -->
        <div class="form-row mt-30">
            <div class="card">
                <div style="text-align: center; padding: 30px;">
                    <div style="font-size: 60px; margin-bottom: 20px;">🎯</div>
                    <h2 style="color: #e91e63; margin-bottom: 15px;">Our Mission</h2>
                    <p style="font-size: 16px; line-height: 1.8; color: #666;">
                        To provide a trusted, secure, and efficient platform that helps individuals find compatible life 
                        partners while respecting cultural values, family traditions, and personal preferences.
                    </p>
                </div>
            </div>

            <div class="card">
                <div style="text-align: center; padding: 30px;">
                    <div style="font-size: 60px; margin-bottom: 20px;">👁️</div>
                    <h2 style="color: #e91e63; margin-bottom: 15px;">Our Vision</h2>
                    <p style="font-size: 16px; line-height: 1.8; color: #666;">
                        To be the most trusted matrimonial platform in Bangladesh, known for our commitment to quality, 
                        safety, and successful matches. We envision a future where every person finds their ideal partner 
                        through our service.
                    </p>
                </div>
            </div>
        </div>

        <!-- Our Values -->
        <div class="card mt-30">
            <div class="card-header">
                <h2>💎 Our Core Values</h2>
            </div>
            <div class="dashboard-grid">
                <div style="padding: 25px; border-radius: 8px; background: #f8f9fa;">
                    <div style="font-size: 40px; margin-bottom: 15px;">🔒</div>
                    <h3 style="color: #e91e63; margin-bottom: 10px;">Privacy & Security</h3>
                    <p style="color: #666;">
                        Your personal information is sacred to us. We employ industry-leading security measures to 
                        protect your data and ensure complete privacy.
                    </p>
                </div>

                <div style="padding: 25px; border-radius: 8px; background: #f8f9fa;">
                    <div style="font-size: 40px; margin-bottom: 15px;">✓</div>
                    <h3 style="color: #e91e63; margin-bottom: 10px;">Authenticity</h3>
                    <p style="color: #666;">
                        Every profile is manually verified by our team to ensure genuine users and authentic information, 
                        giving you peace of mind.
                    </p>
                </div>

                <div style="padding: 25px; border-radius: 8px; background: #f8f9fa;">
                    <div style="font-size: 40px; margin-bottom: 15px;">🤝</div>
                    <h3 style="color: #e91e63; margin-bottom: 10px;">Respect & Dignity</h3>
                    <p style="color: #666;">
                        We treat every member with respect and maintain the dignity of the matrimonial search process, 
                        honoring cultural and religious values.
                    </p>
                </div>

                <div style="padding: 25px; border-radius: 8px; background: #f8f9fa;">
                    <div style="font-size: 40px; margin-bottom: 15px;">🎯</div>
                    <h3 style="color: #e91e63; margin-bottom: 10px;">Quality Matches</h3>
                    <p style="color: #666;">
                        Our advanced matching algorithm and personalized service ensure you find compatible partners who 
                        share your values and life goals.
                    </p>
                </div>

                <div style="padding: 25px; border-radius: 8px; background: #f8f9fa;">
                    <div style="font-size: 40px; margin-bottom: 15px;">💬</div>
                    <h3 style="color: #e91e63; margin-bottom: 10px;">Customer Support</h3>
                    <p style="color: #666;">
                        Our dedicated support team is always ready to assist you throughout your journey to find your 
                        perfect match.
                    </p>
                </div>

                <div style="padding: 25px; border-radius: 8px; background: #f8f9fa;">
                    <div style="font-size: 40px; margin-bottom: 15px;">🌟</div>
                    <h3 style="color: #e91e63; margin-bottom: 10px;">Transparency</h3>
                    <p style="color: #666;">
                        We believe in complete transparency in our processes, pricing, and policies. No hidden charges, 
                        no surprises.
                    </p>
                </div>
            </div>
        </div>

        <!-- Why Choose Us -->
        <div class="card mt-30">
            <div class="card-header">
                <h2>⭐ Why Choose MatrimonyHub?</h2>
            </div>
            <div class="card-body">
                <div class="form-row" style="margin-bottom: 25px;">
                    <div style="display: flex; gap: 20px; align-items: start;">
                        <div style="font-size: 40px; color: #e91e63;">✓</div>
                        <div>
                            <h3 style="color: #333; margin-bottom: 10px;">Verified Profiles</h3>
                            <p style="color: #666; line-height: 1.6;">
                                Every profile undergoes manual verification to ensure authenticity and genuineness.
                            </p>
                        </div>
                    </div>
                    <div style="display: flex; gap: 20px; align-items: start;">
                        <div style="font-size: 40px; color: #e91e63;">✓</div>
                        <div>
                            <h3 style="color: #333; margin-bottom: 10px;">Advanced Privacy Controls</h3>
                            <p style="color: #666; line-height: 1.6;">
                                You control who sees your information with our comprehensive privacy settings.
                            </p>
                        </div>
                    </div>
                </div>

                <div class="form-row" style="margin-bottom: 25px;">
                    <div style="display: flex; gap: 20px; align-items: start;">
                        <div style="font-size: 40px; color: #e91e63;">✓</div>
                        <div>
                            <h3 style="color: #333; margin-bottom: 10px;">Smart Matching</h3>
                            <p style="color: #666; line-height: 1.6;">
                                Our intelligent algorithm suggests compatible matches based on your preferences.
                            </p>
                        </div>
                    </div>
                    <div style="display: flex; gap: 20px; align-items: start;">
                        <div style="font-size: 40px; color: #e91e63;">✓</div>
                        <div>
                            <h3 style="color: #333; margin-bottom: 10px;">Dedicated Support</h3>
                            <p style="color: #666; line-height: 1.6;">
                                Our team is available to assist you throughout your matrimonial journey.
                            </p>
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div style="display: flex; gap: 20px; align-items: start;">
                        <div style="font-size: 40px; color: #e91e63;">✓</div>
                        <div>
                            <h3 style="color: #333; margin-bottom: 10px;">Success Stories</h3>
                            <p style="color: #666; line-height: 1.6;">
                                Thousands of successful marriages have started through our platform.
                            </p>
                        </div>
                    </div>
                    <div style="display: flex; gap: 20px; align-items: start;">
                        <div style="font-size: 40px; color: #e91e63;">✓</div>
                        <div>
                            <h3 style="color: #333; margin-bottom: 10px;">Affordable Pricing</h3>
                            <p style="color: #666; line-height: 1.6;">
                                Premium features at competitive prices with transparent billing.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Statistics -->
        <div class="stats-grid mt-30">
            <div class="stat-card">
                <div class="stat-icon success">👥</div>
                <div class="stat-content">
                    <h3>10,000+</h3>
                    <p>Active Members</p>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon primary">💑</div>
                <div class="stat-content">
                    <h3>5,000+</h3>
                    <p>Successful Marriages</p>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon warning">⭐</div>
                <div class="stat-content">
                    <h3>98%</h3>
                    <p>Satisfaction Rate</p>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon info">🏆</div>
                <div class="stat-content">
                    <h3>5+ Years</h3>
                    <p>Trusted Service</p>
                </div>
            </div>
        </div>

        <!-- How We Work -->
        <div class="card mt-30">
            <div class="card-header">
                <h2>🔄 How We Work</h2>
            </div>
            <div class="form-row-3">
                <div style="text-align: center; padding: 25px;">
                    <div style="width: 80px; height: 80px; background: linear-gradient(135deg, #e91e63 0%, #673ab7 100%); 
                                border-radius: 50%; display: flex; align-items: center; justify-content: center; 
                                margin: 0 auto 20px; color: white; font-size: 36px; font-weight: bold;">1</div>
                    <h3 style="color: #e91e63; margin-bottom: 15px;">Register Free</h3>
                    <p style="color: #666; line-height: 1.6;">
                        Create your account in minutes. It's completely free to register and browse profiles.
                    </p>
                </div>

                <div style="text-align: center; padding: 25px;">
                    <div style="width: 80px; height: 80px; background: linear-gradient(135deg, #e91e63 0%, #673ab7 100%); 
                                border-radius: 50%; display: flex; align-items: center; justify-content: center; 
                                margin: 0 auto 20px; color: white; font-size: 36px; font-weight: bold;">2</div>
                    <h3 style="color: #e91e63; margin-bottom: 15px;">Create Profile</h3>
                    <p style="color: #666; line-height: 1.6;">
                        Fill in your details and preferences. Our team verifies your profile for authenticity.
                    </p>
                </div>

                <div style="text-align: center; padding: 25px;">
                    <div style="width: 80px; height: 80px; background: linear-gradient(135deg, #e91e63 0%, #673ab7 100%); 
                                border-radius: 50%; display: flex; align-items: center; justify-content: center; 
                                margin: 0 auto 20px; color: white; font-size: 36px; font-weight: bold;">3</div>
                    <h3 style="color: #e91e63; margin-bottom: 15px;">Find Matches</h3>
                    <p style="color: #666; line-height: 1.6;">
                        Browse verified profiles and connect with compatible matches who share your values.
                    </p>
                </div>
            </div>
        </div>

        <!-- Team Section -->
        <div class="card mt-30">
            <div class="card-header">
                <h2>👨‍👩‍👧‍👦 Our Team</h2>
            </div>
            <div class="card-body">
                <p style="font-size: 18px; line-height: 1.8; color: #333; text-align: center; margin-bottom: 30px;">
                    Our dedicated team of matrimonial experts, customer support specialists, and verification officers 
                    work tirelessly to ensure you have the best experience on our platform.
                </p>
                <div class="form-row-3">
                    <div style="text-align: center;">
                        <div style="width: 100px; height: 100px; background: linear-gradient(135deg, #e91e63 0%, #673ab7 100%); 
                                    border-radius: 50%; display: flex; align-items: center; justify-content: center; 
                                    margin: 0 auto 15px; color: white; font-size: 48px;">👨‍💼</div>
                        <h4 style="color: #333; margin-bottom: 5px;">Expert Team</h4>
                        <p style="color: #666; font-size: 14px;">Customer Support</p>
                    </div>
                    <div style="text-align: center;">
                        <div style="width: 100px; height: 100px; background: linear-gradient(135deg, #e91e63 0%, #673ab7 100%); 
                                    border-radius: 50%; display: flex; align-items: center; justify-content: center; 
                                    margin: 0 auto 15px; color: white; font-size: 48px;">🔍</div>
                        <h4 style="color: #333; margin-bottom: 5px;">Verification Team</h4>
                        <p style="color: #666; font-size: 14px;">Profile Authentication</p>
                    </div>
                    <div style="text-align: center;">
                        <div style="width: 100px; height: 100px; background: linear-gradient(135deg, #e91e63 0%, #673ab7 100%); 
                                    border-radius: 50%; display: flex; align-items: center; justify-content: center; 
                                    margin: 0 auto 15px; color: white; font-size: 48px;">💻</div>
                        <h4 style="color: #333; margin-bottom: 5px;">Tech Team</h4>
                        <p style="color: #666; font-size: 14px;">Platform Development</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Contact Section -->
        <div class="card mt-30">
            <div class="card-header">
                <h2>📞 Get In Touch</h2>
            </div>
            <div class="form-row">
                <div>
                    <h3 style="color: #e91e63; margin-bottom: 15px;">Contact Information</h3>
                    <p style="margin-bottom: 15px; line-height: 1.8;">
                        <strong>Email:</strong> support@matrimonyhub.com<br>
                        <strong>Phone:</strong> +880 1712-345678<br>
                        <strong>Address:</strong> Dhaka, Bangladesh<br>
                        <strong>Hours:</strong> 24/7 Support Available
                    </p>
                </div>
                <div>
                    <h3 style="color: #e91e63; margin-bottom: 15px;">Follow Us</h3>
                    <p style="line-height: 1.8; color: #666;">
                        Stay connected with us on social media for updates, success stories, and matrimonial tips.
                    </p>
                    <div style="margin-top: 20px;">
                        <span style="font-size: 32px; margin-right: 15px;">📘</span>
                        <span style="font-size: 32px; margin-right: 15px;">📷</span>
                        <span style="font-size: 32px; margin-right: 15px;">🐦</span>
                        <span style="font-size: 32px;">▶️</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- CTA Section -->
        <div class="card text-center mt-30" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); color: white; padding: 50px;">
            <h2 style="font-size: 36px; margin-bottom: 20px;">Ready to Find Your Perfect Match?</h2>
            <p style="font-size: 18px; margin-bottom: 30px;">
                Join thousands of happy couples who found their soulmate through MatrimonyHub
            </p>
            <div class="btn-group" style="justify-content: center;">
                <a href="register.jsp" class="btn" style="background: white; color: #11998e; padding: 15px 40px; font-size: 18px;">
                    Register Now - It's Free!
                </a>
                <a href="browse-profiles.jsp" class="btn btn-outline" style="border-color: white; color: white; padding: 15px 40px; font-size: 18px;">
                    Browse Profiles
                </a>
            </div>
        </div>
    </div>

    <footer>
        <div style="padding: 30px 20px;">
            <p>&copy; 2026 MatrimonyHub. All Rights Reserved.</p>
            <p style="margin-top: 10px;">Find Your Perfect Match | Safe & Secure Platform</p>
            <p style="margin-top: 15px; font-size: 14px;">
                <a href="index.jsp" style="color: white; margin: 0 10px;">Home</a> |
                <a href="about.jsp" style="color: white; margin: 0 10px;">About</a> |
                <a href="browse-profiles.jsp" style="color: white; margin: 0 10px;">Browse</a> |
                <a href="premium.jsp" style="color: white; margin: 0 10px;">Premium</a>
            </p>
        </div>
    </footer>
</body>
</html>
