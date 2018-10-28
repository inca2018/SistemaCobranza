<?php

class Conexion {
   public function ruta(){
      return "http://localhost/ucv/SistemaCobranza/app/";
   }
   public function rutaOP(){
      return "http://localhost/ucv/SistemaCobranza/app/Gestion/";
   }
   public function convertir($string){
	   $cant=strlen($string);
		if($cant>1){
			   switch ($string){
					case '10':
						 $string='OCTUBRE';
					 	break;
					case '11':
						 $string='NOVIEMBRE';
					 	break;
					case '12':
						 $string='DICIEMBRE';
					 	break;
				}
		}else{
			  $string = str_replace(
				array('1', '2', '3', '4', '5', '6', '7', '8', '9'),
				array('ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO', 'JULIO', 'AGOSTO', 'SEPTIEMBRE'),
				$string
				);
		}

   return $string;
   }
	public function validar_null($valor,$moneda){
		if($valor==null){
			if($moneda=="1"){
				 $valor="S/. 0";
			}elseif($moneda=="2"){
				 $valor ="$. 0";
			}else{
				 $valor="S/. 0";
			}
		}else{
			if($moneda=="1"){
				$valor="S/. ".$valor;
			}elseif($moneda=="2"){
				$valor="$. ".$valor;
			}else{
				$valor="S/. 0";
			}
		}
		 return $valor;
	}
	public function validar_vacio($valor){
		if($valor==null){
				 $valor="0.00";
		}
		 return $valor;
	}
   public function upload_documento($tipo,$dni,$nombre) {
      // ubicar el de recurso
      $linkDocumento='../../vista/FotosAlumno/';
      if(!file_exists($linkDocumento)){
         mkdir("$linkDocumento",0777);
      }
      $linkRecurso='../../vista/FotosAlumno/'.$dni."/";
      if(!file_exists($linkRecurso)){
         mkdir("$linkRecurso",0777);
      }
       if($tipo==2){
           //editar

           $linkRecurso2='../../vista/FotosAlumno/'.$dni.'/'.$nombre.'.jpg';
            if(file_exists($linkRecurso2)){
                 unlink($linkRecurso2);
              }
               if(isset($_FILES["adjuntar_documento"])){

                 $extension = explode('.', $_FILES['adjuntar_documento']['name']);
                 $destination ='../../vista/FotosAlumno/'.$dni.'/'.$nombre.'.jpg';
                 $subida = move_uploaded_file($_FILES['adjuntar_documento']['tmp_name'], $destination);
                 return $subida;

            }


       }else{
           //registrar
            if(isset($_FILES["adjuntar_documento"])){

                 $extension = explode('.', $_FILES['adjuntar_documento']['name']);
                 $destination ='../../vista/FotosAlumno/'.$dni.'/'.$nombre.'.jpg';
                 $subida = move_uploaded_file($_FILES['adjuntar_documento']['tmp_name'], $destination);
                 return $subida;
              }
       }



   }

   public function upload_finContrato($idColaborador,$idContrato) {
      // ubicar el de recurso
      $linkDocumento='../../../documentos/RRHH';
      if(!file_exists($linkDocumento)){
         mkdir("$linkDocumento",0777);
      }
      $linkRecurso='../../../documentos/RRHH/'.$idColaborador."/";
      if(!file_exists($linkRecurso)){
         mkdir("$linkRecurso",0777);
      }
      if(isset($_FILES["documentoFinalizacion"])){
         $extension = explode('.', $_FILES['documentoFinalizacion']['name']);
         $destination ='../../../documentos/RRHH/'.$idColaborador.'/Finalizaicion'.$idContrato.'.pdf';
         $upload = move_uploaded_file($_FILES['adjuntar_documento']['tmp_name'], $destination);

      }else{
         $upload=false;
      }
      return $upload;
   }

    public function upload_Alumno($dni,$nombre) {
      // ubicar el de recurso
      $linkDocumento='../../vista/FotosAlumno';
      if(!file_exists($linkDocumento)){
         mkdir("$linkDocumento",0777);
      }
      $linkRecurso='../../vista/FotosAlumno/'.$dni."/";
      if(!file_exists($linkRecurso)){
         mkdir("$linkRecurso",0777);
      }
      if(isset($_FILES["fotoAlumno"])){
         $extension = explode('.', $_FILES['fotoAlumno']['name']);
         $destination ='../../vista/FotosAlumno/'.$dni.'/'.$nombre.'.jpg';
         $upload = move_uploaded_file($_FILES['fotoAlumno']['tmp_name'],$nombre);

      }else{
         $upload=false;
      }
      return $upload;
   }



function BuscarEstado($reg){
        if($reg->Estado_idEstado=='1' || $reg->Estado_idEstado==1 ){
            return '<div class="badge badge-success">'.$reg->nombreEstado.'</div>';
        }elseif($reg->Estado_idEstado=='2' || $reg->Estado_idEstado==2){
            return '<div class="badge badge-danger">'.$reg->nombreEstado.'</div>';
        }elseif($reg->Estado_idEstado=='3' || $reg->Estado_idEstado==3){
            return '<div class="badge badge-success">'.$reg->nombreEstado.'</div>';
        }elseif($reg->Estado_idEstado=='4' || $reg->Estado_idEstado==4){
            return '<div class="badge badge-danger">'.$reg->nombreEstado.'</div>';
        }elseif($reg->Estado_idEstado=='5' || $reg->Estado_idEstado==5){
            return '<div class="badge badge-warning">'.$reg->nombreEstado.'</div>';
        }elseif($reg->Estado_idEstado=='6' || $reg->Estado_idEstado==6){
            return '<div class="badge badge-purple">'.$reg->nombreEstado.'</div>';
        }elseif($reg->Estado_idEstado=='7' || $reg->Estado_idEstado==7){
            return '<div class="badge badge-info">'.$reg->nombreEstado.'</div>';
        }else{
             return '<div class="badge badge-danger">'.$reg->nombreEstado.'</div>';
        }
    }
}


?>
