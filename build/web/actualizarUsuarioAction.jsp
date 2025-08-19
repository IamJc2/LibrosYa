<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Actualizar Usuario</title>
</head>
<body>
    <%
        int id = Integer.parseInt(request.getParameter("id"));
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String email = request.getParameter("email");
        String rol = request.getParameter("rol");
        String contraseña = request.getParameter("contraseña");

        if (nombre != null && !nombre.isEmpty() && apellido != null && !apellido.isEmpty() && email != null && !email.isEmpty() && rol != null && !rol.isEmpty() && contraseña != null && !contraseña.isEmpty()) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                String sql = "UPDATE Usuarios SET nombre=?, apellido=?, email=?, rol=?, contraseña=? WHERE id_usuario=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, nombre);
                pstmt.setString(2, apellido);
                pstmt.setString(3, email);
                pstmt.setString(4, rol);
                pstmt.setString(5, contraseña);
                pstmt.setInt(6, id);
                pstmt.executeUpdate();
                out.println("<p>Usuario actualizado con éxito.</p>");
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p style='color:red;'>Error al actualizar usuario.</p>");
            } finally {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        } else {
            out.println("<p style='color:red;'>Todos los campos son obligatorios.</p>");
        }
    %>
    <a href="usuarios.jsp">Volver</a>
</body>
</html>
