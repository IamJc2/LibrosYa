<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comprar Libro - LibrosYA</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
       body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
            display: flex;
            flex-direction: column;
            min-height: 870px; /* Hace que el body ocupe toda la altura de la ventana */
        }

        /* El contenido principal ocupará el espacio disponible */
        .container {
            flex: 1;
            padding-top: 10px; /* Añadir espacio entre el título y la parte superior */
            padding-bottom: 10px; /* Añadir espacio entre el contenido y el footer */
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

        .book-card {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,.1);
            transition: transform 0.3s ease;
            margin-bottom: 30px;
        }
        .book-card:hover {
            transform: translateY(-5px);
        }
        .book-title {
            font-size: 1.1rem;
            font-weight: bold;
            margin-top: 15px;
        }
        .book-author, .book-category {
            font-size: 0.9rem;
            color: #6c757d;
        }
        .book-price {
            font-size: 1.2rem;
            color: #e74c3c;
            font-weight: bold;
        }
        .btn-primary {
            background-color: #3498db;
            border-color: #3498db;
        }
        .btn-primary:hover {
            background-color: #2980b9;
            border-color: #2980b9;
        }

        footer {
            background-color: #2c3e50;
            color: #ecf0f1;
            padding: 20px 0;
            flex-shrink: 0;
        }

        .wishlist-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            background: none;
            border: none;
            font-size: 1.5rem;
            color: #e74c3c;
            cursor: pointer;
            transition: transform 0.3s ease;
        }
        .wishlist-btn:hover {
            transform: scale(1.2);
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
                            <a class="nav-link" href="perfil.jsp">
                                <i class="fas fa-user"></i> Perfil
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="carrito.jsp">
                                <i class="fas fa-shopping-cart"></i> Carrito 
                                <%
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
                            <a class="nav-link" href="listaDeseos.jsp">
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

    <!-- Contenido principal -->
    <div class="container">
        <div class="purchase-container">
            <h1 class="mb-4">Comprar Libro</h1>
            <%
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                String isbn = request.getParameter("isbn");

                try {
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                    String sql = "SELECT titulo, autor, precio FROM Libros WHERE isbn = ?";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, isbn);
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        String titulo = rs.getString("titulo");
                        String autor = rs.getString("autor");
                        double precio = rs.getDouble("precio");
            %>
                        <div class="book-info">
                            <h2><%= titulo %></h2>
                            <p>Autor: <%= autor %></p>
                            <p>ISBN: <%= isbn %></p>
                            <p class="text-success font-weight-bold">Precio: S/ <%= String.format("%.2f", precio) %></p>
                        </div>
                        <div class="mt-4">
                            <a href="procesarCompraPago.jsp?isbn=<%= isbn %>" class="btn btn-success mr-2">
                                Proceder al Pago
                            </a>
                            <a href="detalleLibro.jsp?isbn=<%= isbn %>" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Volver a Detalles
                            </a>
                        </div>
            <%
                    } else {
            %>
                        <div class="alert alert-warning" role="alert">
                            <i class="fas fa-exclamation-triangle"></i> El libro no se encontró.
                        </div>
                        <a href="librosDisponibles.jsp" class="btn btn-secondary">
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
                    <a href="librosDisponibles.jsp" class="btn btn-secondary">
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
                        <li><a href="#" class="text-muted">Contacto</a></li>
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
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
