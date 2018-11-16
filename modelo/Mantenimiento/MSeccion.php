<?php
   require_once '../../config/config.php';


   class MSeccion{

      public function __construct(){
      }

	  public function Listar_Seccion(){
           $sql="CALL `SP_SECCION_LISTAR`();";
           return ejecutarConsulta($sql);
       }
      public function Eliminar_Seccion($idSeccion,$codigo,$idCreador){
           $sql="CALL `SP_SECCION_HABILITACION`('$idSeccion','$codigo','$idCreador');";

           return ejecutarConsulta($sql);
       }
        public function Borrar_Seccion($idSeccion){
           $sql="DELETE FROM `seccion` WHERE `idSeccion`='$idSeccion'";

           return ejecutarConsulta($sql);
       }
      public function ValidarSeccion($Seccionnom,$idSeccion){
          $sql="";
          if($idSeccion=='' || $idSeccion==null || empty($idSeccion)){
			   $sql="SELECT * FROM Seccion WHERE Descripcion='$Seccionnom';";
          }else{
             $sql="SELECT * FROM Seccion WHERE idSeccion!='$idSeccion' and Descripcion='$Seccionnom';";
          }
          return validarDatos($sql);
      }
      public function RegistroSeccion($idSeccion,$SeccionNombre,$SeccionEstado,$login_idLog){
        $sql="";

        if($idSeccion=="" || $idSeccion==null || empty($idSeccion)){
             $sql="CALL `SP_SECCION_REGISTRO`('$SeccionNombre','$SeccionEstado','$login_idLog');";

        }else{

             $sql="CALL `SP_SECCION_ACTUALIZAR`('$SeccionNombre','$SeccionEstado','$idSeccion','$login_idLog');";
        }

         return ejecutarConsulta($sql);
      }

		public function Recuperar_Seccion($idSeccion){
			$sql="CALL `SP_SECCION_RECUPERAR`('$idSeccion');";
			return ejecutarConsultaSimpleFila($sql);
		}


   }

?>
