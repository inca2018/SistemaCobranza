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
                 <input type="hidden" id="oculto_importe_pagar" name="oculto_importe_pagar" value="0">
                 <input type="hidden" id="oculto_importe_total" name="oculto_importe_total" value="0">
                 <input type="hidden" id="oculto_importe_vuelto" name="oculto_importe_vuelto" value="0">
                <div class="row ">
                    <div class="col-md-12 w-100 text-center ">
                        <h3>Pago Matricula:</h3>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2 form-group ml-3 br bl bt bb p-2 sombra2">
                        <label>Seleccione Año:</label>
                        <select class="form-control m-0 p-0 bg bg-gray-light" id="yearSelect" name="yearSelect" style="widht:10px;height:30px;font-size:12px;">
                        </select>
                    </div>
                </div>

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


                        </form>
                    </div>
                    <div class="col-lg-6">
                        <p class="lead bb">Información Academica</p>
                        <form class="form-horizontal">

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
                </div>
                <hr>
                <div class="row">
                    <div class="col-md-6 br">
                        <p class="lead bb">Pagos Pendientes:</p>

                        <div role="tabpanel">
                            <ul class="nav nav-pills " role="tablist">
                                <li class="nav-item pill-1 m-2 " role="presentation"><a class="nav-link active panelBoton" href="#op_datos" aria-controls="home" role="tab" data-toggle="tab" id="menu1">Pagos de Matricula</a>
                                </li>
                                <li class="nav-item pill-2 m-2" role="presentation"><a class="nav-link panelBoton" href="#op_info" aria-controls="profile" role="tab" data-toggle="tab">Pensiones</a>
                                </li>


                            </ul>
                            <div class="tab-content">
                                <div class="tab-pane active  panelAccion" id="op_datos" role="tabpanel">
                                    <div class="container contenedor_modal">
                                        <div class="row">
                                            <div class="col-md-4 offset-8">
                                                <label>Seleccionar Todos:
                                                    <input type="checkbox" class="seleccion_pagos" id="Selector_matricula">
                                                </label>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-12">
                                                <table class="table w-100 table-hover table-sm dt-responsive nowrap" id="tablaDeudas1" style="font-size:11px">
                                                    <thead class="thead-light text-center">

                                                        <tr>
                                                            <th data-priority="1">#</th>
                                                            <th>SELECCION</th>
                                                            <th>ESTADO</th>
                                                            <th>PAGO</th>
                                                            <th>IMPORTE</th>
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
                                <div class="tab-pane panelAccion" id="op_info" role="tabpanel">
                                    <div class="container contenedor_modal">
                                        <div class="row">
                                            <div class="col-md-4 offset-8">
                                                <label>Seleccionar Todos:
                                                    <input type="checkbox" class="seleccion_pagos" id="Selector_pensiones">
                                                </label>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-12">
                                                <table class="table w-100 table-hover table-sm dt-responsive " id="tablaDeudas2" style="font-size:11px">
                                                    <thead class="thead-light text-center">
                                                        <tr>
                                                            <th width="5%"  data-priority="1">#</th>
                                                            <th width="5%" >*</th>
                                                            <th width="15%" >ESTADO</th>
                                                            <th width="15%" >PAGO</th>
                                                            <th width="15%" >IMPORTE</th>
                                                            <th width="5%" >D.MORA</th>
                                                            <th width="15%" >MORA</th>
                                                            <th width="15%" >F.V.</th>
                                                            <th width="10%" >ACCION</th>
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
                        <div class="row mt-3">
                            <div class="col-md-3 offset-9">
                                <button class="btn btn-success btn-block " onclick="AgregarPagos();">AGREGAR PAGOS</button>
                            </div>
                        </div>

                    </div>
                    <div class="col-md-6">
                        <div class="row">
                        	<div class="col-md-3 form-group">
                        			<label for="" class=" form-label">Monto Total:</label>
                        		   <input class="form-control" id="v_importe_total" name="v_importe_total"  type="text" maxlength="50" readonly>
                        	</div>
                        	<div class="col-md-3">
                        		<label for="" class=" form-label">Monto a Pagar:</label>
                        		<input class="form-control" id="m_importe_pagar_cliente" name="m_importe_pagar_cliente"  type="text" maxlength="50" onkeypress="return SoloNumerosModificado(event,5,this.id);" value="S/. 0.00">
                        	</div>
                        	<div class="col-md-3">
                        		<label for="" class=" form-label">Vuelto:</label>
                        		<input class="form-control" id="m_importe_vuelto" name="m_importe_vuelto"  type="text" maxlength="50" onkeypress="return SoloNumerosModificado(event,5,this.id);" value="S/. 0.00" readonly>
                        	</div>
                        	<div class="col-md-3 mt-4">
                        	   <button type="button" class="btn btn-success btn-block" onclick="AbrirPago();">PAGAR</button>
                        	</div>
                        </div>
                        <p class="lead bb">Pagos a Pagar:</p>
                        <div class="row">
                            <div class="col-md-12">
                                <table class="table w-100 table-hover table-sm dt-responsive" id="tablaPagar" style="font-size:11px">
                                    <thead class="thead-light text-center">
                                        <tr class="text-center">
                                            <th data-priority="1">#</th>
                                            <th>TIPO PAGO</th>
                                            <th>IMPORTE A PAGAR</th>
                                            <th>ESTADO</th>
                                        </tr>
                                    </thead>
                                    <tbody>

                                    </tbody>

                                </table>
                            </div>

                        </div>
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

<div class="modal fade " id="ModalPago" role="dialog" aria-labelledby="myModalLabelLarge" aria-hidden="true">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="row m-1 bb">
                <div class="col-md-12">
                    <h4 class="text-center text-" id="">PAGAR</h4>
                </div>
            </div>
            <div class="modal-body" id="ModuloPago">
                <form id="FormularioPago" method="POST" autocomplete="off">
                    <input type="hidden" name="idAlumnoP" id="idAlumnoP">
                    <input type="hidden" name="yearP" id="yearP">
                    <input type="hidden" name="importePago" id="importePago">
                    <input type="hidden" name="importeMora" id="importeMora">

                    <input type="hidden" name="codigoPago" id="codigoPago">
                    <input type="hidden" name="TipoPago" id="TipoPago">

                    <input type="hidden" name="pagar_importe" id="pagar_importe" value="0">
                    <input type="hidden" name="pagar_importe_mora" id="pagar_importe_mora" value="0">

                     <input type="hidden" name="tituloPago" id="tituloPago" value="0">
                    <div class="row">
                        <div class="col-md-12 form-group">
                            <label for="m_importe" class=" col-form-label">Importe:</label>
                            <input class="form-control" id="m_importe" name="m_importe"  type="text" maxlength="50" readonly>
                        </div>
                        <div class="col-md-12 form-group">
                            <label for="NivelNombre" class="  col-form-label">Monto a Pagar:</label>
                            <input class="form-control" id="m_importe_pagar" name="m_importe_pagar"  type="text" maxlength="50" onkeypress="return SoloNumerosModificado(event,5,this.id);">
                        </div>

                    </div>
                    <div class="row" id="modulo_mora" style="display:none">
                         <div class="col-md-12 form-group">
                            <label for="NivelNombre" class=" col-form-label">Importe de Mora:</label>
                            <input class="form-control" id="m_importe_mora" name="m_importe_mora"  type="text" maxlength="50" readonly>
                        </div>
                        <div class="col-md-12 form-group">
                            <label for="NivelNombre" class="  col-form-label">Monto de Mora a Pagar:</label>
                            <input class="form-control" id="m_importe_mora_pagar"   type="text" maxlength="50" onkeypress="return SoloNumerosModificado(event,5,this.id);">
                        </div>
                    </div>
                    <div class="row" >
                        <div class="col-md-12 form-group">
                            <button type="submit" class="btn btn-success  btn-block" title="Guardar">
                                <i class="fa fa-save fa-lg mr-2"></i>AGREGAR
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>



<script src="<?php echo $conexionConfig->rutaOP(); ?>vista/js/PagoMatricula.js"></script>
