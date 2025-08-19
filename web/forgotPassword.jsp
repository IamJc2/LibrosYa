<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Recuperar Contraseña</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h2 class="my-4">Recuperar Contraseña</h2>
        <form method="post" action="sendResetLink.jsp">
            <div class="form-group">
                <label for="email">Ingresa tu correo electrónico:</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <button type="submit" class="btn btn-primary">Enviar enlace de recuperación</button>
        </form>
        <p class="mt-3">¿Recordaste tu contraseña? <a href="login.jsp">Inicia sesión aquí</a></p>
    </div>
</body>
</html>
