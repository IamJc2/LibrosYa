<%@ page import="java.sql.*, java.security.MessageDigest" %>
<%
    String password = request.getParameter("password");
    String resetCode = (String) session.getAttribute("resetCode");

    if (resetCode == null || password == null || password.isEmpty()) {
        session.setAttribute("error", "El código de recuperación o la contraseña no son válidos.");
        response.sendRedirect("resetPassword.jsp?code=" + resetCode);
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");

        String sql = "UPDATE Usuarios SET contraseña = ?, verification_code = NULL WHERE verification_code = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, password);
        pstmt.setString(2, resetCode);

        int rows = pstmt.executeUpdate();

        if (rows > 0) {
            response.sendRedirect("login.jsp");
        } else {
            session.setAttribute("error", "No se pudo actualizar la contraseña. Inténtalo de nuevo.");
            response.sendRedirect("resetPassword.jsp?code=" + resetCode);
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
