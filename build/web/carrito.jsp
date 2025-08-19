<%@ page import="java.sql.*, javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LibrosYA - Carrito de Compras</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
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
        .hero-section {
            background: linear-gradient(rgba(44, 62, 80, 0.7), rgba(44, 62, 80, 0.7)), url('https://source.unsplash.com/1600x900/?library,books') no-repeat center center;
            background-size: cover;
            color: #fff;
            padding: 60px 0;
            margin-bottom: 40px;
        }
        .hero-title {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 20px;
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
            margin-top: auto;
        }
        .cart-item {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,.1);
            margin-bottom: 20px;
            padding: 20px;
            transition: transform 0.3s ease;
        }
        .cart-item:hover {
            transform: translateY(-5px);
        }
        .cart-item img {
            max-width: 100px;
            height: auto;
            object-fit: cover;
            border-radius: 4px;
        }
        .cart-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
        }
        .cart-actions .btn {
            width: 48%;
        }
        .empty-cart {
            text-align: center;
            padding: 40px 0;
        }
        .empty-cart i {
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
        
        .book-info {
            padding-right: 40px;
        }
        /* Nuevo estilo para limitar la altura del select */
        .quantity-select {
            max-height: 150px;
            overflow-y: auto;
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
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
        <a class="navbar-brand" href="librosDisponibles.jsp">Libros<span class="text-primary">YA</span></a>
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
                        <i class="fas fa-heart"></i> Lista de Deseos
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

<!-- Hero Section -->
<section class="hero-section text-center">
    <div class="container">
        <h1 class="hero-title">Tu Carrito de Compras</h1>
        <p class="lead">Revisa tus selecciones y completa tu compra</p>
    </div>
</section>

<!-- Contenido del Carrito -->
<section class="cart-content">
    <div class="container">
        <%
            if (session.getAttribute("id_usuario") != null) {
                int id_usuario = (Integer) session.getAttribute("id_usuario");
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");

                    String queryCarrito = "SELECT l.id_libro, l.titulo, l.autor, l.precio, dc.cantidad, l.isbn, l.cantidad_disponible " +
                                          "FROM detalle_carrito dc " +
                                          "JOIN carrito c ON dc.id_carrito = c.id_carrito " +
                                          "JOIN Libros l ON dc.id_libro = l.id_libro " +
                                          "WHERE c.id_usuario = ? AND c.estado = 'activo'";
                    PreparedStatement ps = conn.prepareStatement(queryCarrito);
                    ps.setInt(1, id_usuario);
                    ResultSet rs = ps.executeQuery();

                    double total = 0;
                    boolean hayLibros = false;

                    while (rs.next()) {
                        hayLibros = true;
                        int id_libro = rs.getInt("id_libro");
                        String titulo = rs.getString("titulo");
                        String autor = rs.getString("autor");
                        double precio = rs.getDouble("precio");
                        int cantidad = rs.getInt("cantidad");
                        String isbn = rs.getString("isbn");
                        int cantidad_disponible = rs.getInt("cantidad_disponible");
                        total += precio * cantidad;
        %>
        <div class="cart-item">
            <div class="row">
                <div class="col-md-2">
                    <img src="imagenLibro?isbn=<%= isbn %>" alt="<%= titulo %>" class="img-fluid">
                </div>
                <div class="col-md-6">
                    <h5><%= titulo %></h5>
                    <p>Autor: <%= autor %></p>
                    <p>Precio: S/. <span class="precio"><%= String.format("%.2f", precio) %></span></p>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="cantidad-<%= id_libro %>">Cantidad:</label>
                        <select class="form-control quantity-select" id="cantidad-<%= id_libro %>" onchange="actualizarCantidad(<%= id_libro %>, this.value)">
                            <% for(int i = 1; i <= cantidad_disponible; i++) { %>
                                <option value="<%= i %>" <%= (i == cantidad) ? "selected" : "" %>><%= i %></option>
                            <% } %>
                        </select>
                    </div>
                    <button type="button" class="btn btn-danger btn-block" onclick="eliminarDelCarrito(<%= id_libro %>)">Eliminar</button>
                </div>
            </div>
        </div>
        <%
                    }
                    rs.close();
                    ps.close();
                    conn.close();

                    if (!hayLibros) {
        %>
        <div class="empty-cart">
            <i class="fas fa-shopping-cart"></i>
            <h3>Tu carrito está vacío</h3>
            <p>¿Por qué no agregas algunos libros increíbles?</p>
            <a href="librosDisponibles.jsp" class="btn btn-primary mt-3">Explorar Libros</a>
        </div>
        <%
                    } else {
        %>
        <div class="row mt-4">
            <div class="col-md-6 offset-md-6">
                <h4 class="text-right">Total: S/. <span id="total"><%= String.format("%.2f", total) %></span></h4>
            </div>
        </div>
        <div class="row mt-4">
            <div class="col-md-6">
                <a href="librosDisponibles.jsp" class="btn btn-secondary btn-block">
                    <i class="fas fa-arrow-left"></i> Seguir Comprando
                </a>
            </div>
            <div class="col-md-6">
                <a href="pasarelaCompra.jsp?from=cart" class="btn btn-success btn-block">
                    Procesar Compra <i class="fas fa-shopping-cart"></i>
                </a>
            </div>
        </div>
        <%
                    }
                } catch (Exception e) {
                    out.println("<p class='alert alert-danger'>Error al obtener el carrito. Por favor, intente de nuevo más tarde.</p>");
                    e.printStackTrace();
                }
            } else {
                out.println("<p class='alert alert-warning'>Por favor, inicie sesión para ver su carrito.</p>");
            }
        %>
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
<script>
    function eliminarDelCarrito(id_libro) {
    // Mostrar la alerta de SweetAlert2
    Swal.fire({
        title: '¿Estás seguro?',
        text: "¡Este libro será eliminado del carrito!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Sí, eliminar',
        cancelButtonText: 'Cancelar'
    }).then((result) => {
        // Si el usuario confirma la eliminación
        if (result.isConfirmed) {
            // Enviar la solicitud para eliminar el libro del carrito
            $.post("eliminarDelCarrito.jsp", { id_libro: id_libro }, function(data) {
                // Recargar la página después de eliminar el libro
                location.reload();
            });
        }
    });
}

</script>

<script>
    function actualizarCantidad(id_libro, nuevaCantidad) {
        $.post("actualizarCarrito.jsp", { id_libro: id_libro, cantidad: nuevaCantidad }, function(data) {
            calcularTotal();
        });
    }

    function calcularTotal() {
        let total = 0;
        $('.cart-item').each(function() {
            const precio = parseFloat($(this).find('.precio').text());
            const cantidad = parseInt($(this).find('select').val());
            total += precio * cantidad;
        });
        $('#total').text(total.toFixed(2));
    }


    $(document).ready(function() {
        calcularTotal();
    });
</script>
</body>
</html>