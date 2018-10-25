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
              <div>Mantenimiento TipoPagos</div>
            </div> -->
        <!-- START card-->
        <div class="card card-default m-1 ">
            <div class="card-body ">
                <div class="row ">
                    <div class="col-md-12 w-100 text-center ">
                        <h3>Mantenimiento de TipoPago de Pago:</h3>
                    </div>
                </div>
                <hr class="mt-2 mb-2">
                <div class="row">
                    <div class="col-md-2 offset-10">
                        <button class="btn btn-success btn-block btn-sm" onclick="NuevoTipoPago();"><i class="fa fa-plus fa-lg mr-2"></i> Nueva TipoPago</button>
                    </div>
                </div>
                <h5 class="mt-3 mb-3 titulo_area"><em><b>Lista General de TipoPago:</b></em></h5>
                <div class="row ">
                    <div class="col-md-12">
                        <div class="row">
                            <div class="col-md-12">
                                <table class="table w-100 table-hover table-sm dt-responsive nowrap" id="tablaTipoPago">
                                    <thead class="thead-light text-center">
                                        <tr>
                                            <th data-priority="1">#</th>
                                            <th>ESTADO</th>
                                            <th>NOMBRE DE PAGO</th>
                                            <th>MONTO</th>
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

<div class="modal fade " id="ModalTipoPago" role="dialog" aria-labelledby="myModalLabelLarge" aria-hidden="true">
    <div class="modal-dialog modal-lg  ">
        <div class="modal-content">
            <div class="row m-1 bb">
                <div class="col-md-12">
                    <h4 class="text-center text-" id="tituloModalTipoPago"></h4>
                </div>
            </div>
            <div class="modal-body ">
                <form id="FormularioTipoPago" method="POST" autocomplete="off">
                    <input type="hidden" name="idTipoPago" id="idTipoPago">
                    <div class="row mb-3 mt-1">
                        <div class="col-md-3">
                            <label class=""><span class="red">(*) Campos Obligatorios</span></label>
                        </div>
                        <div class="col-md-1 offset-8">
                            <button type="button" class="btn btn-info btn-sm btn-display" title="Limpiar Campos" onclick="LimpiarTipoPago();">
                                <i class="fa fa-trash-alt fa-lg "></i>
                            </button>
                        </div>
                    </div>
                    <div class="row" id="cuerpo">
                        <div class="col-md-12   bl">
                            <div class="row">
                                <div class="col-md-12">
                                    <label for="TipoPagoNombre" class="  col-form-label"> Tipo de Pago<span class="red">*</span>:</label>
                                    <input class="form-control validarPanel" id="TipoPagoNombre" name="TipoPagoNombre" data-message="- Campo  Tipo de Pago" placeholder="Tipo de Pago" type="text" maxlength="100">
                                </div>
                                <div class="col-md-6">
                                    <label for="TipoPagoImporte" class="  col-form-label">Monto de Pago<span class="red">*</span>:</label>
                                    <input class="form-control validarPanel" id="TipoPagoImporte" name="TipoPagoImporte" data-message="- Campo  Monto" placeholder="Monto" type="text"   onkeypress="return SoloNumerosModificado(event,7,this.id);">
                                </div>
                                <div class="col-md-6">
                                    <label for="TipoPagoCuota" class="  col-form-label">Cuota<span class="red">*</span>:</label>
                                    <input class="form-control validarPanel" id="TipoPagoCuota" name="TipoPagoCuota" data-message="- Campo  Numero de Cuotas" placeholder="Numero de Cuotas" type="text"  onkeypress="return SoloNumerosModificado(event,7,this.id);">
                                </div>
                                <div class="col-md-6 ">

                                        <label for="TipoPagoEstado" class=" col-form-label"> Estado<span class="red">*</span>:</label>

                                    <select class="form-control validarPanel" id="TipoPagoEstado" name="TipoPagoEstado" data-message="- Campo Estado"></select>

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


<script src="<?php echo $conexionConfig->rutaOP(); ?>vista/js/MantTipoPago.js"></script>
