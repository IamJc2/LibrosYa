<%@ page import="java.sql.*, java.util.*, java.time.LocalDate" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Préstamo de Libro - LibrosYA</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
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
        .loan-container {
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
        .book-image {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,.1);
        }
        .btn-custom {
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        .btn-submit {
            background-color: #3498db;
            color: white;
        }
        .btn-custom:hover {
            opacity: 0.9;
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
        .form-control:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
        }
        
    </style>
</head>
<body>
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
        <div class="loan-container">
            <h1 class="mb-4">Formulario de Préstamo</h1>
            <%
                if (session.getAttribute("user") == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }

                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                String isbn = request.getParameter("isbn");

                try {
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                    String sql = "SELECT id_libro, titulo, autor, editorial, anio_publicacion, categoria, columna_imagen, precio FROM Libros WHERE isbn = ?";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, isbn);
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        int id_libro = rs.getInt("id_libro");
                        String titulo = rs.getString("titulo");
                        String autor = rs.getString("autor");
                        String editorial = rs.getString("editorial");
                        int anioPublicacion = rs.getInt("anio_publicacion");
                        String categoria = rs.getString("categoria");
                        double precio = rs.getDouble("precio");
                        double costoPrestamo = precio * 0.2; // 80% menos que el precio del libro
            %>
            <div class="row">
                <div class="col-md-4 mb-4">
                    <img src="imagenLibro?isbn=<%= isbn %>" alt="<%= titulo %>" class="book-image img-fluid">
                </div>
                <div class="col-md-8">
                    <div class="book-info">
                        <h2><%= titulo %></h2>
                        <p><strong>Autor:</strong> <%= autor %></p>
                        <p><strong>Editorial:</strong> <%= editorial %></p>
                        <p><strong>Año de Publicación:</strong> <%= anioPublicacion %></p>
                        <p><strong>Categoría:</strong> <%= categoria %></p>
                        <p><strong>ISBN:</strong> <%= isbn %></p>
                        <p><strong>Costo del Préstamo:</strong> S/ <%= String.format("%.2f", costoPrestamo) %></p>
                    </div>
                    <form action="procesarPrestamo.jsp" method="post" class="loan-form">
                        <input type="hidden" name="id_libro" value="<%= id_libro %>">
                        <input type="hidden" name="costo_prestamo" value="<%= costoPrestamo %>">
                        <div class="form-group">
                            <label for="fechaPrestamo"><i class="fas fa-calendar-alt"></i> Fecha de Préstamo:</label>
                            <input type="text" class="form-control datepicker" id="fechaPrestamo" name="fechaPrestamo" required>
                        </div>
                        <div class="form-group">
                            <label for="fechaDevolucion"><i class="fas fa-calendar-check"></i> Fecha de Devolución:</label>
                            <input type="text" class="form-control datepicker" id="fechaDevolucion" name="fechaDevolucion" required>
                        </div>
                        <a href="detalleLibro.jsp?isbn=<%= isbn %>" class="btn btn-custom btn-back mt-3">
                            <i class="fas fa-arrow-left"></i> Volver a Detalles
                        </a>
                        <button type="submit" class="btn btn-custom btn-submit">
                            <i class="fas fa-book-reader"></i> Solicitar Préstamo
                        </button>
                    </form>
                </div>
            </div>
            <%
                    } else {
            %>
            <div class="alert alert-warning" role="alert">
                <i class="fas fa-exclamation-triangle"></i> El libro no se encontró.
            </div>
            <a href="librosDisponibles.jsp" class="btn btn-custom btn-back">
                <i class="fas fa-home"></i> Volver al Inicio
            </a>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-circle"></i> Ocurrió un error al cargar los detalles del libro.
            </div>
            <a href="librosDisponibles.jsp" class="btn btn-custom btn-back">
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
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            flatpickr(".datepicker", {
                dateFormat: "Y-m-d",
                minDate: "today",
            });
        });
    </script>
</body>
</html>