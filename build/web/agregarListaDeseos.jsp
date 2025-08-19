<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    if (session.getAttribute("user") != null) {
        int id_usuario = (Integer) session.getAttribute("id_usuario");
        int id_libro = Integer.parseInt(request.getParameter("id_libro"));
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
            
            // Verificar si el libro ya está en la lista de deseos
            String checkSql = "SELECT * FROM listadeseos WHERE id_usuario = ? AND id_libro = ?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, id_usuario);
            checkPs.setInt(2, id_libro);
            ResultSet rs = checkPs.executeQuery();
            
            if (!rs.next()) {
                // Si el libro no está en la lista de deseos, lo agregamos
                String insertSql = "INSERT INTO listadeseos (id_usuario, id_libro) VALUES (?, ?)";
                PreparedStatement insertPs = conn.prepareStatement(insertSql);
                insertPs.setInt(1, id_usuario);
                insertPs.setInt(2, id_libro);
                insertPs.executeUpdate();
                insertPs.close();
            }
            
            rs.close();
            checkPs.close();
            conn.close();
            
            response.sendRedirect("librosDisponibles.jsp");
        } catch (Exception e) {
            out.println("<p>Error al agregar el libro a la lista de deseos: " + e.getMessage() + "</p>");
        }
    } else {
        response.sendRedirect("login.jsp");
    }
%>