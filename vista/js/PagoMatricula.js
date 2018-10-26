function init(){

 Listar_TipoDeTarjeta();
 Listar_TipoPago();

var idAlumno=$("#idAlumno").val();
RecuperarInformacionMatricula(idAlumno);

    iniciar_Valores();
}

function Listar_TipoDeTarjeta(){
     $.post("../../controlador/Gestion/CGestion.php?op=listar_tipoTarjeta", function (ts) {
      $("#PagoTipoTarjeta").append(ts);
   });
}

function Listar_TipoPago(){
    $.post("../../controlador/Gestion/CGestion.php?op=listar_tipoPago", function (ts) {
      $("#PagoTipoPago").append(ts);
   });
}

function RecuperarInformacionMatricula(idAlumno){
    //solicitud de recuperar Proveedor
	$.post("../../controlador/Gestion/CGestion.php?op=RecuperarInformacionMatricula",{"idAlumno":idAlumno}, function(data, status){
		data = JSON.parse(data);
		console.log(data);
debugger;
$("#info_alu_dni").empty();
$("#info_alu_nombres").empty();
$("#info_alu_nivel").empty();
$("#info_alu_grado").empty();
$("#info_apo_dni").empty();
$("#info_apo_nombres").empty();
$("#info_apo_telefono").empty();

$("#info_alu_dni").html("<strong>"+data.ALumnoDNI+"</strong>");
$("#info_alu_nombres").html("<strong>"+data.AlumnoNombres+"</strong>");
$("#info_alu_nivel").html("<strong>"+data.AlumnoNivel+"</strong>");
$("#info_alu_grado").html("<strong>"+data.AlumnoGradoSeccion+"</strong>");
$("#info_apo_dni").html("<strong>"+data.ApoderadoDNI+"</strong>");
$("#info_apo_nombres").html("<strong>"+data.ApoderadoNombre+"</strong>");
$("#info_apo_telefono").html("<strong>"+data.ApoderadoTelefono+"</strong>");



	});
}
function PagarDeuda(codigo,pagoActual){
    $("#numPago").val(codigo);
    $("#modulo_pago").show();
    $("#panel_tipoTarjeta").hide();
    $("#MontoPagar").val(0);
    $("#MontoIngreso").val(0);
    $("#MontoPagar").val(pagoActual);
    $("#importePagar").val("S/. "+pagoActual);
    $("#importePago").val("S/. 0.00");

    var tipoTAr=$("#idTarjeta").val();
    if(tipoTAr=='-'){
       $("#panel_tipoTarjeta").hide();
    }else{
       $("#panel_tipoTarjeta").show();
    }

     $("#FormularioPago").on("submit",function(e)
	{
	      RegistroPago(e);
	});

}
function iniciar_Valores(){

     $("#PagoTipoPago").change(function(){
        var tipoP= $("#PagoTipoPago").val();
         if(tipoP==2){
            $("#panel_tipoTarjeta").show();
         }else{
           $("#panel_tipoTarjeta").hide();
         }

     });
     $("#importePago").change(function(){
        debugger;
	 	var ingreso=$("#importePago").val();
         console.log("Ingreso actualizado:"+ingreso);
		if(ingreso!=''){
					$("#MontoIngreso").val(parseFloat($("#importePago").val()));
					$("#importePago").val("S/."+Formato_Moneda(parseFloat($("#importePago").val()),2))

				}else{
					$("#MontoIngreso").val(0);
					$("#importePago").val('S/. 0.00');

				}
	});

    $("#importePago").click(function(){

        console.log("RecuperadoCLik:"+$("#MontoIngreso").val());
		$("#importePago").val($("#MontoIngreso").val());
	});
	$("#importePago").blur(function(){

        console.log("RecuperadoBLUR:"+$("#MontoIngreso").val());
		$("#importePago").val("S/. "+Formato_Moneda($("#MontoIngreso").val(),2));
	});

}

function RegistroPago(){
      //cargar(true);
	event.preventDefault(); //No se activará la acción predeterminada del evento
    var error="";
    var pagoPagar=$("#MontoPagar").val();
    var importeIngreso=$("#MontoIngreso").val();

    $(".validarPanel").each(function(){
			if($(this).val()==" " || $(this).val()==0){
				error=error+$(this).data("message")+"<br>";
			}
    });

    if(parseFloat(pagoPagar)!=parseFloat(importeIngreso)){
        error=error+"Importe Ingresado es Diferente al Importe a Pagar.";
    }

    if(error==""){
		$("#modulo_pago").addClass("whirl");
		$("#modulo_pago").addClass("ringed");
		setTimeout('AjaxRegistroPago()', 2000);
	}else{
 		notificar_warning("Complete :<br>"+error);
	}
}
function AjaxRegistroPago(){
	debugger;
    var idPlan=$("#idPlan").val();
    var idAlumno=$("#idAlumno").val();
     var formData = new FormData($("#FormularioPago")[0]);
        formData.append("idPlan",idPlan);
        formData.append("idAlumno",idAlumno);
		console.log(formData);
		$.ajax({
			url: "../../controlador/Gestion/CGestion.php?op=RegistrarPago",
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
						$("#modulo_pago").removeClass("whirl");
						$("#modulo_pago").removeClass("ringed");
						 swal("Error:", Mensaje);

					}else{
						$("#modulo_pago").removeClass("whirl");
						$("#modulo_pago").removeClass("ringed");

                        $('#FormularioPago')[0].reset();
					    swal("Acción:", Mensaje);
                        $("#modulo_pago").hide();
                        $("#modulo_Mensaje").show();
                        $("#MontoPagar").val(0);
                        $("#MontoIngreso").val(0);

                        RecuperarInformacionMatricula(idPlan,idAlumno);

					}
			 }
		});
}
function Volver(){
      $.redirect('../Operaciones/Operaciones.php');
}

init();
