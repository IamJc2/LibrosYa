<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    if (session.getAttribute("id_usuario") != null) {
        int id_usuario = (Integer) session.getAttribute("id_usuario");
        int id_libro = Integer.parseInt(request.getParameter("id_libro"));
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
            
            // Actualizar la cantidad en el carrito
            String sql = "UPDATE detalle_carrito dc " +
                         "JOIN carrito c ON dc.id_carrito = c.id_carrito " +
                         "SET dc.cantidad = ? WHERE c.id_usuario = ? AND dc.id_libro = ? AND c.estado = 'activo'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, cantidad);
            ps.setInt(2, id_usuario);
            ps.setInt(3, id_libro);
            ps.executeUpdate();
            
            ps.close();
            conn.close();
            
            // Redirigir al carrito 
            response.sendRedirect("carrito.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    } else {
        response.sendRedirect("login.jsp");
    }
%>
