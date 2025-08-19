<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Action</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <%
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            if (email != null && password != null) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");

                    // Verificar si el usuario existe
                    String sql = "SELECT * FROM Usuarios WHERE email=?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, email);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        String hashedPassword = rs.getString("contraseña");
                        boolean isVerified = rs.getBoolean("verified");
                        String rol = rs.getString("rol");
                        int id_usuario = rs.getInt("id_usuario");

                        boolean passwordMatch = false;

                        if ("administrador".equals(rol)) {
                            // Para administradores, no usar BCrypt
                            passwordMatch = password.equals(hashedPassword);
                        } else {
                            // Para otros usuarios, verificar la contraseña encriptada
                            passwordMatch = BCrypt.checkpw(password, hashedPassword);
                        }

                        if (passwordMatch) {
                            if (isVerified) {
                                HttpSession userSession = request.getSession();
                                userSession.setAttribute("user", email);
                                userSession.setAttribute("rol", rol);
                                userSession.setAttribute("id_usuario", id_usuario);
                                
                                if ("administrador".equals(rol)) {
                                    response.sendRedirect("admin.jsp");
                                } else {
                                    response.sendRedirect("librosDisponibles.jsp");
                                }
                            } else {
                                out.println("<div class='alert alert-warning mt-4' role='alert'>Tu cuenta no está verificada. Por favor, verifica tu correo electrónico antes de iniciar sesión.</div>");
                            }
                        } else {
                            out.println("<div class='alert alert-danger mt-4' role='alert'>Email o contraseña incorrectos.</div>");
                        }
                    } else {
                        out.println("<div class='alert alert-danger mt-4' role='alert'>Email o contraseña incorrectos.</div>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<div class='alert alert-danger mt-4' role='alert'>Error al iniciar sesión: " + e.getMessage() + "</div>");
                } finally {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                }
            } else {
                out.println("<div class='alert alert-danger mt-4' role='alert'>Falta email o contraseña.</div>");
            }
        %>
        <a href="login.jsp" class="btn btn-primary mt-3">Volver al inicio de sesión</a>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>