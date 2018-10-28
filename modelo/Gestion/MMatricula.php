<?php
   require_once '../../config/config.php';


   class MMatricula{

      public function __construct(){
      }


       public function ListarMatriculas($year){
			$sql="CALL `SP_MATRICULA_LISTAR_MATRICULADOS`('$year')";

			return ejecutarConsulta($sql);
		}
       public function ListarCuotasDisponibles($idPersona,$idAlumno,$year){
			$sql="CALL `SP_MATRICULA_LISTAR_CUOTAS`('$idPersona','$idAlumno','$year')";

			return ejecutarConsulta($sql);
		}
       public function ListarPagosDisponibles(){
			 $sql="SELECT * FROM generalimportes";
			return ejecutarConsulta($sql);
		}


       public function ListarYear(){
           $sql="SELECT * FROM year";
           return ejecutarConsulta($sql);
       }
        public function RecuperarDatosAlumno($idPersona,$idAlumno,$year){
			$sql="CALL `SP_MATRICULA_ALUMNO_RECUPERAR`('$idPersona','$idAlumno','$year')";
			return ejecutarConsultaSimpleFila($sql);
		}

       public function AgregarPlan1($idPersona,$idAlumno,$year){
			$sql="CALL `SP_MATRICULA_AGREGAR_PENSIONES1`('$idPersona','$idAlumno','$year')";

			return ejecutarConsultaSimpleFila($sql);
		}
       public function AgregarPlan2($idPersona,$idAlumno,$year){
			$sql="CALL `SP_MATRICULA_AGREGAR_PENSIONES2`('$idPersona','$idAlumno','$year')";

			return ejecutarConsultaSimpleFila($sql);
		}
       public function LimpiarMatricula($idPersona,$idAlumno,$year){
			$sql="CALL `SP_MATRICULA_LIMPIAR`('$idPersona','$idAlumno','$year')";

			return ejecutarConsultaSimpleFila($sql);
		}

       public function RecuperarPagoAlumno($idAlumno,$year){
           $sql="CALL `SP_MATRICULAR_RECUPEAR_PAGOS`('$idAlumno','$year');";

           return ejecutarConsulta($sql);
       }
        public function ActualizarListadoPago($pago,$idAlumno,$year){
           $sql="CALL `SP_AGREGAR_TIPOPAGO_ALUMNO`('$pago','$idAlumno','$year');";

           return ejecutarConsulta($sql);
      }
       public function MatricularAlumno($idPersona,$idAlumno,$year,$idNivel,$idGrado,$idSeccion){
           $sql="CALL `SP_MATRICULA_REGISTRAR`('$idPersona','$idAlumno','$year','$idNivel','$idGrado','$idSeccion');";

           return ejecutarConsulta($sql);
       }
       public function LimpiarPagos($idAlumno,$year){
           $sql="DELETE FROM `alumnopagos` WHERE `Alumno_idAlumno`='$idAlumno' and `year`='$year'";
           return ejecutarConsulta($sql);
       }
       public function ActualizarAlumno($idPersona,$idAlumno,$year,$idNivel,$idGrado,$idSeccion){
           $sql="CALL `SP_MATRICULA_ACTUALIZAR`('$idPersona','$idAlumno','$year','$idNivel','$idGrado','$idSeccion');";
           return ejecutarConsulta($sql);
       }


   }

?>
