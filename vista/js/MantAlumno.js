var tablaAlumno;
function init(){
    Iniciar_Componentes();
    Listar_Estado();
    Listar_Nivel();
    Listar_Grado();
    Listar_Seccion();
    //Listar_Alumno();
}
function Iniciar_Componentes(){
   //var fecha=hoyFecha();

	//$('#date_fecha_comprobante').datepicker('setDate',fecha);

    $("#FormularioAlumno").on("submit",function(e)
	{
	      RegistroAlumno(e);
	});
 	$('#dateFechaNacimiento').datepicker({
      format: 'dd/mm/yyyy',
      language: 'es'
   });

}
function RegistroAlumno(event){
	  //cargar(true);
	event.preventDefault(); //No se activará la acción predeterminada del evento
    var error="";

    $(".validarPanel").each(function(){
			if($(this).val()==" " || $(this).val()==0){
				error=error+$(this).data("message")+"<br>";
			}
    });

    if(error==""){
		$("#ModalAlumno #cuerpo").addClass("whirl");
		$("#ModalAlumno #cuerpo").addClass("ringed");
		setTimeout('AjaxRegistroAlumno()', 2000);
	}else{
 		notificar_warning("Complete :<br>"+error);
	}
}
function AjaxRegistroAlumno(){
    var formData = new FormData($("#FormularioAlumno")[0]);
		console.log(formData);
		$.ajax({
			url: "../../controlador/Mantenimiento/CAlumno.php?op=AccionAlumno",
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
						$("#ModalAlumno #cuerpo").removeClass("whirl");
						$("#ModalAlumno #cuerpo").removeClass("ringed");
						$("#ModalAlumno").modal("hide");
						swal("Error:", Mensaje);
						LimpiarAlumno();
						tablaAlumno.ajax.reload();
					}else{
						$("#ModalAlumno #cuerpo").removeClass("whirl");
						$("#ModalAlumno #cuerpo").removeClass("ringed");
						$("#ModalAlumno").modal("hide");
					   swal("Acción:", Mensaje);
						LimpiarAlumno();
						tablaAlumno.ajax.reload();
					}
			 }
		});
}
function Listar_Estado(){
	 $.post("../../controlador/Mantenimiento/CAlumno.php?op=listar_estados", function (ts) {
      $("#AlumnoEstado").append(ts);
   });
}
function Listar_Nivel(){
	 $.post("../../controlador/Mantenimiento/CAlumno.php?op=listar_niveles", function (ts) {
      $("#AlumnoNivel").append(ts);
   });
}
function Listar_Grado(){
	 $.post("../../controlador/Mantenimiento/CAlumno.php?op=listar_grados", function (ts) {
      $("#AlumnoGrado").append(ts);
 });
}
function Listar_Seccion(){
	 $.post("../../controlador/Mantenimiento/CAlumno.php?op=listar_secciones", function (ts) {
      $("#AlumnoSeccion").append(ts);
 });
}


function Listar_Alumno(){
	tablaAlumno = $('#tablaAlumno').dataTable({
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
               , "targets": [1,2,3,4,5,6]
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
			url: '../../controlador/Mantenimiento/CAlumno.php?op=Listar_Alumno',
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
	tablaAlumno.on('order.dt search.dt', function () {
		tablaAlumno.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
}
function NuevoAlumno(){
    $("#ModalAlumno").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalAlumno").modal("show");
    $("#tituloModalAlumno").empty();
    $("#tituloModalAlumno").append("Nuevo Alumno:");
}
function EditarAlumno(idAlumno){
    $("#ModalAlumno").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalAlumno").modal("show");
    $("#tituloModalAlumno").empty();
    $("#tituloModalAlumno").append("Editar Alumno:");
	RecuperarAlumno(idAlumno);
}
function RecuperarAlumno(idAlumno){
	//solicitud de recuperar Proveedor
	$.post("../../controlador/Mantenimiento/CAlumno.php?op=RecuperarInformacion_Alumno",{"idAlumno":idAlumno}, function(data, status){
		data = JSON.parse(data);
		console.log(data);

$("#idAlumno").val(data.idAlumno);
$("#AlumnoNombre").val(data.nombreAlumno);
$("#AlumnoFechaNacimiento").val(data.fechaNacimiento);
$("#AlumnoApellidoP").val(data.apellidoPaterno);
$("#AlumnoDNI").val(data.DNI);
$("#AlumnoApellidoM").val(data.apellidoMaterno);
$("#AlumnoCorreo").val(data.correo);
$("#AlumnoTelefono").val(data.telefono);
$("#AlumnoDireccion").val(data.direccion);
$("#AlumnoEstado").val(data.Estado_idEstado);

	});
}
function EliminarAlumno(idAlumno){
      swal({
      title: "Eliminar?",
      text: "Esta Seguro que desea Eliminar Alumno!",
      type: "warning",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Eliminar!",
      closeOnConfirm: false
   }, function () {
      ajaxEliminarAlumno(idAlumno);
   });
}
function ajaxEliminarAlumno(idAlumno){
    $.post("../../controlador/Mantenimiento/CAlumno.php?op=Eliminar_Alumno", {idAlumno: idAlumno}, function (data, e) {
      data = JSON.parse(data);
      var Error = data.Error;
      var Mensaje = data.Mensaje;
      if (Error) {
         swal("Error", Mensaje, "error");
      } else {
         swal("Eliminado!", Mensaje, "success");
         tablaAlumno.ajax.reload();
      }
   });
}
function HabilitarAlumno(idAlumno){
      swal({
      title: "Habilitar?",
      text: "Esta Seguro que desea Habilitar Alumno!",
      type: "info",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Habilitar!",
      closeOnConfirm: false
   }, function () {
      ajaxHabilitarAlumno(idAlumno);
   });
}
function ajaxHabilitarAlumno(idAlumno){
       $.post("../../controlador/Mantenimiento/CAlumno.php?op=Recuperar_Alumno", {idAlumno: idAlumno}, function (data, e) {
      data = JSON.parse(data);
      var Error = data.Error;
      var Mensaje = data.Mensaje;
      if (Error) {
         swal("Error", Mensaje, "error");
      } else {
         swal("Eliminado!", Mensaje, "success");
         tablaAlumno.ajax.reload();
      }
   });
}
function LimpiarAlumno(){
   $('#FormularioAlumno')[0].reset();
	$("#idAlumno").val("");

}
function Cancelar(){
    LimpiarAlumno();
    $("#ModalAlumno").modal("hide");

}

init();
