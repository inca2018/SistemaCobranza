<?php
   require_once '../../config/config.php';


   class MGestion{

      public function __construct(){
      }


		public function Recuperar_Gestion($idGestion){
			$sql="CALL `SP_Gestion_RECUPERAR`('$idGestion');";
			return ejecutarConsultaSimpleFila($sql);
		}
       public function ListarOperaciones(){
			$sql="CALL `SP_OPERACIONES_LISTAR`();";
			return ejecutarConsulta($sql);
		}
       public function RecuperarInformacionMatricula($idPlan,$idAlumno){
           $sql="CALL `SP_OPERACION_RECUPERAR_INFO`('$idPlan','$idAlumno');";
			return ejecutarConsultaSimpleFila($sql);
       }
       public function RegistrarPago($idPlan,$idAlumno,$numPago,$PagoTipoPago,$PagoTipoTarjeta,$importePago,$pago_detalle,$login_idLog){

           if($PagoTipoTarjeta=='' || $PagoTipoTarjeta==null || empty($PagoTipoTarjeta)){
			  $PagoTipoTarjeta='0';
		  }
           if($pago_detalle=='' || $pago_detalle==null || empty($pago_detalle)){
			  $pago_detalle='0';
		  }

           $sql="CALL `SP_OPERACIONES_ACCION_PAGO`('$idPlan','$idAlumno','$numPago','$PagoTipoPago','$PagoTipoTarjeta','$importePago','$pago_detalle','$login_idLog');";

			return ejecutarConsulta($sql);
       }
       public function RegistrarCuota($idPlan,$idAlumno,$idCuota,$PagoTipoPago,$PagoTipoTarjeta,$importePago,$importeBase,$importeMora,$pago_detalle,$login_idLog){

           if($PagoTipoTarjeta=='' || $PagoTipoTarjeta==null || empty($PagoTipoTarjeta)){
			  $PagoTipoTarjeta='0';
		  }
           if($pago_detalle=='' || $pago_detalle==null || empty($pago_detalle)){
			  $pago_detalle='0';
		  }

           $sql="CALL `SP_OPERACION_PAGO_CUOTA`('$idPlan','$idAlumno','$idCuota','$PagoTipoPago','$PagoTipoTarjeta','$importePago','$importeBase','$importeMora','$pago_detalle','$login_idLog');";

			return ejecutarConsulta($sql);
       }

       public function Listar_Cuotas($idPlan,$idAlumno){
			$sql="CALL `SP_OPERACIONES_LISTAR_CUOTAS`('$idPlan','$idAlumno');";
			return ejecutarConsulta($sql);
		}

        public function RecuperarCuotaPagar($idPlan,$idCuota){
           $sql="CALL `SP_OPERACION_RECUPERAR_CUOTA_PAGAR`('$idPlan','$idCuota');";
			return ejecutarConsultaSimpleFila($sql);
       }

   }

?>
