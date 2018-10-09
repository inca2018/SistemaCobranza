<?php
   require_once '../../config/config.php';


   class MApoderado{

      public function __construct(){
      }

	  public function Listar_Apoderado(){
           $sql="CALL `SP_APODERADO_LISTAR`();";
           return ejecutarConsulta($sql);
       }
      public function Eliminar_Apoderado($idPersona,$codigo,$idCreador){
           $sql="CALL `SP_PERSONA_HABILITACION`('$idPersona','$codigo','$idCreador');";

           return ejecutarConsulta($sql);
       }
      public function ValidarApoderado($ApoderadoDni,$idPersona){
          $sql="";
          if($idPersona=='' || $idPersona==null || empty($idPersona)){

			   $sql="SELECT * FROM persona WHERE DNI='$ApoderadoDni';";
          }else{

             $sql="SELECT * FROM persona WHERE idPersona!='$idPersona' and DNI='$ApoderadoDni';";
          }
          return validarDatos($sql);
      }
      public function RegistroApoderado($idPersona,$idApoderado,$ApoderadoNombre,$ApoderadoApellidoP,$ApoderadoApellidoM,$ApoderadoDNI,$ApoderadoFechaNacimiento,$ApoderadoCorreo,$ApoderadoTelefono,$ApoderadoDireccion,$ApoderadoEstado,$ApoderadoTipoTarjeta,$ApoderadoDetalle,$login_idLog){
        $sql="";

         if($ApoderadoCorreo=='' || $ApoderadoCorreo==null || empty($ApoderadoCorreo)){
			  $ApoderadoCorreo='0';
		  }
			if($ApoderadoTelefono=='' || $ApoderadoTelefono==null || empty($ApoderadoTelefono)){
			  $ApoderadoTelefono='0';
		  }
			if($ApoderadoDireccion=='' || $ApoderadoDireccion==null || empty($ApoderadoDireccion)){
			  $ApoderadoDireccion='0';
		  }
          if($ApoderadoTipoTarjeta=='' || $ApoderadoTipoTarjeta==null || empty($ApoderadoTipoTarjeta)){
			  $ApoderadoTipoTarjeta='0';
		  }
          if($ApoderadoDetalle=='' || $ApoderadoDetalle==null || empty($ApoderadoDetalle)){
			  $ApoderadoDetalle='0';
		  }


        if($idApoderado=="" || $idApoderado==null || empty($idApoderado)){
             $sql="CALL `SP_APODERADO_REGISTRO`('$ApoderadoNombre','$ApoderadoApellidoP','$ApoderadoApellidoM','$ApoderadoDNI','$ApoderadoFechaNacimiento','$ApoderadoCorreo','$ApoderadoTelefono','$ApoderadoDireccion','$ApoderadoEstado','$ApoderadoTipoTarjeta','$ApoderadoDetalle','$login_idLog');";

        }else{
             $sql="CALL `SP_APODERADO_ACTUALIZAR`('$ApoderadoNombre','$ApoderadoApellidoP','$ApoderadoApellidoM','$ApoderadoDNI','$ApoderadoFechaNacimiento','$ApoderadoCorreo','$ApoderadoTelefono','$ApoderadoDireccion','$ApoderadoEstado','$ApoderadoTipoTarjeta','$ApoderadoDetalle','$idPersona','$idApoderado','$login_idLog');";
        }

         return ejecutarConsulta($sql);
      }

		public function Recuperar_Apoderado($idPersona,$idApoderado){
			$sql="CALL `SP_APODERADO_RECUPERAR`('$idPersona','$idApoderado');";

			return ejecutarConsultaSimpleFila($sql);
		}


   }

?>
