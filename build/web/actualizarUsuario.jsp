<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Actualizar Usuario</title>
    <!-- Incluir Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script>
        function togglePasswordVisibility() {
            var passwordField = document.getElementById("password");
            var toggleButton = document.getElementById("togglePassword");
            if (passwordField.type === "password") {
                passwordField.type = "text";
                toggleButton.textContent = "Ocultar Contraseña";
            } else {
                passwordField.type = "password";
                toggleButton.textContent = "Mostrar Contraseña";
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <h2 class="my-4">Actualizar Usuario</h2>
        <%
            int id = Integer.parseInt(request.getParameter("id"));
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            String nombre = "";
            String apellido = "";
            String email = "";
            String rol = "";
            String contraseña = "";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                String sql = "SELECT * FROM Usuarios WHERE id_usuario=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, id);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    nombre = rs.getString("nombre");
                    apellido = rs.getString("apellido");
                    email = rs.getString("email");
                    rol = rs.getString("rol");
                    contraseña = rs.getString("contraseña");
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        %>
        <form method="post" action="actualizarUsuarioAction.jsp">
            <input type="hidden" name="id" value="<%= id %>">
            <div class="form-group">
                <label for="nombre">Nombre:</label>
                <input type="text" class="form-control" id="nombre" name="nombre" value="<%= nombre %>" required>
            </div>
            <div class="form-group">
                <label for="apellido">Apellido:</label>
                <input type="text" class="form-control" id="apellido" name="apellido" value="<%= apellido %>" required>
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" class="form-control" id="email" name="email" value="<%= email %>" required>
            </div>
            <div class="form-group">
                <label for="rol">Rol:</label>
                <input type="text" class="form-control" id="rol" name="rol" value="<%= rol %>" required>
            </div>
            <div class="form-group">
                <label for="contraseña">Contraseña:</label>
                <input type="password" class="form-control" id="password" name="contraseña" value="<%= contraseña %>" required>
                <button type="button" class="btn btn-secondary mt-2" id="togglePassword" onclick="togglePasswordVisibility()">Mostrar Contraseña</button>
            </div>
            <button type="submit" class="btn btn-primary">Actualizar</button>
        </form>
        <a href="usuarios.jsp" class="btn btn-secondary mt-4">Volver</a>
    </div>

    <!-- Incluir Bootstrap JS y dependencias -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
