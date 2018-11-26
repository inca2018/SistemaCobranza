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

        <!-- START card-->
        <div class="card card-default">
            <div class="card-body">
                <div class="row ">
                    <div class="col-md-12 w-100 text-center ">
                        <h3>Panel de Reporte:</h3>
                    </div>
                </div>
                <div class="row justify-content-center">
                    <div class="col-md-4 form-group ">
                        <label>Seleccione Año:</label>
                        <select class="form-control  " id="yearSelect" name="yearSelect"> </select>
                    </div>

                    <div class="col-md-4 form-group  ">
                        <label>Seleccione Año:</label>
                        <select class="form-control " id="Meses" name="">
                            <option value="1">ENERO</option>
                            <option value="2">FEBRERO</option>
                            <option value="3">MARZO</option>
                            <option value="4">ABRIL</option>
                            <option value="5">MAYO</option>
                            <option value="6">JUNIO</option>
                            <option value="7">JULIO</option>
                            <option value="8">AGOSTO</option>
                            <option value="9">SEPTIEMBRE</option>
                            <option value="10">OCTUBRE</option>
                            <option value="11">NOVIEMBRE</option>
                            <option value="12">DICIEMBRE</option>

                        </select>
                    </div>
                </div>

                <div class="row justify-content-center m-3">
                    <button type="button" class="btn btn-success col-md-6" onclick="buscar_reporte()">BUSCAR RESULTADOS</button>
                </div>
                <hr>


                <div class="row">
                    <div class="col-md-6">
                        <h4 class="modal-title mt-3 mb-3 bb" id="myModalLabelLarge">Indice de Cumplimiento de Pago: </h4>
                        <div class="row">
                            <div class="col-md-12">
                                <table class="table my-4 w-100 table-hover table-sm dt-responsive" id="tabla_Detalles1" style="font-size:10px">
                                    <thead class="thead-light">
                                        <tr>
                                            <th width="5%" data-priority="1">#</th>
                                            <th width="20%">Alumno</th>
                                            <th width="20%">Fecha</th>
                                            <th width="20%">Numero de Cuentas Pagadas(NCPA)</th>
                                            <th width="20%">Numero de Cuentas Programadas(NCPR)</th>
                                            <th width="15%">ICP=(NCPA/NCPR)</th>

                                        </tr>
                                    </thead>
                                    <tbody id="body_detalles1">

                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <h4 class="modal-title mt-3 mb-3 bb" id="myModalLabelLarge">Indice de Morocidad:</h4>
                        <div class="row">
                            <div class="col-md-12">
                                <table class="table my-4 w-100 table-hover table-sm dt-responsive " id="tabla_Detalles2" style="font-size:10px">
                                    <thead class="thead-light">
                                        <tr>
                                            <th  width="5%" data-priority="1">#</th>
                                            <th width="20%">Alumno</th>
                                            <th width="20%">Fecha</th>
                                            <th width="20%">Cartera Vencida (CV)</th>
                                            <th width="20%">Cartera Total (CT)</th>
                                            <th width="15%">IMOR=(CV/CT)</th>

                                        </tr>
                                    </thead>
                                    <tbody id="body_detalles2">

                                    </tbody>
                                </table>
                            </div>
                        </div>

                    </div>
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



<script src="<?php echo $conexionConfig->rutaOP(); ?>vista/js/Reporte.js"></script>
