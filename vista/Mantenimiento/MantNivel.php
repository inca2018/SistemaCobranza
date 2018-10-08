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
              <div>Mantenimiento Nivels</div>
            </div> -->
            <!-- START card-->
            <div class="card card-default m-1 ">
               <div class="card-body ">
                        <div class="row ">
                            <div class="col-md-12 w-100 text-center ">
                                <h3>Mantenimiento de Nivel Academico:</h3>
                            </div>
                        </div>
                        <hr class="mt-2 mb-2">
                         <div class="row">
                            <div class="col-md-2 offset-10">
                                <button class="btn btn-success btn-block btn-sm" onclick="NuevoNivel();"><i class="fa fa-plus fa-lg mr-2"></i> Nueva Nivel</button>
                            </div>
                        </div>
                        <h5 class="mt-3 mb-3 titulo_area" ><em><b>Lista General de Nivel:</b></em></h5>
                        <div class="row ">
                            <div class="col-md-12">
                                <div class="row">
                                   <div class="col-md-12">
                                        <table class="table w-100 table-hover table-sm dt-responsive nowrap" id="tablaNivel">
                                            <thead class="thead-light text-center">
                                                <tr>
                                                    <th data-priority="1">#</th>
                                                    <th>ESTADO</th>
                                                    <th>NOMBRE DE NIVEL</th>
                                                    <th>REGISTRO</th>
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

<div class="modal fade " id="ModalNivel" role="dialog" aria-labelledby="myModalLabelLarge" aria-hidden="true">
	<div class="modal-dialog modal-lg  ">
		<div class="modal-content">
            <div class="row m-1 bb">
                <div class="col-md-12">
                    <h4 class="text-center text-" id="tituloModalNivel"></h4>
                </div>
            </div>
			<div class="modal-body " >
				<form id="FormularioNivel" method="POST" autocomplete="off">
                     <input type="hidden" name="idNivel" id="idNivel">
                     <div class="row mb-3 mt-1">
                         <div class="col-md-3">
                             <label class=""><span class="red">(*) Campos Obligatorios</span></label>
                         </div>
                         <div class="col-md-1 offset-8">
                              <button type="button" class="btn btn-info btn-sm btn-display" title="Limpiar Campos" onclick="LimpiarNivel();">
                              <i class="fa fa-trash-alt fa-lg "></i>
                              </button>
                         </div>
                     </div>

					 <div class="row" id="cuerpo">
					      <div class="col-md-12   bl">

                                <div class="row">
                                      <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="NivelNombre" class="col-md-5 col-form-label"><i class="fas fa-bookmark fa-lg mr-3"></i> Nivel<span class="red">*</span>:</label>
                                            <div class="col-md-7">
                                                <input class="form-control validarPanel" id="NivelNombre" name="NivelNombre" data-message="- Campo  Nombre de Nivel"  placeholder="Nombre de Nivel" type="text" maxlength="50">

                                            </div>
                                        </div>
                                    </div>
											  <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="NivelEstado" class="col-md-5 col-form-label"><i class="fa fa-sun fa-lg mr-3"></i>Estado<span class="red">*</span>:</label>
                                            <div class="col-md-7">
                                                <select class="form-control validarPanel" id="NivelEstado" name="NivelEstado" data-message="- Campo Estado">

                                                </select>
                                            </div>
                                        </div>
                                    </div>


                                </div>
                                <div class="row mr-1 ml-1">
                                           <button type="submit" class="col-md-2 btn btn-success btn-sm" title="Guardar">
                                              <i class="fa fa-save fa-lg mr-2"></i>GUARDAR
                                           </button>

                                           <button type="button" class="col-md-2 btn btn-danger btn-sm  offset-8" title="Cancelar" onclick="Cancelar();">
                                              <i class="fa fa-times fa-lg mr-2"></i>CANCELAR
                                           </button>

                               </div>
                            </div>
					 </div>
				</form>
			</div>
		</div>
	</div>
</div>


<script src="<?php echo $conexionConfig->rutaOP(); ?>vista/js/MantNivel.js"></script>
