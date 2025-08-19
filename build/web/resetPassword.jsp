<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restablecer Contraseña - LibrosYA</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            background-color: #dfdfdf;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            font-family: 'Arial', sans-serif;
        }
        .container {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
            height: 100%;
        }
        .reset-card {
            background-color: #ffffff;
            border-radius: 40px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            padding: 5rem;
            max-width: 3000px;
            width: 100%;
            transition: transform 0.3s ease;
        }
        .reset-card:hover {
            transform: translateY(-5px);
        }
        .form-group {
            margin-bottom: 1.5rem;
        }
        .password-strength {
            font-weight: bold;
            font-size: 0.9rem;
            margin-top: 0.5rem;
            transition: color 0.3s ease;
        }
        .password-strength.minima { color: #dc3545; }
        .password-strength.intermedia { color: #ffc107; }
        .password-strength.maxima { color: #28a745; }
        .password-rules {
            font-size: 0.85rem;
            color: #6c757d;
            margin-top: 1rem;
            background-color: #f8f9fa;
            padding: 1rem;
            border-radius: 10px;
        }
        .password-rules ul {
            padding-left: 1.2rem;
            margin-bottom: 0;
        }
        .password-rules li {
            margin-bottom: 0.3rem;
        }
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 123, 255, 0.3);
        }
        .input-group-text {
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .input-group-text:hover {
            background-color: #e9ecef;
        }
        .form-control:focus {
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="reset-card">
            <h2 class="text-center mb-4">Restablecer Contraseña</h2>
            <form method="post" action="resetPasswordAction.jsp">
                <div class="form-group">
                    <label for="newPassword"><i class="fas fa-lock mr-2"></i>Nueva Contraseña:</label>
                    <div class="input-group">
                        <input type="password" class="form-control" id="newPassword" name="newPassword" required oninput="validatePassword()">
                        
                    </div>
                    <small id="passwordStrength" class="password-strength">Seguridad de la contraseña:</small>
                </div>
                <div class="form-group">
                    <label for="confirmPassword"><i class="fas fa-lock mr-2"></i>Confirmar Contraseña:</label>
                    <div class="input-group">
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                        
                    </div>
                </div>
                <input type="hidden" name="resetCode" value="<%= request.getParameter("code") %>">
                <button type="submit" class="btn btn-primary btn-block">Restablecer Contraseña</button>
            </form>

            <div class="password-rules mt-4">
                <h6 class="font-weight-bold">Normas para una Contraseña Segura:</h6>
                <ul>
                    <li>Al menos 8 caracteres</li>
                    <li>Una letra mayúscula</li>
                    <li>Una letra minúscula</li>
                    <li>Un número</li>
                    <li>Un carácter especial (@, #, $, etc.) para seguridad máxima</li>
                </ul>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        function togglePasswordVisibility(id, iconId) {
            var passwordField = document.getElementById(id);
            var toggleIcon = document.getElementById(iconId);
            if (passwordField.type === "password") {
                passwordField.type = "text";
                toggleIcon.classList.remove("fa-eye");
                toggleIcon.classList.add("fa-eye-slash");
            } else {
                passwordField.type = "password";
                toggleIcon.classList.remove("fa-eye-slash");
                toggleIcon.classList.add("fa-eye");
            }
        }

        function validatePassword() {
            var password = document.getElementById("newPassword").value;
            var strengthText = "";
            var strengthClass = "minima";

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
        }
    </script>
</body>
</html>