<%@ page import="java.sql.*, java.util.UUID" %>
<%@ page import="Mail.MailUtil" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recuperar Contraseña</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            background-image: url('images/fondologin.png');
            background-size: cover;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }
        .recover-container {
            position: absolute;
            top: 50%;
            right: 450px;
            transform: translateY(-50%);
            width: 100%;
            max-width: 800px;
            padding: 100px;
            border: rgba(255, 255, 255, 0.7);
            border-radius: 50px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            background-color: #ffffff;
            display: flex;
            align-items: center;
            gap: 100px;
            background: rgba(255, 255, 255, 0.7);
        }
        .recover-image {
            max-width: 40%;
            height: auto;
            border-radius: 20px;
        }
        .recover-form {
            flex: 1;
        }
        .btn-primary {
            background: linear-gradient(45deg, #007bff, #0056b3);
            border: none;
            color: #ffffff;
            font-size: 16px;
            padding: 10px 20px;
            border-radius: 25px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            transition: background 0.3s, box-shadow 0.3s;
        }
        .btn-primary:hover {
            background: linear-gradient(45deg, #0056b3, #003d7a);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.3);
        }
        .btn-primary:active {
            background: linear-gradient(45deg, #003d7a, #002c5a);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }
        @media (max-width: 768px) {
            .recover-container {
                flex-direction: column;
                margin: 20px;
                padding: 15px;
                box-shadow: none;
                border: none;
            }
            .recover-image {
                max-width: 100%;
                margin-bottom: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="recover-container">
            <img src="images/recuperar.png" alt="Descripción de la Imagen" class="recover-image"> <!-- Ruta a tu imagen -->
            <div class="recover-form">
                <h2 class="text-center">Recuperar Contraseña</h2>
                <form method="post" action="recoverPasswordAction.jsp">
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">Enviar enlace de recuperación</button>
                </form>
            </div>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
