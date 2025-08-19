<%@ page import="java.sql.*, javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LibrosYA - Tu Librería Online</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick-theme.min.css">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
    
    <style>
        /* General Styles */
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
        }

        /* Enhanced Navbar Styles */
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

        /* Book Carousel Styles */
        .book-carousel {
            background-color: #2c3e50;
            color: #fff;
            padding: 50px 0;
            margin-bottom: 40px;
        }
        .book-slide {
            display: flex !important;
            align-items: center;
        }
        .book-cover {
            flex: 0 0 40%;
            padding-right: 50px;
        }
        .book-info {
            flex: 0 0 60%;
            padding-right: 40px;
        }
        .book-badge {
            background-color: #e74c3c;
            color: #fff;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            margin-bottom: 10px;
            display: inline-block;
        }
        .book-title {
            font-size: 2.5rem;
            margin-bottom: 20px;
        }
        .book-description {
            font-size: 1rem;
            margin-bottom: 20px;
        }
        .btn-read-more {
            background-color: #e74c3c;
            border: none;
            padding: 10px 20px;
            font-size: 1rem;
            transition: background-color 0.3s ease;
        }
        .btn-read-more:hover {
            background-color: #c0392b;
        }

        
        .search-category-section {
            background-color: #fff;
            padding: 30px 0;
            margin-bottom: 40px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .search-form .form-control {
            border-radius: 20px 0 0 20px;
        }
        .search-form .btn {
            border-radius: 0 20px 20px 0;
        }

        /* Book Cards */
        .book-card {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-bottom: 30px;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0,0,0,.15);
        }
        .book-image {
            height: 90%;
            object-fit: cover;
            border-top-left-radius: 8px;
            border-top-right-radius: 8px;
        }
        .card-body {
            display: flex;
            flex-direction: column;
            flex-grow: 1;
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
            margin-top: auto;
        }
        .wishlist-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(255,255,255,0.8);
            border: none;
            font-size: 1.2rem;
            color: #e74c3c;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: transform 0.3s ease;
        }
        .wishlist-btn:hover {
            transform: scale(1.1);
        }

        /* Footer Styles */
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
                                                out.print("<span class='badge badge-pill badge-danger'>" + totalItems + "</span>");
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

<!-- Book Carousel -->
<section class="book-carousel">
    <div class="container">
        <div class="carousel">
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                         PreparedStatement ps = conn.prepareStatement("SELECT * FROM Libros ORDER BY RAND() LIMIT 5");
                         ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            String isbn = rs.getString("isbn");
                            String titulo = rs.getString("titulo");
                            String descripcion = rs.getString("resumen");
            %>
            <div class="book-slide">
                <div class="book-cover">
                    <img src="imagenLibro?isbn=<%= isbn %>" alt="<%= titulo %>" class="img-fluid">
                </div>
                <div class="book-info">
                    <span class="book-badge">Mejores Libros Disponibles</span>
                    <h2 class="book-title"><%= titulo %></h2>
                    <p class="book-description"><%= descripcion.substring(0, Math.min(descripcion.length(), 150)) %>...</p>
                    <a href="detalleLibro.jsp?isbn=<%= isbn %>" class="btn btn-read-more">LEER MÁS</a>
                </div>
            </div>
            <%
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </div>
    </div>
</section>

<!-- Search Section -->
<section class="search-category-section">
    <div class="container">
        <div class="row">
            <div class="col-md-8 mb-3">
                <form method="get" action="" class="search-form" id="searchForm">
                    <div class="input-group">
                        <input type="text" class="form-control" name="search" placeholder="Buscar por ISBN, título o autor">
                        <div class="input-group-append">
                            <button class="btn btn-primary" type="submit">
                                <i class="fas fa-search"></i> Buscar
                            </button>
                        </div>
                    </div>
                </form>
            </div>
            <div class="col-md-4 mb-3">
                <form id="category-form" method="get" action="">
                    <select id="categoria" name="categoria" class="form-control custom-select" onchange="this.form.submit()">
                        <option value="">Todas las categorías</option>
                        <% 
                            String selectedCategoria = request.getParameter("categoria");
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                                     PreparedStatement ps = conn.prepareStatement("SELECT DISTINCT categoria FROM Libros");
                                     ResultSet rs = ps.executeQuery()) {
                                    while (rs.next()) {
                                        String categoria = rs.getString("categoria");
                                        String selected = categoria.equals(selectedCategoria) ? "selected" : "";
                        %>
                        <option value="<%= categoria %>" <%= selected %>><%= categoria %></option>
                        <% 
                                    }
                                }
                            } catch (Exception e) {
                                out.println("<option>Error al cargar categorías</option>");
                                e.printStackTrace();
                            }
                        %>
                    </select>
                </form>
            </div>
        </div>
    </div>
</section>

<!-- Libros Section -->
<section class="books-section" id="libros-section">
    <div class="container">
        <div class="row">
            <% 
                String search = request.getParameter("search");
                String categoria = request.getParameter("categoria");
                String query = "SELECT * FROM Libros WHERE 1=1";
                if (search != null && !search.trim().isEmpty()) {
                    query += " AND (titulo LIKE ? OR autor LIKE ? OR isbn LIKE ?)";
                }
                if (categoria != null && !categoria.trim().isEmpty()) {
                    query += " AND categoria = ?";
                }
                
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                         PreparedStatement ps = conn.prepareStatement(query)) {
                        int index = 1;
                        if (search != null && !search.trim().isEmpty()) {
                            ps.setString(index++, "%" + search + "%");
                            ps.setString(index++, "%" + search + "%");
                            ps.setString(index++, "%" + search + "%");
                        }
                        if (categoria != null && !categoria.trim().isEmpty()) {
                            ps.setString(index, categoria);
                        }
                        try (ResultSet rs = ps.executeQuery()) {
                            while (rs.next()) {
                                String isbn = rs.getString("isbn");
                                String titulo = rs.getString("titulo");
                                String autor = rs.getString("autor");
                                String categoriaLibro = rs.getString("categoria");
                                double precio = rs.getDouble("precio");
                                int cantidadDisponible = rs.getInt("cantidad_disponible");
                                int id_libro = rs.getInt("id_libro");
            %>
            <div class="col-md-3 col-sm-6 mb-4">
                <div class="book-card">
                    <div class="position-relative">
                        <img src="imagenLibro?isbn=<%= isbn %>" alt="<%= titulo %>" class="book-image img-fluid w-100">
                        <% if (session.getAttribute("user") != null) { %>
                            <form action="agregarListaDeseos.jsp" method="post" class="d-inline">
                                <input type="hidden" name="id_libro" value="<%= id_libro %>">
                                <button type="submit" class="wishlist-btn">
                                    <i class="far fa-heart"></i>
                                </button>
                            </form>
                        <% } %>
                    </div>
                    <div class="card-body d-flex flex-column">
                        <h5 class="book-title"><%= titulo %></h5>
                        <p class="book-author">por <%= autor %></p>
                        <p class="book-category"><%= categoriaLibro %></p>
                        <p class="book-price mt-auto">S/. <%= String.format("%.2f", precio) %></p>
                        <form action="agregarAlCarrito.jsp" method="post" class="mt-2" onsubmit="return verificarStock(<%= cantidadDisponible %>)">
                            <input type="hidden" name="id_libro" value="<%= id_libro %>">
                            <div class="form-group">
                                <select name="cantidad" class="form-control form-control-sm">
                                    <% 
                                        // Aquí no hay límite de 10, solo muestra hasta la cantidad disponible.
                                        for (int i = 1; i <= cantidadDisponible; i++) { 
                                    %>
                                        <option value="<%= i %>"><%= i %></option>
                                    <% } %>
                                </select>

                            </div>
                            <% if (session.getAttribute("user") != null) { %>
                                <button type="submit" class="btn btn-primary btn-sm btn-block">Agregar al Carrito</button>
                            <% } else { %>
                                <button type="button" class="btn btn-primary btn-sm btn-block" onclick="mostrarAlerta('Por favor, inicia sesión para agregar al carrito.')">Agregar al Carrito</button>
                            <% } %>
                        </form>
                        <a href="detalleLibro.jsp?isbn=<%= isbn %>" class="btn btn-outline-secondary btn-sm btn-block mt-2">Ver Detalle</a>
                    </div>
                </div>
            </div>
            <% 
                            }
                        }
                    }
                } catch (Exception e) {
                    out.println("<div class='col-12'><p class='alert alert-danger'>Error al obtener los libros. Por favor, intente de nuevo más tarde.</p></div>");
                    e.printStackTrace();
                }
            %>
        </div>
    </div>
</section>

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
<script src="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick.min.js"></script>
<script>
    function verificarStock(cantidadDisponible) {
        // Verifica si el libro tiene stock
        if (cantidadDisponible === 0) {
            // Muestra el mensaje de SweetAlert2 si no hay stock
            Swal.fire({
                icon: 'error',
                title: 'Sin Stock',
                text: 'Lo siento, este libro no está disponible en este momento.',
                confirmButtonText: 'OK'
            });
            return false; // Evita que se envíe el formulario
        }
        return true; // Permite que el formulario se envíe si hay stock
    }
</script>
<script>
    $(document).ready(function() {
        // Inicializa Slick Carousel
        $('.carousel').slick({
            dots: true,
            infinite: true,
            speed: 500,
            fade: true,
            cssEase: 'linear',
            prevArrow: '<button type="button" class="slick-prev">&#8249;</button>',
            nextArrow: '<button type="button" class="slick-next">&#8250;</button>'
        });

        // Guardar la posición del scroll cuando el formulario de búsqueda es enviado
        $('#searchForm').submit(function(e) {
            e.preventDefault();
            sessionStorage.setItem('scrollPosition', $(window).scrollTop());
            this.submit(); // Enviar el formulario de búsqueda
        });

        // Guardar la posición del scroll cuando cambia la categoría
        $('#categoria').change(function() {
            sessionStorage.setItem('scrollPosition', $(window).scrollTop());
            $('#category-form').submit(); // Enviar el formulario de categoría
        });

        // Restaurar la posición del scroll cuando la página carga
        $(window).on('load', function() {
            var savedScrollPosition = sessionStorage.getItem('scrollPosition');
            if (savedScrollPosition) {
                $(window).scrollTop(savedScrollPosition);
                sessionStorage.removeItem('scrollPosition'); // Limpiar la posición guardada
            }
        });
    });

    function mostrarAlerta(mensaje) {
        Swal.fire({
            icon: 'warning',
            title: 'Atención',
            text: mensaje,
            confirmButtonText: 'OK'
        });
    }
</script>

<script>
    $(document).ready(function(){
        $('.carousel').slick({
            dots: true,
            infinite: true,
            speed: 500,
            fade: true,
            cssEase: 'linear',
            prevArrow: '<button type="button" class="slick-prev">&#8249;</button>',
            nextArrow: '<button type="button" class="slick-next">&#8250;</button>'
        });

        // Guardar la posición del scroll
        var scrollPosition;

        // Función para guardar la posición del scroll
        function saveScrollPosition() {
            scrollPosition = $(window).scrollTop();
        }

        // Función para restaurar la posición del scroll
        function restoreScrollPosition() {
            if (scrollPosition !== undefined) {
                $(window).scrollTop(scrollPosition);
            }
        }

        // Manejar el envío del formulario de búsqueda
        $('#searchForm').submit(function(e) {
            e.preventDefault();
            saveScrollPosition();
            this.submit();
        });

        // Manejar el cambio de categoría
        $('#categoria').change(function() {
            saveScrollPosition();
            $('#category-form').submit();
        });

        // Restaurar la posición del scroll después de que la página se haya cargado completamente
        $(window).on('load', function() {
            restoreScrollPosition();
        });
    });

    function mostrarAlerta(mensaje) {
        Swal.fire({
            icon: 'warning',
            title: 'Atención',
            text: mensaje,
            confirmButtonText: 'OK'
        });
    }
</script>
</body>
</html>