<!-- Inicio de Cabecera-->
<?php require_once('../layaout/Header.php');?>
<!-- fin Cabecera-->
<!-- Inicio del Cuerpo y Nav -->
<?php require_once('../layaout/Nav.php');?>
<!-- Fin  del Cuerpo y Nav -->
<!-- Cuerpo del sistema de Menu -->
<!-- Main section-->
<section class="section-container">
    <!-- Page content-->
    <div class="content-wrapper">
        <!-- <div class="content-heading">
              <div>Mantenimiento Alumnos</div>
            </div> -->
        <!-- START card-->
        <div class="card card-default m-1 ">
            <div class="card-body ">
                <div class="row ">
                    <div class="col-md-12 w-100 text-center ">
                        <h3>Comunicado:</h3>
                    </div>
                </div>
                <hr class="mt-2 mb-2">
                <h5 class="mt-3 mb-3 titulo_area"><em><b>Agregar Comunicado:</b></em></h5>
                <form id="FormularioComunicado" method="POST" autocomplete="off">
                    <span id="exiteComunicado"></span>
                    <div class="row" id="contenedor">

                        <div class="col-md-6">
                            <div class="row">
                                <div class="col-md-12">
                                    <label for="Titulo " class=" col-form-label"> Titulo de Comunicado:</label>
                                    <input type="text" class="form-control " placeholder="Titulo de Comunicado" name="Titulo" id="Titulo" maxlength="150">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <label for="Titulo " class=" col-form-label"> Documento Adjunto:</label>
                                    <input class="form-control filestyle " type="file" name="adjuntar_documento" id="adjuntar_documento" data-classbutton="btn btn-secondary sombra3" data-classinput="form-control inline" data-icon="&lt;span class='fa fa-upload mr-2 '&gt;&lt;/span&gt;" accept="application/pdf">
                                </div>
                            </div>
                            <div class="row mt-3">
                               <div class="col-md-12">
                                   <button type="submit" class=" btn btn-success btn-sm" title="Guardar">
                                    <i class="fa fa-save fa-lg mr-2"></i>GUARDAR COMUNICADO
                                </button>
                               </div>

                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</section>
<!-- Fin Modal Agregar-->
<!-- Fin del Cuerpo del Sistema del Menu-->
<!-- Inicio del footer -->
<?php require_once('../layaout/Footer.php');?>
<!-- Fin del Footer -->


<script src="<?php echo $conexionConfig->rutaOP(); ?>vista/js/Comunicado.js"></script>
