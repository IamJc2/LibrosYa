<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Recuperar Contrase�a</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h2 class="my-4">Recuperar Contrase�a</h2>
        <form method="post" action="sendResetLink.jsp">
            <div class="form-group">
                <label for="email">Ingresa tu correo electr�nico:</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <button type="submit" class="btn btn-primary">Enviar enlace de recuperaci�n</button>
        </form>
        <p class="mt-3">�Recordaste tu contrase�a? <a href="login.jsp">Inicia sesi�n aqu�</a></p>
    </div>
</body>
</html>
