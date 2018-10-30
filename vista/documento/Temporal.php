
    <?php

    $html = '<body>
     <!-- Content Wrapper. Contains page content -->
      <div class="content-wrapper">
            <div class="colum-2">
            <img src="../../vistas/documento/logo.png" class="Logo">

            </div>
            <div class="colum-2 ">
              <address>
                <b>QSystem S.A.C</b><br>
                Cal. los Ruiseñores Nro. 198 - Surquillo<br>
                Ruc: 20508843411<br>
                Telefono: 01-4627633<br>
                Correo:contactoqs@qsystem.com.pe <br>
                Web: www.qsystem.com.pe
              </address>
            </div>
            <div class="colum-2">
              <div>
                       <div class="bloqueA">
                       <span class="titulo2">R.U.C 20508843411</span>
                       </div>
                       <div class="bloqueB">
                       <span class="titulo3">FACTURA</span>
                       </div>
                        <div class="bloqueC">
                        <span class="titulo2">Nº 001 - 01256 </span>
                    </div>
              </div>
            </div>
            <hr class="general">

     </div>';
$html .="
        <div class='row cliente-info'>
            <div class='row caja'>
                <span class='titulo_caja'>Datos del Cliente</span>
            </div>

            <div class='colum-a'>
                  <div class='row caja'>
                      <div class='pregunta'> Razón Social:</div>
                      <div class='respuesta'> Razon Social</div>
                  </div>
                  <div class='row caja'>
                      <div class='pregunta'> Ruc:</div>
                      <div class='respuesta'> 01236369852</div>
                  </div>
                  <div class='row caja'>
                      <div class='pregunta'> Teléfono:</div>
                      <div class='respuesta'> 9458304443</div>
                  </div>
                  <div class='row caja'>
                      <div class='pregunta'> Dirección: </div>
                      <div class='respuesta'> Direccion del cliente </div>
                  </div>

            </div>

            <div class='colum-b'>
                  <div class='row caja'>
                      <div class='pregunta2'> Nº O/C: </div>
                      <div class='respuesta2'> 01212313 </div>
                  </div>
                   <div class='row caja'>
                      <div class='pregunta2'>Fecha: </div>
                      <div class='respuesta2'> 01/12/2018</div>
                  </div>
            </div>
        </div>";


$html .=' <div class="container2">
                <div class="bloqueD1">
                       <div class="cabecera1"><span >Nº</span></div>
                       <div class="cabecera2"><span >Detalle</span></div>
                       <div class="cabecera3"><span >Sub Total</span></div>
                </div>

                <div class="bloqueD2">
                    <div >
                           <div class="item1"><span>1</span></div>
                           <div class="item2"><span> Se detalla la factura skndskndksanksdlkmanfkj njkan d jkabfjksadnfjkanb jfkbjksdjkfbv  hjafbjdafjkas ajkdbcfjkadnfdlkasfn jdbfjdkafbdsakj</span></div>
                           <div class="item3"><span >S/. 15000 </span></div>
                    </div>

                </div>

              <div class="bloqueD3">
                            <div class="datos">
                               <div class="caja">
                                  <div class="detalle1"> SON:</div>
                                  <div class="detalle2"> texto del cambio </div>
                               </div>

                               <div class="caja">
                                  <div class="detalle1"> FECHA:</div>
                                  <div class="detalle2">1631631263</div>
                               </div>

                            </div>
                            <div class="total">
                                <div class="grupo">
                                     <div class="pregunta"><span >Subtotal:</span></div>
                                    <div class="respuesta"><span >S/. 15000</span></div>
                                </div>
                                <div class="grupo">
                                     <div class="pregunta"><span >IGV (18%)</span></div>
                                    <div class="respuesta"><span >S/. 5000</span></div>
                                </div>
                                <div class="grupo">
                                     <div class="pregunta"><span >Total:</span></div>
                                    <div class="respuesta"><span >S/. 20000</span></div>
                                </div>

                            </div>

                </div>
         </div>
                ';

$html .='

    </body>';

        include("../../pdf/mpdf.php");


        $mpdf=new mPDF();


        $mpdf->SetDisplayMode('fullpage');
        // LOAD a stylesheet
        $stylesheet1 = file_get_contents('../../views/documento/bootstrap.min.css');
        $stylesheet2 = file_get_contents('../../views/documento/boleta.css');
        $mpdf->WriteHTML($stylesheet1,1);
        $mpdf->WriteHTML($stylesheet2,1);
        $mpdf->WriteHTML($html);

        $nombre_doc=$detalles['NumeroFactura'].'.pdf';
        $ruta_pre='../../views/Finanzas/Documento/';

        $ruta=Verificar_Carpeta($ruta_pre,$nombre_doc,$detalles['RucCli']);

        $mpdf->Output($ruta,'F');

/* el error esta en el exit por que cierras el proceso */
//exit;

//==============================================================
//==============================================================
//==============================================================



function Verificar_Carpeta($ruta,$nombre,$ruc){

	if (!file_exists($ruta.$ruc)) {
    mkdir($ruta.$ruc, 0777, true);
		return $ruta.$ruc."/".$nombre;
	}else{
		return $ruta.$ruc."/".$nombre;
	}

}

?>
