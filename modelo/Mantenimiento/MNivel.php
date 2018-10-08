<?php
   require_once '../../config/config.php';


   class MNivel{

      public function __construct(){
      }

	  public function Listar_Nivel(){
           $sql="CALL `SP_NIVEL_LISTAR`();";
           return ejecutarConsulta($sql);
       }
      public function Eliminar_Nivel($idNivel,$codigo,$idCreador){
           $sql="CALL `SP_Nivel_HABILITACION`('$idNivel','$codigo','$idCreador');";

           return ejecutarConsulta($sql);
       }
      public function ValidarNivel($Nivelnom,$idNivel){
          $sql="";
          if($idNivel=='' || $idNivel==null || empty($idNivel)){
			   $sql="SELECT * FROM nivel WHERE Descripcion='$Nivelnom';";
          }else{
             $sql="SELECT * FROM nivel WHERE idNivel!='$idNivel' and Descripcion='$Nivelnom';";
          }
          return validarDatos($sql);
      }
      public function RegistroNivel($idNivel,$NivelNombre,$NivelEstado,$login_idLog){
        $sql="";

        if($idNivel=="" || $idNivel==null || empty($idNivel)){
             $sql="CALL `SP_NIVEL_REGISTRO`('$NivelNombre','$NivelEstado','$login_idLog');";

        }else{

             $sql="CALL `SP_NIVEL_ACTUALIZAR`('$NivelNombre','$NivelEstado','$idNivel','$login_idLog');";
        }

         return ejecutarConsulta($sql);
      }

		public function Recuperar_Nivel($idNivel){
			$sql="CALL `SP_NIVEL_RECUPERAR`('$idNivel');";
			return ejecutarConsultaSimpleFila($sql);
		}


   }

?>
