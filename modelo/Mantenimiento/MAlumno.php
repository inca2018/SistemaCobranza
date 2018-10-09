<?php
   require_once '../../config/config.php';


   class MAlumno{

      public function __construct(){
      }

	  public function Listar_Alumno(){
           $sql="CALL `SP_ALUMNO_LISTAR`();";
           return ejecutarConsulta($sql);
       }
      public function Eliminar_Alumno($idPersona,$codigo,$idCreador){
           $sql="CALL `SP_PERSONA_HABILITACION`('$idPersona','$codigo','$idCreador');";

           return ejecutarConsulta($sql);
       }
      public function ValidarAlumno($AlumnoDni,$idPersona){
          $sql="";
          if($idPersona=='' || $idPersona==null || empty($idPersona)){

			   $sql="SELECT * FROM persona WHERE DNI='$AlumnoDni';";
          }else{

             $sql="SELECT * FROM persona WHERE idPersona!='$idPersona' and DNI='$AlumnoDni';";
          }
          return validarDatos($sql);
      }
      public function RegistroAlumno($idPersona,$idAlumno,$AlumnoNombre,$AlumnoApellidoP,$AlumnoApellidoM,$AlumnoDNI,$AlumnoFechaNacimiento,$AlumnoCorreo,$AlumnoTelefono,$AlumnoDireccion,$AlumnoEstado,$AlumnoImagen,$AlumnoNivel,$AlumnoGrado,$AlumnoSeccion,$login_idLog){
        $sql="";

         if($AlumnoCorreo=='' || $AlumnoCorreo==null || empty($AlumnoCorreo)){
			  $AlumnoCorreo='0';
		  }
			if($AlumnoTelefono=='' || $AlumnoTelefono==null || empty($AlumnoTelefono)){
			  $AlumnoTelefono='0';
		  }
			if($AlumnoDireccion=='' || $AlumnoDireccion==null || empty($AlumnoDireccion)){
			  $AlumnoDireccion='0';
		  }
          if($AlumnoImagen=='' || $AlumnoImagen==null || empty($AlumnoImagen)){
			  $AlumnoImagen='0';
		  }

        if($idAlumno=="" || $idAlumno==null || empty($idAlumno)){
             $sql="CALL `SP_ALUMNO_REGISTRO`('$AlumnoNombre','$AlumnoApellidoP','$AlumnoApellidoM','$AlumnoDNI','$AlumnoFechaNacimiento','$AlumnoCorreo','$AlumnoTelefono','$AlumnoDireccion','$AlumnoEstado','$AlumnoImagen','$AlumnoNivel','$AlumnoGrado','$AlumnoSeccion','$login_idLog');";

        }else{
             $sql="CALL `SP_ALUMNO_ACTUALIZAR`('$AlumnoNombre','$AlumnoApellidoP','$AlumnoApellidoM','$AlumnoDNI','$AlumnoFechaNacimiento','$AlumnoCorreo','$AlumnoTelefono','$AlumnoDireccion','$AlumnoEstado','$AlumnoNivel','$AlumnoGrado','$AlumnoSeccion','$AlumnoImagen','$idPersona','$idAlumno','$login_idLog');";
        }

         return ejecutarConsulta($sql);
      }

		public function Recuperar_Alumno($idPersona,$idAlumno){
			$sql="CALL `SP_ALUMNO_RECUPERAR`('$idPersona','$idAlumno');";

			return ejecutarConsultaSimpleFila($sql);
		}


   }

?>
