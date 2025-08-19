<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="Mail.MailUtil" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirmación de Compra - LibrosYA</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 1rem;
        }
        .card {
            max-width: 500px;
            width: 100%;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border-radius: 30px;
        }
        .card-title {
            font-size: 1.5rem;
            font-weight: bold;
        }
        .alert {
            display: flex;
            align-items: flex-start;
            border-radius: 30px;
        }
        .alert i {
            margin-right: 10px;
            font-size: 1.25rem;
            margin-top: 3px;
        }
        .order-number {
            font-weight: bold;
            margin-top: 10px;
        }
        .boucher {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 15px;
            padding: 15px;
            margin-top: 20px;
        }
        .boucher-header {
            border-bottom: 2px dashed #ddd;
            padding-bottom: 10px;
            margin-bottom: 10px;
        }
        .boucher-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 5px;
        }
        .boucher-total {
            border-top: 2px dashed #ddd;
            padding-top: 10px;
            margin-top: 10px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="card-body">
            <h5 class="card-title text-center mb-4">Confirmación de Compra</h5>
            <%
                String orderId = request.getParameter("orderId");
                int userId = (Integer) session.getAttribute("id_usuario");
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                boolean purchaseSuccess = false;
                double precioTotal = 0.0;
                List<Map<String, Object>> items = new ArrayList<>();
                
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                    
                    String sqlCarrito = "SELECT l.id_libro, l.titulo, dc.cantidad, l.precio, l.cantidad_disponible " +
                                        "FROM detalle_carrito dc " +
                                        "JOIN carrito c ON dc.id_carrito = c.id_carrito " +
                                        "JOIN libros l ON dc.id_libro = l.id_libro " +
                                        "WHERE c.id_usuario = ? AND c.estado = 'activo'";
                    pstmt = conn.prepareStatement(sqlCarrito);
                    pstmt.setInt(1, userId);
                    rs = pstmt.executeQuery();
                    
                    StringBuilder emailBody = new StringBuilder();
                    emailBody.append("Gracias por tu compra. Detalles de tu pedido:\n\n");
                    
                    while (rs.next()) {
                        int idLibro = rs.getInt("id_libro");
                        String titulo = rs.getString("titulo");
                        int cantidad = rs.getInt("cantidad");
                        double precio = rs.getDouble("precio");
                        int cantidadDisponible = rs.getInt("cantidad_disponible");
                        
                        double subtotal = cantidad * precio;
                        precioTotal += subtotal;

                        Map<String, Object> item = new HashMap<>();
                        item.put("titulo", titulo);
                        item.put("cantidad", cantidad);
                        item.put("precio", precio);
                        item.put("subtotal", subtotal);
                        items.add(item);

                        emailBody.append(titulo).append(" - Cantidad: ").append(cantidad)
                                 .append(" - Precio: s/").append(precio).append("\n");
                        
                        String sqlUpdateCantidad = "UPDATE libros SET cantidad_disponible = ? WHERE id_libro = ?";
                        PreparedStatement pstmtUpdateCantidad = conn.prepareStatement(sqlUpdateCantidad);
                        pstmtUpdateCantidad.setInt(1, cantidadDisponible - cantidad);
                        pstmtUpdateCantidad.setInt(2, idLibro);
                        pstmtUpdateCantidad.executeUpdate();
                        pstmtUpdateCantidad.close();
                    }
                    
                    String sqlUpdateCarrito = "UPDATE carrito SET estado = 'procesado' WHERE id_usuario = ? AND estado = 'activo'";
                    pstmt = conn.prepareStatement(sqlUpdateCarrito);
                    pstmt.setInt(1, userId);
                    pstmt.executeUpdate();
                    
                    String sqlUsuario = "SELECT email FROM usuarios WHERE id_usuario = ?";
                    pstmt = conn.prepareStatement(sqlUsuario);
                    pstmt.setInt(1, userId);
                    rs = pstmt.executeQuery();
                    
                    if (rs.next()) {
                        String email = rs.getString("email");
                        String subject = "Confirmación de compra - LibrosYA";
                        emailBody.append("\nTotal: s/").append(String.format("%.2f", precioTotal));
                        MailUtil.sendEmail(email, subject, emailBody.toString(), "smtp.gmail.com", "587", "reyes.luisito2002@gmail.com", "uhnv cbkm gcoq jmqz");
                    }
                    
                    purchaseSuccess = true;
                } catch (Exception e) {
                    e.printStackTrace();
                    purchaseSuccess = false;
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            %>
            
            <% if (purchaseSuccess) { %>
                <div class="alert alert-success" role="alert">
                    <i class="fas fa-check-circle"></i>
                    <div>
                        <h4 class="alert-heading">¡Compra realizada con éxito!</h4>
                        <p>Tu pedido ha sido procesado. Hemos enviado un correo electrónico con los detalles de tu compra.</p>
                        <p class="order-number">Número de orden: <%= orderId %></p>
                    </div>
                </div>
                <div class="boucher">
                    <div class="boucher-header text-center">
                        <h6 class="mb-0">Detalle de Compra</h6>
                    </div>
                    <% for (Map<String, Object> item : items) { %>
                        <div class="boucher-item">
                            <span><%= item.get("cantidad") %>x <%= item.get("titulo") %></span>
                            <span>s/<%= String.format("%.2f", (Double)item.get("subtotal")) %></span>
                        </div>
                    <% } %>
                    <div class="boucher-total">
                        <div class="d-flex justify-content-between">
                            <span>Total:</span>
                            <span>s/<%= String.format("%.2f", precioTotal) %></span>
                        </div>
                    </div>
                </div>
            <% } else { %>
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-circle"></i>
                    <div>
                        <h4 class="alert-heading">Error en el proceso de compra</h4>
                        <p>Lo sentimos, ha ocurrido un error al procesar tu compra. Por favor, contacta con nuestro servicio de atención al cliente.</p>
                    </div>
                </div>
            <% } %>
            
            <div class="text-center mt-4">
                <a href="librosDisponibles.jsp" class="btn btn-outline-primary">
                    <i class="fas fa-arrow-left mr-2"></i>Volver al catálogo
                </a>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>