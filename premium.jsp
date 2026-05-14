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
    
    if (request.getMethod().equals("POST")) {
        String planType = request.getParameter("planType");
        String paymentMethod = request.getParameter("paymentMethod");
        String amountStr = request.getParameter("amount");
        String transactionId = request.getParameter("transactionId");
        
        if (planType != null && paymentMethod != null && amountStr != null) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            
            try {
                conn = getConnection();
                
                double amount = Double.parseDouble(amountStr);
                
                // Calculate plan dates
                java.sql.Date startDate = new java.sql.Date(System.currentTimeMillis());
                java.sql.Date endDate = null;
                
                java.util.Calendar cal = java.util.Calendar.getInstance();
                if ("MONTHLY".equals(planType)) {
                    cal.add(java.util.Calendar.MONTH, 1);
                } else if ("QUARTERLY".equals(planType)) {
                    cal.add(java.util.Calendar.MONTH, 3);
                } else if ("YEARLY".equals(planType)) {
                    cal.add(java.util.Calendar.YEAR, 1);
                }
                endDate = new java.sql.Date(cal.getTimeInMillis());
                
                // Insert payment record
                String sql = "INSERT INTO PAYMENTS (payment_id, user_id, amount, payment_method, plan_type, " +
                           "payment_status, transaction_id, plan_start_date, plan_end_date) " +
                           "VALUES (payment_seq.NEXTVAL, ?, ?, ?, ?, 'PENDING', ?, ?, ?)";
                
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, userId);
                pstmt.setDouble(2, amount);
                pstmt.setString(3, paymentMethod);
                pstmt.setString(4, planType);
                pstmt.setString(5, transactionId != null ? transactionId : "");
                pstmt.setDate(6, startDate);
                pstmt.setDate(7, endDate);
                
                int rows = pstmt.executeUpdate();
                
                if (rows > 0) {
                    message = "Payment request submitted successfully! Our team will verify and activate your premium membership within 24 hours.";
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
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Premium Membership - Matrimony Website</title>
    <link rel="stylesheet" href="CSS/styles.css">
</head>
<body>
    <header>
        <nav class="navbar">
            <a href="index.jsp" class="logo">MatrimonyHub</a>
            <ul>
                <li><a href="user-dashboard.jsp">Dashboard</a></li>
                <li><a href="browse-profiles.jsp">Browse Profiles</a></li>
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

    <div class="container">
        <div class="card text-center mt-30" style="background: linear-gradient(135deg, #FFD700 0%, #FFA500 100%); padding: 50px;">
            <h1 style="font-size: 42px; margin-bottom: 15px; color: #333;">✨ Premium Membership ✨</h1>
            <p style="font-size: 20px; color: #333;">Unlock unlimited access and find your perfect match faster</p>
        </div>

        <% if (!message.isEmpty()) { %>
            <div class="alert alert-<%= messageType %> mt-20">
                <%= message %>
            </div>
        <% } %>

        <!-- Premium Features -->
        <div class="card mt-30">
            <div class="card-header">
                <h2>Premium Benefits</h2>
            </div>
            <div class="dashboard-grid">
                <div style="padding: 20px; text-align: center;">
                    <div style="font-size: 48px; margin-bottom: 10px;">📞</div>
                    <h4>View Contact Details</h4>
                    <p style="color: #666;">Access phone numbers of all verified profiles</p>
                </div>
                <div style="padding: 20px; text-align: center;">
                    <div style="font-size: 48px; margin-bottom: 10px;">💬</div>
                    <h4>Unlimited Messages</h4>
                    <p style="color: #666;">Send unlimited interest requests and messages</p>
                </div>
                <div style="padding: 20px; text-align: center;">
                    <div style="font-size: 48px; margin-bottom: 10px;">⭐</div>
                    <h4>Priority Listing</h4>
                    <p style="color: #666;">Your profile appears first in search results</p>
                </div>
                <div style="padding: 20px; text-align: center;">
                    <div style="font-size: 48px; margin-bottom: 10px;">🎯</div>
                    <h4>Advanced Filters</h4>
                    <p style="color: #666;">Use advanced search filters to find perfect matches</p>
                </div>
                <div style="padding: 20px; text-align: center;">
                    <div style="font-size: 48px; margin-bottom: 10px;">👁️</div>
                    <h4>Profile Insights</h4>
                    <p style="color: #666;">See who viewed your profile</p>
                </div>
                <div style="padding: 20px; text-align: center;">
                    <div style="font-size: 48px; margin-bottom: 10px;">💎</div>
                    <h4>Premium Badge</h4>
                    <p style="color: #666;">Stand out with premium member badge</p>
                </div>
            </div>
        </div>

        <!-- Pricing Plans -->
        <h2 class="text-center mt-30" style="color: #e91e63; font-size: 36px;">Choose Your Plan</h2>
        
        <div class="plans-grid mt-20">
            <!-- Monthly Plan -->
            <div class="plan-card">
                <div class="plan-header">
                    <h3>Monthly</h3>
                    <div class="plan-price">BDT999<small>/mo</small></div>
                    <p>Perfect for getting started</p>
                </div>
                <div class="plan-features">
                    <ul>
                        <li>All Premium Features</li>
                        <li>View Contact Details</li>
                        <li>Unlimited Messages</li>
                        <li>Priority Support</li>
                        <li>Profile Badge</li>
                    </ul>
                    <button onclick="selectPlan('MONTHLY', 999)" class="btn btn-primary btn-block mt-20">
                        Select Plan
                    </button>
                </div>
            </div>

            <!-- Quarterly Plan -->
            <div class="plan-card" style="border: 3px solid #FFD700;">
                <div style="background: #FFD700; color: #333; padding: 10px; text-align: center; font-weight: bold; margin: -25px -30px 20px;">
                    🎉 MOST POPULAR
                </div>
                <div class="plan-header">
                    <h3>Quarterly</h3>
                    <div class="plan-price">BDT2499<small>/3mo</small></div>
                    <p style="text-decoration: line-through; opacity: 0.7;">BDT2997</p>
                    <p style="color: #FFD700; font-weight: bold;">Save BDT498!</p>
                </div>
                <div class="plan-features">
                    <ul>
                        <li>All Premium Features</li>
                        <li>View Contact Details</li>
                        <li>Unlimited Messages</li>
                        <li>Priority Support</li>
                        <li>Profile Badge</li>
                        <li>Extended Visibility</li>
                    </ul>
                    <button onclick="selectPlan('QUARTERLY', 2499)" class="btn btn-block mt-20" 
                            style="background: #FFD700; color: #333;">
                        Select Plan
                    </button>
                </div>
            </div>

            <!-- Yearly Plan -->
            <div class="plan-card">
                <div class="plan-header">
                    <h3>Yearly</h3>
                    <div class="plan-price">BDT7999<small>/year</small></div>
                    <p style="text-decoration: line-through; opacity: 0.7;">BDT11988</p>
                    <p style="color: #4caf50; font-weight: bold;">Save BDT3989!</p>
                </div>
                <div class="plan-features">
                    <ul>
                        <li>All Premium Features</li>
                        <li>View Contact Details</li>
                        <li>Unlimited Messages</li>
                        <li>24/7 Priority Support</li>
                        <li>Premium Profile Badge</li>
                        <li>Maximum Visibility</li>
                        <li>Dedicated Support Agent</li>
                    </ul>
                    <button onclick="selectPlan('YEARLY', 7999)" class="btn btn-success btn-block mt-20">
                        Select Plan
                    </button>
                </div>
            </div>
        </div>

        <!-- Payment Form (Hidden by default) -->
        <div id="paymentForm" class="card mt-30" style="display: none;">
            <div class="card-header">
                <h2>Complete Payment</h2>
            </div>
            <form method="POST" action="premium.jsp">
                <input type="hidden" id="planType" name="planType">
                <input type="hidden" id="amount" name="amount">
                
                <div class="alert alert-info">
                    <strong>Selected Plan:</strong> <span id="selectedPlan"></span><br>
                    <strong>Amount:</strong> BDT<span id="selectedAmount"></span>
                </div>

                <div class="form-group">
                    <label for="paymentMethod">Payment Method *</label>
                    <select id="paymentMethod" name="paymentMethod" class="form-control" required>
                        <option value="">Select Payment Method</option>
                        <option value="BKASH">bKash</option>
                        <option value="NAGAD">Nagad</option>
                        <option value="ROCKET">Rocket</option>
                        <option value="BANK_TRANSFER">Bank Transfer</option>
                    </select>
                </div>

                <div class="alert alert-warning">
                    <strong>Payment Instructions:</strong><br>
                    1. Send money to our number: <strong>01712-345678</strong><br>
                    2. Enter the transaction ID below<br>
                    3. Submit the form<br>
                    4. Your membership will be activated within 24 hours after verification
                </div>

                <div class="form-group">
                    <label for="transactionId">Transaction ID *</label>
                    <input type="text" id="transactionId" name="transactionId" class="form-control" 
                           placeholder="Enter your transaction ID" required>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-success">Submit Payment</button>
                    <button type="button" onclick="cancelPayment()" class="btn btn-secondary">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 MatrimonyHub. All Rights Reserved.</p>
    </footer>

    <script>
        function selectPlan(planType, amount) {
            document.getElementById('planType').value = planType;
            document.getElementById('amount').value = amount;
            document.getElementById('selectedPlan').textContent = planType.charAt(0) + planType.slice(1).toLowerCase();
            document.getElementById('selectedAmount').textContent = amount;
            document.getElementById('paymentForm').style.display = 'block';
            document.getElementById('paymentForm').scrollIntoView({ behavior: 'smooth' });
        }

        function cancelPayment() {
            document.getElementById('paymentForm').style.display = 'none';
        }
    </script>
</body>
</html>
