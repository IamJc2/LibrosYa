<%@ page import="java.sql.*, java.util.*, java.util.regex.Pattern, java.util.regex.Matcher" %>
<%@ page import="Mail.MailUtil" %>
<%
    String email = request.getParameter("email");

    if (email == null || email.isEmpty()) {
        session.setAttribute("error", "Por favor, introduce un correo electrónico.");
        response.sendRedirect("forgotPassword.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");

        String sql = "SELECT id_usuario FROM Usuarios WHERE email = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, email);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            String resetCode = UUID.randomUUID().toString();
            String updateSql = "UPDATE Usuarios SET verification_code = ? WHERE email = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setString(1, resetCode);
            pstmt.setString(2, email);
            pstmt.executeUpdate();

            String resetLink = "http://localhost:8080/LibrosYA/resetPassword.jsp?code=" + resetCode;
            String smtpHost = "smtp.gmail.com";
            String smtpPort = "587";
            String smtpUser = "reyes.luisito2002@gmail.com";
            String smtpPassword = "uhnv cbkm gcoq jmqz";

            MailUtil.sendResetPasswordEmail(email, resetLink, smtpHost, smtpPort, smtpUser, smtpPassword);

            response.sendRedirect("checkEmail.jsp");
        } else {
            session.setAttribute("error", "No se encontró una cuenta con ese correo electrónico.");
            response.sendRedirect("forgotPassword.jsp");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
