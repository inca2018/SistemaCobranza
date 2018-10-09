<?php
   session_start();
   require_once "../../modelo/Mantenimiento/MApoderado.php";
   require_once "../../modelo/General/MGeneral.php";
   $mantenimiento = new MApoderado();
   $general = new MGeneral();

    $idPersona=isset($_POST["idPersona"])?limpiarCadena($_POST["idPersona"]):"";
    $idApoderado=isset($_POST["idApoderado"])?limpiarCadena($_POST["idApoderado"]):"";
    $ApoderadoNombre=isset($_POST["ApoderadoNombre"])?limpiarCadena($_POST["ApoderadoNombre"]):"";
    $ApoderadoFechaNacimiento=isset($_POST["ApoderadoFechaNacimiento"])?limpiarCadena($_POST["ApoderadoFechaNacimiento"]):"";
    $ApoderadoApellidoP=isset($_POST["ApoderadoApellidoP"])?limpiarCadena($_POST["ApoderadoApellidoP"]):"";
    $ApoderadoDNI=isset($_POST["ApoderadoDNI"])?limpiarCadena($_POST["ApoderadoDNI"]):"";
    $ApoderadoApellidoM=isset($_POST["ApoderadoApellidoM"])?limpiarCadena($_POST["ApoderadoApellidoM"]):"";
    $ApoderadoCorreo=isset($_POST["ApoderadoCorreo"])?limpiarCadena($_POST["ApoderadoCorreo"]):"";
    $ApoderadoTelefono=isset($_POST["ApoderadoTelefono"])?limpiarCadena($_POST["ApoderadoTelefono"]):"";
    $ApoderadoDireccion=isset($_POST["ApoderadoDireccion"])?limpiarCadena($_POST["ApoderadoDireccion"]):"";
    $ApoderadoEstado=isset($_POST["ApoderadoEstado"])?limpiarCadena($_POST["ApoderadoEstado"]):"";


    $ApoderadoTipoTarjeta=isset($_POST["ApoderadoTipoTarjeta"])?limpiarCadena($_POST["ApoderadoTipoTarjeta"]):"";
    $ApoderadoDetalle=isset($_POST["ApoderadoDetalle"])?limpiarCadena($_POST["ApoderadoDetalle"]):"";

	$login_idLog=$_SESSION['idUsuario'];

    $date = str_replace('/', '-', $ApoderadoFechaNacimiento);
   $ApoderadoFechaNacimiento = date("Y-m-d", strtotime($date));

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
            <button type="button" title="Editar" class="btn btn-warning btn-sm" onclick="EditarApoderado('.$reg->idPersona.','.$reg->idApoderado.');"><i class="fa fa-edit"></i></button>
               <button type="button"  title="Eliminar" class="btn btn-danger btn-sm" onclick="EliminarApoderado('.$reg->idPersona.','.$reg->idApoderado.');"><i class="fa fa-trash"></i></button>
               ';
        }elseif($reg->Estado_idEstado==4){
            return '<button type="button"  title="Habilitar" class="btn btn-info btn-sm" onclick="HabilitarApoderado('.$reg->idPersona.','.$reg->idApoderado.');"><i class="fa fa-sync"></i></button>';
        }
    }

   switch($_GET['op']){
        case 'AccionApoderado':
		 	$rspta=array("Error"=>false,"Mensaje"=>"","Registro"=>false);
         if(empty($idPersona)){

                /*--  validar si el numero de la factura ya se encuentra emitido  --*/
                $validarApoderado=$mantenimiento->ValidarApoderado($ApoderadoDNI,$idPersona);
                if($validarApoderado>0){
                    $rspta["Mensaje"].="La Persona ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }
                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el Apoderado.";
                }else{
                    $RespuestaRegistro=$mantenimiento->RegistroApoderado($idPersona,$idApoderado,$ApoderadoNombre,$ApoderadoApellidoP,$ApoderadoApellidoM,$ApoderadoDNI,$ApoderadoFechaNacimiento,$ApoderadoCorreo,$ApoderadoTelefono,$ApoderadoDireccion,$ApoderadoEstado,$ApoderadoTipoTarjeta,$ApoderadoDetalle,$login_idLog);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="Apoderado se registro Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="Apoderado no se puede registrar comuniquese con el area de soporte.";
                    }
                }
            }else{

                 $validarApoderado=$mantenimiento->ValidarApoderado($ApoderadoDNI,$idPersona);
                if($validarApoderado>0){
                    $rspta["Mensaje"].="La Persona ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }
                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el Apoderado.";
                }else{

                    $RespuestaRegistro=$mantenimiento->RegistroApoderado($idPersona,$idApoderado,$ApoderadoNombre,$ApoderadoApellidoP,$ApoderadoApellidoM,$ApoderadoDNI,$ApoderadoFechaNacimiento,$ApoderadoCorreo,$ApoderadoTelefono,$ApoderadoDireccion,$ApoderadoEstado,$ApoderadoTipoTarjeta,$ApoderadoDetalle,$login_idLog);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="Apoderado se Actualizo Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="Apoderado no se puede Actualizar comuniquese con el area de soporte.";
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

         case 'listar_TipoTarjeta':
           echo '<option value="0">--SELECCIONE--</option>';
      		$rpta = $general->Listar_TipoTarjeta();
         	while ($reg = $rpta->fetch_object()){
					echo '<option   value=' . $reg->idTipoTarjeta . '>' . $reg->Descripcion . '</option>';
         	}
       break;

		case 'Listar_Apoderado':

         $rspta=$mantenimiento->Listar_Apoderado();
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>'',
               "1"=>BuscarEstado($reg),
               "2"=>$reg->NombrePersona,
               "3"=>$reg->DNI,
               "4"=>$reg->TipoTarjeta,
               "5"=>$reg->Detalle,
               "6"=>$reg->fechaRegistro,
               "7"=>BuscarAccion($reg)
            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;

      case 'Eliminar_Apoderado':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_Apoderado($idPersona,1,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Apoderado Eliminado.":$rspta['Mensaje']="Apoderado no se pudo eliminar comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'Recuperar_Apoderado':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_Apoderado($idPersona,2,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Apoderado Restablecido.":$rspta['Mensaje']="Apoderado no se pudo Restablecer comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'RecuperarInformacion_Apoderado':
			$rspta=$mantenimiento->Recuperar_Apoderado($idPersona,$idApoderado);
         echo json_encode($rspta);
      break;


   }


?>
