var tablaOperacion;

function init(){

Listar_Operacion();
RecuperarParametros();

}
function
RecuperarParametros(){
		$.post("../../controlador/Gestion/CGestion.php?op=RecuperarParametros", function(data, status){
			data = JSON.parse(data);

$("#total_alumnos").append();
$("#total_apoderados").append();
$("#ind_empleados_operaciones").append();
$("#ind_asignado").append();


$("#total_alumnos").html("<b>"+data.NumAlumnos+"</b>");
$("#total_apoderados").html("<b>"+data.NumApoderados+"</b>");
$("#ind_empleados_operaciones").html("<b>"+data.PagoHoy+"</b>");
$("#ind_asignado").html("<b>"+data.VencidoHoy+"</b>");

		});

}

function Listar_Operacion(){
	tablaOperacion = $('#tablaOperaciones').dataTable({
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
               , "targets": [0,5,6,7,8,9]
            }
            , {
               "className": "text-left"
               , "targets": [1,2,3,4]
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
            },
            {
               extend: 'pdfHtml5'
               , className: 'btn-info sombra3'
               , title: "Reporte de Operaciones"
               ,orientation: 'landscape'
               ,pageSize: 'LEGAL'
            }
            , {
               extend: 'print'
               , className: 'btn-info'
            }
            ],
         "ajax": { //Solicitud Ajax Servidor
			url: '../../controlador/Gestion/CGestion.php?op=Listar_Operaciones',
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
	tablaOperacion.on('order.dt search.dt', function () {
		tablaOperacion.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
}

function MostrarGestionAlumnos(){
    $.redirect('../Mantenimiento/MantAlumno.php');
}

function MostrarGestionApoderados(){
    $.redirect('../Mantenimiento/MantApoderado.php');
}

function PagoMatricula(idAlumno){
    $.redirect('../Operaciones/PagoMatricula.php',{'idAlumno':idAlumno});
}
function PagoCuota(idAlumno){
    $.redirect('../Operaciones/PagoCuota.php',{'idAlumno':idAlumno});
}
init();
