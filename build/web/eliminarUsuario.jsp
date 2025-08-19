<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Eliminar Usuario</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card mt-5">
                    <div class="card-header text-center">
                        <h4>Eliminar Usuario</h4>
                    </div>
                    <div class="card-body">
                        <%
                            int id = Integer.parseInt(request.getParameter("id"));
                            Connection conn = null;
                            PreparedStatement pstmt = null;

                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librosya", "root", "123456");
                                String sql = "DELETE FROM Usuarios WHERE id_usuario=?";
                                pstmt = conn.prepareStatement(sql);
                                pstmt.setInt(1, id);
                                pstmt.executeUpdate();
                                out.println("<p class='text-success text-center'>Usuario eliminado con éxito.</p>");
                            } catch (Exception e) {
                                e.printStackTrace();
                                out.println("<p class='text-danger text-center'>Error al eliminar usuario.</p>");
                            } finally {
                                if (pstmt != null) pstmt.close();
                                if (conn != null) conn.close();
                            }
                        %>
                        <div class="text-center">
                            <a href="admin.jsp" class="btn btn-primary mt-3">Volver a la lista de usuarios</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
