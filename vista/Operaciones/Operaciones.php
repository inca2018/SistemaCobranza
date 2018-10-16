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
               <div class="card-body ">
                        <div class="row ">
                            <div class="col-md-12 w-100 text-center ">
                                <h3>Panel de Control:</h3>
                            </div>
                        </div>
                        <hr class="mt-2 mb-2">
                        <div class="row" id="OpcionEmpleado">
                           <div class="col-md-12">
                                <div class="row">
                                   <div class="col-xl-3 col-lg-6">
                                      <!-- START card-->
                                      <div class="card bg-info-dark border-0 sombra1">
                                         <div class="card-header">
                                            <div class="row align-items-center">
                                               <div class="col-3">
                                                  <em class="fa fa-child fa-4x"></em>
                                               </div>
                                               <div class="col-9 text-right">
                                                  <div class="text-lg" id="total_alumnos">0</div>
                                                  <h4><p class="m-0">Alumnos</p> </h4>
                                               </div>
                                            </div>
                                         </div>
                                         <a class="card-footer p-2 bg-info  bt0 clearfix btn-block d-flex" href="#" onclick="MostrarGestionAlumnos();">
                                            <span>Gestión</span>
                                            <span class="ml-auto">
                                               <em class="fa fa-chevron-circle-right"></em>
                                            </span>
                                         </a>

                                         <!-- END card-->
                                      </div>
                                   </div>
                                   <div class="col-xl-3 col-lg-6">
                                      <!-- START card-->
                                      <div class="card bg-warning-dark border-0 sombra1">
                                         <div class="card-header">
                                            <div class="row align-items-center">
                                               <div class="col-3">
                                                  <em class="fas fa-male fa-4x"></em>

                                               </div>
                                               <div class="col-9 text-right">
                                                  <div class="text-lg" id="total_apoderados">0</div>
                                                    <h4><p class="m-0"></p>Apoderados</h4>
                                               </div>
                                            </div>
                                         </div>
                                         <a class="card-footer p-2 bg-warning bt0 clearfix btn-block d-flex" href="#" onclick="MostrarGestionApoderados();">
                                            <span>Gestión</span>
                                            <span class="ml-auto">
                                               <em class="fa fa-chevron-circle-right"></em>
                                            </span>
                                         </a>

                                      </div>
                                      <!-- END card-->
                                   </div>
                                   <div class="col-xl-3 col-lg-6">
                                      <!-- START card-->
                                      <div class="card bg-green-dark border-0 sombra1" >
                                         <div class="card-header">
                                            <div class="row align-items-center">
                                               <div class="col-3">
                                                 <em class="far fa-money-bill-alt fa-4x"></em>
                                               </div>
                                               <div class="col-9 text-right">
                                                  <div class="text-lg" id="ind_empleados_operaciones">0</div>
                                                            <h4> <p class="m-0">Cuotas Pagadas Hoy</p> </h4>

                                               </div>
                                            </div>
                                         </div>

                                         <a class="card-footer p-2 bg-green  bt0 clearfix btn-block d-flex"  href="#" onclick="MostrarOperaciones();">
                                            <span>Detalles</span>
                                            <span class="ml-auto">
                                               <em class="fa fa-chevron-circle-right"></em>
                                            </span>
                                         </a>

                                      </div>
                                      <!-- END card-->
                                   </div>
                                   <div class="col-xl-3 col-lg-6">
                                      <!-- START card-->
                                      <div class="card bg-danger-dark border-0 sombra1">
                                         <div class="card-header">
                                            <div class="row align-items-center">
                                               <div class="col-3">
                                                  <em class="far fa-money-bill-alt fa-4x"></em>
                                               </div>
                                               <div class="col-9 text-right">
                                                  <div class="text-lg" id="ind_asignado">0</div>
                                                            <h4> <p class="m-0">Cuotas Vencidas</p></h4>

                                               </div>
                                            </div>
                                         </div>
                                         <a class="card-footer p-2 bg-danger-light  bt0 clearfix btn-block d-flex"  href="#" onclick="MostrarInformacionAsignado();">
                                            <span>Detalles</span>
                                            <span class="ml-auto">
                                               <em class="fa fa-chevron-circle-right"></em>
                                            </span>
                                         </a>

                                      </div>
                                      <!-- END card-->
                                   </div>
                                </div>
                           </div>

                        </div>

                        <h5 class="mt-3 mb-3 titulo_area" ><em><b>Información General:</b></em></h5>
                        <div class="row ">
                            <div class="col-md-12">
                                <div class="row">
                                   <div class="col-md-12">
                                        <table class="table w-100 table-hover table-sm dt-responsive nowrap" id="tablaOperaciones" style="font-size:13px">
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


<script src="<?php echo $conexionConfig->rutaOP(); ?>vista/js/Operaciones.js"></script>
