package servlet;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/listarLibros")
public class ListarLibrosServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        ArrayList<Libro> libros = new ArrayList<>();
        
        String url = "jdbc:mysql://localhost:3306/librosya";
        String user = "root";
        String password = "123456";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, password)) {
                String sql = "SELECT * FROM Libros";
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();
                
                while (rs.next()) {
                    int idLibro = rs.getInt("id_libro");
                    String titulo = rs.getString("titulo");
                    String autor = rs.getString("autor");
                    String isbn = rs.getString("isbn");
                    // Agregar otros campos si es necesario
                    
                    Libro libro = new Libro(idLibro, titulo, autor, isbn);
                    libros.add(libro);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.setAttribute("libros", libros);
        request.getRequestDispatcher("listarLibros.jsp").forward(request, response);
    }
}

// Clase Libro
class Libro {
    private int idLibro;
    private String titulo;
    private String autor;
    private String isbn;
    
    public Libro(int idLibro, String titulo, String autor, String isbn) {
        this.idLibro = idLibro;
        this.titulo = titulo;
        this.autor = autor;
        this.isbn = isbn;
    }
    
    // Getters
    public int getIdLibro() { return idLibro; }
    public String getTitulo() { return titulo; }
    public String getAutor() { return autor; }
    public String getIsbn() { return isbn; }
}
