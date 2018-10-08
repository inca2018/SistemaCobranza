<?php
   session_start();
   require_once "../../modelo/Mantenimiento/MAlumno.php";
   require_once "../../modelo/General/MGeneral.php";
   $mantenimiento = new MAlumno();
   $general = new MGeneral();


    $idAlumno=isset($_POST["idAlumno"])?limpiarCadena($_POST["idAlumno"]):"";
    $AlumnoNombre=isset($_POST["AlumnoNombre"])?limpiarCadena($_POST["AlumnoNombre"]):"";
    $AlumnoFechaNacimiento=isset($_POST["AlumnoFechaNacimiento"])?limpiarCadena($_POST["AlumnoFechaNacimiento"]):"";
    $AlumnoApellidoP=isset($_POST["AlumnoApellidoP"])?limpiarCadena($_POST["AlumnoApellidoP"]):"";
    $AlumnoDNI=isset($_POST["AlumnoDNI"])?limpiarCadena($_POST["AlumnoDNI"]):"";
    $AlumnoApellidoM=isset($_POST["AlumnoApellidoM"])?limpiarCadena($_POST["AlumnoApellidoM"]):"";
    $AlumnoCorreo=isset($_POST["AlumnoCorreo"])?limpiarCadena($_POST["AlumnoCorreo"]):"";
    $AlumnoTelefono=isset($_POST["AlumnoTelefono"])?limpiarCadena($_POST["AlumnoTelefono"]):"";
    $AlumnoDireccion=isset($_POST["AlumnoDireccion"])?limpiarCadena($_POST["AlumnoDireccion"]):"";
    $AlumnoEstado=isset($_POST["AlumnoEstado"])?limpiarCadena($_POST["AlumnoEstado"]):"";

    $AlumnoNivel=isset($_POST["AlumnoNivel"])?limpiarCadena($_POST["AlumnoNivel"]):"";
    $AlumnoGrado=isset($_POST["AlumnoGrado"])?limpiarCadena($_POST["AlumnoGrado"]):"";
    $AlumnoSeccion=isset($_POST["AlumnoSeccion"])?limpiarCadena($_POST["AlumnoSeccion"]):"";

    $AlumnoImagen=isset($_POST["AlumnoImagen"])?limpiarCadena($_POST["AlumnoImagen"]):"";




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
            <button type="button" title="Editar" class="btn btn-warning btn-sm" onclick="EditarAlumno('.$reg->idAlumno.')"><i class="fa fa-edit"></i></button>
               <button type="button"  title="Eliminar" class="btn btn-danger btn-sm" onclick="EliminarAlumno('.$reg->idAlumno.')"><i class="fa fa-trash"></i></button>
               ';
        }elseif($reg->Estado_idEstado==4){
            return '<button type="button"  title="Habilitar" class="btn btn-info btn-sm" onclick="HabilitarAlumno('.$reg->idAlumno.')"><i class="fa fa-sync"></i></button>';
        }
    }

   switch($_GET['op']){
        case 'AccionAlumno':
		 	$rspta=array("Error"=>false,"Mensaje"=>"","Registro"=>false);
         if(empty($idAlumno)){

                /*--  validar si el numero de la factura ya se encuentra emitido  --*/
                $validarAlumno=$mantenimiento->ValidarAlumno($AlumnoNombre,$idAlumno);
                if($validarAlumno>0){
                    $rspta["Mensaje"].="El Alumno ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }
                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el Alumno.";
                }else{
                    $RespuestaRegistro=$mantenimiento->RegistroAlumno($idAlumno,$AlumnoNombre,$AlumnoEstado,$login_idLog);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="Alumno se registro Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="Alumno no se puede registrar comuniquese con el area de soporte.";
                    }
                }
            }else{

                 $validarAlumno=$mantenimiento->ValidarAlumno($AlumnoNombre,$idAlumno);
                if($validarAlumno>0){
                    $rspta["Mensaje"].="El Alumno ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }
                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el Alumno.";
                }else{

                    $RespuestaRegistro=$mantenimiento->RegistroAlumno($idAlumno,$AlumnoNombre,$AlumnoEstado,$login_idLog);
                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="Alumno se Actualizo Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="Alumno no se puede Actualizar comuniquese con el area de soporte.";
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
        case 'listar_niveles':

      		$rpta = $general->Listar_Niveles();
             echo '<option value="0">--SELECCIONE--</option>';
         	while ($reg = $rpta->fetch_object()){
					echo '<option   value=' . $reg->idNivel . '>' . $reg->Descripcion . '</option>';
         	}
       break;
         case 'listar_grados':

      		$rpta = $general->Listar_Grados();
         	while ($reg = $rpta->fetch_object()){
					echo '<option   value=' . $reg->idGrado . '>' . $reg->Descripcion . '</option>';
         	}
       break;
         case 'listar_secciones':

      		$rpta = $general->Listar_Secciones();
         	while ($reg = $rpta->fetch_object()){
					echo '<option   value=' . $reg->idSeccion . '>' . $reg->Descripcion . '</option>';
         	}
       break;

		case 'Listar_Alumno':

         $rspta=$mantenimiento->Listar_Alumno();
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

      case 'Eliminar_Alumno':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_Alumno($idAlumno,1,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Alumno Eliminado.":$rspta['Mensaje']="Alumno no se pudo eliminar comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'Recuperar_Alumno':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_Alumno($idAlumno,2,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Alumno Restablecido.":$rspta['Mensaje']="Alumno no se pudo Restablecer comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'RecuperarInformacion_Alumno':
			$rspta=$mantenimiento->Recuperar_Alumno($idAlumno);
         echo json_encode($rspta);
      break;


   }


?>
