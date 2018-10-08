<?php
   session_start();
   require_once "../../modelo/Mantenimiento/MNivel.php";
   require_once "../../modelo/General/MGeneral.php";
   $mantenimiento = new MNivel();
   $general = new MGeneral();


	$idNivel=isset($_POST["idNivel"])?limpiarCadena($_POST["idNivel"]):"";
	$NivelNombre=isset($_POST["NivelNombre"])?limpiarCadena($_POST["NivelNombre"]):"";

	$NivelEstado=isset($_POST["NivelEstado"])?limpiarCadena($_POST["NivelEstado"]):"";


	$login_idLog=$_SESSION['idUsuario'];



    function BuscarEstado($reg){
        if($reg->Estado_idEstado=='1' || $reg->Estado_idEstado==1 ){
            return '<div class="badge badge-success">'.$reg->nombreEstado.'</div>';
        }elseif($reg->Estado_idEstado=='2' || $reg->Estado_idEstado==2){
            return '<div class="badge badge-danger">'.$reg->nombreEstado.'</div>';
        }else{
             return '<div class="badge badge-primary">'.$reg->nombreEstado.'</div>';
        }
    }
    function BuscarAccion($reg){
        if($reg->Estado_idEstado==1 || $reg->Estado_idEstado==2 ){
            return '
            <button type="button" title="Editar" class="btn btn-warning btn-sm" onclick="EditarNivel('.$reg->idNivel.')"><i class="fa fa-edit"></i></button>
               <button type="button"  title="Eliminar" class="btn btn-danger btn-sm" onclick="EliminarNivel('.$reg->idNivel.')"><i class="fa fa-trash"></i></button>
               ';
        }elseif($reg->Estado_idEstado==4){
            return '<button type="button"  title="Habilitar" class="btn btn-info btn-sm" onclick="HabilitarNivel('.$reg->idNivel.')"><i class="fa fa-sync"></i></button>';
        }
    }

   switch($_GET['op']){
        case 'AccionNivel':
		 	$rspta=array("Error"=>false,"Mensaje"=>"","Registro"=>false);
         if(empty($idNivel)){

                /*--  validar si el numero de la factura ya se encuentra emitido  --*/
                $validarNivel=$mantenimiento->ValidarNivel($NivelNombre,$idNivel);
                if($validarNivel>0){
                    $rspta["Mensaje"].="El Nivel ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }
                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el Nivel.";
                }else{
                    $RespuestaRegistro=$mantenimiento->RegistroNivel($idNivel,$NivelNombre,$NivelEstado,$login_idLog);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="Nivel se registro Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="Nivel no se puede registrar comuniquese con el area de soporte.";
                    }
                }
            }else{

                 $validarNivel=$mantenimiento->ValidarNivel($NivelNombre,$idNivel);
                if($validarNivel>0){
                    $rspta["Mensaje"].="El Nivel ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }
                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el Nivel.";
                }else{

                    $RespuestaRegistro=$mantenimiento->RegistroNivel($idNivel,$NivelNombre,$NivelEstado,$login_idLog);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="Nivel se Actualizo Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="Nivel no se puede Actualizar comuniquese con el area de soporte.";
                    }
                }
            }

         echo json_encode($rspta);
       break;
      case 'listar_estados':

      		$rpta = $general->Listar_Estados(1);
         	while ($reg = $rpta->fetch_object()){
					echo '<option   value=' . $reg->idEstado . '>' . $reg->nombreEstado . '</option>';
         	}
       break;

		case 'Listar_Nivel':

         $rspta=$mantenimiento->Listar_Nivel();
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>'',
               "1"=>BuscarEstado($reg),
               "2"=>$reg->Descripcion,
               "3"=>$reg->fechaRegistro,
               "4"=>BuscarAccion($reg)
            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;

      case 'Eliminar_Nivel':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_Nivel($idNivel,1,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Nivel Eliminado.":$rspta['Mensaje']="Nivel no se pudo eliminar comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'Recuperar_Nivel':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_Nivel($idNivel,2,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Nivel Restablecido.":$rspta['Mensaje']="Nivel no se pudo Restablecer comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'RecuperarInformacion_Nivel':
			$rspta=$mantenimiento->Recuperar_Nivel($idNivel);
         echo json_encode($rspta);
      break;


   }


?>
