<%@ page import="java.sql.*, org.mindrot.jbcrypt.BCrypt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Restablecimiento de Contraseña</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-body">
                        <%
                            String newPassword = request.getParameter("newPassword");
                            String confirmPassword = request.getParameter("confirmPassword");
                            String resetCode = request.getParameter("resetCode");

                            String passwordStrength = "";

                            if (newPassword != null && confirmPassword != null) {
                                if (newPassword.equals(confirmPassword)) {
                                    // Validar la contraseña
                                    if (newPassword.length() >= 8) {
                                        if (newPassword.matches("^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@#$%^&+=!]).+$")) {
                                            passwordStrength = "Seguridad máxima";
                                        } else if (newPassword.matches("^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).+$")) {
                                            passwordStrength = "Seguridad intermedia";
                                        } else {
                                            passwordStrength = "Seguridad mínima";
                                        }
                                    } else {
                                        passwordStrength = "Seguridad mínima";
                                    }

                                    if (passwordStrength.equals("Seguridad mínima") && newPassword.length() > 0) {
                                        session.setAttribute("error", "La contraseña es demasiado débil. Intenta usar una combinación de mayúsculas, minúsculas, números y símbolos.");
                                        response.sendRedirect("resetPassword.jsp");
                                        return;
                                    }

                                    Connection conn = null;
                                    PreparedStatement pstmt = null;

                                    try {
                                        Class.forName("com.mysql.cj.jdbc.Driver");
                                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");

                                        // Encriptar la nueva contraseña
                                        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

                                        // Actualizar la contraseña en la base de datos
                                        String sql = "UPDATE Usuarios SET contraseña=?, verification_code=NULL WHERE verification_code=?";
                                        pstmt = conn.prepareStatement(sql);
                                        pstmt.setString(1, hashedPassword); // Almacenar la contraseña encriptada
                                        pstmt.setString(2, resetCode);

                                        int rows = pstmt.executeUpdate();

                                        if (rows > 0) {
                        %>
                                            <div class="alert alert-success" role="alert">
                                                Contraseña actualizada exitosamente. Ahora puedes <a href='login.jsp' class="alert-link">iniciar sesión</a>.
                                            </div>
                                        <%
                                        } else {
                        %>
                                            <div class="alert alert-danger" role="alert">
                                                Error: Código de recuperación inválido o expirado.
                                            </div>
                                        <%
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                        %>
                                        <div class="alert alert-danger" role="alert">
                                            Error: <%= e.getMessage() %>
                                        </div>
                        <%
                                    } finally {
                                        if (pstmt != null) pstmt.close();
                                        if (conn != null) conn.close();
                                    }
                                } else {
                                    // Las contraseñas no coinciden
                                    session.setAttribute("error", "Las contraseñas no coinciden. Por favor, inténtalo de nuevo.");
                                    response.sendRedirect("resetPassword.jsp");
                                    return;
                                }
                            } else {
                                // Datos incompletos
                                session.setAttribute("error", "Por favor, completa todos los campos.");
                                response.sendRedirect("resetPassword.jsp");
                                return;
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
