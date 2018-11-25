function init(){

    Verificar_Comunicado();

    $("#FormularioComunicado").on("submit", function (e) {
        RegistroComunicado(e);
    });
}

function Verificar_Comunicado(){
      $.post("../../controlador/Gestion/CGestion.php?op=VerificarComunicado", function (data, status) {
        data = JSON.parse(data);

        if(data==null){
            $("#exiteComunicado").addClass("text-danger");
             $("#exiteComunicado").empty();
             $("#exiteComunicado").append("ACTUALMENTE NO EXITE UN COMUNICADO AGREGADO");
        }else{
             $("#exiteComunicado").addClass("text-success");
             $("#exiteComunicado").empty();
             $("#exiteComunicado").append("ACTUALMENTE EXITE UN COMUNICADO AGREGADO");
        }

    });
}

function RegistroComunicado(event) {
    //cargar(true);
    event.preventDefault(); //No se activará la acción predeterminada del evento
    var error = "";

    if($("#Titulo").val()==null || $("#Titulo").val()==""){
       error=error+" - Titulo del Comunicado.<br>";
       }
     if($("#adjuntar_documento").val()==null || $("#adjuntar_documento").val()==""){
       error=error+" - DocumentoAdjunto.<br>";
       }

    if (error == "") {
        $("#contenedor").addClass("whirl");
        $("#contenedor").addClass("ringed");
        setTimeout('AjaxRegistroComunicado()', 2000);
    } else {
        notificar_warning("Complete :<br>" + error);
    }
}

function AjaxRegistroComunicado() {
    var formData = new FormData($("#FormularioComunicado")[0]);
    console.log(formData);
    $.ajax({
        url: "../../controlador/Gestion/CGestion.php?op=RegistroComunicado",
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
                $("#contenedor").removeClass("whirl");
                $("#contenedor").removeClass("ringed");
                swal("Error:", Mensaje);
                Verificar_Comunicado();

            } else {
                $("#contenedor").removeClass("whirl");
                $("#contenedor").removeClass("ringed");
                swal("Acción:", Mensaje);
                 $("#Titulo").val("");
                $("#adjuntar_documento").val(null);
                 Verificar_Comunicado();
            }
        }
    });
}

init();
