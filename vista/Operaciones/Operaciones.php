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
				<input type="hidden" id="PerfilCodigo" value="<?php echo $_SESSION['perfil'];?>">
				<input type="hidden" id="idUsuario" value="<?php echo $_SESSION['idUsuario'];?>">
				<div class="card sombra2 ">
					<div class="card-body" id="modulo_empleado"  style="display:none">
						<div class="row ">
							<div class="col-md-12 w-100 text-center ">
								<h3>Panel de Control:</h3> </div>
						</div>
						<hr class="mt-2 mb-2">
						<div class="row">
							<div class="col-md-12">
								<div class="row">
									<div class="col-xl-3 col-lg-6">
										<!-- START card-->
										<div class="card bg-info-dark border-0 sombra1">
											<div class="card-header">
												<div class="row align-items-center">
													<div class="col-3"> <em class="fa fa-child fa-4x"></em> </div>
													<div class="col-9 text-right">
														<div class="text-lg" id="total_alumnos">0</div>
														<h4>
													<p class="m-0">Alumnos</p>
												</h4> </div>
												</div>
											</div>
											<a class="card-footer p-2 bg-info  bt0 clearfix btn-block d-flex" href="#" onclick="MostrarGestionAlumnos();"> <span>Gestión</span> <span class="ml-auto">
											<em class="fa fa-chevron-circle-right"></em>
										</span> </a>
											<!-- END card-->
										</div>
									</div>
									<div class="col-xl-3 col-lg-6">
										<!-- START card-->
										<div class="card bg-warning-dark border-0 sombra1">
											<div class="card-header">
												<div class="row align-items-center">
													<div class="col-3"> <em class="fas fa-male fa-4x"></em> </div>
													<div class="col-9 text-right">
														<div class="text-lg" id="total_apoderados">0</div>
														<h4>
													<p class="m-0"></p>Apoderados
												</h4> </div>
												</div>
											</div>
											<a class="card-footer p-2 bg-warning bt0 clearfix btn-block d-flex" href="#" onclick="MostrarGestionApoderados();"> <span>Gestión</span> <span class="ml-auto">
											<em class="fa fa-chevron-circle-right"></em>
										</span> </a>
										</div>
										<!-- END card-->
									</div>
									<div class="col-xl-3 col-lg-6">
										<!-- START card-->
										<div class="card bg-green-dark border-0 sombra1">
											<div class="card-header">
												<div class="row align-items-center">
													<div class="col-3"> <em class="far fa-money-bill-alt fa-4x"></em> </div>
													<div class="col-9 text-right">
														<div class="text-lg" id="ind_empleados_operaciones">0</div>
														<h4>
													<p class="m-0">Cuotas Pagadas Hoy</p>
												</h4> </div>
												</div>
											</div>
											<a class="card-footer p-2 bg-green  bt0 clearfix btn-block d-flex" href="#" onclick="MostrarOperaciones();"> <span>Detalles</span> <span class="ml-auto">
											<em class="fa fa-chevron-circle-right"></em>
										</span> </a>
										</div>
										<!-- END card-->
									</div>
									<div class="col-xl-3 col-lg-6">
										<!-- START card-->
										<div class="card bg-danger-dark border-0 sombra1">
											<div class="card-header">
												<div class="row align-items-center">
													<div class="col-3"> <em class="far fa-money-bill-alt fa-4x"></em> </div>
													<div class="col-9 text-right">
														<div class="text-lg" id="ind_asignado">0</div>
														<h4>
													<p class="m-0">Cuotas Vencidas</p>
												</h4> </div>
												</div>
											</div>
											<a class="card-footer p-2 bg-danger-light  bt0 clearfix btn-block d-flex" href="#" onclick="MostrarInformacionAsignado();"> <span>Detalles</span> <span class="ml-auto">
											<em class="fa fa-chevron-circle-right"></em>
										</span> </a>
										</div>
										<!-- END card-->
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-2 offset-10">
								<button class="btn btn-info btn-block" type="button" onclick="MatricularAlumnos();"><i class="fab fa-monero mr-2"></i>MATRICULAR</button>
							</div>
						</div>
						<h5 class="mt-3 mb-3 titulo_area"><em><b>Información General:</b></em></h5>
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
													<th>PAGOS</th>
												</tr>
											</thead>
											<tbody> </tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="card-body" id="modulo_alumno" style="display:none">
						<div class="row ">
							<div class="col-md-12 w-100 text-center ">
								<h3>Información de Pagos:</h3> </div>
						</div>
						<hr class="mt-2 mb-2">
						<h5 class="mt-3 mb-3 titulo_area"><em><b>Información de Matricula:</b></em></h5>
						<div class="row">
							<div class="col-lg-6">
								<p class="lead bb">Información del Alumno</p>
								<form class="form-horizontal">
									<div class="form-group row">
										<div class="col-md-4">DNI:</div>
										<div class="col-md-8" id="info_alu_dni"> <strong>-</strong> </div>
									</div>
									<div class="form-group row">
										<div class="col-md-4">Nombres y Apellidos:</div>
										<div class="col-md-8" id="info_alu_nombres"> <strong>-</strong> </div>
									</div>
								</form>
							</div>
							<div class="col-lg-6">
								<p class="lead bb">Información Academica</p>
								<form class="form-horizontal">
									<div class="form-group row">
										<div class="col-md-4">Nivel:</div>
										<div class="col-md-8" id="info_alu_nivel"> <strong>-</strong> </div>
									</div>
									<div class="form-group row">
										<div class="col-md-4">Grado y Sección:</div>
										<div class="col-md-8" id="info_alu_grado"> <strong>-</strong> </div>
									</div>
								</form>
							</div>
						</div>
						<div class="row">
							<div class="col-md-2 form-group ml-3 br bl bt bb p-2 sombra2">
								<label>Seleccione Año:</label>
								<select class="form-control m-0 p-0 bg bg-gray-light" id="yearSelect" name="yearSelect" style="widht:10px;height:30px;font-size:12px;"> </select>
							</div>
						</div>
						<div class="row">
							<div class="col-md-6">
								<h5 class="mt-3 mb-3 titulo_area"><em><b>Deudas de Matricula:</b></em></h5>
								<div class="row">
									<div class="col-md-12">
										<table class="table w-100 table-hover table-sm dt-responsive nowrap" id="tablaDeudas1" style="font-size:11px">
											<thead class="thead-light text-center">
												<tr>
													<th data-priority="1">#</th>
													<th>ESTADO</th>
													<th>PAGO</th>
													<th>IMPORTE</th>
												</tr>
											</thead>
											<tbody> </tbody>
										</table>
									</div>
								</div>
							</div>
							<div class="col-md-6">
								<h5 class="mt-3 mb-3 titulo_area"><em><b>Deudas de Pensiones:</b></em></h5>
								<div class="row">
									<div class="col-md-12">
										<table class="table w-100 table-hover table-sm dt-responsive nowrap" id="tablaDeudas2" style="font-size:11px">
											<thead class="thead-light text-center">
												<tr>
													<th width="5%" data-priority="1">#</th>
													<th width="15%">ESTADO</th>
													<th width="15%">PAGO</th>
													<th width="15%">IMPORTE</th>
													<th width="5%">D.MORA</th>
													<th width="15%">MORA</th>
													<th width="15%">F.V.</th>
												</tr>
											</thead>
											<tbody> </tbody>
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
