var tablaNivel;
function init(){
   Iniciar_Componentes();
   Listar_Nivel();
	Listar_Estado();
}
function Iniciar_Componentes(){
   //var fecha=hoyFecha();

	//$('#date_fecha_comprobante').datepicker('setDate',fecha);

    $("#FormularioNivel").on("submit",function(e)
	{
	      RegistroNivel(e);
	});

}
function RegistroNivel(event){
	  //cargar(true);
	event.preventDefault(); //No se activará la acción predeterminada del evento
    var error="";

    $(".validarPanel").each(function(){
			if($(this).val()==" " || $(this).val()==0){
				error=error+$(this).data("message")+"<br>";
			}
    });

    if(error==""){
		$("#ModalNivel #cuerpo").addClass("whirl");
		$("#ModalNivel #cuerpo").addClass("ringed");
		setTimeout('AjaxRegistroNivel()', 2000);
	}else{
 		notificar_warning("Complete :<br>"+error);
	}
}
function AjaxRegistroNivel(){
    var formData = new FormData($("#FormularioNivel")[0]);
		console.log(formData);
		$.ajax({
			url: "../../controlador/Mantenimiento/CNivel.php?op=AccionNivel",
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
						$("#ModalNivel #cuerpo").removeClass("whirl");
						$("#ModalNivel #cuerpo").removeClass("ringed");
						$("#ModalNivel").modal("hide");
						swal("Error:", Mensaje);
						LimpiarNivel();
						tablaNivel.ajax.reload();
					}else{
						$("#ModalNivel #cuerpo").removeClass("whirl");
						$("#ModalNivel #cuerpo").removeClass("ringed");
						$("#ModalNivel").modal("hide");
					   swal("Acción:", Mensaje);
						LimpiarNivel();
						tablaNivel.ajax.reload();
					}
			 }
		});
}
function Listar_Estado(){
	 $.post("../../controlador/Mantenimiento/CNivel.php?op=listar_estados", function (ts) {
      $("#NivelEstado").append(ts);
   });
}
function Listar_Nivel(){

	tablaNivel = $('#tablaNivel').dataTable({
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
			url: '../../controlador/Mantenimiento/CNivel.php?op=Listar_Nivel',
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
	tablaNivel.on('order.dt search.dt', function () {
		tablaNivel.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
}
function NuevoNivel(){
    $("#ModalNivel").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalNivel").modal("show");
    $("#tituloModalNivel").empty();
    $("#tituloModalNivel").append("Nuevo Nivel:");
}
function EditarNivel(idNivel){
    $("#ModalNivel").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalNivel").modal("show");
    $("#tituloModalNivel").empty();
    $("#tituloModalNivel").append("Editar Nivel:");
	RecuperarNivel(idNivel);
}
function RecuperarNivel(idNivel){
	//solicitud de recuperar Proveedor
	$.post("../../controlador/Mantenimiento/CNivel.php?op=RecuperarInformacion_Nivel",{"idNivel":idNivel}, function(data, status){
		data = JSON.parse(data);
		console.log(data);

	$("#idNivel").val(data.idNivel);
	$("#NivelNombre").val(data.Descripcion);
	$("#NivelEstado").val(data.Estado_idEstado);

	});
}
function EliminarNivel(idNivel){
      swal({
      title: "Eliminar?",
      text: "Esta Seguro que desea Eliminar Nivel!",
      type: "warning",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Eliminar!",
      closeOnConfirm: false
   }, function () {
      ajaxEliminarNivel(idNivel);
   });
}
function ajaxEliminarNivel(idNivel){
    $.post("../../controlador/Mantenimiento/CNivel.php?op=Eliminar_Nivel", {idNivel: idNivel}, function (data, e) {
      data = JSON.parse(data);
      var Error = data.Error;
      var Mensaje = data.Mensaje;
      if (Error) {
         swal("Error", Mensaje, "error");
      } else {
         swal("Eliminado!", Mensaje, "success");
         tablaNivel.ajax.reload();
      }
   });
}
function HabilitarNivel(idNivel){
      swal({
      title: "Habilitar?",
      text: "Esta Seguro que desea Habilitar Nivel!",
      type: "info",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Habilitar!",
      closeOnConfirm: false
   }, function () {
      ajaxHabilitarNivel(idNivel);
   });
}
function ajaxHabilitarNivel(idNivel){
       $.post("../../controlador/Mantenimiento/CNivel.php?op=Recuperar_Nivel", {idNivel: idNivel}, function (data, e) {
      data = JSON.parse(data);
      var Error = data.Error;
      var Mensaje = data.Mensaje;
      if (Error) {
         swal("Error", Mensaje, "error");
      } else {
         swal("Eliminado!", Mensaje, "success");
         tablaNivel.ajax.reload();
      }
   });
}
function LimpiarNivel(){
   $('#FormularioNivel')[0].reset();
	$("#idNivel").val("");

}
function Cancelar(){
    LimpiarNivel();
    $("#ModalNivel").modal("hide");
}


init();
