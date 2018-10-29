var tablaMatricula;
var tablaPagosDisponibles;
var tablaCuotas;
var accionAgregar;

function init() {
    ListarYear();
    ListarNivel(null);
    ListarGrado(null);
    ListarSeccion(null);
    Listar_Pagos_Disponibles();
}

function Listar_Matriculas(year) {
    tablaMatricula = $('#tablaMatricula').dataTable({
        "aProcessing": true,
        "aServerSide": true,
        "processing": true,
        "paging": true, // Paginacion en tabla
        "ordering": true, // Ordenamiento en columna de tabla
        "info": true, // Informacion de cabecera tabla
        "responsive": true, // Accion de responsive
        "searching": true,
        dom: 'lBfrtip',
        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
        "order": [[0, "asc"]],

        "bDestroy": true,
        "columnDefs": [
            {
                "className": "text-center",
                "targets": [1, 2, 3, ]
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
                title: "Reporte de Matriculas",
                orientation: 'landscape',
                pageSize: 'LEGAL'
            }
            , {
                extend: 'print',
                className: 'btn-info'
            }
            ],
        "ajax": { //Solicitud Ajax Servidor
            url: '../../controlador/Gestion/CMatricula.php?op=Listar_Matriculas',
            type: "POST",
            dataType: "JSON",
            data: {
                year: year
            },
            error: function (e) {
                console.log(e.responseText);
            }
        },
        // cambiar el lenguaje de datatable
        oLanguage: español,
    }).DataTable();
    //Aplicar ordenamiento y autonumeracion , index
    tablaMatricula.on('order.dt search.dt', function () {
        tablaMatricula.column(0, {
            search: 'applied',
            order: 'applied'
        }).nodes().each(function (cell, i) {
            cell.innerHTML = i + 1;
        });
    }).draw();
}

function ListarYear() {
    $.post("../../controlador/Gestion/CMatricula.php?op=ListarYear", function (ts) {
        $("#yearSelect").append(ts);

        var year = $("#yearSelect").val();
        $("#year_Actual").val(year);
        Listar_Matriculas(year);
        IniciarComponentes();
    });
}

function ListarNivel(nivel) {
    $.post("../../controlador/Gestion/CMatricula.php?op=listar_niveles", function (ts) {
        $("#AlumnoNivel").empty();
        $("#AlumnoNivel").append(ts);
        if(nivel!=null){
            $("#AlumnoNivel").val(nivel);
        }
    });
}

function ListarGrado(grado) {
    $.post("../../controlador/Gestion/CMatricula.php?op=listar_grados", function (ts) {
        $("#AlumnoGrado").empty(ts);
        $("#AlumnoGrado").append(ts);
        if(grado!=null){
          $("#AlumnoGrado").val(grado);
        }
    });
}

function ListarSeccion(seccion) {
    $.post("../../controlador/Gestion/CMatricula.php?op=listar_secciones", function (ts) {
        $("#AlunnoSeccion").empty(ts);
        $("#AlunnoSeccion").append(ts);
        if(seccion!=null){
           $("#AlunnoSeccion").val(seccion);
        }
    });
}


function IniciarComponentes() {
    $("#yearSelect").change(function () {
        var year = $("#yearSelect").val();
        $("#year_Actual").val(year);
        Listar_Matriculas(year);
    });

    $('#buscador_alumno').on('keyup', function () {
        console.log("Buscando ... " + $('#buscador_alumno').val());
        tablaMatricula.columns(3).search($('#buscador_alumno').val(), false, true).draw();

    });

}

function AgregarPlanPensiones() {
    accionAgregar=true;
    var tipoPlan = $("#planPensiones").val();
    var year = $("#year_Actual").val();
    var idPersona = $("#O_idPersona").val();
    var idAlumno = $("#O_idAlumno").val();
    if (tipoPlan == 0) {
        //plan no seleccionado
        LimpiarPlan(idPersona, idAlumno, year);
    } else if (tipoPlan == 1) {
        //plan anual
        AgregarPlan1(idPersona, idAlumno, year);
    } else {
        //plan medio año
        AgregarPlan2(idPersona, idAlumno, year);
    }
}

function AgregarPlan1(idPersona, idAlumno, year) {
    //solicitud de recuperar Proveedor
    $.post("../../controlador/Gestion/CMatricula.php?op=AgregarPlan1", {
        "idPersona": idPersona,
        "idAlumno": idAlumno,
        "year": year,
    }, function (data, status) {
        data = JSON.parse(data);
        console.log(data);
        var registro = data.Registro;
        var Mensaje=data.Mensaje;
        if (registro) {
            tablaCuotas.ajax.reload();
        } else {
            notificar_warning(Mensaje);
        }

    });
}

function AgregarPlan2(idPersona, idAlumno, year) {
    //solicitud de recuperar Proveedor
    $.post("../../controlador/Gestion/CMatricula.php?op=AgregarPlan2", {
        "idPersona": idPersona,
        "idAlumno": idAlumno,
        "year": year,
    }, function (data, status) {
        data = JSON.parse(data);
        console.log(data);
        var registro = data.Registro;
         var Mensaje=data.Mensaje;
        if (registro) {
            tablaCuotas.ajax.reload();
        } else {
            notificar_warning(Mensaje);
        }

    });
}

function LimpiarPlan(idPersona, idAlumno, year) {
    //solicitud de recuperar Proveedor
    $.post("../../controlador/Gestion/CMatricula.php?op=LimpiarMatricula", {
        "idPersona": idPersona,
        "idAlumno": idAlumno,
        "year": year,
    }, function (data, status) {
        data = JSON.parse(data);
        console.log(data);
        var registro = data.Registro;
        var Mensaje=data.Mensaje;
        if (registro) {
            tablaCuotas.ajax.reload();
        } else {
            notificar_warning(Mensaje);
        }

    });
}

function Matricular(idPersona, idAlumno) {

    $("#ModalMatricula").modal({
        backdrop: 'static',
        keyboard: false
    });
    $("#ModalMatricula").modal("show");
    var year = $("#yearSelect").val();
    RecuperarDatosAlumno(idPersona, idAlumno, year);

}

function RecuperarDatosAlumno(idPersona, idAlumno, year) {
    //solicitud de recuperar Proveedor
    $.post("../../controlador/Gestion/CMatricula.php?op=RecuperarDatosAlumno", {
        "idPersona": idPersona,
        "idAlumno": idAlumno,
        "year": year,
    }, function (data, status) {
        data = JSON.parse(data);
        console.log(data);

        $("#O_idAlumno").val(idAlumno);
        $("#O_idPersona").val(idPersona);
        $("#datos_nombres").val(data.nombrePersona);
        $("#datos_apellido").val(data.apellidoPaterno + " " + data.apellidoMaterno);
        $("#datos_dni").val(data.DNI);
        $("#datos_telefono").val(data.telefono);
        $("#datos_direccion").val(data.direccion);
        $("#matricula").val(data.Matricula);
        var CantidadCuotas=data.CantidadCuotas;

        if(CantidadCuotas==0){
             $("#planPensiones").val(0);
           }else if(CantidadCuotas==10){
             $("#planPensiones").val(1);
           }else{
             $("#planPensiones").val(2);
           }

        if (data.Matricula == 1) {
            //tiene matricula
             accionAgregar=true;

            ListarNivel(data.Nivel);
            ListarGrado(data.Grado);
            ListarSeccion(data.Seccion)
            Recuperar_Pagos_Registrado(idAlumno,year);
            ActualizarModal();

        } else {
             accionAgregar=false;
            // no tiene matricula

            Limpiar();
            ActualizarModal();
        }
        Listar_Cuotas_Registradas(idPersona,idAlumno,year);

    });
}

function Salir() {
    var idAlumno = $("#O_idAlumno").val();
    var idPersona = $("#O_idPersona").val();
    var year = $("#yearSelect").val();
    var matricula = $("#matricula").val();
    if (matricula == 0) {
        LimpiarPlan(idPersona, idAlumno, year);
    }

    $("#ModalMatricula").modal("hide");
    $(".panelBoton").removeClass("active");
    $(".panelBoton").removeClass("show");
    $(".panelAccion").removeClass("active");
    $("#menu1").addClass("active");
    $("#menu1").addClass("show");
    $("#op_datos").addClass("active");
    Limpiar();

   accionAgregar=false;
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
            url: '../../controlador/Gestion/CMatricula.php?op=ListarPagosDisponibles',
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

function Listar_Cuotas_Registradas(idPersona, idAlumno, year) {
    if (tablaCuotas == null) {
        tablaCuotas = $('#tablaCuotas').dataTable({
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
                url: '../../controlador/Gestion/CMatricula.php?op=ListarCuotasDisponibles',
                type: "POST",
                dataType: "JSON",
                data: {
                    idPersona: idPersona,
                    idAlumno: idAlumno,
                    year: year
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
    } else {
        tablaCuotas.destroy();
        tablaCuotas = $('#tablaCuotas').dataTable({
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
                url: '../../controlador/Gestion/CMatricula.php?op=ListarCuotasDisponibles',
                type: "POST",
                dataType: "JSON",
                data: {
                    idPersona: idPersona,
                    idAlumno: idAlumno,
                    year: year
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


}

function MatricularAlumno() {
    var error="";
    var nivel = $("#AlumnoNivel").val();
    var grado = $("#AlumnoGrado").val();
    var seccion = $("#AlunnoSeccion").val();
    var idAlumno = $("#O_idAlumno").val();
    var idPersona = $("#O_idPersona").val();
    var year = $("#yearSelect").val();
    var pensiones=$("#planPensiones").val();
    ArregloPagos = [];

    $('.seleccion_pagos:checked').each(function () {
        var idPago = $(this).attr("id");
        ArregloPagos.push(idPago);
    });


    var matriculado = $("#matricula").val();

   if(nivel==null || nivel=='0' || nivel==0){
       error=error+"- Nivel Academico<BR>";
   }
    if(grado==null || grado=='0' || grado==0){
       error=error+"- Grado Academico<BR>";
   }
    if(seccion==null || seccion=='0' || seccion==0){
       error=error+"- Sección Academico<BR>";
   }
    if(ArregloPagos.length==0){
        error=error+"- Seleccione al menos un Tipo de Pago.<br>";
    }
    if(pensiones==0 || pensiones=='0'){
       error=error+"- Seleccione un Tipo de Plan de Pensiones.<br>";
       }
    if(!accionAgregar){
       error=error+"- Agregue un Plan de Pensiones.<br>";
    }
    if(error!=""){
        notificar_warning("Complete los siguientes requisitos para la Matricula:<br>"+error);
    }else{

        if (matriculado == 1) {
             $.post("../../controlador/Gestion/CMatricula.php?op=ActualizarMatricula", {
                "Pagos": ArregloPagos.join(','),
                "idAlumno": idAlumno,
                "idPersona":idPersona,
                "idNivel":nivel,
                "idGrado":grado,
                "idSeccion":seccion,
                "year":year
            }, function (data, status) {
                data = JSON.parse(data);
                var Registro = data.Registro;
                var Mensaje = data.Mensaje;
                if (Registro) {

                    notificar_success(Mensaje);
                    tablaMatricula.ajax.reload();
                    $("#ModalMatricula").modal("hide");
                    Limpiar();
                } else {

                    notificar_warning(Mensaje);
                }
            });
        } else {
            $.post("../../controlador/Gestion/CMatricula.php?op=RegistrarMatricula", {
                "Pagos": ArregloPagos.join(','),
                "idAlumno": idAlumno,
                "idPersona":idPersona,
                "idNivel":nivel,
                "idGrado":grado,
                "idSeccion":seccion,
                "year":year
            }, function (data, status) {
                data = JSON.parse(data);
                var Registro = data.Registro;
                var Mensaje = data.Mensaje;
                if (Registro) {

                    notificar_success(Mensaje);
                    tablaMatricula.ajax.reload();
                    $("#ModalMatricula").modal("hide");
                    Limpiar();
                } else {

                    notificar_warning(Mensaje);
                }
            });

        }
    }

}
function Limpiar(){
    $("#AlumnoNivel").val(0);
    $("#AlumnoGrado").val(0);
    $("#AlunnoSeccion").val(0);
    $("#planPensiones").val(0);

     $('.seleccion_pagos').each(function () {
            $(this).removeAttr('checked');
        });
    tablaPagosDisponibles.ajax.reload();
}
function ActualizarModal(){
    $(".panelBoton").removeClass("active");
    $(".panelBoton").removeClass("show");
    $(".panelAccion").removeClass("active");
    $("#menu1").addClass("active");
    $("#menu1").addClass("show");
    $("#op_datos").addClass("active");
}
function Recuperar_Pagos_Registrado(idAlumno, year) {
    $.post("../../controlador/Gestion/CMatricula.php?op=RecuperarPagoAlumno", {
        "idAlumno": idAlumno,
        "year": year
    }, function (data, status) {
        data = JSON.parse(data);
        console.log(data);

        $('.seleccion_pagos').each(function () {
            $(this).removeAttr('checked');
            $(this).removeAttr('onclick');
        });

        $('.seleccion_pagos').each(function () {

            var idSeleccion = $(this).attr("id");
            for (var i in data) {
               var dato=data[i];
                var id=dato.id;
                var estado=dato.estado;

                if (id == idSeleccion) {
                    $(this).attr('checked', 'checked');
                    //$(this).attr('data-estado',estado);
                    $(this).attr('onclick','Pagado(this.id,"'+estado+'");');
                }
             }
        });


    });
}


function Pagado(check,mensaje){
    debugger;
   if(mensaje=="NO"){
       //check.prop("checked", true);
   }else{
       $("#"+check).prop("checked", true);
       notificar_warning("No se puede deshabilitar porque tiene un pago realizado.");
   }
}
function volver(){
     $.redirect('../Operaciones/Operaciones.php',{});
}
init();
