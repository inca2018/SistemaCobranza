<?php
   require_once '../../config/config.php';


   class MAlumno{

      public function __construct(){
      }

	  public function Listar_Alumno(){
           $sql="CALL `SP_Alumno_LISTAR`();";
           return ejecutarConsulta($sql);
       }
      public function Eliminar_Alumno($idAlumno,$codigo,$idCreador){
           $sql="CALL `SP_Alumno_HABILITACION`('$idAlumno','$codigo','$idCreador');";

           return ejecutarConsulta($sql);
       }
      public function ValidarAlumno($Alumnonom,$idAlumno){
          $sql="";
          if($idAlumno=='' || $idAlumno==null || empty($idAlumno)){
			   $sql="SELECT * FROM Alumno WHERE Descripcion='$Alumnonom';";
          }else{
             $sql="SELECT * FROM Alumno WHERE idAlumno!='$idAlumno' and Descripcion='$Alumnonom';";
          }
          return validarDatos($sql);
      }
      public function RegistroAlumno($idAlumno,$AlumnoNombre,$AlumnoEstado,$login_idLog){
        $sql="";

        if($idAlumno=="" || $idAlumno==null || empty($idAlumno)){
             $sql="CALL `SP_Alumno_REGISTRO`('$AlumnoNombre','$AlumnoEstado','$login_idLog');";

        }else{

             $sql="CALL `SP_Alumno_ACTUALIZAR`('$AlumnoNombre','$AlumnoEstado','$idAlumno','$login_idLog');";
        }

         return ejecutarConsulta($sql);
      }

		public function Recuperar_Alumno($idAlumno){
			$sql="CALL `SP_Alumno_RECUPERAR`('$idAlumno');";
			return ejecutarConsultaSimpleFila($sql);
		}


   }

?>
