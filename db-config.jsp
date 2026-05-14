<%@ page import="java.sql.*" %>
<%!
    // Database configuration
    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:xe";
    private static final String DB_USER = "system";
    private static final String DB_PASSWORD = "sohan1";
    
    // Get database connection
    public Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
    
    // Close database resources
    public void closeResources(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Check if user is logged in
    public boolean isLoggedIn(HttpSession session) {
        return session != null && session.getAttribute("userId") != null;
    }
    
    // Check if user is admin
    public boolean isAdmin(HttpSession session) {
        return session != null && "ADMIN".equals(session.getAttribute("role"));
    }
    
    // Check if user is staff
    public boolean isStaff(HttpSession session) {
        return session != null && "STAFF".equals(session.getAttribute("role"));
    }
    
    // Check if user is premium
    public boolean isPremium(HttpSession session) {
        return session != null && "YES".equals(session.getAttribute("isPremium"));
    }
%>
