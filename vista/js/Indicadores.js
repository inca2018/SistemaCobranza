var datos;
var datos2;

function init(){

	ListarAlumnos();
	Mostrar_Indicadores();
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

			                 var canvas = document.getElementById('chart1').getContext('2d');
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

function ListarAlumnos(){
    $.post("../../controlador/Gestion/CGestion.php?op=listar_alumnos_filtro", function (ts) {
      $("#alumnosSelect").append(ts);
   });
}

function buscar_reporte1(){


	var usuario=$("#alumnosSelect").val();

	if(usuario=='' ){
		  	notificar_warning("Seleccione Alumno")
		}else{
			actualizar_indicadores1(usuario);
		}
}

function actualizar_indicadores1(idAlumno){

	$.post("../../controlador/Gestion/CGestion.php?op=RecuperarReporte",{idAlumno:idAlumno}, function(data, status){
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

init();
