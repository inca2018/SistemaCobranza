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
       public function ListarDeudas($idAlumno,$year){
			$sql="CALL `SP_OPERACIONES_RECUPERAR_DEUDA`('$idAlumno','$year');";
			return ejecutarConsulta($sql);
		}
       public function ListarDeudasPensiones($idAlumno,$year){
			$sql="CALL `SP_OPERACIONES_RECUPERAR_PENSIONES`('$idAlumno','$year');";
			return ejecutarConsulta($sql);
		}
         public function ListarPagar($idAlumno,$year){
            $sql="CALL `SP_OPERACIONES_RECUPERAR_PAGAR`('$idAlumno','$year');";
			return ejecutarConsulta($sql);
         }

       public function RecuperarInformacionMatricula($idAlumno){
           $sql="CALL `SP_OPERACION_RECUPERAR_INFO`('$idAlumno');";
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

			  if($importeMora=='' || $importeMora==null || empty($importeMora)){
			  $importeMora='0';
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
		 public function RecuperarTotales($idAlumno,$year){
           $sql="CALL `SP_OPERACIONES_RECUPERAR_TOTALES`('$idAlumno','$year');";

			return ejecutarConsultaSimpleFila($sql);
       }

		  public function RecuperarParametros(){
			  $sql1=ejecutarConsulta("CALL `SP_RECUPERAR_PARAMETROS`(@p0, @p1, @p2, @p3);");
           $sql="SELECT @p0 AS `NumAlumnos`, @p1 AS `NumApoderados`, @p2 AS `PagoHoy`, @p3 AS `VencidoHoy`;";
			return ejecutarConsultaSimpleFila($sql);
       }

		public function RecuperarReporte($idAlumno){
          $sql1=ejecutarConsulta(" CALL `SP_INDICADORES_ALUMNO`(@p0, @p1, @p2, @p3,'$idAlumno');");
          $sql="SELECT @p0 AS `numCuotas`, @p1 AS `cuotaPend`, @p2 AS `cuotaPagada`, @p3 AS `cuotaVencida`;";
			return ejecutarConsultaSimpleFila($sql);
       }

		public function RecuperarReporteFechas($fechaInicio,$fechaFin){
          $sql1=ejecutarConsulta(" CALL `SP_INDICADORES_FECHAS`(@p0, @p1, @p2, @p3,'$fechaInicio','$fechaFin');");
          $sql="SELECT @p0 AS `numCuotas`, @p1 AS `cuotaPend`, @p2 AS `cuotaPagada`, @p3 AS `cuotaVencida`;";
			return ejecutarConsultaSimpleFila($sql);
       }


       public function RegistrarPagoP($idAlumnoP,$yearP,$importePago,$importeMora,$codigoPago,$TipoPago,$pagar_importe,$pagar_importe_mora,$tituloPago){
          $sql="CALL `SP_OPERACIONES_REGISTRO_PAGO`('$idAlumnoP','$yearP','$importePago','$importeMora','$codigoPago','$TipoPago','$pagar_importe','$pagar_importe_mora','$tituloPago');";
			return ejecutarConsulta($sql);
       }
       public function EliminarPagar($idPagar,$importePagar,$idAlumno,$year,$idCuota,$idMatricula,$TipoPago){
           if($idCuota=='0' || $idCuota==null || empty($idCuota)){
			  $idCuota='0';
		  }
           if($idMatricula=='0' || $idMatricula==null || empty($idMatricula)){
			  $idMatricula='0';
		  }
          $sql="CALL `SP_OPERACIONES_ELIMINAR_PAGAR`('$idPagar','$importePagar','$idAlumno','$year','$idCuota','$idMatricula','$TipoPago');";

			 return ejecutarConsulta($sql);
       }


   }

?>
