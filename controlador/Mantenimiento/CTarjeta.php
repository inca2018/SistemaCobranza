<?php
   session_start();
   require_once "../../modelo/Mantenimiento/MTarjeta.php";
   require_once "../../modelo/General/MGeneral.php";
   $mantenimiento = new MTarjeta();
   $general = new MGeneral();


	$idTarjeta=isset($_POST["idTarjeta"])?limpiarCadena($_POST["idTarjeta"]):"";
	$TarjetaNombre=isset($_POST["TarjetaNombre"])?limpiarCadena($_POST["TarjetaNombre"]):"";

	$TarjetaEstado=isset($_POST["TarjetaEstado"])?limpiarCadena($_POST["TarjetaEstado"]):"";


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
            <button type="button"   title="Editar" class="btn btn-warning btn-sm" onclick="EditarTarjeta('.$reg->idTipoTarjeta.')"><i class="fa fa-edit"></i></button>
               <button type="button"  title="Eliminar" class="btn btn-danger btn-sm" onclick="EliminarTarjeta('.$reg->idTipoTarjeta.')"><i class="fa fa-trash"></i></button>
               ';
        }elseif($reg->Estado_idEstado==4){
            return '<button type="button"  title="Habilitar" class="btn btn-info btn-sm" onclick="HabilitarTarjeta('.$reg->idTipoTarjeta.')"><i class="fa fa-sync"></i></button>';
        }
    }

   switch($_GET['op']){
        case 'AccionTarjeta':
		 	$rspta=array("Error"=>false,"Mensaje"=>"","Registro"=>false);
         if(empty($idTarjeta)){

                /*--  validar si el numero de la factura ya se encuentra emitido  --*/
                $validarTarjeta=$mantenimiento->ValidarTarjeta($TarjetaNombre,$idTarjeta);
                if($validarTarjeta>0){
                    $rspta["Mensaje"].="El Tarjeta ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }
                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el Tarjeta.";
                }else{
                    $RespuestaRegistro=$mantenimiento->RegistroTarjeta($idTarjeta,$TarjetaNombre,$TarjetaEstado,$login_idLog);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="Tarjeta se registro Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="Tarjeta no se puede registrar comuniquese con el area de soporte.";
                    }
                }
            }else{

                 $validarTarjeta=$mantenimiento->ValidarTarjeta($TarjetaNombre,$idTarjeta);
                if($validarTarjeta>0){
                    $rspta["Mensaje"].="El Tarjeta ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }
                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el Tarjeta.";
                }else{

                    $RespuestaRegistro=$mantenimiento->RegistroTarjeta($idTarjeta,$TarjetaNombre,$TarjetaEstado,$login_idLog);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="Tarjeta se Actualizo Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="Tarjeta no se puede Actualizar comuniquese con el area de soporte.";
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

		case 'Listar_Tarjeta':

         $rspta=$mantenimiento->Listar_Tarjeta();
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

      case 'Eliminar_Tarjeta':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_Tarjeta($idTarjeta,1,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Tarjeta Eliminado.":$rspta['Mensaje']="Tarjeta no se pudo eliminar comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'Recuperar_Tarjeta':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_Tarjeta($idTarjeta,2,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Tarjeta Restablecido.":$rspta['Mensaje']="Tarjeta no se pudo Restablecer comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'RecuperarInformacion_Tarjeta':
			$rspta=$mantenimiento->Recuperar_Tarjeta($idTarjeta);
         echo json_encode($rspta);
      break;


   }


?>
