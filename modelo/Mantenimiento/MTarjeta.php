<?php
   require_once '../../config/config.php';


   class MTarjeta{

      public function __construct(){
      }

	  public function Listar_Tarjeta(){
           $sql="CALL `SP_TARJETA_LISTAR`();";
           return ejecutarConsulta($sql);
       }
      public function Eliminar_Tarjeta($idTarjeta,$codigo,$idCreador){
           $sql="CALL `SP_TARJETA_HABILITACION`('$idTarjeta','$codigo','$idCreador');";

           return ejecutarConsulta($sql);
       }
      public function ValidarTarjeta($Tarjetanom,$idTarjeta){
          $sql="";
          if($idTarjeta=='' || $idTarjeta==null || empty($idTarjeta)){
			   $sql="SELECT * FROM tipotarjeta WHERE   Descripcion='$Tarjetanom';";
          }else{
             $sql="SELECT * FROM tipotarjeta WHERE idTipoTarjeta!='$idTarjeta' and Descripcion='$Tarjetanom';";
          }
          return validarDatos($sql);
      }
      public function RegistroTarjeta($idTarjeta,$TarjetaNombre,$TarjetaEstado,$login_idLog){
        $sql="";

        if($idTarjeta=="" || $idTarjeta==null || empty($idTarjeta)){
             $sql="CALL `SP_TARJETA_REGISTRO`('$TarjetaNombre','$TarjetaEstado','$login_idLog');";

        }else{
             $sql="CALL `SP_TARJETA_ACTUALIZAR`('$TarjetaNombre','$TarjetaEstado','$idTarjeta','$login_idLog');";
        }

         return ejecutarConsulta($sql);
      }

		public function Recuperar_Tarjeta($idTarjeta){
			$sql="CALL `SP_TARJETA_RECUPERAR`('$idTarjeta');";
			return ejecutarConsultaSimpleFila($sql);
		}


   }

?>
