package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.*;
import java.util.*;
import Mail.MailUtil;

public final class confirmarCompra_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      out.write("<!DOCTYPE html>\n");
      out.write("<html lang=\"es\">\n");
      out.write("<head>\n");
      out.write("    <meta charset=\"UTF-8\">\n");
      out.write("    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n");
      out.write("    <title>Confirmación de Compra - LibrosYA</title>\n");
      out.write("    <link rel=\"stylesheet\" href=\"https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css\">\n");
      out.write("</head>\n");
      out.write("<body>\n");
      out.write("    <div class=\"container mt-5\">\n");
      out.write("        <h2 class=\"text-center mb-4\">Confirmación de Compra</h2>\n");
      out.write("        \n");
      out.write("        ");

            String orderId = request.getParameter("orderId");
            int userId = (Integer) session.getAttribute("id_usuario");
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                
                // Obtener detalles del carrito
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
                
                // Actualizar cantidad disponible por cada libro en el carrito
                while (rs.next()) {
                    int idLibro = rs.getInt("id_libro");
                    String titulo = rs.getString("titulo");
                    int cantidad = rs.getInt("cantidad");
                    double precio = rs.getDouble("precio");
                    int cantidadDisponible = rs.getInt("cantidad_disponible");
                    
                    emailBody.append(titulo).append(" - Cantidad: ").append(cantidad).append(" - Precio: s/").append(precio).append("\n");
                    
                    // Actualizar cantidad disponible en la tabla 'libros'
                    String sqlUpdateCantidad = "UPDATE libros SET cantidad_disponible = ? WHERE id_libro = ?";
                    PreparedStatement pstmtUpdateCantidad = conn.prepareStatement(sqlUpdateCantidad);
                    pstmtUpdateCantidad.setInt(1, cantidadDisponible - cantidad); // Restar la cantidad comprada
                    pstmtUpdateCantidad.setInt(2, idLibro);
                    pstmtUpdateCantidad.executeUpdate();
                    pstmtUpdateCantidad.close();
                }
                
                // Actualizar estado del carrito
                String sqlUpdateCarrito = "UPDATE carrito SET estado = 'procesado' WHERE id_usuario = ? AND estado = 'activo'";
                pstmt = conn.prepareStatement(sqlUpdateCarrito);
                pstmt.setInt(1, userId);
                pstmt.executeUpdate();
                
                // Obtener email del usuario
                String sqlUsuario = "SELECT email FROM usuarios WHERE id_usuario = ?";
                pstmt = conn.prepareStatement(sqlUsuario);
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    String email = rs.getString("email");
                    String subject = "Confirmación de compra - LibrosYA";
                    MailUtil.sendEmail(email, subject, emailBody.toString(), "smtp.gmail.com", "587", "reyes.luisito2002@gmail.com", "uhnv cbkm gcoq jmqz");
                }
        
      out.write("\n");
      out.write("        <div class=\"alert alert-success\" role=\"alert\">\n");
      out.write("            <h4 class=\"alert-heading\">¡Compra realizada con éxito!</h4>\n");
      out.write("            <p>Tu pedido ha sido procesado. Hemos enviado un correo electrónico con los detalles de tu compra.</p>\n");
      out.write("            <hr>\n");
      out.write("            <p class=\"mb-0\">Número de orden: ");
      out.print( orderId );
      out.write("</p>\n");
      out.write("        </div>\n");
      out.write("        <a href=\"librosDisponibles.jsp\" class=\"btn btn-primary\">Volver al catálogo</a>\n");
      out.write("        ");

            } catch (Exception e) {
                e.printStackTrace();
        
      out.write("\n");
      out.write("        <div class=\"alert alert-danger\" role=\"alert\">\n");
      out.write("            <h4 class=\"alert-heading\">Error en el proceso de compra</h4>\n");
      out.write("            <p>Lo sentimos, ha ocurrido un error al procesar tu compra. Por favor, contacta con nuestro servicio de atención al cliente.</p>\n");
      out.write("        </div>\n");
      out.write("        ");

            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        
      out.write("\n");
      out.write("    </div>\n");
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
