<?php
   require_once '../../config/config.php';


   class MTipoPago{

      public function __construct(){
      }

	  public function Listar_TipoPago(){
           $sql="CALL `SP_TIPOPAGO_LISTAR`();";
           return ejecutarConsulta($sql);
       }
      public function Eliminar_TipoPago($idTipoPago,$codigo,$idCreador){
           $sql="CALL `SP_TIPOPAGO_HABILITACION`('$idTipoPago','$codigo','$idCreador');";

           return ejecutarConsulta($sql);
       }
        public function Borrar_TipoPago($idTipoPago){
           $sql="DELETE FROM `generalimportes` WHERE `idGeneral`='$idTipoPago'";

           return ejecutarConsulta($sql);
       }
      public function ValidarTipoPago($TipoPagonom,$idTipoPago){
          $sql="";
          if($idTipoPago=='' || $idTipoPago==null || empty($idTipoPago)){
			   $sql="SELECT * FROM generalimportes WHERE   NombrePago='$TipoPagonom';";
          }else{
             $sql="SELECT * FROM generalimportes WHERE idGeneral!='$idTipoPago' and NombrePago='$TipoPagonom';";
          }
          return validarDatos($sql);
      }
      public function RegistroTipoPago($idTipoPago,$TipoPagoNombre,$TipoPagoImporte,$TipoPagoCuota,$TipoPagoEstado,$login_idLog){
        $sql="";

        if($idTipoPago=="" || $idTipoPago==null || empty($idTipoPago)){
             $sql="CALL `SP_TIPOPAGO_REGISTRO`('$TipoPagoNombre','$TipoPagoImporte','$TipoPagoCuota','$TipoPagoEstado','$login_idLog');";

        }else{
             $sql="CALL `SP_TIPOPAGO_ACTUALIZAR`('$idTipoPago','$TipoPagoNombre','$TipoPagoImporte','$TipoPagoCuota','$TipoPagoEstado','$login_idLog');";
        }

         return ejecutarConsulta($sql);
      }

		public function Recuperar_TipoPago($idTipoPago){
			$sql="CALL `SP_TIPOPAGO_RECUPERAR`('$idTipoPago');";
			return ejecutarConsultaSimpleFila($sql);
		}


   }

?>
