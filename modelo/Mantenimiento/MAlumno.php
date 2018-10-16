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


		public function Matricular($idPersona,$idAlumno,$O_importe_matricula,$O_importe_cuota,$O_importe_adicional1,$O_importe_adicional2,$O_observaciones,$login_idLog){
			$sql="INSERT INTO `planpago`(`Alumno_idAlumno`, `fechaRegistro`, `montoCuota`, `montoMatricula`,`pagoM`, `otroPago1`, `pagoOtro1`,`otroPago2`,`pagoOtro2`, `Observaciones`, `Estado_idEstado`) VALUES ('$idAlumno',NOW(),'$O_importe_cuota','$O_importe_matricula',0,'$O_importe_adicional1',0,'$O_importe_adicional2',0,'$O_observaciones',1);";

			return ejecutarConsulta($sql);
		}

       public function Listar_Cuotas_Disponibles($idAlumno){
           $sql="CALL `SP_CUOTAS_LISTAR`('$idAlumno');";

           return ejecutarConsulta($sql);
       }

       public function AgregarCuota($idAlumno,$creador){
           $sql="CALL `SP_CUOTA_AGREGAR`('$idAlumno','$creador');";

           return ejecutarConsulta($sql);
       }

    public function ActualizarCampo($idAlumno,$campo,$campoEdicion){
           $sql="UPDATE `planpago` SET  `$campo`='$campoEdicion'  WHERE `Alumno_idAlumno`='$idAlumno'";
           return ejecutarConsulta($sql);
       }


     public function AnularCuota($idCuota,$codigo,$creador){
           $sql="CALL `SP_CUOTA_ANULAR`('$idCuota','$codigo','$creador');";
           return ejecutarConsulta($sql);
       }


   }

?>
