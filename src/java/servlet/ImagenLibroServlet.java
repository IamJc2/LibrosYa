package servlet;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/imagenLibro")
public class ImagenLibroServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String isbn = request.getParameter("isbn");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");

            String sql = "SELECT columna_imagen FROM Libros WHERE isbn = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, isbn);
            rs = stmt.executeQuery();

            if (rs.next()) {
                response.setContentType("image/jpeg"); // o "image/png" dependiendo del tipo de imagen
                OutputStream out = response.getOutputStream();
                byte[] imgBytes = rs.getBytes("columna_imagen");
                out.write(imgBytes);
                out.flush();
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND); // Imagen no encontrada
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // Error en el servidor
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (Exception e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
}
