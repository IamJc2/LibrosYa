<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agregar Usuario - LibrosYA</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
            color: #333;
        }
        .navbar {
            background-color: #2c3e50;
            box-shadow: 0 2px 4px rgba(0,0,0,.1);
        }
        .navbar-brand {
            font-weight: bold;
            color: #ecf0f1 !important;
        }
        .nav-link {
            color: #ecf0f1 !important;
            transition: color 0.3s ease;
        }
        .nav-link:hover {
            color: #3498db !important;
        }
        .container {
            margin-top: 50px;
        }
        .form-group label {
            font-weight: bold;
        }
        .form-control {
            border-radius: 5px;
        }
        .btn {
            border-radius: 5px;
            padding: 10px 20px;
            font-size: 1rem;
        }
        .btn-secondary {
            background-color: #3498db;
            color: white;
        }
        .btn-secondary:hover {
            opacity: 0.9;
            transform: translateY(-2px);
        }
        .btn-primary {
            background-color: #2ecc71;
            color: white;
        }
        footer {
            background-color: #2c3e50;
            padding: 20px 0;
            margin-top: 40px;
        }
    </style>
    <script>
        function togglePasswordVisibility() {
            var passwordField = document.getElementById("password");
            var toggleButton = document.getElementById("togglePassword");
            if (passwordField.type === "password") {
                passwordField.type = "text";
                toggleButton.textContent = "Ocultar Contraseña";
            } else {
                passwordField.type = "password";
                toggleButton.textContent = "Mostrar Contraseña";
            }
        }
    </script>
</head>
<body>
    <!-- Barra de Navegación -->
    <!--<nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="librosDisponibles.jsp">LibrosYA</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="#"><i class="fas fa-user"></i> Perfil</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#"><i class="fas fa-shopping-cart"></i> Carrito</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#"><i class="fas fa-heart"></i> Lista de Deseos</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>-->

    <!-- Formulario de Agregar Usuario -->
    <div class="container">
        <h2 class="my-4">Agregar Usuario</h2>
        <form method="post" action="agregarUsuarioAction.jsp">
            <div class="form-group">
                <label for="nombre">Nombre:</label>
                <input type="text" class="form-control" id="nombre" name="nombre" required>
            </div>
            <div class="form-group">
                <label for="apellido">Apellido:</label>
                <input type="text" class="form-control" id="apellido" name="apellido" required>
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="rol">Rol:</label>
                <input type="text" class="form-control" id="rol" name="rol" required>
            </div>
            <div class="form-group">
                <label for="password">Contraseña:</label>
                <input type="password" class="form-control" id="password" name="password" required>
                <button type="button" class="btn btn-secondary mt-2" id="togglePassword" onclick="togglePasswordVisibility()">Mostrar Contraseña</button>
            </div>
            <button type="submit" class="btn btn-primary">Agregar Usuario</button>
        </form>
    </div>

    <!-- Footer -->
    <footer class="bg-light text-dark py-5 mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-4 mb-md-0">
                    <h5 class="text-primary mb-4">Enlaces Rápidos</h5>
                    <ul class="list-unstyled">
                        <li><a href="#" class="text-muted">Sobre nosotros</a></li>
                        <li><a href="#" class="text-muted">Términos y condiciones</a></li>
                        <li><a href="#" class="text-muted">Política de privacidad</a></li>
                        <li><a href="#" class="text-muted">Preguntas frecuentes</a></li>
                    </ul>
                </div>
                <div class="col-md-4 mb-4 mb-md-0">
                    <h5 class="text-primary mb-4">Contacto</h5>
                    <p class="text-muted"><i class="fas fa-map-marker-alt mr-2"></i> Av. Principal 123, Ciudad</p>
                    <p class="text-muted"><i class="fas fa-phone mr-2"></i> +51 123 456 789</p>
                    <p class="text-muted"><i class="fas fa-envelope mr-2"></i> info@librosya.com</p>
                </div>
                <div class="col-md-4">
                    <h5 class="text-primary mb-4">Síguenos</h5>
                    <div class="social-icons">
                        <a href="#" class="mr-3" style="color: #3b5998;"><i class="fab fa-facebook-f fa-2x"></i></a>
                        <a href="#" class="mr-3" style="color: #1da1f2;"><i class="fab fa-twitter fa-2x"></i></a>
                        <a href="#" class="mr-3" style="color: #e1306c;"><i class="fab fa-instagram fa-2x"></i></a>
                        <a href="#" style="color: #0077b5;"><i class="fab fa-linkedin-in fa-2x"></i></a>
                    </div>
                </div>
            </div>
            <hr class="my-4">
            <div class="row">
                <div class="col-md-12 text-center">
                    <p class="mb-0 text-muted">&copy; 2023 LibrosYA. Todos los derechos reservados.</p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
