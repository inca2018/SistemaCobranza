var tablaAlumno;
var tablaCuotas;
var tablaPagosDisponibles;

function init() {
    Iniciar_Componentes();
    Listar_Estado();
    Listar_Nivel();
    Listar_Grado();
    Listar_Seccion();
    Listar_Alumno();
    Listar_Pagos_Disponibles();
}

function Iniciar_Componentes() {
    //var fecha=hoyFecha();

    //$('#date_fecha_comprobante').datepicker('setDate',fecha);

    $("#FormularioAlumno").on("submit", function (e) {
        RegistroAlumno(e);
    });
    $('#dateFechaNacimiento').datepicker({
        format: 'dd/mm/yyyy',
        language: 'es'
    });




    $('#dateInicio').datepicker({
        format: 'dd/mm/yyyy',
    });
    $('#dateFin').datepicker({
        format: 'dd/mm/yyyy',
    });
    $('#dateInicio').datepicker().on('changeDate', function (ev) {
        var f_inicio = $("#FechaInicio").val();
        var f_fin = $("#FechaFin").val();
        var day = parseInt(f_inicio.substr(0, 2));
        var month = parseInt(f_inicio.substr(3, 2));
        var year = parseInt(f_inicio.substr(6, 8));

        $('#dateFin').datepicker('setStartDate', new Date(year, (month - 1), day));
    });
    $('#dateFin').datepicker().on('changeDate', function (ev) {
        var f_inicio = $("#FechaInicio").val();
        var f_fin = $("#FechaFin").val();
        var day = parseInt(f_fin.substr(0, 2));
        var month = parseInt(f_fin.substr(3, 2));
        var year = parseInt(f_fin.substr(6, 8));
        $('#dateInicio').datepicker('setEndDate', new Date(year, (month - 1), day));
    });

}

function RegistroAlumno(event) {
    //cargar(true);
    event.preventDefault(); //No se activará la acción predeterminada del evento
    var error = "";

    $(".validarPanel").each(function () {
        if ($(this).val() == " " || $(this).val() == 0) {
            error = error + $(this).data("message") + "<br>";
        }
    });

    if (error == "") {
        $("#ModalAlumno #cuerpo").addClass("whirl");
        $("#ModalAlumno #cuerpo").addClass("ringed");
        setTimeout('AjaxRegistroAlumno()', 2000);
    } else {
        notificar_warning("Complete :<br>" + error);
    }
}

function AjaxRegistroAlumno() {
    var formData = new FormData($("#FormularioAlumno")[0]);
    console.log(formData);
    $.ajax({
        url: "../../controlador/Mantenimiento/CAlumno.php?op=AccionAlumno",
        type: "POST",
        data: formData,
        contentType: false,
        processData: false,
        success: function (data, status) {
            data = JSON.parse(data);
            console.log(data);
            var Mensaje = data.Mensaje;
            var Error = data.Registro;
            if (!Error) {
                $("#ModalAlumno #cuerpo").removeClass("whirl");
                $("#ModalAlumno #cuerpo").removeClass("ringed");
                $("#ModalAlumno").modal("hide");
                swal("Error:", Mensaje);
                LimpiarAlumno();
                tablaAlumno.ajax.reload();
            } else {
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

function Listar_Estado() {
    $.post("../../controlador/Mantenimiento/CAlumno.php?op=listar_estados", function (ts) {
        $("#AlumnoEstado").append(ts);
    });
}

function Listar_Nivel() {
    $.post("../../controlador/Mantenimiento/CAlumno.php?op=listar_niveles", function (ts) {
        $("#AlumnoNivel").append(ts);
    });
}

function Listar_Grado() {
    $.post("../../controlador/Mantenimiento/CAlumno.php?op=listar_grados", function (ts) {
        $("#AlumnoGrado").append(ts);
    });
}

function Listar_Seccion() {
    $.post("../../controlador/Mantenimiento/CAlumno.php?op=listar_secciones", function (ts) {
        $("#AlumnoSeccion").append(ts);
    });
}

function Listar_Alumno() {
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

        "bDestroy": true,
        "columnDefs": [
            {
                "className": "text-center",
                "targets": [1, 2, 3, 4, 5, 6, 7]
            }
            , {
                "className": "text-left",
                "targets": [0]
            }
         , ],
        buttons: [
            {
                extend: 'copy',
                className: 'btn-info'
            }
            , {
                extend: 'csv',
                className: 'btn-info'
            }
            , {
                extend: 'excel',
                className: 'btn-info',
                title: 'Facturacion'
            }
            , {
                extend: 'pdfHtml5',
                className: 'btn-info sombra3',
                title: "Reporte de Alumnos",
                orientation: 'landscape',
                pageSize: 'LEGAL'
            }
            , {
                extend: 'print',
                className: 'btn-info'
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

function NuevoAlumno() {
    $("#ModalAlumno").modal({
        backdrop: 'static',
        keyboard: false
    });
    $("#ModalAlumno").modal("show");
    $("#tituloModalAlumno").empty();
    $("#tituloModalAlumno").append("Nuevo Alumno:");
}

function EditarAlumno(idPersona, idAlumno) {
    $("#ModalAlumno").modal({
        backdrop: 'static',
        keyboard: false
    });
    $("#ModalAlumno").modal("show");
    $("#tituloModalAlumno").empty();
    $("#tituloModalAlumno").append("Editar Alumno:");
    RecuperarAlumno(idPersona, idAlumno);
}

function RecuperarAlumno(idPersona, idAlumno) {
    //solicitud de recuperar Proveedor
    $.post("../../controlador/Mantenimiento/CAlumno.php?op=RecuperarInformacion_Alumno", {
        "idPersona": idPersona,
        "idAlumno": idAlumno
    }, function (data, status) {
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

function EliminarAlumno(idPersona, idAlumno) {
    swal({
        title: "Eliminar?",
        text: "Esta Seguro que desea Eliminar Alumno!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "Si, Eliminar!",
        closeOnConfirm: false
    }, function () {
        ajaxEliminarAlumno(idPersona, idAlumno);
    });
}

function ajaxEliminarAlumno(idPersona, idAlumno) {
    $.post("../../controlador/Mantenimiento/CAlumno.php?op=Eliminar_Alumno", {
        idPersona: idPersona,
        idAlumno: idAlumno
    }, function (data, e) {
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

function HabilitarAlumno(idPersona, idAlumno) {
    swal({
        title: "Habilitar?",
        text: "Esta Seguro que desea Habilitar Alumno!",
        type: "info",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "Si, Habilitar!",
        closeOnConfirm: false
    }, function () {
        ajaxHabilitarAlumno(idPersona, idAlumno);
    });
}

function ajaxHabilitarAlumno(idPersona, idAlumno) {
    $.post("../../controlador/Mantenimiento/CAlumno.php?op=Recuperar_Alumno", {
        idPersona: idPersona,
        idAlumno: idAlumno
    }, function (data, e) {
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

function LimpiarAlumno() {
    $('#FormularioAlumno')[0].reset();
    $("#idAlumno").val("");

}

function Cancelar() {
    LimpiarAlumno();
    $("#ModalAlumno").modal("hide");

}

function Volver() {
    $.redirect('../Operaciones/Operaciones.php');
}

function VerPlanPago(idPersona, idAlumno) {
    $("#ModalPlanPago").modal({
        backdrop: 'static',
        keyboard: false
    });
    $("#ModalPlanPago").modal("show");

    Mostrar_Informacion_Alumno(idPersona, idAlumno);
    Recuperar_Pagos_Registrado(idAlumno);
    ListarCuotas(idAlumno);

}

function Salir() {
    LimpiarPlan();
    $("#ModalPlanPago").modal("hide");
    $("#CuotaEdicion").val("");
    $("#area_Edicion").hide();
    $("#titulo_editar_cuota").hide();

    $('#dateInicio').datepicker("option", {
        minDate: null,
        maxDate: null
    });
    $('#dateInicio').datepicker("option", {
        minDate: null,
        maxDate: null
    });
}

function Mostrar_Informacion_Alumno(idPersona, idAlumno) {
    $.post("../../controlador/Mantenimiento/CAlumno.php?op=RecuperarInformacion_Alumno", {
        "idPersona": idPersona,
        "idAlumno": idAlumno
    }, function (data, status) {
        data = JSON.parse(data);
        console.log(data);

        $("#O_idPersona").val(data.idPersona);
        $("#O_idAlumno").val(data.idAlumno);
        $("#O_PlanCreado").val(data.PlanP);

        $("#datos_dni").val(data.DNI);
        $("#datos_apellido").val(data.apellidoPaterno + " " + data.apellidoMaterno);
        $("#datos_nombres").val(data.nombrePersona);
        $("#datos_direccion").val(data.direccion);
        $("#datos_telefono").val(data.telefono);
        $("#datos_nivel").val(data.NivelNombre);
        $("#datos_grado").val(data.GradoNombre);
        $("#datos_seccion").val(data.SeccionNombre);

        $("#Area_Edicion").hide();


    });
}

function ActualizarPagos() {
    ArregloPagos = [];

    $('.seleccion_pagos:checked').each(function () {
        var idPago = $(this).attr("id");
        ArregloPagos.push(idPago);
    });
    var idAlumno = $("#O_idAlumno").val();


    $("#area_tabla_pagos").addClass("whirl");
    $("#area_tabla_pagos").addClass("ringed");
    $.post("../../controlador/Mantenimiento/CAlumno.php?op=ActualizarPagos", {
        "Pagos": ArregloPagos.join(','),
        "idAlumno": idAlumno
    }, function (data, status) {
        data = JSON.parse(data);
        var Accion = data.Accion;
        var Mensaje = data.Mensaje;
        if (Accion) {

            $("#area_tabla_pagos").removeClass("whirl");
            $("#area_tabla_pagos").removeClass("ringed");
            notificar_success(Mensaje);
        } else {
            ("#area_tabla_pagos").removeClass("whirl");
            $("#area_tabla_pagos").removeClass("ringed");
            notificar_warning(Mensaje);
        }
    });
}

function Recuperar_Pagos_Registrado(idAlumno) {
    $.post("../../controlador/Mantenimiento/CAlumno.php?op=RecuperarPagoAlumno", {
        "idAlumno": idAlumno
    }, function (data, status) {
        data = JSON.parse(data);
        console.log(data);
        var arrayDeCadenas = data.Pagos.split("-");
        var ultimo = arrayDeCadenas.pop();

        $('.seleccion_pagos').each(function () {
            $(this).removeAttr('checked');
        });

        $('.seleccion_pagos').each(function () {

            var idSeleccion = $(this).attr("id");
            for (x = 0; x < arrayDeCadenas.length; x++) {
                if (arrayDeCadenas[x] == idSeleccion) {
                    $(this).attr('checked', 'checked');
                }
            }
        });
    });
}

function Listar_Pagos_Disponibles() {
    tablaPagosDisponibles = $('#tablaPagos').dataTable({
        "aProcessing": true,
        "aServerSide": true,
        "processing": true,
        "paging": false, // Paginacion en tabla
        "ordering": true, // Ordenamiento en columna de tabla
        "info": false, // Informacion de cabecera tabla
        "responsive": true, // Accion de responsive
        "searching": false,
        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
        "order": [[0, "asc"]],

        "bDestroy": false,
        "columnDefs": [
            {
                "className": "text-center",
                "targets": [0, 3, 4]
            }
            , {
                "className": "text-left",
                "targets": [1]
            },
            {
                "className": "text-right",
                "targets": [2]
            }
         , ],
        "ajax": { //Solicitud Ajax Servidor
            url: '../../controlador/Mantenimiento/CAlumno.php?op=Listar_Tipo_Pagos',
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
    tablaPagosDisponibles.on('order.dt search.dt', function () {
        tablaPagosDisponibles.column(0, {
            search: 'applied',
            order: 'applied'
        }).nodes().each(function (cell, i) {
            cell.innerHTML = i + 1;
        });
    }).draw();
}


function EdicionCampos() {

    $("#edicion_importe").click(function () {
        $("#Area_Edicion").show();
        $("#campoEdicion").val($("#O_importe_matricula").val());
        $("#EdicionAccion").val("montoMatricula");
        $("#campoEdicion").removeAttr("onkeypress");
        $("#campoEdicion").attr("onkeypress", "return SoloNumerosModificado(event,8,this.id);");
    });
    $("#edicion_cuota").click(function () {
        $("#Area_Edicion").show();
        $("#campoEdicion").val($("#O_importe_cuota").val());
        $("#EdicionAccion").val("montoCuota");
        $("#campoEdicion").removeAttr("onkeypress");
        $("#campoEdicion").attr("onkeypress", "return SoloNumerosModificado(event,8,this.id);");
    });
    $("#edicion_adicional1").click(function () {
        $("#Area_Edicion").show();
        $("#campoEdicion").val($("#O_importe_adicional1").val());
        $("#EdicionAccion").val("otroPago1");
        $("#campoEdicion").removeAttr("onkeypress");
        $("#campoEdicion").attr("onkeypress", "return SoloNumerosModificado(event,8,this.id);");
    });
    $("#edicion_adicional2").click(function () {
        $("#Area_Edicion").show();
        $("#campoEdicion").val($("#O_importe_adicional2").val());
        $("#EdicionAccion").val("otroPago2");
        $("#campoEdicion").removeAttr("onkeypress");
        $("#campoEdicion").attr("onkeypress", "return SoloNumerosModificado(event,8,this.id);");

    });

    $("#edicion_obser").click(function () {
        $("#Area_Edicion").show();
        $("#campoEdicion").val($("#O_observaciones").val());
        $("#EdicionAccion").val("Observaciones");
        $("#campoEdicion").removeAttr("onkeypress");
        $("#campoEdicion").attr("onkeypress", "return SoloLetras(event,150,this.id);");

    });
}

function ActualizarEdicion() {
    debugger;
    var campoEdicion = $("#campoEdicion").val();
    var campo = $("#EdicionAccion").val();
    var idAlumno = $("#O_idAlumno").val();
    $.post("../../controlador/Mantenimiento/CAlumno.php?op=ActualizarCampo", {
        idAlumno: idAlumno,
        campoEdicion: campoEdicion,
        campo: campo
    }, function (data, e) {
        data = JSON.parse(data);
        var Error = data.Error;
        var Mensaje = data.Mensaje;
        if (Error) {
            notificar_danger(Mensaje);
        } else {
            notificar_success(Mensaje);
            var persona_id = $("#O_idPersona").val();
            var alumno_id = $("#O_idAlumno").val();
            Mostrar_Informacion_Alumno(persona_id, alumno_id);
        }
    });
}

function RegistroMatricula(event) {
    event.preventDefault();

    var error = "";

    var imp_matricula = $("#O_importe_matricula").val();
    var imp_cuota = $("#O_importe_cuota").val();
    var imp_adicional1 = $("#O_importe_adicional1").val();
    var imp_adicional2 = $("#O_importe_adicional2").val();

    if (imp_matricula == 0) {
        error = error + "- Importe Matricula. <br>";
    }
    if (imp_cuota == 0) {
        error = error + "- Importe Cuota. <br>";
    }

    if (error == "") {
        $("#cuerpo_matricula").addClass("whirl");
        $("#cuerpo_matricula").addClass("ringed");
        setTimeout('AjaxRegistroMatricula()', 2000);
    } else {
        notificar_warning("Complete :<br>" + error);
    }

}

function AjaxRegistroMatricula() {
    var formData = new FormData($("#FormularioMatricula")[0]);
    console.log(formData);
    $.ajax({
        url: "../../controlador/Mantenimiento/CAlumno.php?op=AccionMatricula",
        type: "POST",
        data: formData,
        contentType: false,
        processData: false,
        success: function (data, status) {
            data = JSON.parse(data);
            console.log(data);
            var Mensaje = data.Mensaje;
            var Error = data.Registro;
            if (!Error) {
                $("#cuerpo_matricula").removeClass("whirl");
                $("#cuerpo_matricula").removeClass("ringed");
                //$("#ModalPlanPago").modal("hide");
                swal("Error:", Mensaje);
            } else {
                $("#cuerpo_matricula").removeClass("whirl");
                $("#cuerpo_matricula").removeClass("ringed");
                //$("#ModalPlanPago").modal("hide");
                swal("Acción:", Mensaje);

                var idPersona = $("#O_idPersona").val();
                var idAlumno = $("#O_idAlumno").val();
                Mostrar_Informacion_Alumno(idPersona, idAlumno);
                tablaAlumno.ajax.reload();
            }
        }
    });
}

function LimpiarPlan() {

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

function AgregarCuota() {
    var Cantidad = $("#CantidadCuota").val();
    swal({
        title: "Agregar?",
        text: "Esta Seguro que desea Agregar " + Cantidad + " cuota Nuevas!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "Si, Agregar!",
        closeOnConfirm: false
    }, function () {
        if (Cantidad == '' || Cantidad == 0) {
            notificar_warning("Ingrese Cantidad Valida.");
        } else {
            ajaxAgregarCuota(Cantidad);
        }

    });
}

function ajaxAgregarCuota(Cantidad) {
    var idAlumno = $("#O_idAlumno").val();

    $.post("../../controlador/Mantenimiento/CAlumno.php?op=AgregarCuotaNueva", {
        O_idAlumno: idAlumno,
        Cantidad: Cantidad
    }, function (data, e) {
        data = JSON.parse(data);
        var Error = data.Registro;
        var Mensaje = data.Mensaje;
        if (!Error) {
            swal("Error", Mensaje, "error");
        } else {
            swal("Agregado!", Mensaje, "success");
            tablaCuotas.ajax.reload();
            tablaAlumno.ajax.reload();
        }
    });
}

function EditarFechas(idCuota) {
    $("#CuotaEdicion").val(idCuota);
    $("#area_Edicion").show();
    $("#titulo_editar_cuota").show();
    $('#ModalPlanPago').animate({
        scrollTop: 0
    }, 'slow');
}

function ActualizarFecha() {
    var idAlumno = $("#O_idAlumno").val();
    var idCuota = $("#CuotaEdicion").val();
    var fecha_inicio = $("#FechaInicio").val();
    var fecha_fin = $("#FechaFin").val();
    if (fecha_inicio == '' || fecha_fin == '' || fecha_inicio == null || fecha_fin == null) {
        notificar_warning("Complete las Fechas para continuar con la Edición");
    } else {
        ActualizarFechas(idAlumno, idCuota, fecha_inicio, fecha_fin);

    }
}

function ActualizarFechas(idAlumno, idCuota, fecha_inicio, fecha_fin) {
    $.post("../../controlador/Mantenimiento/CAlumno.php?op=ActualizarFechas", {
        O_idAlumno: idAlumno,
        idCuota: idCuota,
        inicio: fecha_inicio,
        fin: fecha_fin
    }, function (data, e) {
        data = JSON.parse(data);
        var Error = data.Actualizar;
        var Mensaje = data.Mensaje;
        if (!Error) {
            swal("Error", Mensaje, "error");
        } else {
            swal("Agregado!", Mensaje, "success");
            tablaCuotas.ajax.reload();
            tablaAlumno.ajax.reload();
            $("#CuotaEdicion").val("");
            $("#area_Edicion").hide();
            $("#titulo_editar_cuota").hide();



            $('#dateInicio').datepicker("option", {
                minDate: null,
                maxDate: null
            });
            $('#dateFin').datepicker("option", {
                minDate: null,
                maxDate: null
            });


        }



    });

}

function ListarCuotas(idAlumno) {

    tablaCuotas = $('#tablaCuotas').dataTable({
        "aProcessing": true,
        "aServerSide": true,
        "processing": true,
        "paging": true, // Paginacion en tabla
        "ordering": true, // Ordenamiento en columna de tabla
        "info": true, // Informacion de cabecera tabla
        "responsive": true, // Accion de responsive

        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
        "order": [[0, "asc"]],

        "bDestroy": true,
        "columnDefs": [
            {
                "className": "text-center",
                "targets": [0, 1, 2, 3, 4, 5, 6]
            }
            , {
                "className": "text-left",
                "targets": [0]
            }
         , ],
        buttons: [
            {
                extend: 'copy',
                className: 'btn-info'
            }
            , {
                extend: 'csv',
                className: 'btn-info'
            }
            , {
                extend: 'excel',
                className: 'btn-info',
                title: 'Facturacion'
            }
            , {
                extend: 'pdfHtml5',
                className: 'btn-info sombra3',
                title: "Reporte de Cuotas",
                orientation: 'landscape',
                pageSize: 'LEGAL'
            }
            , {
                extend: 'print',
                className: 'btn-info'
            }
            ],
        "ajax": { //Solicitud Ajax Servidor
            url: '../../controlador/Mantenimiento/CAlumno.php?op=Listar_Cuotas',
            type: "POST",
            dataType: "JSON",
            data: {
                idAlumno: idAlumno
            },
            error: function (e) {
                console.log(e.responseText);
            }
        },
        // cambiar el lenguaje de datatable
        oLanguage: español,
    }).DataTable();
    //Aplicar ordenamiento y autonumeracion , index
    tablaCuotas.on('order.dt search.dt', function () {
        tablaCuotas.column(0, {
            search: 'applied',
            order: 'applied'
        }).nodes().each(function (cell, i) {
            cell.innerHTML = i + 1;
        });
    }).draw();
}

function AnularCuota(idCuota, estado) {
    swal({
        title: "Anular?",
        text: "Esta Seguro que desea Anular Cuota!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "Si, Eliminar!",
        closeOnConfirm: false
    }, function () {
        if (estado == 6 || estado == 7) {
            swal("Error", "No puede Anular Cuota,porque se encuentra Pagada.", "error");
        } else {
            ajaxAnularCuota(idCuota);
        }

    });
}

function ajaxAnularCuota(idCuota) {
    $.post("../../controlador/Mantenimiento/CAlumno.php?op=AnularCuota", {
        idCuota: idCuota
    }, function (data, e) {
        data = JSON.parse(data);
        var Error = data.Error;
        var Mensaje = data.Mensaje;
        if (Error) {
            swal("Error", Mensaje, "error");
        } else {
            swal("Anulado!", Mensaje, "success");
            tablaCuotas.ajax.reload();
        }
    });
}

function HabilitarCuota(idCuota, estado) {
    swal({
        title: "Recuperar?",
        text: "Esta Seguro que desea Recuperar Cuota!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "Si, Recuperar!",
        closeOnConfirm: false
    }, function () {
        ajaxRecuperarCuota(idCuota);
    });
}

function ajaxRecuperarCuota(idCuota) {
    $.post("../../controlador/Mantenimiento/CAlumno.php?op=RecuperarCuota", {
        idCuota: idCuota
    }, function (data, e) {
        data = JSON.parse(data);
        var Error = data.Error;
        var Mensaje = data.Mensaje;
        if (Error) {
            swal("Error", Mensaje, "error");
        } else {
            swal("Recuperado!", Mensaje, "success");
            tablaCuotas.ajax.reload();
        }
    });
}

init();
