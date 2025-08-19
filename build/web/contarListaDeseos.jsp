<%@ page import="java.sql.*" %>
<%@ page contentType="text/plain; charset=UTF-8" %>
<%
    if (session.getAttribute("user") != null) {
        int id_usuario = (Integer) session.getAttribute("id_usuario");
        int count = 0;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
            String sql = "SELECT COUNT(*) as count FROM listadeseos WHERE id_usuario = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id_usuario);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt("count");
            }
            
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        out.print(count);
    } else {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
    }
%>