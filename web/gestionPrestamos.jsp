<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="javax.naming.*, javax.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Préstamos - LibrosYA</title>
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
        .form-control {
            border-radius: 10px;
        }
        .btn-icon {
            padding: 0.375rem 0.75rem;
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
                            <a class="nav-link" href="admin.jsp">
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
                            <a class="nav-link active" href="gestionPrestamos.jsp">
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
                <h1 class="main-title"><i class="fas fa-book-reader mr-2"></i>Gestión de Préstamos</h1>
                
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h5 class="card-title"><i class="fas fa-list mr-2"></i>Lista de Préstamos</h5>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Usuario</th>
                                        <th>Libro</th>
                                        <th>Fecha Préstamo</th>
                                        <th>Fecha Devolución</th>
                                        <th>Estado</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        Connection conn = null;
                                        PreparedStatement ps = null;
                                        ResultSet rs = null;

                                        try {
                                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                                            String sql = "SELECT p.id_prestamo, u.nombre, u.apellido, l.titulo, p.fecha_prestamo, p.fecha_devolucion, p.estado " +
                                                         "FROM prestamos p " +
                                                         "JOIN usuarios u ON p.id_usuario = u.id_usuario " +
                                                         "JOIN libros l ON p.id_libro = l.id_libro " +
                                                         "ORDER BY p.fecha_prestamo DESC";
                                            ps = conn.prepareStatement(sql);
                                            rs = ps.executeQuery();

                                            while (rs.next()) {
                                    %>
                                    <tr>
                                        <td><%= rs.getInt("id_prestamo") %></td>
                                        <td><%= rs.getString("nombre") + " " + rs.getString("apellido") %></td>
                                        <td><%= rs.getString("titulo") %></td>
                                        <td><%= rs.getDate("fecha_prestamo") %></td>
                                        <td><%= rs.getDate("fecha_devolucion") %></td>
                                        <td><%= rs.getString("estado") %></td>
                                        <td>
                                            <form action="actualizarEstadoPrestamo.jsp" method="post" style="display: inline;">
                                                <input type="hidden" name="id_prestamo" value="<%= rs.getInt("id_prestamo") %>">
                                                <select name="nuevo_estado" class="form-control form-control-sm d-inline-block w-auto mr-2">
                                                    <option value="pendiente" <%= "pendiente".equals(rs.getString("estado")) ? "selected" : "" %>>Pendiente</option>
                                                    <option value="aprobado" <%= "aprobado".equals(rs.getString("estado")) ? "selected" : "" %>>Aprobado</option>
                                                    <option value="rechazado" <%= "rechazado".equals(rs.getString("estado")) ? "selected" : "" %>>Rechazado</option>
                                                    <option value="devuelto" <%= "devuelto".equals(rs.getString("estado")) ? "selected" : "" %>>Devuelto</option>
                                                </select>
                                                <button type="submit" class="btn btn-primary btn-sm">Actualizar</button>
                                            </form>
                                            <!-- Botón de Eliminar -->
                                            <form action="eliminarPrestamo.jsp" method="post" style="display: inline;">
                                                <input type="hidden" name="id_prestamo" value="<%= rs.getInt("id_prestamo") %>">
                                                <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('¿Estás seguro de que deseas eliminar este préstamo?');">Eliminar</button>
                                            </form>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                    %>
                                    <tr>
                                        <td colspan="7">
                                            <div class="alert alert-danger" role="alert">
                                                Ocurrió un error al cargar los préstamos. Por favor, intente nuevamente más tarde.
                                            </div>
                                        </td>
                                    </tr>
                                    <%
                                        } finally {
                                            if (rs != null) rs.close();
                                            if (ps != null) ps.close();
                                            if (conn != null) conn.close();
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