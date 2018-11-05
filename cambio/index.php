<?php
session_start();

if(isset($_SESSION['idUsuario'])){
    header("Location: Gestion/vista/Menu/menu.php");
}
?><!DOCTYPE html>
<html lang="es">
<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
   <meta name="description" content="Sistema">
   <meta name="keywords" content="app, responsive, jquery, bootstrap, dashboard, admin">
   <title>Sistema</title>
   <!-- =============== VENDOR STYLES ===============-->
   <!-- FONT AWESOME-->
   <link rel="stylesheet" href="vendor/font-awesome/css/fontawesome.min.css">
   <!-- SIMPLE LINE ICONS-->
   <link rel="stylesheet" href="vendor/simple-line-icons/css/simple-line-icons.css">
   <!-- =============== BOOTSTRAP STYLES ===============-->
   <link rel="stylesheet" href="css/bootstrap.css" id="bscss">
   <!-- =============== APP STYLES ===============-->
   <link rel="stylesheet" href="css/app.css" id="maincss">
   <style>
      html, body{
         height: 100%;
      }
      .container, .row{
         height: 100%;
      }
   </style>
</head>

<body>
<div class="container">
   <div class="row  d-flex justify-content-center">
        <div class="col-12 col-md-6 col-lg-4 align-self-center ">
            <div class="wrapper">
                  <!-- START card-->
               <div class="card card-flat">
                  <div class="card-header text-center">
                     <a href="#">
                        <!-- <img class="img-fluid" src="img/qsystem.png" alt="Image"> -->

                         <img src="Gestion/vista/documento/logo.png" class="Logo" style="height:80px; width:280px">
                         <h3 class="mt-4">Sistema de Cobranza</h3>
                     </a>
                  </div>
                  <div class="card-body">
                     <form class="mb-3" id="frmAcceso" novalidate="" autocomplete="off">
                        <div class="form-group">
                           <div class="input-group with-focus">
                              <input class="form-control border-right-0" id="usuario" type="text" placeholder="Usuario" autocomplete="off" required>
                              <div class="input-group-append">
                                 <span class="input-group-text text-muted bg-transparent border-left-0"><i class="fa fa-user fa-lg text-gray-dark"></i></span>
                              </div>
                           </div>
                           <label id="mensajeUsu"></label>
                        </div>
                        <div class="form-group">
                           <div class="input-group with-focus">
                              <input class="form-control border-right-0" id="password" type="password" placeholder="Password" required>
                              <div class="input-group-append">
                                 <span class="input-group-text  text-muted bg-transparent border-left-0"><i class="fas fa-lock fa-lg text-gray-dark"></i></span>
                              </div>
                           </div>
                           <div id="mensajePass"></div>
                        </div>
                        <button class="btn btn-block btn-primary mt-3" type="submit">Ingresar</button>
                     </form>
                  </div>
               </div>
                  <!-- END card-->
               <div class="p-3 text-center">
                  <span class="mr-2">&copy;</span>
                  <span>2018</span>
                  <span class="mr-2">-</span>
                  <span>Sistema </span>
                  <br>
                  <span></span>
               </div>
                 <!-- /.login-box-body -->
               <div class="text-center" id="loading">
                <br>
                  <i class="fa fa-spinner fa-pulse fa-3x fa-fw text-info"></i>
                  <span class="sr-only">Loading...</span>
               </div>
            </div>
         </div>
      </div>
  </div>
   <!-- =============== VENDOR SCRIPTS ===============-->
   <!-- MODERNIZR-->
   <script src="vendor/modernizr/modernizr.custom.js"></script>
   <!-- JQUERY-->
   <script src="vendor/jquery/dist/jquery.js"></script>
   <!-- BOOTSTRAP-->
   <script src="vendor/bootstrap/dist/js/bootstrap.js"></script>
   <!-- STORAGE API-->
   <script src="vendor/js-storage/js.storage.js"></script>
   <!-- PARSLEY-->
   <script src="vendor/parsleyjs/dist/parsley.js"></script>
   <!-- =============== APP SCRIPTS ===============-->
   <script src="js/app.js"></script>

   <script src="vendor/font-awesome/js/all.min.js"></script>

   <script src="login.js"></script>
</body>

</html>
