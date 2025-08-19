<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle de Carrito - LibrosYA</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .card { border: none; border-radius: 15px; box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15); }
        .main-title { font-size: 2rem; font-weight: 700; color: #343a40; margin-bottom: 1.5rem; padding-bottom: 0.5rem; border-bottom: 2px solid #007bff; }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h1 class="main-title"><i class="fas fa-shopping-cart mr-2"></i>Detalle de Carrito</h1>
        
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <%
                    int idCarrito = Integer.parseInt(request.getParameter("id"));
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                        
                        // Obtener información del carrito
                        String sqlCarrito = "SELECT c.id_carrito, c.fecha_creacion, c.estado, u.nombre, u.apellido " +
                                            "FROM carrito c JOIN usuarios u ON c.id_usuario = u.id_usuario " +
                                            "WHERE c.id_carrito = ?";
                        pstmt = conn.prepareStatement(sqlCarrito);
                        pstmt.setInt(1, idCarrito);
                        rs = pstmt.executeQuery();
                        
                        if (rs.next()) {
                            String nombreUsuario = rs.getString("nombre") + " " + rs.getString("apellido");
                            String fechaCreacion = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(rs.getTimestamp("fecha_creacion"));
                            String estado = rs.getString("estado");
                %>
                <h5 class="card-title">Información del Carrito</h5>
                <p><strong>ID Carrito:</strong> <%= idCarrito %></p>
                <p><strong>Usuario:</strong> <%= nombreUsuario %></p>
                <p><strong>Fecha de Creación:</strong> <%= fechaCreacion %></p>
                <p><strong>Estado:</strong> <%= estado %></p>
                
                <h5 class="card-title mt-4">Detalle de Productos</h5>
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Libro</th>
                                <th>Cantidad</th>
                                <th>Precio Unitario</th>
                                <th>Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                // Obtener detalles del carrito
                                String sqlDetalle = "SELECT l.titulo, dc.cantidad, dc.precio_unitario " +
                                                    "FROM detalle_carrito dc JOIN libros l ON dc.id_libro = l.id_libro " +
                                                    "WHERE dc.id_carrito = ?";
                                pstmt = conn.prepareStatement(sqlDetalle);
                                pstmt.setInt(1, idCarrito);
                                rs = pstmt.executeQuery();
                                
                                double total = 0;
                                while (rs.next()) {
                                    String titulo = rs.getString("titulo");
                                    int cantidad = rs.getInt("cantidad");
                                    double precioUnitario = rs.getDouble("precio_unitario");
                                    double subtotal = cantidad * precioUnitario;
                                    total += subtotal;
                            %>
                            <tr>
                                <td><%= titulo %></td>
                                <td><%= cantidad %></td>
                                <td>S/. <%= String.format("%.2f", precioUnitario) %></td>
                                <td>S/. <%= String.format("%.2f", subtotal) %></td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                        <tfoot>
                            <tr>
                                <th colspan="3" class="text-right">Total:</th>
                                <th>S/. <%= String.format("%.2f", total) %></th>
                            </tr>
                        </tfoot>
                    </table>
                </div>
                
                <div class="mt-4">
                    <a href="gestionCompras.jsp" class="btn btn-secondary mr-2">
                        <i class="fas fa-arrow-left mr-2"></i>Volver
                    </a>
                    <a href="generarPDF.jsp?id=<%= idCarrito %>" class="btn btn-primary" target="_blank">
                        <i class="fas fa-print mr-2"></i>Imprimir PDF
                    </a>
                </div>
                <%
                        } else {
                %>
                <p class="text-danger">No se encontró el carrito especificado.</p>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                <p class="text-danger">Error al cargar los datos: <%= e.getMessage() %></p>
                <%
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { }
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { }
                    }
                %>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>