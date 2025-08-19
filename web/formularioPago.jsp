<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="Mail.MailUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Formulario de Pago - LibrosYA</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
        }
        .payment-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .form-group label {
            font-weight: bold;
        }
        .btn-pay {
            background-color: #28a745;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="payment-container">
            <h2 class="text-center mb-4">Formulario de Pago</h2>
            <%
                String isbn = request.getParameter("isbn");
                String action = request.getParameter("action");
                
                if ("process_payment".equals(action)) {
                    // Simular procesamiento de pago
                    boolean pagoExitoso = true; // En un escenario real, aquí iría la lógica de procesamiento del pago
                    
                    if (pagoExitoso) {
                        // Actualizar la base de datos (simular venta)
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                            
                            // Obtener detalles de los libros para el correo
                            StringBuilder emailBody = new StringBuilder("Gracias por tu compra. Has adquirido los siguientes libros:\n\n");
                            double totalCompra = 0;

                            if ("from_cart".equals(request.getParameter("from"))) {
                                // Obtener todos los libros del carrito
                                String sql = "SELECT l.titulo, l.precio, dc.cantidad, l.id_libro, c.id_carrito " +
                                             "FROM detalle_carrito dc " +
                                             "JOIN carrito c ON dc.id_carrito = c.id_carrito " +
                                             "JOIN Libros l ON dc.id_libro = l.id_libro " +
                                             "WHERE c.id_usuario = ? AND c.estado = 'activo'";
                                PreparedStatement ps = conn.prepareStatement(sql);
                                ps.setInt(1, (Integer) session.getAttribute("id_usuario"));
                                ResultSet rs = ps.executeQuery();
                                int id_carrito = 0;

                                // Calcular el total y preparar el cuerpo del correo
                                while (rs.next()) {
                                    String titulo = rs.getString("titulo");
                                    double precio = rs.getDouble("precio");
                                    int cantidad = rs.getInt("cantidad");
                                    int id_libro = rs.getInt("id_libro");
                                    id_carrito = rs.getInt("id_carrito");
                                    double subtotal = precio * cantidad;
                                    totalCompra += subtotal;
                                    emailBody.append(String.format("- %s (x%d): S/ %.2f\n", titulo, cantidad, subtotal));
                                    
                                    // Actualizar cantidad disponible
                                    String updateSql = "UPDATE Libros SET cantidad_disponible = cantidad_disponible - ? WHERE id_libro = ?";
                                    PreparedStatement updatePs = conn.prepareStatement(updateSql);
                                    updatePs.setInt(1, cantidad);
                                    updatePs.setInt(2, id_libro);
                                    updatePs.executeUpdate();
                                    updatePs.close();
                                }
                                rs.close();
                                ps.close();

                                // Vaciar el carrito
                                String sqlVaciarCarrito = "DELETE FROM detalle_carrito WHERE id_carrito = ?";
                                PreparedStatement psVaciar = conn.prepareStatement(sqlVaciarCarrito);
                                psVaciar.setInt(1, id_carrito);
                                psVaciar.executeUpdate();
                                psVaciar.close();

                                // Actualizar el estado del carrito a 'procesado'
                                String sqlActualizarCarrito = "UPDATE carrito SET estado = 'procesado' WHERE id_carrito = ?";
                                PreparedStatement psActualizar = conn.prepareStatement(sqlActualizarCarrito);
                                psActualizar.setInt(1, id_carrito);
                                psActualizar.executeUpdate();
                                psActualizar.close();
                            } else {
                                // Caso de compra de un solo libro
                                String sql = "SELECT titulo, precio FROM Libros WHERE isbn = ?";
                                PreparedStatement ps = conn.prepareStatement(sql);
                                ps.setString(1, isbn);
                                ResultSet rs = ps.executeQuery();
                                if (rs.next()) {
                                    String titulo = rs.getString("titulo");
                                    double precio = rs.getDouble("precio");
                                    totalCompra = precio;
                                    emailBody.append(String.format("- %s: S/ %.2f\n", titulo, precio));
                                    
                                    // Actualizar cantidad disponible
                                    String updateSql = "UPDATE Libros SET cantidad_disponible = cantidad_disponible - 1 WHERE isbn = ?";
                                    PreparedStatement updatePs = conn.prepareStatement(updateSql);
                                    updatePs.setString(1, isbn);
                                    updatePs.executeUpdate();
                                    updatePs.close();
                                }
                                rs.close();
                                ps.close();
                            }

                            emailBody.append(String.format("\nTotal de la compra: S/ %.2f", totalCompra));

                            conn.close();

                            // Enviar correo electrónico de confirmación
                            String userEmail = (String) session.getAttribute("user");
                            String smtpHost = "smtp.gmail.com";
                            String smtpPort = "587";
                            String smtpUser = "reyes.luisito2002@gmail.com";
                            String smtpPassword = "uhnv cbkm gcoq jmqz";
                            String emailSubject = "Confirmación de compra - LibrosYA";

                            MailUtil.sendEmail(userEmail, emailSubject, emailBody.toString(), smtpHost, smtpPort, smtpUser, smtpPassword);
            %>
                            <div class="alert alert-success" role="alert">
                                <h4 class="alert-heading">¡Pago Exitoso!</h4>
                                <p>Tu compra se ha procesado correctamente. Hemos enviado un correo de confirmación a tu dirección de email.</p>
                            </div>
                            <a href="librosDisponibles.jsp" class="btn btn-primary btn-block">Volver al Catálogo</a>
            <%
                        } catch (Exception e) {
                            e.printStackTrace();
            %>
                            <div class="alert alert-danger" role="alert">
                                <h4 class="alert-heading">Error en el Proceso</h4>
                                <p>Lo sentimos, ha ocurrido un error al procesar tu compra. Por favor, intenta nuevamente más tarde.</p>
                            </div>
                            <button onclick="history.back()" class="btn btn-secondary btn-block">Volver e Intentar de Nuevo</button>
            <%
                        }
                    } else {
            %>
                        <div class="alert alert-danger" role="alert">
                            <h4 class="alert-heading">Error en el Pago</h4>
                            <p>Lo sentimos, ha ocurrido un error al procesar tu pago. Por favor, intenta nuevamente.</p>
                        </div>
                        <button onclick="history.back()" class="btn btn-secondary btn-block">Volver e Intentar de Nuevo</button>
            <%
                    }
                } else {
                    // Mostrar el formulario de pago
                    double total = 0;
                    if ("from_cart".equals(request.getParameter("from"))) {
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                            String sql = "SELECT SUM(l.precio * dc.cantidad) as total " +
                                         "FROM detalle_carrito dc " +
                                         "JOIN carrito c ON dc.id_carrito = c.id_carrito " +
                                         "JOIN Libros l ON dc.id_libro = l.id_libro " +
                                         "WHERE c.id_usuario = ? AND c.estado = 'activo'";
                            PreparedStatement ps = conn.prepareStatement(sql);
                            ps.setInt(1, (Integer) session.getAttribute("id_usuario"));
                            ResultSet rs = ps.executeQuery();
                            if (rs.next()) {
                                total = rs.getDouble("total");
                            }
                            rs.close();
                            ps.close();
                            conn.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    } else if (isbn != null && !isbn.isEmpty()) {
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                            String sql = "SELECT precio FROM Libros WHERE isbn = ?";
                            PreparedStatement ps = conn.prepareStatement(sql);
                            ps.setString(1, isbn);
                            ResultSet rs = ps.executeQuery();
                            if (rs.next()) {
                                total = rs.getDouble("precio");
                            }
                            rs.close();
                            ps.close();
                            conn.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
            %>
                <h4 class="mb-4">Total a Pagar: S/ <%= String.format("%.2f", total) %></h4>
                <form action="formularioPago.jsp" method="post">
                    <input type="hidden" name="isbn" value="<%= isbn %>">
                    <input type="hidden" name="action" value="process_payment">
                    <input type="hidden" name="from" value="<%= request.getParameter("from") %>">
                    <div class="form-group">
                        <label for="cardNumber">Número de Tarjeta</label>
                        <input type="text" class="form-control" id="cardNumber" name="cardNumber" required>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="expiryDate">Fecha de Expiración</label>
                            <input type="text" class="form-control" id="expiryDate" name="expiryDate" placeholder="MM/YY" required>
                        </div>
                        <div class="form-group col-md-6">
                            <label for="cvv">CVV</label>
                            <input type="text" class="form-control" id="cvv" name="cvv" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="cardName">Nombre en la Tarjeta</label>
                        <input type="text" class="form-control" id="cardName" name="cardName" required>
                    </div>
                    <button type="submit" class="btn btn-pay btn-block">Procesar Pago</button>
                </form>
            <%
                }
            %>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
