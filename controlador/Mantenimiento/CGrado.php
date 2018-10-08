<?php
   session_start();
   require_once "../../modelo/Mantenimiento/MGrado.php";
   require_once "../../modelo/General/MGeneral.php";
   $mantenimiento = new MGrado();
   $general = new MGeneral();


	$idGrado=isset($_POST["idGrado"])?limpiarCadena($_POST["idGrado"]):"";
	$GradoNombre=isset($_POST["GradoNombre"])?limpiarCadena($_POST["GradoNombre"]):"";

	$GradoEstado=isset($_POST["GradoEstado"])?limpiarCadena($_POST["GradoEstado"]):"";


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
            <button type="button" title="Editar" class="btn btn-warning btn-sm" onclick="EditarGrado('.$reg->idGrado.')"><i class="fa fa-edit"></i></button>
               <button type="button"  title="Eliminar" class="btn btn-danger btn-sm" onclick="EliminarGrado('.$reg->idGrado.')"><i class="fa fa-trash"></i></button>
               ';
        }elseif($reg->Estado_idEstado==4){
            return '<button type="button"  title="Habilitar" class="btn btn-info btn-sm" onclick="HabilitarGrado('.$reg->idGrado.')"><i class="fa fa-sync"></i></button>';
        }
    }

   switch($_GET['op']){
        case 'AccionGrado':
		 	$rspta=array("Error"=>false,"Mensaje"=>"","Registro"=>false);
         if(empty($idGrado)){

                /*--  validar si el numero de la factura ya se encuentra emitido  --*/
                $validarGrado=$mantenimiento->ValidarGrado($GradoNombre,$idGrado);
                if($validarGrado>0){
                    $rspta["Mensaje"].="El Grado ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }
                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el Grado.";
                }else{
                    $RespuestaRegistro=$mantenimiento->RegistroGrado($idGrado,$GradoNombre,$GradoEstado,$login_idLog);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="Grado se registro Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="Grado no se puede registrar comuniquese con el area de soporte.";
                    }
                }
            }else{

                 $validarGrado=$mantenimiento->ValidarGrado($GradoNombre,$idGrado);
                if($validarGrado>0){
                    $rspta["Mensaje"].="El Grado ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }
                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el Grado.";
                }else{

                    $RespuestaRegistro=$mantenimiento->RegistroGrado($idGrado,$GradoNombre,$GradoEstado,$login_idLog);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="Grado se Actualizo Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="Grado no se puede Actualizar comuniquese con el area de soporte.";
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

		case 'Listar_Grado':

         $rspta=$mantenimiento->Listar_Grado();
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

      case 'Eliminar_Grado':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_Grado($idGrado,1,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Grado Eliminado.":$rspta['Mensaje']="Grado no se pudo eliminar comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'Recuperar_Grado':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_Grado($idGrado,2,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Grado Restablecido.":$rspta['Mensaje']="Grado no se pudo Restablecer comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'RecuperarInformacion_Grado':
			$rspta=$mantenimiento->Recuperar_Grado($idGrado);
         echo json_encode($rspta);
      break;


   }


?>
