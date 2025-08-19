<%@ page import="java.sql.*, javax.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Procesar Compra</title>
</head>
<body>
    

<%
    Integer id_usuario = (Integer) session.getAttribute("id_usuario");

    if (id_usuario == null) {
        out.println("<p>Debe iniciar sesión para realizar la compra.</p>");
    } else {
        try {
            // Conectar a la base de datos
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");

            // Actualizar el estado del carrito del usuario a "procesado"
            String query = "UPDATE carrito SET estado = 'procesado' WHERE id_usuario = ? AND estado = 'activo'";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, id_usuario);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                out.println("<p>Compra procesada con éxito. Gracias por su compra.</p>");
            } else {
                out.println("<p>No se pudo procesar la compra. Verifique su carrito.</p>");
            }

            // Cerrar la conexión
            ps.close();
            conn.close();

        } catch (Exception e) {
            out.println("<p>Error al procesar la compra.</p>");
            e.printStackTrace();
        }
    }

    // Redirigir a la página principal o a un resumen de la compra
    response.sendRedirect("librosDisponibles.jsp");
%>

</body>

</html>
