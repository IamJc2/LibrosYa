<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Buscar Usuarios - LibrosYA</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <style>
        .sidebar {
            min-height: 100vh;
            background-color: #343a40;
            display: flex;
            flex-direction: column;
        }
        .sidebar a {
            color: #ffffff;
        }
        .sidebar a:hover {
            background-color: #495057;
            text-decoration: none;
        }
        .content {
            padding: 20px;
        }
        .profile-image {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            margin: 20px auto;
            background-color: #6c757d;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            color: white;
        }
        .logout-btn {
            margin-top: auto;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-2 d-none d-md-block sidebar">
                <div class="sidebar-sticky d-flex flex-column h-100">
                    <div class="profile-image">
                        <i class="fas fa-user"></i>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" href="admin.jsp">
                                <i class="fas fa-users"></i> Gestión de Usuarios
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="admin.jsp#crearLibro">
                                <i class="fas fa-book"></i> Crear Libro
                            </a>
                        </li>
                    </ul>
                    <a href="login.jsp" class="btn btn-danger logout-btn">
                        <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
                    </a>
                </div>
            </nav>

            <!-- Contenido principal -->
            <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4 content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Buscar Usuarios</h1>
                </div>

                <form method="get" action="buscarUsuarios.jsp" class="mb-4">
                    <div class="form-row align-items-center">
                        <div class="col-auto">
                            <input type="text" class="form-control mb-2" id="keyword" name="keyword" placeholder="Introduce la palabra clave" value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
                        </div>
                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary mb-2">Buscar</button>
                        </div>
                    </div>
                </form>

                <%
                    String keyword = request.getParameter("keyword");
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");

                        String sql = "SELECT * FROM Usuarios WHERE nombre LIKE ? OR apellido LIKE ? OR email LIKE ?";
                        pstmt = conn.prepareStatement(sql);
                        String searchTerm = "%" + (keyword != null ? keyword : "") + "%";
                        pstmt.setString(1, searchTerm);
                        pstmt.setString(2, searchTerm);
                        pstmt.setString(3, searchTerm);
                        rs = pstmt.executeQuery();

                        if (rs != null) {
                %>
                <h2 class="my-4">Resultados de la Búsqueda</h2>
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="thead-dark">
                            <tr>
                                <th>ID</th>
                                <th>Nombre</th>
                                <th>Apellido</th>
                                <th>Email</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                while (rs.next()) {
                                    int id = rs.getInt("id_usuario");
                                    String nombre = rs.getString("nombre");
                                    String apellido = rs.getString("apellido");
                                    String email = rs.getString("email");
                            %>
                            <tr>
                                <td><%= id %></td>
                                <td><%= nombre %></td>
                                <td><%= apellido %></td>
                                <td><%= email %></td>
                                <td>
                                    <form method="post" action="eliminarUsuario.jsp" style="display:inline;" onsubmit="return confirm('¿Estás seguro de que deseas eliminar este usuario?');">
                                        <input type="hidden" name="id" value="<%= id %>">
                                        <button type="submit" class="btn btn-danger btn-sm">
                                            <i class="fas fa-trash-alt"></i> Eliminar
                                        </button>
                                    </form>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <%
                        } else {
                            out.println("<p class='alert alert-info'>No se encontraron resultados.</p>");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<p class='alert alert-danger'>Error al buscar usuarios: " + e.getMessage() + "</p>");
                    } finally {
                        if (rs != null) rs.close();
                        if (pstmt != null) pstmt.close();
                        if (conn != null) conn.close();
                    }
                %>
            </main>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>