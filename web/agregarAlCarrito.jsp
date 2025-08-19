<%@ page import="java.sql.*, javax.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agregar al Carrito</title>
</head>
<body>

<%
    
    Integer id_usuario = (Integer) session.getAttribute("id_usuario"); 
    String idLibroStr = request.getParameter("id_libro");
    String cantidadStr = request.getParameter("cantidad");

    
    if (id_usuario == null) {
        response.sendRedirect("login.jsp");
        return; 
    }

    if (idLibroStr != null && cantidadStr != null) {
        try {
            // Validar cantidad
            if (!cantidadStr.matches("\\d+")) {
                out.println("<p>La cantidad debe ser un número entero positivo.</p>");
                return;
            }

            int id_libro = Integer.parseInt(idLibroStr);
            int cantidad = Integer.parseInt(cantidadStr);

            // Conectar a la base de datos
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");

            // Verificar si el usuario ya tiene un carrito activo
            String queryCarrito = "SELECT id_carrito FROM carrito WHERE id_usuario = ? AND estado = 'activo'";
            PreparedStatement psCarrito = conn.prepareStatement(queryCarrito);
            psCarrito.setInt(1, id_usuario);
            ResultSet rsCarrito = psCarrito.executeQuery();

            int id_carrito;
            if (rsCarrito.next()) {
                id_carrito = rsCarrito.getInt("id_carrito");
            } else {
                // Si no tiene carrito activo, crear uno nuevo
                String crearCarrito = "INSERT INTO carrito (id_usuario) VALUES (?)";
                PreparedStatement psCrearCarrito = conn.prepareStatement(crearCarrito, Statement.RETURN_GENERATED_KEYS);
                psCrearCarrito.setInt(1, id_usuario);
                psCrearCarrito.executeUpdate();

                ResultSet rsCrearCarrito = psCrearCarrito.getGeneratedKeys();
                if (rsCrearCarrito.next()) {
                    id_carrito = rsCrearCarrito.getInt(1); // Obtener id 
                } else {
                    throw new Exception("No se pudo crear un nuevo carrito.");
                }
                psCrearCarrito.close();
            }

            // Verificar si el libro ya está en el carrito
            String queryExisteLibro = "SELECT cantidad FROM detalle_carrito WHERE id_carrito = ? AND id_libro = ?";
            PreparedStatement psExisteLibro = conn.prepareStatement(queryExisteLibro);
            psExisteLibro.setInt(1, id_carrito);
            psExisteLibro.setInt(2, id_libro);
            ResultSet rsExisteLibro = psExisteLibro.executeQuery();

            if (rsExisteLibro.next()) {
                // Si el libro ya está en el carrito, actualizar la cantidad
                int cantidadActual = rsExisteLibro.getInt("cantidad");
                String actualizarCantidad = "UPDATE detalle_carrito SET cantidad = ? WHERE id_carrito = ? AND id_libro = ?";
                PreparedStatement psActualizar = conn.prepareStatement(actualizarCantidad);
                psActualizar.setInt(1, cantidadActual + cantidad);
                psActualizar.setInt(2, id_carrito);
                psActualizar.setInt(3, id_libro);
                psActualizar.executeUpdate();
                psActualizar.close();
            } else {
                // Si el libro no está en el carrito, agregarlo
                String queryAgregar = "INSERT INTO detalle_carrito (id_carrito, id_libro, cantidad, precio_unitario) " +
                                      "VALUES (?, ?, ?, (SELECT precio FROM libros WHERE id_libro = ?))";
                PreparedStatement psAgregar = conn.prepareStatement(queryAgregar);
                psAgregar.setInt(1, id_carrito);
                psAgregar.setInt(2, id_libro);
                psAgregar.setInt(3, cantidad);
                psAgregar.setInt(4, id_libro);
                psAgregar.executeUpdate();
                psAgregar.close();
            }

            // Cerrar la conexión
            psCarrito.close();
            conn.close();

            // Redirigir de vuelta a la página de libros
            response.sendRedirect("carrito.jsp?msg=Libro agregado con éxito");
            
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error al agregar el libro al carrito.</p>");
        }
    }
%>

</body>
</html>
