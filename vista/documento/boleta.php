<?php
//require_once "../../modelos/Facturacion/MFactura.php";
require_once "conversion.php";
require_once "../../modelo/Gestion/MGestion.php";


function fechaCastellano ($fecha) {
  $fecha = substr($fecha, 0, 10);
  $numeroDia = date('d', strtotime($fecha));
  $dia = date('l', strtotime($fecha));
  $mes = date('F', strtotime($fecha));
  $anio = date('Y', strtotime($fecha));
  $dias_ES = array("Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo");
  $dias_EN = array("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday");
  $nombredia = str_replace($dias_EN, $dias_ES, $dia);
  $meses_ES = array("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre");
  $meses_EN = array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
  $nombreMes = str_replace($meses_EN, $meses_ES, $mes);

   return $nombredia." ".$numeroDia." de ".$nombreMes." de ".$anio;
}

function GeneracionFacturaPDF($detalles,$cuerpo){


    $total=$detalles["ImporteTotal"];
    $vuelto=$detalles["ImporteVuelto"];
    $pagado=$detalles["ImportePagar"];
    $corre=$detalles["ReciboVoucher"];
    $alumnoNombre=$detalles["NombresAlumno"];
    $alumnoDNI=$detalles["DNI"];
    $alumnoTelefono=$detalles["telefono"];
    $alumnoDireccion=$detalles["direccion"];

   $cambio = valorEnLetras($total,1);
   $fecha = $detalles['fechaRegistro'];
   $fecha_letras = fechaCastellano($fecha);

   $fecha_emi= date(" d/ m/ Y", strtotime($fecha));

   $Moneda=1;
   $valor='';
	 if($Moneda=='1'){
		 $valor="S./ ";
	 }else{
		 $valor="$. ";
	 }
	$int=1;

	$detalle_documento="";

	//$detalle_convertido=str_replace("      ","<br>",$detalles["Detalle"]);
    $correlativo=1;
	while ($reg=$cuerpo->fetch_object()){

			$detalle_documento.= '
            <tr>
               <th class="columnaA titulo_normal izquierda">'.$correlativo.'.-</th>
               <th class="columnaB titulo_normal izquierda" >'.$reg->NombrePago.'</th>
               <th class="columnaC titulo_normal derecha">S/. '.number_format($reg->ImportePago,2).'</th>
            </tr>';
          $correlativo=$correlativo+1;
	}

     $html = '<body>

      <div class="CabeceraArea">
         <table>
          <tr>
            <th colspan="2" class="imagen_altura centrar"><img src="../../vista/documento/logo.png" class="Logo"></th>
          </tr>
           <tr>
            <th colspan="2" class="titulo_recibo"><b>COLEGIO JOSÉ GÁLVEZ</b></th>
          </tr>
          <tr>
            <th colspan="2" class="titulo_normal">RUC: 20508843411</th>
          </tr>
         </table>
          <hr class="puntear">
         <table>
           <tr>
            <th colspan="2" class="titulo_normal izquierda"><b>FECHA: </b>'.$fecha_emi.'</th>
          </tr>
          <tr>
            <th  class="titulo_normal izquierda"><b>CLIENTE: </b>'.$alumnoNombre.'</th><th class="titulo_normal izquierda"><b>DNI:   </b>'.$alumnoDNI.'</th>
          </tr>
           <tr>
            <th colspan="2" class="titulo_normal izquierda"><b>DIRECCIÓN: </b>'.$alumnoDireccion.'</th>
          </tr>
         </table>
          <hr class="puntear">

          <table>
           <tr>
            <th class="columnaA titulo_recibo centrar">N°</th>
            <th class="columnaB titulo_recibo centrar">DETALLE</th>
            <th class="columnaC titulo_recibo centrar">IMPORTE</th>
          </tr>
             '.$detalle_documento.'
         </table>
         <hr class="puntear">
          <table>
           <tr>
            <th colspan="2" class="titulo_normal izquierda">MONTO TOTAL:</th>
            <th class="titulo_normal derecha">'.$valor. $detalles['ImporteTotal'] .'</th>
          </tr>
          <tr>
            <th colspan="2" class="titulo_normal izquierda">MONTO PAGADO:</th>
            <th class="titulo_normal derecha">'.$valor. $detalles['ImportePagar'] .'</th>
          </tr>
          <tr>
            <th colspan="2" class="titulo_normal izquierda">VUELTO:</th>
            <th class="titulo_normal derecha">'.$valor. $detalles['ImporteVuelto'] .'</th>
          </tr>
          <tr>
            <th  class="titulo_normal izquierda">SON:</th>
            <th colspan="2" class="titulo_normal izquierda">'.$cambio.'</th>
          </tr>
          <tr>
            <th  class="titulo_normal izquierda">FECHA:</th>
            <th colspan="2" class="titulo_normal izquierda">'.$fecha_letras.'</th>
          </tr>

         </table>
          <hr class="puntear">
          <table>
          <tr>
            <th colspan="3"  class="titulo_normal izquierda">GRACIAS POR LA REALIZACIÓN DE SU PAGO.</th>
           </tr>
           </table>
     </div>';


$html .='</body>';

        //==============================================================
        include("../../pdf/mpdf.php");

        $mpdf=new mPDF('format' => 'A6');

        $mpdf->SetDisplayMode('fullpage');
        // LOAD a stylesheet
        $stylesheet1 = file_get_contents('../../vista/documento/bootstrap.min.css');
        $stylesheet2 = file_get_contents('../../vista/documento/boleta.css');
        $mpdf->WriteHTML($stylesheet1,1);
        $mpdf->WriteHTML($stylesheet2,1);
        $mpdf->WriteHTML($html);

        $nombre_doc=$detalles['ReciboVoucher'].'.pdf';
        $ruta_pre='../../vista/Operaciones/Documento/';

        $ruta=Verificar_Carpeta($ruta_pre,$nombre_doc,$detalles['idPago']);

         $mpdf->Output($ruta,'F');



/* el error esta en el exit por que cierras el proceso */
//exit;

//==============================================================
//==============================================================
//==============================================================

    }


function Verificar_Carpeta($ruta,$nombre,$ruc){

	if (!file_exists($ruta.$ruc)) {
       mkdir($ruta.$ruc, 0777, true);
		return $ruta.$ruc."/".$nombre;
	}else{
		return $ruta.$ruc."/".$nombre;
	}

}
/*$num=3;
$datosFactura=$Factura->recuperar_factura($num);
$detalleFactura=$Factura->recuperar_factura_detalle($num);

GeneracionFacturaPDF($datosFactura,$detalleFactura);*/
?>
