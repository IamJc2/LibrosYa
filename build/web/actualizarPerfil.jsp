<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    if (session.getAttribute("user") != null) {
        int id_usuario = (Integer) session.getAttribute("id_usuario");
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String email = request.getParameter("email");
        String nuevaContraseña = request.getParameter("nueva_contraseña");
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
            
            String sql = "UPDATE Usuarios SET nombre = ?, apellido = ?, email = ? WHERE id_usuario = ?";
            if (nuevaContraseña != null && !nuevaContraseña.isEmpty()) {
                sql = "UPDATE Usuarios SET nombre = ?, apellido = ?, email = ?, contraseña = ? WHERE id_usuario = ?";
            }
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, nombre);
            ps.setString(2, apellido);
            ps.setString(3, email);
            
            if (nuevaContraseña != null && !nuevaContraseña.isEmpty()) {
                ps.setString(4, nuevaContraseña); 
                ps.setInt(5, id_usuario);
            } else {
                ps.setInt(4, id_usuario);
            }
            
            ps.executeUpdate();
            
            ps.close();
            conn.close();
            
            response.sendRedirect("perfil.jsp?actualizado=true");
        } catch (Exception e) {
            out.println("<p>Error al actualizar el perfil: " + e.getMessage() + "</p>");
        }
    } else {
        response.sendRedirect("login.jsp");
    }
%>