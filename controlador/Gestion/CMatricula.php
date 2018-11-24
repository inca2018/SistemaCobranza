<?php
   session_start();
   require_once "../../modelo/Gestion/MMatricula.php";
   require_once "../../modelo/General/MGeneral.php";
   require_once "../../config/conexion.php";
   $gestion = new MMatricula();
   $general = new MGeneral();
   $recursos = new Conexion();

   $idPersona=isset($_POST["idPersona"])?limpiarCadena($_POST["idPersona"]):"";
   $idAlumno=isset($_POST["idAlumno"])?limpiarCadena($_POST["idAlumno"]):"";
   $year=isset($_POST["year"])?limpiarCadena($_POST["year"]):"";
    $idNivel=isset($_POST["idNivel"])?limpiarCadena($_POST["idNivel"]):"";
    $idGrado=isset($_POST["idGrado"])?limpiarCadena($_POST["idGrado"]):"";
    $idSeccion=isset($_POST["idSeccion"])?limpiarCadena($_POST["idSeccion"]):"";

    $Pagos=isset($_POST["Pagos"])?limpiarCadena($_POST["Pagos"]):"";
    $Actualizar=isset($_POST["Actualizar"])?limpiarCadena($_POST["Actualizar"]):"";
   /* $date = str_replace('/', '-', $fechaInicio);
    $fechaInicio = date("Y-m-d", strtotime($date));
 	 $date = str_replace('/', '-', $fechaFin);
    $fechaFin = date("Y-m-d", strtotime($date));*/

$login_idLog=$_SESSION['idUsuario'];
function verificarFoto($reg){
    if($reg->imagen==NULL){
        return "";
    }else{
        return '<div class="col-5 text-center">
                              <img class="imgRedonda" src="../../vista/FotosAlumno/'.$reg->imagen.'"  >
                           </div>';
    }
}

function verificarMatricula($reg){
    if($reg->EstadoMatricula=="MATRICULADO"){
        return '<div class="badge badge-success">'.$reg->EstadoMatricula.'</div>';
    }else{
      return '<div class="badge badge-danger">'.$reg->EstadoMatricula.'</div>';
    }
}

   switch($_GET['op']){

        case 'RecuperarDatosAlumno':
			$rspta=$gestion->RecuperarDatosAlumno($idPersona,$idAlumno,$year);
            echo json_encode($rspta);
        break;

		case 'Listar_Matriculas':

         $rspta=$gestion->ListarMatriculas($year);
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>'',
               "1"=>verificarMatricula($reg),
               "2"=>verificarFoto($reg),
               "3"=>$reg->AlumnoNombres,
               "4"=>$reg->DNI,
               "5"=>$reg->FechaNacimiento,
               "6"=>'<button type="button" title="Gestión de Matricula" class="btn btn-success btn-sm m-1" onclick="Matricular('.$reg->idPersona.','.$reg->idAlumno.');"><i class="fas fa-share-square"></i></button>'

            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;

    case 'ListarPagosDisponibles':

         $rspta=$gestion->ListarPagosDisponibles();
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

    	case 'ListarCuotasDisponibles':

         $rspta=$gestion->ListarCuotasDisponibles($idPersona,$idAlumno,$year);
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>'',
               "1"=>$recursos->BuscarEstado($reg),
               "2"=>"S/. ".number_format($reg->Importe),
               "3"=>"S/. ".number_format($reg->Diferencia),
               "4"=>$recursos->convertir($reg->Mes),
               "5"=>$reg->FechaEmision,
               "6"=>$reg->FechaVencimiento,
               "7"=>$reg->year

            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;


       case 'ListarYear':
      		$rpta = $gestion->ListarYear();
         	while ($reg = $rpta->fetch_object()){
					echo '<option   value=' . $reg->year . '>Gestión '. $reg->year . '</option>';
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



    case 'AgregarPlan1':
         $rspta=array("Error"=>false,"Mensaje"=>"","Registro"=>false);
         /*------ Cuando el usuario ya se esta facturando, ya no se puede eliminar --------*/
         $Recuperado=$gestion->AgregarPlan1($idPersona,$idAlumno,$year);

         $NumPagos=$Recuperado["Pagos"];
         $Mensaje=$Recuperado["Mensaje"];

         if($NumPagos>0){
           $rspta['Registro']=false;
           $rspta['Mensaje']=$Mensaje;
         }else{
           $rspta['Registro']=true;
           $rspta['Mensaje']=$Mensaje;
         }

         echo json_encode($rspta);
      break;
    case 'AgregarPlan2':
         $rspta=array("Error"=>false,"Mensaje"=>"","Registro"=>false);

         $Recuperado=$gestion->AgregarPlan2($idPersona,$idAlumno,$year);

        $NumPagos=$Recuperado["Pagos"];
         $Mensaje=$Recuperado["Mensaje"];

         if($NumPagos>0){
           $rspta['Registro']=false;
           $rspta['Mensaje']=$Mensaje;
         }else{
           $rspta['Registro']=true;
           $rspta['Mensaje']=$Mensaje;
         }
         echo json_encode($rspta);
      break;
     case 'LimpiarMatricula':
         $rspta=array("Error"=>false,"Mensaje"=>"","Registro"=>false);

        $Recuperado=$gestion->LimpiarMatricula($idPersona,$idAlumno,$year);

         $NumPagos=$Recuperado["Pagos"];
         $Mensaje=$Recuperado["Mensaje"];

         if($NumPagos>0){
           $rspta['Registro']=false;
           $rspta['Mensaje']=$Mensaje;
         }else{
           $rspta['Registro']=true;
           $rspta['Mensaje']=$Mensaje;
         }
         echo json_encode($rspta);
      break;
      case 'RecuperarPagoAlumno':
         //$Pagos="";
         //$count=0;
         //$rspta=array("Pagos"=>"","Cantidad"=>0);
         $recuperado=$gestion->RecuperarPagoAlumno($idAlumno,$year);
        /* while ($reg=$recuperado->fetch_object()){
             $Pagos=$Pagos.$reg->TipoPago_idTipoPago."-";
             $count=$count+1;
         }*/
         $response =array();
         while($reg=$recuperado->fetch_object()){
             $data =array();
             $data["id"]=$reg->TipoPago_idTipoPago;
             $data["estado"]=$reg->Pagado;
             $response[]=$data;
         }
         //$rspta["Pagos"]=$Pagos;
         //$rspta["Cantidad"]=$count;
         echo json_encode($response);
      break;
     case 'RegistrarMatricula':
         $rspta=array("Error"=>false,"Mensaje"=>"","Registro"=>false);
         $data= array();
         $Pagos = explode(',', $Pagos);
         $respuesta="";
         $contador=count($Pagos);


        for($i=0;$i<$contador;$i++){
            $rpta = $gestion->ActualizarListadoPago($Pagos[$i],$idAlumno,$year);

        }


       if($rpta){
            $data["Accion"]=true;
            $data["Mensaje"]="Listado de Pagos Actualizados.";
         }else{
            $data["Accion"]=false;
            $data["Mensaje"]="Listado de Pagos No se pudieron Actualizar";
         }

        if($data["Accion"]){
             $rspta['Registro']=$gestion->MatricularAlumno($idPersona,$idAlumno,$year,$idNivel,$idGrado,$idSeccion);
             $rspta['Registro']?$rspta['Mensaje']="Alumno Matriculado.":$rspta['Mensaje']="Alumno no se pudo Matricular, comuniquese con el   area de soporte";
        }

         echo json_encode($rspta);
      break;

       case 'ActualizarMatricula':
         $rspta=array("Error"=>false,"Mensaje"=>"","Registro"=>false);
         $data= array();
         $Pagos = explode(',', $Pagos);
         $respuesta="";
         $contador=count($Pagos);

         $limpieza=$gestion->LimpiarPagos($idAlumno,$year);
         if($limpieza){
             for($i=0;$i<$contador;$i++){
                    $rpta = $gestion->ActualizarListadoPago($Pagos[$i],$idAlumno,$year);
                }

               if($rpta){
                    $data["Accion"]=true;
                    $data["Mensaje"]="Listado de Pagos Actualizados.";
                 }else{
                    $data["Accion"]=false;
                    $data["Mensaje"]="Listado de Pagos No se pudieron Actualizar";
                 }

                if($data["Accion"]){
                     $rspta['Registro']=$gestion->ActualizarAlumno($idPersona,$idAlumno,$year,$idNivel,$idGrado,$idSeccion);
                     $rspta['Registro']?$rspta['Mensaje']="Matricula Actualizada.":$rspta['Mensaje']="Alumno no se pudo Matricular, comuniquese con el   area de soporte";
                }
         }else{
            $data["Accion"]=false;
            $rspta['Mensaje']="Se encontro problemas al Actualizar, comuniquese con el area de soporte.";
         }


         echo json_encode($rspta);
      break;

       case 'RecuperarNombreAlumno':
			$rspta=$gestion->RecuperarNombreAlumno($idAlumno);
            echo json_encode($rspta);
        break;
         case 'RecuperarNombreAlumno2':
			$rspta=$gestion->RecuperarNombreAlumno2($idAlumno);
            echo json_encode($rspta);
        break;


   }


?>
