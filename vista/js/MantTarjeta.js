var tablaTarjeta;
function init(){
   Iniciar_Componentes();
   Listar_Tarjeta();
	Listar_Estado();
}
function Iniciar_Componentes(){
   //var fecha=hoyFecha();

	//$('#date_fecha_comprobante').datepicker('setDate',fecha);

    $("#FormularioTarjeta").on("submit",function(e)
	{
	      RegistroTarjeta(e);
	});

}
function RegistroTarjeta(event){
	  //cargar(true);
	event.preventDefault(); //No se activará la acción predeterminada del evento
    var error="";

    $(".validarPanel").each(function(){
			if($(this).val()==" " || $(this).val()==0){
				error=error+$(this).data("message")+"<br>";
			}
    });

    if(error==""){
		$("#ModalTarjeta #cuerpo").addClass("whirl");
		$("#ModalTarjeta #cuerpo").addClass("ringed");
		setTimeout('AjaxRegistroTarjeta()', 2000);
	}else{
 		notificar_warning("Complete :<br>"+error);
	}
}
function AjaxRegistroTarjeta(){
    var formData = new FormData($("#FormularioTarjeta")[0]);
		console.log(formData);
		$.ajax({
			url: "../../controlador/Mantenimiento/CTarjeta.php?op=AccionTarjeta",
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
						$("#ModalTarjeta #cuerpo").removeClass("whirl");
						$("#ModalTarjeta #cuerpo").removeClass("ringed");
						$("#ModalTarjeta").modal("hide");
						swal("Error:", Mensaje);
						LimpiarTarjeta();
						tablaTarjeta.ajax.reload();
					}else{
						$("#ModalTarjeta #cuerpo").removeClass("whirl");
						$("#ModalTarjeta #cuerpo").removeClass("ringed");
						$("#ModalTarjeta").modal("hide");
					   swal("Acción:", Mensaje);
						LimpiarTarjeta();
						tablaTarjeta.ajax.reload();
					}
			 }
		});
}
function Listar_Estado(){
	 $.post("../../controlador/Mantenimiento/CTarjeta.php?op=listar_estados", function (ts) {
      $("#TarjetaEstado").append(ts);
   });
}
function Listar_Tarjeta(){

	tablaTarjeta = $('#tablaTarjeta').dataTable({
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
               , "targets": [1,2]
            }
            , {
               "className": "text-left"
               , "targets": [0]
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
               extend: 'pdf'
               , className: 'btn-info'
               , title: $('title').text()
            }
            , {
               extend: 'print'
               , className: 'btn-info'
            }
            ],
        "ajax": { //Solicitud Ajax Servidor
			url: '../../controlador/Mantenimiento/CTarjeta.php?op=Listar_Tarjeta',
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
	tablaTarjeta.on('order.dt search.dt', function () {
		tablaTarjeta.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
}
function NuevoTarjeta(){
    $("#ModalTarjeta").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalTarjeta").modal("show");
    $("#tituloModalTarjeta").empty();
    $("#tituloModalTarjeta").append("Nueva Tarjeta:");
}
function EditarTarjeta(idTarjeta){
    $("#ModalTarjeta").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalTarjeta").modal("show");
    $("#tituloModalTarjeta").empty();
    $("#tituloModalTarjeta").append("Editar Tarjeta:");
	RecuperarTarjeta(idTarjeta);
}
function RecuperarTarjeta(idTarjeta){
	//solicitud de recuperar Proveedor
	$.post("../../controlador/Mantenimiento/CTarjeta.php?op=RecuperarInformacion_Tarjeta",{"idTarjeta":idTarjeta}, function(data, status){
		data = JSON.parse(data);
		console.log(data);

	$("#idTarjeta").val(data.idTipoTarjeta);
	$("#TarjetaNombre").val(data.Descripcion);
	$("#TarjetaEstado").val(data.Estado_idEstado);

	});
}
function EliminarTarjeta(idTarjeta){
      swal({
      title: "Eliminar?",
      text: "Esta Seguro que desea Eliminar Tarjeta!",
      type: "warning",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Eliminar!",
      closeOnConfirm: false
   }, function () {
      ajaxEliminarTarjeta(idTarjeta);
   });
}
function ajaxEliminarTarjeta(idTarjeta){
    $.post("../../controlador/Mantenimiento/CTarjeta.php?op=Eliminar_Tarjeta", {idTarjeta: idTarjeta}, function (data, e) {
      data = JSON.parse(data);
      var Error = data.Error;
      var Mensaje = data.Mensaje;
      if (Error) {
         swal("Error", Mensaje, "error");
      } else {
         swal("Eliminado!", Mensaje, "success");
         tablaTarjeta.ajax.reload();
      }
   });
}
function HabilitarTarjeta(idTarjeta){
      swal({
      title: "Habilitar?",
      text: "Esta Seguro que desea Habilitar Tarjeta!",
      type: "info",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Habilitar!",
      closeOnConfirm: false
   }, function () {
      ajaxHabilitarTarjeta(idTarjeta);
   });
}
function ajaxHabilitarTarjeta(idTarjeta){
       $.post("../../controlador/Mantenimiento/CTarjeta.php?op=Recuperar_Tarjeta", {idTarjeta: idTarjeta}, function (data, e) {
      data = JSON.parse(data);
      var Error = data.Error;
      var Mensaje = data.Mensaje;
      if (Error) {
         swal("Error", Mensaje, "error");
      } else {
         swal("Eliminado!", Mensaje, "success");
         tablaTarjeta.ajax.reload();
      }
   });
}
function LimpiarTarjeta(){
   $('#FormularioTarjeta')[0].reset();
	$("#idTarjeta").val("");

}
function Cancelar(){
    LimpiarTarjeta();
    $("#ModalTarjeta").modal("hide");
}


init();
