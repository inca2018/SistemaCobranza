var tablaAlumno;
function init(){
    Iniciar_Componentes();
    Listar_Estado();
    Listar_Nivel();
    Listar_Grado();
    Listar_Seccion();
    Listar_Alumno();
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
               , "targets": [1,2,3,4,5,6,7,8]
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
function EditarAlumno(idPersona,idAlumno){
    $("#ModalAlumno").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalAlumno").modal("show");
    $("#tituloModalAlumno").empty();
    $("#tituloModalAlumno").append("Editar Alumno:");
	RecuperarAlumno(idPersona,idAlumno);
}
function RecuperarAlumno(idPersona,idAlumno){
	//solicitud de recuperar Proveedor
	$.post("../../controlador/Mantenimiento/CAlumno.php?op=RecuperarInformacion_Alumno",{"idPersona":idPersona,"idAlumno":idAlumno}, function(data, status){
		data = JSON.parse(data);
		console.log(data);

$("#idAlumno").val(data.idAlumno);
$("#idPersona").val(data.idPersona);
$("#AlumnoNombre").val(data.nombrePersona);
$("#AlumnoFechaNacimiento").val(data.fechaNacimiento);
$("#AlumnoApellidoP").val(data.apellidoPaterno);
$("#AlumnoDNI").val(data.DNI);
$("#AlumnoApellidoM").val(data.apellidoMaterno);
$("#AlumnoCorreo").val(data.correo);
$("#AlumnoTelefono").val(data.telefono);
$("#AlumnoDireccion").val(data.direccion);
$("#AlumnoEstado").val(data.Estado_idEstado);

$("#AlumnoNivel").val(data.idNivel);
$("#AlumnoGrado").val(data.idGrado);
$("#AlumnoSeccion").val(data.idSeccion);


	});
}
function EliminarAlumno(idPersona,idAlumno){
      swal({
      title: "Eliminar?",
      text: "Esta Seguro que desea Eliminar Alumno!",
      type: "warning",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Eliminar!",
      closeOnConfirm: false
   }, function () {
      ajaxEliminarAlumno(idPersona,idAlumno);
   });
}
function ajaxEliminarAlumno(idPersona,idAlumno){
    $.post("../../controlador/Mantenimiento/CAlumno.php?op=Eliminar_Alumno", {idPersona:idPersona,idAlumno: idAlumno}, function (data, e) {
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
function HabilitarAlumno(idPersona,idAlumno){
      swal({
      title: "Habilitar?",
      text: "Esta Seguro que desea Habilitar Alumno!",
      type: "info",
      showCancelButton: true,
      confirmButtonColor: "#DD6B55",
      confirmButtonText: "Si, Habilitar!",
      closeOnConfirm: false
   }, function () {
      ajaxHabilitarAlumno(idPersona,idAlumno);
   });
}
function ajaxHabilitarAlumno(idPersona,idAlumno){
       $.post("../../controlador/Mantenimiento/CAlumno.php?op=Recuperar_Alumno", {idPersona:idPersona,idAlumno: idAlumno}, function (data, e) {
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
function Volver(){
    $.redirect('../Operaciones/Operaciones.php');
}
function VerPlanPago(idPersona,idAlumno){
    $("#ModalPlanPago").modal({
      backdrop: 'static'
      , keyboard: false
    });
    $("#ModalPlanPago").modal("show");

    Mostrar_Informacion_Alumno(idPersona,idAlumno);
    iniciar_valores();
}
function Salir(){
    LimpiarPlan();
    $("#ModalPlanPago").modal("hide");
}
function Mostrar_Informacion_Alumno(idPersona,idAlumno){
    $.post("../../controlador/Mantenimiento/CAlumno.php?op=RecuperarInformacion_Alumno",{"idPersona":idPersona,"idAlumno":idAlumno}, function(data, status){
		data = JSON.parse(data);
		console.log(data);

    $("#O_idPersona").val(data.idPersona);
    $("#O_idAlumno").val(data.idAlumno);
    $("#O_PlanCreado").val(data.PlanP);
    $("#datos_dni").val(data.DNI);
    $("#datos_apellido").val(data.apellidoPaterno+" "+data.apellidoMaterno);
    $("#datos_nombres").val(data.nombrePersona);
    $("#datos_direccion").val(data.direccion);
    $("#datos_telefono").val(data.telefono);
    $("#datos_nivel").val(data.NivelNombre);
    $("#datos_grado").val(data.GradoNombre);
    $("#datos_seccion").val(data.SeccionNombre);



    if(data.PlanP==0){
        $("#importe_matricula").removeAttr("disabled");
        $("#importe_cuota").removeAttr("disabled");
        $("#importe_adicional1").removeAttr("disabled");
        $("#importe_adicional2").removeAttr("disabled");
        $("#datos_observaciones").removeAttr("disabled");

        $("#importe_matricula").removeAttr("disabled");
        $("#importe_cuota").removeAttr("disabled");
        $("#importe_adicional1").removeAttr("disabled");
        $("#importe_adicional2").removeAttr("disabled");
        $("#datos_observaciones").removeAttr("disabled");

        $("#boton_matricula").removeAttr("disabled");

        $("#mensajeMatricula").empty();
        $("#fechaMatricula").empty();

    }else{
        $("#importe_matricula").attr("disabled","true");
        $("#importe_cuota").attr("disabled","true");
        $("#importe_adicional1").attr("disabled","true");
        $("#importe_adicional2").attr("disabled","true");
        $("#datos_observaciones").attr("disabled","true");

        $("#boton_matricula").attr("disabled","true");

        $("#fechaMatricula").empty();
        $("#fechaMatricula").html("Fecha de Matricula: "+data.fechaMatricula);

        $("#importe_matricula").val("S/."+Formato_Moneda(parseFloat(data.montoMatricula),2));
        $("#importe_cuota").val("S/."+Formato_Moneda(parseFloat(data.montoCuota),2));
        $("#importe_adicional1").val("S/."+Formato_Moneda(parseFloat(data.otroPago1),2));
        $("#importe_adicional2").val("S/."+Formato_Moneda(parseFloat(data.otroPago2),2));
        $("#datos_observaciones").val(data.Observaciones);

        $("#mensajeMatricula").empty();
        $("#mensajeMatricula").html("ALUMNO MATRICULADO");
    }

	});
}
function iniciar_valores(){

     $("#FormularioMatricula").on("submit",function(e)
	{
	      RegistroMatricula(e);
	});


    $("#importe_matricula").change(function(){
	 	var ingreso_adelanto=$("#importe_matricula").val();
		if(ingreso_adelanto!=''){
					$("#O_importe_matricula").val(parseFloat($("#importe_matricula").val()));
					$("#importe_matricula").val("S/."+Formato_Moneda(parseFloat($("#importe_matricula").val()),2))

				}else{
					$("#O_importe_matricula").val(0);
					$("#importe_matricula").val('S/. 0.00');

				}
	});

    $("#importe_matricula").click(function(){
		$("#importe_matricula").val($("#O_importe_matricula").val());
	});
	$("#importe_matricula").blur(function(){
		$("#importe_matricula").val("S/. "+Formato_Moneda($("#O_importe_matricula").val(),2));
	});


     $("#importe_cuota").change(function(){
	 	var ingreso_adelanto=$("#importe_matricula").val();
		if(ingreso_adelanto!=''){
					$("#O_importe_cuota").val(parseFloat($("#importe_cuota").val()));
					$("#importe_cuota").val("S/."+Formato_Moneda(parseFloat($("#importe_cuota").val()),2))

				}else{
					$("#O_importe_cuota").val(0);
					$("#importe_cuota").val('S/. 0.00');
				}
	});

    $("#importe_cuota").click(function(){
		$("#importe_cuota").val($("#O_importe_cuota").val());
	});
	$("#importe_cuota").blur(function(){
		$("#importe_cuota").val("S/. "+Formato_Moneda($("#O_importe_cuota").val(),2));
	});


     $("#importe_adicional1").change(function(){
	 	var ingreso_adelanto=$("#importe_adicional1").val();
		if(ingreso_adelanto!=''){
					$("#O_importe_adicional1").val(parseFloat($("#importe_adicional1").val()));
					$("#importe_adicional1").val("S/."+Formato_Moneda(parseFloat($("#importe_adicional1").val()),2))

				}else{
					$("#O_importe_adicional1").val(0);
					$("#importe_adicional1").val('S/. 0.00');
				}
	});

    $("#importe_adicional1").click(function(){
		$("#importe_adicional1").val($("#O_importe_adicional1").val());
	});
	$("#importe_adicional1").blur(function(){
		$("#importe_adicional1").val("S/. "+Formato_Moneda($("#O_importe_adicional1").val(),2));
	});



     $("#importe_adicional2").change(function(){
	 	var ingreso_adelanto=$("#importe_adicional1").val();
		if(ingreso_adelanto!=''){
					$("#O_importe_adicional2").val(parseFloat($("#importe_adicional2").val()));
					$("#importe_adicional2").val("S/."+Formato_Moneda(parseFloat($("#importe_adicional2").val()),2))

				}else{
					$("#O_importe_adicional2").val(0);
					$("#importe_adicional2").val('S/. 0.00');
				}
	});

    $("#importe_adicional2").click(function(){
		$("#importe_adicional2").val($("#O_importe_adicional2").val());
	});
	$("#importe_adicional1").blur(function(){
		$("#importe_adicional2").val("S/. "+Formato_Moneda($("#O_importe_adicional2").val(),2));
	});

     $("#datos_observaciones").change(function(){
	 	var ff=$("#datos_observaciones").val();
		if(ff!=''){
					$("#O_observaciones").val($("#datos_observaciones").val());
				}else{
					$("#O_importe_adicional2").val('');
					$("#datos_observaciones").val('');
				}
	});



}

function RegistroMatricula(event){
    event.preventDefault();

    var error="";

    var imp_matricula=$("#O_importe_matricula").val();
    var imp_cuota=$("#O_importe_cuota").val();
    var imp_adicional1=$("#O_importe_adicional1").val();
    var imp_adicional2=$("#O_importe_adicional2").val();

    if(imp_matricula==0){
        error=error+"- Importe Matricula. <br>";
       }
    if(imp_cuota==0){
        error=error+"- Importe Cuota. <br>";
       }

    if(error==""){
		$("#cuerpo_matricula").addClass("whirl");
		$("#cuerpo_matricula").addClass("ringed");
		setTimeout('AjaxRegistroMatricula()', 2000);
	}else{
 		notificar_warning("Complete :<br>"+error);
	}

}

function AjaxRegistroMatricula(){
     var formData = new FormData($("#FormularioMatricula")[0]);
		console.log(formData);
		$.ajax({
			url: "../../controlador/Mantenimiento/CAlumno.php?op=AccionMatricula",
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
						$("#cuerpo_matricula").removeClass("whirl");
						$("#cuerpo_matricula").removeClass("ringed");
						//$("#ModalPlanPago").modal("hide");
						swal("Error:", Mensaje);
					}else{
						$("#cuerpo_matricula").removeClass("whirl");
						$("#cuerpo_matricula").removeClass("ringed");
						//$("#ModalPlanPago").modal("hide");
					    swal("Acción:", Mensaje);

                        var idPersona=$("#O_idPersona").val();
                        var idAlumno=$("#O_idAlumno").val();
                        Mostrar_Informacion_Alumno(idPersona,idAlumno);
					}
			 }
		});
}
function LimpiarPlan(){

    $("#FormularioMatricula")[0].reset();

$("#O_idPersona").val("");
$("#O_idAlumno").val("");
$("#O_PlanCreado").val("");
$("#O_importe_matricula").val("");
$("#O_importe_cuota").val("");
$("#O_importe_adicional1").val("");
$("#O_importe_adicional2").val("");
$("#O_observaciones").val("");

$(".panelAccion").removeClass("active");
$("#op_datos").addClass("active");
$(".panelBoton").removeClass("active");
$("#menu1").addClass("active");
}
init();
