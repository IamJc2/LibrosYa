package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.*;
import java.util.*;
import javax.naming.*;
import javax.sql.*;
import Mail.MailUtil;

public final class actualizarEstadoPrestamo_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html; charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("<!DOCTYPE html>\n");
      out.write("<html lang=\"es\">\n");
      out.write("<head>\n");
      out.write("    <meta charset=\"UTF-8\">\n");
      out.write("    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n");
      out.write("    <title>Actualizar Estado de Préstamo - LibrosYA</title>\n");
      out.write("    <link rel=\"stylesheet\" href=\"https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css\">\n");
      out.write("</head>\n");
      out.write("<body>\n");
      out.write("    <div class=\"container mt-5\">\n");
      out.write("        ");

            // Verificar si el usuario es administrador
            if (session.getAttribute("user") == null || !"administrador".equals(session.getAttribute("rol"))) {
                response.sendRedirect("login.jsp");
                return;
            }

            int id_prestamo = Integer.parseInt(request.getParameter("id_prestamo"));
            String nuevo_estado = request.getParameter("nuevo_estado");

            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

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
                               "Recuerde que tiene un plazo máximo de 2 días hábiles para recojer su pedido. Si no se realiza dentro de este período, el préstamo será rechazado.\n\n" +
                               "Gracias por confiar en nuestro servicio de préstamos.\n" +
                               "Atentamente,\n" +
                               "Equipo de LibrosYA";                 

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
        
      out.write("\n");
      out.write("                <div class=\"alert alert-success\" role=\"alert\">\n");
      out.write("                    <h4 class=\"alert-heading\">¡Actualización Exitosa!</h4>\n");
      out.write("                    <p>El estado del préstamo ha sido actualizado correctamente.</p>\n");
      out.write("                </div>\n");
      out.write("        ");

            } catch (Exception e) {
                e.printStackTrace();
        
      out.write("\n");
      out.write("                <div class=\"alert alert-danger\" role=\"alert\">\n");
      out.write("                    <h4 class=\"alert-heading\">Error en la Actualización</h4>\n");
      out.write("                    <p>Lo sentimos, ha ocurrido un error al actualizar el estado del préstamo. Por favor, intente nuevamente.</p>\n");
      out.write("                </div>\n");
      out.write("        ");

            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        
      out.write("\n");
      out.write("        <a href=\"gestionPrestamos.jsp\" class=\"btn btn-primary\">Volver a Gestión de Préstamos</a>\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("    <script src=\"https://code.jquery.com/jquery-3.5.1.slim.min.js\"></script>\n");
      out.write("    <script src=\"https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js\"></script>\n");
      out.write("    <script src=\"https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js\"></script>\n");
      out.write("</body>\n");
      out.write("</html>\n");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
