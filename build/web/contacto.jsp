<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contacto - LibrosYA</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fa;
            color: #333;
        }
        .navbar {
            background-color: #2c3e50;
            box-shadow: 0 2px 4px rgba(0,0,0,.1);
        }
        .navbar-brand, .nav-link {
            color: #ecf0f1 !important;
        }
        .nav-link:hover {
            color: #3498db !important;
        }
        .contact-form {
            background-color: #ffffff;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            padding: 30px;
            margin-top: 50px;
            margin-bottom: 50px;
        }
        .contact-form h2 {
            color: #2c3e50;
            margin-bottom: 30px;
        }
        .form-control {
            border-radius: 20px;
        }
        .btn-primary {
            background-color: #3498db;
            border: none;
            border-radius: 20px;
            padding: 10px 20px;
        }
        .btn-primary:hover {
            background-color: #2980b9;
        }
        footer {
            background-color: #2c3e50;
            color: #ecf0f1;
            padding: 20px 0;
            margin-top: 50px;
        }
        .social-icons a {
            color: #ecf0f1;
            font-size: 1.5rem;
            margin-right: 15px;
        }
        .social-icons a:hover {
            color: #3498db;
        }
    </style>
</head>
<body>
    <!-- Barra de Navegación -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">LibrosYA</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="index.jsp">Inicio</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="librosDisponibles.jsp">Catálogo</a>
                    </li>
                    <li class="nav-item active">
                        <a class="nav-link" href="contacto.jsp">Contacto</a>
                    </li>
                    <% if (session.getAttribute("user") != null) { %>
                        <li class="nav-item">
                            <a class="nav-link" href="perfil.jsp">Perfil</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="logout.jsp">Cerrar Sesión</a>
                        </li>
                    <% } else { %>
                        <li class="nav-item">
                            <a class="nav-link" href="login.jsp">Iniciar Sesión</a>
                        </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Formulario de Contacto -->
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <form class="contact-form" action="procesarContacto.jsp" method="post">
                    <h2 class="text-center">Contáctanos</h2>
                    <div class="form-group">
                        <label for="nombre">Nombre</label>
                        <input type="text" class="form-control" id="nombre" name="nombre" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>
                    <div class="form-group">
                        <label for="asunto">Asunto</label>
                        <input type="text" class="form-control" id="asunto" name="asunto" required>
                    </div>
                    <div class="form-group">
                        <label for="mensaje">Mensaje</label>
                        <textarea class="form-control" id="mensaje" name="mensaje" rows="5" required></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">Enviar Mensaje</button>
                </form>
            </div>
        </div>
    </div>

    <!-- Footer -->
<footer class="bg-dark text-light py-4">
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-3 mb-md-0">
                <h5>LibrosYA</h5>
                <p class="text-muted">Tu librería online de confianza</p>
            </div>
            <div class="col-md-4 mb-3 mb-md-0">
                <h5>Enlaces Rápidos</h5>
                <ul class="list-unstyled">
                    <li><a href="librosDisponibles.jsp" class="text-muted">Catálogo</a></li>
                    <li><a href="sobre-nosotros.jsp" class="text-muted">Sobre Nosotros</a></li>
                    <li><a href="contacto.jsp" class="text-muted">Contacto</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <h5>Síguenos</h5>
                <div class="d-flex justify-content-start">
                    <a href="#" class="text-muted mr-3"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="text-muted mr-3"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="text-muted mr-3"><i class="fab fa-instagram"></i></a>
                </div>
            </div>
        </div>
        <hr class="bg-secondary my-4">
        <div class="row">
            <div class="col-md-6 text-center text-md-left">
                <p class="mb-0">&copy; 2024 LibrosYA. Todos los derechos reservados.</p>
            </div>
            <div class="col-md-6 text-center text-md-right">
                <a href="#" class="text-muted mr-2">Términos de Uso</a>
                <a href="#" class="text-muted">Política de Privacidad</a>
            </div>
        </div>
    </div>
</footer>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>