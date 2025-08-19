<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar Usuario</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            background-image: url('images/fondologin.png');
            background-size: cover;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }
        .register-container {
            position: absolute;
            top: 50%;
            right: 450px;
            transform: translateY(-50%);
            width: 100%;
            max-width: 800px;
            padding: 80px;
            border: rgba(255, 255, 255, 0.7);
            border-radius: 50px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            background: rgba(255, 255, 255, 0.7);
            display: flex;
            align-items: center;
            gap: 100px;
        }
        .register-image {
            max-width: 40%;
            height: auto;
            border-radius: 20px;
        }
        .register-form {
            flex: 1;
        }
        .btn-primary {
            background: linear-gradient(45deg, #007bff, #0056b3);
            border: none;
            color: #ffffff;
            font-size: 16px;
            padding: 10px 20px;
            border-radius: 25px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            transition: background 0.3s, box-shadow 0.3s;
        }
        .btn-primary:hover {
            background: linear-gradient(45deg, #0056b3, #003d7a);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.3);
        }
        .password-strength {
            font-weight: bold;
            font-size: 0.95rem;
        }
        .password-strength.minima {
            color: red;
        }
        .password-strength.intermedia {
            color: orangered;
        }
        .password-strength.maxima {
            color: green;
        }
    </style>
</head>
<body>
    <script>
        function validatePassword() {
            var password = document.getElementById("password").value;
            var strengthText = "";
            var strengthClass = "minima"; // Clase por defecto para seguridad mínima

            if (password.length >= 8) {
                if (password.match(/^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@#$%^&+=!]).+$/)) {
                    strengthText = "Seguridad máxima";
                    strengthClass = "maxima";
                } else if (password.match(/^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).+$/)) {
                    strengthText = "Seguridad intermedia";
                    strengthClass = "intermedia";
                } else {
                    strengthText = "Seguridad mínima";
                }
            } else {
                strengthText = "Seguridad mínima";
            }

            var strengthElement = document.getElementById("passwordStrength");
            strengthElement.innerText = "Seguridad de la contraseña: " + strengthText;
            strengthElement.className = "password-strength " + strengthClass;

            return strengthClass; // Devolvemos la clase para verificarla más tarde
        }

        function handleFormSubmission(event) {
            var passwordStrength = validatePassword();

            if (passwordStrength === "minima") {
                event.preventDefault(); // Evitar el envío del formulario

                // Limpiar los campos del formulario
                document.getElementById("nombre").value = "";
                document.getElementById("apellido").value = "";
                document.getElementById("email").value = "";
                document.getElementById("password").value = "";
                document.getElementById("passwordStrength").innerText = "Seguridad de la contraseña:";

                // Mostrar SweetAlert2
                Swal.fire({
                    icon: 'error',
                    title: 'Contraseña débil',
                    text: 'Por favor, elige una contraseña más segura.',
                    confirmButtonText: 'Aceptar'
                });
            }
        }
    </script>

    <div class="container">
        <div class="register-container">
            <img src="images/registro.png" alt="Descripción de la Imagen" class="register-image">
            <div class="register-form">
                <h2 class="text-center">Registrar Usuario</h2>
                <form method="post" action="registerAction.jsp" onsubmit="handleFormSubmission(event)">
                    <div class="form-group">
                        <label for="nombre">Nombre:</label>
                        <input type="text" class="form-control" id="nombre" name="nombre" required>
                    </div>
                    <div class="form-group">
                        <label for="apellido">Apellido:</label>
                        <input type="text" class="form-control" id="apellido" name="apellido" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Contraseña:</label>
                        <input type="password" class="form-control" id="password" name="contraseña" required oninput="validatePassword()">
                        <small id="passwordStrength" class="password-strength">Seguridad de la contraseña:</small>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">Registrar</button>
                </form>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
