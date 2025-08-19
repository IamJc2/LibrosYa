<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    if (session.getAttribute("user") != null) {
        int id_usuario = (Integer) session.getAttribute("id_usuario");
        int id_libro = Integer.parseInt(request.getParameter("id_libro"));
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
            String sql = "DELETE FROM listadeseos WHERE id_usuario = ? AND id_libro = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id_usuario);
            ps.setInt(2, id_libro);
            ps.executeUpdate();
            ps.close();
            conn.close();
            out.print("success");
        } catch (Exception e) {
            out.print("error: " + e.getMessage());
        }
    } else {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
    }
%>
