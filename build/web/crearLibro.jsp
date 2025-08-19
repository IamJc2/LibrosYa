<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Libro - Panel de Administración</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .sidebar {
            min-height: 100vh;
            background-color: #343a40;
            padding-top: 20px;
            position: fixed;
            top: 0;
            left: 0;
            width: 250px;
            z-index: 100;
        }
        .sidebar a {
            color: #ffffff;
            padding: 10px 15px;
            display: block;
            transition: all 0.3s;
        }
        .sidebar a:hover {
            background-color: #495057;
            text-decoration: none;
        }
        .content {
            margin-left: 250px;
            padding: 20px;
        }
        .profile-image {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            margin: 0 auto 20px;
            background-color: #6c757d;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            color: white;
        }
        .logout-btn {
            position: fixed;
            bottom: 20px;
            left: 15px;
            width: 220px;
            z-index: 1000;
        }
        .main-title {
            font-size: 2rem;
            font-weight: 700;
            color: #343a40;
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #007bff;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }
        .form-control {
            border-radius: 10px;
        }
        .btn-icon {
            padding: 0.375rem 0.75rem;
        }
        #successMessage, #errorMessage {
            display: none;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-2 d-none d-md-block sidebar">
                <div class="sidebar-sticky">
                    <div class="profile-image">
                        <i class="fas fa-user"></i>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="admin.jsp">
                                <i class="fas fa-users mr-2"></i> Gestión de Usuarios
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="crearLibro.jsp">
                                <i class="fas fa-book mr-2"></i> Agregar Libros
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="listarLibros.jsp">
                                <i class="fas fa-list mr-2"></i> Listar Libros
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="gestionPrestamos.jsp">
                                <i class="fas fa-book-reader mr-2"></i> Gestión de Préstamos
                            </a>
                        </li>
                        <li class="nav-item">
                        <a class="nav-link" href="gestionCompras.jsp">
                            <i class="fas fa-shopping-cart mr-2"></i> Gestión de Compras
                        </a>
                    </li>
                    </ul>
                </div>
            </nav>

            <!-- Contenido principal -->
            <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4 content">
                <h1 class="main-title"><i class="fas fa-book mr-2"></i>Crear Nuevo Libro</h1>

                <div class="card shadow-sm">
                    <div class="card-body">
                        <!-- Formulario con accept-charset UTF-8 -->
                        <form id="crearLibroForm" action="crearLibro" method="post" enctype="multipart/form-data" accept-charset="UTF-8">
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="titulo"><i class="fas fa-heading mr-2"></i>Título:</label>
                                    <input type="text" class="form-control" id="titulo" name="titulo" required>
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="autor"><i class="fas fa-user-edit mr-2"></i>Autor:</label>
                                    <input type="text" class="form-control" id="autor" name="autor" required>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-4">
                                    <label for="editorial"><i class="fas fa-building mr-2"></i>Editorial:</label>
                                    <input type="text" class="form-control" id="editorial" name="editorial">
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="anio_publicacion"><i class="fas fa-calendar-alt mr-2"></i>Año de Publicación:</label>
                                    <input type="number" class="form-control" id="anio_publicacion" name="anio_publicacion">
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="isbn"><i class="fas fa-barcode mr-2"></i>ISBN:</label>
                                    <input type="text" class="form-control" id="isbn" name="isbn">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="categoria"><i class="fas fa-tags mr-2"></i>Categoría:</label>
                                    <input type="text" class="form-control" id="categoria" name="categoria">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="imagen"><i class="fas fa-image mr-2"></i>Imagen del Libro:</label>
                                    <div class="custom-file">
                                        <input type="file" class="custom-file-input" id="imagen" name="imagen">
                                        <label class="custom-file-label" for="imagen">Elegir archivo</label>
                                    </div>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="cantidad_disponible"><i class="fas fa-cubes mr-2"></i>Cantidad Disponible:</label>
                                    <input type="number" class="form-control" id="cantidad_disponible" name="cantidad_disponible" required>
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="precio"><i class="fas fa-dollar-sign mr-2"></i>Precio:</label>
                                    <input type="number" step="0.01" class="form-control" id="precio" name="precio">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="resumen"><i class="fas fa-file-alt mr-2"></i>Resumen:</label>
                                <textarea class="form-control" id="resumen" name="resumen" rows="3"></textarea>
                            </div>
                            <div class="form-group">
                                <label for="biografia_autor"><i class="fas fa-user-circle mr-2"></i>Biografía del Autor:</label>
                                <textarea class="form-control" id="biografia_autor" name="biografia_autor" rows="3"></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary btn-block"><i class="fas fa-plus-circle mr-2"></i>Crear Libro</button>
                        </form>
                        <div id="successMessage" class="alert alert-success mt-3" role="alert">
                            <i class="fas fa-check-circle mr-2"></i>Libro creado exitosamente.
                        </div>
                        <div id="errorMessage" class="alert alert-danger mt-3" role="alert">
                            <i class="fas fa-exclamation-circle mr-2"></i>Error al crear el libro. Por favor, intente nuevamente.
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <a href="login.jsp" class="btn btn-danger btn-block logout-btn">
        <i class="fas fa-sign-out-alt mr-2"></i> Cerrar Sesión
    </a>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#crearLibroForm').on('submit', function(e) {
                e.preventDefault();
                
                var formData = new FormData(this);

                $.ajax({
                    url: 'crearLibro',
                    type: 'POST',
                    data: formData,
                    success: function(response) {
                        $('#successMessage').fadeIn().delay(3000).fadeOut();
                        $('#crearLibroForm')[0].reset();
                        $('.custom-file-label').html('Elegir archivo');
                    },
                    error: function(xhr, status, error) {
                        $('#errorMessage').fadeIn().delay(3000).fadeOut();
                    },
                    cache: false,
                    contentType: false,
                    processData: false
                });
            });

            $('.custom-file-input').on('change', function() {
                var fileName = $(this).val().split('\\').pop();
                $(this).next('.custom-file-label').html(fileName);
            });
        });
        
    </script>
</body>
</html>
