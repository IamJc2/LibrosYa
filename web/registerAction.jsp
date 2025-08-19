<%@ page import="java.sql.*, java.util.*, java.util.regex.Pattern, java.util.regex.Matcher" %>
<%@ page import="Mail.MailUtil" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String nombre = request.getParameter("nombre");
    String apellido = request.getParameter("apellido");
    String email = request.getParameter("email");
    String contraseña = request.getParameter("contraseña");

    // Validación de campos vacíos
    if (nombre == null || nombre.trim().isEmpty() || 
        apellido == null || apellido.trim().isEmpty() || 
        email == null || email.trim().isEmpty() || 
        contraseña == null || contraseña.trim().isEmpty()) {
        session.setAttribute("error", "Todos los campos son obligatorios.");
        response.sendRedirect("register.jsp");
        return;
    }

    // Validación de email
    String emailRegex = "^[A-Za-z0-9+_.-]+@(gmail|outlook)\\.com$";
    Pattern emailPattern = Pattern.compile(emailRegex);
    Matcher emailMatcher = emailPattern.matcher(email);

    if (!emailMatcher.matches()) {
        session.setAttribute("error", "Email inválido. Por favor, introduce un email válido de gmail.com o outlook.com.");
        response.sendRedirect("register.jsp");
        return;
    }

    // Validación de contraseña
    if (!contraseña.matches("^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@#$%^&+=!]).{8,}$")) {
        session.setAttribute("error", "La contraseña no cumple con los requisitos de seguridad máxima.");
        response.sendRedirect("register.jsp");
        return;
    }

    String verificationCode = UUID.randomUUID().toString();

    // Encriptar la contraseña
    String hashedPassword = BCrypt.hashpw(contraseña, BCrypt.gensalt());

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");

        // Verificar si el email ya existe
        String checkEmailSql = "SELECT COUNT(*) FROM Usuarios WHERE email = ?";
        pstmt = conn.prepareStatement(checkEmailSql);
        pstmt.setString(1, email);
        ResultSet rs = pstmt.executeQuery();
        rs.next();
        if (rs.getInt(1) > 0) {
            session.setAttribute("error", "Este email ya está registrado.");
            response.sendRedirect("register.jsp");
            return;
        }

        // Insertar nuevo usuario
        String sql = "INSERT INTO Usuarios (nombre, apellido, email, contraseña, verification_code, verified) VALUES (?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, nombre);
        pstmt.setString(2, apellido);
        pstmt.setString(3, email);
        pstmt.setString(4, hashedPassword);
        pstmt.setString(5, verificationCode);
        pstmt.setBoolean(6, false);

        int rows = pstmt.executeUpdate();

        if (rows > 0) {
            String verificationLink = "http://localhost:8080/LibrosYA/verifyEmail.jsp?code=" + verificationCode;
            String smtpHost = "smtp.gmail.com";
            String smtpPort = "587";
            String smtpUser = "reyes.luisito2002@gmail.com";
            String smtpPassword = "uhnv cbkm gcoq jmqz";

            try {
                MailUtil.sendVerificationEmail(email, verificationLink, smtpHost, smtpPort, smtpUser, smtpPassword);
                session.setAttribute("success", "Registro exitoso. Por favor, verifica tu email.");
                response.sendRedirect("registerSuccess.jsp");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("error", "Error al enviar el email de verificación. Por favor, contacta al soporte.");
                response.sendRedirect("register.jsp");
            }
        } else {
            session.setAttribute("error", "Error al registrar el usuario. Por favor, inténtalo de nuevo.");
            response.sendRedirect("register.jsp");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        session.setAttribute("error", "Error de base de datos: " + e.getMessage());
        response.sendRedirect("register.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error", "Error inesperado: " + e.getMessage());
        response.sendRedirect("register.jsp");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>