var tablaGrado;
function init(){
   Iniciar_Componentes();
   Listar_Grado();
	Listar_Estado();
}
function Iniciar_Componentes(){
   //var fecha=hoyFecha();

	//$('#date_fecha_comprobante').datepicker('setDate',fecha);

    $("#FormularioGrado").on("submit",function(e)
	{
	      RegistroGrado(e);
	});

}
function RegistroGrado(event){
	  //cargar(true);
	event.preventDefault(); //No se activará la acción predeterminada del evento
    var error="";

    $(".validarPanel").each(function(){
			if($(this).val()==" " || $(this).val()==0){
				error=error+$(this).data("message")+"<br>";
			}
    });

    if(error==""){
		$("#ModalGrado #cuerpo").addClass("whirl");
		$("#ModalGrado #cuerpo").addClass("ringed");
		setTimeout('AjaxRegistroGrado()', 2000);
	}else{
 		notificar_warning("Complete :<br>"+error);
	}
}
function AjaxRegistroGrado(){
    var formData = new FormData($("#FormularioGrado")[0]);
		console.log(formData);
		$.ajax({
			url: "../../controlador/Mantenimiento/CGrado.php?op=AccionGrado",
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
						$("#ModalGrado #cuerpo").removeClass("whirl");
						$("#ModalGrado #cuerpo").removeClass("ringed");
						$("#ModalGrado").modal("hide");
						swal("Error:", Mensaje);
						LimpiarGrado();
						tablaGrado.ajax.reload();
					}else{
						$("#ModalGrado #cuerpo").removeClass("whirl");
						$("#ModalGrado #cuerpo").removeClass("ringed");
						$("#ModalGrado").modal("hide");
					   swal("Acción:", Mensaje);
						LimpiarGrado();
						tablaGrado.ajax.reload();
					}
			 }
		});
}
function Listar_Estado(){
	 $.post("../../controlador/Mantenimiento/CGrado.php?op=listar_estados", function (ts) {
      $("#GradoEstado").append(ts);
   });
}
function Listar_Grado(){

	tablaGrado = $('#tablaGrado').dataTable({
		"aProcessing": true,
		"aServerSide": true,
		"processing": true,
		"paging": true, // Paginacion en tabla
		"ordering": true, // Ordenamiento en columna de tabla
		"info": true, // Informacion de cabecera tabla
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
               , title: "Sistema de Matricula - Jose Galvez - Reporte"
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
               , className: 'btn-info'
                ,  title: "Sistema de Matricula - Jose Galvez - Reporte"
            }
            ],
          "ajax": { //Solicitud Ajax Servidor
			url: '../../controlador/Mantenimiento/CGrado.php?op=Listar_Grado',
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
	tablaGrado.on('order.dt search.dt', function () {
		tablaGrado.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
}
function NuevoGrado(){
    $("#ModalGrado").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalGrado").modal("show");
    $("#tituloModalGrado").empty();
    $("#tituloModalGrado").append("Nuevo Grado:");
}
function EditarGrado(idGrado){
    $("#ModalGrado").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalGrado").modal("show");
    $("#tituloModalGrado").empty();
    $("#tituloModalGrado").append("Editar Grado:");
	RecuperarGrado(idGrado);
}
function RecuperarGrado(idGrado){
	//solicitud de recuperar Proveedor
	$.post("../../controlador/Mantenimiento/CGrado.php?op=RecuperarInformacion_Grado",{"idGrado":idGrado}, function(data, status){
		data = JSON.parse(data);
		console.log(data);

	$("#idGrado").val(data.idGrado);
	$("#GradoNombre").val(data.Descripcion);
	$("#GradoEstado").val(data.Estado_idEstado);

	});
}
function EliminarGrado(idGrado){
      swal({
      title: "Eliminar?",
      text: "Esta Seguro que desea Eliminar Grado!",
      type: "warning",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Eliminar!",
      closeOnConfirm: false
   }, function () {
      ajaxEliminarGrado(idGrado);
   });
}
function ajaxEliminarGrado(idGrado){
    $.post("../../controlador/Mantenimiento/CGrado.php?op=Eliminar_Grado", {idGrado: idGrado}, function (data, e) {
      data = JSON.parse(data);
      var Error = data.Error;
      var Mensaje = data.Mensaje;
      if (Error) {
         swal("Error", Mensaje, "error");
      } else {
         swal("Eliminado!", Mensaje, "success");
         tablaGrado.ajax.reload();
      }
   });
}
function HabilitarGrado(idGrado){
      swal({
      title: "Habilitar?",
      text: "Esta Seguro que desea Habilitar Grado!",
      type: "info",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Habilitar!",
      closeOnConfirm: false
   }, function () {
      ajaxHabilitarGrado(idGrado);
   });
}
function ajaxHabilitarGrado(idGrado){
       $.post("../../controlador/Mantenimiento/CGrado.php?op=Recuperar_Grado", {idGrado: idGrado}, function (data, e) {
      data = JSON.parse(data);
      var Error = data.Error;
      var Mensaje = data.Mensaje;
      if (Error) {
         swal("Error", Mensaje, "error");
      } else {
         swal("Eliminado!", Mensaje, "success");
         tablaGrado.ajax.reload();
      }
   });
}
function LimpiarGrado(){
   $('#FormularioGrado')[0].reset();
	$("#idGrado").val("");

}
function Cancelar(){
    LimpiarGrado();
    $("#ModalGrado").modal("hide");
}


init();
