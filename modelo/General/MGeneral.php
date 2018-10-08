<?php
   require_once '../../config/config.php';

   class MGeneral{

      public function __construct(){
      }

        public function Listar_Estados($tipo){
         $sql="CALL `SP_ESTADO_LISTAR`('$tipo');";
         return ejecutarConsulta($sql);
       }
        public function Listar_Persona_Todo(){
         $sql="CALL `SP_PERSONA_LISTAR_TODO`(); ";
         return ejecutarConsulta($sql);
       }

       public function Listar_Personas_Sin_Usuario(){
         $sql="CALL `SP_PERSONAS_LISTAR_SIN_USUARIOS`();";
         return ejecutarConsulta($sql);
       }
		public function Listar_Personas_Todo(){
         $sql="select * from persona";
         return ejecutarConsulta($sql);
       }
        public function Listar_Perfiles(){
         $sql="CALL `SP_PERFIL_LISTAR`();";
         return ejecutarConsulta($sql);
       }
       public function Listar_Niveles(){
         $sql="CALL `SP_NIVEL_LISTAR`();";
         return ejecutarConsulta($sql);
       }
        public function Listar_Grados(){
         $sql="CALL `SP_GRADO_LISTAR`();";
         return ejecutarConsulta($sql);
       }
        public function Listar_Secciones(){
         $sql="CALL `SP_SECCION_LISTAR`();";
         return ejecutarConsulta($sql);
       }




   }

?>
