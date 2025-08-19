<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Actualizar Libro</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
</head>
<body>
<div class="container">
    <h1>Actualizar Libro</h1>
    <%
        String isbn = request.getParameter("isbn");
        String titulo = "", autor = "";

        // Conectar a la base de datos y obtener los datos del libro
        String url = "jdbc:mysql://localhost:3306/librosya";
        String user = "root";
        String password = "123456";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, password)) {
                String sql = "SELECT titulo, autor FROM Libros WHERE isbn = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, isbn);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    titulo = rs.getString("titulo");
                    autor = rs.getString("autor");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>

    <form action="actualizarLibroServlet" method="post">
        <input type="hidden" name="isbn" value="<%= isbn %>">
        <div class="form-group">
            <label for="titulo">Título:</label>
            <input type="text" class="form-control" id="titulo" name="titulo" value="<%= titulo %>" required>
        </div>
        <div class="form-group">
            <label for="autor">Autor:</label>
            <input type="text" class="form-control" id="autor" name="autor" value="<%= autor %>" required>
        </div>
        <button type="submit" class="btn btn-primary">Actualizar</button>
    </form>
</div>
</body>
</html>
