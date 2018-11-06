var tablaOperacion;
var tablaDeuda1;
var tablaDeuda2;

var tablaComprobantes;

function init(){

var perfil=$("#PerfilCodigo").val();
var usuario=$("#idUsuario").val();
ListarYear();
Listar_Operacion();
RecuperarParametros();
RecuperarInformacionMatricula(usuario);

	if(perfil==1 || perfil==6 || perfil==8){
		$("#modulo_empleado").show();
		$("#modulo_alumno").hide();
	}else if(perfil==9){
		$("#modulo_empleado").hide();
		$("#modulo_alumno").show();
	}

	$("#yearSelect").change(function () {
		var year = $("#yearSelect").val();
		var idAlumno = $("#idUsuario").val();
		$("#year_Actual").val(year);
		Listar_Deudas1(idAlumno, year);
		Listar_Deudas2(idAlumno, year);
	});
}


function ListarYear() {
	$.post("../../controlador/Gestion/CMatricula.php?op=ListarYear", function (ts) {
		$("#yearSelect").append(ts);
		var year = $("#yearSelect").val();
		var idAlumno = $("#idUsuario").val();
		$("#year_Actual").val(year);
		Listar_Deudas1(idAlumno, year);
		Listar_Deudas2(idAlumno, year);


	});
}
function Listar_Deudas1(idAlumno, year) {
	if (tablaDeuda1 == null) {
		tablaDeuda1 = $('#tablaDeudas1').dataTable({
			"aProcessing": true
			, "aServerSide": true
			, "processing": true
			, "paging": true, // Paginacion en tabla
			"ordering": true, // Ordenamiento en columna de tabla
			"info": true, // Informacion de cabecera tabla
			"responsive": true, // Accion de responsive
			"searching": false,
			  dom: 'lBfrtip'
			, "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]]
			, "order": [[0, "asc"]]
			, "bDestroy": true
			, "columnDefs": [
				{
					"className": "text-center"
					, "targets": [0, 1]
            }
            , {
					"className": "text-left"
					, "targets": [3]
            }, {
					"className": "text-right"
					, "targets": [1]
            }
         , ], buttons: [
            {
                extend: 'copy',
                className: 'btn-info',
                title: "Sistema de Matricula - Jose Galvez - Reporte"
            }

            , {
                extend: 'excel',
                className: 'btn-info',
                title: "Sistema de Matricula - Jose Galvez - Reporte"
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
                extend: 'print',
                className: 'btn-info',
                title: "Sistema de Matricula - Jose Galvez - Reporte"
            }
            ]
			, "ajax": { //Solicitud Ajax Servidor
				url: '../../controlador/Gestion/CGestion.php?op=ListarDeuda1A'
				, type: "POST"
				, dataType: "JSON"
				, data: {
					year: year
					, idAlumno: idAlumno
				}
				, error: function (e) {
					console.log(e.responseText);
				}
			}
			, // cambiar el lenguaje de datatable
			oLanguage: español
		, }).DataTable();
		//Aplicar ordenamiento y autonumeracion , index
		tablaDeuda1.on('order.dt search.dt', function () {
			tablaDeuda1.column(0, {
				search: 'applied'
				, order: 'applied'
			}).nodes().each(function (cell, i) {
				cell.innerHTML = i + 1;
			});
		}).draw();
	}
	else {
		tablaDeuda1.destroy();
		tablaDeuda1 = $('#tablaDeudas1').dataTable({
			"aProcessing": true
			, "aServerSide": true
			, "processing": true
			, "paging": true, // Paginacion en tabla
			"ordering": true, // Ordenamiento en columna de tabla
			"info": true, // Informacion de cabecera tabla
			"responsive": true, // Accion de responsive
			"searching": false,
			  dom: 'lBfrtip'
			, "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]]
			, "order": [[0, "asc"]]
			, "bDestroy": true
			, "columnDefs": [
				{
					"className": "text-center"
					, "targets": [0, 1]
            }
            , {
					"className": "text-left"
					, "targets": [3]
            }, {
					"className": "text-right"
					, "targets": [1]
            }
         , ],
			 buttons: [
            {
                extend: 'copy',
                className: 'btn-info',
                title: "Sistema de Matricula - Jose Galvez - Reporte"
            }

            , {
                extend: 'excel',
                className: 'btn-info',
                title: "Sistema de Matricula - Jose Galvez - Reporte"
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
                extend: 'print',
                className: 'btn-info',
                title: "Sistema de Matricula - Jose Galvez - Reporte"
            }
            ]
			, "ajax": { //Solicitud Ajax Servidor
				url: '../../controlador/Gestion/CGestion.php?op=ListarDeuda1A'
				, type: "POST"
				, dataType: "JSON"
				, data: {
					year: year
					, idAlumno: idAlumno
				}
				, error: function (e) {
					console.log(e.responseText);
				}
			}
			, // cambiar el lenguaje de datatable
			oLanguage: español
		, }).DataTable();
		//Aplicar ordenamiento y autonumeracion , index
		tablaDeuda1.on('order.dt search.dt', function () {
			tablaDeuda1.column(0, {
				search: 'applied'
				, order: 'applied'
			}).nodes().each(function (cell, i) {
				cell.innerHTML = i + 1;
			});
		}).draw();
	}
}

function Listar_Deudas2(idAlumno, year) {
	if (tablaDeuda2 == null) {
		tablaDeuda2 = $('#tablaDeudas2').dataTable({
			"aProcessing": true
			, "aServerSide": true
			, "processing": true
			, "paging": true, // Paginacion en tabla
			"ordering": true, // Ordenamiento en columna de tabla
			"info": true, // Informacion de cabecera tabla
			"responsive": true, // Accion de responsive
			"searching": false,
			  dom: 'lBfrtip'
			, "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]]
			, "order": [[0, "asc"]]
			, "columnDefs": [
				{
					"className": "text-center"
					, "targets": [1, 2, 3 ]
            }
            , {
					"className": "text-left"
					, "targets": [0]
            }, {
					"className": "text-right"
					, "targets": [4]
            }
         , ], buttons: [
            {
                extend: 'copy',
                className: 'btn-info',
                title: "Sistema de Matricula - Jose Galvez - Reporte"
            }

            , {
                extend: 'excel',
                className: 'btn-info',
               title: "Sistema de Matricula - Jose Galvez - Reporte"
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
                extend: 'print',
                className: 'btn-info',
                title: "Sistema de Matricula - Jose Galvez - Reporte"
            }
            ]
			, "ajax": { //Solicitud Ajax Servidor
				url: '../../controlador/Gestion/CGestion.php?op=ListarDeuda2A'
				, type: "POST"
				, dataType: "JSON"
				, data: {
					year: year
					, idAlumno: idAlumno
				}
				, error: function (e) {
					console.log(e.responseText);
				}
			}
			, // cambiar el lenguaje de datatable
			oLanguage: español
		, }).DataTable();
		//Aplicar ordenamiento y autonumeracion , index
		tablaDeuda2.on('order.dt search.dt', function () {
			tablaDeuda2.column(0, {
				search: 'applied'
				, order: 'applied'
			}).nodes().each(function (cell, i) {
				cell.innerHTML = i + 1;
			});
		}).draw();
	}
	else {
		tablaDeuda2.destroy();
		tablaDeuda2 = $('#tablaDeudas2').dataTable({
			"aProcessing": true
			, "aServerSide": true
			, "processing": true
			, "paging": true, // Paginacion en tabla
			"ordering": true, // Ordenamiento en columna de tabla
			"info": true, // Informacion de cabecera tabla
			"responsive": true, // Accion de responsive
			"searching": false,
			  dom: 'lBfrtip'
			, "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]]
			, "order": [[0, "asc"]]
			, "columnDefs": [
				{
					"className": "text-center"
					, "targets": [1, 2, 3]
            }
            , {
					"className": "text-left"
					, "targets": [0]
            }, {
					"className": "text-right"
					, "targets": [4]
            }
         , ], buttons: [
            {
                extend: 'copy',
                className: 'btn-info',
                title: "Sistema de Matricula - Jose Galvez - Reporte"
            }

            , {
                extend: 'excel',
                className: 'btn-info',
                title: "Sistema de Matricula - Jose Galvez - Reporte"
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
                extend: 'print',
                className: 'btn-info',
                title: "Sistema de Matricula - Jose Galvez - Reporte"
            }
            ]
			, "ajax": { //Solicitud Ajax Servidor
				url: '../../controlador/Gestion/CGestion.php?op=ListarDeuda2A'
				, type: "POST"
				, dataType: "JSON"
				, data: {
					year: year
					, idAlumno: idAlumno
				}
				, error: function (e) {
					console.log(e.responseText);
				}
			}
			, // cambiar el lenguaje de datatable
			oLanguage: español
		, }).DataTable();
		//Aplicar ordenamiento y autonumeracion , index
		tablaDeuda2.on('order.dt search.dt', function () {
			tablaDeuda2.column(0, {
				search: 'applied'
				, order: 'applied'
			}).nodes().each(function (cell, i) {
				cell.innerHTML = i + 1;
			});
		}).draw();
	}
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
               , className: 'btn-info',
                 title: "Sistema de Matricula - Jose Galvez - Reporte"
            }

            , {
               extend: 'excel'
               , className: 'btn-info'
               ,  title: "Sistema de Matricula - Jose Galvez - Reporte"
            },
            {
               extend: 'pdfHtml5'
               , className: 'btn-info sombra3'
               ,  title: "Sistema de Matricula - Jose Galvez - Reporte"
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
               , className: 'btn-info',
                 title: "Sistema de Matricula - Jose Galvez - Reporte"
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

function Pagos(idAlumno){
   $.redirect('../Operaciones/PagoMatricula.php',{'idAlumno':idAlumno});
}
function Comprobantes(idAlumno){
    $("#ModalComprobantes").modal("show");
    Listar_Comprobantes(idAlumno);
}

function Listar_Comprobantes(idAlumno) {
	if (tablaComprobantes == null) {
		tablaComprobantes = $('#tablaComprobantes').dataTable({
			"aProcessing": true
			, "aServerSide": true
			, "processing": true
			, "paging": true, // Paginacion en tabla
			"ordering": true, // Ordenamiento en columna de tabla
			"info": true, // Informacion de cabecera tabla
			"responsive": true, // Accion de responsive
			"searching": false,
			  dom: 'lBfrtip'
			, "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]]
			, "order": [[0, "asc"]]
			, "bDestroy": true
			, "columnDefs": [
				{
					"className": "text-center"
					, "targets": [0, 1]
            }
            , {
					"className": "text-left"
					, "targets": [3]
            }, {
					"className": "text-right"
					, "targets": [1]
            }
         , ], buttons: [
            {
                extend: 'copy',
                className: 'btn-info',
                title: "Sistema de Matricula - Jose Galvez - Reporte"
            }

            , {
                extend: 'excel',
                className: 'btn-info',
                title: "Sistema de Matricula - Jose Galvez - Reporte"
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
                extend: 'print',
                className: 'btn-info',
                title: "Sistema de Matricula - Jose Galvez - Reporte"
            }
            ]
			, "ajax": { //Solicitud Ajax Servidor
				url: '../../controlador/Gestion/CGestion.php?op=listarComprobantes'
				, type: "POST"
				, dataType: "JSON"
				, data: { idAlumno: idAlumno
				}
				, error: function (e) {
					console.log(e.responseText);
				}
			}
			, // cambiar el lenguaje de datatable
			oLanguage: español
		, }).DataTable();
		//Aplicar ordenamiento y autonumeracion , index
		tablaComprobantes.on('order.dt search.dt', function () {
			tablaComprobantes.column(0, {
				search: 'applied'
				, order: 'applied'
			}).nodes().each(function (cell, i) {
				cell.innerHTML = i + 1;
			});
		}).draw();
	}
	else {
		tablaComprobantes.destroy();
		tablaComprobantes = $('#tablaComprobantes').dataTable({
			"aProcessing": true
			, "aServerSide": true
			, "processing": true
			, "paging": true, // Paginacion en tabla
			"ordering": true, // Ordenamiento en columna de tabla
			"info": true, // Informacion de cabecera tabla
			"responsive": true, // Accion de responsive
			"searching": false,
			  dom: 'lBfrtip'
			, "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]]
			, "order": [[0, "asc"]]
			, "bDestroy": true
			, "columnDefs": [
				{
					"className": "text-center"
					, "targets": [0, 1]
            }
            , {
					"className": "text-left"
					, "targets": [3]
            }, {
					"className": "text-right"
					, "targets": [1]
            }
         , ],
			 buttons: [
            {
                extend: 'copy',
                className: 'btn-info',
                title: "Sistema de Matricula - Jose Galvez - Reporte"
            }

            , {
                extend: 'excel',
                className: 'btn-info',
                title: "Sistema de Matricula - Jose Galvez - Reporte"
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
                extend: 'print',
                className: 'btn-info',
                title: "Sistema de Matricula - Jose Galvez - Reporte"
            }
            ]
			, "ajax": { //Solicitud Ajax Servidor
				url: '../../controlador/Gestion/CGestion.php?op=listarComprobantes'
				, type: "POST"
				, dataType: "JSON"
				, data: {
	 idAlumno: idAlumno
				}
				, error: function (e) {
					console.log(e.responseText);
				}
			}
			, // cambiar el lenguaje de datatable
			oLanguage: español
		, }).DataTable();
		//Aplicar ordenamiento y autonumeracion , index
		tablaComprobantes.on('order.dt search.dt', function () {
			tablaComprobantes.column(0, {
				search: 'applied'
				, order: 'applied'
			}).nodes().each(function (cell, i) {
				cell.innerHTML = i + 1;
			});
		}).draw();
	}
}


function MatricularAlumnos(){
   $.redirect('../Operaciones/Matricula.php',{});
}

function RecuperarInformacionMatricula(idAlumno) {
	//solicitud de recuperar Proveedor
	$.post("../../controlador/Gestion/CGestion.php?op=RecuperarInformacionMatricula2", {
		"idAlumno": idAlumno
	}, function (data, status) {
		data = JSON.parse(data);
		console.log(data);
		$("#info_alu_dni").empty();
		$("#info_alu_nombres").empty();
		$("#info_alu_nivel").empty();
		$("#info_alu_grado").empty();
		$("#info_apo_dni").empty();
		$("#info_apo_nombres").empty();
		$("#info_apo_telefono").empty();
		$("#info_alu_dni").html("<strong>" + data.ALumnoDNI + "</strong>");
		$("#info_alu_nombres").html("<strong>" + data.AlumnoNombres + "</strong>");
		$("#info_alu_nivel").html("<strong>" + data.AlumnoNivel + "</strong>");
		$("#info_alu_grado").html("<strong>" + data.AlumnoGradoSeccion + "</strong>");
		//$("#info_apo_dni").html("<strong>" + data.ApoderadoDNI + "</strong>");
		//$("#info_apo_nombres").html("<strong>" + data.ApoderadoNombre + "</strong>");
		//$("#info_apo_telefono").html("<strong>" + data.ApoderadoTelefono + "</strong>");
	});
}
init();
