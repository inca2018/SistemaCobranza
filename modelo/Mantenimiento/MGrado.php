<?php
   require_once '../../config/config.php';


   class MGrado{

      public function __construct(){
      }

	  public function Listar_Grado(){
           $sql="CALL `SP_GRADO_LISTAR`();";
           return ejecutarConsulta($sql);
       }
      public function Eliminar_Grado($idGrado,$codigo,$idCreador){
           $sql="CALL `SP_GRADO_HABILITACION`('$idGrado','$codigo','$idCreador');";

           return ejecutarConsulta($sql);
       }
      public function Borrar_Grado($idGrado){
           $sql="DELETE FROM `grado` WHERE `idGrado`='$idGrado'";

           return ejecutarConsulta($sql);
       }


      public function ValidarGrado($Gradonom,$idGrado){
          $sql="";
          if($idGrado=='' || $idGrado==null || empty($idGrado)){
			   $sql="SELECT * FROM Grado WHERE Descripcion='$Gradonom';";
          }else{
             $sql="SELECT * FROM Grado WHERE idGrado!='$idGrado' and Descripcion='$Gradonom';";
          }
          return validarDatos($sql);
      }
      public function RegistroGrado($idGrado,$GradoNombre,$GradoEstado,$login_idLog){
        $sql="";

        if($idGrado=="" || $idGrado==null || empty($idGrado)){
             $sql="CALL `SP_GRADO_REGISTRO`('$GradoNombre','$GradoEstado','$login_idLog');";

        }else{

             $sql="CALL `SP_GRADO_ACTUALIZAR`('$GradoNombre','$GradoEstado','$idGrado','$login_idLog');";
        }

         return ejecutarConsulta($sql);
      }

		public function Recuperar_Grado($idGrado){
			$sql="CALL `SP_GRADO_RECUPERAR`('$idGrado');";
			return ejecutarConsultaSimpleFila($sql);
		}


   }

?>
