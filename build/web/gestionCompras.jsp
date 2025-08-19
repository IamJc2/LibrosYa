<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Compras - LibrosYA</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .sidebar {
            min-height: 100vh;
            background-color: #343a40;
            padding-top: 20px;
            position: fixed;
            top: 0;
            left: 0;
            width: 250px;
            z-index: 100;
        }
        .sidebar a {
            color: #ffffff;
            padding: 10px 15px;
            display: block;
            transition: all 0.3s;
        }
        .sidebar a:hover {
            background-color: #495057;
            text-decoration: none;
        }
        .content {
            margin-left: 250px;
            padding: 20px;
        }
        .main-title {
            font-size: 2rem;
            font-weight: 700;
            color: #343a40;
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #007bff;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }
        .table-responsive {
            border-radius: 15px;
            overflow: hidden;
        }
        .profile-image {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            margin: 0 auto 20px;
            background-color: #6c757d;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            color: white;
        }
        .logout-btn {
            position: fixed;
            bottom: 20px;
            left: 15px;
            width: 220px;
            z-index: 1000;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-2 d-none d-md-block sidebar">
                <div class="sidebar-sticky">
                    <div class="profile-image">
                        <i class="fas fa-user"></i>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" href="admin.jsp">
                                <i class="fas fa-users mr-2"></i> Gestión de Usuarios
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="crearLibro.jsp">
                                <i class="fas fa-book mr-2"></i> Agregar Libros
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="listarLibros.jsp">
                                <i class="fas fa-list mr-2"></i> Listar Libros
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="gestionPrestamos.jsp">
                                <i class="fas fa-book-reader mr-2"></i> Gestión de Préstamos
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="gestionCompras.jsp">
                                <i class="fas fa-shopping-cart mr-2"></i> Gestión de Compras
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- Contenido principal -->
            <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4 content">
                <h1 class="main-title"><i class="fas fa-shopping-cart mr-2"></i>Gestión de Compras</h1>

                <div class="card shadow-sm mb-4">
                    <div class="card-body">
                        <h5 class="card-title"><i class="fas fa-list mr-2"></i>Lista de Compras</h5>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID Carrito</th>
                                        <th>Nombre del Usuario</th>
                                        <th>Fecha de Creación</th>
                                        <th>Estado</th>
                                        <th>Total</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        Connection conn = null;
                                        PreparedStatement pstmt = null;
                                        ResultSet rs = null;
                                        try {
                                            Class.forName("com.mysql.cj.jdbc.Driver");
                                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                                            String sql = "SELECT c.id_carrito, u.nombre, u.apellido, c.fecha_creacion, c.estado, " +
                                                         "SUM(dc.cantidad * dc.precio_unitario) as total " +
                                                         "FROM carrito c " +
                                                         "LEFT JOIN detalle_carrito dc ON c.id_carrito = dc.id_carrito " +
                                                         "JOIN usuarios u ON c.id_usuario = u.id_usuario " +
                                                         "GROUP BY c.id_carrito " +
                                                         "ORDER BY c.fecha_creacion DESC";
                                            pstmt = conn.prepareStatement(sql);
                                            rs = pstmt.executeQuery();
                                            
                                            while (rs.next()) {
                                                int idCarrito = rs.getInt("id_carrito");
                                                String nombreUsuario = rs.getString("nombre") + " " + rs.getString("apellido");
                                                String fechaCreacion = rs.getString("fecha_creacion");
                                                String estado = rs.getString("estado");
                                                double total = rs.getDouble("total");
                                    %>
                                    <tr>
                                        <td><%= idCarrito %></td>
                                        <td><%= nombreUsuario %></td>
                                        <td><%= fechaCreacion %></td>
                                        <td><%= estado %></td>
                                        <td>S/. <%= String.format("%.2f", total) %></td>
                                        <td>
                                            <a href="detalleCarrito.jsp?id=<%= idCarrito %>" class="btn btn-info btn-sm btn-icon">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                    %>
                                    <tr>
                                        <td colspan="6" class="text-center text-danger">Error al cargar los datos: <%= e.getMessage() %></td>
                                    </tr>
                                    <%
                                        } finally {
                                            if (rs != null) try { rs.close(); } catch (SQLException e) { }
                                            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                                            if (conn != null) try { conn.close(); } catch (SQLException e) { }
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
                                
    <a href="login.jsp" class="btn btn-danger btn-block logout-btn">
        <i class="fas fa-sign-out-alt mr-2"></i> Cerrar Sesión
    </a>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>