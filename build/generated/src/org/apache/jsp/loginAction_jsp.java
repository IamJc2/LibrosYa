package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.*;
import javax.servlet.http.*;
import javax.servlet.*;
import org.mindrot.jbcrypt.BCrypt;
import java.util.ArrayList;

public final class loginAction_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      response.setContentType("text/html");
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
      out.write("<html>\n");
      out.write("<head>\n");
      out.write("    <meta charset=\"UTF-8\">\n");
      out.write("    <title>Login Action</title>\n");
      out.write("    <link rel=\"stylesheet\" href=\"https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css\">\n");
      out.write("</head>\n");
      out.write("<body>\n");
      out.write("    <div class=\"container\">\n");
      out.write("        ");

            String email = request.getParameter("email");
            String password = request.getParameter("password");

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            if (email != null && password != null) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");

                    // Verificar si el usuario existe
                    String sql = "SELECT * FROM Usuarios WHERE email=?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, email);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        String hashedPassword = rs.getString("contraseña");
                        boolean isVerified = rs.getBoolean("verified");
                        String rol = rs.getString("rol");
                        int id_usuario = rs.getInt("id_usuario");

                        boolean passwordMatch = false;

                        if ("administrador".equals(rol)) {
                            // Para administradores, no usar BCrypt
                            passwordMatch = password.equals(hashedPassword);
                        } else {
                            // Para otros usuarios, verificar la contraseña encriptada
                            passwordMatch = BCrypt.checkpw(password, hashedPassword);
                        }

                        if (passwordMatch) {
                            if (isVerified) {
                                HttpSession userSession = request.getSession();
                                userSession.setAttribute("user", email);
                                userSession.setAttribute("rol", rol);
                                userSession.setAttribute("id_usuario", id_usuario);
                                
                                if ("administrador".equals(rol)) {
                                    response.sendRedirect("admin.jsp");
                                } else {
                                    response.sendRedirect("librosDisponibles.jsp");
                                }
                            } else {
                                out.println("<div class='alert alert-warning mt-4' role='alert'>Tu cuenta no está verificada. Por favor, verifica tu correo electrónico antes de iniciar sesión.</div>");
                            }
                        } else {
                            out.println("<div class='alert alert-danger mt-4' role='alert'>Email o contraseña incorrectos.</div>");
                        }
                    } else {
                        out.println("<div class='alert alert-danger mt-4' role='alert'>Email o contraseña incorrectos.</div>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<div class='alert alert-danger mt-4' role='alert'>Error al iniciar sesión: " + e.getMessage() + "</div>");
                } finally {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                }
            } else {
                out.println("<div class='alert alert-danger mt-4' role='alert'>Falta email o contraseña.</div>");
            }
        
      out.write("\n");
      out.write("        <a href=\"login.jsp\" class=\"btn btn-primary mt-3\">Volver al inicio de sesión</a>\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("    <script src=\"https://code.jquery.com/jquery-3.5.1.slim.min.js\"></script>\n");
      out.write("    <script src=\"https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js\"></script>\n");
      out.write("    <script src=\"https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js\"></script>\n");
      out.write("</body>\n");
      out.write("</html>");
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
