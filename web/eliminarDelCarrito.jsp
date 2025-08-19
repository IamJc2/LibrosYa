<%@ page import="java.sql.*, javax.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Eliminar del Carrito</title>
</head>
<body>

<%
    // Obtener el id del libro a eliminar
    String idLibroStr = request.getParameter("id_libro");
    Integer id_usuario = (Integer) session.getAttribute("id_usuario"); // Obtén el ID del usuario desde la sesión

    if (id_usuario == null) {
        out.println("<p>Debe iniciar sesión para eliminar productos del carrito.</p>");
    } else if (idLibroStr != null) {
        try {
            int id_libro = Integer.parseInt(idLibroStr);
            
            // Conectar a la base de datos
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");

            // Eliminar el libro del carrito del usuario
            String query = "DELETE dc FROM detalle_carrito dc " +
                           "JOIN carrito c ON dc.id_carrito = c.id_carrito " +
                           "WHERE c.id_usuario = ? AND dc.id_libro = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, id_usuario);
            ps.setInt(2, id_libro);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                out.println("<p>El libro ha sido eliminado del carrito.</p>");
            } else {
                out.println("<p>No se pudo eliminar el libro. Puede que no esté en su carrito.</p>");
            }

            // Cerrar conexión
            ps.close();
            conn.close();

        } catch (Exception e) {
            out.println("<p>Error al eliminar el libro del carrito.</p>");
            e.printStackTrace();
        }
    } else {
        out.println("<p>ID de libro inválido.</p>");
    }
    
    // Redirigir de vuelta al carrito
    response.sendRedirect("carrito.jsp");
%>

</body>
</html>
