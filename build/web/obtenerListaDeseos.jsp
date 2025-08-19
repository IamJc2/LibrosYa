<%@ page import="java.sql.*, java.util.ArrayList, java.util.List" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
    if (session.getAttribute("user") != null) {
        int id_usuario = (Integer) session.getAttribute("id_usuario");
        List<Integer> listaDeseos = new ArrayList<>();
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
            String sql = "SELECT id_libro FROM listadeseos WHERE id_usuario = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id_usuario);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                listaDeseos.add(rs.getInt("id_libro"));
            }
            
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Convertir la lista a formato JSON manualmente
        StringBuilder jsonBuilder = new StringBuilder("[");
        for (int i = 0; i < listaDeseos.size(); i++) {
            jsonBuilder.append(listaDeseos.get(i));
            if (i < listaDeseos.size() - 1) {
                jsonBuilder.append(",");
            }
        }
        jsonBuilder.append("]");
        
        out.print(jsonBuilder.toString());
    } else {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
    }
%>