<?php
//require_once "../../modelos/Facturacion/MFactura.php";
require_once "conversion.php";



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

	while ($reg=$cuerpo->fetch_object()){
			$detalle_documento.= '
            <tr id="cuerpoFactura">
               <td class="DNumero">1</td>
               <td colspan="2" class="DDetalle" >'.$reg->NombrePago.'</td>
               <td class="DTotal">S/. '.number_format($reg->ImportePago,2).'</td>
            </tr>';
	}


   $html = '<body>
     <!-- Content Wrapper. Contains page content -->
      <div class="content-wrapper">
            <div class="colum-2">
               <!-- <img src="../../views/documento/logo.png" class="Logo"> -- >
            </div>
            <div class="colum-2">
              <address>
                <b>COLEGIO XXXX</b><br>
                Cal. los Ruiseñores 323 - Surquillo<br>
                Ruc: 20508843411<br>
                Telefono: 01-4627633<br>
                Correo:contactoqs@example.com.pe <br>
                Web: www.colegio.com.pe
              </address>
            </div>
            <div class="colum-2">
              <div>
                 <div class="bloqueA">
                 <span class="titulo2">R.U.C 20508843411</span>
                 </div>
                 <div class="bloqueB">
                 <span class="titulo3">RECIBO DE PAGO</span>
                 </div>
                  <div class="bloqueC">
                  <span class="titulo2">1</span>
              </div>
            </div>
            </div>
         <hr class="general">
     </div>';

$html .="
        <div class='cliente-info'>
            <div class='caja'>
                <span class='DatosCliente'>Datos del Alumno:</span>
            </div>
            <div class='DatosClienteTabla'>
               <table class='table table-bordered'>
                  <tbody>
                     <tr>
                        <td>Razón Social:</td>
                        <td> </td>
                        <td>Ruc:</td>
                        <td> </td>
                     </tr>
                     <tr>
                        <td>Dirección:</td>
                        <td> </td>
                        <td>Teléfono:</td>
                        <td> </td>
                     </tr>
                     <tr>
                        <td>Atención:</td>
                        <td> </td>
                        <td>Fecha:</td>
                        <td>".$fecha_emi."</td>
                     </tr>

                  </tody>
               </table>
            <div>
        </div>";

$html .='<table id="tablaFactura" class="table table-bordered">
           <thead class="CabeceraFactura">
             <tr>
               <th class="TNumero">Nº</th>
               <th colspan="2" class="TDetalle">Detalle</th>
               <th class="TTotal">Total</th>
             </tr>
           </thead>
   ';
$html .='<tbody id="tbody">
            '.$detalle_documento.'
         </tbody>';

$html .='<tfoot>
            <tr>
               <td class="DNumero">Sol</td>
               <td class="Fdetalle">'. $cambio .'</td>
               <td class="FNomSub">SubTotal</td>
               <td class="DTotal">'.$valor. $detalles['ImporteTotal'] .'</td>
            </tr>
            <tr>
               <td class="DNumero" >Fecha </td>
               <td class="Fdetalle">'. $fecha_letras .'</td>
               <td class="FNomSub"> IGV </td>
               <td class="DTotal"> '.$valor. $detalles['ImportePagar'] .'</td>
            </tr>
            <tr>
               <td colspan="2"></td>
               <td class="FNomSub" >Monto Total:</td>
               <td class="DTotal">'.$valor. $detalles['ImporteVuelto'] .'</td>
            </tr>
         </tfoot>
      </table>';

$html .='</body>';

        //echo $html;
        //==============================================================
        include("../../pdf/mpdf.php");

        $mpdf=new mPDF();

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
         //$mpdf->Output();
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
