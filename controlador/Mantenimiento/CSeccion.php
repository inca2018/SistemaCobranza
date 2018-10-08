<?php
   session_start();
   require_once "../../modelo/Mantenimiento/MSeccion.php";
   require_once "../../modelo/General/MGeneral.php";
   $mantenimiento = new MSeccion();
   $general = new MGeneral();


	$idSeccion=isset($_POST["idSeccion"])?limpiarCadena($_POST["idSeccion"]):"";
	$SeccionNombre=isset($_POST["SeccionNombre"])?limpiarCadena($_POST["SeccionNombre"]):"";

	$SeccionEstado=isset($_POST["SeccionEstado"])?limpiarCadena($_POST["SeccionEstado"]):"";


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
            <button type="button" title="Editar" class="btn btn-warning btn-sm" onclick="EditarSeccion('.$reg->idSeccion.')"><i class="fa fa-edit"></i></button>
               <button type="button"  title="Eliminar" class="btn btn-danger btn-sm" onclick="EliminarSeccion('.$reg->idSeccion.')"><i class="fa fa-trash"></i></button>
               ';
        }elseif($reg->Estado_idEstado==4){
            return '<button type="button"  title="Habilitar" class="btn btn-info btn-sm" onclick="HabilitarSeccion('.$reg->idSeccion.')"><i class="fa fa-sync"></i></button>';
        }
    }

   switch($_GET['op']){
        case 'AccionSeccion':
		 	$rspta=array("Error"=>false,"Mensaje"=>"","Registro"=>false);
         if(empty($idSeccion)){

                /*--  validar si el numero de la factura ya se encuentra emitido  --*/
                $validarSeccion=$mantenimiento->ValidarSeccion($SeccionNombre,$idSeccion);
                if($validarSeccion>0){
                    $rspta["Mensaje"].="El Seccion ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }
                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el Seccion.";
                }else{
                    $RespuestaRegistro=$mantenimiento->RegistroSeccion($idSeccion,$SeccionNombre,$SeccionEstado,$login_idLog);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="Seccion se registro Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="Seccion no se puede registrar comuniquese con el area de soporte.";
                    }
                }
            }else{

                 $validarSeccion=$mantenimiento->ValidarSeccion($SeccionNombre,$idSeccion);
                if($validarSeccion>0){
                    $rspta["Mensaje"].="El Seccion ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }
                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el Seccion.";
                }else{

                    $RespuestaRegistro=$mantenimiento->RegistroSeccion($idSeccion,$SeccionNombre,$SeccionEstado,$login_idLog);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="Seccion se Actualizo Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="Seccion no se puede Actualizar comuniquese con el area de soporte.";
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

		case 'Listar_Seccion':

         $rspta=$mantenimiento->Listar_Seccion();
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

      case 'Eliminar_Seccion':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_Seccion($idSeccion,1,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Seccion Eliminado.":$rspta['Mensaje']="Seccion no se pudo eliminar comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'Recuperar_Seccion':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_Seccion($idSeccion,2,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Seccion Restablecido.":$rspta['Mensaje']="Seccion no se pudo Restablecer comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'RecuperarInformacion_Seccion':
			$rspta=$mantenimiento->Recuperar_Seccion($idSeccion);
         echo json_encode($rspta);
      break;


   }


?>
