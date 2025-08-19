<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Administración</title>
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
        #successMessage, #errorMessage {
            display: none;
            margin-top: 20px;
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
                <h1 class="main-title"><i class="fas fa-tachometer-alt mr-2"></i>Panel de Administración</h1>

                <!-- Sección de Gestión de Usuarios -->
                <section id="gestionUsuarios">
                    <div class="card shadow-sm mb-4">
                        <div class="card-body">
                            <h5 class="card-title"><i class="fas fa-search mr-2"></i>Buscar Usuarios</h5>
                            <form method="get" action="buscarUsuarios.jsp" class="form-inline">
                                <div class="form-group mb-2 mr-2">
                                    <label for="keyword" class="sr-only">Palabra clave</label>
                                    <input type="text" class="form-control" id="keyword" name="keyword" placeholder="Buscar usuarios...">
                                </div>
                                <button type="submit" class="btn btn-primary mb-2"><i class="fas fa-search mr-2"></i>Buscar</button>
                            </form>
                        </div>
                    </div>

                    <div class="card shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title"><i class="fas fa-list mr-2"></i>Lista de Usuarios</h5>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
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
                                            Connection conn = null;
                                            Statement stmt = null;
                                            ResultSet rs = null;
                                            try {
                                                Class.forName("com.mysql.cj.jdbc.Driver");
                                                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                                                stmt = conn.createStatement();
                                                rs = stmt.executeQuery("SELECT * FROM Usuarios WHERE rol = 'cliente'");
                                                
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
                                                    <button type="submit" class="btn btn-danger btn-sm btn-icon">
                                                        <i class="fas fa-trash-alt"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                            } catch (Exception e) {
                                                e.printStackTrace();
                                            } finally {
                                                if (rs != null) rs.close();
                                                if (stmt != null) stmt.close();
                                                if (conn != null) conn.close();
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </section>
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