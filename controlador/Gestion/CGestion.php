<?php
   session_start();
   require_once "../../modelo/Gestion/MGestion.php";
   require_once "../../modelo/General/MGeneral.php";
   require_once "../../config/conexion.php";
   require_once "../../vista/documento/boleta.php";

   require_once "../../../php/PasswordHash.php";

    $gestion = new MGestion();
    $general = new MGeneral();
    $recursos = new Conexion();


	$idGestion=isset($_POST["idGestion"])?limpiarCadena($_POST["idGestion"]):"";
	$GestionNombre=isset($_POST["GestionNombre"])?limpiarCadena($_POST["GestionNombre"]):"";
	$GestionDescripcion=isset($_POST["GestionDescripcion"])?limpiarCadena($_POST["GestionDescripcion"]):"";
	$GestionEstado=isset($_POST["GestionEstado"])?limpiarCadena($_POST["GestionEstado"]):"";

    $idPermisos=isset($_POST["idPermisos"])?limpiarCadena($_POST["idPermisos"]):"";
    $Permiso1=isset($_POST["m_gestion"])?limpiarCadena($_POST["m_gestion"]):"";
    $Permiso2=isset($_POST["m_gestion"])?limpiarCadena($_POST["m_gestion"]):"";
    $Permiso3=isset($_POST["m_reporte"])?limpiarCadena($_POST["m_reporte"]):"";

    $idPlan=isset($_POST["idPlan"])?limpiarCadena($_POST["idPlan"]):"";
    $idAlumno=isset($_POST["idAlumno"])?limpiarCadena($_POST["idAlumno"]):"";
    $idCuota=isset($_POST["idCuota"])?limpiarCadena($_POST["idCuota"]):"";

	$login_idLog=$_SESSION['idUsuario'];


    $PagoTipoPago=isset($_POST["PagoTipoPago"])?limpiarCadena($_POST["PagoTipoPago"]):"";
    $PagoTipoTarjeta=isset($_POST["PagoTipoTarjeta"])?limpiarCadena($_POST["PagoTipoTarjeta"]):"";

    $pago_detalle=isset($_POST["pago_detalle"])?limpiarCadena($_POST["pago_detalle"]):"";
    $numPago=isset($_POST["numPago"])?limpiarCadena($_POST["numPago"]):"";

    $importePago=isset($_POST["MontoIngreso"])?limpiarCadena($_POST["MontoIngreso"]):"";
    $importeBase=isset($_POST["importeBase"])?limpiarCadena($_POST["importeBase"]):"";
    $importeMora=isset($_POST["importeMora"])?limpiarCadena($_POST["importeMora"]):"";

    $fechaInicio=isset($_POST["fechaInicio"])?limpiarCadena($_POST["fechaInicio"]):"";
    $fechaFin=isset($_POST["fechaFin"])?limpiarCadena($_POST["fechaFin"]):"";

    $year=isset($_POST["year"])?limpiarCadena($_POST["year"]):"";


    $idAlumnoP=isset($_POST["idAlumnoP"])?limpiarCadena($_POST["idAlumnoP"]):"";
    $yearP=isset($_POST["yearP"])?limpiarCadena($_POST["yearP"]):"";
    $importePago=isset($_POST["importePago"])?limpiarCadena($_POST["importePago"]):"";
    $importeMora=isset($_POST["importeMora"])?limpiarCadena($_POST["importeMora"]):"";
    $codigoPago=isset($_POST["codigoPago"])?limpiarCadena($_POST["codigoPago"]):"";
    $TipoPago=isset($_POST["TipoPago"])?limpiarCadena($_POST["TipoPago"]):"";
    $pagar_importe=isset($_POST["pagar_importe"])?limpiarCadena($_POST["pagar_importe"]):"";
    $pagar_importe_mora=isset($_POST["pagar_importe_mora"])?limpiarCadena($_POST["pagar_importe_mora"]):"";

    $tituloPago=isset($_POST["tituloPago"])?limpiarCadena($_POST["tituloPago"]):"";


     $idPagar=isset($_POST["idPagar"])?limpiarCadena($_POST["idPagar"]):"";
    $importePagar=isset($_POST["importePagar"])?limpiarCadena($_POST["importePagar"]):"";

    $idMatricula=isset($_POST["idMatricula"])?limpiarCadena($_POST["idMatricula"]):"";

    $TipoPago=isset($_POST["TipoPago"])?limpiarCadena($_POST["TipoPago"]):"";

    $Arreglo1=isset($_POST["Arreglo1"])?limpiarCadena($_POST["Arreglo1"]):"";
    $Arreglo2=isset($_POST["Arreglo2"])?limpiarCadena($_POST["Arreglo2"]):"";




    $final_importe_pagar=isset($_POST["final_importe_pagar"])?limpiarCadena($_POST["final_importe_pagar"]):"";
    $final_importe_vuelto=isset($_POST["final_importe_vuelto"])?limpiarCadena($_POST["final_importe_vuelto"]):"";
    $final_importe_total=isset($_POST["final_importe_total"])?limpiarCadena($_POST["final_importe_total"]):"";
    $final_metodoPago=isset($_POST["final_metodoPago"])?limpiarCadena($_POST["final_metodoPago"]):"";
    $final_tipo_tarjeta=isset($_POST["final_tipo_tarjeta"])?limpiarCadena($_POST["final_tipo_tarjeta"]):"";
    $final_num_tarjeta=isset($_POST["final_num_tarjeta"])?limpiarCadena($_POST["final_num_tarjeta"]):"";
    $final_cvv_tarjeta=isset($_POST["final_cvv_tarjeta"])?limpiarCadena($_POST["final_cvv_tarjeta"]):"";
    $final_detalle=isset($_POST["final_detalle"])?limpiarCadena($_POST["final_detalle"]):"";

 	$idRecuperado=isset($_POST["idRecuperado"])?limpiarCadena($_POST["idRecuperado"]):"";


    // GESTION DE PERFIL
    $UsuarioCorreo=isset($_POST["UsuarioCorreo"])?limpiarCadena($_POST["UsuarioCorreo"]):"";
    $UsuarioContacto=isset($_POST["UsuarioContacto"])?limpiarCadena($_POST["UsuarioContacto"]):"";
    $idUsuario=isset($_POST["idUsuario"])?limpiarCadena($_POST["idUsuario"]):"";

    $UsuarioPassVerificar=isset($_POST["UsuarioPassVerificar"])?limpiarCadena($_POST["UsuarioPassVerificar"]):"";
    $UsuarioPassNuevo=isset($_POST["UsuarioPassNuevo"])?limpiarCadena($_POST["UsuarioPassNuevo"]):"";


    $date = str_replace('/', '-', $fechaInicio);
    $fechaInicio = date("Y-m-d", strtotime($date));
 	 $date = str_replace('/', '-', $fechaFin);
    $fechaFin = date("Y-m-d", strtotime($date));



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
    function BuscarAccion($reg){
        if($reg->Estado_idEstado==1 || $reg->Estado_idEstado==2 ){
            return '<button type="button"  title="Permisos" class="btn btn-info btn-sm" onclick="PermisosGestion('.$reg->idGestion.')"><i class="fa fa-tasks"></i></button>
            <button type="button"   title="Editar" class="btn btn-warning btn-sm" onclick="EditarGestion('.$reg->idGestion.')"><i class="fa fa-edit"></i></button>
               <button type="button"  title="Eliminar" class="btn btn-danger btn-sm" onclick="EliminarGestion('.$reg->idGestion.')"><i class="fa fa-trash"></i></button>
               ';
        }elseif($reg->Estado_idEstado==4){
            return '<button type="button"  title="Habilitar" class="btn btn-info btn-sm" onclick="HabilitarGestion('.$reg->idGestion.')"><i class="fa fa-sync"></i></button>';
        }
    }
    function AccionesCuotas($reg){
        if($reg->Estado_idEstado==5 || $reg->Estado_idEstado==6 ){
            return '<button type="button"  title="Pago de Matriculas" class="btn btn-green btn-sm m-1" onclick="PagoCuota('.$reg->idCuota.')"><i class="fas fa-money-bill-alt fa-1x"></i>
            </button>';
        }else{
            return '<div class="badge badge-primary">PAGADO</div>';
        }
    }

   function AccionesOperacion($reg){
       $respuesta="";
       if($reg->PagosDisponibles==0 || $reg->PagosDisponibles=='0'){
            $respuesta.='<div class="badge badge-primary">DEBE HABILITAR PAGOS DEL ALUMNO</div>';
       }else{

         $respuesta.='<button type="button"   title="Realizar Pago" class="btn btn-success btn-sm m-1" onclick="Pagos('.$reg->idAlumno.')"><i class="fas fa-dollar-sign fa-lg"></i></button><button type="button"   title="Comprobantes de Pago" class="btn btn-info btn-sm m-1" onclick="Comprobantes('.$reg->idAlumno.')"><i class="fas fa-bars"></i></button>
            ';

       }
     return $respuesta;
   }
  function MostrarDocumento($reg){
      if($reg->Documento!=null){
        return '<a href="../../vista/Operaciones/Documento/'.$reg->idPago.'/'.$reg->Documento.'" target="_blank" class="btn btn-danger btn-sm ml-1 sombra3"><i class="fas fa-file-pdf"></i></a> ';
      }
  }

   switch($_GET['op']){
       case 'RecuperarDatosPerfil':
         $rspta=$gestion->RecuperarDatosPerfil($login_idLog);
         echo json_encode($rspta);
      break;

     case 'RecuperarInformacionMatricula':
			$rspta=$gestion->RecuperarInformacionMatricula($idAlumno);
         echo json_encode($rspta);
      break;
			 case 'RecuperarInformacionMatricula2':
			$rspta=$gestion->RecuperarInformacionMatricula2($idAlumno);
         echo json_encode($rspta);
      break;

    case 'RecuperarCuotaPagar':
			$rspta=$gestion->RecuperarCuotaPagar($idPlan,$idCuota);
         echo json_encode($rspta);
      break;
   case 'RecuperarParametros':
			$rspta=$gestion->RecuperarParametros();
         echo json_encode($rspta);
      break;
	 case 'RecuperarTotales':
			$rspta=$gestion->RecuperarTotales($idAlumno,$year);
         echo json_encode($rspta);
      break;

     case 'RecuperarReporte':
			$rspta=$gestion->RecuperarReporte($idAlumno);
         echo json_encode($rspta);
      break;
	 case 'RecuperarReporteFechas':
			$rspta=$gestion->RecuperarReporteFechas($fechaInicio,$fechaFin);
         echo json_encode($rspta);
      break;

       case 'RecuperarGraficoFechas':
			$rspta=$gestion->RecuperarGraficoFechas($fechaInicio,$fechaFin);
         echo json_encode($rspta);
      break;
      case 'RecuperarGraficoFechasAlumno':
			$rspta=$gestion->RecuperarGraficoFechasAlumno($fechaInicio,$fechaFin,$idAlumno);
         echo json_encode($rspta);
      break;
      case 'listar_tipoTarjeta':

      		$rpta = $general->Listar_TipoTarjeta();
         	while ($reg = $rpta->fetch_object()){
					echo '<option   value=' . $reg->idTipoTarjeta . '>' . $reg->Descripcion . '</option>';
         	}
       break;
     case 'listar_tipoPago':

      		$rpta = $general->Listar_TipoPago();
         	while ($reg = $rpta->fetch_object()){
					echo '<option   value=' . $reg->idTipoPago . '>' . $reg->Descripcion . '</option>';
         	}
       break;

		case 'listar_alumnos_filtro':

      		$rpta = $general->Listar_Alumnos();
         	while ($reg = $rpta->fetch_object()){
					echo '<option   value=' . $reg->idAlumno . '>' . $reg->personaNombre . '- DNI:'.$reg->DNI.'</option>';
         	}
       break;

		case 'Listar_Operaciones':

         $rspta=$gestion->ListarOperaciones();
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>'',
               "1"=>$reg->AlumnoNombre,
               "2"=>$reg->DNI,
               "3"=>$reg->ApoderadoNombre,
               "4"=>$reg->ApoderadoDNI,
               "5"=>$reg->NumCuotas,
               "6"=>$reg->CuotaPendiente,
               "7"=>$reg->CuotasPagadas,
               "8"=>$reg->CuotasVencidas,
               "9"=>AccionesOperacion($reg)


            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;

    case 'listarComprobantes':

         $rspta=$gestion->ListaComprobantes($idAlumno);
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>'',
               "1"=>$reg->ReciboVoucher,
               "2"=>$reg->YearComp,
               "3"=>"S/. ".number_format($reg->ImporteTotal,2),
               "4"=>$reg->TipoPago,
               "5"=>$reg->fechaRegistro,
               "6"=>MostrarDocumento($reg)


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
         $rspta=$gestion->Listar_Cuotas($idPlan,$idAlumno);
         $data= array();
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>'',
               "1"=>BuscarEstado($reg),
               "2"=>"S/. ".number_format($reg->Importe,2),
               "3"=>"S/. ".number_format($reg->Diferencia,2),

               "4"=>$reg->fechaVencimiento,
               "5"=>$reg->DiasMora,
               "6"=>"S/. ".number_format((($reg->DiasMora*1)-$reg->Mora),2),
               "7"=>AccionesCuotas($reg)

            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;

    case 'ListarDeuda1':
         $rspta=$gestion->ListarDeudas($idAlumno,$year);
         $data= array();
         $count=1;
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>$count++,
               "1"=>'<input title="Seleccionar" type="checkbox" class="pagos_matricula" id="'.$reg->idAlumnoPago.'">',
               "2"=>BuscarEstado($reg),
               "3"=>$reg->NombrePago,
               "4"=>"S/. ".number_format($reg->Diferencia,2),
               "5"=>'<div class="badge badge-purple" title="PAGAR" onclick="EnviarPago('.$reg->Alumno_idAlumno.','.$reg->idPago.','.$reg->year.','.$reg->Diferencia.',0,1,\''.$reg->NombrePago.'\')"><i class="fas fa-angle-double-right"></i></div>'
            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;
	 case 'ListarDeuda1A':
         $rspta=$gestion->ListarDeudasOperaciones($idAlumno,$year);
         $data= array();
         $count=1;
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>$count++,
               "1"=>BuscarEstado($reg),
               "2"=>$reg->NombrePago,
               "3"=>"S/. ".number_format($reg->Importe,2)
            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;
    case 'ListarDeuda2':
         $rspta=$gestion->ListarDeudasPensiones($idAlumno,$year);
         $data= array();
         $count=1;
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>$count++,
               "1"=>'<div  title="Seleccione">
                           <label>
                           <input type="checkbox" class="pagos_pensiones" id="'.$reg->idCuota.'" data-mora="'.(($reg->DiasMora*1)-$reg->Mora).'"  data-alumno="'.$reg->Alumno_idAlumno.'" data-pago="'.$reg->idCuota.'"  data-year="'.$reg->year.'" data-importe="'.$reg->Diferencia.' data-tipo="2" data-nombre="\'PENSIÓN'.$recursos->convertir($reg->Mes).'">
                             </label>
                     </div>',
               "2"=>BuscarEstado($reg),
               "3"=>"PENSIÓN ".($recursos->convertir($reg->Mes)),
               "4"=>"S/. ".number_format($reg->Diferencia+(($reg->DiasMora*1)-$reg->Mora),2),
               "5"=>$reg->fechaVencimiento,
               "6"=>'<div class="badge badge-purple  " title="PAGAR" onclick="EnviarPago('.$reg->Alumno_idAlumno.','.$reg->idCuota.','.$reg->year.','.$reg->Diferencia.','.(($reg->DiasMora*1)-$reg->Mora).',2,\'PENSIÓN '.$recursos->convertir($reg->Mes).'\')"><i class="fas fa-angle-double-right"></i></div>'

            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;
	 case 'ListarDeuda2A':
         $rspta=$gestion->ListarDeudasPensionesOperaciones($idAlumno,$year);
         $data= array();
         $count=1;
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>$count++,
               "1"=>BuscarEstado($reg),
               "2"=>"PENSIÓN ".($recursos->convertir($reg->Mes)),
               "3"=>"S/. ".number_format(($reg->Importe-$reg->Diferencia)+$reg->Mora,2),
               "4"=>$reg->fechaVencimiento

            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;

    case 'ListarPagar':
         $rspta=$gestion->ListarPagar($idAlumno,$year);
         $data= array();
         $count=1;
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>$count++,
               "1"=>$reg->NombrePago,
               "2"=>"S/. ".number_format($reg->ImportePago,2),
               "3"=>"<div class='badge badge-danger' onclick='EliminarPagar(".$reg->idDetallePago.",".$reg->ImportePago.",".$reg->Alumno_idAlumno.",".$reg->year.",".$reg->Cuota_idCuota.",".$reg->TipoPago_idTipoPago.",".$reg->TipoPago.")'><i class='fa fa-trash'></i></div>"
            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;

      case 'RegistrarPago':
         $rspta = array("Mensaje"=>"","Registro"=>false,"Error"=>false);

         $rspta['Registro']=$gestion->RegistrarPago($idPlan,$idAlumno,$numPago,$PagoTipoPago,$PagoTipoTarjeta,$importePago,$pago_detalle,$login_idLog);
         $rspta['Registro']?$rspta['Mensaje']="Pago Registrado.":$rspta['Mensaje']="Pago no se pudo Registrar comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

  case 'RegistrarCuota':
         $rspta = array("Mensaje"=>"","Registro"=>false,"Error"=>false);


            $rspta['Registro']=$gestion->RegistrarCuota($idPlan,$idAlumno,$idCuota,$PagoTipoPago,$PagoTipoTarjeta,$importePago,$importeBase,$importeMora,$pago_detalle,$login_idLog);
            $rspta['Registro']?$rspta['Mensaje']="Pago Registrado.":$rspta['Mensaje']="Pago no se pudo Registrar comuniquese con el area de soporte";

         echo json_encode($rspta);
      break;
     case 'RegistrarPagoP':
         $rspta = array("Mensaje"=>"","Registro"=>false,"Error"=>false);

         $rspta['Registro']=$gestion->RegistrarPagoP($idAlumnoP,$yearP,$importePago,$importeMora,$codigoPago,$TipoPago,$pagar_importe,$pagar_importe_mora,$tituloPago);
         $rspta['Registro']?$rspta['Mensaje']="Pago Registrado.":$rspta['Mensaje']="Pago no se pudo Registrar comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

		case 'RegistrarFinal':
			$rspta = array("Mensaje"=>"","Registro"=>false,"Recuperado"=>0,"Error"=>false);
			$datosVenta=$gestion->RegistrarPagoCabecera($idAlumno,$year,$final_importe_pagar,$final_importe_vuelto,$final_importe_total,$final_metodoPago,$final_tipo_tarjeta,$final_num_tarjeta,$final_cvv_tarjeta,$final_detalle);

			if($datosVenta){
				$rspta["Registro"]=true;
				$rspta["Recuperado"]=$datosVenta["idCodigo"];
				$rspta['Mensaje']="PASO";
			}else{
				$rspta["Registro"]=false;
				$rspta['Mensaje']="Se encontro inconveniente Registro Cabecera";
			}

		 echo json_encode($rspta);
		break;

		case 'RegistrarFinal2':
			$rspta = array("Mensaje"=>"","Registro"=>false,"Recuperado"=>0,"Error"=>false);

			$actualizar_pagos=$gestion->Cambios($idAlumno,$year,$idRecuperado);

			if($actualizar_pagos){
				$rspta["Registro"]=true;
				$rspta['Mensaje']="PASO";
			}else{
				$rspta["Registro"]=false;
				$rspta['Mensaje']="Se encontro inconveniente Realizar Cambios";
			}

		 echo json_encode($rspta);
		break;

     case 'RegistrarFinal3':
         $rspta = array("Mensaje"=>"","Registro"=>false,"Error"=>false);

			$datosCabecera=$gestion->RecuperarCabecera($idRecuperado,$idAlumno);
			$nombreVoucher=$datosCabecera["ReciboVoucher"];

            $cuerpo=$gestion->RecuperarDetalle($idRecuperado,$idAlumno,$year);
			GeneracionFacturaPDF($datosCabecera,$cuerpo);
			$rspta["Registro"]=$gestion->actualizar_Documento($idRecuperado,$idAlumno,$nombreVoucher.'.pdf');
			$rspta['Registro']?$rspta['Mensaje']="Pago Registrado.":$rspta['Mensaje']="Pago no se pudo Registrar comuniquese con el area de soporte";

         echo json_encode($rspta);
      break;



 case 'EliminarPagar':
         $rspta = array("Mensaje"=>"","Eliminar"=>false,"Error"=>false);

         $rspta['Eliminar']=$gestion->EliminarPagar($idPagar,$importePagar,$idAlumno,$year,$idCuota,$idMatricula,$TipoPago);
         $rspta['Eliminar']?$rspta['Mensaje']="Pago por Pagar Eliminado.":$rspta['Mensaje']="Pago por Pagar no se pudo Eliminar  comuniquese con el area de soporte";
         echo json_encode($rspta);
      break;

   case 'RegistrarVariosPagos':
         $rspta=array("Error"=>false,"Mensaje"=>"","Accion"=>false);

         $Arreglo1 = explode(',', $Arreglo1);
         $Arreglo2 = explode(',', $Arreglo2);

         $contador1=count($Arreglo1);
         $contador2=count($Arreglo2);

         if($contador1!=0){
           foreach ($Arreglo1 as &$valor) {
               $respuesta = $gestion->RecuperarInfoMatricula($valor,$idAlumno,$year);
           }
         }

         if($contador2!=0){
              foreach ($Arreglo2 as &$valor2){
               $respuesta =  $gestion->RecuperarInfoPension($valor2,$idAlumno,$year);
              }
         }

       if($respuesta){
            $rspta["Accion"]=true;
            $rspta["Mensaje"]="Pagos Agregados.";
         }else{
            $rspta["Accion"]=true;
            $rspta["Mensaje"]="Pagos Agregados.";
         }


         echo json_encode($rspta);
      break;




   case 'Recuperar_Detalle_Indicadores':
            $response=Array();

            $fechaaamostar = $fechaInicio;
            while(strtotime($fechaFin) >= strtotime($fechaInicio)){
            if(strtotime($fechaFin) != strtotime($fechaaamostar)){
                $resu=$gestion->RecuperarReporteFechas($fechaaamostar,$fechaaamostar);

                $dia=array();
                $dia["dia"]=$fechaaamostar;
                $dia["Total"]=$resu["numCuotas"];
                $dia["Pendiente"]=$resu["cuotaPend"];
                $dia["Pagada"]=$resu["cuotaPagada"];
                $dia["Vencida"]=$resu["cuotaVencida"];

                $response[]=$dia;
                $fechaaamostar = date("Y-m-d", strtotime($fechaaamostar . " + 1 day"));
            }else{
                $resu=$gestion->RecuperarReporteFechas($fechaaamostar,$fechaaamostar);
                $dia=array();
                $dia["dia"]=$fechaaamostar;
                $dia["Total"]=$resu["numCuotas"];
                $dia["Pendiente"]=$resu["cuotaPend"];
					 $dia["Pagada"]=$resu["cuotaPagada"];
					 $dia["Vencida"]=$resu["cuotaVencida"];

                $response[]=$dia;
            break;
            }
        }
            echo json_encode($response);
    break;



     case 'ListarReportes1':
         $rspta=$gestion->BuscarReporteIndicadores($fechaInicio,$fechaFin);
         $data= array();
         $count=1;
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>$count++,
               "1"=>$reg->fecha,
               "2"=>$reg->CuotaPagada,
               "3"=>$reg->CuotaTotal,
               "4"=>number_format(($reg->CuotaPagada/$reg->CuotaTotal),2)


            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;

     case 'ListarReportes2':
         $rspta=$gestion->BuscarReporteIndicadores($fechaInicio,$fechaFin);
         $data= array();
         $count=1;
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>$count++,
               "1"=>$reg->fecha,
               "2"=>$reg->CuotaVencida,
               "3"=>$reg->CuotaTotal,
               "4"=>number_format(($reg->CuotaVencida/$reg->CuotaTotal),2)


            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;

     case 'ListarReportesAlumno':
         $rspta=$gestion->BuscarReporteIndicadoresAlumno($fechaInicio,$fechaFin,$idAlumno);
         $data= array();
         $count=1;
         while ($reg=$rspta->fetch_object()){
         $data[]=array(
               "0"=>$count++,
               "1"=>BuscarEstado($reg),
               "2"=>"PENSIÓN ".($recursos->convertir($reg->Mes)),
               "3"=>"S/. ".number_format($reg->Diferencia,2),
               "4"=>$reg->DiasMora,
               "5"=>"S/. ".number_format((($reg->DiasMora*1)-$reg->Mora),2),
               "6"=>$reg->fechaVencimiento

            );
         }
         $results = array(
            "sEcho"=>1, //Información para el datatables
            "iTotalRecords"=>count($data), //enviamos el total registros al datatable
            "iTotalDisplayRecords"=>count($data), //enviamos el total registros a visualizar
            "aaData"=>$data);
         echo json_encode($results);
      break;



     case 'ActualizarPerfil':
           $rspta = array("Mensaje"=>"","Registro"=>false,"Error"=>false);

           $hasher=new PasswordHash(8,false);
           $hash=$gestion->password($idUsuario);
           $hash=$hash['pass'];

           if($UsuarioPassVerificar=='' || $UsuarioPassVerificar==null){
                $rspta["Registro"]=$gestion->actualizar_datos_perfil($idUsuario,$UsuarioCorreo,$UsuarioContacto,$UsuarioPassNuevo,1);
               $rspta["Mensaje"]="Datos del Perfil Actualizado Correctamente.";
           }else{

                if($hasher->CheckPassword($UsuarioPassVerificar,$hash)==1){

                  $UsuarioPassword = $hasher->HashPassword($UsuarioPassNuevo);
                  $rspta["Registro"]=$gestion->actualizar_datos_perfil($idUsuario,$UsuarioCorreo,$UsuarioContacto,$UsuarioPassword,2);
                  $rspta["Mensaje"]="Datos del Perfil Actualizado Correctamente.";

               }else{
                 $rspta["Registro"]=false;
                 $rspta["Mensaje"]="Contraseña anterior incorrecta";
               }
           }


         echo json_encode($rspta);
      break;

   }


?>
