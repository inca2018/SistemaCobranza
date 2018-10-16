<?php

if(isset($_POST["idPlan"]) && isset($_POST["idAlumno"])){

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
               <div class="card-body ">
                    <input type="hidden" id="idPlan" name="idPlan" value="<?php echo $_POST["idPlan"] ;?>">
                    <input type="hidden" id="idAlumno" name="idAlumno" value="<?php echo $_POST["idAlumno"] ;?>">


                        <div class="row ">
                            <div class="col-md-12 w-100 text-center ">
                                <h3>Pago Cuotas:</h3>
                            </div>
                        </div>
                        <hr>

                        <div class="row  ">
                            <div class="col-md-6">
                                <h5 class="mt-3 mb-3 titulo_area" ><em><b>Información de Alumno:</b></em></h5>
                                <div class="row">
                                    <div class="col-12 col-md-6 br bb">
												<div class="form-group">
                                                    <label class="text-center w-100  text-muted"><em><b>Nombres del Alumno:</b></em></label>
													<h5 class="text-center " id="cab_nombre_alumno" ><b> </b></h5>
												</div>
										</div>
										<div class="col-12 col-md-6 br bb">
												<div class="form-group">
                                                    <label class="text-center w-100 text-muted"><em><b>DNI del Alumno:</b></em></label>
													<h5 class="text-center" id="cab_dni_alumno"><b> </b></h5>
												</div>
										</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <h5 class="mt-3 mb-3 titulo_area" ><em><b>Información de Apoderado:</b></em></h5>
                                <div class="row">
                                      <div class="col-12 col-md-6 br bb">
												<div class="form-group">
                                                    <label class="text-center w-100  text-muted"><em><b>Nombres del Alumno:</b></em></label>
													<h5 class="text-center " id="cab_nombre_apoderado" ><b> </b></h5>
												</div>
										</div>
										<div class="col-12 col-md-6 br bb">
												<div class="form-group">
                                                    <label class="text-center w-100 text-muted"><em><b>DNI del Alumno:</b></em></label>
													<h5 class="text-center" id="cab_dni_apoderado"><b> </b></h5>
												</div>
										</div>
                                </div>
                            </div>
                        </div>

                         <div class="row">
                             <div class="col-md-6 br">
                                 <h5 class="mt-3 mb-3 titulo_area" ><em><b>Pagos Pendientes:</b></em></h5>

                                  <table class="table w-100 table-hover table-sm dt-responsive nowrap" id="tablaCuotas" style="font-size:11px;">
                                            <thead class="thead-light text-center">
                                                <tr>
                                                    <th data-priority="1">#</th>
                                                    <th>ESTADO</th>
                                                    <th>IMPORTE</th>
                                                    <th>DIFERENCIA</th>

                                                    <th>F.VENC.</th>
                                                    <th>D.VENC.</th>
                                                    <th>IMP. MORA</th>
                                                    <th>ACCION</th>
                                                </tr>

                                            </thead>
                                            <tbody>
                                            </tbody>
                                    </table>

                             </div>
                             <div class="col-md-6" id="modulo_pago" style="display:none;">
                                <form id="FormularioPago" method="POST" autocomplete="off">
                                    <input type="hidden" id="MontoPagar" name="MontoPagar">
                                    <input type="hidden" id="MontoMoraBase" name="MontoMoraBase">

                                    <input type="hidden" id="MontoIngreso" name="MontoIngreso" value="0">
                                    <input type="hidden" id="importeMora" name="importeMora">


                                    <input type="hidden" id="idTarjeta" name="idTarjeta">
                                    <input type="hidden" id="numPago" name="numPago">
                                    <input type="hidden" id="idCuota" name="idCuota">

                                   <input type="hidden" id="importeBase" name="importeBase">

                                 <h5 class="mt-3 mb-3 titulo_area" ><em><b>Pagar:</b></em></h5>
                                 <div class="row">
                                     <div class="col-md-12">
                                           <div class="form-group row">
                                                <label for="" class="col-md-5 col-form-label">IMPORTE A PAGAR:</label>
                                                <div class="col-md-7">
                                                    <input type="text" class="form-control " placeholder="Importe" name="importePagar" id="importePagar" readonly>
                                                </div>
                                            </div>
                                     </div>
                                  </div>
                                  <div class="row" id="modulo_Mora1" style="display:none;">
                                     <div class="col-md-12">
                                           <div class="form-group row">
                                                <label for="" class="col-md-5 col-form-label">IMPORTE A PAGAR DE MORA:</label>
                                                <div class="col-md-7">
                                                    <input type="text" class="form-control " placeholder="Importe Mora" name="importePagarMora" id="importePagarMora" readonly>
                                                </div>
                                            </div>
                                     </div>
                                  </div>
                                 <div class="row">
                                     <div class="col-md-12">
                                        <div class="form-group row">
                                            <label for="" class="col-md-5 col-form-label">TIPO DE PAGO :</label>
                                            <div class="col-md-7">
                                                <select class="form-control validarPanel" id="PagoTipoPago" name="PagoTipoPago" data-message="- Tipo de Pago">

                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                 </div>
                                 <div class="row" id="panel_tipoTarjeta" style="display:none;">
                                     <div class="col-md-12">
                                        <div class="form-group row">
                                            <label for="" class="col-md-5 col-form-label">TIPO DE TARJETA:</label>
                                            <div class="col-md-7">
                                                <select class="form-control" id="PagoTipoTarjeta" name="PagoTipoTarjeta" >
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                 </div>
                                  <div class="row">
                                     <div class="col-md-12">
                                           <div class="form-group row">
                                                <label for="" class="col-md-5 col-form-label">IMPORTE:</label>
                                                <div class="col-md-7">
                                                    <input type="text" class="form-control " placeholder="Importe" name="importePago" id="importePago" data-message="- Importe Pago" onkeypress="return SoloNumerosModificado(event,8,this.id);">
                                                </div>
                                            </div>
                                     </div>
                                  </div>
                                  <div class="row" id="modulo_Mora2" style="display:none;">
                                     <div class="col-md-12">
                                           <div class="form-group row">
                                                <label for="" class="col-md-5 col-form-label">IMPORTE MORA:</label>
                                                <div class="col-md-7">
                                                    <input type="text" class="form-control validarPanel" placeholder="Importe" name="importePagoMora" id="importePagoMora" data-message="- Importe Pago" onkeypress="return SoloNumerosModificado(event,8,this.id);">
                                                </div>
                                            </div>
                                     </div>
                                  </div>
                                  <div class="row">
                                      <div class="col-md-12">
                                                <div class="form-group ">
                                                    <label for="" class=" col-form-label texto-x12"><b>DETALLE:</b> </label>

                                                    <textarea id="pago_detalle" name="pago_detalle" rows="2" class="form-control" onkeypress="return SoloLetras(event,150,this.id);">
                                                    </textarea>
                                                </div>
                                            </div>
                                  </div>
                                  <div class="row">
                                      <div class="col-md-3 offset-5">
                                          <button class="btn btn-success">GUARDAR PAGO</button>
                                      </div>
                                  </div>
                                </form>
                             </div>
                             <div class="col-md-6" id="modulo_Mensaje" style="display:none;">

                                 <div class=" text-green text-center"><h4>PAGO COMPLETADO EXITOSAMENTE.</h4></div>
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


<script src="<?php echo $conexionConfig->rutaOP(); ?>vista/js/PagoCuota.js"></script>
