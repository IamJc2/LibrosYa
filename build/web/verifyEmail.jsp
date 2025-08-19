<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verificación de Email - LibrosYA</title>
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
        .verification-card {
            background-color: #ffffff;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            max-width: 400px;
            width: 100%;
            transition: transform 0.3s ease;
        }
        .verification-card:hover {
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
            margin-bottom: 0;
        }
        .alert-link {
            font-weight: 600;
            text-decoration: underline;
        }
        .alert-link:hover {
            text-decoration: none;
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
    </style>
</head>
<body>
    <div class="container">
        <div class="verification-card">
            <div class="card-header">
                <h4><i class="fas fa-envelope mr-2"></i>Verificación de Email</h4>
            </div>
            <div class="card-body">
                <%
                    String verificationCode = request.getParameter("code");

                    if (verificationCode == null || verificationCode.isEmpty()) {
                %>
                    <div class="text-center">
                        <i class="fas fa-exclamation-triangle icon error-icon"></i>
                        <div class="alert alert-danger">Código de verificación inválido.</div>
                    </div>
                <%
                        return;
                    }

                    String jdbcUrl = "jdbc:mysql://localhost:3306/librosya";
                    String dbUser = "root";
                    String dbPassword = "123456";

                    String sql = "UPDATE Usuarios SET verified = ? WHERE verification_code = ?";

                    try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
                         PreparedStatement pstmt = conn.prepareStatement(sql)) {

                        Class.forName("com.mysql.cj.jdbc.Driver");

                        pstmt.setBoolean(1, true);
                        pstmt.setString(2, verificationCode);

                        int rows = pstmt.executeUpdate();

                        if (rows > 0) {
                %>
                    <div class="text-center">
                        <i class="fas fa-check-circle icon success-icon"></i>
                        <div class="alert alert-success">
                            Correo electrónico verificado exitosamente. 
                            <br><br>
                            <a href="login.jsp" class="btn btn-primary">Iniciar Sesión</a>
                        </div>
                    </div>
                <%
                        } else {
                %>
                    <div class="text-center">
                        <i class="fas fa-times-circle icon error-icon"></i>
                        <div class="alert alert-danger">Error: Código de verificación inválido o usuario no encontrado.</div>
                    </div>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                    <div class="text-center">
                        <i class="fas fa-exclamation-circle icon error-icon"></i>
                        <div class="alert alert-danger">Error: <%= e.getMessage() %></div>
                    </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>