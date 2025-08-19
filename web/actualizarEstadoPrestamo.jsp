<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="javax.naming.*, javax.sql.*" %>
<%@ page import="Mail.MailUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Actualizar Estado de Préstamo - LibrosYA</title>
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
            border-radius: 50px;
        }
        .card {
            max-width: 500px;
            width: 100%;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border-radius: 40px;
        }
        .card-title {
            font-size: 1.5rem;
            font-weight: bold;
            border-radius: 30px;
        }
        .alert {
            display: flex;
            align-items: center;
            border-radius: 30px;
        }
        .alert i {
            margin-right: 10px;
            font-size: 1.25rem;
            border-radius: 50px;
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="card-body">
            <h5 class="card-title text-center mb-4">Actualización de Estado de Préstamo</h5>
            <%
                
                if (session.getAttribute("user") == null || !"administrador".equals(session.getAttribute("rol"))) {
                    response.sendRedirect("login.jsp");
                    return;
                }

                int id_prestamo = Integer.parseInt(request.getParameter("id_prestamo"));
                String nuevo_estado = request.getParameter("nuevo_estado");

                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                boolean updateSuccess = false;
                String message = "";

                try {
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                    
                    // Actualizar el estado del préstamo
                    String sql = "UPDATE prestamos SET estado = ? WHERE id_prestamo = ?";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, nuevo_estado);
                    ps.setInt(2, id_prestamo);
                    ps.executeUpdate();

                    // Obtener detalles del préstamo para el correo
                    sql = "SELECT u.email, u.nombre, l.titulo FROM prestamos p " +
                          "JOIN usuarios u ON p.id_usuario = u.id_usuario " +
                          "JOIN libros l ON p.id_libro = l.id_libro " +
                          "WHERE p.id_prestamo = ?";
                    ps = conn.prepareStatement(sql);
                    ps.setInt(1, id_prestamo);
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        String email = rs.getString("email");
                        String nombre = rs.getString("nombre");
                        String titulo = rs.getString("titulo");

                        // Construir mensaje personalizado
                        String subject = "Actualización de Estado de Préstamo - LibrosYA";
                        String body;

                        if ("aprobado".equalsIgnoreCase(nuevo_estado)) {
                            body = "Estimado/a " + nombre + ",\n\n" +
                                   "Nos complace informarle que el estado de su préstamo para el libro '" + titulo + "' ha sido actualizado a 'Aprobado'.\n\n" +
                                   "Por favor, realice el pago de su préstamo de manera presencial en nuestras instalaciones.\n\n" +
                                   "Si tiene alguna pregunta o necesita más información, no dude en contactarnos al número 985619341.\n\n" +
                                   "Recuerde que tiene un plazo máximo de 2 días hábiles para recoger su pedido. Si no se realiza dentro de este período, el préstamo será rechazado.\n\n" +
                                   "Gracias por confiar en nuestro servicio de préstamos.\n" +
                                   "Atentamente,\n" +
                                   "Equipo de LibrosYA";
                            
                        } else if ("devuelto".equalsIgnoreCase(nuevo_estado)) {
                            body = "Estimado/a " + nombre + ",\n\n" +
                                   "Gracias por devolver el libro '" + titulo + "'.\n" +
                                   "Cualquier consulta adicional puede comunicarse al número 985619341.\n\n" +
                                   "Gracias por confiar en LibrosYA.\nAtentamente,\nEquipo de LibrosYA";
                        } else {
                            body = "Estimado/a " + nombre + ",\n\n" +
                                   "El estado de su préstamo para el libro '" + titulo + "' ha sido actualizado a '" + nuevo_estado + "'.\n\n" +
                                   "Si tiene alguna pregunta, por favor contáctenos al 985619341.\n\n" +
                                   "Gracias por usar nuestro servicio de préstamos.\n" +
                                   "Equipo de LibrosYA";
                        }

                        // Enviar correo electrónico
                        MailUtil.sendEmail(email, subject, body, "smtp.gmail.com", "587", "reyes.luisito2002@gmail.com", "uhnv cbkm gcoq jmqz");
                    }

                    updateSuccess = true;
                    message = "El estado del préstamo ha sido actualizado correctamente.";
                } catch (Exception e) {
                    e.printStackTrace();
                    message = "Lo sentimos, ha ocurrido un error al actualizar el estado del préstamo. Por favor, intente nuevamente.";
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
            %>
            <div class="alert alert-<%= updateSuccess ? "success" : "danger" %>" role="alert">
                <i class="fas fa-<%= updateSuccess ? "check-circle" : "exclamation-circle" %>"></i>
                <div>
                    <h4 class="alert-heading"><%= updateSuccess ? "¡Actualización Exitosa!" : "Error en la Actualización" %></h4>
                    <p><%= message %></p>
                </div>
            </div>
            <div class="text-center mt-4">
                <a href="gestionPrestamos.jsp" class="btn btn-outline-primary">
                    <i class="fas fa-arrow-left mr-2"></i>Volver a Gestión de Préstamos
                </a>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>