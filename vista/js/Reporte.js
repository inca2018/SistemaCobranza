var datos;
var datos2;
var sumaDisponible=0;
var sumaNoDisponible=0;
var sumaDisponible2=0;
var sumaNoDisponible2=0;
var cuerpo="";
var cuerpo2="";
var cont=0;


var tabladetalle1;
var tabladetalle2;


function init(){

    ListarYear();

}

function ListarYear() {
    var idAlumno = $("#idUsuario").val();

        $.post("../../controlador/Gestion/CMatricula.php?op=ListarYear", function (ts) {
            $("#yearSelect").empty();
            $("#yearSelect").append(ts);
        });

}


function buscar_reporte(){

   var year=$("#yearSelect").val();
   var mes=$("#Meses").val();

	if(year=='' || mes==''){
		  	notificar_warning("Ingrese Parametros Necesarios.")
		}else{

           mostrar_Tabla_detalles1(year,mes);
             mostrar_Tabla_detalles2(year,mes);
		}
}


function mostrar_Tabla_detalles1(year,mes){
    if(tabladetalle1==null){
        tabladetalle1 = $('#tabla_Detalles1').dataTable({
		"aProcessing": true,
		"aServerSide": true,
		"processing": true,
		"paging": false, // Paginacion en tabla
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
               , "targets": [0,1,2,3,4]
            }
            , {
               "className": "text-left"
               , "targets": []
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
				extend: 'pdfHtml5',
				className: 'btn-info sombra3',
				title: "Sistema de Matricula - Jose Galvez - Reporte" ,
				orientation: 'landscape',
				pageSize: 'LEGAL',
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
			url: '../../controlador/Gestion/CGestion.php?op=ListarReportes1',
			type: "POST",
			dataType: "JSON",
			data:{year:year,mes:mes},
			error: function (e) {
				console.log(e.responseText);
			}
		},
		// cambiar el lenguaje de datatable
		oLanguage: español,
	}).DataTable();
	//Aplicar ordenamiento y autonumeracion , index
	tabladetalle1.on('order.dt search.dt', function () {
		tabladetalle1.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
    }else{
        tabladetalle1.destroy();
        tabladetalle1 = $('#tabla_Detalles1').dataTable({
		"aProcessing": true,
		"aServerSide": true,
		"processing": true,
		"paging": false, // Paginacion en tabla
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
               , "targets": [0,1,2,3,4]
            }
            , {
               "className": "text-left"
               , "targets": []
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
				extend: 'pdfHtml5',
				className: 'btn-info sombra3',
				title: "Sistema de Matricula - Jose Galvez - Reporte" ,
				orientation: 'landscape',
				pageSize: 'LEGAL',
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
			url: '../../controlador/Gestion/CGestion.php?op=ListarReportes1',
			type: "POST",
			dataType: "JSON",
			data:{year:year,mes:mes},
			error: function (e) {
				console.log(e.responseText);
			}
		},
		// cambiar el lenguaje de datatable
		oLanguage: español,
	}).DataTable();
	//Aplicar ordenamiento y autonumeracion , index
	tabladetalle1.on('order.dt search.dt', function () {
		tabladetalle1.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
    }

}
function mostrar_Tabla_detalles2(year,mes){
    if(tabladetalle2==null){
       tabladetalle2 = $('#tabla_Detalles2').dataTable({
		"aProcessing": true,
		"aServerSide": true,
		"processing": true,
		"paging": false, // Paginacion en tabla
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
               , "targets": [0,1,2,3,4]
            }
            , {
               "className": "text-left"
               , "targets": []
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
				extend: 'pdfHtml5',
				className: 'btn-info sombra3',
				title: "Sistema de Matricula - Jose Galvez - Reporte" ,
				orientation: 'landscape',
				pageSize: 'LEGAL',
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
			url: '../../controlador/Gestion/CGestion.php?op=ListarReportes2',
			type: "POST",
			dataType: "JSON",
			data:{year:year,mes:mes},
			error: function (e) {
				console.log(e.responseText);
			}
		},
		// cambiar el lenguaje de datatable
		oLanguage: español,
	}).DataTable();
	//Aplicar ordenamiento y autonumeracion , index
	tabladetalle2.on('order.dt search.dt', function () {
		tabladetalle2.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
       }else{
       tabladetalle2.destroy();
       tabladetalle2 = $('#tabla_Detalles2').dataTable({
		"aProcessing": true,
		"aServerSide": true,
		"processing": true,
		"paging": false, // Paginacion en tabla
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
               , "targets": [0,1,2,3,4]
            }
            , {
               "className": "text-left"
               , "targets": []
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
				extend: 'pdfHtml5',
				className: 'btn-info sombra3',
				title: "Sistema de Matricula - Jose Galvez - Reporte" ,
				orientation: 'landscape',
				pageSize: 'LEGAL',
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

            }
            ],
         "ajax": { //Solicitud Ajax Servidor
			url: '../../controlador/Gestion/CGestion.php?op=ListarReportes2',
			type: "POST",
			dataType: "JSON",
			data:{year:year,mes:mes},
			error: function (e) {
				console.log(e.responseText);
			}
		},
		// cambiar el lenguaje de datatable
		oLanguage: español,
	}).DataTable();
	//Aplicar ordenamiento y autonumeracion , index
	tabladetalle2.on('order.dt search.dt', function () {
		tabladetalle2.column(0, {
			search: 'applied',
			order: 'applied'
		}).nodes().each(function (cell, i) {
			cell.innerHTML = i + 1;
		});
	}).draw();
       }

}
init();
