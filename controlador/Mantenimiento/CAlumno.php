<?php
   session_start();
   require_once "../../modelo/Mantenimiento/MAlumno.php";
   require_once "../../modelo/General/MGeneral.php";
   require_once "../../config/conexion.php";
   $mantenimiento = new MAlumno();
   $general = new MGeneral();
   $recursos = new Conexion();

    $idPersona=isset($_POST["idPersona"])?limpiarCadena($_POST["idPersona"]):"";
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

    $O_importe_matricula=isset($_POST["O_importe_matricula"])?limpiarCadena($_POST["O_importe_matricula"]):"";
    $O_importe_cuota=isset($_POST["O_importe_cuota"])?limpiarCadena($_POST["O_importe_cuota"]):"";
    $O_importe_adicional1=isset($_POST["O_importe_adicional1"])?limpiarCadena($_POST["O_importe_adicional1"]):"";
    $O_importe_adicional2=isset($_POST["O_importe_adicional2"])?limpiarCadena($_POST["O_importe_adicional2"]):"";
    $O_observaciones=isset($_POST["O_observaciones"])?limpiarCadena($_POST["O_observaciones"]):"";

    $O_idPersona=isset($_POST["O_idPersona"])?limpiarCadena($_POST["O_idPersona"]):"";
    $O_idAlumno=isset($_POST["O_idAlumno"])?limpiarCadena($_POST["O_idAlumno"]):"";

    $campo=isset($_POST["campo"])?limpiarCadena($_POST["campo"]):"";
    $campoEdicion=isset($_POST["campoEdicion"])?limpiarCadena($_POST["campoEdicion"]):"";

    $idCuota=isset($_POST["idCuota"])?limpiarCadena($_POST["idCuota"]):"";
    $Cantidad=isset($_POST["Cantidad"])?limpiarCadena($_POST["Cantidad"]):"";


    $Pagos=isset($_POST["Pagos"])?limpiarCadena($_POST["Pagos"]):"";

    $inicio=isset($_POST["inicio"])?limpiarCadena($_POST["inicio"]):"";
    $fin=isset($_POST["fin"])?limpiarCadena($_POST["fin"]):"";

	$login_idLog=$_SESSION['idUsuario'];

    $date = str_replace('/', '-', $AlumnoFechaNacimiento);
   $AlumnoFechaNacimiento = date("Y-m-d", strtotime($date));

 $date = str_replace('/', '-', $inicio);
   $inicio = date("Y-m-d", strtotime($date));

 $date = str_replace('/', '-', $fin);
   $fin = date("Y-m-d", strtotime($date));

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
    function BuscarAccion2($reg){
        $rep="";
        if($reg->Estado_idEstado==5){
            $rep.='
            <button type="button" title="Anular" class="btn btn-danger btn-sm m-1" onclick="AnularCuota('.$reg->idCuota.','.$reg->Estado_idEstado.');"><i class="fa fa-trash"></i></button>
               ';
        }elseif($reg->Estado_idEstado==8){
            $rep.='<button type="button"  title="Habilitar" class="btn btn-info btn-sm m-1" onclick="HabilitarCuota('.$reg->idCuota.','.$reg->Estado_idEstado.');"><i class="fa fa-sync"></i></button>';
        }
        elseif($reg->Estado_idEstado==2){
            $rep.='<button type="button"  title="Edición de Fechas" class="btn btn-warning btn-sm m-1" onclick="EditarFechas('.$reg->idCuota.');"><i class="fa fa-pen"></i></button>';
        }
        return $rep;
    }
      function Matriculado($reg){
        $rep="";
        if($reg==1){
            $rep.='
            <div class="badge badge-purple">SI</div>
               ';
        }elseif($reg==0){
            $rep.='<div class="badge badge-danger">NO</div>';
        }

        return $rep;
    }

    function BuscarAccion($reg){
        $rep="";
        if($reg->Estado_idEstado==1 || $reg->Estado_idEstado==2 ){
            $rep.='
            <button type="button" title="Editar" class="btn btn-warning btn-sm m-1" onclick="EditarAlumno('.$reg->idPersona.','.$reg->idAlumno.');"><i class="fa fa-edit"></i></button>
               <button type="button"  title="Eliminar" class="btn btn-danger btn-sm m-1" onclick="EliminarAlumno('.$reg->idPersona.','.$reg->idAlumno.');"><i class="fa fa-trash"></i></button>
               ';
        }elseif($reg->Estado_idEstado==4){
            $rep.='<button type="button"  title="Habilitar" class="btn btn-info btn-sm m-1" onclick="HabilitarAlumno('.$reg->idPersona.','.$reg->idAlumno.');"><i class="fa fa-sync"></i></button>';
        }



        return $rep;
    }


 function verificarFoto($reg){
    if($reg->fotoAlumno==NULL){
        return "";
    }else{
        return '<div class="col-5 text-center">
                              <img class="imgRedonda" src="../../vista/FotosAlumno/'.$reg->fotoAlumno.'"  >
                           </div>';
    }

}



   switch($_GET['op']){
        case 'AccionAlumno':
		 	$rspta=array("Error"=>false,"Mensaje"=>"","Registro"=>false);
         if(empty($idPersona)){

                /*--  validar si el numero de la factura ya se encuentra emitido  --*/
                $validarAlumno=$mantenimiento->ValidarAlumno($AlumnoDNI,$idPersona);
                if($validarAlumno>0){
                    $rspta["Mensaje"].="La Persona ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }

                $Documento = "";
                if ($_FILES["adjuntar_documento"]["name"] != '') {
                    $tipoFile = $_FILES['adjuntar_documento']['type'];
                    if ($tipoFile == "image/jpeg") {
                        $Documento = $AlumnoDNI."/".$AlumnoNombre.".jpg";
                    } else {
                        $Documento      = null;
                        $rspta["Error"] = true;
                        $rspta["Mensaje"] .= " Documento Adjunto no es un Archivo JPG valido.";
                    }
                } else {
                    $Documento = null;
                }




                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el Alumno.";
                }else{
                    $RespuestaRegistro=$mantenimiento->RegistroAlumno($idPersona,$idAlumno,$AlumnoNombre,$AlumnoApellidoP,$AlumnoApellidoM,$AlumnoDNI,$AlumnoFechaNacimiento,$AlumnoCorreo,$AlumnoTelefono,$AlumnoDireccion,$AlumnoEstado,$Documento,$AlumnoNivel,$AlumnoGrado,$AlumnoSeccion,$login_idLog);

                     if($Documento!=null || $Documento!='')
					 {
						$Subida= $recursos->upload_documento(1,$AlumnoDNI,$AlumnoNombre);
					 }

                    if($RespuestaRegistro){
                        $rspta["Registro"]=true;
                        $rspta["Mensaje"]="Alumno se registro Correctamente.";
                    }else{
                        $rspta["Registro"]=false;
                        $rspta["Mensaje"]="Alumno no se puede registrar comuniquese con el area de soporte.";
                    }
                }
            }else{

                 $validarAlumno=$mantenimiento->ValidarAlumno($AlumnoDNI,$idPersona);
                if($validarAlumno>0){
                    $rspta["Mensaje"].="La Persona ya se encuentra Registrado ";
                    $rspta["Error"]=true;
                }

                  $Documento ="";
                if ($_FILES["adjuntar_documento"]["name"] != '') {
                    $tipoFile = $_FILES['adjuntar_documento']['type'];
                    if ($tipoFile == "image/jpeg") {
                       $Documento = $AlumnoDNI."/".$AlumnoNombre.".jpg";
                    } else {
                        $Documento      = null;
                        $rspta["Error"] = true;
                        $rspta["Mensaje"] .= " Documento Adjunto no es un Archivo JPG valido.";
                    }
                } else {
                    $Documento = null;
                }



                if($rspta["Error"]){
                    $rspta["Mensaje"].="Por estas razones no se puede Registrar el Alumno.";
                }else{

                    $RespuestaRegistro=$mantenimiento->RegistroAlumno($idPersona,$idAlumno,$AlumnoNombre,$AlumnoApellidoP,$AlumnoApellidoM,$AlumnoDNI,$AlumnoFechaNacimiento,$AlumnoCorreo,$AlumnoTelefono,$AlumnoDireccion,$AlumnoEstado,$Documento,$AlumnoNivel,$AlumnoGrado,$AlumnoSeccion,$login_idLog);


                    if($Documento!=null || $Documento!='')
					 {

						$Subida= $recursos->upload_documento(2,$AlumnoDNI,$AlumnoNombre);
					 }
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
           echo '<option value="0">--SELECCIONE--</option>';
      		$rpta = $general->Listar_Grados();
         	while ($reg = $rpta->fetch_object()){
					echo '<option   value=' . $reg->idGrado . '>' . $reg->Descripcion . '</option>';
         	}
       break;
         case 'listar_secciones':
           echo '<option value="0">--SELECCIONE--</option>';
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
               "2"=>verificarFoto($reg),
               "3"=>$reg->NombrePersona,
               "4"=>$reg->DNI,
               "5"=>$reg->FechaNacimiento,
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

     case 'Listar_Cuotas':

         $rspta=$mantenimiento->Listar_Cuotas_Disponibles($idAlumno);
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>'',
               "1"=>BuscarEstado($reg),
               "2"=>$reg->Importe,
               "3"=>$reg->Diferencia,
               "4"=>$reg->fechaEmision,
               "5"=>$reg->fechaVencimiento,
               "6"=>BuscarAccion2($reg)
            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;
       case 'Listar_Tipo_Pagos':

         $rspta=$mantenimiento->Listar_Pagos_Disponibles();
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>'',
               "1"=>$reg->NombrePago,
               "2"=>"S/. ".number_format($reg->Monto,2),
               "3"=>$reg->Cuotas,
               "4"=>'<div  title="Seleccione">
                           <label>
                           <input type="checkbox" class="seleccion_pagos" id="'.$reg->idGeneral.'" data-pago="'.$reg->Monto.'" data-cuota="'.$reg->Cuotas.'">
                             </label>
                     </div>'
            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;
       case 'RecuperarPagoAlumno':
         $Pagos="";
         $count=0;
         $rspta=array("Pagos"=>"","Cantidad"=>0);
         $recuperado=$mantenimiento->RecuperarPagoAlumno($idAlumno);
         while ($reg=$recuperado->fetch_object()){
             $Pagos=$Pagos.$reg->TipoPago_idTipoPago."-";
             $count=$count+1;
         }
         $rspta["Pagos"]=$Pagos;
         $rspta["Cantidad"]=$count;
         echo json_encode($rspta);
      break;

      case 'Eliminar_Alumno':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_Alumno($idPersona,1,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Alumno Eliminado.":$rspta['Mensaje']="Alumno no se pudo eliminar comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'Recuperar_Alumno':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->Eliminar_Alumno($idPersona,2,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Alumno Restablecido.":$rspta['Mensaje']="Alumno no se pudo Restablecer comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'RecuperarInformacion_Alumno':
			$rspta=$mantenimiento->Recuperar_Alumno($idPersona,$idAlumno);
         echo json_encode($rspta);
      break;

      case 'ActualizarPagos':
         $data= array();
         $Pagos = explode(',', $Pagos);
         $respuesta="";
         $contador=count($Pagos);
         $limpieza=$mantenimiento->LimpiarPagos($idAlumno);
          if($limpieza){
             for($i=0;$i<$contador;$i++){
            $rpta = $mantenimiento->ActualizarListadoPago($Pagos[$i],$idAlumno);
             }

               if($rpta){
                    $data["Accion"]=true;
                    $data["Mensaje"]="Listado de Pagos Actualizados.";
                 }else{
                    $data["Accion"]=false;
                    $data["Mensaje"]="Listado de Pagos No se pudieron Actualizar";
                 }
          }else{
              $data["Accion"]=false;
              $data["Mensaje"]="Listado de Pagos No se pudieron Actualizar";
          }

         echo json_encode($data);

      break;


      case 'AccionMatricula':
         $rspta=array("Error"=>false,"Mensaje"=>"","Registro"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Registro']=$mantenimiento->Matricular($O_idPersona,$O_idAlumno,$O_importe_matricula,$O_importe_cuota,$O_importe_adicional1,$O_importe_adicional2,$O_observaciones,$login_idLog);

         $rspta['Registro']?$rspta['Mensaje']="Alumno Matriculado.":$rspta['Mensaje']="Alumno no se pudo matricular comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

        case 'AgregarCuotaNueva':
         $rspta=array("Error"=>false,"Mensaje"=>"","Registro"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Registro']=$mantenimiento->AgregarCuota($O_idAlumno,$Cantidad,$login_idLog);

         $rspta['Registro']?$rspta['Mensaje']="Cuota Agregada.":$rspta['Mensaje']="Cuota no se pudo Agregar comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

         case 'ActualizarCampo':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->ActualizarCampo($idAlumno,$campo,$campoEdicion);

         $rspta['Eliminar']?$rspta['Mensaje']="Campo Actualizado.":$rspta['Mensaje']="Campo no se pudo Actualizar comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

      case 'AnularCuota':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->AnularCuota($idCuota,1,$login_idLog);

         $rspta['Eliminar']?$rspta['Mensaje']="Cuota Anulada.":$rspta['Mensaje']="Cuota no se pudo Anular comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

     case 'RecuperarCuota':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Eliminar']=$mantenimiento->AnularCuota($idCuota,2,$login_idLog);
         $rspta['Eliminar']?$rspta['Mensaje']="Cuota Recuperada.":$rspta['Mensaje']="Cuota no se pudo Recuperar comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;


  case 'ActualizarFechas':
         $rspta = array("Mensaje"=>"","Actualizar"=>false,"Error"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $rspta['Actualizar']=$mantenimiento->ActualizarFechas($O_idAlumno,$idCuota,$inicio,$fin);

         $rspta['Actualizar']?$rspta['Mensaje']="Fechas Actualizadas.":$rspta['Mensaje']="Campo no se pudo Actualizar comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

   }


?>
