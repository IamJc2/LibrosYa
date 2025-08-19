<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Disponibilidad del Libro - LibrosYA</title>
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
            padding: 1rem 2rem;
            box-shadow: 0 2px 4px rgba(0,0,0,.1);
        }
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
            color: #ecf0f1 !important;
            transition: color 0.3s ease;
        }
        .navbar-brand:hover {
            color: #3498db !important;
        }
        .nav-link {
            color: #ecf0f1 !important;
            transition: all 0.3s ease;
            position: relative;
            padding: 0.5rem 1rem;
        }
        .nav-link:hover {
            color: #3498db !important;
        }
        .nav-link::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: 0;
            left: 50%;
            background-color: #3498db;
            transition: all 0.3s ease;
        }
        .nav-link:hover::after {
            width: 100%;
            left: 0;
        }
        .availability-container {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,.1);
            padding: 30px;
            margin-top: 30px;
        }
        .book-info {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .availability-status {
            font-size: 1.2rem;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .btn-custom {
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        .btn-back {
            background-color: #3498db;
            color: white;
        }
        .btn-back:hover {
            background-color: #2980b9;
            transform: translateY(-2px);
        }
        footer {
            background-color: #2c3e50;
            color: #ecf0f1;
            padding: 40px 0;
            margin-top: 40px;
        }
        footer h5 {
            color: #3498db;
            font-weight: bold;
            margin-bottom: 20px;
        }
        footer ul {
            list-style: none;
            padding-left: 0;
        }
        footer ul li {
            margin-bottom: 10px;
        }
        footer a {
            color: #ecf0f1;
            transition: color 0.3s ease;
        }
        footer a:hover {
            color: #3498db;
            text-decoration: none;
        }
        .social-icons a {
            font-size: 1.5rem;
            margin-right: 15px;
        }
    </style>
</head>
<body>
    <!-- Barra de Navegación -->
    <!-- Barra de Navegación -->
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
        <a class="navbar-brand" href="librosDisponibles.jsp">LibrosYA</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <% if (session.getAttribute("user") != null) { %>
                    <li class="nav-item">
                        <a class="nav-link" href="#" data-toggle="modal" data-target="#perfilModal">
                            <i class="fas fa-user"></i> Perfil
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="carrito.jsp">
                            <i class="fas fa-shopping-cart"></i> Carrito 
                            <%
                                // Contar el número de libros en el carrito
                                if (session.getAttribute("id_usuario") != null) {
                                    int id_usuario = (Integer) session.getAttribute("id_usuario");
                                    try {
                                        Class.forName("com.mysql.cj.jdbc.Driver");
                                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");

                                        String queryCarrito = "SELECT SUM(cantidad) AS totalItems FROM detalle_carrito dc " +
                                                              "JOIN carrito c ON dc.id_carrito = c.id_carrito " +
                                                              "WHERE c.id_usuario = ? AND c.estado = 'activo'";
                                        PreparedStatement ps = conn.prepareStatement(queryCarrito);
                                        ps.setInt(1, id_usuario);
                                        ResultSet rs = ps.executeQuery();

                                        if (rs.next()) {
                                            int totalItems = rs.getInt("totalItems");
                                            if (totalItems > 0) {
                                                out.print("(" + totalItems + ")");
                                            }
                                        }
                                        rs.close();
                                        ps.close();
                                        conn.close();
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                }
                            %>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" data-toggle="modal" data-target="#listaDeseosModal">
                            <i class="fas fa-heart"></i> Lista de Deseos
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="logout.jsp">
                            <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
                        </a>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link" href="login.jsp">
                            <i class="fas fa-sign-in-alt"></i> Iniciar Sesión
                        </a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

    <div class="container">
        <div class="availability-container">
            <h1 class="mb-4">Disponibilidad del Libro</h1>
            <%
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                String isbn = request.getParameter("isbn");

                try {
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                    String sql = "SELECT L.titulo, L.autor, L.cantidad_disponible FROM Libros L WHERE L.isbn = ?";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, isbn);
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        String titulo = rs.getString("titulo");
                        String autor = rs.getString("autor");
                        int cantidadDisponible = rs.getInt("cantidad_disponible");
            %>
            <div class="book-info">
                <h2><%= titulo %></h2>
                <p>Autor: <%= autor %></p>
                <p>ISBN: <%= isbn %></p>
            </div>
            <div class="availability-status">
                <% if (cantidadDisponible > 0) { %>
                    <i class="fas fa-check-circle text-success"></i> Disponible
                <% } else { %>
                    <i class="fas fa-times-circle text-danger"></i> No disponible
                <% } %>
            </div>
            <p>Ejemplares disponibles: <%= cantidadDisponible %></p>
            <% if (cantidadDisponible > 0) { %>
                <p class="text-success">¡Buenas noticias! Este libro está disponible para préstamo o compra.</p>
            <% } else { %>
                <p class="text-danger">Lo sentimos, actualmente no hay ejemplares disponibles. Puedes agregarlo a tu lista de deseos para ser notificado cuando esté disponible.</p>
            <% } %>
            <a href="detalleLibro.jsp?isbn=<%= isbn %>" class="btn btn-custom btn-back mt-3">
                <i class="fas fa-arrow-left"></i> Volver a Detalles
            </a>
            <%
                    } else {
            %>
            <div class="alert alert-warning" role="alert">
                <i class="fas fa-exclamation-triangle"></i> El libro no se encontró.
            </div>
            <a href="librosDisponibles.jsp" class="btn btn-custom btn-back mt-3">
                <i class="fas fa-home"></i> Volver al Inicio
            </a>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-circle"></i> Ocurrió un error al cargar la disponibilidad del libro.
            </div>
            <a href="librosDisponibles.jsp" class="btn btn-custom btn-back mt-3">
                <i class="fas fa-home"></i> Volver al Inicio
            </a>
            <%
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
            %>
        </div>
    </div>

<!-- Footer Mejorado -->
<footer class="bg-dark text-light py-5">
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-4 mb-md-0">
                <h5 class="text-uppercase mb-4">LibrosYA</h5>
                <p class="mb-3">Tu librería online de confianza. Descubre un mundo de historias en cada página.</p>
                <p><i class="fas fa-envelope mr-3"></i> reyes.luisito2002@gmail.com</p>
                <p><i class="fas fa-phone mr-3"></i> +51 985619341</p>
            </div>
            <div class="col-md-4 mb-4 mb-md-0">
                <h5 class="text-uppercase mb-4">Enlaces Rápidos</h5>
                <ul class="list-unstyled">
                    <li><a href="librosDisponibles.jsp" class="text-light">Catálogo</a></li>
                    <li><a href="sobre-nosotros.jsp" class="text-light">Sobre Nosotros</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <h5 class="text-uppercase mb-4">Síguenos</h5>
                <div class="social-icons mb-4">
                    <a href="https://www.facebook.com/lancombookstore/" target="_blank" class="text-light mr-3"><i class="fab fa-facebook-f"></i></a>
                    <a href="https://x.com/LancomLibreria" target="_blank" class="text-light mr-3"><i class="fab fa-twitter"></i></a>
                    <a href="https://www.instagram.com/lancomperu/" target="_blank" class="text-light"><i class="fab fa-instagram"></i></a>
                </div>
            </div>
        </div>
        <hr class="bg-light my-4">
        <div class="row align-items-center">
            <div class="col-md-7 col-lg-8 text-center text-md-left">
                <p class="mb-0">&copy; 2024 LibrosYA. Todos los derechos reservados.</p>
            </div>
            <div class="col-md-5 col-lg-4 text-center text-md-right">
                <a href="#" class="text-light mr-3" data-toggle="modal" data-target="#terminosModal">Términos de Uso</a>
                <a href="#" class="text-light" data-toggle="modal" data-target="#privacidadModal">Política de Privacidad</a>
            </div>
        </div>
    </div>
</footer>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>