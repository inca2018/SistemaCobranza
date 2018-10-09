var tablaApoderado;
function init(){
    Iniciar_Componentes();
    Listar_Estado();
    Listar_TipoTarjeta();
    Listar_Apoderado();
}
function Iniciar_Componentes(){
   //var fecha=hoyFecha();

	//$('#date_fecha_comprobante').datepicker('setDate',fecha);

    $("#FormularioApoderado").on("submit",function(e)
	{
	      RegistroApoderado(e);
	});
 	$('#dateFechaNacimiento').datepicker({
      format: 'dd/mm/yyyy',
      language: 'es'
   });

}
function RegistroApoderado(event){
	  //cargar(true);
	event.preventDefault(); //No se activará la acción predeterminada del evento
    var error="";

    $(".validarPanel").each(function(){
			if($(this).val()==" " || $(this).val()==0){
				error=error+$(this).data("message")+"<br>";
			}
    });

    if(error==""){
		$("#ModalApoderado #cuerpo").addClass("whirl");
		$("#ModalApoderado #cuerpo").addClass("ringed");
		setTimeout('AjaxRegistroApoderado()', 2000);
	}else{
 		notificar_warning("Complete :<br>"+error);
	}
}
function AjaxRegistroApoderado(){
    var formData = new FormData($("#FormularioApoderado")[0]);
		console.log(formData);
		$.ajax({
			url: "../../controlador/Mantenimiento/CApoderado.php?op=AccionApoderado",
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
						$("#ModalApoderado #cuerpo").removeClass("whirl");
						$("#ModalApoderado #cuerpo").removeClass("ringed");
						$("#ModalApoderado").modal("hide");
						swal("Error:", Mensaje);
						LimpiarApoderado();
						tablaApoderado.ajax.reload();
					}else{
						$("#ModalApoderado #cuerpo").removeClass("whirl");
						$("#ModalApoderado #cuerpo").removeClass("ringed");
						$("#ModalApoderado").modal("hide");
					   swal("Acción:", Mensaje);
						LimpiarApoderado();
						tablaApoderado.ajax.reload();
					}
			 }
		});
}
function Listar_Estado(){
	 $.post("../../controlador/Mantenimiento/CApoderado.php?op=listar_estados", function (ts) {
      $("#ApoderadoEstado").append(ts);
   });
}
function Listar_TipoTarjeta(){
	 $.post("../../controlador/Mantenimiento/CApoderado.php?op=listar_TipoTarjeta", function (ts) {
      $("#ApoderadoTipoTarjeta").append(ts);
   });
}

function Listar_Apoderado(){
	tablaApoderado = $('#tablaApoderado').dataTable({
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
               , "targets": [1,2,3,4,5,6,7]
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
			url: '../../controlador/Mantenimiento/CApoderado.php?op=Listar_Apoderado',
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
	tablaApoderado.on('order.dt search.dt', function () {
		tablaApoderado.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
}
function NuevoApoderado(){
    $("#ModalApoderado").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalApoderado").modal("show");
    $("#tituloModalApoderado").empty();
    $("#tituloModalApoderado").append("Nuevo Apoderado:");
}
function EditarApoderado(idPersona,idApoderado){
    $("#ModalApoderado").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalApoderado").modal("show");
    $("#tituloModalApoderado").empty();
    $("#tituloModalApoderado").append("Editar Apoderado:");
	RecuperarApoderado(idPersona,idApoderado);
}
function RecuperarApoderado(idPersona,idApoderado){
	//solicitud de recuperar Proveedor
	$.post("../../controlador/Mantenimiento/CApoderado.php?op=RecuperarInformacion_Apoderado",{"idPersona":idPersona,"idApoderado":idApoderado}, function(data, status){
		data = JSON.parse(data);
		console.log(data);

$("#idApoderado").val(data.idApoderado);
$("#idPersona").val(data.idPersona);
$("#ApoderadoNombre").val(data.nombrePersona);
$("#ApoderadoFechaNacimiento").val(data.fechaNacimiento);
$("#ApoderadoApellidoP").val(data.apellidoPaterno);
$("#ApoderadoDNI").val(data.DNI);
$("#ApoderadoApellidoM").val(data.apellidoMaterno);
$("#ApoderadoCorreo").val(data.correo);
$("#ApoderadoTelefono").val(data.telefono);
$("#ApoderadoDireccion").val(data.direccion);
$("#ApoderadoEstado").val(data.Estado_idEstado);

$("#ApoderadoNivel").val(data.idNivel);
$("#ApoderadoGrado").val(data.idGrado);
$("#ApoderadoSeccion").val(data.idSeccion);


	});
}
function EliminarApoderado(idPersona,idApoderado){
      swal({
      title: "Eliminar?",
      text: "Esta Seguro que desea Eliminar Apoderado!",
      type: "warning",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Eliminar!",
      closeOnConfirm: false
   }, function () {
      ajaxEliminarApoderado(idPersona,idApoderado);
   });
}
function ajaxEliminarApoderado(idPersona,idApoderado){
    $.post("../../controlador/Mantenimiento/CApoderado.php?op=Eliminar_Apoderado", {idPersona:idPersona,idApoderado: idApoderado}, function (data, e) {
      data = JSON.parse(data);
      var Error = data.Error;
      var Mensaje = data.Mensaje;
      if (Error) {
         swal("Error", Mensaje, "error");
      } else {
         swal("Eliminado!", Mensaje, "success");
         tablaApoderado.ajax.reload();
      }
   });
}
function HabilitarApoderado(idPersona,idApoderado){
      swal({
      title: "Habilitar?",
      text: "Esta Seguro que desea Habilitar Apoderado!",
      type: "info",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Habilitar!",
      closeOnConfirm: false
   }, function () {
      ajaxHabilitarApoderado(idPersona,idApoderado);
   });
}
function ajaxHabilitarApoderado(idPersona,idApoderado){
       $.post("../../controlador/Mantenimiento/CApoderado.php?op=Recuperar_Apoderado", {idPersona:idPersona,idApoderado: idApoderado}, function (data, e) {
      data = JSON.parse(data);
      var Error = data.Error;
      var Mensaje = data.Mensaje;
      if (Error) {
         swal("Error", Mensaje, "error");
      } else {
         swal("Eliminado!", Mensaje, "success");
         tablaApoderado.ajax.reload();
      }
   });
}
function LimpiarApoderado(){
   $('#FormularioApoderado')[0].reset();
	$("#idApoderado").val("");

}
function Cancelar(){
    LimpiarApoderado();
    $("#ModalApoderado").modal("hide");

}
function Volver(){
    $.redirect('../Operaciones/Operaciones.php');
}
init();
