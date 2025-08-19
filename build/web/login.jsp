<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        /* Estilo para el fondo sólido de la página */
        body {
            background-image: url('images/fondologin.png');
            background-size: cover;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            
        }
        
        .login-container {
            position: absolute;
            top: 50%;
            right: 450px;
            transform: translateY(-50%);
            width: 100%;
            max-width: 800px; 
            padding: 70px;
            border-radius: 50px;
            box-shadow: -1px -1px 20px 2px rgba(0, 0, 0, 0.27);
            background: rgba(255, 255, 255, 0.7);
            display: flex; 
            align-items: center;
            gap: 100px; 
            
        }

        .login-image {
            max-width: 40%; 
            height: auto;
            border-radius: 20px; 
            
        }

        .login-form {
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

  
        .form-control {
            transition: all 0.3s ease;
        }

        @media (max-width: 768px) {
            .login-container {
                flex-direction: column; 
                margin: 20px;
                padding: 15px;
                box-shadow: none;
                border: none;
                
            }

            .login-image {
                max-width: 100%; 
                margin-bottom: 20px; 
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="login-container">
            <img src="images/libro3.png" alt="Descripción de la Imagen" class="login-image"> <!-- Ruta a tu imagen -->
            <div class="login-form">
                <h2 class="text-center">Login</h2>
                <form method="post" action="loginAction.jsp">
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Contraseña:</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">Ingresar</button>
                </form>
                <div class="mt-4 text-center">
                    <p>¿Olvidaste tu contraseña? <a href="recoverPassword.jsp">Recuperar aquí</a></p>
                    <p>¿Todavía no tienes una cuenta? <a href="register.jsp">Regístrate aquí</a></p>
                </div>
            </div>
        </div>
    </div>

    <!-- Incluir Bootstrap JS y dependencias -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
