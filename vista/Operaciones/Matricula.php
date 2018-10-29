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
                        <h3>Panel de Matricula:</h3>
                    </div>
                </div>
                <hr>


                <div class="row" id="OpcionEmpleado">
                    <div class="col-md-12">
                        <div class="row justify-content-center">

                            <div class="col-md-3 form-group ml-3 br bl bt bb p-2 sombra2">
                                <label>Seleccione Año:</label>
                                <select class="form-control m-0 p-0 bg bg-gray-light" id="yearSelect" name="yearSelect" style="widht:10px;height:30px;font-size:12px;">

                                </select>
                            </div>
                            <div class="col-md-8 mt-3">
                                <div class="input-group input-group-lg">
                                    <input class="form-control form-control-lg rounded-0" type="text" name="term" placeholder="Buscar Alumno Matriculado" id="buscador_alumno">

                                    <div class="input-group-append">
                                        <button class="btn btn-info btn-lg b0 rounded-0" type="button">
                                            <i class="fa fa-search fa-lg"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>

                        </div>

                    </div>

                </div>
                <hr>


                <h5 class="mt-3 mb-3 titulo_area"><em><b>Información General:</b></em></h5>
                <div class="row ">
                    <div class="col-md-12">
                        <div class="row">
                            <div class="col-md-12">
                                <table class="table w-100 table-hover table-sm dt-responsive nowrap" id="tablaMatricula" style="font-size:13px">
                                    <thead class="thead-light text-center">

                                        <tr>
                                            <th data-priority="1">#</th>
                                            <th>ESTADO</th>
                                            <th>FOTO</th>
                                            <th>ALUMNOS</th>
                                            <th>DNI</th>
                                            <th>FECHA DE NACIMIENTO</th>
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
                <hr>
                <div class="row m-2">
                    <button class="btn btn-info " onclick="volver();">VOLVER</button>
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

<div class="modal fade" id="ModalMatricula" role="dialog" aria-labelledby="myModalLabelLarge" aria-hidden="true">
    <form id="FormularioMatricula" method="POST" autocomplete="off">
        <input type="hidden" id="O_idPersona" name="O_idPersona">
        <input type="hidden" id="O_idAlumno" name="O_idAlumno">
        <input type="hidden" id="year_Actual" name="year_Actual">
        <input type="hidden" id="matricula" name="matricula">



        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="row mr-1 ml-1">
                    <div class="col-md-6 br bb mb-1 ">
                        <label class=" texto-x10 text-muted  m-0 text-center">SISTEMA: </label>
                        <span class="texto-x12 text-muted  text-center"><b>MATRICULA</b></span>
                    </div>
                    <div class="col-md-6   bb mb-1 ">
                        <label class=" texto-x10 text-muted  m-0 text-center">OPERACION: </label>
                        <span class=" texto-x12 text-muted  text-center" id="titulo_cabecera"><b>REGISTRO DE MATRICULA</b></span>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-xl-12">
                            <div role="tabpanel">
                                <ul class="nav nav-pills " role="tablist">
                                    <li class="nav-item pill-1 m-2 " role="presentation"><a class="nav-link active panelBoton" href="#op_datos" aria-controls="home" role="tab" data-toggle="tab" id="menu1">Datos del Alumno</a>
                                    </li>
                                    <li class="nav-item pill-2 m-2" role="presentation"><a class="nav-link panelBoton" href="#op_info" aria-controls="profile" role="tab" data-toggle="tab">Pagos del Alumno</a>
                                    </li>
                                    <li class="nav-item pill-3 m-2" role="presentation"><a class="nav-link panelBoton" href="#op_cuotas" aria-controls="messages" role="tab" data-toggle="tab">Pensiones del Alumno</a>
                                    </li>

                                </ul>
                                <div class="tab-content">
                                    <div class="tab-pane active  panelAccion" id="op_datos" role="tabpanel">
                                        <div class="container contenedor_modal" >
                                            <h5 class="mt-2 mb-2 titulo_area" id="titulo_gasto"><em><b>Datos Personales:</b></em></h5>
                                            <div class="row ">
                                                <div class=" col-md-4">
                                                    <div class="form-group row p-0">
                                                        <label for="datos_dni" class="col-md-4 col-form-label texto-x12"><b>Nº DNI:</b></label>
                                                        <div class="col-md-8">
                                                            <input type="text" class="form-control texto-x12" placeholder="" name="datos_dni" id="datos_dni" readonly value="">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class=" col-md-4">
                                                    <div class="form-group row p-0">
                                                        <label for="datos_apellido" class="col-md-4 col-form-label texto-x12"><b>APELLIDOS:</b></label>
                                                        <div class="col-md-8">
                                                            <input type="text" class="form-control texto-x12" placeholder="" name="datos_apellido" id="datos_apellido" readonly value="">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class=" col-md-4">
                                                    <div class="form-group row p-0">
                                                        <label for="datos_nombres" class="col-md-4 col-form-label texto-x12"><b>NOMBRES:</b></label>
                                                        <div class="col-md-8">
                                                            <input type="text" class="form-control texto-x12" placeholder="" name="datos_nombres" id="datos_nombres" readonly value="">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class=" col-md-8">
                                                    <div class="form-group row p-0">
                                                        <label for="datos_direccion" class="col-md-2 col-form-label texto-x12"><b>DIRECCIÓN:</b></label>
                                                        <div class="col-md-10">
                                                            <input type="text" class="form-control texto-x12" placeholder="" name="datos_direccion" id="datos_direccion" readonly value="">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class=" col-md-4">
                                                    <div class="form-group row p-0">
                                                        <label for="datos_telefono" class="col-md-4 col-form-label texto-x12"><b>TELEFONO:</b></label>
                                                        <div class="col-md-8">
                                                            <input type="text" class="form-control texto-x12" placeholder="" name="datos_telefono" id="datos_telefono" readonly value="">
                                                        </div>
                                                    </div>
                                                </div>


                                            </div>
                                            <h5 class="mt-2 mb-2 titulo_area" id="titulo_gasto"><em><b>Selección de Nivel Escolar:</b></em></h5>
                                            <div class="row">
                                                <div class=" col-md-4">
                                                    <div class="form-group row p-0">
                                                        <label for="AlumnoNivel" class="col-md-4 col-form-label texto-x12"><b>NIVEL:</b></label>
                                                        <div class="col-md-8">
                                                            <select class="form-control validarPanel" id="AlumnoNivel" name="AlumnoNivel" data-message="- Nivel"> </select>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class=" col-md-4">
                                                    <div class="form-group row p-0">
                                                        <label for="AlumnoGrado" class="col-md-4 col-form-label texto-x12"><b>GRADO:</b></label>
                                                        <div class="col-md-8">
                                                            <select class="form-control validarPanel" id="AlumnoGrado" name="AlumnoGrado" data-message="- Nivel"> </select>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class=" col-md-4">
                                                    <div class="form-group row p-0">
                                                        <label for="AlunnoSeccion" class="col-md-4 col-form-label texto-x12"><b>SECCION:</b></label>
                                                        <div class="col-md-8">
                                                            <select class="form-control validarPanel" id="AlunnoSeccion" name="AlunnoSeccion" data-message="- Nivel"> </select>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>


                                        </div>
                                    </div>
                                    <div class="tab-pane panelAccion" id="op_info" role="tabpanel">
                                        <div class="container contenedor_modal">

                                            <h5 class="mt-2 mb-2 titulo_area2" id="titulo_gasto"><em><b>Seleccione Pagos del Alumno:</b></em></h5>

                                            <div class="row" id="area_tabla_pagos">
                                                <table class="table w-100 table-hover table-sm dt-responsive nowrap" id="tablaPagos">
                                                    <thead class="thead-light text-center">
                                                        <tr>
                                                            <th data-priority="1"></th>
                                                            <th>TIPO DE PAGO</th>
                                                            <th>IMPORTE</th>
                                                            <th>CUOTAS</th>
                                                            <th>ACCION</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                    </tbody>
                                                </table>

                                            </div>


                                        </div>
                                    </div>
                                    <div class="tab-pane panelAccion" id="op_cuotas" role="tabpanel">
                                        <div class="container contenedor_modal">

                                            <div class="row mt-3">

                                                <div class="col-md-8 ">
                                                    <div class="form-group row">
                                                        <label for="planPensiones" class="col-md-6 col-form-label titulo">Seleccione Plan de Pensiones:</label>
                                                        <div class="col-md-6">
                                                            <select class="form-control m-0 p-0 bg bg-gray-light" id="planPensiones" name="planPensiones">
                                                                <option value="0"> -- SELECCIONE -- </option>
                                                                <option value="1">PLAN ANUAL (MARZO - DICIEMBRE)</option>
                                                                <option value="2">PLAN EXTEMPORANEA (JULIO - DICIEMBRE)</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-4 form-group">
                                                    <button type="button" class="btn btn-warning btn-sm  " title="Agregar Plan de Pensiones" onclick="AgregarPlanPensiones();" id="button_nueva_cuota">
                                                        Agregar Plan de Pensiones
                                                    </button>
                                                </div>
                                            </div>


                                            <div class="row">
                                                <div class="col-md-12">
                                                    <h5 class="mt-2 mb-2 titulo_area3" id="titulo_gasto"><em><b>Listado de Pensiones del Alumno:</b></em></h5>

                                                    <div class="row">
                                                        <table class="table w-100 table-hover table-sm dt-responsive nowrap" id="tablaCuotas">
                                                            <thead class="thead-light text-center">
                                                                <tr>
                                                                    <th data-priority="1">NUM.</th>
                                                                    <th>ESTADO</th>
                                                                    <th>IMPORTE</th>
                                                                    <th>DIFERENCIA</th>
                                                                    <th>MES</th>
                                                                    <th>FECHA INICIO</th>
                                                                    <th>FECHA VENCIMIENTO</th>
                                                                    <th>AÑO</th>
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
                        </div>
                    </div>
                </div>
                <div class="row m-2">

                    <div class="col-md-2 p-3">
                        <button type="button" class="btn btn-primary btn-sm btn-block" onclick="Salir();">SALIR</button>
                    </div>
                    <div class="col-md-3 offset-7  p-3">
                        <button type="button" class="btn btn-success btn-sm btn-block" onclick="MatricularAlumno();">GUARDAR MATRICULA</button>
                    </div>
                </div>

            </div>
        </div>
    </form>
</div>


<script src="<?php echo $conexionConfig->rutaOP(); ?>vista/js/Matricula.js"></script>
