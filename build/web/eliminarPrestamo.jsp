<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    int idPrestamo = Integer.parseInt(request.getParameter("id_prestamo"));
    Connection conn = null;
    PreparedStatement ps = null;

    try {
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
        String sql = "DELETE FROM prestamos WHERE id_prestamo = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, idPrestamo);
        int rowsAffected = ps.executeUpdate();

        if (rowsAffected > 0) {
            response.sendRedirect("gestionPrestamos.jsp?msg=El préstamo ha sido eliminado correctamente.");
        } else {
            response.sendRedirect("gestionPrestamos.jsp?msg=No se encontró el préstamo para eliminar.");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("gestionPrestamos.jsp?msg=Ocurrió un error al intentar eliminar el préstamo.");
    } finally {
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
