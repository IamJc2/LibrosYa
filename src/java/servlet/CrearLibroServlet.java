package servlet;

import java.io.InputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig
@WebServlet("/crearLibro")
public class CrearLibroServlet extends HttpServlet {

    // Remover @Override aquí porque no es necesario
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Configurar el encoding UTF-8 para el request y response
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Obtener los parámetros del formulario
        String titulo = request.getParameter("titulo");
        String autor = request.getParameter("autor");
        String editorial = request.getParameter("editorial");
        int anioPublicacion = Integer.parseInt(request.getParameter("anio_publicacion"));
        String isbn = request.getParameter("isbn");
        String categoria = request.getParameter("categoria");
        int cantidadDisponible = Integer.parseInt(request.getParameter("cantidad_disponible"));
        String resumen = request.getParameter("resumen");
        String biografiaAutor = request.getParameter("biografia_autor");
        double precio = Double.parseDouble(request.getParameter("precio"));

        // Obtener el archivo de imagen
        Part imagenPart = request.getPart("imagen");
        InputStream imagenInputStream = null;
        if (imagenPart != null) {
            imagenInputStream = imagenPart.getInputStream();
        }

        // Conexión a la base de datos
        Connection conn = null;
        PreparedStatement stmt = null;
        String sql = "INSERT INTO Libros (titulo, autor, editorial, anio_publicacion, isbn, categoria, columna_imagen, cantidad_disponible, resumen, biografia_autor, precio) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            // Cargar el driver de MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establecer la conexión a la base de datos
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, titulo);
            stmt.setString(2, autor);
            stmt.setString(3, editorial);
            stmt.setInt(4, anioPublicacion);
            stmt.setString(5, isbn);
            stmt.setString(6, categoria);

            if (imagenInputStream != null) {
                stmt.setBlob(7, imagenInputStream);
            } else {
                stmt.setNull(7, java.sql.Types.BLOB);
            }

            stmt.setInt(8, cantidadDisponible);
            stmt.setString(9, resumen);
            stmt.setString(10, biografiaAutor);
            stmt.setDouble(11, precio);

            stmt.executeUpdate();
            response.sendRedirect("librosDisponibles.jsp");

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().println("Error al crear el libro: " + e.getMessage());
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
