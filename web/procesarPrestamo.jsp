<%@ page import="java.sql.*, java.util.*, java.time.LocalDate" %>
<%@ page import="javax.naming.*, javax.sql.*, java.text.SimpleDateFormat" %>
<%@ page import="Mail.MailUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Procesar Préstamo - LibrosYA</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
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
        h1, h4 {
            color: #007bff;
        }
        .alert {
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .btn-container {
            margin-top: 20px;
            text-align: center;
        }
        .btn {
            margin: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="text-center mb-4"><i class="fas fa-book-reader"></i> Procesar Préstamo</h1>
        <%
            if (session.getAttribute("user") == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            int id_usuario = (Integer) session.getAttribute("id_usuario");
            int id_libro = Integer.parseInt(request.getParameter("id_libro"));
            String fechaPrestamo = request.getParameter("fechaPrestamo");
            String fechaDevolucion = request.getParameter("fechaDevolucion");
            double costoPrestamo = Double.parseDouble(request.getParameter("costo_prestamo"));

            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            boolean prestamoExitoso = false;

            try {
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                
                // Insertar el préstamo en la base de datos
                String sql = "INSERT INTO prestamos (id_usuario, id_libro, fecha_prestamo, fecha_devolucion, estado) VALUES (?, ?, ?, ?, 'pendiente')";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, id_usuario);
                ps.setInt(2, id_libro);
                ps.setString(3, fechaPrestamo);
                ps.setString(4, fechaDevolucion);
                ps.executeUpdate();

                // Obtener detalles del libro y usuario para el correo
                sql = "SELECT l.titulo, u.email, u.nombre FROM Libros l JOIN usuarios u ON u.id_usuario = ? WHERE l.id_libro = ?";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, id_usuario);
                ps.setInt(2, id_libro);
                rs = ps.executeQuery();

                if (rs.next()) {
                    String titulo = rs.getString("titulo");
                    String email = rs.getString("email");
                    String nombre = rs.getString("nombre");

                    // Enviar correo electrónico
                    String subject = "Solicitud de Préstamo - LibrosYA";
                    String body = "Estimado/a " + nombre + ",\n\n" +
                                  "Su solicitud de préstamo para el libro '" + titulo + "' ha sido recibida.\n" +
                                  "Detalles del préstamo:\n" +
                                  "Fecha de préstamo: " + fechaPrestamo + "\n" +
                                  "Fecha de devolución: " + fechaDevolucion + "\n" +
                                  "Costo del préstamo: S/ " + String.format("%.2f", costoPrestamo) + "\n\n" +
                                  "El estado de su solicitud es 'pendiente'. Le notificaremos cuando sea aprobada.\n\n" +
                                  "Gracias por usar nuestro servicio de préstamos.\n" +
                                  "Equipo de LibrosYA";

                    MailUtil.sendEmail(email, subject, body, "smtp.gmail.com", "587", "reyes.luisito2002@gmail.com", "uhnv cbkm gcoq jmqz");
                    prestamoExitoso = true;
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }

            if (prestamoExitoso) {
        %>
                <div class="alert alert-success" role="alert">
                    <h4 class="alert-heading"><i class="fas fa-check-circle"></i> ¡Solicitud de Préstamo Exitosa!</h4>
                    <p>Su solicitud de préstamo ha sido registrada. Hemos enviado un correo de confirmación a su dirección de email.</p>
                </div>
                <div class="btn-container">
                    
                    <a href="librosDisponibles.jsp" class="btn btn-secondary">
                        <i class="fas fa-book"></i> Volver al Catálogo
                    </a>
                </div>
        <%
            } else {
        %>
                <div class="alert alert-danger" role="alert">
                    <h4 class="alert-heading"><i class="fas fa-exclamation-triangle"></i> Error en el Proceso</h4>
                    <p>Lo sentimos, ha ocurrido un error al procesar su solicitud de préstamo. Por favor, intente nuevamente más tarde.</p>
                </div>
                <div class="btn-container">
                    <button onclick="history.back()" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Volver e Intentar de Nuevo
                    </button>
                </div>
        <%
            }
        %>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>