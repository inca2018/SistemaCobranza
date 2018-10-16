function init(){

 Listar_TipoDeTarjeta();
 Listar_TipoPago();

var idPlan=$("#idPlan").val();
var idAlumno=$("#idAlumno").val();
RecuperarInformacionMatricula(idPlan,idAlumno);

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

function RecuperarInformacionMatricula(idPlan,idAlumno){
    //solicitud de recuperar Proveedor
	$.post("../../controlador/Gestion/CGestion.php?op=RecuperarInformacionMatricula",{"idPlan":idPlan,"idAlumno":idAlumno}, function(data, status){
		data = JSON.parse(data);
		console.log(data);

$("#cab_nombre_alumno").append();
$("#cab_dni_alumno").append();
$("#cab_nombre_apoderado").append();
$("#cab_dni_apoderado").append();
$("#pago_matricula").append();
$("#pago_adicional1").append();
$("#pago_adicional2").append();


$("#cab_nombre_alumno").html("<b>"+data.AlumnoNombre+"</b>");
$("#cab_dni_alumno").html("<b>"+data.ApoderadoDNI+"</b>");
$("#cab_nombre_apoderado").html("<b>"+data.ApoderadoNombre+"</b>");
$("#cab_dni_apoderado").html("<b>"+data.DNI+"</b>");
$("#pago_matricula").html("<b>S/. "+data.montoMatricula+"</b>");
$("#pago_adicional1").html("<b>S/. "+data.otroPago1+"</b>");
$("#pago_adicional2") .html("<b>S/. "+data.otroPago2+"</b>");

var NoPagado='<button type="button" class="btn btn-success" onclick="PagarDeuda(1)">PAGAR</button>';
var Pagado='<div class="badge badge-success">PAGADO</div>';
var pagoActual=0;
if(data.Estado1==0){
    pagoActual=data.montoMatricula;
    $("#accionPago1").append();
    $("#accionPago1").html('<button type="button" class="btn btn-success" onclick="PagarDeuda('+1+','+pagoActual+')">PAGAR</button>');

}else{
    $("#accionPago1").append();
    $("#accionPago1").html(Pagado);
}

if(data.Estado2==0){
     pagoActual=data.otroPago1;
    $("#accionPago2").append();
    $("#accionPago2").html('<button type="button" class="btn btn-success" onclick="PagarDeuda('+2+','+pagoActual+')">PAGAR</button>');

}else{
    $("#accionPago2").append();
    $("#accionPago2").html(Pagado);
}

if(data.Estado3==0){
     pagoActual=data.otroPago2;
    $("#accionPago3").append();
    $("#accionPago3").html('<button type="button" class="btn btn-success" onclick="PagarDeuda('+3+','+pagoActual+')">PAGAR</button>');

}else{
    $("#accionPago3").append();
    $("#accionPago3").html(Pagado);
}

$("#idTarjeta").val(data.idTipoTarjetaApoderado);
$("#modulo_pago").hide();
$("#modulo_Mensaje").hide();


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
