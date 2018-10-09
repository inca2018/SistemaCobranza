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
                                <h3>Mantenimiento de Alumno:</h3>
                            </div>
                        </div>
                        <hr class="mt-2 mb-2">
                         <div class="row">
                            <div class="col-md-2">
                                <button class="btn btn-info btn-block btn-sm" onclick="Volver();"><i class="fas fa-arrow-left  fa-lg mr-2"></i>Volver</button>
                            </div>
                            <div class="col-md-2 offset-8">
                                <button class="btn btn-success btn-block btn-sm" onclick="NuevoAlumno();"><i class="fa fa-plus fa-lg mr-2"></i> Nueva Alumno</button>
                            </div>
                        </div>
                        <h5 class="mt-3 mb-3 titulo_area" ><em><b>Lista General de Alumno:</b></em></h5>
                        <div class="row ">
                            <div class="col-md-12">
                                <div class="row">
                                   <div class="col-md-12">
                                        <table class="table w-100 table-hover table-sm dt-responsive nowrap" id="tablaAlumno">
                                            <thead class="thead-light text-center">
                                                <tr>
                                                    <th data-priority="1">#</th>
                                                    <th>ESTADO</th>
                                                    <th>NOMBRE DE ALUMNO</th>
                                                    <th>DNI</th>
                                                    <th>NIVEL</th>
                                                    <th>GRADO</th>
                                                    <th>SECCION</th>
                                                    <th>FECHA REGISTRO</th>
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

<div class="modal fade " id="ModalAlumno" role="dialog" aria-labelledby="myModalLabelLarge" aria-hidden="true">
	<div class="modal-dialog modal-lg  ">
		<div class="modal-content">
            <div class="row m-1 bb">
                <div class="col-md-12">
                    <h4 class="text-center text-" id="tituloModalAlumno"></h4>
                </div>
            </div>
			<div class="modal-body " >
				<form id="FormularioAlumno" method="POST" autocomplete="off">
                     <input type="hidden" name="idPersona" id="idPersona">
                     <input type="hidden" name="idAlumno" id="idAlumno">

                     <div class="row mb-3 mt-1">
                         <div class="col-md-3">
                             <label class=""><span class="red">(*) Campos Obligatorios</span></label>
                         </div>
                         <div class="col-md-1 offset-8">
                              <button type="button" class="btn btn-info btn-sm btn-display" title="Limpiar Campos" onclick="LimpiarAlumno();">
                              <i class="fa fa-trash-alt fa-lg "></i>
                              </button>
                         </div>
                     </div>

					 <div class="row" id="cuerpo">
					      <div class="col-md-12 bl">
                                <h5 class="mt-3 mb-3 titulo_area" ><em><b>Datos Personales:</b></em></h5>
                                <div class="row">
                                      <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="AlumnoNombre" class="col-md-5 col-form-label"><i class="fas fa-address-book fa-lg mr-2"></i>Nombres<span class="red">*</span>:</label>
                                            <div class="col-md-7">
                                                <input class="form-control validarPanel" id="AlumnoNombre" name="AlumnoNombre" data-message="- Nombre de Alumno"  placeholder="Nombre" type="text" onkeypress="return SoloLetras(event,40,this.id);">

                                            </div>
                                        </div>
                                    </div>



                                      <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="AlumnoFechaNacimiento" class="col-md-5 col-form-label"><i class="far fa-calendar-check fa-lg mr-2"></i>F.Nacimiento<span class="red">*</span>:</label>
                                            <div class="col-md-7">
                                                <div class=" row">
																<div class="input-group date  col-md-12" id="dateFechaNacimiento"   >
																	<input class="form-control validarPanel" type="text" id="AlumnoFechaNacimiento" name="AlumnoFechaNacimiento"  autocomplete="off" data-message="- Fecha de Nacimiento">
																	<span class="input-group-append input-group-addon">

																		<span class="input-group-text "><i class="fa fa-calendar fa-lg"></i></span>
																	</span>
																</div>
															</div>
                                            </div>
                                        </div>
                                    </div>
                                     <div class="col-md-6 br">
                                           <div class="form-group row">
                                                <label for="AlumnoApellidoP " class="col-md-5 col-form-label  "><i class="far fa-address-book mr-2 fa-lg"></i>Apellido P.<span class="red">*</span>:</label>
                                                <div class="col-md-7">
                                                    <input type="text" class="form-control validarPanel" placeholder="Apellido Paterno" name="AlumnoApellidoP" id="AlumnoApellidoP" data-message="- Apellido Paterno" onkeypress="return SoloLetras(event,40,this.id);">
                                                </div>
                                            </div>
                                     </div>

                                      <div class="col-md-6">
                                           <div class="form-group row">
                                                <label for="AlumnoDNI" class="col-md-5 col-form-label"><i class="fa fa-lock mr-2 fa-lg"></i>DNI:<span class="red">*</span>:</label>
                                                <div class="col-md-7">
                                                    <input type="number" class="form-control validarPanel" placeholder="Dni" name="AlumnoDNI" id="AlumnoDNI" data-message="- DNI" onkeypress="return SoloNumerosModificado(event,8,this.id);">
                                                </div>
                                            </div>
                                     </div>


                                     <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="AlumnoApellidoM" class="col-md-5 col-form-label"><i class="fa fa-address-card mr-2 fa-lg"></i>Apellido M.<span class="red">*</span>:</label>
                                            <div class="col-md-7">
                                                <input type="text" class="form-control validarPanel" placeholder="Apellido Materno" name="AlumnoApellidoM" id="AlumnoApellidoM" data-message="- Apellido Materno" onkeypress="return SoloLetras(event,40,this.id);">
                                            </div>
                                        </div>
                                    </div>
                                     <div class="col-md-6">
                                           <div class="form-group row">
                                                <label for="AlumnoCorreo " class="col-md-5 col-form-label"><i class="fa fa-at mr-2 fa-lg"></i>Correo:</label>
                                                <div class="col-md-7">
                                                    <input type="email" class="form-control " placeholder="Correo" name="AlumnoCorreo" id="AlumnoCorreo" maxlength="40">
                                                </div>
                                            </div>
                                     </div>
                                    <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="AlumnoTelefono" class="col-md-5 col-form-label"><i class="fa fa-phone fa-lg mr-3"></i>Telefono:</label>
                                            <div class="col-md-7">
                                               <input type="number" class="form-control " placeholder="Telefono" name="AlumnoTelefono" id="AlumnoTelefono" onkeypress="return SoloNumerosModificado(event,9,this.id);">
                                            </div>
                                        </div>
                                    </div>
                                      <div class="col-md-12 ">
                                        <div class="form-group ">
                                            <label for="AlumnoDireccion" class=" col-form-label"><i class="fa fa-address-card fa-lg mr-3"></i>Dirección:</label>

                                                 <textarea id="AlumnoDireccion" name="AlumnoDireccion" rows="2" class="form-control" >

                                                 </textarea>

                                        </div>
                                    </div>
                                    <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="AlumnoEstado" class="col-md-5 col-form-label"><i class="fa fa-sun fa-lg mr-3"></i>Estado<span class="red">*</span>:</label>
                                            <div class="col-md-7">
                                                <select class="form-control validarPanel" id="AlumnoEstado" name="AlumnoEstado" data-message="- Estado">

                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                </div>

                                <hr>
                                 <h5 class="mt-3 mb-3 titulo_area" ><em><b>Información Acádemica:</b></em></h5>
                                <div class="row">
                                   <div class="col-md-4 br">
                                        <div class="form-group row">
                                            <label for="AlumnoNivel" class="col-md-6 col-form-label"><i class="fa fa-star fa-lg mr-3"></i>Nivel<span class="red">*</span>:</label>
                                            <div class="col-md-6">
                                                <select class="form-control validarPanel" id="AlumnoNivel" name="AlumnoNivel" data-message="- Nivel">

                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                     <div class="col-md-4 br">
                                        <div class="form-group row">
                                            <label for="AlumnoGrado" class="col-md-6 col-form-label"><i class="fa fa-star fa-lg mr-3"></i>Grado<span class="red">*</span>:</label>
                                            <div class="col-md-6">
                                                <select class="form-control validarPanel" id="AlumnoGrado" name="AlumnoGrado" data-message="- Grado">

                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-4 br">
                                        <div class="form-group row">
                                            <label for="AlumnoSeccion" class="col-md-6 col-form-label"><i class="fa fa-star fa-lg mr-3"></i>Sección<span class="red">*</span>:</label>
                                            <div class="col-md-6">
                                                <select class="form-control validarPanel" id="AlumnoSeccion" name="AlumnoSeccion" data-message="- Sección">

                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                                <hr>
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
<div class="modal fade " id="ModalPlanPago2" role="dialog" aria-labelledby="myModalLabelLarge" aria-hidden="true">
	<div class="modal-dialog modal-lg  ">
		<div class="modal-content">
            <div class="row m-1 bb">
                <div class="col-md-12">
                    <h4 class="text-center text-">NUEVO PLAN DE PAGO:</h4>
                </div>
            </div>
			<div class="modal-body " >
				<form id="FormularioAlumno" method="POST" autocomplete="off">
                     <input type="hidden" name="idPersona" id="idPersona">
                     <input type="hidden" name="idAlumno" id="idAlumno">

                     <div class="row mb-3 mt-1">
                         <div class="col-md-3">
                             <label class=""><span class="red">(*) Campos Obligatorios</span></label>
                         </div>
                         <div class="col-md-1 offset-8">
                              <button type="button" class="btn btn-info btn-sm btn-display" title="Limpiar Campos" onclick="LimpiarAlumno();">
                              <i class="fa fa-trash-alt fa-lg "></i>
                              </button>
                         </div>
                     </div>

					 <div class="row" id="cuerpo">
					      <div class="col-md-12 bl">
                                <h5 class="mt-3 mb-3 titulo_area" ><em><b>Información de Alumno:</b></em></h5>
                                <div class="row">
                                      <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="AlumnoNombre" class="col-md-5 col-form-label"><i class="fas fa-address-book fa-lg mr-2"></i>Nombres<span class="red">*</span>:</label>
                                            <div class="col-md-7">
                                                <input class="form-control validarPanel" id="AlumnoNombre" name="AlumnoNombre" data-message="- Nombre de Alumno"  placeholder="Nombre" type="text" onkeypress="return SoloLetras(event,40,this.id);">

                                            </div>
                                        </div>
                                    </div>



                                      <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="AlumnoFechaNacimiento" class="col-md-5 col-form-label"><i class="far fa-calendar-check fa-lg mr-2"></i>F.Nacimiento<span class="red">*</span>:</label>
                                            <div class="col-md-7">
                                                <div class=" row">
																<div class="input-group date  col-md-12" id="dateFechaNacimiento"   >
																	<input class="form-control validarPanel" type="text" id="AlumnoFechaNacimiento" name="AlumnoFechaNacimiento"  autocomplete="off" data-message="- Fecha de Nacimiento">
																	<span class="input-group-append input-group-addon">

																		<span class="input-group-text "><i class="fa fa-calendar fa-lg"></i></span>
																	</span>
																</div>
															</div>
                                            </div>
                                        </div>
                                    </div>
                                     <div class="col-md-6 br">
                                           <div class="form-group row">
                                                <label for="AlumnoApellidoP " class="col-md-5 col-form-label  "><i class="far fa-address-book mr-2 fa-lg"></i>Apellido P.<span class="red">*</span>:</label>
                                                <div class="col-md-7">
                                                    <input type="text" class="form-control validarPanel" placeholder="Apellido Paterno" name="AlumnoApellidoP" id="AlumnoApellidoP" data-message="- Apellido Paterno" onkeypress="return SoloLetras(event,40,this.id);">
                                                </div>
                                            </div>
                                     </div>

                                      <div class="col-md-6">
                                           <div class="form-group row">
                                                <label for="AlumnoDNI" class="col-md-5 col-form-label"><i class="fa fa-lock mr-2 fa-lg"></i>DNI:<span class="red">*</span>:</label>
                                                <div class="col-md-7">
                                                    <input type="number" class="form-control validarPanel" placeholder="Dni" name="AlumnoDNI" id="AlumnoDNI" data-message="- DNI" onkeypress="return SoloNumerosModificado(event,8,this.id);">
                                                </div>
                                            </div>
                                     </div>


                                     <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="AlumnoApellidoM" class="col-md-5 col-form-label"><i class="fa fa-address-card mr-2 fa-lg"></i>Apellido M.<span class="red">*</span>:</label>
                                            <div class="col-md-7">
                                                <input type="text" class="form-control validarPanel" placeholder="Apellido Materno" name="AlumnoApellidoM" id="AlumnoApellidoM" data-message="- Apellido Materno" onkeypress="return SoloLetras(event,40,this.id);">
                                            </div>
                                        </div>
                                    </div>
                                     <div class="col-md-6">
                                           <div class="form-group row">
                                                <label for="AlumnoCorreo " class="col-md-5 col-form-label"><i class="fa fa-at mr-2 fa-lg"></i>Correo:</label>
                                                <div class="col-md-7">
                                                    <input type="email" class="form-control " placeholder="Correo" name="AlumnoCorreo" id="AlumnoCorreo" maxlength="40">
                                                </div>
                                            </div>
                                     </div>
                                    <div class="col-md-6 br">
                                        <div class="form-group row">
                                            <label for="AlumnoTelefono" class="col-md-5 col-form-label"><i class="fa fa-phone fa-lg mr-3"></i>Telefono:</label>
                                            <div class="col-md-7">
                                               <input type="number" class="form-control " placeholder="Telefono" name="AlumnoTelefono" id="AlumnoTelefono" onkeypress="return SoloNumerosModificado(event,9,this.id);">
                                            </div>
                                        </div>
                                    </div>
                                      <div class="col-md-12 ">
                                        <div class="form-group ">
                                            <label for="AlumnoDireccion" class=" col-form-label"><i class="fa fa-address-card fa-lg mr-3"></i>Dirección:</label>

                                                 <textarea id="AlumnoDireccion" name="AlumnoDireccion" rows="2" class="form-control" >

                                                 </textarea>

                                        </div>
                                    </div>


                                </div>


                                <hr>
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

<div class="modal fade" id="ModalPlanPago" role="dialog" aria-labelledby="myModalLabelLarge" aria-hidden="true">
	<form  id="FormEmisionComprobante" method="POST" autocomplete="off">
		<input type="hidden" id="general_id_empleado" name="general_id_empleado">
		<input type="hidden" id="general_diasMes_actual" name="general_diasMes_actual" value="0">


		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="row mr-1 ml-1">
					<div class="col-md-6 br bb mb-1 ">
						<label class=" texto-x10 text-muted  m-0 text-center">SISTEMA: </label>
						<span class="texto-x12 text-muted  text-center"><b>PROCESO DE COBRANZA</b></span>
					</div>
					<div class="col-md-6   bb mb-1 ">
						<label class=" texto-x10 text-muted  m-0 text-center">OPERACION: </label>
						<span class=" texto-x12 text-muted  text-center" id="titulo_cabecera"><b>REGISTRO DE PLAN DE PAGO</b></span>
					</div>
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-xl-12">
							<div role="tabpanel">
								<ul class="nav nav-pills " role="tablist">
									<li class="nav-item pill-1 m-2 " role="presentation"><a class="nav-link active" href="#op_datos" aria-controls="home" role="tab" data-toggle="tab">Datos del Alumno</a>
									</li>
									<li class="nav-item pill-2 m-2" role="presentation"><a class="nav-link" href="#op_info" aria-controls="profile" role="tab" data-toggle="tab">Información de Matricula</a>
									</li>
									<li class="nav-item pill-3 m-2" role="presentation"><a class="nav-link" href="#op_cuotas" aria-controls="messages" role="tab" data-toggle="tab">Cuotas Pensión</a>
									</li>

								</ul>
								<div class="tab-content">
								<div class="tab-pane active" id="op_datos" role="tabpanel">
									<div class="container">
										<h5 class="mt-2 mb-2 titulo_area" id="titulo_gasto"><em><b>Datos Personales:</b></em></h5>
										<div class="row ">
											<div class=" col-md-4">
												<div class="form-group row p-0" >
													<label for="cod_comprobante" class="col-md-4 col-form-label texto-x12" ><b>Nº DNI:</b></label>
													<div class="col-md-8">
														<input type="text" class="form-control texto-x12" placeholder="" name="datos_dni" id="datos_dni" readonly  value=""  >
													</div>
												</div>
											</div>
											<div class=" col-md-4">
												<div class="form-group row p-0" >
													<label for="cod_comprobante" class="col-md-4 col-form-label texto-x12" ><b>APELLIDOS:</b></label>
													<div class="col-md-8">
														<input type="text" class="form-control texto-x12" placeholder="" name="datos_apellido" id="datos_apellido" readonly  value=""  >
													</div>
												</div>
											</div>
											<div class=" col-md-4">
												<div class="form-group row p-0" >
													<label for="cod_comprobante" class="col-md-4 col-form-label texto-x12" ><b>NOMBRES:</b></label>
													<div class="col-md-8">
														<input type="text" class="form-control texto-x12" placeholder="" name="datos_nombres" id="datos_nombres" readonly  value=""  >
													</div>
												</div>
											</div>
											<div class=" col-md-8">
												<div class="form-group row p-0" >
													<label for="cod_comprobante" class="col-md-2 col-form-label texto-x12" ><b>DIRECCIÓN:</b></label>
													<div class="col-md-10">
														<input type="text" class="form-control texto-x12" placeholder="" name="datos_seguro" id="datos_seguro" readonly  value=""  >
													</div>
												</div>
											</div>
											<div class=" col-md-4">
												<div class="form-group row p-0" >
													<label for="cod_comprobante" class="col-md-4 col-form-label texto-x12" ><b>TELEFONO:</b></label>
													<div class="col-md-8">
														<input type="text" class="form-control texto-x12" placeholder="" name="datos_cussp" id="datos_cussp" readonly  value=""  >
													</div>
												</div>
											</div>


										</div>


									</div>
								</div>
								<div class="tab-pane" id="op_info" role="tabpanel">
									<div class="container">
										<div class="row">
											<div class="col-md-6 br">
												<h5 class="mt-2 mb-2 titulo_area2" id="titulo_gasto"><em><b>Dias de jornada:</b></em></h5>
												<div class="row">
													<div class=" col-md-12">
														<div class="form-group row p-0" >
															<label for="cod_comprobante" class="col-md-4 col-form-label texto-x12" ><b>Mes Actual:</b></label>
															<div class="col-md-8">
																<input type="text" class="form-control texto-x12 text-center" placeholder="" name="jornada_mes" id="jornada_mes" readonly  value=""  >
															</div>
														</div>
													</div>
													<div class=" col-md-12">
														<div class="form-group row p-0" >
															<label for="cod_comprobante" class="col-md-8 col-form-label texto-x12" ><b>Dias Habiles del Mes Actual:</b></label>
															<div class="col-md-4">
																<input type="text" class="form-control texto-x12 text-center" placeholder="" name="jornada_diaMes" id="jornada_diaMes" readonly  value="0"  >
															</div>
														</div>
													</div>
													<div class=" col-md-12">
														<div class="form-group row p-0" >
															<label for="cod_comprobante" class="col-md-8 col-form-label texto-x12" ><b>Dias Laborados del Mes Actual:</b></label>
															<div class="col-md-4">
																<input type="text" class="form-control texto-x12 text-center" placeholder="" name="jornada_dias_laborados" id="jornada_dias_laborados"   value="0" onkeypress="return SoloNumerosModificado(event,2,this.id);" >
															</div>
														</div>
													</div>
												</div>
											</div>
											<div class="col-md-6">
												<h5 class="mt-2 mb-2 titulo_area2" id="titulo_gasto"><em><b>Dias no Laborados:</b></em></h5>
												<div class="row">
													<div class=" col-md-12">
														<div class="form-group row p-0" >
															<label for="cod_comprobante" class="col-md-9 col-form-label texto-x12" ><b>Dias Subsidiados por Incapacidad Temporal:</b></label>
															<div class="col-md-3">
																<input type="text" class="form-control texto-x12 text-center" placeholder="" name="jornada_dias_inc_temp" id="jornada_dias_inc_temp" value="0" onkeypress="return SoloNumerosModificado(event,2,this.id);" >
															</div>
														</div>
													</div>
													<div class=" col-md-12">
														<div class="form-group row p-0" >
															<label for="cod_comprobante" class="col-md-9 col-form-label texto-x12" ><b>Dias Subsidiados por Maternidad:</b></label>
															<div class="col-md-3">
																<input type="text" class="form-control texto-x12 text-center " placeholder="" name="jornada_dias_maternidad" id="jornada_dias_maternidad" value="0" onkeypress="return SoloNumerosModificado(event,2,this.id);" >
															</div>
														</div>
													</div>
													<div class=" col-md-12">
														<div class="form-group row p-0" >
															<label for="cod_comprobante" class="col-md-9 col-form-label texto-x12" ><b>Dias de Vaciones:</b></label>
															<div class="col-md-3">
																<input type="text" class="form-control texto-x12 text-center " placeholder="" name="jornada_dias_vacaciones" id="jornada_dias_vacaciones" value="0" onkeypress="return SoloNumerosModificado(event,2,this.id);" >
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
										<hr>
										<div class="row">
											<div class="col-md-4">
												<div class="row">
													<div class=" col-md-12">
														<div class="form-group row p-0" >
															<label for="cod_comprobante" class="col-md-7 col-form-label texto-x12" ><b>Total Dias Laborados:</b></label>
															<div class="col-md-5">
																<input type="number" class="form-control texto-x12 text-center" placeholder="" name="jornada_total_laborados" id="jornada_total_laborados"  readonly value="0"  >
															</div>
														</div>
													</div>
												</div>
											</div>
											<div class="col-md-4">
												<div class="row">
													<div class=" col-md-12">
														<div class="form-group row p-0" >
															<label for="jornada_total_subsidiados" class="col-md-7 col-form-label texto-x12" ><b>Total Dias Subsidiados:</b></label>
															<div class="col-md-5">
																<input type="number" class="form-control texto-x12 text-center " placeholder="" name="jornada_total_subsidiados" id="jornada_total_subsidiados"  readonly value="0"  >
															</div>
														</div>
													</div>
												</div>
											</div>
											<div class="col-md-4">
												<div class="row">
													<div class=" col-md-12">
														<div class="form-group row p-0" >
															<label for="jornada_total_nolaborados" class="col-md-7 col-form-label texto-x12" ><b>Total Dias no Laborados:</b></label>
															<div class="col-md-5">
																<input type="number" class="form-control texto-x12 text-center " placeholder="" name="jornada_total_nolaborados" id="jornada_total_nolaborados"  readonly value="0"  >
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>

									</div>
								</div>
								<div class="tab-pane" id="op_cuotas" role="tabpanel">
									<div class="container">
										<div class="row">
											<div class="col-md-6 br">
												<h5 class="mt-2 mb-2 titulo_area3" id="titulo_gasto"><em><b>Ingresos:</b></em></h5>
												<div class="row">
													<div class=" col-md-12">
														<div class="form-group row p-0" >
															<label for="ingreso_base" class="col-md-8 col-form-label texto-x12" ><b>Sueldo Base:</b></label>
															<div class="col-md-4">
																<input type="text" class="form-control texto-x12 text-center" placeholder="" name="ingreso_base" id="ingreso_base" readonly  value="S/. 0.00"  >
															</div>
														</div>
													</div>
													<div class=" col-md-12">
														<div class="form-group row p-0" >
															<label for="ingreso_base" class="col-md-8 col-form-label texto-x12" ><b>Sueldo neto:</b></label>
															<div class="col-md-4">
																<input type="text" class="form-control texto-x12 text-center" placeholder="" name="ingreso_neto" id="ingreso_neto" readonly  value="S/. 0.00"  >
															</div>
														</div>
													</div>
													<div class=" col-md-12">
														<div class="form-group row p-0" >
															<label for="ingreso_asignacion" class="col-md-8 col-form-label texto-x12" ><b>Importe Asignación Familiar:</b></label>
															<div class="col-md-4">
																<input type="text" class="form-control texto-x12 text-center" placeholder="" name="ingreso_asignacion" id="ingreso_asignacion" readonly  value="S/. 0.00" readonly >
															</div>
														</div>
													</div>


												</div>
											</div>
											<div class="col-md-6">
												<h5 class="mt-2 mb-2 titulo_area3" id="titulo_gasto"><em><b>Otros Ingresos:</b></em></h5>
												<div class="row">
													<div class=" col-md-12">
														<div class="form-group row p-0" >
														<label for="ingreso_grati" class="col-md-8 col-form-label texto-x12" ><b>Gratificación:</b></label>
														<div class="col-md-4">
															<input type="text" class="form-control texto-x12 text-center" placeholder="" name="ingreso_grati" id="ingreso_grati"   value="0"  onkeypress="return SoloNumerosModificado(event,7,this.id);">
														</div>
														</div>
													</div>
													<div class=" col-md-12">
														<div class="form-group row p-0" >
															<label for="ingreso_bonificacion" class="col-md-8 col-form-label texto-x12" ><b>Bonificación:</b></label>
															<div class="col-md-4">
																<input type="text" class="form-control texto-x12 text-center" placeholder="" name="ingreso_bonificacion" id="ingreso_bonificacion"   value="0"  onkeypress="return SoloNumerosModificado(event,7,this.id);">
															</div>
														</div>
													</div>
													<div class=" col-md-12">
														<div class="form-group row p-0" >
															<label for="ingreso_comp" class="col-md-8 col-form-label texto-x12" ><b>Compensación por Tiempo de Servicio (CTS):</b></label>
															<div class="col-md-4">
																<input type="text" class="form-control texto-x12 text-center" placeholder="" name="ingreso_comp" id="ingreso_comp"   value="0"  onkeypress="return SoloNumerosModificado(event,7,this.id);">
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>


									</div>
								</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="row m-2">
					<div class="col-md-2  p-3">
						<button class="btn btn-success btn-sm btn-block">GUARDAR</button>
					</div>
					<div class="col-md-2 offset-8 p-3">
						<button class="btn btn-danger btn-sm btn-block">SALIR</button>
					</div>
				</div>

			</div>
		</div>
	</form>
</div>


<script src="<?php echo $conexionConfig->rutaOP(); ?>vista/js/MantAlumno.js"></script>
