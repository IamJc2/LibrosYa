<%@ page import="java.sql.*, java.io.*, java.text.SimpleDateFormat" %>
<%@ page import="com.itextpdf.text.*, com.itextpdf.text.pdf.*" %>
<%@ page contentType="application/pdf" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%
    response.setHeader("Content-Disposition", "inline; filename=\"resumen_compra.pdf\"");
    
    int idCarrito = Integer.parseInt(request.getParameter("id"));
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    Document document = new Document();
    ByteArrayOutputStream baos = new ByteArrayOutputStream();

    try {
        // Configurar el documento PDF
        PdfWriter.getInstance(document, baos);
        document.open();

        // Agregar título
        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
        Paragraph title = new Paragraph("Resumen de Compra - LibrosYA", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);
        document.add(Chunk.NEWLINE);

        // Conexión a la base de datos
        Class.forName("com.mysql.jdbc.Driver");
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

            // Agregar información del carrito
            document.add(new Paragraph("ID Carrito: " + idCarrito));
            document.add(new Paragraph("Usuario: " + nombreUsuario));
            document.add(new Paragraph("Fecha de Creación: " + fechaCreacion));
            document.add(new Paragraph("Estado: " + estado));
            document.add(Chunk.NEWLINE);

            // Crear tabla para los detalles del producto
            PdfPTable table = new PdfPTable(4);
            table.setWidthPercentage(100);
            table.addCell(new PdfPCell(new Phrase("Libro", FontFactory.getFont(FontFactory.HELVETICA_BOLD))));
            table.addCell(new PdfPCell(new Phrase("Cantidad", FontFactory.getFont(FontFactory.HELVETICA_BOLD))));
            table.addCell(new PdfPCell(new Phrase("Precio Unitario", FontFactory.getFont(FontFactory.HELVETICA_BOLD))));
            table.addCell(new PdfPCell(new Phrase("Subtotal", FontFactory.getFont(FontFactory.HELVETICA_BOLD))));

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

                table.addCell(titulo);
                table.addCell(String.valueOf(cantidad));
                table.addCell(String.format("S/. %.2f", precioUnitario));
                table.addCell(String.format("S/. %.2f", subtotal));
            }

            document.add(table);
            document.add(Chunk.NEWLINE);
            document.add(new Paragraph("Total: S/. " + String.format("%.2f", total), FontFactory.getFont(FontFactory.HELVETICA_BOLD)));
        } else {
            document.add(new Paragraph("No se encontró información para el carrito especificado."));
        }
    } catch (Exception e) {
        document.add(new Paragraph("Error al generar el PDF: " + e.getMessage()));
        e.printStackTrace();
    } finally {
        document.close();
        if (rs != null) try { rs.close(); } catch (SQLException e) { }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
        if (conn != null) try { conn.close(); } catch (SQLException e) { }
    }

    // Enviar el PDF al navegador
    response.setContentLength(baos.size());
    OutputStream os = response.getOutputStream();
    baos.writeTo(os);
    os.flush();
    os.close();
%>