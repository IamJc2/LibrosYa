<%@ page import="java.sql.*, java.util.UUID" %>
<%@ page import="Mail.MailUtil" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recuperación de Contraseña - LibrosYA</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <style>
        body {
            background-color: #dfdfdf;
            font-family: 'Arial', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        .container {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
            height: 100%;
        }
        .recovery-card {
            background-color: #ffffff;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            max-width: 400px;
            width: 100%;
            transition: transform 0.3s ease;
        }
        .recovery-card:hover {
            transform: translateY(-5px);
        }
        .card-header {
            background-color: #007bff;
            color: #ffffff;
            padding: 1.5rem;
            text-align: center;
            border-bottom: none;
        }
        .card-header h4 {
            margin: 0;
            font-weight: 600;
        }
        .card-body {
            padding: 2rem;
        }
        .alert {
            border-radius: 10px;
            font-size: 0.95rem;
        }
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 123, 255, 0.3);
        }
        .icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        .success-icon {
            color: #28a745;
        }
        .error-icon {
            color: #dc3545;
        }
        .warning-icon {
            color: #ffc107;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="recovery-card">
            <div class="card-header">
                <h4><i class="fas fa-key mr-2"></i>Recuperación de Contraseña</h4>
            </div>
            <div class="card-body">
                <%
                    String email = request.getParameter("email");

                    if (email != null && !email.isEmpty()) {
                        String resetCode = UUID.randomUUID().toString();
                        Connection conn = null;
                        PreparedStatement pstmt = null;

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");

                            String sql = "UPDATE Usuarios SET verification_code=? WHERE email=?";
                            pstmt = conn.prepareStatement(sql);
                            pstmt.setString(1, resetCode);
                            pstmt.setString(2, email);

                            int rows = pstmt.executeUpdate();

                            if (rows > 0) {
                                String resetLink = "http://localhost:8080/LibrosYA/resetPassword.jsp?code=" + resetCode;
                                String smtpHost = "smtp.gmail.com";
                                String smtpPort = "587";
                                String smtpUser = "reyes.luisito2002@gmail.com";
                                String smtpPassword = "uhnv cbkm gcoq jmqz";

                                MailUtil.sendResetPasswordEmail(email, resetLink, smtpHost, smtpPort, smtpUser, smtpPassword);
                %>
                                <div class="text-center">
                                    <i class="fas fa-check-circle icon success-icon"></i>
                                    <div class="alert alert-success" role="alert">
                                        Enlace de recuperación enviado a tu correo electrónico.
                                    </div>
                                </div>
                <%
                            } else {
                %>
                                <div class="text-center">
                                    <i class="fas fa-exclamation-triangle icon error-icon"></i>
                                    <div class="alert alert-danger" role="alert">
                                        Error: No se pudo enviar el enlace de recuperación. Verifica que el correo esté registrado.
                                    </div>
                                </div>
                <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                %>
                            <div class="text-center">
                                <i class="fas fa-times-circle icon error-icon"></i>
                                <div class="alert alert-danger" role="alert">
                                    Error: <%= e.getMessage() %>
                                </div>
                            </div>
                <%
                        } finally {
                            if (pstmt != null) pstmt.close();
                            if (conn != null) conn.close();
                        }
                    } else {
                %>
                        <div class="text-center">
                            <i class="fas fa-exclamation-circle icon warning-icon"></i>
                            <div class="alert alert-warning" role="alert">
                                Por favor, introduce un correo electrónico válido.
                            </div>
                        </div>
                <%
                    }
                %>
                <div class="text-center mt-4">
                    <a href="login.jsp" class="btn btn-primary">
                        <i class="fas fa-arrow-left mr-2"></i>Volver al Login
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>