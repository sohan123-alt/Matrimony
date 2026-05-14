<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db-config.jsp" %>
<%@ page import="java.util.*" %>
<%
    if (!isLoggedIn(session) || !isAdmin(session)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String message = "";
    String messageType = "";
    String action = request.getParameter("action");
    String filter = request.getParameter("filter");
    Integer adminId = (Integer) session.getAttribute("userId");
    
    // Handle payment verification
    if ("verify".equals(action) && request.getMethod().equals("POST")) {
        String paymentIdStr = request.getParameter("paymentId");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            
            // Get payment details
            String selectSql = "SELECT user_id, plan_start_date, plan_end_date FROM PAYMENTS WHERE payment_id = ?";
            pstmt = conn.prepareStatement(selectSql);
            pstmt.setInt(1, Integer.parseInt(paymentIdStr));
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                int userId = rs.getInt("user_id");
                java.sql.Date startDate = rs.getDate("plan_start_date");
                java.sql.Date endDate = rs.getDate("plan_end_date");
                
                // Update payment status
                String updatePaymentSql = "UPDATE PAYMENTS SET payment_status = 'PAID', " +
                                        "verified_by = ?, verified_date = CURRENT_TIMESTAMP " +
                                        "WHERE payment_id = ?";
                pstmt = conn.prepareStatement(updatePaymentSql);
                pstmt.setInt(1, adminId);
                pstmt.setInt(2, Integer.parseInt(paymentIdStr));
                pstmt.executeUpdate();
                
                // Update profile to premium
                String updateProfileSql = "UPDATE PROFILES SET is_premium = 'YES' WHERE user_id = ?";
                pstmt = conn.prepareStatement(updateProfileSql);
                pstmt.setInt(1, userId);
                pstmt.executeUpdate();
                
                message = "Payment verified and premium membership activated successfully!";
                messageType = "success";
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
            messageType = "danger";
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
    }
    
    // Fetch payments
    List<Map<String, Object>> payments = new ArrayList<>();
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = getConnection();
        
        StringBuilder sql = new StringBuilder(
            "SELECT p.payment_id, p.user_id, p.amount, p.payment_method, p.plan_type, " +
            "p.payment_status, p.payment_date, p.transaction_id, p.plan_start_date, " +
            "p.plan_end_date, u.email, pr.name " +
            "FROM PAYMENTS p " +
            "JOIN USERS3 u ON p.user_id = u.user_id " +
            "LEFT JOIN PROFILES pr ON u.user_id = pr.user_id"
        );
        
        if ("pending".equals(filter)) {
            sql.append(" WHERE p.payment_status = 'PENDING'");
        } else if ("paid".equals(filter)) {
            sql.append(" WHERE p.payment_status = 'PAID'");
        }
        
        sql.append(" ORDER BY p.payment_date DESC");
        
        pstmt = conn.prepareStatement(sql.toString());
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> payment = new HashMap<>();
            payment.put("paymentId", rs.getInt("payment_id"));
            payment.put("userId", rs.getInt("user_id"));
            payment.put("amount", rs.getDouble("amount"));
            payment.put("paymentMethod", rs.getString("payment_method"));
            payment.put("planType", rs.getString("plan_type"));
            payment.put("paymentStatus", rs.getString("payment_status"));
            payment.put("paymentDate", rs.getTimestamp("payment_date"));
            payment.put("transactionId", rs.getString("transaction_id"));
            payment.put("planStartDate", rs.getDate("plan_start_date"));
            payment.put("planEndDate", rs.getDate("plan_end_date"));
            payment.put("email", rs.getString("email"));
            payment.put("name", rs.getString("name"));
            payments.add(payment);
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
    <title>Payment Management - Admin</title>
    <link rel="stylesheet" href="CSS/styles.css">


</head>
<body>
    <header>
        <nav class="navbar">
            <a href="admin-dashboard.jsp" class="logo">MatrimonyHub - Admin</a>
            <ul>
                <li><a href="admin-dashboard.jsp">Dashboard</a></li>
                <li><a href="admin-users.jsp">Users</a></li>
                <li><a href="admin-profiles.jsp">Profiles</a></li>
                <li><a href="admin-tasks.jsp">Tasks</a></li>
                <li><a href="admin-payments.jsp">Payments</a></li>
                <li><a href="admin-reports.jsp">Reports</a></li>
                <li>
                    <div class="user-info">
                        <span>👑 Admin</span>
                        <a href="logout.jsp" class="btn btn-danger">Logout</a>
                    </div>
                </li>
            </ul>
        </nav>
    </header>

    <div class="container">
        <h1 class="mt-30" style="color: #e91e63;">Payment Management</h1>

        <% if (!message.isEmpty()) { %>
            <div class="alert alert-<%= messageType %> mt-20">
                <%= message %>
            </div>
        <% } %>

        <!-- Filter Buttons -->
        <div class="btn-group mt-20">
            <a href="admin-payments.jsp" class="btn <%= filter == null ? "btn-primary" : "btn-secondary" %>">
                All Payments
            </a>
            <a href="admin-payments.jsp?filter=pending" class="btn <%= "pending".equals(filter) ? "btn-warning" : "btn-secondary" %>">
                Pending Verification
            </a>
            <a href="admin-payments.jsp?filter=paid" class="btn <%= "paid".equals(filter) ? "btn-success" : "btn-secondary" %>">
                Verified Payments
            </a>
        </div>

        <!-- Statistics -->
        <%
            long pendingCount = payments.stream().filter(p -> "PENDING".equals(p.get("paymentStatus"))).count();
            long paidCount = payments.stream().filter(p -> "PAID".equals(p.get("paymentStatus"))).count();
            double totalRevenue = payments.stream()
                .filter(p -> "PAID".equals(p.get("paymentStatus")))
                .mapToDouble(p -> (Double)p.get("amount"))
                .sum();
        %>
        
        <div class="stats-grid mt-30">
            <div class="stat-card">
                <div class="stat-icon primary">💰</div>
                <div class="stat-content">
                    <h3><%= payments.size() %></h3>
                    <p>Total Transactions</p>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon success">✓</div>
                <div class="stat-content">
                    <h3><%= paidCount %></h3>
                    <p>Verified</p>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon warning">⏳</div>
                <div class="stat-content">
                    <h3><%= pendingCount %></h3>
                    <p>Pending</p>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon info">💵</div>
                <div class="stat-content">
                    <h3>BDT<%= String.format("%.2f", totalRevenue) %></h3>
                    <p>Total Revenue</p>
                </div>
            </div>
        </div>

        <!-- Payments Table -->
        <div class="table-container mt-30">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>User</th>
                        <th>Plan</th>
                        <th>Amount</th>
                        <th>Payment Method</th>
                        <th>Transaction ID</th>
                        <th>Status</th>
                        <th>Date</th>
                        <th>Validity</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> payment : payments) { %>
                        <tr>
                            <td><%= payment.get("paymentId") %></td>
                            <td>
                                <strong><%= payment.get("name") != null ? payment.get("name") : "N/A" %></strong><br>
                                <small><%= payment.get("email") %></small>
                            </td>
                            <td>
                                <span class="badge badge-info">
                                    <%= payment.get("planType") %>
                                </span>
                            </td>
                            <td><strong>BDT<%= payment.get("amount") %></strong></td>
                            <td><%= payment.get("paymentMethod") %></td>
                            <td><%= payment.get("transactionId") != null && !payment.get("transactionId").toString().isEmpty() ? 
                                   payment.get("transactionId") : "N/A" %></td>
                            <td>
                                <% if ("PAID".equals(payment.get("paymentStatus"))) { %>
                                    <span class="badge badge-success">✓ Paid</span>
                                <% } else if ("PENDING".equals(payment.get("paymentStatus"))) { %>
                                    <span class="badge badge-warning">⏳ Pending</span>
                                <% } else { %>
                                    <span class="badge badge-danger">✗ Failed</span>
                                <% } %>
                            </td>
                            <td><%= payment.get("paymentDate") %></td>
                            <td>
                                <% if (payment.get("planStartDate") != null && payment.get("planEndDate") != null) { %>
                                    <%= payment.get("planStartDate") %><br>to<br><%= payment.get("planEndDate") %>
                                <% } else { %>
                                    N/A
                                <% } %>
                            </td>
                            <td>
                                <% if ("PENDING".equals(payment.get("paymentStatus"))) { %>
                                    <form method="POST" action="admin-payments.jsp?action=verify" style="display: inline;">
                                        <input type="hidden" name="paymentId" value="<%= payment.get("paymentId") %>">
                                        <button type="submit" class="btn btn-success" style="padding: 5px 10px; font-size: 12px;">
                                            Verify & Activate
                                        </button>
                                    </form>
                                <% } else { %>
                                    <span style="color: #4caf50;">✓ Verified</span>
                                <% } %>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <% if (payments.isEmpty()) { %>
            <div class="alert alert-info mt-20">
                No payments found matching the selected filter.
            </div>
        <% } %>
    </div>

    <footer>
        <p>&copy; 2026 MatrimonyHub. All Rights Reserved.</p>
    </footer>
</body>
</html>
