<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Deseos - LibrosYA</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
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
        .wishlist-card {
            background-color: #ffffff;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0,0,0,.1);
            padding: 2rem;
            margin-top: 2rem;
            margin-bottom: 2rem;
        }
        .wishlist-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .book-item {
            border-bottom: 1px solid #e9ecef;
            padding: 1rem 0;
            transition: background-color 0.3s ease;
        }
        .book-item:last-child {
            border-bottom: none;
        }
        .book-item:hover {
            background-color: #f8f9fa;
        }
        .book-image {
            max-width: 100px;
            height: auto;
            transition: transform 0.3s ease;
        }
        .book-image:hover {
            transform: scale(1.05);
        }
        .btn-danger {
            background-color: #e74c3c;
            border-color: #e74c3c;
        }
        .btn-danger:hover {
            background-color: #c0392b;
            border-color: #c0392b;
        }
        .btn-secondary {
            background-color: #7f8c8d;
            border-color: #7f8c8d;
        }
        .btn-secondary:hover {
            background-color: #6c7a89;
            border-color: #6c7a89;
        }
        footer {
            background-color: #2c3e50;
            color: #ecf0f1;
            padding: 20px 0;
            margin-top: auto;
        }
        .empty-wishlist {
            text-align: center;
            padding: 2rem;
        }
        .empty-wishlist i {
            font-size: 4rem;
            color: #bdc3c7;
            margin-bottom: 1rem;
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
        html, body {
        height: 100%;
      }

      body {
        display: flex;
        flex-direction: column;
      }

      .content-wrapper {
        flex: 1 0 auto;
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
     

.book-info {
  padding-right: 40px;
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
                    <li class="nav-item">
                        <a class="nav-link" href="perfil.jsp">
                            <i class="fas fa-user"></i> Perfil
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="carrito.jsp">
                            <i class="fas fa-shopping-cart"></i> Carrito
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="listaDeseos.jsp">
                            <i class="fas fa-heart"></i> Lista de Deseos <span id="wishlistCount" class="badge badge-light">0</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="logout.jsp">
                            <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="wishlist-card">
                    <div class="wishlist-header">
                        <h2><i class="fas fa-heart mr-2"></i>Lista de Deseos</h2>
                    </div>
                    <%
                        if (session.getAttribute("user") != null) {
                            int id_usuario = (Integer) session.getAttribute("id_usuario");
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                                String sql = "SELECT l.id_libro, l.titulo, l.autor, l.isbn, l.precio FROM Libros l INNER JOIN listadeseos ld ON l.id_libro = ld.id_libro WHERE ld.id_usuario = ?";
                                PreparedStatement ps = conn.prepareStatement(sql);
                                ps.setInt(1, id_usuario);
                                ResultSet rs = ps.executeQuery();
                                boolean hayLibros = false;
                                int contador = 0;
                                while (rs.next()) {
                                    hayLibros = true;
                                    contador++;
                    %>
                    <div class="book-item">
                        <div class="row align-items-center">
                            <div class="col-md-2">
                                <img src="imagenLibro?isbn=<%= rs.getString("isbn") %>" alt="<%= rs.getString("titulo") %>" class="book-image img-fluid">
                            </div>
                            <div class="col-md-8">
                                <h5><%= rs.getString("titulo") %></h5>
                                <p>por <%= rs.getString("autor") %></p>
                                <p>S/. <%= String.format("%.2f", rs.getDouble("precio")) %></p>
                            </div>
                            <div class="col-md-2">
                                <button class="btn btn-danger btn-sm remove-wishlist" data-id="<%= rs.getInt("id_libro") %>">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <%
                                }
                                if (!hayLibros) {
                    %>
                    <div class="empty-wishlist">
                        <i class="far fa-heart"></i>
                        <p>Tu lista de deseos está vacía.</p>
                        
                    </div>
                    <%
                                } else {
                    %>
                    <div class="text-right mt-3">
                        <p>Total de libros en la lista de deseos: <strong><%= contador %></strong></p>
                    </div>
                    <%
                                }
                                rs.close();
                                ps.close();
                                conn.close();
                            } catch (Exception e) {
                                out.println("<p class='alert alert-danger'>Error al cargar la lista de deseos: " + e.getMessage() + "</p>");
                            }
                        } else {
                            response.sendRedirect("login.jsp");
                        }
                    %>
                    <a href="librosDisponibles.jsp" class="btn btn-secondary btn-block mt-3">
                        <i class="fas fa-arrow-left mr-2"></i>Volver a Libros Disponibles
                    </a>
                </div>
            </div>
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

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        $(document).ready(function() {
            function actualizarContadorListaDeseos() {
                $.get("contarListaDeseos.jsp", function(count) {
                    $("#wishlistCount").text(count);
                });
            }

            $(".remove-wishlist").click(function() {
                var id_libro = $(this).data("id");
                var $bookItem = $(this).closest(".book-item");
                
                $.post("eliminarListaDeseos.jsp", { id_libro: id_libro }, function() {
                    $bookItem.fadeOut(300, function() {
                        $(this).remove();
                        actualizarContadorListaDeseos();
                        
                        if ($(".book-item").length === 0) {
                            $(".wishlist-card").html(`
                                <div class="empty-wishlist">
                                    <i class="far fa-heart"></i>
                                    <p>Tu lista de deseos está vacía.</p>
                                    
                                </div>
                                <a href="librosDisponibles.jsp" class="btn btn-secondary btn-block mt-3">
                                    <i class="fas fa-arrow-left mr-2"></i>Volver a Libros Disponibles
                                </a>
                            `);
                        }
                    });
                });
            });

            actualizarContadorListaDeseos();
        });
    </script>
</body>
</html>