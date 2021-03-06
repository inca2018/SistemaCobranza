var tablaSeccion;
function init(){
   Iniciar_Componentes();
   Listar_Seccion();
	Listar_Estado();
}
function Iniciar_Componentes(){
   //var fecha=hoyFecha();

	//$('#date_fecha_comprobante').datepicker('setDate',fecha);

    $("#FormularioSeccion").on("submit",function(e)
	{
	      RegistroSeccion(e);
	});

}
function RegistroSeccion(event){
	  //cargar(true);
	event.preventDefault(); //No se activará la acción predeterminada del evento
    var error="";

    $(".validarPanel").each(function(){
			if($(this).val()==" " || $(this).val()==0){
				error=error+$(this).data("message")+"<br>";
			}
    });

    if(error==""){
		$("#ModalSeccion #cuerpo").addClass("whirl");
		$("#ModalSeccion #cuerpo").addClass("ringed");
		setTimeout('AjaxRegistroSeccion()', 2000);
	}else{
 		notificar_warning("Complete :<br>"+error);
	}
}
function AjaxRegistroSeccion(){
    var formData = new FormData($("#FormularioSeccion")[0]);
		console.log(formData);
		$.ajax({
			url: "../../controlador/Mantenimiento/CSeccion.php?op=AccionSeccion",
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
						$("#ModalSeccion #cuerpo").removeClass("whirl");
						$("#ModalSeccion #cuerpo").removeClass("ringed");
						$("#ModalSeccion").modal("hide");
						swal("Error:", Mensaje);
						LimpiarSeccion();
						tablaSeccion.ajax.reload();
					}else{
						$("#ModalSeccion #cuerpo").removeClass("whirl");
						$("#ModalSeccion #cuerpo").removeClass("ringed");
						$("#ModalSeccion").modal("hide");
					   swal("Acción:", Mensaje);
						LimpiarSeccion();
						tablaSeccion.ajax.reload();
					}
			 }
		});
}
function Listar_Estado(){
	 $.post("../../controlador/Mantenimiento/CSeccion.php?op=listar_estados", function (ts) {
      $("#SeccionEstado").append(ts);
   });
}
function Listar_Seccion(){

	tablaSeccion = $('#tablaSeccion').dataTable({
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
               , className: 'btn-info',
                title: "Sistema de Matricula - Jose Galvez - Reporte"
            }

            , {
               extend: 'excel'
               , className: 'btn-info'
               , title: "Sistema de Matricula - Jose Galvez - Reporte"
            }
            , {
               extend: 'pdfHtml5'
               , className: 'btn-info sombra3'
               , title: "Reporte de Secciones"
               ,orientation: 'landscape'
               ,pageSize: 'LEGAL',
                customize: function ( doc ) {
                    doc.content.splice( 1, 0, {
                        margin: [ 0, 0, 0, 12 ],
                        alignment: 'center',
                        image: RecuperarLogo64(),
                    } );
                }
            }
            , {
               extend: 'print'
               , className: 'btn-info',
                title: "Sistema de Matricula - Jose Galvez - Reporte"
            }
            ],
          "ajax": { //Solicitud Ajax Servidor
			url: '../../controlador/Mantenimiento/CSeccion.php?op=Listar_Seccion',
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
	tablaSeccion.on('order.dt search.dt', function () {
		tablaSeccion.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
}
function NuevoSeccion(){
    $("#ModalSeccion").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalSeccion").modal("show");
    $("#tituloModalSeccion").empty();
    $("#tituloModalSeccion").append("Nuevo Seccion:");
}
function EditarSeccion(idSeccion){
    $("#ModalSeccion").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalSeccion").modal("show");
    $("#tituloModalSeccion").empty();
    $("#tituloModalSeccion").append("Editar Seccion:");
	RecuperarSeccion(idSeccion);
}
function RecuperarSeccion(idSeccion){
	//solicitud de recuperar Proveedor
	$.post("../../controlador/Mantenimiento/CSeccion.php?op=RecuperarInformacion_Seccion",{"idSeccion":idSeccion}, function(data, status){
		data = JSON.parse(data);
		console.log(data);

	$("#idSeccion").val(data.idSeccion);
	$("#SeccionNombre").val(data.Descripcion);
	$("#SeccionEstado").val(data.Estado_idEstado);

	});
}
function EliminarSeccion(idSeccion){
      swal({
      title: "Deshabilitar?",
      text: "Esta Seguro que desea Deshabilitar Seccion!",
      type: "warning",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Deshabilitar!",
      closeOnConfirm: false
   }, function () {
      ajaxEliminarSeccion(idSeccion);
   });
}
function BorrarSeccion(idSeccion){
      swal({
      title: "Eliminar?",
      text: "Esta Seguro que desea Eliminar Seccion!",
      type: "warning",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Eliminar!",
      closeOnConfirm: false
   }, function () {
      ajaxBorrarSeccion(idSeccion);
   });
}
function ajaxBorrarSeccion(idSeccion){
    $.post("../../controlador/Mantenimiento/CSeccion.php?op=Borrar_Seccion", {idSeccion: idSeccion}, function (data, e) {
      data = JSON.parse(data);
      var Error = data.Error;
      var Mensaje = data.Mensaje;
      if (Error) {
         swal("Error", Mensaje, "error");
      } else {
         swal("Eliminado!", Mensaje, "success");
         tablaSeccion.ajax.reload();
      }
   });
}
function ajaxEliminarSeccion(idSeccion){
    $.post("../../controlador/Mantenimiento/CSeccion.php?op=Eliminar_Seccion", {idSeccion: idSeccion}, function (data, e) {
      data = JSON.parse(data);
      var Error = data.Error;
      var Mensaje = data.Mensaje;
      if (Error) {
         swal("Error", Mensaje, "error");
      } else {
         swal("Eliminado!", Mensaje, "success");
         tablaSeccion.ajax.reload();
      }
   });
}
function HabilitarSeccion(idSeccion){
      swal({
      title: "Habilitar?",
      text: "Esta Seguro que desea Habilitar Seccion!",
      type: "info",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Habilitar!",
      closeOnConfirm: false
   }, function () {
      ajaxHabilitarSeccion(idSeccion);
   });
}
function ajaxHabilitarSeccion(idSeccion){
       $.post("../../controlador/Mantenimiento/CSeccion.php?op=Recuperar_Seccion", {idSeccion: idSeccion}, function (data, e) {
      data = JSON.parse(data);
      var Error = data.Error;
      var Mensaje = data.Mensaje;
      if (Error) {
         swal("Error", Mensaje, "error");
      } else {
         swal("Eliminado!", Mensaje, "success");
         tablaSeccion.ajax.reload();
      }
   });
}
function LimpiarSeccion(){
   $('#FormularioSeccion')[0].reset();
	$("#idSeccion").val("");

}
function Cancelar(){
    LimpiarSeccion();
    $("#ModalSeccion").modal("hide");
}


init();
