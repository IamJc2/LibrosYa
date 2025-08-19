<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro Exitoso</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    
    <style>
        body {
            background: #dfdfdf;
            background-size: 11px 11px;
            display: grid;
            justify-content: center;
            min-height: 100vh;
            align-items: center;
            height: 100vh;
            margin: 0;
            
        }
        .success-card {
            background-color: #ffffff;
            border-radius: 90px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            padding: 2.5rem;
            max-width: 400px;
            width: 400px;
            transition: transform 0.3s ease;
            text-align: center;
            
        }
        .success-icon {
            font-size: 4rem;
            color: #28a745;
            margin-bottom: 2rem;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="success-card">
            <i class="fas fa-check-circle success-icon"></i>
            <h2 class="mb-4">Registro Exitoso</h2>
            <p class="mb-4">¡Te has registrado exitosamente! Por favor, revisa tu correo electrónico para activar tu cuenta.</p>
            
            
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>