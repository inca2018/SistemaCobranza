var tablaDeuda1;
var tablaDeuda2;
var tablaPagar;

function init() {
	Listar_TipoDeTarjeta();
	Listar_TipoPago();
	var idAlumno = $("#idAlumno").val();
	RecuperarInformacionMatricula(idAlumno);
	iniciar_Valores();
	ListarYear();
	$("#yearSelect").change(function () {
		var year = $("#yearSelect").val();
		var idAlumno = $("#idAlumno").val();
		$("#year_Actual").val(year);
		Listar_Deudas1(idAlumno, year);
		Listar_Deudas2(idAlumno, year);
		Recuperar_Totales();
	});
	Iniciar_Acciones();
}

function Iniciar_Acciones() {

	$('#Selector_matricula').change(function () {
		if (this.checked == true) {
			$('.pagos_matricula').each(function () {
				$(this).attr('checked', 'checked');
			});
		}
		else {
			$('.pagos_matricula').each(function () {
				$(this).removeAttr('checked');
			});
		}
	});

	$(".pagos_matricula").change(function(){
		console.log("click!!");
	});
	$('#Selector_pensiones').change(function () {
		if (this.checked == true) {
			$('.pagos_pensiones').each(function () {
				$(this).attr('checked', 'checked');
			});
		}
		else {
			$('.pagos_pensiones').each(function () {
				$(this).removeAttr('checked');
			});
		}
	});
	$("#m_importe_pagar").change(function () {
		var importe = $("#m_importe_pagar").val();
		var total = $("#pagar_importe").val();
		if (importe != '') {
			if (importe <= total) {
				$("#pagar_importe").val(parseFloat(importe));
				$("#m_importe_pagar").val("S/. " + Formato_Moneda(parseFloat(importe), 2));
			}
			else {
				notificar_warning("Ingrese un Monto Menor al Importe a Pagar.");
				$("#pagar_importe").val(parseFloat(total));
				$("#m_importe_pagar").val("S/. " + Formato_Moneda(parseFloat(total), 2));
			}
		}
		else {
			$("#pagar_importe").val(0);
			$("#m_importe_pagar").val("S/. 0.00");
		}
	});
	$("#m_importe_pagar").click(function () {
		$("#m_importe_pagar").val($("#pagar_importe").val());
	});
	$("#m_importe_pagar").blur(function () {
		$("#m_importe_pagar").val("S/. " + Formato_Moneda($("#pagar_importe").val(), 2));
	});
	$("#m_importe_mora_pagar").change(function () {
		var importe = $("#m_importe_mora_pagar").val();
		var total = $("#pagar_importe_mora").val();
		if (importe != '') {
			if (importe <= total) {
				$("#pagar_importe_mora").val(parseFloat(importe));
				$("#m_importe_mora_pagar").val("S/. " + Formato_Moneda(parseFloat(importe), 2));
			}
			else {
				notificar_warning("Ingrese un Monto Menor al Importe a Pagar");
				$("#pagar_importe_mora").val(parseFloat(total));
				$("#m_importe_mora_pagar").val("S/. " + Formato_Moneda(parseFloat(total), 2));
			}
		}
		else {
			$("#pagar_importe_mora").val(0);
			$("#m_importe_mora_pagar").val("S/. 0.00");
		}
	});
	$("#m_importe_mora_pagar").click(function () {
		$("#m_importe_mora_pagar").val($("#pagar_importe_mora").val());
	});
	$("#m_importe_mora_pagar").blur(function () {
		$("#m_importe_mora_pagar").val("S/. " + Formato_Moneda($("#pagar_importe_mora").val(), 2));
	});
	$("#m_importe_pagar_cliente").change(function () {
		var importe = $("#m_importe_pagar_cliente").val();
		var total = $("#oculto_importe_total").val();
		if (importe != '') {
			if (importe >= total) {
				$("#oculto_importe_pagar").val(parseFloat(importe));
				$("#m_importe_pagar_cliente").val("S/. " + Formato_Moneda(parseFloat(importe), 2));
				$("#oculto_importe_vuelto").val(importe - total);
				$("#m_importe_vuelto").val(Formato_Moneda(parseFloat(importe - total), 2));
			}
			else {
				notificar_warning("Ingrese un Monto Mayor o Igual al Importe a Pagar");
				$("#oculto_importe_pagar").val(parseFloat(0));
				$("#m_importe_pagar_cliente").val("S/. " + Formato_Moneda(parseFloat(0), 2));
				$("#oculto_importe_vuelto").val(0);
				$("#m_importe_vuelto").val(Formato_Moneda(parseFloat(0), 2));
			}
		}
		else {
			$("#oculto_importe_pagar").val(0);
			$("#m_importe_pagar_cliente").val("S/. 0.00");
			$("#oculto_importe_vuelto").val(0);
			$("#m_importe_vuelto").val(Formato_Moneda(parseFloat(0), 2));
		}
	});
	$("#m_importe_pagar_cliente").click(function () {
		$("#m_importe_pagar_cliente").val($("#oculto_importe_pagar").val());
	});
	$("#m_importe_pagar_cliente").blur(function () {
		$("#m_importe_pagar_cliente").val("S/. " + Formato_Moneda($("#oculto_importe_pagar").val(), 2));
	});
	$("#FormularioPago").on("submit", function (e) {
		RegistrarPagoP(e);
	});
}

function RegistrarPagoP(event) {
	//cargar(true);
	event.preventDefault(); //No se activará la acción predeterminada del evento
	var error = "";
	if (error == "") {
		$("#ModuloPago").addClass("whirl");
		$("#ModuloPago").addClass("ringed");
		setTimeout('AjaxRegistroPagoP()', 2000);
	}
	else {
		notificar_warning("Complete :<br>" + error);
	}
}

function AjaxRegistroPagoP() {
	var formData = new FormData($("#FormularioPago")[0]);
	console.log(formData);
	$.ajax({
		url: "../../controlador/Gestion/CGestion.php?op=RegistrarPagoP"
		, type: "POST"
		, data: formData
		, contentType: false
		, processData: false
		, success: function (data, status) {
			data = JSON.parse(data);
			console.log(data);
			var Mensaje = data.Mensaje;
			var Error = data.Registro;
			if (!Error) {
				$("#ModuloPago").removeClass("whirl");
				$("#ModuloPago").removeClass("ringed");
				$("#ModalAlumno").modal("hide");
				swal("Error:", Mensaje);
				tablaDeuda1.ajax.reload();
				tablaDeuda2.ajax.reload();
				tablaPagar.ajax.reload();
				Recuperar_Totales();
				$("#ModalPago").modal("hide");
			}
			else {
				$("#ModuloPago").removeClass("whirl");
				$("#ModuloPago").removeClass("ringed");
				swal("Acción:", Mensaje);
				tablaDeuda1.ajax.reload();
				tablaDeuda2.ajax.reload();
				tablaPagar.ajax.reload();
				Recuperar_Totales();
				$("#ModalPago").modal("hide");
			}
		}
	});
}

function ListarYear() {
	$.post("../../controlador/Gestion/CMatricula.php?op=ListarYear", function (ts) {
		$("#yearSelect").append(ts);
		var year = $("#yearSelect").val();
		var idAlumno = $("#idAlumno").val();
		$("#year_Actual").val(year);
		Listar_Deudas1(idAlumno, year);
		Listar_Deudas2(idAlumno, year);
		Listar_Pagar(idAlumno, year);
		Recuperar_Totales();
	});
}

function Listar_TipoDeTarjeta() {
	$.post("../../controlador/Gestion/CGestion.php?op=listar_tipoTarjeta", function (ts) {
		$("#PagoTipoTarjeta").append(ts);
	});
}

function Listar_TipoPago() {
	$.post("../../controlador/Gestion/CGestion.php?op=listar_tipoPago", function (ts) {
		$("#PagoTipoPago").append(ts);
	});
}

function Recuperar_Totales() {
	var year = $("#yearSelect").val();
	var idAlumno = $("#idAlumno").val();
	//solicitud de recuperar Proveedor
	$.post("../../controlador/Gestion/CGestion.php?op=RecuperarTotales", {
		"idAlumno": idAlumno
		, "year": year
	}, function (data, status) {
		data = JSON.parse(data);
		console.log(data);
		$("#oculto_importe_total").val(data.TotalPagar);
		$("#v_importe_total").val("S/. " + Formato_Moneda(parseFloat(data.TotalPagar)), 2);
	});
}

function RecuperarInformacionMatricula(idAlumno) {
	//solicitud de recuperar Proveedor
	$.post("../../controlador/Gestion/CGestion.php?op=RecuperarInformacionMatricula", {
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
		$("#info_apo_dni").html("<strong>" + data.ApoderadoDNI + "</strong>");
		$("#info_apo_nombres").html("<strong>" + data.ApoderadoNombre + "</strong>");
		$("#info_apo_telefono").html("<strong>" + data.ApoderadoTelefono + "</strong>");
	});
}

function PagarDeuda(codigo, pagoActual) {
	$("#numPago").val(codigo);
	$("#modulo_pago").show();
	$("#panel_tipoTarjeta").hide();
	$("#MontoPagar").val(0);
	$("#MontoIngreso").val(0);
	$("#MontoPagar").val(pagoActual);
	$("#importePagar").val("S/. " + pagoActual);
	$("#importePago").val("S/. 0.00");
	var tipoTAr = $("#idTarjeta").val();
	if (tipoTAr == '-') {
		$("#panel_tipoTarjeta").hide();
	}
	else {
		$("#panel_tipoTarjeta").show();
	}
	$("#FormularioPago").on("submit", function (e) {
		RegistroPago(e);
	});
}

function iniciar_Valores() {
	$("#PagoTipoPago").change(function () {
		var tipoP = $("#PagoTipoPago").val();
		if (tipoP == 2) {
			$("#panel_tipoTarjeta").show();
		}
		else {
			$("#panel_tipoTarjeta").hide();
		}
	});
	$("#importePago").change(function () {
		debugger;
		var ingreso = $("#importePago").val();
		console.log("Ingreso actualizado:" + ingreso);
		if (ingreso != '') {
			$("#MontoIngreso").val(parseFloat($("#importePago").val()));
			$("#importePago").val("S/." + Formato_Moneda(parseFloat($("#importePago").val()), 2))
		}
		else {
			$("#MontoIngreso").val(0);
			$("#importePago").val('S/. 0.00');
		}
	});
	$("#importePago").click(function () {
		console.log("RecuperadoCLik:" + $("#MontoIngreso").val());
		$("#importePago").val($("#MontoIngreso").val());
	});
	$("#importePago").blur(function () {
		console.log("RecuperadoBLUR:" + $("#MontoIngreso").val());
		$("#importePago").val("S/. " + Formato_Moneda($("#MontoIngreso").val(), 2));
	});
}

function RegistroPago() {
	//cargar(true);
	event.preventDefault(); //No se activará la acción predeterminada del evento
	var error = "";
	var pagoPagar = $("#MontoPagar").val();
	var importeIngreso = $("#MontoIngreso").val();
	$(".validarPanel").each(function () {
		if ($(this).val() == " " || $(this).val() == 0) {
			error = error + $(this).data("message") + "<br>";
		}
	});
	if (parseFloat(pagoPagar) != parseFloat(importeIngreso)) {
		error = error + "Importe Ingresado es Diferente al Importe a Pagar.";
	}
	if (error == "") {
		$("#modulo_pago").addClass("whirl");
		$("#modulo_pago").addClass("ringed");
		setTimeout('AjaxRegistroPago()', 2000);
	}
	else {
		notificar_warning("Complete :<br>" + error);
	}
}

function AjaxRegistroPago() {
	var formData = new FormData($("#FormularioPago")[0]);
	$.ajax({
		url: "../../controlador/Gestion/CGestion.php?op=RegistrarPago"
		, type: "POST"
		, data: formData
		, contentType: false
		, processData: false
		, success: function (data, status) {
			data = JSON.parse(data);
			console.log(data);
			var Mensaje = data.Mensaje;
			var Error = data.Registro;
			if (!Error) {
				$("#modulo_pago").removeClass("whirl");
				$("#modulo_pago").removeClass("ringed");
				swal("Error:", Mensaje);
			}
			else {
				$("#modulo_pago").removeClass("whirl");
				$("#modulo_pago").removeClass("ringed");
				$('#FormularioPago')[0].reset();
				swal("Acción:", Mensaje);
				$("#modulo_pago").hide();
				$("#modulo_Mensaje").show();
				$("#MontoPagar").val(0);
				$("#MontoIngreso").val(0);
				RecuperarInformacionMatricula(idPlan, idAlumno);
			}
		}
	});
}

function Volver() {
	$.redirect('../Operaciones/Operaciones.php');
}

function Listar_Deudas1(idAlumno, year) {
	if (tablaDeuda1 == null) {
		tablaDeuda1 = $('#tablaDeudas1').dataTable({
			"aProcessing": true
			, "aServerSide": true
			, "processing": true
			, "paging": false, // Paginacion en tabla
			"ordering": false, // Ordenamiento en columna de tabla
			"info": true, // Informacion de cabecera tabla
			"responsive": true, // Accion de responsive
			"searching": false
			, "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]]
			, "order": [[0, "asc"]]
			, "bDestroy": true
			, "columnDefs": [
				{
					"className": "text-center"
					, "targets": [0, 1, 2, 5]
            }
            , {
					"className": "text-left"
					, "targets": [3]
            }, {
					"className": "text-right"
					, "targets": [4]
            }
         , ]
			, "ajax": { //Solicitud Ajax Servidor
				url: '../../controlador/Gestion/CGestion.php?op=ListarDeuda1'
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
			, "paging": false, // Paginacion en tabla
			"ordering": false, // Ordenamiento en columna de tabla
			"info": true, // Informacion de cabecera tabla
			"responsive": true, // Accion de responsive
			"searching": false
			, "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]]
			, "order": [[0, "asc"]]
			, "bDestroy": true
			, "columnDefs": [
				{
					"className": "text-center"
					, "targets": [0, 1, 2, 5]
            }
            , {
					"className": "text-left"
					, "targets": [3]
            }, {
					"className": "text-right"
					, "targets": [4]
            }
         , ]
			, "ajax": { //Solicitud Ajax Servidor
				url: '../../controlador/Gestion/CGestion.php?op=ListarDeuda1'
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
			, "paging": false, // Paginacion en tabla
			"ordering": false, // Ordenamiento en columna de tabla
			"info": true, // Informacion de cabecera tabla
			"responsive": true, // Accion de responsive
			"searching": false
			, "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]]
			, "order": [[0, "asc"]]
			, "columnDefs": [
				{
					"className": "text-center"
					, "targets": [1, 2, 3, 4, 5, 6, 7, 8]
            }
            , {
					"className": "text-left"
					, "targets": [0]
            }, {
					"className": "text-right"
					, "targets": [4]
            }
         , ]
			, "ajax": { //Solicitud Ajax Servidor
				url: '../../controlador/Gestion/CGestion.php?op=ListarDeuda2'
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
			, "paging": false, // Paginacion en tabla
			"ordering": false, // Ordenamiento en columna de tabla
			"info": true, // Informacion de cabecera tabla
			"responsive": true, // Accion de responsive
			"searching": false
			, "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]]
			, "order": [[0, "asc"]]
			, "columnDefs": [
				{
					"className": "text-center"
					, "targets": [1, 2, 3, 4, 5, 6, 7, 8]
            }
            , {
					"className": "text-left"
					, "targets": [0]
            }, {
					"className": "text-right"
					, "targets": [4]
            }
         , ]
			, "ajax": { //Solicitud Ajax Servidor
				url: '../../controlador/Gestion/CGestion.php?op=ListarDeuda2'
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

function Listar_Pagar(idAlumno, year) {
	if (tablaPagar == null) {
		tablaPagar = $('#tablaPagar').dataTable({
			"aProcessing": true
			, "aServerSide": true
			, "processing": true
			, "paging": false, // Paginacion en tabla
			"ordering": false, // Ordenamiento en columna de tabla
			"info": true, // Informacion de cabecera tabla
			"responsive": true, // Accion de responsive
			"searching": false
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
					, "targets": [0]
            }
         , ]
			, "ajax": { //Solicitud Ajax Servidor
				url: '../../controlador/Gestion/CGestion.php?op=ListarPagar'
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
		tablaPagar.on('order.dt search.dt', function () {
			tablaPagar.column(0, {
				search: 'applied'
				, order: 'applied'
			}).nodes().each(function (cell, i) {
				cell.innerHTML = i + 1;
			});
		}).draw();
	}
	else {
		tablaPagar.destroy();
		tablaPagar = $('#tablaDeudas2').dataTable({
			"aProcessing": true
			, "aServerSide": true
			, "processing": true
			, "paging": false, // Paginacion en tabla
			"ordering": false, // Ordenamiento en columna de tabla
			"info": true, // Informacion de cabecera tabla
			"responsive": true, // Accion de responsive
			"searching": false
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
					, "targets": []
            }
         , ]
			, "ajax": { //Solicitud Ajax Servidor
				url: '../../controlador/Gestion/CGestion.php?op=ListarPagar'
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
		tablaPagar.on('order.dt search.dt', function () {
			tablaPagar.column(0, {
				search: 'applied'
				, order: 'applied'
			}).nodes().each(function (cell, i) {
				cell.innerHTML = i + 1;
			});
		}).draw();
	}
}

function EnviarPago(idAlumno, idPago, year, importe, mora, TipoPago, TituloPago) {
	//Tipo pago M=MATRICULA, P=PENSION
	$("#idAlumnoP").val(idAlumno);
	$("#yearP").val(year);
	$("#importePago").val(importe);
	$("#importeMora").val(mora);
	$("#TipoPago").val(TipoPago);
	$("#codigoPago").val(idPago);
	$("#tituloPago").val(TituloPago);
	$("#pagar_importe").val(parseFloat(importe));
	$("#pagar_importe_mora").val(parseFloat(mora));
	$("#m_importe_pagar").val("S/. " + Formato_Moneda(parseFloat(importe), 2));
	$("#m_importe_mora_pagar").val("S/. " + Formato_Moneda(parseFloat(mora), 2));
	$("#m_importe").val("S/. " + Formato_Moneda(parseFloat(importe), 2));
	$("#m_importe_mora").val("S/. " + Formato_Moneda(parseFloat(mora), 2));
	if (parseFloat(mora) > 0) {
		$("#modulo_mora").show();
	}
	else {
		$("#modulo_mora").hide();
	}
	$("#ModalPago").modal("show");
}

function EliminarPagar(idPagar, importePagar, idAlumno, year, idCuota, idMatricula, TipoPago) {
	swal({
		title: "Eliminar?"
		, text: "Esta Seguro que desea Eliminar Pago Agregado!"
		, type: "warning"
		, showCancelButton: true
		, confirmButtonColor: "#DD6B55"
		, confirmButtonText: "Si, Eliminar!"
		, closeOnConfirm: false
	}, function () {
		ajaxEliminarPagar(idPagar, importePagar, idAlumno, year, idCuota, idMatricula, TipoPago);
	});
}

function ajaxEliminarPagar(idPagar, importePagar, idAlumno, year, idCuota, idMatricula, TipoPago) {
	$.post("../../controlador/Gestion/CGestion.php?op=EliminarPagar", {
		idPagar: idPagar
		, importePagar: importePagar
		, idAlumno: idAlumno
		, year: year
		, idCuota: idCuota
		, idMatricula: idMatricula
		, TipoPago: TipoPago
	}, function (data, e) {
		data = JSON.parse(data);
		var Error = data.Eliminar;
		var Mensaje = data.Mensaje;
		if (!Error) {
			swal("Error", Mensaje, "error");
		}
		else {
			swal("Eliminado!", Mensaje, "success");
			tablaDeuda1.ajax.reload();
			tablaDeuda2.ajax.reload();
			tablaPagar.ajax.reload();
			Recuperar_Totales();
		}
	});
}

function AbrirPago() {
	var importe_pagar = $("#oculto_importe_pagar").val();
	var importe_total = $("#oculto_importe_total").val();
	var importe_vuelto = $("#oculto_importe_vuelto").val();
}
init();
