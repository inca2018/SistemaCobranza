var datos;
var datos2;
var sumaDisponible=0;
var sumaNoDisponible=0;
var sumaDisponible2=0;
var sumaNoDisponible2=0;
var cuerpo="";
var cuerpo2="";
var cont=0;

function init(){

	iniciar();
	Mostrar_Indicadores();
}


function iniciar(){

		$('#date_inicio1').datepicker({
			 format: 'dd/mm/yyyy',

        });
	$('#date_fin1').datepicker({

		    format: 'dd/mm/yyyy',
    });

	$('#date_inicio1').datepicker().on('changeDate', function (ev) {
	    var f_inicio=$("#inicio1").val();
		 var f_fin=$("#fin1").val();
	   var day = parseInt(f_inicio.substr(0,2));
		var month = parseInt(f_inicio.substr(3,2));
		var year = parseInt(f_inicio.substr(6,8));
	 $('#date_fin1').datepicker('setStartDate',new Date(year,(month-1),day));
   });

	$('#date_fin1').datepicker().on('changeDate', function (ev) {
	    var f_inicio=$("#inicio1").val();
		 var f_fin=$("#fin1").val();
		var day = parseInt(f_fin.substr(0,2));
		var month = parseInt(f_fin.substr(3,2));
		var year = parseInt(f_fin.substr(6,8));

	 $('#date_inicio1').datepicker('setEndDate',new Date(year,(month-1),day));
   });

}
function Mostrar_Indicadores(){
		 datos = {
						               type: "pie",
										data : {
											datasets :[{
												data :[
														1,
														1,
													],
												backgroundColor: [

													"#5BC374",
													"#EE2D2A",

												],
											}],

											labels : [

												"% Cuotas No vencidas",
												"% Cuotas Vencidas",

											]
										   },
										options : {
											responsive : true,

										}

									};

			                 var canvas = document.getElementById('chart').getContext('2d');
					         window.pie = new Chart(canvas, datos);

	      datos2 = {
						               type: "pie",
										data : {
											datasets :[{
												data :[
														1,
														1,

													],
												backgroundColor: [

													"#5BC374",
													"#EE2D2A",

												],
											}],

											labels : [

												"% Cuotas Pagadas",
												"% Cuotas No Pagadas",


											]
										   },
										options : {
											responsive : true,

										}

									};

			                 var canvas = document.getElementById('chart2').getContext('2d');
					         window.pie2 = new Chart(canvas, datos2);
}
function buscar_reporte(){

   var f_inicio=$("#inicio1").val();
   var f_fin=$("#fin1").val();

	if(f_inicio=='' || f_fin==''){
		  	notificar_warning("Seleccione Fechas")
		}else{
			actualizar_indicadores1(f_inicio,f_fin);
			$("#body_detalles1").empty();
         $("#body_detalles2").empty();
		}
}
function actualizar_indicadores1(f_inicio,f_fin){

	$.post("../../controlador/Gestion/CGestion.php?op=RecuperarReporteFechas",{fechaInicio:f_inicio,fechaFin:f_fin}, function(data, status){
      data = JSON.parse(data);
		console.log(data);
      var cuotaTotal = parseInt(data.numCuotas);
      var cuotaPendiente = parseInt(data.cuotaPend);
		var cuotaPagada = parseInt(data.cuotaPagada);
		var cuotaVencida = parseInt(data.cuotaVencida);



		$("#ind_cuota_total").append();
		$("#ind_cuota_pendiente").append();
		$("#ind_cuota_pagada").append();
		$("#ind_cuota_vencida").append();

		$("#ind_cuota_total").html("<b>"+cuotaTotal+"</b>");
		$("#ind_cuota_pendiente").html("<b>"+cuotaPendiente+"</b>");
		$("#ind_cuota_pagada").html("<b>"+cuotaPagada+"</b>");
		$("#ind_cuota_vencida").html("<b>"+cuotaVencida+"</b>");

		var porcCartVencida=parseFloat((cuotaVencida*100)/cuotaTotal).toFixed(2);
		var porcCartNoVencida=parseFloat(100-porcCartVencida);


		var porcCartPagadas=parseFloat((cuotaPagada*100)/cuotaTotal).toFixed(2);
		var porcCartNoPagadas=parseFloat(100-porcCartPagadas);

		datos.data.datasets.splice(0);
		var newData = {
									backgroundColor : [
											"#5BC374",
											"#EE2D2A",


									],
									data : [porcCartNoVencida,porcCartVencida]
								};
		datos.data.datasets.push(newData);
		window.pie.update();

		datos2.data.datasets.splice(0);
		var newData2 = {
									backgroundColor : [
											"#5BC374",
											"#EE2D2A",


									],
									data : [porcCartNoPagadas,porcCartPagadas]
								};
		datos2.data.datasets.push(newData2);
		window.pie2.update();
    });
}
function detalles1(){

    var inicio=$("#inicio1").val();
    var fin=$("#fin1").val();
    if(inicio=='' || fin=='' ){
         swal("Error!", "Seleccione todos los indicadores para buscar reporte!.", "warning");
    }else{
        $('#modal_detalles1').modal({backdrop: 'static', keyboard: false})
        $("#modal_detalles1").modal('show');

       mostrar_Tabla_detalles1(inicio,fin);
    }

}
function detalles2(){

    var inicio=$("#inicio1").val();
    var fin=$("#fin1").val();
    if(inicio=='' || fin=='' ){
         swal("Error!", "Seleccione todos los indicadores para buscar reporte!.", "warning");
    }else{
        $('#modal_detalles2').modal({backdrop: 'static', keyboard: false})
        $("#modal_detalles2").modal('show');
       mostrar_Tabla_detalles2(inicio,fin);
    }

}

function mostrar_Tabla_detalles1(inicio,fin){
	  cuerpo="";
	 $.post("../../controlador/Gestion/CGestion.php?op=Recuperar_Detalle_Indicadores",{fechaInicio:inicio,fechaFin:fin}, function(data, status){
      data = JSON.parse(data);
         console.log(data);

     for (var i in data) {
         //console.log("entro:"+i);
       var dato=data[i];
        //console.log(data);
       var fecha=dato.dia;
       var Total=parseInt(dato.Total);
       var Pendiente=parseInt(dato.Pendiente);
		 var Pagada=parseInt(dato.Pagada);
       var Vencida=parseInt(dato.Vencida);

         var corre=(parseInt(i)+1);
         cuerpo=cuerpo+"<tr><th>"+corre+"</th><th class='text-center'>"+fecha+"</th><th class='text-center'>"+verificar(Pagada)+"</th><th class='text-center'>"+verificar(Total)+"</th><th class='text-center'>"+verificar(parseFloat(Pagada/Total).toFixed(2))+"</th></tr>"
        }

        $("#body_detalles1").empty();
        $("#body_detalles1").append(cuerpo);


   });
}

function mostrar_Tabla_detalles2(inicio,fin){
	     cuerpo2="";
	 $.post("../../controlador/Gestion/CGestion.php?op=Recuperar_Detalle_Indicadores",{fechaInicio:inicio,fechaFin:fin}, function(data, status){
      data = JSON.parse(data);
         console.log(data);

     for (var i in data) {
         //console.log("entro:"+i);
       var dato=data[i];
        //console.log(data);
       var fecha=dato.dia;
       var Total=parseInt(dato.Total);
       var Pendiente=parseInt(dato.Pendiente);
		 var Pagada=parseInt(dato.Pagada);
       var Vencida=parseInt(dato.Vencida);

         var corre=(parseInt(i)+1);
         cuerpo2=cuerpo2+"<tr><th>"+corre+"</th><th class='text-center'>"+fecha+"</th><th class='text-center'>"+verificar(Vencida)+"</th><th class='text-center'>"+verificar(Total)+"</th><th class='text-center'>"+verificar(parseFloat(Vencida/Total).toFixed(2))+"</th> </tr>"
        }

        $("#body_detalles2").empty();
        $("#body_detalles2").append(cuerpo2);



   });
}


function verificar(dato){
    if(isNaN(dato)){
        return 0;
    }else{
        var dato_Redondenado=Math.round(dato * 100) / 100;
        return dato_Redondenado;
    }
}

init();
