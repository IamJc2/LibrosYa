<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Libros</title>
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
        .book-image {
            max-width: 100px;
            height: auto;
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
                            <a class="nav-link active" href="listarLibros.jsp">
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
                <h1 class="main-title"><i class="fas fa-book mr-2"></i>Lista de Libros</h1>
                <div class="card shadow-sm">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Título</th>
                                        <th>Autor</th>
                                        <th>Imagen</th>
                                        <th>ISBN</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        String url = "jdbc:mysql://localhost:3306/librosya";
                                        String user = "root";
                                        String password = "123456";

                                        ArrayList<String[]> libros = new ArrayList<>();

                                        try {
                                            Class.forName("com.mysql.cj.jdbc.Driver");
                                            try (Connection conn = DriverManager.getConnection(url, user, password)) {
                                                String sql = "SELECT titulo, autor, isbn FROM Libros";
                                                PreparedStatement ps = conn.prepareStatement(sql);
                                                ResultSet rs = ps.executeQuery();

                                                while (rs.next()) {
                                                    String[] libro = new String[3];
                                                    libro[0] = rs.getString("titulo");
                                                    libro[1] = rs.getString("autor");
                                                    libro[2] = rs.getString("isbn");
                                                    libros.add(libro);
                                                }
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }

                                        for (String[] libro : libros) {
                                    %>
                                        <tr>
                                            <td><%= libro[0] %></td>
                                            <td><%= libro[1] %></td>
                                            <td>
                                                <img src="imagenLibro?isbn=<%= libro[2] %>" alt="<%= libro[0] %>" class="book-image img-fluid">
                                            </td>
                                            <td><%= libro[2] %></td>
                                        </tr>
                                    <%
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