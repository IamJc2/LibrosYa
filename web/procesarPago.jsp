<%@ page import="java.sql.*, javax.mail.*, javax.mail.internet.*, java.util.Properties" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Procesar Pago - LibrosYA</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
        }
        .payment-container {
            max-width: 500px;
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
            <h2 class="text-center mb-4">Detalles de Pago</h2>
            <%
                String isbn = request.getParameter("isbn");
                String titulo = request.getParameter("titulo");
                String precio = request.getParameter("precio");
                
                if (request.getMethod().equalsIgnoreCase("post")) {
                    // Simular procesamiento de pago
                    boolean pagoExitoso = true; // En un escenario real, aquí iría la lógica de procesamiento del pago
                    
                    if (pagoExitoso) {
                        // Actualizar la base de datos (simular venta)
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                            String sql = "UPDATE Libros SET cantidad_disponible = cantidad_disponible - 1 WHERE isbn = ?";
                            PreparedStatement ps = conn.prepareStatement(sql);
                            ps.setString(1, isbn);
                            ps.executeUpdate();
                            ps.close();
                            conn.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        
                        // Enviar correo electrónico
                        String to = (String) session.getAttribute("user");
                        String from = "noreply@librosya.com";
                        String host = "localhost";
                        Properties properties = System.getProperties();
                        properties.setProperty("mail.smtp.host", host);
                        Session mailSession = Session.getDefaultInstance(properties);
                        
                        try {
                            MimeMessage message = new MimeMessage(mailSession);
                            message.setFrom(new InternetAddress(from));
                            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
                            message.setSubject("Confirmación de compra - LibrosYA");
                            message.setText("Gracias por tu compra. Has adquirido el libro '" + titulo + "' por S/ " + precio + ".");
                            Transport.send(message);
                        } catch (MessagingException mex) {
                            mex.printStackTrace();
                        }
            %>
                        <div class="alert alert-success" role="alert">
                            <h4 class="alert-heading">¡Pago Exitoso!</h4>
                            <p>Tu compra se ha procesado correctamente. Hemos enviado un correo de confirmación a tu dirección de email.</p>
                        </div>
                        <a href="librosDisponibles.jsp" class="btn btn-primary btn-block">Volver al Catálogo</a>
            <%
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
            %>
                <form action="procesarPago.jsp" method="post">
                    <input type="hidden" name="isbn" value="<%= isbn %>">
                    <input type="hidden" name="titulo" value="<%= titulo %>">
                    <input type="hidden" name="precio" value="<%= precio %>">
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
                    <button type="submit" class="btn btn-pay btn-block">Pagar S/ <%= precio %></button>
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