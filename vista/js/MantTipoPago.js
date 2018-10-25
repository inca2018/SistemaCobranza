var tablaTipoPago;
function init(){
   Iniciar_Componentes();
   Listar_TipoPago();
   Listar_Estado();
}
function Iniciar_Componentes(){
   //var fecha=hoyFecha();

	//$('#date_fecha_comprobante').datepicker('setDate',fecha);

    $("#FormularioTipoPago").on("submit",function(e)
	{
	      RegistroTipoPago(e);
	});

}
function RegistroTipoPago(event){
	  //cargar(true);
	event.preventDefault(); //No se activará la acción predeterminada del evento
    var error="";

    $(".validarPanel").each(function(){
			if($(this).val()==" " || $(this).val()==0){
				error=error+$(this).data("message")+"<br>";
			}
    });

    if(error==""){
		$("#ModalTipoPago #cuerpo").addClass("whirl");
		$("#ModalTipoPago #cuerpo").addClass("ringed");
		setTimeout('AjaxRegistroTipoPago()', 2000);
	}else{
 		notificar_warning("Complete :<br>"+error);
	}
}
function AjaxRegistroTipoPago(){
    var formData = new FormData($("#FormularioTipoPago")[0]);
		console.log(formData);
		$.ajax({
			url: "../../controlador/Mantenimiento/CTipoPago.php?op=AccionTipoPago",
			 type: "POST",
			 data: formData,
			 contentType: false,
			 processData: false,
			 success: function(data, status)
			 {
					data = JSON.parse(data);
					console.log(data);
					var Mensaje=data.Mensaje;
				 	var Error=data.Registro;
					if(!Error){
						$("#ModalTipoPago #cuerpo").removeClass("whirl");
						$("#ModalTipoPago #cuerpo").removeClass("ringed");
						$("#ModalTipoPago").modal("hide");
						swal("Error:", Mensaje);
						LimpiarTipoPago();
						tablaTipoPago.ajax.reload();
					}else{
						$("#ModalTipoPago #cuerpo").removeClass("whirl");
						$("#ModalTipoPago #cuerpo").removeClass("ringed");
						$("#ModalTipoPago").modal("hide");
					   swal("Acción:", Mensaje);
						LimpiarTipoPago();
						tablaTipoPago.ajax.reload();
					}
			 }
		});
}
function Listar_Estado(){
	 $.post("../../controlador/Mantenimiento/CTipoPago.php?op=listar_estados", function (ts) {
      $("#TipoPagoEstado").append(ts);
   });
}
function Listar_TipoPago(){

	tablaTipoPago = $('#tablaTipoPago').dataTable({
		"aProcessing": true,
		"aServerSide": true,
		"processing": true,
		"paging": true, // Paginacion en tabla
		"ordering": true, // Ordenamiento en columna de tabla
		"info": false, // Informacion de cabecera tabla
		"responsive": true, // Accion de responsive
          dom: 'lBfrtip',
        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
          "order": [[0, "asc"]],

		"bDestroy": true
        , "columnDefs": [
            {
               "className": "text-center"
               , "targets": [1,4,5]
            }
            , {
               "className": "text-left"
               , "targets": [0,2]
            },{
               "className": "text-right"
               , "targets": [3]
            }
         , ]
         , buttons: [
            {
               extend: 'copy'
               , className: 'btn-info'
            }
            , {
               extend: 'csv'
               , className: 'btn-info'
            }
            , {
               extend: 'excel'
               , className: 'btn-info'
               , title: 'Facturacion'
            }
            , {
               extend: 'pdfHtml5'
               , className: 'btn-info sombra3'
               , title: "Reporte de TipoPagos"
               ,orientation: 'landscape'
               ,pageSize: 'LEGAL'
            }
            , {
               extend: 'print'
               , className: 'btn-info'
            }
            ],
        "ajax": { //Solicitud Ajax Servidor
			url: '../../controlador/Mantenimiento/CTipoPago.php?op=Listar_TipoPago',
			type: "POST",
			dataType: "JSON",
			error: function (e) {
				console.log(e.responseText);
			}
		},
		// cambiar el lenguaje de datatable
		oLanguage: español,
	}).DataTable();
	//Aplicar ordenamiento y autonumeracion , index
	tablaTipoPago.on('order.dt search.dt', function () {
		tablaTipoPago.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
}
function NuevoTipoPago(){
    $("#ModalTipoPago").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalTipoPago").modal("show");
    $("#tituloModalTipoPago").empty();
    $("#tituloModalTipoPago").append("Nueva TipoPago:");
}
function EditarTipoPago(idTipoPago){
    $("#ModalTipoPago").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalTipoPago").modal("show");
    $("#tituloModalTipoPago").empty();
    $("#tituloModalTipoPago").append("Editar TipoPago:");
	RecuperarTipoPago(idTipoPago);
}
function RecuperarTipoPago(idTipoPago){
	//solicitud de recuperar Proveedor
	$.post("../../controlador/Mantenimiento/CTipoPago.php?op=RecuperarInformacion_TipoPago",{"idTipoPago":idTipoPago}, function(data, status){
		data = JSON.parse(data);
		console.log(data);

	$("#idTipoPago").val(data.idTipoTipoPago);
	$("#TipoPagoNombre").val(data.NombrePago);
    $("#TipoPagoImporte").val(data.Monto);
    $("#TipoPagoCuota").val(data.Cuotas);
	$("#TipoPagoEstado").val(data.Estado_idEstado);

	});
}
function EliminarTipoPago(idTipoPago){
      swal({
      title: "Eliminar?",
      text: "Esta Seguro que desea Eliminar TipoPago!",
      type: "warning",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Eliminar!",
      closeOnConfirm: false
   }, function () {
      ajaxEliminarTipoPago(idTipoPago);
   });
}
function ajaxEliminarTipoPago(idTipoPago){
    $.post("../../controlador/Mantenimiento/CTipoPago.php?op=Eliminar_TipoPago", {idTipoPago: idTipoPago}, function (data, e) {
      data = JSON.parse(data);
      var Error = data.Error;
      var Mensaje = data.Mensaje;
      if (Error) {
         swal("Error", Mensaje, "error");
      } else {
         swal("Eliminado!", Mensaje, "success");
         tablaTipoPago.ajax.reload();
      }
   });
}
function HabilitarTipoPago(idTipoPago){
      swal({
      title: "Habilitar?",
      text: "Esta Seguro que desea Habilitar TipoPago!",
      type: "info",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Habilitar!",
      closeOnConfirm: false
   }, function () {
      ajaxHabilitarTipoPago(idTipoPago);
   });
}
function ajaxHabilitarTipoPago(idTipoPago){
       $.post("../../controlador/Mantenimiento/CTipoPago.php?op=Recuperar_TipoPago", {idTipoPago: idTipoPago}, function (data, e) {
      data = JSON.parse(data);
      var Error = data.Error;
      var Mensaje = data.Mensaje;
      if (Error) {
         swal("Error", Mensaje, "error");
      } else {
         swal("Eliminado!", Mensaje, "success");
         tablaTipoPago.ajax.reload();
      }
   });
}
function LimpiarTipoPago(){
   $('#FormularioTipoPago')[0].reset();
	$("#idTipoPago").val("");

}
function Cancelar(){
    LimpiarTipoPago();
    $("#ModalTipoPago").modal("hide");
}


init();
