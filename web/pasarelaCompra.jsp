<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pasarela de Pago - LibrosYA</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://www.paypal.com/sdk/js?client-id=AY4sbNw0KQ69I9BttIV4vZ37Q8lqiOEHpVvWFkde2Kv8YjIpfC_Y8dokkC3XRAY0Y5fVRDuCa0XxSKZ-&currency=USD"></script>
    <style>
        body {
            background-color: #f8f9fa;
        }
        .payment-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .book-item {
            border-bottom: 1px solid #eee;
            padding: 10px 0;
        }
    </style>
</head>
<body>
    <div class="container payment-container">
        <h2 class="text-center mb-4">Resumen de Compra</h2>
        
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            double total = 0;
            DecimalFormat df = new DecimalFormat("#.##");
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                
                int userId = (Integer) session.getAttribute("id_usuario");
                String sql = "SELECT l.titulo, l.precio, dc.cantidad " +
                             "FROM detalle_carrito dc " +
                             "JOIN carrito c ON dc.id_carrito = c.id_carrito " +
                             "JOIN libros l ON dc.id_libro = l.id_libro " +
                             "WHERE c.id_usuario = ? AND c.estado = 'activo'";
                             
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    String titulo = rs.getString("titulo");
                    double precio = rs.getDouble("precio");
                    int cantidad = rs.getInt("cantidad");
                    double subtotal = precio * cantidad;
                    total += subtotal;
        %>
        <div class="book-item">
            <p><strong><%= titulo %></strong></p>
            <p>Precio: S/<%= df.format(precio) %> x <%= cantidad %></p>
            <p class="text-right">Subtotal: S/<%= df.format(subtotal) %></p>
        </div>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        %>
        
        <div class="mt-4">
            <h4 class="text-right">Total: S/<%= df.format(total) %></h4>
        </div>
        
        <div id="paypal-button-container" class="mt-4"></div>
    </div>

    <script>
        paypal.Buttons({
            createOrder: function(data, actions) {
                return actions.order.create({
                    purchase_units: [{
                        amount: {
                            value: '<%= df.format(total) %>'
                        }
                    }]
                });
            },
            onApprove: function(data, actions) {
                return actions.order.capture().then(function(details) {
                    alert('Transacción completada por ' + details.payer.name.given_name);
                    // Aquí puedes redirigir a una página de confirmación o actualizar el estado del pedido
                    window.location.href = 'confirmarCompra.jsp?orderId=' + data.orderID;
                });
            }
        }).render('#paypal-button-container');
    </script>
</body>
</html>