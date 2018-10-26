<?php

if(isset($_POST["idAlumno"])){

}else{
    header("Location: Operaciones.php");
}
?>
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
              <div>Mantenimiento Grados</div>
            </div> -->
        <!-- START card-->
        <div class="card sombra2 ">
            <div class="card-body">
                <input type="hidden" id="idAlumno" name="idAlumno" value="<?php echo $_POST["idAlumno"] ;?>">
                <input type="hidden" id="idApoderado" name="idApoderado">
                <div class="row ">
                    <div class="col-md-12 w-100 text-center ">
                        <h3>Pago Matricula:</h3>
                    </div>
                </div>
                <hr>
                <div class="row">
                    <div class="col-lg-6">
                        <p class="lead bb">Información del Alumno</p>
                        <form class="form-horizontal">
                            <div class="form-group row">
                                <div class="col-md-4">DNI:</div>
                                <div class="col-md-8" id="info_alu_dni">
                                    <strong>-</strong>
                                </div>
                            </div>
                            <div class="form-group row">
                                <div class="col-md-4">Nombres y Apellidos:</div>
                                <div class="col-md-8" id="info_alu_nombres">
                                    <strong>-</strong>
                                </div>
                            </div>
                            <div class="form-group row">
                                <div class="col-md-4">Nivel:</div>
                                <div class="col-md-8" id="info_alu_nivel">
                                    <strong>-</strong>
                                </div>
                            </div>
                            <div class="form-group row">
                                <div class="col-md-4">Grado y Sección:</div>
                                <div class="col-md-8" id="info_alu_grado">
                                    <strong>-</strong>
                                </div>
                            </div>

                        </form>
                    </div>
                    <div class="col-lg-6">
                        <p class="lead bb">Información del Apoderado</p>
                        <form class="form-horizontal">
                            <div class="form-group row">
                                <div class="col-md-4">DNI:</div>
                                <div class="col-md-8" id="info_apo_dni">
                                    <strong>-</strong>
                                </div>
                            </div>
                            <div class="form-group row">
                                <div class="col-md-4">Nombres y APellidos</div>
                                <div class="col-md-8" id="info_apo_nombres">
                                    <strong>-</strong>
                                </div>
                            </div>
                            <div class="form-group row">
                                <div class="col-md-4">Telefono:</div>
                                <div class="col-md-8" id="info_apo_telefono">
                                    <strong>-</strong>
                                </div>
                            </div>

                        </form>
                    </div>
                </div>
                <hr>
                <div class="row">
                    <div class="col-md-6">
                        <div class="row">
							<div class="col-md-12">
								<table class="table w-100 table-hover table-sm dt-responsive nowrap" id="tablaDeudas" style="font-size:13px">
									<thead class="thead-light text-center">

										<tr>
											<th data-priority="1">#</th>
											<th>ALUMNOS</th>
											<th>DNI</th>
											<th>APODERADO</th>
											<th>DNI</th>
											<th>N° CUOTAS</th>
											<th>C. PENDIENTES</th>
											<th>C. PAGADAS</th>
											<th>C. VENCIDAS</th>
											<th>ACCION</th>
										</tr>
									</thead>
									<tbody>
									</tbody>
								</table>
							</div>

						</div>
                    </div>
                    <div class="col-md-6">

                    </div>
                </div>

                <div class="row m-3">
                    <button type="button" class="btn btn-info col-md-1" onclick="Volver();">VOLVER</button>
                </div>

            </div>
        </div>
    </div>
</section>
<!-- Fin Modal Agregar-->
<!-- Fin del Cuerpo del Sistema del Menu-->
<!-- Inicio del footer -->
<?php require_once('../layaout/Footer.php');?>
<!-- Fin del Footer -->


<script src="<?php echo $conexionConfig->rutaOP(); ?>vista/js/PagoMatricula.js"></script>
