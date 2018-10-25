<?php
   session_start();
   require_once "../../modelo/Mantenimiento/MTipoPago.php";
   require_once "../../modelo/General/MGeneral.php";
   $mantenimiento = new MTipoPago();
   $general = new MGeneral();


	$idTipoPago=isset($_POST["idTipoPago"])?limpiarCadena($_POST["idTipoPago"]):"";
	$TipoPagoNombre=isset($_POST["TipoPagoNombre"])?limpiarCadena($_POST["TipoPagoNombre"]):"";
    $TipoPagoImporte=isset($_POST["TipoPagoImporte"])?limpiarCadena($_POST["TipoPagoImporte"]):"";
    $TipoPagoCuota=isset($_POST["TipoPagoCuota"])?limpiarCadena($_POST["TipoPagoCuota"]):"";

	$TipoPagoEstado=isset($_POST["TipoPagoEstado"])?limpiarCadena($_POST["TipoPagoEstado"]):"";


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
            <button type="button"   title="Editar" class="btn btn-warning btn-sm" onclick="EditarTipoPago('.$reg->idGeneral.')"><i class="fa fa-edit"></i></button>
               <button type="button"  title="Eliminar" class="btn btn-danger btn-sm" onclick="EliminarTipoPago('.$reg->idGeneral.')"><i class="fa fa-trash"></i></button>
               ';
        }elseif($reg->Estado_idEstado==4){
            return '<button type="button"  title="Habilitar" class="btn btn-info btn-sm" onclick="HabilitarTipoPago('.$reg->idGeneral.')"><i class="fa fa-sync"></i></button>';
        }
    }

   switch($_GET['op']){
        case 'AccionTipoPago':
		 	$rspta=array("Error"=>false,"Mensaje"=>"","Registro"=>false);
         if(empty($idTipoPago)){

                /*--  validar si el numero de la factura ya se encuentra emitido  --*/
                $validarTipoPago=$mantenimiento->ValidarTipoPago($TipoPagoNombre,$idTipoPago);
                if($validarTipoPago>0){
                    $rspta["Mensaje"].="El TipoPago ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }
                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el TipoPago.";
                }else{
                    $RespuestaRegistro=$mantenimiento->RegistroTipoPago($idTipoPago,$TipoPagoNombre,$TipoPagoImporte,$TipoPagoCuota,$TipoPagoEstado,$login_idLog);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="TipoPago se registro Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="TipoPago no se puede registrar comuniquese con el area de soporte.";
                    }
                }
            }else{

                 $validarTipoPago=$mantenimiento->ValidarTipoPago($TipoPagoNombre,$idTipoPago);
                if($validarTipoPago>0){
                    $rspta["Mensaje"].="El TipoPago ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }
                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el TipoPago.";
                }else{

                    $RespuestaRegistro=$mantenimiento->RegistroTipoPago($idTipoPago,$TipoPagoNombre,$TipoPagoImporte,$TipoPagoCuota,$TipoPagoEstado,$login_idLog);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="TipoPago se Actualizo Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="TipoPago no se puede Actualizar comuniquese con el area de soporte.";
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

		case 'Listar_TipoPago':

         $rspta=$mantenimiento->Listar_TipoPago();
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>'',
               "1"=>BuscarEstado($reg),
               "2"=>$reg->NombrePago,
               "3"=>"S/. ".number_format($reg->Monto,2),
               "4"=>$reg->Cuotas,
               "5"=>BuscarAccion($reg)
            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;

      case 'Eliminar_TipoPago':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_TipoPago($idTipoPago,1,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="TipoPago Eliminado.":$rspta['Mensaje']="TipoPago no se pudo eliminar comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'Recuperar_TipoPago':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_TipoPago($idTipoPago,2,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="TipoPago Restablecido.":$rspta['Mensaje']="TipoPago no se pudo Restablecer comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'RecuperarInformacion_TipoPago':
			$rspta=$mantenimiento->Recuperar_TipoPago($idTipoPago);
         echo json_encode($rspta);
      break;


   }


?>
