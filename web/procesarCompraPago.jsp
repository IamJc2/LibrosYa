<%@ page import="java.sql.*, java.util.*, java.text.DecimalFormat" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pago de Compra - LibrosYA</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <script src="https://www.paypal.com/sdk/js?client-id=AY4sbNw0KQ69I9BttIV4vZ37Q8lqiOEHpVvWFkde2Kv8YjIpfC_Y8dokkC3XRAY0Y5fVRDuCa0XxSKZ-&currency=USD"></script>

    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }
        .container {
            max-width: 600px;
            margin: 50px auto;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        h1 {
            color: #007bff;
            margin-bottom: 30px;
        }
        .btn-container {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="text-center"><i class="fas fa-shopping-cart"></i> Pago de Compra</h1>
        
        <%
            // Verificar si el usuario está autenticado
            if (session.getAttribute("user") == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String isbn = request.getParameter("isbn"); // Recuperar ISBN del libro
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            DecimalFormat df = new DecimalFormat("#.##");
            double precio = 0;

            try {
                // Conectar a la base de datos
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");

                // Consulta SQL para obtener los detalles del libro
                String sql = "SELECT titulo, autor, precio FROM libros WHERE isbn = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, isbn); // Asignar ISBN a la consulta
                rs = ps.executeQuery();

                // Verificar si el libro fue encontrado
                if (rs.next()) {
                    String titulo = rs.getString("titulo");
                    String autor = rs.getString("autor");
                    precio = rs.getDouble("precio"); // Obtener el precio del libro
        %>
                    <!-- Mostrar los detalles del libro -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <h5 class="card-title"><%= titulo %></h5>
                            <p class="card-text"><strong>Autor:</strong> <%= autor %></p>
                            <p class="card-text"><strong>ISBN:</strong> <%= isbn %></p>
                            <p class="card-text"><strong>Precio:</strong> S/ <%= df.format(precio) %></p>
                        </div>
                    </div>
                    
                    <!-- Botón de PayPal -->
                    <div id="paypal-button-container"></div>
                    
                    <!-- Botón para volver al catálogo -->
                    <div class="btn-container text-center mt-4">
                        <a href="librosDisponibles.jsp" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Volver al Catálogo
                        </a>
                    </div>

                    <!-- Script para renderizar el botón de PayPal -->
                    <script>
                        paypal.Buttons({
                            createOrder: function(data, actions) {
                                return actions.order.create({
                                    purchase_units: [{
                                        amount: {
                                            value: '<%= df.format(precio) %>' // Enviar el precio correctamente formateado
                                        }
                                    }]
                                });
                            },
                            onApprove: function(data, actions) {
                                return actions.order.capture().then(function(details) {
                                    alert('Transacción completada por ' + details.payer.name.given_name);
                                    // Redirigir a la página de confirmación de compra
                                    window.location.href = 'confirmarCompra.jsp?orderId=' + data.orderID;
                                });
                            },
                            onError: function(err) {
                                console.error('Error en la transacción: ', err);
                                alert('Ocurrió un error durante el proceso de pago. Revisa la consola para más detalles.');
                            }
                        }).render('#paypal-button-container');
                    </script>
        <%
                } else {
        %>
                    <!-- Mostrar mensaje si no se encuentra el libro -->
                    <div class="alert alert-warning" role="alert">
                        <i class="fas fa-exclamation-triangle"></i> No se encontró información del libro.
                    </div>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
        %>
                <!-- Mostrar mensaje de error si ocurre algún problema en la consulta -->
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-circle"></i> Ocurrió un error al procesar la información del libro.
                </div>
        <%
            } finally {
                if (rs != null) rs.close(); // Cerrar el ResultSet
                if (ps != null) ps.close(); // Cerrar el PreparedStatement
                if (conn != null) conn.close(); // Cerrar la conexión
            }
        %>
    </div>

    <!-- Dependencias de Bootstrap y Popper.js -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
