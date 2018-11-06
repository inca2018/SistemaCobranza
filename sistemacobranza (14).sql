-- phpMyAdmin SQL Dump
-- version 4.7.9
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 05-11-2018 a las 07:52:34
-- Versión del servidor: 5.7.21
-- Versión de PHP: 5.6.35

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sistemacobranza`
--

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `SP_ACTUALIZAR_CUOTAS_FECHAS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ACTUALIZAR_CUOTAS_FECHAS` (IN `idAlumnoU` INT(11), IN `idCuotaU` INT(11), IN `inicio` DATE, IN `fin` DATE)  NO SQL
BEGIN 

UPDATE `cuota` SET `fechaEmision`=inicio,`fechaVencimiento`=fin,`Estado_idEstado`=5 WHERE `idCuota`=idCuotaU and `Alumno_idAlumno`=idAlumnoU;


END$$

DROP PROCEDURE IF EXISTS `SP_ACTUALIZAR_PAGOS_NUEVO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ACTUALIZAR_PAGOS_NUEVO` (IN `idAlumU` INT(11), IN `yearU` INT(11), IN `cabeceraU` INT(11))  NO SQL
BEGIN

DECLARE done INT DEFAULT FALSE;
DECLARE v_id BIGINT;
DECLARE v_tipoPago BIGINT;
DECLARE v_cuota BIGINT;

DECLARE CursorPagar CURSOR FOR 
SELECT pg.idDetallePago,pg.TipoPago_idTipoPago,pg.Cuota_idCuota FROM pagodetalle pg WHERE pg.Alumno_idAlumno=idAlumU and pg.year=yearU;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
 
open CursorPagar;
bucle: LOOP

FETCH CursorPagar into v_id,v_tipoPago,v_cuota;

IF done THEN
LEAVE bucle;
END IF;

 
UPDATE `pagodetalle` SET `Cabecera_idCabecera`=cabeceraU,`Estado_idEstado`=10 WHERE `idDetallePago`=v_id and `Alumno_idAlumno`=idAlumU and `year`=yearU and `Estado_idEstado`=9;

IF(v_tipoPago IS NULL)THEN 

    SET @Importe=(SELECT cu.Diferencia FROM cuota cu WHERE cu.Alumno_idAlumno=idAlumU and cu.year=yearU and cu.idCuota=v_cuota);

    SET @Mora=(SELECT cu.Mora FROM cuota cu WHERE cu.Alumno_idAlumno=idAlumU and cu.year=yearU and cu.idCuota=v_cuota);
    
    SET @FechaVencimiento=(SELECT cu.fechaVencimiento FROM cuota cu WHERE cu.Alumno_idAlumno=idAlumU and cu.year=yearU and cu.idCuota=v_cuota);
    
    SET @MontoMora=(((DATEDIFF(DATE_FORMAT(NOW(),"%Y-%m-%d"),@FechaVencimiento)*1)-@Mora));
      
	IF((@Importe+@MontoMora)>0) then 
            UPDATE `cuota` SET `Estado_idEstado`=6 WHERE `idCuota`=v_cuota and `Alumno_idAlumno`=idAlumU and `year`=yearU;
    ELSE 
            UPDATE `cuota` SET `Estado_idEstado`=7 WHERE `idCuota`=v_cuota and `Alumno_idAlumno`=idAlumU and `year`=yearU;
    END IF;

ELSE

    SET @Diferencia=(SELECT alu.Diferencia FROM alumnopagos alu WHERE alu.Alumno_idAlumno=idAlumU and alu.year=yearU and alu.TipoPago_idTipoPago=v_tipoPago);

    if(@Diferencia>0)then 
    UPDATE `alumnopagos` SET  `Estado_idEstado`=6 WHERE   `Alumno_idAlumno`=idAlumU and `year`=yearU and `TipoPago_idTipoPago`=v_tipoPago;
    ELSE 
    UPDATE `alumnopagos` SET  `Estado_idEstado`=7 WHERE   `Alumno_idAlumno`=idAlumU and `year`=yearU and `TipoPago_idTipoPago`=v_tipoPago;
    end if;
 
END IF;

END LOOP;
CLOSE CursorPagar;

END$$

DROP PROCEDURE IF EXISTS `SP_ACTUALIZAR_PERFIL`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ACTUALIZAR_PERFIL` (IN `idUsuarioU` INT(11), IN `CorreoE` VARCHAR(150), IN `ContactoE` VARCHAR(150), IN `PassE` VARCHAR(150), IN `accion` INT(11))  NO SQL
BEGIN 

IF(CorreoE='0')THEN
SET CorreoE=NULL; 
end if;

IF(ContactoE='0')THEN
SET ContactoE=NULL; 
end if;


IF(accion=2)then 
UPDATE `usuario` SET  `pass`=PassE  WHERE `idUsuario`=idUsuarioU;    
end if;
 

set @idPersonaE=(SELECT p.idPersona FROM usuario u INNER JOIN persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=idUsuarioU);

UPDATE `persona` SET  `correo`=CorreoE,`telefono`=ContactoE WHERE `idPersona`=@idPersonaE;

END$$

DROP PROCEDURE IF EXISTS `SP_AGREGAR_TIPOPAGO_ALUMNO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AGREGAR_TIPOPAGO_ALUMNO` (IN `idPagoControl` INT(11), IN `idAlumnoE` INT(11), IN `yearE` INT(11))  NO SQL
BEGIN
DECLARE Importe DECIMAL(10,2);

SET Importe=(SELECT ge.Monto FROM generalimportes ge WHERE ge.idGeneral=idPagoControl);   

 
INSERT INTO `alumnopagos`(`idAlumnoPago`, `Alumno_idAlumno`,`year`, `TipoPago_idTipoPago`,`Importe`,`Diferencia`,`Mora`,`Estado_idEstado`,`fechaRegistro`) 	VALUES (NULL,idAlumnoE,yearE,idPagoControl,Importe,Importe,0,5,NOW());
   
END$$

DROP PROCEDURE IF EXISTS `SP_ALUMNO_ACTUALIZAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ALUMNO_ACTUALIZAR` (IN `nombre` VARCHAR(100), IN `apellidoP` VARCHAR(100), IN `apellidoM` VARCHAR(100), IN `DNI` INT(10), IN `fechaNacimiento` DATE, IN `correo` VARCHAR(100), IN `telefono` INT(10), IN `Direccion` TEXT, IN `estado` INT(11), IN `imagenU` VARCHAR(150), IN `idPersonaU` INT(11), IN `idAlumnoU` INT(11), IN `creador` INT(11))  NO SQL
BEGIN 

 
if(correo='0')then 
SET correo=null;
end if;
if(telefono='0')then 
SET telefono=null;
end if;
if(Direccion='0')then 
SET Direccion=null;
end if; 

   
UPDATE `persona` SET `nombrePersona`=UPPER(nombre),`apellidoPaterno`=UPPER(apellidoP),`apellidoMaterno`=UPPER(apellidoM),`DNI`=DNI,`fechaNacimiento`=fechaNacimiento,`correo`=UPPER(correo),`telefono`=telefono,`direccion`=UPPER(Direccion),`Estado_idEstado`=estado WHERE `idPersona`=idPersonaU;


if(imagenU!='0')then 
UPDATE `alumno` SET `imagen`=imagenU WHERE `idAlumno`=idAlumnoU;
end if; 

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=creador);
 
INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ACTUALIZACION','Alumno',CONCAT('SE ACTUALIZO Alumno:',nombre,' ',apellidoP,' ',apellidoM),NOW());
END$$

DROP PROCEDURE IF EXISTS `SP_ALUMNO_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ALUMNO_LISTAR` ()  NO SQL
BEGIN 

SELECT 
al.imagen as fotoAlumno,
p.idPersona,al.idAlumno,CONCAT(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombrePersona,p.DNI,p.fechaRegistro,e.idEstado as Estado_idEstado,e.nombreEstado,DATE_FORMAT(p.fechaNacimiento,"%d/%m/%Y") as FechaNacimiento
FROM persona p INNER JOIN alumno al ON al.Persona_idPersona=p.idPersona INNER JOIN estado e ON e.idEstado=p.Estado_idEstado ; 


END$$

DROP PROCEDURE IF EXISTS `SP_ALUMNO_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ALUMNO_RECUPERAR` (IN `idPersonaE` INT(11), IN `idAlumnoE` INT(11))  NO SQL
BEGIN 

SELECT
 p.idPersona,al.idAlumno,p.nombrePersona,p.apellidoPaterno,p.apellidoMaterno,p.DNI,p.fechaRegistro,p.fechaNacimiento,p.correo,p.telefono,p.direccion,e.idEstado as Estado_idEstado,e.nombreEstado FROM persona p INNER JOIN alumno al ON al.Persona_idPersona=p.idPersona INNER JOIN estado e ON e.idEstado=p.Estado_idEstado
WHERE p.idPersona=idPersonaE and al.idAlumno=idAlumnoE;  
  

END$$

DROP PROCEDURE IF EXISTS `SP_ALUMNO_REGISTRO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ALUMNO_REGISTRO` (IN `nombre` VARCHAR(100), IN `apellidoP` VARCHAR(100), IN `apellidoM` VARCHAR(100), IN `DNI` INT(11), IN `fechaNacimiento` DATE, IN `correo` VARCHAR(100), IN `telefono` INT, IN `Direccion` TEXT, IN `estado` INT(11), IN `imagen` VARCHAR(150), IN `creador` INT(11))  NO SQL
BEGIN 

DECLARE idPersonaNew INT(11);

if(correo='0')THEN
SET correo=null;
end if;
if(telefono='0')THEN
SET telefono=null;
end if;
if(Direccion='0')THEN
SET Direccion=null;
end if;


INSERT INTO `persona`(`idPersona`, `nombrePersona`, `apellidoPaterno`, `apellidoMaterno`, `DNI`, `fechaNacimiento`, `correo`, `telefono`, `direccion`, `Estado_idEstado`, `fechaRegistro`) VALUES (NULL,UPPER(nombre),UPPER(apellidoP),UPPER(apellidoM),DNI,fechaNacimiento,UPPER(correo),telefono,UPPER(Direccion),estado,NOW());

 
SET idPersonaNew=(SELECT LAST_INSERT_ID());

if(imagen='0')THEN
 INSERT INTO `alumno`(`idAlumno`, `Persona_idPersona`, `Nivel_idNivel`, `Grado_idGrado`, `Seccion_idSeccion`, `fechaRegistro`) VALUES (NULL,idPersonaNew,NULL,NULL,NULL,NOW());
ELSE 
INSERT INTO `alumno`(`idAlumno`, `imagen`, `Persona_idPersona`, `Nivel_idNivel`, `Grado_idGrado`, `Seccion_idSeccion`, `fechaRegistro`) VALUES (NULL,imagen,idPersonaNew,NULL,NULL,NULL,NOW());
end if;



/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=creador);  

 
INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'REGISTRO','Alumno',CONCAT('SE REGISTRO PERSONA:',nombre,' ',apellidoP,' ',apellidoM," COMO ALUMNO NUEVO"),NOW());


END$$

DROP PROCEDURE IF EXISTS `SP_APODERADO_ACTUALIZAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_APODERADO_ACTUALIZAR` (IN `nombre` VARCHAR(100), IN `apellidoP` VARCHAR(100), IN `apellidoM` VARCHAR(100), IN `DNI` INT(10), IN `fechaNacimiento` DATE, IN `correo` VARCHAR(100), IN `telefono` INT(10), IN `Direccion` TEXT, IN `estado` INT(11), IN `TipoTarjetaU` INT(11), IN `DetalleU` VARCHAR(150), IN `idPersonau` INT(11), IN `IdApoderadoU` INT(11), IN `creador` INT(11))  NO SQL
BEGIN  
if(correo='0')then 
SET correo=null;
end if;
if(telefono='0')then 
SET telefono=null;
end if;
if(Direccion='0')then 
SET Direccion=null;
end if; 
if(TipoTarjetaU='0')then 
SET TipoTarjetaU=null;
end if; 
if(DetalleU='0')then 
SET DetalleU=null;
end if; 

   
UPDATE `persona` SET `nombrePersona`=UPPER(nombre),`apellidoPaterno`=UPPER(apellidoP),`apellidoMaterno`=UPPER(apellidoM),`DNI`=DNI,`fechaNacimiento`=fechaNacimiento,`correo`=UPPER(correo),`telefono`=telefono,`direccion`=UPPER(Direccion),`Estado_idEstado`=estado WHERE `idPersona`=idPersonaU;

UPDATE `apoderado` SET  `TipoTarjeta_idTipoTarjeta`=TipoTarjetaU,`Detalle`=DetalleU WHERE `idApoderado`=IdApoderadoU;

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=creador);
 
INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ACTUALIZACION','Apoderado',CONCAT('SE ACTUALIZO Apoderado:',nombre,' ',apellidoP,' ',apellidoM),NOW());
END$$

DROP PROCEDURE IF EXISTS `SP_APODERADO_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_APODERADO_LISTAR` ()  NO SQL
BEGIN 

SELECT p.idPersona,apo.idApoderado,concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombrePersona,p.DNI,p.Estado_idEstado,e.nombreEstado,p.fechaRegistro,IFNULL(tip.Descripcion,'-') AS TipoTarjeta,IFNULL(apo.Detalle,'-') AS Detalle FROM persona p
INNER JOIN apoderado apo ON apo.Persona_idPersona=p.idPersona
INNER JOIN estado e ON e.idEstado=p.Estado_idEstado  
LEFT JOIN tipotarjeta tip ON tip.idTipoTarjeta=apo.TipoTarjeta_idTipoTarjeta; 
END$$

DROP PROCEDURE IF EXISTS `SP_APODERADO_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_APODERADO_RECUPERAR` (IN `idPersonaU` INT(11), IN `idApoderadoU` INT(11))  NO SQL
BEGIN 



SELECT p.idPersona,apo.idApoderado, P.nombrePersona,P.apellidoPaterno,P.apellidoMaterno,P.fechaNacimiento,p.correo,p.telefono,p.direccion,tip.idTipoTarjeta,p.DNI,p.Estado_idEstado,e.nombreEstado,p.fechaRegistro,IFNULL(tip.Descripcion,'-') AS TipoTarjeta,apo.Detalle FROM persona p
INNER JOIN apoderado apo ON apo.Persona_idPersona=p.idPersona
INNER JOIN estado e ON e.idEstado=p.Estado_idEstado  
LEFT JOIN tipotarjeta tip ON tip.idTipoTarjeta=apo.TipoTarjeta_idTipoTarjeta where p.idPersona=idPersonaU and apo.idApoderado=idApoderadoU;

END$$

DROP PROCEDURE IF EXISTS `SP_APODERADO_REGISTRO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_APODERADO_REGISTRO` (IN `nombre` VARCHAR(100), IN `apellidoP` VARCHAR(100), IN `apellidoM` VARCHAR(100), IN `DNI` INT(10), IN `fechaNacimiento` DATE, IN `correo` VARCHAR(100), IN `telefono` INT(10), IN `Direccion` TEXT, IN `estado` INT(11), IN `TipoTarjetaE` INT(11), IN `DetalleE` VARCHAR(150), IN `creador` INT(11))  NO SQL
BEGIN 

DECLARE idPersonaNew INT(11);

if(correo='0')THEN
SET correo=null;
end if;
if(telefono='0')THEN
SET telefono=null;
end if;
if(Direccion='0')THEN
SET Direccion=null;
end if;
if(TipoTarjetaE='0')THEN
SET TipoTarjetaE=null;
end if;
if(DetalleE='0')THEN
SET DetalleE=null;
end if;
 
INSERT INTO `persona`(`idPersona`, `nombrePersona`, `apellidoPaterno`, `apellidoMaterno`, `DNI`, `fechaNacimiento`, `correo`, `telefono`, `direccion`, `Estado_idEstado`, `fechaRegistro`) VALUES (NULL,UPPER(nombre),UPPER(apellidoP),UPPER(apellidoM),DNI,fechaNacimiento,UPPER(correo),telefono,UPPER(Direccion),estado,NOW());

 
SET idPersonaNew=(SELECT LAST_INSERT_ID());


INSERT INTO `apoderado`(`idApoderado`, `Persona_idPersona`, `TipoTarjeta_idTipoTarjeta`, `Detalle`, `fechaRegistro`) VALUES (NULL,idPersonaNew,TipoTarjetaE,DetalleE,NOW());

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=creador);  

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'REGISTRO','Persona',CONCAT('SE REGISTRO APODERADO:',nombre,' ',apellidoP,' ',apellidoM),NOW());

 
END$$

DROP PROCEDURE IF EXISTS `SP_CUOTAS_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CUOTAS_LISTAR` (IN `idAlumnoU` INT(11))  NO SQL
BEGIN


SELECT cu.idCuota, cu.Estado_idEstado,e.nombreEstado,cu.Importe,cu.Diferencia,IFNULL(cu.fechaEmision,'-') as fechaEmision ,IFNULL(cu.fechaVencimiento,'-') as fechaVencimiento FROM alumno al INNER JOIN cuota cu 
ON cu.Alumno_idAlumno=al.idAlumno
INNER JOIN estado e ON e.idEstado=cu.Estado_idEstado
WHERE CU.Alumno_idAlumno=idAlumnoU; 
  
END$$

DROP PROCEDURE IF EXISTS `SP_CUOTA_AGREGAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CUOTA_AGREGAR` (IN `idALumnoU` INT(11), IN `Cantidad` INT(11), IN `creador` INT(11))  NO SQL
BEGIN 

DECLARE contador INT(11);
 
SET contador=0;

WHILE contador<Cantidad DO
 
INSERT INTO `cuota`(`idCuota`,`Alumno_idAlumno`, `PlanPago_idPlanPago`, `Importe`, `Diferencia`,`Mora`, `fechaEmision`, `fechaVencimiento`, `Estado_idEstado`) VALUES (NULL,idALumnoU,NULL,200,200,0,NULL,NULL,2);  
  
 SET contador=contador+1;
 END WHILE;  

 

END$$

DROP PROCEDURE IF EXISTS `SP_CUOTA_ANULAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CUOTA_ANULAR` (IN `idCuotaU` INT(11), IN `codigo` INT(11), IN `creador` INT(11))  NO SQL
BEGIN 

if(codigo=1) then 
UPDATE `cuota` SET `Estado_idEstado`=8 WHERE `idCuota`=idCuotaU;
ELSE
UPDATE `cuota` SET `Estado_idEstado`=5 WHERE `idCuota`=idCuotaU;
end if;


 /* ------ REGISTRO DE BITACORA ------ */

set @usuario=(SELECT u.usuario FROM usuario u  WHERE u.idUsuario=creador);
 

INSERT INTO `bitacora`(`usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (@usuario,"CUOTA ANULADA",'CUOTA',CONCAT("COUTA ANULADA :", idCuotaU),NOW());     
 
END$$

DROP PROCEDURE IF EXISTS `SP_CUOTA_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CUOTA_LISTAR` (IN `idPlanPagoU` INT(11))  NO SQL
BEGIN 

SELECT * FROM cuota c WHERE c.PlanPago_idPlanPago=idPlanPagoU;


END$$

DROP PROCEDURE IF EXISTS `SP_ESTADO_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ESTADO_LISTAR` (IN `Tipo` INT(11))  NO SQL
BEGIN 

Select * FROM estado e WHERE e.tipoEstado=Tipo;

END$$

DROP PROCEDURE IF EXISTS `SP_GRADO_ACTUALIZAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GRADO_ACTUALIZAR` (IN `descri` VARCHAR(100), IN `estado` INT(11), IN `idGradoE` INT(11), IN `creador` INT(11))  NO SQL
BEGIN 

UPDATE `grado` SET `Descripcion`=UPPER(descri), `Estado_idEstado`=estado WHERE `idGrado`=idGradoE; 

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT u.usuario FROM usuario u WHERE u.idUsuario=creador);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ACTUALIZACION','GRADO',CONCAt("SE ACTUALIZO GRADO:",descri),NOW());    
END$$

DROP PROCEDURE IF EXISTS `SP_GRADO_HABILITACION`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GRADO_HABILITACION` (IN `idGradoE` INT(11), IN `codigo` INT(11), IN `creador` INT(11))  NO SQL
BEGIN 

if (codigo=1) then 
  
    UPDATE `grado` SET `Estado_idEstado`=4  WHERE `idGrado`=idGradoE;
  SET @Mensaje=("GRADO DESHABILITADO");
else 
   UPDATE `grado` SET `Estado_idEstado`=1  WHERE `idGrado`=idGradoE;    
 SET  @Mensaje=("GRADO HABILITADO");   
end if;

 /* ------ REGISTRO DE BITACORA ------ */

set @usuario=(SELECT u.usuario FROM usuario u  WHERE u.idUsuario=creador);

set @tipotar=(SELECT g.Descripcion FROM grado g WHERE g.idGrado=idGradoE);

INSERT INTO `bitacora`(`usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (@usuario,@Mensaje,'GRADO',CONCAT(@Mensaje," :", @tipotar),NOW());     
 
END$$

DROP PROCEDURE IF EXISTS `SP_GRADO_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GRADO_LISTAR` ()  NO SQL
BEGIN

SELECT * FROM grado gra INNER JOIN estado e ON e.idEstado=gra.Estado_idEstado;
END$$

DROP PROCEDURE IF EXISTS `SP_GRADO_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GRADO_RECUPERAR` (IN `idGradoE` INT(11))  NO SQL
BEGIN 

SELECT * FROM grado g WHERE g.idGrado=idGradoE;

END$$

DROP PROCEDURE IF EXISTS `SP_GRADO_REGISTRO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GRADO_REGISTRO` (IN `descri` VARCHAR(100), IN `estado` INT(11), IN `creador` INT(11))  NO SQL
BEGIN 

-- REGISTRAR TIPO DE TARJETA --
INSERT INTO `grado`(`idGrado`, `Descripcion`, `fechaRegistro`, `Estado_idEstado`) VALUES (NULL,UPPER(descri),NOW(),estado);
 

SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=creador);


INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'INSERTAR','SE REGISTRO GRADO','GRADO',NOW()); 

END$$

DROP PROCEDURE IF EXISTS `SP_INDICADORES_ALUMNO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_INDICADORES_ALUMNO` (OUT `numCuotas` INT(11), OUT `cuotaPend` INT(11), OUT `cuotaPagada` INT(11), OUT `cuotaVencida` INT(11), IN `idAlumnoU` INT(11))  NO SQL
BEGIN 


SET numCuotas=(SELECT COUNT(cu.idCuota) FROM alumno al INNER JOIN cuota cu On cu.Alumno_idAlumno=al.idAlumno WHERE al.idAlumno=idAlumnoU);

SET cuotaPend=(SELECT COUNT(cu.idCuota) FROM alumno al INNER JOIN cuota cu On cu.Alumno_idAlumno=al.idAlumno WHERE al.idAlumno=idAlumnoU and (cu.Estado_idEstado=5 or cu.Estado_idEstado=6));

SET cuotaPagada=(SELECT COUNT(cu.idCuota) FROM alumno al INNER JOIN cuota cu On cu.Alumno_idAlumno=al.idAlumno WHERE al.idAlumno=idAlumnoU and cu.Estado_idEstado=7);

SET cuotaVencida=(SELECT COUNT(cu.idCuota) FROM alumno al INNER JOIN cuota cu On cu.Alumno_idAlumno=al.idAlumno WHERE al.idAlumno=idAlumnoU and DATE_FORMAT(NOW(),"%Y-%m-%d")>DATE_FORMAT(cu.fechaVencimiento,"%Y-%m-%d"));

 

END$$

DROP PROCEDURE IF EXISTS `SP_INDICADORES_FECHAS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_INDICADORES_FECHAS` (OUT `numCuotas` INT(11), OUT `cuotaPend` INT(11), OUT `cuotaPagada` INT(11), OUT `cuotaVencida` INT(11), IN `inicio` DATE, IN `fin` DATE)  NO SQL
BEGIN 


SET numCuotas=(SELECT COUNT(cu.idCuota) FROM alumno al INNER JOIN cuota cu On cu.Alumno_idAlumno=al.idAlumno WHERE   cu.fechaEmision BETWEEN inicio AND fin);

SET cuotaPend=(SELECT COUNT(cu.idCuota) FROM alumno al INNER JOIN cuota cu On cu.Alumno_idAlumno=al.idAlumno WHERE   (cu.Estado_idEstado=5 or cu.Estado_idEstado=6) and cu.fechaEmision BETWEEN inicio AND fin);

SET cuotaPagada=(SELECT COUNT(cu.idCuota) FROM alumno al INNER JOIN cuota cu On cu.Alumno_idAlumno=al.idAlumno WHERE   cu.Estado_idEstado=7 and  cu.fechaEmision BETWEEN inicio AND fin);

SET cuotaVencida=(SELECT COUNT(cu.idCuota) FROM alumno al INNER JOIN cuota cu On cu.Alumno_idAlumno=al.idAlumno WHERE DATE_FORMAT(NOW(),"%Y-%m-%d")>DATE_FORMAT(cu.fechaVencimiento,"%Y-%m-%d") and  cu.fechaEmision BETWEEN inicio AND fin);

 

END$$

DROP PROCEDURE IF EXISTS `SP_LISTAR_GRADOS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_GRADOS` ()  NO SQL
BEGIN 

SELECT * from grado g WHERE g.Estado_idEstado=1 OR g.Estado_idEstado=3; 

END$$

DROP PROCEDURE IF EXISTS `SP_LISTAR_NIVELES`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_NIVELES` ()  NO SQL
BEGIN 

SELECT * FROM nivel n WHERE n.Estado_idEstado=1 or n.Estado_idEstado=3;

END$$

DROP PROCEDURE IF EXISTS `SP_LISTAR_PERFILES`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_PERFILES` ()  NO SQL
BEGIN 

SELECT * FROM perfil p WHERE p.Estado_idEstado=1 or p.Estado_idEstado=3;

END$$

DROP PROCEDURE IF EXISTS `SP_LISTAR_SECCIONES`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_SECCIONES` ()  NO SQL
BEGIN 

SELECT * FROM seccion s WHERE s.Estado_idEstado=1 or s.Estado_idEstado=3;

END$$

DROP PROCEDURE IF EXISTS `SP_LOGIN_REGISTRO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LOGIN_REGISTRO` (IN `idUsuario` INT(11), IN `usuario` VARCHAR(100), IN `passwordLog` TEXT, IN `perfil` VARCHAR(100))  NO SQL
BEGIN


INSERT INTO `login`(`idLogin`, `Usuario_idUsuario`, `usuarioLog`, `passwordLog`, `perfilLog`, `fechaLog`) VALUES (null,idUsuario,usuario,passwordLog,perfil,NOW());


END$$

DROP PROCEDURE IF EXISTS `SP_MATRICULAR_RECUPEAR_PAGOS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MATRICULAR_RECUPEAR_PAGOS` (IN `idAlumnoE` INT(11), IN `yearU` INT(11))  NO SQL
BEGIN 

SELECT alu.TipoPago_idTipoPago,IF((alu.Importe-alu.Diferencia)=0,'NO','SI') as Pagado FROM alumno al INNER JOIN alumnopagos alu ON alu.Alumno_idAlumno=Al.idAlumno INNER JOIN generalimportes ge ON ge.idGeneral=alu.TipoPago_idTipoPago GROUP BY alu.TipoPago_idTipoPago;
 
END$$

DROP PROCEDURE IF EXISTS `SP_MATRICULA_ACTUALIZAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MATRICULA_ACTUALIZAR` (IN `idPersonaR` INT(11), IN `idAlumnoR` INT(11), IN `yearR` INT(11), IN `nivelR` INT(11), IN `gradoR` INT(11), IN `seccionR` INT(11))  NO SQL
BEGIN 
 

UPDATE `matricula` SET `Nivel_idNivel`=nivelR ,`Grado_idGrado`=gradoR ,`Seccion_idSeccion`=seccionR  WHERE  `Alumno_idAlumno`=idAlumnoR and `year`=yearR;

END$$

DROP PROCEDURE IF EXISTS `SP_MATRICULA_AGREGAR_PENSIONES1`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MATRICULA_AGREGAR_PENSIONES1` (IN `idPersonaU` INT(11), IN `idAlumnoU` INT(11), IN `yearU` INT(11))  NO SQL
BEGIN 
DECLARE Pagos INT(11);
DECLARE Mensaje VARCHAR(150); 

SET Pagos=(SELECT COUNT(*) FROM cuota cu WHERE cu.Alumno_idAlumno=idAlumnoU and cu.year=yearU and (cu.Estado_idEstado=6 or cu.Estado_idEstado=8));

if(Pagos>0)THEN
SET Mensaje=CONCAT("SE ENCONTRO ",Pagos," REALIZADOS.");
else 

DELETE FROM cuota WHERE Alumno_idAlumno=idAlumnoU and year=yearU;

INSERT INTO `cuota`(`idCuota`, `Alumno_idAlumno`, `PlanPago_idPlanPago`, `Importe`, `Diferencia`, `Mora`, `year`, `Mes`, `fechaEmision`, `fechaVencimiento`, `Estado_idEstado`) VALUES (NULL,idAlumnoU,NULL,200.00,200.00,0.00,yearU,3,CONCAT(yearU,'-0',3,'-01'),CONCAT(yearU,'-0',3,'-30'),5);

INSERT INTO `cuota`(`idCuota`, `Alumno_idAlumno`, `PlanPago_idPlanPago`, `Importe`, `Diferencia`, `Mora`, `year`, `Mes`, `fechaEmision`, `fechaVencimiento`, `Estado_idEstado`) VALUES (NULL,idAlumnoU,NULL,200.00,200.00,0.00,yearU,4,CONCAT(yearU,'-0',4,'-01'),CONCAT(yearU,'-0',4,'-30'),5);

INSERT INTO `cuota`(`idCuota`, `Alumno_idAlumno`, `PlanPago_idPlanPago`, `Importe`, `Diferencia`, `Mora`, `year`, `Mes`, `fechaEmision`, `fechaVencimiento`, `Estado_idEstado`) VALUES (NULL,idAlumnoU,NULL,200.00,200.00,0.00,yearU,5,CONCAT(yearU,'-0',5,'-01'),CONCAT(yearU,'-0',5,'-30'),5);

INSERT INTO `cuota`(`idCuota`, `Alumno_idAlumno`, `PlanPago_idPlanPago`, `Importe`, `Diferencia`, `Mora`, `year`, `Mes`, `fechaEmision`, `fechaVencimiento`, `Estado_idEstado`) VALUES (NULL,idAlumnoU,NULL,200.00,200.00,0.00,yearU,6,CONCAT(yearU,'-0',6,'-01'),CONCAT(yearU,'-0',6,'-30'),5);

INSERT INTO `cuota`(`idCuota`, `Alumno_idAlumno`, `PlanPago_idPlanPago`, `Importe`, `Diferencia`, `Mora`, `year`, `Mes`, `fechaEmision`, `fechaVencimiento`, `Estado_idEstado`) VALUES (NULL,idAlumnoU,NULL,200.00,200.00,0.00,yearU,7,CONCAT(yearU,'-0',7,'-01'),CONCAT(yearU,'-0',7,'-30'),5);

INSERT INTO `cuota`(`idCuota`, `Alumno_idAlumno`, `PlanPago_idPlanPago`, `Importe`, `Diferencia`, `Mora`, `year`, `Mes`, `fechaEmision`, `fechaVencimiento`, `Estado_idEstado`) VALUES (NULL,idAlumnoU,NULL,200.00,200.00,0.00,yearU,8,CONCAT(yearU,'-0',8,'-01'),CONCAT(yearU,'-0',8,'-30'),5);

INSERT INTO `cuota`(`idCuota`, `Alumno_idAlumno`, `PlanPago_idPlanPago`, `Importe`, `Diferencia`, `Mora`, `year`, `Mes`, `fechaEmision`, `fechaVencimiento`, `Estado_idEstado`) VALUES (NULL,idAlumnoU,NULL,200.00,200.00,0.00,yearU,9,CONCAT(yearU,'-0',9,'-01'),CONCAT(yearU,'-0',9,'-30'),5);

INSERT INTO `cuota`(`idCuota`, `Alumno_idAlumno`, `PlanPago_idPlanPago`, `Importe`, `Diferencia`, `Mora`, `year`, `Mes`, `fechaEmision`, `fechaVencimiento`, `Estado_idEstado`) VALUES (NULL,idAlumnoU,NULL,200.00,200.00,0.00,yearU,10,CONCAT(yearU,'-',10,'-01'),CONCAT(yearU,'-',10,'-30'),5);

INSERT INTO `cuota`(`idCuota`, `Alumno_idAlumno`, `PlanPago_idPlanPago`, `Importe`, `Diferencia`, `Mora`, `year`, `Mes`, `fechaEmision`, `fechaVencimiento`, `Estado_idEstado`) VALUES (NULL,idAlumnoU,NULL,200.00,200.00,0.00,yearU,11,CONCAT(yearU,'-',11,'-01'),CONCAT(yearU,'-',11,'-30'),5);

INSERT INTO `cuota`(`idCuota`, `Alumno_idAlumno`, `PlanPago_idPlanPago`, `Importe`, `Diferencia`, `Mora`, `year`, `Mes`, `fechaEmision`, `fechaVencimiento`, `Estado_idEstado`) VALUES (NULL,idAlumnoU,NULL,200.00,200.00,0.00,yearU,12,CONCAT(yearU,'-',12,'-01'),CONCAT(yearU,'-',12,'-30'),5);

 

SET Mensaje=CONCAT("SE ENCONTRO ",Pagos," REALIZADOS.");
end if;

SELECT Pagos,Mensaje;



    

END$$

DROP PROCEDURE IF EXISTS `SP_MATRICULA_AGREGAR_PENSIONES2`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MATRICULA_AGREGAR_PENSIONES2` (IN `idPersonaU` INT(11), IN `idAlumnoU` INT(11), IN `yearU` INT(11))  NO SQL
BEGIN 
DECLARE Pagos INT(11);
DECLARE Mensaje VARCHAR(150); 

SET Pagos=(SELECT COUNT(*) FROM cuota cu WHERE cu.Alumno_idAlumno=idAlumnoU and cu.year=yearU and (cu.Estado_idEstado=6 or cu.Estado_idEstado=8));

if(Pagos>0)THEN
SET Mensaje=CONCAT("SE ENCONTRO ",Pagos," REALIZADOS.");
else 

DELETE FROM cuota WHERE Alumno_idAlumno=idAlumnoU and year=yearU;
 
INSERT INTO `cuota`(`idCuota`, `Alumno_idAlumno`, `PlanPago_idPlanPago`, `Importe`, `Diferencia`, `Mora`, `year`, `Mes`, `fechaEmision`, `fechaVencimiento`, `Estado_idEstado`) VALUES (NULL,idAlumnoU,NULL,200.00,200.00,0.00,yearU,7,CONCAT(yearU,'-0',7,'-01'),CONCAT(yearU,'-0',7,'-30'),5);

INSERT INTO `cuota`(`idCuota`, `Alumno_idAlumno`, `PlanPago_idPlanPago`, `Importe`, `Diferencia`, `Mora`, `year`, `Mes`, `fechaEmision`, `fechaVencimiento`, `Estado_idEstado`) VALUES (NULL,idAlumnoU,NULL,200.00,200.00,0.00,yearU,8,CONCAT(yearU,'-0',8,'-01'),CONCAT(yearU,'-0',8,'-30'),5);

INSERT INTO `cuota`(`idCuota`, `Alumno_idAlumno`, `PlanPago_idPlanPago`, `Importe`, `Diferencia`, `Mora`, `year`, `Mes`, `fechaEmision`, `fechaVencimiento`, `Estado_idEstado`) VALUES (NULL,idAlumnoU,NULL,200.00,200.00,0.00,yearU,9,CONCAT(yearU,'-0',9,'-01'),CONCAT(yearU,'-0',9,'-30'),5);

INSERT INTO `cuota`(`idCuota`, `Alumno_idAlumno`, `PlanPago_idPlanPago`, `Importe`, `Diferencia`, `Mora`, `year`, `Mes`, `fechaEmision`, `fechaVencimiento`, `Estado_idEstado`) VALUES (NULL,idAlumnoU,NULL,200.00,200.00,0.00,yearU,10,CONCAT(yearU,'-',10,'-01'),CONCAT(yearU,'-',10,'-30'),5);

INSERT INTO `cuota`(`idCuota`, `Alumno_idAlumno`, `PlanPago_idPlanPago`, `Importe`, `Diferencia`, `Mora`, `year`, `Mes`, `fechaEmision`, `fechaVencimiento`, `Estado_idEstado`) VALUES (NULL,idAlumnoU,NULL,200.00,200.00,0.00,yearU,11,CONCAT(yearU,'-',11,'-01'),CONCAT(yearU,'-',11,'-30'),5);

INSERT INTO `cuota`(`idCuota`, `Alumno_idAlumno`, `PlanPago_idPlanPago`, `Importe`, `Diferencia`, `Mora`, `year`, `Mes`, `fechaEmision`, `fechaVencimiento`, `Estado_idEstado`) VALUES (NULL,idAlumnoU,NULL,200.00,200.00,0.00,yearU,12,CONCAT(yearU,'-',12,'-01'),CONCAT(yearU,'-',12,'-30'),5);
 

SET Mensaje=CONCAT("SE ENCONTRO ",Pagos," REALIZADOS.");
end if;

SELECT Pagos,Mensaje;

 
END$$

DROP PROCEDURE IF EXISTS `SP_MATRICULA_ALUMNO_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MATRICULA_ALUMNO_RECUPERAR` (IN `idPersonaE` INT(11), IN `idAlumnoE` INT(11), IN `yearE` INT(11))  NO SQL
BEGIN 

SELECT
 p.idPersona,al.idAlumno,p.nombrePersona,p.apellidoPaterno,p.apellidoMaterno,p.DNI,p.fechaRegistro,p.fechaNacimiento,p.correo,p.telefono,p.direccion,e.idEstado as Estado_idEstado,e.nombreEstado,
 IF((SELECT COUNT(*) FROM alumno alu LEFT JOIN matricula mm ON mm.Alumno_idAlumno=alu.idAlumno WHERE alu.idAlumno=idAlumnoE and mm.year=yearE)>0,1,0) as Matricula,
 ni.idNivel as Nivel,
 gra.idGrado as Grado,
 sec.idSeccion as Seccion,
 (SELECT COUNT(*) FROM alumno alu INNER JOIN cuota cu ON cu.Alumno_idAlumno=alu.idAlumno WHERE alu.idAlumno=al.idAlumno and cu.year=yearE) as CantidadCuotas
 FROM persona p INNER JOIN alumno al ON al.Persona_idPersona=p.idPersona INNER JOIN estado e ON e.idEstado=p.Estado_idEstado LEFT JOIN matricula ma ON ma.Alumno_idAlumno=al.idAlumno LEFT JOIN nivel ni ON ni.idNivel=ma.Nivel_idNivel LEFT JOIN grado gra ON gra.idGrado=ma.Grado_idGrado LEFT JOIN seccion sec ON sec.idSeccion=ma.Seccion_idSeccion
WHERE p.idPersona=idPersonaE and al.idAlumno=idAlumnoE;  
  
END$$

DROP PROCEDURE IF EXISTS `SP_MATRICULA_LIMPIAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MATRICULA_LIMPIAR` (IN `idPersonaU` INT(11), IN `idAlumnoU` INT(11), IN `yearU` INT(11))  NO SQL
BEGIN 
DECLARE Pagos INT(11);
DECLARE Mensaje VARCHAR(150); 

SET Pagos=(SELECT COUNT(*) FROM cuota cu WHERE cu.Alumno_idAlumno=idAlumnoU and cu.year=yearU and (cu.Estado_idEstado=6 or cu.Estado_idEstado=8));

if(Pagos>0)THEN
SET Mensaje=CONCAT("SE ENCONTRO ",Pagos," REALIZADOS.");
else 
DELETE FROM cuota WHERE Alumno_idAlumno=idAlumnoU and year=yearU;
SET Mensaje=CONCAT("SE ENCONTRO ",Pagos," REALIZADOS.");
end if;

SELECT Pagos,Mensaje;

END$$

DROP PROCEDURE IF EXISTS `SP_MATRICULA_LISTAR_CUOTAS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MATRICULA_LISTAR_CUOTAS` (IN `idPersonaU` INT(11), IN `idAlumnoU` INT(11), IN `yearU` INT(11))  NO SQL
BEGIN 

SELECT cu.Importe,cu.Diferencia,cu.Mora,cu.Mes,cu.year,cu.Mes,DATE_FORMAT(cu.fechaEmision,"%d/%m/%Y") as FechaEmision,DATE_FORMAT(cu.fechaVencimiento,"%d/%m/%Y") as FechaVencimiento,cu.Estado_idEstado,e.nombreEstado FROM alumno al INNER JOIN cuota cu ON cu.Alumno_idAlumno=al.idAlumno INNER JOIN estado e ON e.idEstado=cu.Estado_idEstado WHERE cu.year=yearU and cu.Alumno_idAlumno=idAlumnoU;

END$$

DROP PROCEDURE IF EXISTS `SP_MATRICULA_LISTAR_MATRICULADOS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MATRICULA_LISTAR_MATRICULADOS` (IN `yearM` INT(4))  NO SQL
BEGIN 

SELECT al.imagen,al.idAlumno,per.idPersona,CONCAT(per.nombrePersona,' ',per.apellidoPaterno,' ',per.apellidoMaterno) AS AlumnoNombres,per.DNI,DATE_FORMAT(per.fechaNacimiento,"%d/%m/%Y") as FechaNacimiento,IF((SELECT COUNT(*) FROM matricula m WHERE m.Alumno_idAlumno=al.idAlumno and m.year=yearM)>0,"MATRICULADO","SIN MATRICULA") as EstadoMatricula FROM alumno al INNER JOIN persona per ON per.idPersona=al.Persona_idPersona  WHERE per.Estado_idEstado!=2 and per.Estado_idEstado!=4  ;


END$$

DROP PROCEDURE IF EXISTS `SP_MATRICULA_REGISTRAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MATRICULA_REGISTRAR` (IN `idPersonaR` INT(11), IN `idAlumnoR` INT(11), IN `yearR` INT(11), IN `nivelR` INT(11), IN `gradoR` INT(11), IN `seccionR` INT(11))  NO SQL
BEGIN 

INSERT INTO `matricula`(`idMatricula`, `Alumno_idAlumno`, `Nivel_idNivel`, `Grado_idGrado`, `Seccion_idSeccion`, `year`, `fechaRegistro`) VALUES (NULL,idAlumnoR,nivelR,gradoR,seccionR,yearR,NOW());

END$$

DROP PROCEDURE IF EXISTS `SP_MOSTRAR_ALUMNOS_DISPONIBLES`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MOSTRAR_ALUMNOS_DISPONIBLES` (IN `idApoderadoU` INT(11))  NO SQL
BEGIN 

SELECT al.idAlumno,CONCAT(per.nombrePersona,' ',per.apellidoPaterno,' ',per.apellidoMaterno) as NombreAlumno,per.DNI FROM alumno al INNER JOIN persona per ON per.idPersona=al.Persona_idPersona
 WHERE NOT EXISTS(SELECT * FROM relacionhijos rel INNER JOIN apoderado apo ON apo.idApoderado=rel.Apoderado_idApoderado WHERE rel.Alumno_idAlumno=al.idAlumno and  rel.Apoderado_idApoderado=1);

END$$

DROP PROCEDURE IF EXISTS `SP_NIVEL_ACTUALIZAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_NIVEL_ACTUALIZAR` (IN `Descri` VARCHAR(100), IN `estado` INT(11), IN `idNivelE` INT(11), IN `creador` INT(11))  NO SQL
BEGIN 

UPDATE `nivel` SET  `Descripcion`=UPPER(Descri),`Estado_idEstado`=estado WHERE `idNivel`=idNivelE;  

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT u.usuario FROM usuario u WHERE u.idUsuario=creador);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ACTUALIZACION','Nivel',CONCAt("SE ACTUALIZO NIVEL:",Descri),NOW());    
END$$

DROP PROCEDURE IF EXISTS `SP_NIVEL_HABILITACION`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_NIVEL_HABILITACION` (IN `idNivelE` INT(11), IN `codigo` INT(11), IN `creador` INT(11))  NO SQL
BEGIN 

if (codigo=1) then 
  
    UPDATE `nivel` SET `Estado_idEstado`=4  WHERE `idNivel`=idNivelE;
  SET @Mensaje=("NIVEL DESHABILITADO");
else 
   UPDATE `nivel` SET `Estado_idEstado`=1  WHERE `idNivel`=idNivelE;    
 SET  @Mensaje=("NIVEL HABILITADO");   
end if;

 /* ------ REGISTRO DE BITACORA ------ */

set @usuario=(SELECT u.usuario FROM usuario u  WHERE u.idUsuario=creador);

set @tipotar=(SELECT ni.Descripcion FROM nivel ni WHERE ni.idNivel=idNivelE);

INSERT INTO `bitacora`(`usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (@usuario,@Mensaje,'NIVEL',CONCAT(@Mensaje," :", @tipotar),NOW());     
 
END$$

DROP PROCEDURE IF EXISTS `SP_NIVEL_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_NIVEL_LISTAR` ()  NO SQL
BEGIN 

SELECT * FROM nivel n INNER JOIN estado e ON e.idEstado=n.Estado_idEstado;

END$$

DROP PROCEDURE IF EXISTS `SP_NIVEL_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_NIVEL_RECUPERAR` (IN `idNivelE` INT(11))  NO SQL
BEGIN 

SELECT * FROM nivel ni WHERE ni.idNivel=idNivelE; 
END$$

DROP PROCEDURE IF EXISTS `SP_NIVEL_REGISTRO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_NIVEL_REGISTRO` (IN `nom` VARCHAR(100), IN `estado` INT(11), IN `creador` INT(11))  NO SQL
BEGIN 

-- REGISTRAR TIPO DE TARJETA --
INSERT INTO `nivel`(`idNivel`, `Descripcion`, `fechaRegistro`, `Estado_idEstado`) VALUES (NULL,UPPER(nom),NOW(),estado);
 
 
 
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=creador);


INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'INSERTAR','SE REGISTRO NIVEL','NIVEL',NOW()); 

END$$

DROP PROCEDURE IF EXISTS `SP_OPERACIONES_ACCION_PAGO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OPERACIONES_ACCION_PAGO` (IN `idPlanU` INT(11), IN `idAlumnoU` INT(11), IN `numPago` INT(11), IN `tipoPago` INT(11), IN `tipoTarjeta` INT(11), IN `ImportePago` DECIMAL(7,2), IN `detalle` TEXT, IN `creador` INT(11))  NO SQL
BEGIN 

if(tipoTarjeta='0' or tipoTarjeta=0) THEN
SET tipoTarjeta=null;
end if;
if(detalle='0' or detalle=0) THEN
SET detalle=null;
end if;

SET @idPersona=(SELECT (SELECT per2.idPersona FROM persona per2 INNER JOIN apoderado apo2 ON apo2.Persona_idPersona=per2.idPersona where apo2.idApoderado=rel.Apoderado_idApoderado) as idApoderadoPago
FROM relacionhijos rel 
INNER JOIN alumno alu 
ON alu.idAlumno=rel.Alumno_idAlumno
INNER JOIN persona per 
ON per.idPersona=alu.Persona_idPersona
where alu.idAlumno=idAlumnoU);

INSERT INTO `pago`(`idPago`, `Persona_idPersona`, `Cuota_idCuota`, `Importe`, `fechaRegistro`, `TipoPago_idTipoPago`, `TipoTarjeta_idTipoTarjeta`, `DetallePago`, `Estado_idEstado`) VALUES (NULL,@idPersona,NULL,ImportePago,NOW(),tipoPago,tipoTarjeta,detalle,1);

if(numPago=1)then 
UPDATE `planpago` SET `pagoM`=1 WHERE `idPlanPago`=idPlanU;
elseif(numPago=2)then 
UPDATE `planpago` SET  `pagoOtro1`=1 WHERE `idPlanPago`=idPlanU;
elseif(numPago=3)then 
UPDATE `planpago` SET  `pagoOtro2`=1 WHERE `idPlanPago`=idPlanU;
end if;

 /* ------ REGISTRO DE BITACORA ------ */

set @usuario=(SELECT u.usuario FROM usuario u  WHERE u.idUsuario=creador);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@usuario,"PAGO",'PAGO',CONCAT("SE PAGO - CODIGO PLAN:",idPlanU),NOW());   

END$$

DROP PROCEDURE IF EXISTS `SP_OPERACIONES_ELIMINAR_PAGAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OPERACIONES_ELIMINAR_PAGAR` (IN `idPagarU` INT(11), IN `importPagarU` DECIMAL(10,2), IN `idAlumnoU` INT(11), IN `yearU` INT(11), IN `idCuotaU` INT(11), IN `idMatriculaU` INT(11), IN `tipoPagoU` INT(11))  NO SQL
BEGIN  

DECLARE TotalRecuperado DECIMAL(10,2);
DECLARE TotalGeneral DECIMAL(10,2);

DELETE FROM `pagodetalle` WHERE `Alumno_idAlumno`=idAlumnoU and `year`=yearU and `idDetallePago`=idPagarU;
 
IF(idCuotaU='0' or idCuotaU=0)THEN 
	 
    	SET TotalRecuperado=(SELECT alu.Diferencia FROM alumnopagos alu WHERE alu.Alumno_idAlumno=idAlumnoU and alu.year=yearU and alu.TipoPago_idTipoPago=idMatriculaU);
        
      	SET  TotalRecuperado=TotalRecuperado+importPagarU; 
        
        UPDATE `alumnopagos` SET `Diferencia`=TotalRecuperado  WHERE `TipoPago_idTipoPago`=idMatriculaU and `Alumno_idAlumno`=idAlumnoU and `year`=yearU; 
  
ELSE
 
SET TotalGeneral=(SELECT cu.Importe FROM cuota cu WHERE cu.idCuota=idCuotaU and cu.Alumno_idAlumno=idAlumnoU and cu.year=yearU);

    IF (tipoPagoU=1)THEN
    	SET TotalRecuperado=(SELECT cu.Diferencia FROM cuota cu WHERE cu.idCuota=idCuotaU and cu.Alumno_idAlumno=idAlumnoU and cu.year=yearU);
     	SET  TotalRecuperado=TotalRecuperado+importPagarU;     
  
     UPDATE `cuota` SET `Diferencia`=TotalRecuperado  WHERE `idCuota`=idCuotaU and `Alumno_idAlumno`=idAlumnoU and `year`=yearU;
     	 
    ELSE 
    
    	SET TotalRecuperado=(SELECT cu.Mora FROM cuota cu WHERE cu.idCuota=idCuotaU and cu.Alumno_idAlumno=idAlumnoU and cu.year=yearU);
    	 SET  TotalRecuperado=TotalRecuperado-importPagarU;           
      		UPDATE `cuota` SET `Mora`=TotalRecuperado   WHERE `idCuota`=idCuotaU and `Alumno_idAlumno`=idAlumnoU and `year`=yearU;

    END IF;
END IF;  
END$$

DROP PROCEDURE IF EXISTS `SP_OPERACIONES_INFO_DEUDA1`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OPERACIONES_INFO_DEUDA1` (IN `idAlumnoR` INT(11), IN `yearR` INT(11))  NO SQL
BEGIN 


SELECT alu.idAlumnoPago,ge.idGeneral as idPago,ge.NombrePago,alu.Importe,alu.Diferencia,alu.Mora,alu.Estado_idEstado,e.nombreEstado,alu.Alumno_idAlumno,alu.year FROM alumno al INNER JOIN alumnopagos alu ON alu.Alumno_idAlumno=al.idAlumno LEFT JOIN generalimportes ge ON ge.idGeneral=alu.TipoPago_idTipoPago LEFT JOIN estado e ON e.idEstado=alu.Estado_idEstado where alu.Alumno_idAlumno=idAlumnoR and alu.year=yearR;  

END$$

DROP PROCEDURE IF EXISTS `SP_OPERACIONES_INFO_DEUDA2`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OPERACIONES_INFO_DEUDA2` (IN `idAlumnoR` INT(11), IN `yearR` INT(11))  NO SQL
BEGIN 


SELECT cu.idCuota,cu.Importe,cu.Diferencia,cu.Mora,cu.Estado_idEstado,e.nombreEstado,cu.Alumno_idAlumno,cu.year,cu.Mes,DATE_FORMAT(cu.fechaVencimiento,"%d/%m/%Y") as fechaVencimiento,
(IF(DATE_FORMAT(NOW(),"%Y-%m-%d")>cu.fechaVencimiento,DATEDIFF(DATE_FORMAT(NOW(),"%Y-%m-%d"), cu.fechaVencimiento),0)) as DiasMora
FROM alumno al INNER JOIN cuota cu ON cu.Alumno_idAlumno=al.idAlumno LEFT JOIN estado e ON e.idEstado=cu.Estado_idEstado WHERE cu.Alumno_idAlumno=idAlumnoR and cu.year=yearR;  

END$$

DROP PROCEDURE IF EXISTS `SP_OPERACIONES_INFO_MATRICULA`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OPERACIONES_INFO_MATRICULA` (IN `idMatriculaU` INT(11), IN `idAlumnoU` INT(11), IN `yearU` INT(11))  NO SQL
BEGIN 

SET @CODIGO=(SELECT alu.TipoPago_idTipoPago  FROM alumnopagos alu INNER JOIN  generalimportes ge On ge.idGeneral=alu.TipoPago_idTipoPago WHERE alu.Alumno_idAlumno=idAlumnoU and alu.year=yearU and alu.idAlumnoPago=idMatriculaU);

SET @DIFERENCIA=(SELECT alu.Diferencia  FROM alumnopagos alu INNER JOIN generalimportes ge On ge.idGeneral=alu.TipoPago_idTipoPago WHERE alu.Alumno_idAlumno=idAlumnoU and alu.year=yearU and alu.idAlumnoPago=idMatriculaU);

SET @TITULO=(SELECT ge.NombrePago  FROM alumnopagos alu INNER JOIN  generalimportes ge On ge.idGeneral=alu.TipoPago_idTipoPago WHERE alu.Alumno_idAlumno=idAlumnoU and alu.year=yearU and alu.idAlumnoPago=idMatriculaU);
 

INSERT INTO `pagodetalle`(`idDetallePago`, `Cabecera_idCabecera`, `Alumno_idAlumno`, `year`,`TipoPago`, `NombrePago`, `ImportePago`, `Cuota_idCuota`, `TipoPago_idTipoPago`, `fechaRegistro`, `Estado_idEstado`) VALUES (NULL,NULL,idAlumnoU,yearU,1,@TITULO,@DIFERENCIA,NULL,@CODIGO,NOW(),9);

UPDATE `alumnopagos` SET  `Diferencia`=0  WHERE `Alumno_idAlumno`=idAlumnoU and `year`=yearU and `idAlumnoPago`=idMatriculaU;  


END$$

DROP PROCEDURE IF EXISTS `SP_OPERACIONES_INFO_PENSION`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OPERACIONES_INFO_PENSION` (IN `idCuotaU` INT(11), IN `idAlumnoU` INT(11), IN `yearU` INT(11))  NO SQL
BEGIN 

SET @DIFERENCIA=(SELECT cu.Diferencia FROM cuota cu where cu.Alumno_idAlumno=idAlumnoU and cu.year=yearU and cu.idCuota=idCuotaU);
SET @MORA=(SELECT cu.Mora FROM cuota cu where cu.Alumno_idAlumno=idAlumnoU and cu.year=yearU and cu.idCuota=idCuotaU);
SET @MES=(SELECT cu.Mes FROM cuota cu where cu.Alumno_idAlumno=idAlumnoU and cu.year=yearU and cu.idCuota=idCuotaU);
SET @FECHA_VENCIM=(SELECT cu.fechaVencimiento FROM cuota cu where cu.Alumno_idAlumno=idAlumnoU and cu.year=yearU and cu.idCuota=idCuotaU);

if(@DIFERENCIA>0)then 
	INSERT INTO `pagodetalle`(`idDetallePago`, `Cabecera_idCabecera`, `Alumno_idAlumno`, `year`,`TipoPago`, `NombrePago`, `ImportePago`, `Cuota_idCuota`, `TipoPago_idTipoPago`, `fechaRegistro`, `Estado_idEstado`) VALUES (NULL,NULL,idAlumnoU,yearU,1,CONCAT("PENSIÓN  ",FU_RECUPERAR_MES(@MES)),@DIFERENCIA,idCuotaU,NULL,NOW(),9);
    

UPDATE `cuota` SET  `Diferencia`=0  WHERE `idCuota`=idCuotaU and `Alumno_idAlumno`=idAlumnoU and `year`=yearU; 
end if;

SET @DiasVenc=(DATEDIFF(DATE_FORMAT(NOW(),"%Y-%m-%d"),@FECHA_VENCIM));


if(@DiasVenc>0)then

INSERT INTO `pagodetalle`(`idDetallePago`, `Cabecera_idCabecera`, `Alumno_idAlumno`, `year`,`TipoPago`, `NombrePago`, `ImportePago`, `Cuota_idCuota`, `TipoPago_idTipoPago`, `fechaRegistro`, `Estado_idEstado`) VALUES (NULL,NULL,idAlumnoU,yearU,2,FU_RECUPERAR_MES(@MES),@DiasVenc,idCuotaU,NULL,NOW(),9);


UPDATE `cuota` SET  `Mora`=@DiasVenc  WHERE `idCuota`=idCuotaU and `Alumno_idAlumno`=idAlumnoU and `year`=yearU; 
 
end if;
 
END$$

DROP PROCEDURE IF EXISTS `SP_OPERACIONES_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OPERACIONES_LISTAR` ()  NO SQL
BEGIN 


SELECT 
al.idAlumno,
(SELECT COUNT(*) FROM alumnopagos alup WHERE alup.Alumno_idAlumno=al.idAlumno) as PagosDisponibles,
(SELECT COUNT(*) FROM cuota cuo WHERE cuo.Alumno_idAlumno=al.idAlumno) as NumCuotas,

CONCAT(per.nombrePersona,' ',per.apellidoPaterno,' ',per.apellidoMaterno) as AlumnoNombre,
per.DNI,

IFNULL((SELECT CONCAT(per2.nombrePersona,' ',per2.apellidoPaterno,' ',per2.apellidoMaterno) FROM relacionhijos rel INNER JOIN apoderado apo ON apo.idApoderado=rel.Apoderado_idApoderado INNER JOIN persona per2 ON per2.idPersona=apo.Persona_idPersona  WHERE rel.Alumno_idAlumno=al.idAlumno),'-') as ApoderadoNombre,

IFNULL((SELECT  per2.DNI FROM relacionhijos rel INNER JOIN apoderado apo ON apo.idApoderado=rel.Apoderado_idApoderado INNER JOIN persona per2 ON per2.idPersona=apo.Persona_idPersona  WHERE rel.Alumno_idAlumno=al.idAlumno),'-') as ApoderadoDNI,

(SELECT COUNT(cuu2.idCuota) FROM alumno alu2 LEFT JOIN cuota cuu2 ON cuu2.Alumno_idAlumno=alu2.idAlumno where alu2.idAlumno=al.idAlumno and (cuu2.Estado_idEstado=5 or cuu2.Estado_idEstado=6)) as CuotaPendiente,

(SELECT COUNT(cuu3.idCuota) FROM alumno alu3 LEFT JOIN cuota cuu3 ON cuu3.Alumno_idAlumno=alu3.idAlumno where alu3.idAlumno=al.idAlumno and cuu3.Estado_idEstado=7) as CuotasPagadas,
 
 
(SELECT COUNT(cuu5.idCuota) FROM alumno alu5  LEFT JOIN cuota cuu5 ON cuu5.Alumno_idAlumno=alu5.idAlumno where alu5.idAlumno=al.idAlumno and (cuu5.Estado_idEstado=5 or cuu5.Estado_idEstado=6) and cuu5.fechaVencimiento<=DATE_FORMAT(NOW(), "%Y-%m-%d") ) as CuotasVencidas

FROM persona per
LEFT JOIN alumno al 
ON al.Persona_idPersona=per.idPersona 
LEFT JOIN cuota cu 
ON cu.Alumno_idAlumno=al.idAlumno WHERE (al.idAlumno) IS NOT NULL
GROUP BY al.idAlumno;
 
END$$

DROP PROCEDURE IF EXISTS `SP_OPERACIONES_LISTAR_COMPROBANTES`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OPERACIONES_LISTAR_COMPROBANTES` (IN `idAlumnoU` INT(11))  NO SQL
BEGIN


SELECT pg.idPago,pg.ReciboVoucher,pg.ImporteTotal,pg.TipoTarjeta_idTipoTarjeta,pg.Observaciones,DATE_FORMAT(pg.fechaRegistro,"%Y") as YearComp,pg.fechaRegistro,IF(pg.NumeroTarjeta IS NOT NULL,"TARJETA","EFECTIVO") as TipoPago,pg.Documento FROM pagocabecera pg WHERE pg.Alumno_idAlumno=idAlumnoU ORDER BY pg.idPago DESC;

END$$

DROP PROCEDURE IF EXISTS `SP_OPERACIONES_LISTAR_CUOTAS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OPERACIONES_LISTAR_CUOTAS` (IN `idPlanU` INT(11), IN `idAlumnoU` INT(11))  NO SQL
BEGIN 

SELECT
c.idCuota,c.Estado_idEstado,e.nombreEstado,c.Importe,c.Diferencia,DATE_FORMAT(c.fechaRegistro,"%Y-%m-%d") as fechaRegistro,c.fechaVencimiento,
(IF(DATE_FORMAT(NOW(),"%Y-%m-%d")>c.fechaVencimiento,DATEDIFF(DATE_FORMAT(NOW(),"%Y-%m-%d"), c.fechaVencimiento),0)) as DiasMora,
c.Mora
FROM cuota c 
INNER JOIN estado e ON e.idEstado=c.Estado_idEstado
WHERE c.PlanPago_idPlanPago=idPlanU and c.Estado_idEstado!=8;


END$$

DROP PROCEDURE IF EXISTS `SP_OPERACIONES_RECUPERAR_DEUDA`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OPERACIONES_RECUPERAR_DEUDA` (IN `idAlumnoU` INT(11), IN `yearU` INT(11))  NO SQL
BEGIN 


SELECT alu.idAlumnoPago,ge.idGeneral as idPago,ge.NombrePago,alu.Importe,alu.Diferencia,alu.Mora,alu.Estado_idEstado,e.nombreEstado,alu.Alumno_idAlumno,alu.year FROM alumno al INNER JOIN alumnopagos alu ON alu.Alumno_idAlumno=al.idAlumno LEFT JOIN generalimportes ge ON ge.idGeneral=alu.TipoPago_idTipoPago LEFT JOIN estado e ON e.idEstado=alu.Estado_idEstado where alu.Alumno_idAlumno=idAlumnoU and alu.year=yearU and alu.Estado_idEstado!=7 and alu.Diferencia!=0;  

END$$

DROP PROCEDURE IF EXISTS `SP_OPERACIONES_RECUPERAR_PAGAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OPERACIONES_RECUPERAR_PAGAR` (IN `idAlumnoP` INT(11), IN `yearP` INT(11))  NO SQL
BEGIN 

SELECT pd.idDetallePago,pd.ImportePago,pd.NombrePago,pd.Estado_idEstado,IFNULL(pd.Cuota_idCuota,'0') as Cuota_idCuota ,IFNULL(pd.TipoPago_idTipoPago,'0') as TipoPago_idTipoPago,pd.NombrePago,pd.year,pd.Alumno_idAlumno,pd.TipoPago from pagodetalle pd WHERE pd.Alumno_idAlumno=idAlumnoP and pd.year=yearP and pd.Estado_idEstado=9;



END$$

DROP PROCEDURE IF EXISTS `SP_OPERACIONES_RECUPERAR_PENSIONES`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OPERACIONES_RECUPERAR_PENSIONES` (IN `idAlumnoU` INT(11), IN `yearU` INT(11))  NO SQL
BEGIN 


SELECT cu.idCuota,cu.Importe,cu.Diferencia,cu.Mora,cu.Estado_idEstado,e.nombreEstado,cu.Alumno_idAlumno,cu.year,cu.Mes,DATE_FORMAT(cu.fechaVencimiento,"%d/%m/%Y") as fechaVencimiento,
(IF(DATE_FORMAT(NOW(),"%Y-%m-%d")>cu.fechaVencimiento,DATEDIFF(DATE_FORMAT(NOW(),"%Y-%m-%d"), cu.fechaVencimiento),0)) as DiasMora
FROM alumno al INNER JOIN cuota cu ON cu.Alumno_idAlumno=al.idAlumno LEFT JOIN estado e ON e.idEstado=cu.Estado_idEstado WHERE cu.Alumno_idAlumno=idAlumnoU and cu.year=yearU and  cu.Estado_idEstado!=7 and (((DATEDIFF(DATE_FORMAT(NOW(),"%Y-%m-%d"),cu.fechaVencimiento)*1)-cu.Mora)+cu.Diferencia)!=0;  

END$$

DROP PROCEDURE IF EXISTS `SP_OPERACIONES_RECUPERAR_TOTALES`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OPERACIONES_RECUPERAR_TOTALES` (IN `idAlumnoU` INT(1), IN `idYearU` INT(1))  NO SQL
BEGIN 


SELECT SUM(pg.ImportePago) as TotalPagar FROM pagodetalle pg WHERE pg.Alumno_idAlumno=idAlumnoU and pg.year=idYearU and pg.Estado_idEstado=9;

END$$

DROP PROCEDURE IF EXISTS `SP_OPERACIONES_REGISTRO_PAGO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OPERACIONES_REGISTRO_PAGO` (IN `idAlumnoP` INT(11), IN `yearP` INT(11), IN `impPago` DECIMAL(10,2), IN `impMora` DECIMAL(10,2), IN `codigoPago` INT(11), IN `TipoPago` INT(11), IN `pagarImp` DECIMAL(10,2), IN `pagarMora` DECIMAL(10,2), IN `TituloPago` VARCHAR(150))  NO SQL
BEGIN

  
if(TipoPago=1)then

INSERT INTO `pagodetalle`(`idDetallePago`, `Cabecera_idCabecera`, `Alumno_idAlumno`, `year`,`TipoPago`, `NombrePago`, `ImportePago`, `Cuota_idCuota`, `TipoPago_idTipoPago`, `fechaRegistro`, `Estado_idEstado`) VALUES (NULL,NULL,idAlumnoP,yearP,1,TituloPago,pagarImp,NULL,codigoPago,NOW(),9);

SET @PagoDiferencia=(impPago-pagarImp);
 

UPDATE `alumnopagos` SET  `Diferencia`=@PagoDiferencia  WHERE `Alumno_idAlumno`=idAlumnoP and `year`=yearP and `TipoPago_idTipoPago`=codigoPago;  
 
else

if(pagarImp>0)THEN
SET @PagoDiferencia=(impPago-pagarImp);

	INSERT INTO `pagodetalle`(`idDetallePago`, `Cabecera_idCabecera`, `Alumno_idAlumno`, `year`,`TipoPago`, `NombrePago`, `ImportePago`, `Cuota_idCuota`, `TipoPago_idTipoPago`, `fechaRegistro`, `Estado_idEstado`) VALUES (NULL,NULL,idAlumnoP,yearP,1,TituloPago,pagarImp,codigoPago,NULL,NOW(),9);
    
 

UPDATE `cuota` SET  `Diferencia`=@PagoDiferencia  WHERE `idCuota`=codigoPago and `Alumno_idAlumno`=idAlumnoP and `year`=yearP; 

end if;
 
if(pagarMora>0)then 

SET @MoraPagada=(SELECT cc.Mora FROM cuota cc WHERE cc.Alumno_idAlumno=idAlumnoP and cc.year=yearP and cc.idCuota=codigoPago);

SET @PagoMora=@MoraPagada+pagarMora;
		INSERT INTO `pagodetalle`(`idDetallePago`, `Cabecera_idCabecera`, `Alumno_idAlumno`, `year`,`TipoPago`, `NombrePago`, `ImportePago`, `Cuota_idCuota`, `TipoPago_idTipoPago`, `fechaRegistro`, `Estado_idEstado`) VALUES (NULL,NULL,idAlumnoP,yearP,2,CONCAT("MORA DE ",TituloPago),pagarMora,codigoPago,NULL,NOW(),9);
        
  UPDATE `cuota` SET `Mora`=@PagoMora WHERE `idCuota`=codigoPago and `Alumno_idAlumno`=idAlumnoP and `year`=yearP;  
    end if;
end if;
 

END$$

DROP PROCEDURE IF EXISTS `SP_OPERACION_PAGO_CUOTA`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OPERACION_PAGO_CUOTA` (IN `idPlanU` INT(11), IN `idAlumnoU` INT(11), IN `idCuotaU` INT(11), IN `tipoPago` INT(11), IN `tipoTarjeta` INT(11), IN `ImportePago` DECIMAL(7,2), IN `ImporteBase` DECIMAL(7,2), IN `ImporteMora` DECIMAL(7,2), IN `detalle` TEXT, IN `creador` INT(11))  NO SQL
BEGIN 

DECLARE estadoMora INT(11);
DECLARE pagoDiferencia DECIMAL(7,2);

if(tipoTarjeta='0' or tipoTarjeta=0) THEN
SET tipoTarjeta=null;
end if;
if(detalle='0' or detalle=0) THEN
SET detalle=null;
end if;

SET @idPersona=(SELECT (SELECT per2.idPersona FROM persona per2 INNER JOIN apoderado apo2 ON apo2.Persona_idPersona=per2.idPersona where apo2.idApoderado=rel.Apoderado_idApoderado) as idApoderadoPago
FROM relacionhijos rel 
INNER JOIN alumno alu 
ON alu.idAlumno=rel.Alumno_idAlumno
INNER JOIN persona per 
ON per.idPersona=alu.Persona_idPersona
where alu.idAlumno=idAlumnoU);

if(ImporteMora>0)then 
set estadoMora=1;
end if;

INSERT INTO `pago`(`idPago`, `Persona_idPersona`, `Cuota_idCuota`, `Importe`, `fechaRegistro`, `TipoPago_idTipoPago`, `TipoTarjeta_idTipoTarjeta`, `DetallePago`, `Estado_idEstado`) VALUES (NULL,@idPersona,idCuotaU,ImportePago,NOW(),tipoPago,tipoTarjeta,detalle,1);

if(estadoMora=1)then 
INSERT INTO `pago`(`idPago`, `Persona_idPersona`, `Cuota_idCuota`, `Importe`, `fechaRegistro`, `TipoPago_idTipoPago`, `TipoTarjeta_idTipoTarjeta`, `DetallePago`, `Estado_idEstado`) VALUES (NULL,@idPersona,idCuotaU,ImporteMora,NOW(),tipoPago,tipoTarjeta,detalle,1);

UPDATE `cuota` SET `Mora`=ImporteMora  WHERE `idCuota`=idCuotaU;

end if;

SET pagoDiferencia=ImporteBase-ImportePago;
if(pagoDiferencia=0) then 
 UPDATE `cuota` SET `Diferencia`=pagoDiferencia,`Estado_idEstado`=7  WHERE `idCuota`=idCuotaU;
ELSE
 UPDATE `cuota` SET `Diferencia`=pagoDiferencia,`Estado_idEstado`=6    WHERE `idCuota`=idCuotaU;
end if;   

 /* ------ REGISTRO DE BITACORA ------ */

set @usuario=(SELECT u.usuario FROM usuario u  WHERE u.idUsuario=creador);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@usuario,"PAGO",'PAGO',CONCAT("SE PAGO - CODIGO PLAN:",idPlanU),NOW());   

END$$

DROP PROCEDURE IF EXISTS `SP_OPERACION_RECUPERAR_CUOTA_PAGAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OPERACION_RECUPERAR_CUOTA_PAGAR` (IN `idPlanU` INT(11), IN `idCuotaU` INT(11))  NO SQL
BEGIN 

SELECT
c.idCuota,c.Estado_idEstado,e.nombreEstado,c.Importe,c.Diferencia,DATE_FORMAT(c.fechaRegistro,"%Y-%m-%d") as fechaRegistro,c.fechaVencimiento,
(IF(DATE_FORMAT(NOW(),"%Y-%m-%d")>c.fechaVencimiento,DATEDIFF(DATE_FORMAT(NOW(),"%Y-%m-%d"), c.fechaVencimiento),0)) as DiasMora 
FROM cuota c 
INNER JOIN estado e ON e.idEstado=c.Estado_idEstado
WHERE c.PlanPago_idPlanPago=idPlanU and c.Estado_idEstado!=8 and c.idCuota=idCuotaU;


END$$

DROP PROCEDURE IF EXISTS `SP_OPERACION_RECUPERAR_INFO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OPERACION_RECUPERAR_INFO` (IN `idAlumnoE` INT(11))  NO SQL
BEGIN 


SELECT 
al.idAlumno,
CONCAT(per.nombrePersona,' ',per.apellidoPaterno,' ',per.apellidoMaterno) as AlumnoNombres,
per.DNI as ALumnoDNI,
ni.Descripcion as AlumnoNivel,
CONCAT(gra.Descripcion,' GRADO - SECCION ',sec.Descripcion) as AlumnoGradoSeccion,

IFNULL((SELECT per.idPersona FROM relacionhijos rel INNER JOIN apoderado apo ON apo.idApoderado=rel.Apoderado_idApoderado INNER JOIN persona per2 ON per2.idPersona=apo.Persona_idPersona  WHERE rel.Alumno_idAlumno=al.idAlumno),'-') as ApoderadoID,

IFNULL((SELECT CONCAT(per2.nombrePersona,' ',per2.apellidoPaterno,' ',per2.apellidoMaterno) FROM relacionhijos rel INNER JOIN apoderado apo ON apo.idApoderado=rel.Apoderado_idApoderado INNER JOIN persona per2 ON per2.idPersona=apo.Persona_idPersona  WHERE rel.Alumno_idAlumno=al.idAlumno),'-') as ApoderadoNombre,

IFNULL((SELECT  per2.DNI FROM relacionhijos rel INNER JOIN apoderado apo ON apo.idApoderado=rel.Apoderado_idApoderado INNER JOIN persona per2 ON per2.idPersona=apo.Persona_idPersona  WHERE rel.Alumno_idAlumno=al.idAlumno),'-') as ApoderadoDNI,


IFNULL((SELECT  per2.telefono FROM relacionhijos rel INNER JOIN apoderado apo ON apo.idApoderado=rel.Apoderado_idApoderado INNER JOIN persona per2 ON per2.idPersona=apo.Persona_idPersona  WHERE rel.Alumno_idAlumno=al.idAlumno),'-') as ApoderadoTelefono,

IFNULL((SELECT  tipo.idTipoTarjeta FROM relacionhijos rel INNER JOIN apoderado apod ON apod.idApoderado=rel.Apoderado_idApoderado INNER JOIN persona per2 ON per2.idPersona=apod.Persona_idPersona LEFT JOIN tipotarjeta tipo ON tipo.idTipoTarjeta=apod.TipoTarjeta_idTipoTarjeta  WHERE rel.Alumno_idAlumno=al.idAlumno),'-') as idTipoTarjetaApoderado,

IFNULL((SELECT  tipo.Descripcion FROM relacionhijos rel INNER JOIN apoderado apo ON apo.idApoderado=rel.Apoderado_idApoderado INNER JOIN persona per2 ON per2.idPersona=apo.Persona_idPersona LEFT JOIN tipotarjeta tipo ON tipo.idTipoTarjeta=apo.TipoTarjeta_idTipoTarjeta  WHERE rel.Alumno_idAlumno=al.idAlumno),'-') as TipoTarjetaApoderado

FROM persona per
LEFT JOIN alumno al 
ON al.Persona_idPersona=per.idPersona
LEFT JOIN matricula ma ON ma.Alumno_idAlumno=al.idAlumno
LEFT JOIN nivel ni On ni.idNivel=ma.Nivel_idNivel
LEFT JOIN grado gra ON gra.idGrado=ma.Grado_idGrado
LEFT JOIN seccion sec ON sec.idSeccion=ma.Seccion_idSeccion
WHERE  al.idAlumno=idAlumnoE
GROUP BY al.idAlumno
;
 
END$$

DROP PROCEDURE IF EXISTS `SP_PERFIL_ACTUALIZAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERFIL_ACTUALIZAR` (IN `nombre` VARCHAR(50), IN `descripcion` TEXT, IN `estado` INT(11), IN `idperfilE` INT(11), IN `creador` INT(11))  NO SQL
BEGIN 

if(descripcion=-1)then 
SET descripcion=null;
end if;
 
UPDATE `perfil` SET `nombrePerfil`=UPPER(nombre),`descripcionPerfil`=UPPER(descripcion),`Estado_idEstado`=estado WHERE `idPerfil`=idperfilE; 

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT u.usuario FROM usuario u WHERE u.idUsuario=creador);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ACTUALIZACION','Perfil',CONCAt("SE ACTUALIZO PERFIL:",nombre),NOW());
END$$

DROP PROCEDURE IF EXISTS `SP_PERFIL_ELIMINAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERFIL_ELIMINAR` (IN `idPerfilEnviado` INT(11), IN `idUsuario` INT(11), OUT `Mensaje` TEXT)  NO SQL
BEGIN 
DECLARE CantidadPerfil INT(11);

SET CantidadPerfil=(SELECT COUNT(*) FROM usuario u WHERE u.Perfil_idPerfil=idPerfilEnviado);

SELECT CantidadPerfil;

if(CantidadPerfil>0) then  
    SET Mensaje="No se Puede Eliminar,Existen Usuarios usando el Perfil Seleccionado.";
else 
 	DELETE FROM `perfil`  WHERE `idPerfil`=idPerfilEnviado;
    SET Mensaje="Perfil Elimino Correctamente.";
end if;

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=idUsuario);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ELIMINAR','Perfil',NOW());


END$$

DROP PROCEDURE IF EXISTS `SP_PERFIL_HABILITACION`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERFIL_HABILITACION` (IN `idPerfilE` INT(11), IN `codigo` INT(11), IN `idUsuarioE` INT(11))  NO SQL
BEGIN 

SET @NombrePerfil=(SELECT pe.nombrePerfil FROM perfil pe WHERE pe.idPerfil=idPerfilE);


if (codigo=1) then 
 	UPDATE `perfil` SET  `Estado_idEstado`=4 WHERE `idPerfil`=idPerfilE;
  SET @Mensaje=("PERFIL DESHABILITADO");
else 
    UPDATE `perfil` SET  `Estado_idEstado`=1  WHERE `idPerfil`=idPerfilE;
 SET  @Mensaje=("PERFIL HABILITADO");
end if;

 /* ------ REGISTRO DE BITACORA ------ */

set @usuario=(SELECT u.usuario FROM usuario u  WHERE u.idUsuario=idUsuarioE);

INSERT INTO `bitacora`(`usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (@usuario,@Mensaje,'PERFIL',CONCAT("SE",@Mensaje," :", @NombrePerfil),NOW());     
 
END$$

DROP PROCEDURE IF EXISTS `SP_PERFIL_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERFIL_LISTAR` ()  NO SQL
BEGIN 

SELECT * FROM perfil;

END$$

DROP PROCEDURE IF EXISTS `SP_PERFIL_LISTAR_TODOS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERFIL_LISTAR_TODOS` ()  NO SQL
BEGIN 

SELECT * FROM perfil p INNER JOIN estado e on e.idEstado=p.Estado_idEstado;
END$$

DROP PROCEDURE IF EXISTS `SP_PERFIL_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERFIL_RECUPERAR` (IN `idPerfilE` INT(11))  NO SQL
BEGIN

SELECT * FROM perfil p WHERE p.idPerfil=idPerfilE;
END$$

DROP PROCEDURE IF EXISTS `SP_PERFIL_REGISTRO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERFIL_REGISTRO` (IN `nombrePerfil` VARCHAR(50), IN `descripcion` TEXT, IN `estado` INT(11), IN `idUsuarioE` INT(11))  NO SQL
BEGIN 

DECLARE idPerfil INT(11);

-- REGISTRAR PERFIL --
INSERT INTO `perfil`(`idPerfil`, `nombrePerfil`, `descripcionPerfil`, `Estado_idEstado`, `fechaRegistro`) VALUES (null,UPPER(nombrePerfil),UPPER(descripcion),estado,NOW());
-- RECUPERAR ID DE PERFIL REGISTRADO --
SET idPerfil=(SELECT LAST_INSERT_ID());
-- REGISTRAR PERMISOS ASIGNADOS A PERFIL --
INSERT INTO `permisos`(`idPermisos`, `perfil_idPerfil`, `permiso1`, `permiso2`, `permiso3`) VALUES (null,idPerfil,1,1,1);




SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=idUsuarioE);


INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'INSERTAR','SE REGISTRO PERFIL','Perfil',NOW());

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'INSERTAR','SE REGISTRO PERMISOS DE PERFIL','Permisos',NOW()); 

END$$

DROP PROCEDURE IF EXISTS `SP_PERMISOS_ACTUALIZAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERMISOS_ACTUALIZAR` (IN `idPermisosE` INT(11), IN `perm1` INT(11), IN `perm2` INT(11), IN `perm3` INT(11), IN `idPerfilE` INT(11), IN `idUsuarioE` INT(11))  NO SQL
BEGIN 

UPDATE `permisos` SET `Permiso1`=perm1,`Permiso2`=perm2,`Permiso3`=perm3 WHERE `idPermisos`=idPermisosE;

set @perfil=(SELECT perfil.nombrePerfil FROM perfil WHERE perfil.idPerfil=idPerfilE);

/* ------ REGISTRO DE BITACORA ------ */

set @usuario=(SELECT u.usuario FROM usuario u  WHERE u.idUsuario=idUsuarioE);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@usuario,'SE ACTUALIZO PERMISOS','PERMISOS',CONCAT("SE ACTUALIZO PERMISOS DE PERFIL:",@perfil),NOW()); 

END$$

DROP PROCEDURE IF EXISTS `SP_PERMISOS_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERMISOS_RECUPERAR` (IN `idPerfilE` INT(11))  NO SQL
BEGIN 

SELECT per.idPermisos,per.Permiso1,per.Permiso2,per.Permiso3,perf.nombrePerfil FROM permisos per INNER JOIN perfil perf ON perf.idPerfil=per.Perfil_idPerfil WHERE perf.idPerfil=idPerfilE;

END$$

DROP PROCEDURE IF EXISTS `SP_PERSONAS_LISTAR_SIN_USUARIOS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERSONAS_LISTAR_SIN_USUARIOS` ()  NO SQL
BEGIN 

SELECT * FROM persona p WHERE NOT EXISTS (SELECT * FROM usuario u WHERE u.Persona_idPersona=p.idPersona);


END$$

DROP PROCEDURE IF EXISTS `SP_PERSONA_ACTUALIZAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERSONA_ACTUALIZAR` (IN `nombre` VARCHAR(50), IN `apellidoP` VARCHAR(50), IN `apellidoM` VARCHAR(50), IN `DNI` CHAR(10), IN `fechaNacimiento` DATE, IN `correo` VARCHAR(100), IN `telefono` CHAR(10), IN `Direccion` TEXT, IN `estado` INT(11), IN `idPersonaU` INT(11), IN `idUsuario` INT(11))  NO SQL
BEGIN 

 
if(correo='0')then 
SET correo=null;
end if;
if(telefono='0')then 
SET telefono=null;
end if;
if(Direccion='0')then 
SET Direccion=null;
end if; 
   
UPDATE `persona` SET `nombrePersona`=UPPER(nombre),`apellidoPaterno`=UPPER(apellidoP),`apellidoMaterno`=UPPER(apellidoM),`DNI`=DNI,`fechaNacimiento`=fechaNacimiento,`correo`=UPPER(correo),`telefono`=telefono,`direccion`=UPPER(Direccion),`Estado_idEstado`=estado WHERE `idPersona`=idPersonaU;

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=idUsuario);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ACTUALIZACION','Persona',CONCAT('SE ACTUALIZO PERSONA:',nombre,' ',apellidoP,' ',apellidoM),NOW());
END$$

DROP PROCEDURE IF EXISTS `SP_PERSONA_HABILITACION`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERSONA_HABILITACION` (IN `idPersonaE` INT(11), IN `codigo` INT(11), IN `idUsuarioE` INT(11))  NO SQL
BEGIN 

SET @NombrePersona=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM persona p WHERE p.idPersona=idPersonaE);


if (codigo=1) then 
 	UPDATE `persona` SET  `Estado_idEstado`=4 WHERE `idPersona`=idPersonaE;
  SET @Mensaje=("PERSONA DESHBILITADO");
else 
    UPDATE `persona` SET  `Estado_idEstado`=1  WHERE `idPersona`=idPersonaE;
 SET  @Mensaje=("PERSONA HABILITADO");
end if;

 /* ------ REGISTRO DE BITACORA ------ */

set @usuario=(SELECT u.usuario FROM usuario u  WHERE u.idUsuario=idUsuarioE); 

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@usuario,@Mensaje,'USUARIO',CONCAT("SE",@Mensaje," :", @NombrePersona),NOW());    

END$$

DROP PROCEDURE IF EXISTS `SP_PERSONA_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERSONA_LISTAR` ()  NO SQL
BEGIN 


SELECT * FROM persona p INNER JOIN estado e ON e.idEstado=p.Estado_idEstado;


END$$

DROP PROCEDURE IF EXISTS `SP_PERSONA_LISTAR_TODO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERSONA_LISTAR_TODO` ()  NO SQL
BEGIN 

SELECT * FROM persona;

END$$

DROP PROCEDURE IF EXISTS `SP_PERSONA_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERSONA_RECUPERAR` (IN `idPersonaU` INT)  NO SQL
begin 

SELECT * FROM persona p WHERE p.idPersona=idPersonaU;

end$$

DROP PROCEDURE IF EXISTS `SP_PERSONA_REGISTRO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PERSONA_REGISTRO` (IN `nombre` VARCHAR(50), IN `apellidoP` VARCHAR(50), IN `apellidoM` VARCHAR(50), IN `DNI` CHAR(10), IN `fechaNacimiento` DATE, IN `correo` VARCHAR(100), IN `telefono` CHAR(10), IN `Direccion` TEXT, IN `estado` INT(11), IN `idUsuario` INT(11))  NO SQL
BEGIN 

if(correo='0')THEN
SET correo=null;
end if;
if(telefono='0')THEN
SET telefono=null;
end if;
if(Direccion='0')THEN
SET Direccion=null;
end if;

INSERT INTO `persona`(`idPersona`, `nombrePersona`, `apellidoPaterno`, `apellidoMaterno`, `DNI`, `fechaNacimiento`, `correo`, `telefono`, `direccion`, `Estado_idEstado`, `fechaRegistro`) VALUES (NULL,UPPER(nombre),UPPER(apellidoP),UPPER(apellidoM),DNI,fechaNacimiento,UPPER(correo),telefono,UPPER(Direccion),estado,NOW());  


/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=idUsuario);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'REGISTRO','Persona',CONCAT('SE REGISTRO PERSONA:',nombre,' ',apellidoP,' ',apellidoM),NOW());


END$$

DROP PROCEDURE IF EXISTS `SP_RECUPERAR_PARAMETROS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RECUPERAR_PARAMETROS` (OUT `NumAlumnos` INT(11), OUT `NumApoderados` INT(11), OUT `PagoHoy` INT(11), OUT `VencidoHoy` INT(11))  NO SQL
BEGIN 

SET NumAlumnos=(SELECT COUNT(*) FROM alumno al INNER JOIN persona per ON per.idPersona=al.Persona_idPersona WHERE (per.Estado_idEstado!=2 or per.Estado_idEstado!=4));
SET NumApoderados=(SELECT COUNT(*) FROM apoderado);

SET VencidoHoy=(SELECT COUNT(cuu5.idCuota) FROM alumno alu5  LEFT JOIN cuota cuu5 ON cuu5.Alumno_idAlumno=alu5.idAlumno where  (cuu5.Estado_idEstado=5 or cuu5.Estado_idEstado=6) and cuu5.fechaVencimiento<=DATE_FORMAT(NOW(), "%Y-%m-%d") );  

SET PagoHoy=0; 
END$$

DROP PROCEDURE IF EXISTS `SP_REGISTRAR_DATOS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_DATOS` (IN `idAlumnoE` INT(11), IN `yearE` INT(11), IN `imp_pagar` DECIMAL(10,2), IN `imp_vuelto` DECIMAL(10,2), IN `imp_total` DECIMAL(10,2), IN `metodo` INT(11), IN `tipotarj` INT(11), IN `num_tarjeta` INT(11), IN `cvv_tarjeta` INT(11), IN `detalle` TEXT)  NO SQL
BEGIN 
DECLARE codigo INT(11);
DECLARE idCodigo INT(11);

IF(tipotarj=0)THEN 
SET tipotarj=NULL;
end if;
IF(num_tarjeta=0)THEN 
SET num_tarjeta=NULL;
end if;
IF(cvv_tarjeta=0)THEN 
SET cvv_tarjeta=NULL;
end if;
  
SET codigo=(SELECT COUNT(*) FROM pagocabecera LIMIT 1);
SET codigo=codigo+1;

INSERT INTO `pagocabecera`(`idPago`, `Alumno_idAlumno`, `ImporteTotal`, `ImporteVuelto`, `ImportePagar`, `Observaciones`, `TipoTarjeta_idTipoTarjeta`, `NumeroTarjeta`, `CVV`, `Apoderado_idApoderado`, `Estado_idEstado`, `ReciboVoucher`, `fechaRegistro`) VALUES (NULL,idAlumnoE,imp_total,imp_vuelto,imp_pagar,detalle,tipotarj,num_tarjeta,cvv_tarjeta,NULL,1,CONCAT("COMP-00",codigo),NOW());

SET idCodigo=(SELECT LAST_INSERT_ID()); 
SELECT idCodigo;
END$$

DROP PROCEDURE IF EXISTS `SP_RELACION_AGREGAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RELACION_AGREGAR` (IN `idApoderadoE` INT(11), IN `idAlumnoE` INT(11), IN `creador` INT)  NO SQL
BEGIN 

INSERT INTO `relacionhijos`(`idRelacionHijos`, `Apoderado_idApoderado`, `Alumno_idAlumno`, `Estado_idEstado`, `fechaRegistro`) VALUES (NULL,idApoderadoE,idAlumnoE,1,NOW());


/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=creador);  

 
INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'REGISTRO','Relacion',CONCAT('SE AGREGO ALUMNO:',idAlumnoE,' A APODERADO:',idApoderadoE),NOW());

END$$

DROP PROCEDURE IF EXISTS `SP_RELACION_ELIMINAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RELACION_ELIMINAR` (IN `idRelacion` INT(11), IN `creador` INT(11))  NO SQL
BEGIN 

UPDATE `relacionhijos` SET  `Estado_idEstado`=2 WHERE `idRelacionHijos`=idRelacion;

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=creador);  

 
INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ELIMINAR','Relacion','SE QUITO RELACION',NOW());

END$$

DROP PROCEDURE IF EXISTS `SP_RELACION_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RELACION_LISTAR` (IN `idApoderadoE` INT(11))  NO SQL
BEGIN 

 
SELECT rel.idRelacionHijos,
concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NomAlumno,
p.DNI ,
rel.Estado_idEstado,e.nombreEstado,rel.fechaRegistro
FROM relacionhijos rel
INNER JOIN alumno al 
ON al.idAlumno=rel.Alumno_idAlumno 
INNER JOIN persona p 
ON p.idPersona=al.Persona_idPersona
INNER JOIN estado e 
ON e.idEstado=rel.Estado_idEstado
WHERE rel.Apoderado_idApoderado=idApoderadoE;


END$$

DROP PROCEDURE IF EXISTS `SP_RELACION_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RELACION_RECUPERAR` (IN `idRelacionU` INT(11), IN `creador` INT(11))  NO SQL
BEGIN 

UPDATE `relacionhijos` SET  `Estado_idEstado`=1 WHERE `idRelacionHijos`=idRelacionU;

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=creador);  

 
INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ELIMINAR','Relacion','SE QUITO RELACION',NOW());

END$$

DROP PROCEDURE IF EXISTS `SP_REPORTE_1`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REPORTE_1` (IN `Inicio` DATE, IN `Fin` DATE)  NO SQL
BEGIN 
DECLARE diaTemporal DATE;
 
CREATE TEMPORARY TABLE TablaTemporal (
fecha DATE,
CuotaTotal INT(11), 
CuotaPendiente INT(11), 
CuotaPagada INT(11),
CuotaVencida INT(11)                                      
);           
 
 
SET  diaTemporal=Inicio;
 WHILE diaTemporal<=Fin DO
 
SET @CuotaTotales=(SELECT COUNT(*) as NumeroCuota FROM cuota cu WHERE  cu.fechaEmision<=diaTemporal);

SET @CuotaPendiente=(SELECT COUNT(*) as NumeroCuota FROM cuota cu WHERE cu.fechaEmision<=diaTemporal and (cu.Estado_idEstado=5 OR cu.Estado_idEstado=6));

SET @CuotaPagada=(SELECT COUNT(*) as NumeroCuota FROM cuota cu WHERE cu.fechaEmision<=diaTemporal and cu.Estado_idEstado=7);

SET @CuotaVencida=(SELECT COUNT(*) as NumeroCuota FROM cuota cu WHERE  cu.fechaEmision<=diaTemporal and (cu.Estado_idEstado=5 OR cu.Estado_idEstado=6) and (DATEDIFF(DATE_FORMAT(NOW(),"%Y-%m-%d"),cu.fechaVencimiento)>0));  
  
 
INSERT INTO TablaTemporal(fecha,CuotaTotal,CuotaPendiente,CuotaPagada,CuotaVencida) VALUES (diaTemporal,@CuotaTotales,@CuotaPendiente,@CuotaPagada,@CuotaVencida); 
 
 SET diaTemporal=(DATE(DATE_ADD(diaTemporal, INTERVAL 1 DAY)));
 END WHILE; 
 

SELECT * FROM TablaTemporal ORDER BY fecha ASC;
END$$

DROP PROCEDURE IF EXISTS `SP_REPORTE_2`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REPORTE_2` (IN `Inicio` DATE, IN `Fin` DATE, IN `idAlumnoR` INT(11))  NO SQL
BEGIN 
DECLARE diaTemporal DATE;
 
CREATE TEMPORARY TABLE TablaTemporal (
fecha DATE,
CuotaTotal INT(11), 
CuotaPendiente INT(11), 
CuotaPagada INT(11),
CuotaVencida INT(11)                                      
);           
 
 
SET  diaTemporal=Inicio;
 WHILE diaTemporal<=Fin DO
 
SET @CuotaTotales=(SELECT COUNT(*) as NumeroCuota FROM cuota cu WHERE  cu.fechaEmision<=diaTemporal and cu.Alumno_idAlumno=idAlumnoR);

SET @CuotaPendiente=(SELECT COUNT(*) as NumeroCuota FROM cuota cu WHERE cu.fechaEmision<=diaTemporal and (cu.Estado_idEstado=5 OR cu.Estado_idEstado=6) and cu.Alumno_idAlumno=idAlumnoR);

SET @CuotaPagada=(SELECT COUNT(*) as NumeroCuota FROM cuota cu WHERE cu.fechaEmision<=diaTemporal and cu.Estado_idEstado=7 and cu.Alumno_idAlumno=idAlumnoR);

SET @CuotaVencida=(SELECT COUNT(*) as NumeroCuota FROM cuota cu WHERE  cu.fechaEmision<=diaTemporal and (cu.Estado_idEstado=5 OR cu.Estado_idEstado=6) and (DATEDIFF(DATE_FORMAT(NOW(),"%Y-%m-%d"),cu.fechaVencimiento)>0) and cu.Alumno_idAlumno=idAlumnoR);  
  
 
INSERT INTO TablaTemporal(fecha,CuotaTotal,CuotaPendiente,CuotaPagada,CuotaVencida) VALUES (diaTemporal,@CuotaTotales,@CuotaPendiente,@CuotaPagada,@CuotaVencida); 
 
 SET diaTemporal=(DATE(DATE_ADD(diaTemporal, INTERVAL 1 DAY)));
 END WHILE; 
 

SELECT * FROM TablaTemporal ORDER BY fecha ASC;
END$$

DROP PROCEDURE IF EXISTS `SP_REPORTE_GRAFICO1`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REPORTE_GRAFICO1` (IN `Inicio` DATE, IN `Fin` DATE)  NO SQL
BEGIN 

DECLARE CuotaTotales INT(11);
DECLARE CuotaPendiente INT(11);
DECLARE CuotaPagada INT(11);
DECLARE CuotaVencida INT(11);


SET CuotaTotales=(SELECT COUNT(*) as NumeroCuota FROM cuota cu WHERE  cu.fechaEmision BETWEEN Inicio and Fin );

SET CuotaPendiente=(SELECT COUNT(*) as NumeroCuota FROM cuota cu WHERE (cu.fechaEmision BETWEEN Inicio and Fin) and (cu.Estado_idEstado=5 OR cu.Estado_idEstado=6));

SET CuotaPagada=(SELECT COUNT(*) as NumeroCuota FROM cuota cu WHERE (cu.fechaEmision BETWEEN Inicio and Fin) and cu.Estado_idEstado=7);

SET CuotaVencida=(SELECT COUNT(*) as NumeroCuota FROM cuota cu WHERE  (cu.fechaEmision BETWEEN Inicio and Fin) and (cu.Estado_idEstado=5 OR cu.Estado_idEstado=6) and (DATEDIFF(DATE_FORMAT(NOW(),"%Y-%m-%d"),cu.fechaVencimiento)>0)); 

SELECT CuotaTotales,CuotaPendiente,CuotaPagada,CuotaVencida;

END$$

DROP PROCEDURE IF EXISTS `SP_REPORTE_GRAFICO2`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REPORTE_GRAFICO2` (IN `Inicio` DATE, IN `Fin` DATE, IN `AlumnoR` INT(11))  NO SQL
BEGIN 

DECLARE CuotaTotales INT(11);
DECLARE CuotaPendiente INT(11);
DECLARE CuotaPagada INT(11);
DECLARE CuotaVencida INT(11);

SET CuotaTotales=(SELECT COUNT(*) as NumeroCuota FROM cuota cu WHERE  (cu.fechaEmision BETWEEN Inicio and Fin) and cu.Alumno_idAlumno=AlumnoR);

SET CuotaPendiente=(SELECT COUNT(*) as NumeroCuota FROM cuota cu WHERE (cu.fechaEmision BETWEEN Inicio and Fin) and (cu.Estado_idEstado=5 OR cu.Estado_idEstado=6) and cu.Alumno_idAlumno=AlumnoR);

SET CuotaPagada=(SELECT COUNT(*) as NumeroCuota FROM cuota cu WHERE (cu.fechaEmision BETWEEN Inicio and Fin) and cu.Estado_idEstado=7 and cu.Alumno_idAlumno=AlumnoR);

SET CuotaVencida=(SELECT COUNT(*) as NumeroCuota FROM cuota cu WHERE  (cu.fechaEmision BETWEEN Inicio and Fin) and (cu.Estado_idEstado=5 OR cu.Estado_idEstado=6) and (DATEDIFF(DATE_FORMAT(NOW(),"%Y-%m-%d"),cu.fechaVencimiento)>0) and cu.Alumno_idAlumno=AlumnoR); 

SELECT CuotaTotales,CuotaPendiente,CuotaPagada,CuotaVencida;

END$$

DROP PROCEDURE IF EXISTS `SP_SECCION_ACTUALIZAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_SECCION_ACTUALIZAR` (IN `Descri` VARCHAR(100), IN `estado` INT(11), IN `idSeccionE` INT(11), IN `creador` INT)  NO SQL
BEGIN 


UPDATE `seccion` SET `Descripcion`=UPPER(Descri),`Estado_idEstado`=estado WHERE `idSeccion`=idSeccionE;

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT u.usuario FROM usuario u WHERE u.idUsuario=creador);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ACTUALIZACION','SECCION',CONCAt("SE ACTUALIZO SECCION:",Descri),NOW());    
END$$

DROP PROCEDURE IF EXISTS `SP_SECCION_HABILITACION`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_SECCION_HABILITACION` (IN `idSeccionE` INT(11), IN `codigo` INT(11), IN `creador` INT(11))  NO SQL
BEGIN 

if (codigo=1) then 
  
    UPDATE `seccion` SET `Estado_idEstado`=4  WHERE `idSeccion`=idSeccionE;
  SET @Mensaje=("SECCION DESHABILITADO");
else 
   UPDATE `seccion` SET `Estado_idEstado`=1  WHERE `idSeccion`=idSeccionE;    
 SET  @Mensaje=("SECCION HABILITADO");   
end if;

 /* ------ REGISTRO DE BITACORA ------ */

set @usuario=(SELECT u.usuario FROM usuario u  WHERE u.idUsuario=creador);

set @tipotar=(SELECT s.Descripcion FROM seccion s WHERE s.idSeccion=idSeccionE);

INSERT INTO `bitacora`(`usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (@usuario,@Mensaje,'SECCION',CONCAT(@Mensaje," :", @tipotar),NOW());     
 
END$$

DROP PROCEDURE IF EXISTS `SP_SECCION_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_SECCION_LISTAR` ()  NO SQL
BEGIN 

SELECT * FROM seccion s INNER JOIN estado e ON e.idEstado=s.Estado_idEstado;
END$$

DROP PROCEDURE IF EXISTS `SP_SECCION_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_SECCION_RECUPERAR` (IN `idSeccionE` INT(11))  NO SQL
BEGIN 

SELECT * FROM seccion s WHERE s.idSeccion=idSeccionE;

END$$

DROP PROCEDURE IF EXISTS `SP_SECCION_REGISTRO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_SECCION_REGISTRO` (IN `Descri` VARCHAR(100), IN `estado` INT(11), IN `creador` INT(11))  NO SQL
BEGIN 

-- REGISTRAR TIPO DE TARJETA --
INSERT INTO `seccion`(`idSeccion`, `Descripcion`, `fechaRegistro`, `Estado_idEstado`) VALUES (NULL,Descri,NOW(),estado);
 

SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=creador);


INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'INSERTAR','SE REGISTRO SECCION','SECCION',NOW());  

END$$

DROP PROCEDURE IF EXISTS `SP_TARJETA_ACTUALIZAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TARJETA_ACTUALIZAR` (IN `descri` VARCHAR(100), IN `estado` INT(11), IN `idTarjeta` INT(11), IN `creador` INT)  NO SQL
BEGIN 


UPDATE `tipotarjeta` SET  `Descripcion`=UPPER(descri),`Estado_idEstado`=estado WHERE `idTipoTarjeta`=idTarjeta;

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT u.usuario FROM usuario u WHERE u.idUsuario=creador);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ACTUALIZACION','TipoTarjeta',CONCAt("SE ACTUALIZO TIPO TARJETA:",descri),NOW());  
END$$

DROP PROCEDURE IF EXISTS `SP_TARJETA_HABILITACION`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TARJETA_HABILITACION` (IN `idTarjeta` INT(11), IN `codigo` INT(11), IN `creador` INT(11))  NO SQL
BEGIN 

if (codigo=1) then 
  
    UPDATE `tipotarjeta` SET `Estado_idEstado`=4  WHERE `idTipoTarjeta`=idTarjeta;
  SET @Mensaje=("TIPO DE TARJETA DESHABILITADO");
else 
   UPDATE `tipotarjeta` SET `Estado_idEstado`=1  WHERE `idTipoTarjeta`=idTarjeta;    
 SET  @Mensaje=("TIPO DE TARJETA HABILITADO");
end if;

 /* ------ REGISTRO DE BITACORA ------ */

set @usuario=(SELECT u.usuario FROM usuario u  WHERE u.idUsuario=creador);
set @tipotar=(SELECT tip.Descripcion FROM tipotarjeta tip WHERE tip.idTipoTarjeta=idTarjeta);

INSERT INTO `bitacora`(`usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (@usuario,@Mensaje,'PERFIL',CONCAT(@Mensaje," :", @tipotar),NOW());     
 
END$$

DROP PROCEDURE IF EXISTS `SP_TARJETA_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TARJETA_LISTAR` ()  NO SQL
BEGIN 

SELECT * FROM tipotarjeta tar INNER JOIN estado e ON e.idEstado=tar.Estado_idEstado; 

END$$

DROP PROCEDURE IF EXISTS `SP_TARJETA_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TARJETA_RECUPERAR` (IN `idTarjeta` INT(11))  NO SQL
BEGIN 

SELECT * FROM tipotarjeta tip WHERE tip.idTipoTarjeta=idTarjeta; 

END$$

DROP PROCEDURE IF EXISTS `SP_TARJETA_REGISTRO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TARJETA_REGISTRO` (IN `nombreTarjeta` VARCHAR(100), IN `estado` INT(11), IN `idUsuarioE` INT(11))  NO SQL
BEGIN 

-- REGISTRAR TIPO DE TARJETA --
INSERT INTO `tipotarjeta`(`idTipoTarjeta`, `Descripcion`, `Estado_idEstado`, `fechaRegistro`) VALUES (NULL,UPPER(nombreTarjeta),estado,NOW());
 
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=idUsuarioE);


INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'INSERTAR','SE REGISTRO TIPO DE TARJETA DE PAGO','TipoTarjeta',NOW()); 

END$$

DROP PROCEDURE IF EXISTS `SP_TIPOPAGO_ACTUALIZAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TIPOPAGO_ACTUALIZAR` (IN `idTipoPagoR` INT(11), IN `NombreP` VARCHAR(100), IN `MontoP` DECIMAL(10,2), IN `CuotaP` INT(11), IN `estadoP` INT(11), IN `creador` INT(11))  NO SQL
BEGIN 


UPDATE `generalimportes` SET `NombrePago`=NombreP,`Monto`=MontoP,`Cuotas`=CuotaP,`Estado_idEstado`=estadoP WHERE `idGeneral`=idTipoPagoR;

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT u.usuario FROM usuario u WHERE u.idUsuario=creador);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ACTUALIZACION','TipoPago',CONCAt("SE ACTUALIZO TIPO Pago:",NombreP),NOW());  
END$$

DROP PROCEDURE IF EXISTS `SP_TIPOPAGO_HABILITACION`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TIPOPAGO_HABILITACION` (IN `idTipoP` INT(11), IN `codigo` INT(11), IN `creador` INT(11))  NO SQL
BEGIN 

if (codigo=1) then 
  
    UPDATE generalimportes SET Estado_idEstado=4  WHERE idGeneral=idTipoP;
  SET @Mensaje=("TIPO DE PAGO DESHABILITADO");
else 
   UPDATE generalimportes SET Estado_idEstado=1  WHERE  idGeneral=idTipoP;    
 SET  @Mensaje=("TIPO DE PAGO HABILITADO");
end if;

 /* ------ REGISTRO DE BITACORA ------ */

set @usuario=(SELECT u.usuario FROM usuario u  WHERE u.idUsuario=creador);
 

INSERT INTO `bitacora`(`usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (@usuario,@Mensaje,'TIPOPAGO',@Mensaje,NOW());     
 
END$$

DROP PROCEDURE IF EXISTS `SP_TIPOPAGO_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TIPOPAGO_LISTAR` ()  NO SQL
BEGIN 

SELECT g.idGeneral,g.NombrePago,g.Monto,g.Cuotas,g.Estado_idEstado,e.nombreEstado FROM generalimportes g INNER JOIN estado e ON e.idEstado=g.Estado_idEstado;

END$$

DROP PROCEDURE IF EXISTS `SP_TIPOPAGO_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TIPOPAGO_RECUPERAR` (IN `idTipoP` INT(11))  NO SQL
BEGIN 

SELECT * FROM generalimportes tip WHERE tip.idGeneral=idTipoP; 

END$$

DROP PROCEDURE IF EXISTS `SP_TIPOPAGO_REGISTRO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TIPOPAGO_REGISTRO` (IN `NombreP` VARCHAR(100), IN `MontoP` DECIMAL(10,2), IN `CuotaP` INT(11), IN `estadoP` INT(11), IN `creador` INT(11))  NO SQL
BEGIN 
 

INSERT INTO `generalimportes`(`idGeneral`, `NombrePago`, `Monto`, `Cuotas`, `Estado_idEstado`) VALUES (NULL,UPPER(NombreP),MontoP,CuotaP,estadoP);
 
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=creador);


INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'INSERTAR','SE REGISTRO TIPO APGO','TipoPago',NOW()); 

END$$

DROP PROCEDURE IF EXISTS `SP_TIPO_TARJETA_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TIPO_TARJETA_LISTAR` ()  NO SQL
BEGIN 


SELECT * FROM tipotarjeta t where t.Estado_idEstado=1 or t.Estado_idEstado=3;  
END$$

DROP PROCEDURE IF EXISTS `SP_USUARIO_ACTUALIZAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_USUARIO_ACTUALIZAR` (IN `usuarioE` VARCHAR(50), IN `passE` TEXT, IN `idPerfil` INT(11), IN `idEstado` INT(11), IN `idUsuarioU` INT(11), IN `idCreador` INT(11))  NO SQL
BEGIN
 
DECLARE Mensaje VARCHAR(100);

-- ACTUALIZAR USUARIO
if(passE='-1')then  

UPDATE `usuario` SET 		`usuario`=usuarioE,`Perfil_idPerfil`=idPerfil,`Estado_idEstado`=idEstado WHERE  `idUsuario`= idUsuarioU;
set Mensaje="SE ACTUALIZO EL USUARIO:";
        
else 

UPDATE `usuario` SET 		`usuario`=usuarioE,`pass`=passE,`Perfil_idPerfil`=idPerfil,`Estado_idEstado`=idEstado WHERE  `idUsuario`= idUsuarioU;
set Mensaje="SE ACTUALIZO EL USUARIO:";
end if;



-- REGISTRAR BITACORA
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=idCreador);
 
INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ACTUALIZACION','USUARIO',CONCAT(Mensaje,usuarioE),NOW());  
 
 

END$$

DROP PROCEDURE IF EXISTS `SP_USUARIO_HABILITACION`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_USUARIO_HABILITACION` (IN `idUsuarioE` INT(11), IN `codigo` INT(11), IN `idUsuarioM` INT(11))  NO SQL
BEGIN 

SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=idUsuarioM);


if (codigo=1) then 
 	UPDATE `usuario` SET  `Estado_idEstado`=4 WHERE `idUsuario`=idUsuarioE;
  SET @Mensaje=("USUARIO DESHBILITADO");
else 
    UPDATE `usuario` SET  `Estado_idEstado`=1  WHERE `idUsuario`=idUsuarioE;
 SET  @Mensaje=("USAURIO HABILITADO");
end if;

 /* ------ REGISTRO DE BITACORA ------ */

set @usuario=(SELECT u.usuario FROM usuario u  WHERE u.idUsuario=idUsuarioE);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@usuario,@Mensaje,'USUARIO',CONCAT("SE",@Mensaje," :", @NombreUsuario),NOW());    

END$$

DROP PROCEDURE IF EXISTS `SP_USUARIO_LISTAR_TODO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_USUARIO_LISTAR_TODO` ()  NO SQL
BEGIN 

SELECT 
u.idUsuario,
u.usuario,
DATE_FORMAT(u.fechaRegistro,'%d/%m/%Y') as fechaRegistro,
CONCAT(pes.nombrePersona,' ',pes.apellidoPaterno,' ',pes.apellidoMaterno) as NombrePersona,
e.nombreEstado,  
e.idEstado as Estado_idEstado, 
per.nombrePerfil 
FROM usuario u INNER JOIN estado e ON e.idEstado=u.Estado_idEstado INNER JOIN perfil per ON per.idPerfil=u.Perfil_idPerfil INNER JOIN persona pes ON pes.idPersona=u.Persona_idPersona;

END$$

DROP PROCEDURE IF EXISTS `SP_USUARIO_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_USUARIO_RECUPERAR` (IN `idUsuarioE` INT)  NO SQL
BEGIN


SELECT * FROM usuario u WHERE u.idUsuario=idUsuarioE; 


END$$

DROP PROCEDURE IF EXISTS `SP_USUARIO_REGISTRO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_USUARIO_REGISTRO` (IN `usuarioE` VARCHAR(50), IN `passE` TEXT, IN `idPerfil` INT(11), IN `idPersona` INT(11), IN `idEstado` INT(11), IN `idCreador` INT(11))  NO SQL
BEGIN 

DECLARE Mensaje VARCHAR(100);

-- REGISTRO USUARIO --
INSERT INTO `usuario`(`usuario`, `pass`, `Perfil_idPerfil`, `Persona_idPersona`, `Estado_idEstado`, `fechaRegistro`) VALUES (usuarioE,passE,idPerfil,idPersona,idEstado,NOW());
 
set Mensaje="SE REGISTRO EL USUARIO:";
 
 
-- REGISTRAR BITACORA
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=idCreador);
 
INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'REGISTRO','USUARIO',CONCAT(Mensaje,usuarioE),NOW());  
 
END$$

--
-- Funciones
--
DROP FUNCTION IF EXISTS `FU_RECUPERAR_MES`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `FU_RECUPERAR_MES` (`mes` INT(11)) RETURNS VARCHAR(100) CHARSET latin1 NO SQL
BEGIN 

DECLARE mes_regreso VARCHAR(100);

IF(mes=1)THEN
SET mes_regreso="ENERO";
ELSEIF(mes=2)THEN
SET mes_regreso="FEBRERO";
ELSEIF(mes=3)THEN
SET mes_regreso="MARZO";
ELSEIF(mes=4)THEN
SET mes_regreso="ABRIL";
ELSEIF(mes=5)THEN
SET mes_regreso="MAYO";
ELSEIF(mes=6)THEN
SET mes_regreso="JUNIO";
ELSEIF(mes=7)THEN
SET mes_regreso="JULIO";
ELSEIF(mes=8)THEN
SET mes_regreso="AGOSTO";
ELSEIF(mes=9)THEN
SET mes_regreso="SEPTIEMBRE";
ELSEIF(mes=10)THEN
SET mes_regreso="OCTUBRE";
ELSEIF(mes=11)THEN
SET mes_regreso="NOVIEMBRE";
ELSEIF(mes=12)THEN
SET mes_regreso="DICIEMBRE";
END IF;

RETURN mes_regreso;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alumno`
--

DROP TABLE IF EXISTS `alumno`;
CREATE TABLE IF NOT EXISTS `alumno` (
  `idAlumno` int(11) NOT NULL AUTO_INCREMENT,
  `imagen` varchar(150) DEFAULT NULL,
  `Persona_idPersona` int(11) NOT NULL,
  `Nivel_idNivel` int(11) DEFAULT NULL,
  `Grado_idGrado` int(11) DEFAULT NULL,
  `Seccion_idSeccion` int(11) DEFAULT NULL,
  `fechaRegistro` datetime NOT NULL,
  PRIMARY KEY (`idAlumno`),
  KEY `FK_Persona_idPersona` (`Persona_idPersona`),
  KEY `FK_Nivel_idNivel` (`Nivel_idNivel`),
  KEY `FK_Grado_idGrado` (`Grado_idGrado`),
  KEY `FK_Seccion_idSeccion` (`Seccion_idSeccion`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `alumno`
--

INSERT INTO `alumno` (`idAlumno`, `imagen`, `Persona_idPersona`, `Nivel_idNivel`, `Grado_idGrado`, `Seccion_idSeccion`, `fechaRegistro`) VALUES
(4, '47034923/JOSE.jpg', 32, NULL, NULL, NULL, '2018-10-09 02:36:09'),
(5, '12412342/MARIA.jpg', 33, NULL, NULL, NULL, '2018-10-10 20:09:41'),
(6, '32432434/ROMULO.jpg', 35, NULL, NULL, NULL, '2018-10-10 23:48:02'),
(7, '3242343/ROBERTO.jpg', 36, NULL, NULL, NULL, '2018-10-13 11:59:19'),
(8, '32423423/JOAQUIN.jpg', 38, NULL, NULL, NULL, '2018-10-13 12:21:38'),
(9, '47040092/JOAQUIN.jpg', 39, NULL, NULL, NULL, '2018-10-24 19:45:11'),
(10, '23423423/MIGUEL ANGEL.jpg', 40, NULL, NULL, NULL, '2018-10-24 19:46:04'),
(11, '21432112/SANDRA.jpg', 41, NULL, NULL, NULL, '2018-10-24 19:46:29'),
(12, '23234234/MARICIELO.jpg', 42, NULL, NULL, NULL, '2018-10-24 19:46:57'),
(13, '32423432/ROMINA.jpg', 43, NULL, NULL, NULL, '2018-10-24 19:47:24');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alumnopagos`
--

DROP TABLE IF EXISTS `alumnopagos`;
CREATE TABLE IF NOT EXISTS `alumnopagos` (
  `idAlumnoPago` int(11) NOT NULL AUTO_INCREMENT,
  `Alumno_idAlumno` int(11) NOT NULL,
  `year` int(4) DEFAULT NULL,
  `TipoPago_idTipoPago` int(11) NOT NULL,
  `Importe` decimal(10,2) DEFAULT NULL,
  `Diferencia` decimal(10,2) DEFAULT NULL,
  `Mora` decimal(10,2) DEFAULT NULL,
  `Estado_idEstado` int(11) DEFAULT NULL,
  `fechaRegistro` datetime NOT NULL,
  PRIMARY KEY (`idAlumnoPago`),
  KEY `FK_AlumnoPagosImportes` (`TipoPago_idTipoPago`),
  KEY `FK_Alumno_idAlumnoPago` (`Alumno_idAlumno`),
  KEY `FK_ALUMNOSPAGOS` (`Estado_idEstado`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `alumnopagos`
--

INSERT INTO `alumnopagos` (`idAlumnoPago`, `Alumno_idAlumno`, `year`, `TipoPago_idTipoPago`, `Importe`, `Diferencia`, `Mora`, `Estado_idEstado`, `fechaRegistro`) VALUES
(7, 5, 2017, 1, '250.00', '0.00', '0.00', 7, '2018-10-28 09:39:31'),
(8, 5, 2017, 3, '120.00', '0.00', '0.00', 7, '2018-10-28 09:39:31'),
(9, 5, 2017, 4, '100.00', '0.00', '0.00', 7, '2018-10-28 09:39:31'),
(10, 5, 2017, 5, '120.00', '0.00', '0.00', 7, '2018-10-28 09:39:31'),
(11, 5, 2017, 6, '100.00', '0.00', '0.00', 7, '2018-10-28 09:39:31'),
(12, 5, 2017, 7, '200.00', '0.00', '0.00', 7, '2018-10-28 09:39:31'),
(13, 6, 2017, 1, '250.00', '0.00', '0.00', 7, '2018-10-28 09:39:47'),
(14, 6, 2017, 3, '120.00', '0.00', '0.00', 7, '2018-10-28 09:39:47'),
(15, 6, 2017, 4, '100.00', '0.00', '0.00', 7, '2018-10-28 09:39:47'),
(16, 6, 2017, 5, '120.00', '0.00', '0.00', 7, '2018-10-28 09:39:47'),
(17, 6, 2017, 6, '100.00', '0.00', '0.00', 7, '2018-10-28 09:39:47'),
(18, 6, 2017, 7, '200.00', '0.00', '0.00', 7, '2018-10-28 09:39:47'),
(19, 7, 2017, 1, '250.00', '250.00', '0.00', 5, '2018-10-28 09:40:02'),
(20, 7, 2017, 3, '120.00', '120.00', '0.00', 5, '2018-10-28 09:40:02'),
(21, 7, 2017, 4, '100.00', '100.00', '0.00', 5, '2018-10-28 09:40:02'),
(22, 7, 2017, 5, '120.00', '120.00', '0.00', 5, '2018-10-28 09:40:02'),
(23, 8, 2017, 1, '250.00', '0.00', '0.00', 5, '2018-10-28 09:40:17'),
(24, 8, 2017, 3, '120.00', '120.00', '0.00', 5, '2018-10-28 09:40:17'),
(25, 8, 2017, 4, '100.00', '100.00', '0.00', 5, '2018-10-28 09:40:17'),
(26, 8, 2017, 5, '120.00', '120.00', '0.00', 5, '2018-10-28 09:40:17'),
(27, 9, 2017, 1, '250.00', '250.00', '0.00', 5, '2018-10-28 09:40:33'),
(28, 9, 2017, 3, '120.00', '120.00', '0.00', 5, '2018-10-28 09:40:33'),
(29, 9, 2017, 4, '100.00', '100.00', '0.00', 5, '2018-10-28 09:40:33'),
(30, 9, 2017, 5, '120.00', '120.00', '0.00', 5, '2018-10-28 09:40:33'),
(31, 9, 2017, 6, '100.00', '100.00', '0.00', 5, '2018-10-28 09:40:33'),
(32, 10, 2017, 1, '250.00', '250.00', '0.00', 5, '2018-10-28 09:40:45'),
(33, 10, 2017, 3, '120.00', '120.00', '0.00', 5, '2018-10-28 09:40:45'),
(34, 10, 2017, 4, '100.00', '100.00', '0.00', 5, '2018-10-28 09:40:45'),
(35, 10, 2017, 5, '120.00', '120.00', '0.00', 5, '2018-10-28 09:40:45'),
(36, 11, 2017, 1, '250.00', '250.00', '0.00', 5, '2018-10-28 09:40:59'),
(37, 11, 2017, 3, '120.00', '120.00', '0.00', 5, '2018-10-28 09:40:59'),
(38, 11, 2017, 4, '100.00', '100.00', '0.00', 5, '2018-10-28 09:40:59'),
(39, 11, 2017, 5, '120.00', '120.00', '0.00', 5, '2018-10-28 09:40:59'),
(40, 12, 2017, 1, '250.00', '250.00', '0.00', 5, '2018-10-28 09:41:11'),
(41, 12, 2017, 3, '120.00', '120.00', '0.00', 5, '2018-10-28 09:41:11'),
(42, 12, 2017, 4, '100.00', '100.00', '0.00', 5, '2018-10-28 09:41:11'),
(43, 12, 2017, 5, '120.00', '120.00', '0.00', 5, '2018-10-28 09:41:11'),
(44, 13, 2017, 1, '250.00', '250.00', '0.00', 5, '2018-10-28 09:41:24'),
(45, 13, 2017, 3, '120.00', '120.00', '0.00', 5, '2018-10-28 09:41:24'),
(46, 13, 2017, 4, '100.00', '100.00', '0.00', 5, '2018-10-28 09:41:24'),
(47, 13, 2017, 5, '120.00', '120.00', '0.00', 5, '2018-10-28 09:41:24'),
(48, 4, 2018, 1, '250.00', '0.00', '0.00', 7, '2018-10-28 17:32:18'),
(49, 4, 2018, 3, '120.00', '0.00', '0.00', 7, '2018-10-28 17:32:18'),
(50, 4, 2018, 4, '100.00', '0.00', '0.00', 7, '2018-10-28 17:32:18'),
(51, 4, 2018, 5, '120.00', '0.00', '0.00', 7, '2018-10-28 17:32:18'),
(52, 4, 2018, 6, '100.00', '0.00', '0.00', 7, '2018-10-28 17:32:18'),
(53, 5, 2018, 1, '250.00', '0.00', '0.00', 7, '2018-10-28 17:32:34'),
(54, 5, 2018, 3, '120.00', '0.00', '0.00', 7, '2018-10-28 17:32:34'),
(55, 5, 2018, 4, '100.00', '0.00', '0.00', 7, '2018-10-28 17:32:34'),
(56, 5, 2018, 5, '120.00', '0.00', '0.00', 7, '2018-10-28 17:32:34'),
(57, 5, 2018, 6, '100.00', '0.00', '0.00', 7, '2018-10-28 17:32:34'),
(58, 6, 2018, 1, '250.00', '250.00', '0.00', 5, '2018-10-28 17:32:50'),
(59, 6, 2018, 3, '120.00', '120.00', '0.00', 5, '2018-10-28 17:32:50'),
(60, 6, 2018, 4, '100.00', '100.00', '0.00', 5, '2018-10-28 17:32:50'),
(61, 6, 2018, 5, '120.00', '120.00', '0.00', 5, '2018-10-28 17:32:50'),
(62, 6, 2018, 6, '100.00', '100.00', '0.00', 5, '2018-10-28 17:32:50'),
(63, 7, 2018, 1, '250.00', '250.00', '0.00', 5, '2018-10-30 19:44:33'),
(64, 7, 2018, 3, '120.00', '120.00', '0.00', 5, '2018-10-30 19:44:33'),
(65, 7, 2018, 4, '100.00', '100.00', '0.00', 5, '2018-10-30 19:44:33'),
(66, 7, 2018, 5, '120.00', '120.00', '0.00', 5, '2018-10-30 19:44:33'),
(67, 8, 2018, 1, '250.00', '250.00', '0.00', 5, '2018-10-31 05:21:52'),
(68, 8, 2018, 3, '120.00', '120.00', '0.00', 5, '2018-10-31 05:21:52'),
(69, 8, 2018, 4, '100.00', '100.00', '0.00', 5, '2018-10-31 05:21:52'),
(70, 8, 2018, 5, '120.00', '120.00', '0.00', 5, '2018-10-31 05:21:52'),
(71, 4, 2017, 1, '250.00', '0.00', '0.00', 7, '2018-10-31 05:22:00'),
(72, 4, 2017, 3, '120.00', '0.00', '0.00', 7, '2018-10-31 05:22:00'),
(73, 4, 2017, 4, '100.00', '0.00', '0.00', 7, '2018-10-31 05:22:00'),
(74, 4, 2017, 5, '120.00', '0.00', '0.00', 7, '2018-10-31 05:22:00'),
(75, 4, 2017, 6, '100.00', '0.00', '0.00', 7, '2018-10-31 05:22:00'),
(76, 4, 2017, 7, '200.00', '0.00', '0.00', 7, '2018-10-31 05:22:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `apoderado`
--

DROP TABLE IF EXISTS `apoderado`;
CREATE TABLE IF NOT EXISTS `apoderado` (
  `idApoderado` int(11) NOT NULL AUTO_INCREMENT,
  `Persona_idPersona` int(11) NOT NULL,
  `TipoTarjeta_idTipoTarjeta` int(11) DEFAULT NULL,
  `Detalle` varchar(150) DEFAULT NULL,
  `fechaRegistro` datetime NOT NULL,
  PRIMARY KEY (`idApoderado`),
  KEY `FK_Persona_idPersonaApo` (`Persona_idPersona`),
  KEY `FK_TipoTarjeta_idTipoTarjeta` (`TipoTarjeta_idTipoTarjeta`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `apoderado`
--

INSERT INTO `apoderado` (`idApoderado`, `Persona_idPersona`, `TipoTarjeta_idTipoTarjeta`, `Detalle`, `fechaRegistro`) VALUES
(1, 34, NULL, NULL, '2018-10-10 20:26:35'),
(2, 37, 1, 'PAGO DE VISA', '2018-10-13 12:09:06');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bitacora`
--

DROP TABLE IF EXISTS `bitacora`;
CREATE TABLE IF NOT EXISTS `bitacora` (
  `idBitacora` int(11) NOT NULL AUTO_INCREMENT,
  `usuarioAccion` varchar(100) NOT NULL,
  `Accion` varchar(100) NOT NULL,
  `tablaAccion` varchar(100) NOT NULL,
  `Detalle` text NOT NULL,
  `fechaRegistro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idBitacora`)
) ENGINE=InnoDB AUTO_INCREMENT=483 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `bitacora`
--

INSERT INTO `bitacora` (`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`, `Detalle`, `fechaRegistro`) VALUES
(1, 'JESUS INCA CARDENAS', 'INSERTAR', 'USUARIO', 'SE REGISTRO EL USUARIO:admin3', '2018-09-29 19:53:29'),
(2, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:usuaricambia', '2018-09-29 19:56:41'),
(3, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-09-29 20:00:24'),
(4, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:nuevo', '2018-09-29 20:01:47'),
(5, 'JESUS INCA CARDENAS', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :admin', '2018-10-03 00:56:59'),
(6, 'JESUS INCA CARDENAS', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :admin', '2018-10-03 01:04:58'),
(7, 'JESUS INCA CARDENAS', 'USAURIO HABILITADO', 'USUARIO', 'SEUSAURIO HABILITADO :admin', '2018-10-03 01:09:40'),
(8, 'JESUS INCA CARDENAS', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :admin', '2018-10-03 01:09:44'),
(9, 'JESUS INCA CARDENAS', 'USAURIO HABILITADO', 'USUARIO', 'SEUSAURIO HABILITADO :admin', '2018-10-03 01:09:47'),
(10, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE REGISTRO EL USUARIO:wdqw', '2018-10-03 02:00:09'),
(11, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE REGISTRO EL USUARIO:msilva', '2018-10-04 13:29:08'),
(12, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE REGISTRO EL USUARIO:JLOPEZ', '2018-10-04 13:35:15'),
(13, 'MAJE SILVA SILVA', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :JLOPEZ', '2018-10-04 13:35:27'),
(14, 'MAJE SILVA SILVA', 'USAURIO HABILITADO', 'USUARIO', 'SEUSAURIO HABILITADO :JLOPEZ', '2018-10-04 13:35:36'),
(15, 'MAJE SILVA SILVA', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :JLOPEZ', '2018-10-04 13:35:40'),
(16, 'MAJE SILVA SILVA', 'USAURIO HABILITADO', 'USUARIO', 'SEUSAURIO HABILITADO :JLOPEZ', '2018-10-04 13:35:42'),
(17, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 16:38:33'),
(18, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:msilva2', '2018-10-04 16:39:27'),
(19, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 16:45:08'),
(20, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 16:45:17'),
(21, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 16:45:47'),
(22, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 16:46:08'),
(23, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba3', '2018-10-04 16:47:16'),
(24, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba1', '2018-10-04 16:47:56'),
(25, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba1', '2018-10-04 16:48:23'),
(26, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba3', '2018-10-04 16:50:18'),
(27, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba3', '2018-10-04 16:51:20'),
(28, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin2', '2018-10-04 16:52:32'),
(29, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba3', '2018-10-04 16:55:17'),
(30, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba3', '2018-10-04 16:55:33'),
(31, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba3', '2018-10-04 16:55:53'),
(32, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 16:56:02'),
(33, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 16:56:09'),
(34, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 16:56:32'),
(35, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 16:58:27'),
(36, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 16:59:13'),
(37, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 17:01:09'),
(38, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 17:03:37'),
(39, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 17:04:28'),
(40, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 17:04:43'),
(41, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 17:05:07'),
(42, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 17:05:52'),
(43, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-04 17:06:14'),
(44, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:07:12'),
(45, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:08:37'),
(46, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:09:29'),
(47, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:10:33'),
(48, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:11:14'),
(49, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:12:14'),
(50, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:12:22'),
(51, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:13:03'),
(52, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:13:14'),
(53, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:14:09'),
(54, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:14:50'),
(55, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:14:50'),
(56, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:15:39'),
(57, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:15:47'),
(58, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba', '2018-10-04 17:17:05'),
(59, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin2', '2018-10-04 17:19:14'),
(60, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin2', '2018-10-04 17:19:43'),
(61, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin2', '2018-10-04 17:22:44'),
(62, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin2', '2018-10-04 17:23:08'),
(63, 'LUCIA TABOADA GUZMAN', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin2', '2018-10-04 17:24:49'),
(64, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 17:29:52'),
(65, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 17:31:53'),
(66, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 17:32:14'),
(67, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 17:48:50'),
(68, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 17:49:27'),
(69, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 17:53:16'),
(70, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 17:54:56'),
(71, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 17:55:24'),
(72, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 17:56:52'),
(73, 'MAJE SILVA SILVA', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 18:00:31'),
(74, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 18:03:17'),
(75, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 18:04:41'),
(76, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:admin', '2018-10-04 18:06:15'),
(77, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-05 10:02:27'),
(78, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE REGISTRO EL USUARIO:persona', '2018-10-05 10:14:26'),
(79, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE REGISTRO EL USUARIO:persona2', '2018-10-05 10:16:34'),
(80, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE REGISTRO EL USUARIO:prueba', '2018-10-05 10:17:48'),
(81, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE REGISTRO EL USUARIO:prueba1', '2018-10-05 10:18:17'),
(82, 'JESUS INCA CARDENAS', 'ACTUALIZO', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba2', '2018-10-05 10:39:30'),
(83, 'JESUS INCA CARDENAS', 'INSERTAR', 'Persona', 'SE REGISTRO PERSONA:jesu werfwe fefwe', '2018-10-05 10:51:36'),
(84, 'JESUS INCA CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:jesus inca cardenas', '2018-10-05 11:11:11'),
(85, 'JESUS INCA CARDENAS', 'REGISTRO', 'Persona', 'SE REGISTRO PERSONA:wfwefwe werfwef frefwef', '2018-10-05 12:48:34'),
(86, 'JESUS INCA CARDENAS', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :admin', '2018-10-05 13:36:40'),
(87, 'JESUS INCA CARDENAS', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :admin', '2018-10-05 13:36:46'),
(88, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :JESUS INCA CARDENAS', '2018-10-05 13:38:27'),
(89, 'admin', 'PERSONA HABILITADO', 'USUARIO', 'SEPERSONA HABILITADO :JESUS INCA CARDENAS', '2018-10-05 13:38:30'),
(90, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :JESUS INCA CARDENAS', '2018-10-05 13:38:32'),
(91, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :LUCIA TABOADA GUZMAN', '2018-10-05 13:59:32'),
(92, 'admin', 'PERSONA HABILITADO', 'USUARIO', 'SEPERSONA HABILITADO :JESUS INCA CARDENAS', '2018-10-05 14:00:13'),
(93, 'JESUS23 INCA23 CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:JESUS23 INCA23 CARDENAS', '2018-10-05 14:42:15'),
(94, 'JESUS233 INCA233 CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:JESUS233 INCA233 CARDENAS', '2018-10-05 14:43:49'),
(95, 'JESUS23331 INCA23314 CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:JESUS23331 INCA23314 CARDENAS', '2018-10-05 14:45:17'),
(96, 'JESUS23331 INCA23314 CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:JESUS23331 INCA23314 CARDENAS', '2018-10-05 14:46:03'),
(97, 'JESUS INCA CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:JESUS INCA CARDENAS', '2018-10-05 14:48:34'),
(98, 'JESUS2 INCA2 CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:JESUS2 INCA2 CARDENAS', '2018-10-05 14:49:29'),
(99, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :JESUS2 INCA2 CARDENAS', '2018-10-05 14:49:35'),
(100, 'JESUS2 INCA2 CARDENAS', 'INSERTAR', 'SE REGISTRO PERFIL', 'Perfil', '2018-10-05 15:42:18'),
(101, 'JESUS2 INCA2 CARDENAS', 'INSERTAR', 'SE REGISTRO PERMISOS DE PERFIL', 'Permisos', '2018-10-05 15:42:18'),
(102, 'JESUS2 INCA2 CARDENAS', 'INSERTAR', 'SE REGISTRO PERFIL', 'Perfil', '2018-10-05 15:42:43'),
(103, 'JESUS2 INCA2 CARDENAS', 'INSERTAR', 'SE REGISTRO PERMISOS DE PERFIL', 'Permisos', '2018-10-05 15:42:43'),
(104, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :MAJE SILVA SILVA', '2018-10-05 15:42:51'),
(105, 'admin', 'ACTUALIZACION', 'Perfil', 'SE ACTUALIZO PERFIL:fweefw', '2018-10-05 15:53:04'),
(106, 'admin', 'ACTUALIZACION', 'Perfil', 'SE ACTUALIZO PERFIL:ADMINISTRADOR', '2018-10-05 15:53:22'),
(107, 'admin', 'ACTUALIZACION', 'Perfil', 'SE ACTUALIZO PERFIL:wefwefew', '2018-10-05 15:54:03'),
(108, 'admin', 'ACTUALIZACION', 'Perfil', 'SE ACTUALIZO PERFIL:wfgwf', '2018-10-05 15:54:11'),
(109, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :JESUS2 INCA2 CARDENAS', '2018-10-05 15:56:36'),
(110, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :JESUS2 INCA2 CARDENAS', '2018-10-05 15:56:44'),
(111, 'admin', 'PERFIL DESHBILITADO', 'PERFIL', 'SEPERFIL DESHBILITADO :ADMINISTRADOR', '2018-10-05 16:02:49'),
(112, 'admin', 'PERFIL HABILITADO', 'PERFIL', 'SEPERFIL HABILITADO :ADMINISTRADOR', '2018-10-05 16:03:01'),
(113, 'admin', 'PERFIL HABILITADO', 'PERFIL', 'SEPERFIL HABILITADO :wefwefew', '2018-10-05 16:03:02'),
(114, 'admin', 'PERFIL HABILITADO', 'PERFIL', 'SEPERFIL HABILITADO :wfgwf', '2018-10-05 16:03:05'),
(115, 'JESUS2 INCA2 CARDENAS', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jinca', '2018-10-05 20:43:36'),
(116, 'JESUS2 INCA2 CARDENAS', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jlopez', '2018-10-05 20:52:52'),
(117, 'JESUS2 INCA2 CARDENAS', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:prueba', '2018-10-05 20:54:56'),
(118, 'admin', 'USAURIO HABILITADO', 'USUARIO', 'SEUSAURIO HABILITADO :JESUS2 INCA2 CARDENAS', '2018-10-05 21:09:26'),
(119, 'JESUS2 INCA2 CARDENAS', 'ACTUALIZACION', 'USUARIO', 'SE ACTUALIZO EL USUARIO:prueba3', '2018-10-05 21:11:21'),
(120, 'admin', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :JESUS2 INCA2 CARDENAS', '2018-10-05 21:51:00'),
(121, 'admin', 'USAURIO HABILITADO', 'USUARIO', 'SEUSAURIO HABILITADO :JESUS2 INCA2 CARDENAS', '2018-10-05 21:51:06'),
(122, 'JESUS2 INCA2 CARDENAS', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jesus', '2018-10-06 12:46:55'),
(123, 'JESUS2 INCA2 CARDENAS', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jesusinca', '2018-10-06 12:56:12'),
(124, 'JESUS2 INCA2 CARDENAS', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:test', '2018-10-06 16:19:49'),
(125, 'prueba inca fwef', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:test2', '2018-10-06 16:34:20'),
(126, 'prueba inca fwef', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:test3', '2018-10-06 16:34:40'),
(127, 'rtjtyjty yjhrtyj tyjtyj', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:test10', '2018-10-06 16:44:45'),
(128, 'rtjtyjty yjhrtyj tyjtyj', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:test20', '2018-10-06 16:46:13'),
(129, 'rtjtyjty yjhrtyj tyjtyj', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:test30', '2018-10-06 16:47:40'),
(130, 'rtjtyjty yjhrtyj tyjtyj', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:test40', '2018-10-06 16:49:24'),
(131, 'rtjtyjty yjhrtyj tyjtyj', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:test50', '2018-10-06 16:50:10'),
(132, 'JESUS2 INCA2 CARDENAS', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:prueba', '2018-10-06 17:06:26'),
(133, 'LUCIA TABOADA GUZMAN', 'INSERTAR', 'SE REGISTRO PERFIL', 'Perfil', '2018-10-07 11:50:05'),
(134, 'LUCIA TABOADA GUZMAN', 'INSERTAR', 'SE REGISTRO PERMISOS DE PERFIL', 'Permisos', '2018-10-07 11:50:05'),
(135, 'prueba', 'PERFIL DESHABILITADO', 'PERFIL', 'SEPERFIL DESHABILITADO :INVITADO', '2018-10-07 11:53:24'),
(136, 'prueba', 'PERFIL HABILITADO', 'PERFIL', 'SEPERFIL HABILITADO :NUEVO', '2018-10-07 11:53:27'),
(137, 'prueba', 'PERFIL HABILITADO', 'PERFIL', 'SEPERFIL HABILITADO :INVITADO', '2018-10-07 11:53:29'),
(138, 'LUCIA TABOADA GUZMAN', 'INSERTAR', 'SE REGISTRO PERFIL', 'Perfil', '2018-10-07 11:54:28'),
(139, 'LUCIA TABOADA GUZMAN', 'INSERTAR', 'SE REGISTRO PERMISOS DE PERFIL', 'Permisos', '2018-10-07 11:54:28'),
(140, 'prueba', 'PERFIL DESHABILITADO', 'PERFIL', 'SEPERFIL DESHABILITADO :USUARIO', '2018-10-07 11:54:34'),
(141, 'prueba', 'PERFIL HABILITADO', 'PERFIL', 'SEPERFIL HABILITADO :USUARIO', '2018-10-07 11:54:36'),
(142, 'prueba', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :LUCIA TABOADA GUZMAN', '2018-10-07 11:59:20'),
(143, 'prueba', 'USAURIO HABILITADO', 'USUARIO', 'SEUSAURIO HABILITADO :LUCIA TABOADA GUZMAN', '2018-10-07 11:59:22'),
(144, 'prueba', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :LUCIA TABOADA GUZMAN', '2018-10-07 11:59:24'),
(145, 'prueba', 'USAURIO HABILITADO', 'USUARIO', 'SEUSAURIO HABILITADO :LUCIA TABOADA GUZMAN', '2018-10-07 11:59:26'),
(146, 'JESUS INCA CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:JESUS INCA CARDENAS', '2018-10-07 12:11:52'),
(147, 'admin', 'USUARIO DESHBILITADO', 'USUARIO', 'SEUSUARIO DESHBILITADO :JESUS INCA CARDENAS', '2018-10-07 12:12:41'),
(148, 'admin', 'USAURIO HABILITADO', 'USUARIO', 'SEUSAURIO HABILITADO :JESUS INCA CARDENAS', '2018-10-07 12:12:43'),
(149, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :JESUS INCA CARDENAS', '2018-10-07 12:12:56'),
(150, 'admin', 'PERSONA HABILITADO', 'USUARIO', 'SEPERSONA HABILITADO :JESUS INCA CARDENAS', '2018-10-07 12:12:58'),
(151, 'JESUS INCA CARDENAS', 'REGISTRO', 'Persona', 'SE REGISTRO PERSONA:PERSONA APELLIDO1 APELLIDO2', '2018-10-07 12:13:51'),
(152, 'JESUS INCA CARDENAS', 'REGISTRO', 'Persona', 'SE REGISTRO PERSONA:prueba apellido uno apellido dos', '2018-10-07 12:38:20'),
(153, 'JESUS INCA CARDENAS', 'REGISTRO', 'Persona', 'SE REGISTRO PERSONA:prueba apepa apema', '2018-10-07 12:39:47'),
(154, 'JESUS INCA CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:prueba apepa apema', '2018-10-07 12:39:59'),
(155, 'JESUS INCA CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:prueba apepa apema', '2018-10-07 12:41:04'),
(156, 'JESUS INCA CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:prueba apepa apema', '2018-10-07 12:41:16'),
(157, 'JESUS INCA CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:prueba apepa apema', '2018-10-07 12:41:22'),
(158, 'JESUS INCA CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:prueba apepa apema', '2018-10-07 12:41:28'),
(159, 'JESUS INCA CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:prueba apepa apema', '2018-10-07 12:41:37'),
(160, 'JESUS INCA CARDENAS', 'REGISTRO', 'Persona', 'SE REGISTRO PERSONA:feeqfwe ewfwef wefwef', '2018-10-07 18:35:21'),
(161, 'JESUS INCA CARDENAS', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:feeqfwe ewfwef wefwef', '2018-10-07 18:35:31'),
(162, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :feeqfwe ewfwef wefwef', '2018-10-07 18:35:51'),
(163, 'admin', 'PERSONA HABILITADO', 'USUARIO', 'SEPERSONA HABILITADO :feeqfwe ewfwef wefwef', '2018-10-07 18:35:53'),
(164, 'admin', 'ACTUALIZACION', 'Perfil', 'SE ACTUALIZO PERFIL:USUARIO', '2018-10-07 19:32:06'),
(165, 'JESUS INCA CARDENAS', 'INSERTAR', 'SE REGISTRO PERFIL', 'Perfil', '2018-10-07 20:14:07'),
(166, 'JESUS INCA CARDENAS', 'INSERTAR', 'SE REGISTRO PERMISOS DE PERFIL', 'Permisos', '2018-10-07 20:14:07'),
(167, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:ADMINISTRADOR', '2018-10-07 22:43:04'),
(168, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:ADMINISTRADOR', '2018-10-07 22:44:38'),
(169, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:ADMINISTRADOR', '2018-10-07 22:46:43'),
(170, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:ADMINISTRADOR', '2018-10-07 22:48:24'),
(171, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:ADMINISTRADOR', '2018-10-07 22:48:30'),
(172, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:USUARIO', '2018-10-07 22:48:47'),
(173, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:ADMINISTRADOR', '2018-10-07 22:49:01'),
(174, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:ADMINISTRADOR', '2018-10-07 22:53:20'),
(175, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:USUARIO', '2018-10-07 22:53:35'),
(176, 'JESUS INCA CARDENAS', 'INSERTAR', 'SE REGISTRO PERFIL', 'Perfil', '2018-10-08 00:59:45'),
(177, 'JESUS INCA CARDENAS', 'INSERTAR', 'SE REGISTRO PERMISOS DE PERFIL', 'Permisos', '2018-10-08 00:59:45'),
(178, 'admin', 'ACTUALIZACION', 'Perfil', 'SE ACTUALIZO PERFIL:EMPLEADO', '2018-10-08 01:00:20'),
(179, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:EMPLEADO', '2018-10-08 01:00:55'),
(180, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:APODERADO', '2018-10-08 01:01:12'),
(181, 'JESUS INCA CARDENAS', 'INSERTAR', 'SE REGISTRO PERFIL', 'Perfil', '2018-10-08 01:02:02'),
(182, 'JESUS INCA CARDENAS', 'INSERTAR', 'SE REGISTRO PERMISOS DE PERFIL', 'Permisos', '2018-10-08 01:02:02'),
(183, 'admin', 'SE ACTUALIZO PERMISOS', 'PERMISOS', 'SE ACTUALIZO PERMISOS DE PERFIL:ENCARGADO', '2018-10-08 01:02:19'),
(184, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:ADMINISTRADOR GENERAL DEL SISTEMA', '2018-10-08 01:09:25'),
(185, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Persona', 'SE REGISTRO PERSONA:Jesus Inca Cardenas', '2018-10-08 01:22:56'),
(186, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jinca', '2018-10-08 01:23:23'),
(187, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jinca', '2018-10-08 01:24:11'),
(188, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jinca', '2018-10-08 01:25:04'),
(189, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TIPO DE TARJETA DE PAGO', 'TipoTarjeta', '2018-10-08 02:07:43'),
(190, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TIPO DE TARJETA DE PAGO', 'TipoTarjeta', '2018-10-08 02:09:08'),
(191, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TIPO DE TARJETA DE PAGO', 'TipoTarjeta', '2018-10-08 02:12:44'),
(192, 'admin', 'TIPO DE TARJETA DESHABILITADO', 'PERFIL', 'TIPO DE TARJETA DESHABILITADO :TARJETA PRUEBA3', '2018-10-08 02:14:07'),
(193, 'admin', 'TIPO DE TARJETA HABILITADO', 'PERFIL', 'TIPO DE TARJETA HABILITADO :TARJETA PRUEBA3', '2018-10-08 02:14:09'),
(194, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TIPO DE TARJETA DE PAGO', 'TipoTarjeta', '2018-10-08 02:14:19'),
(195, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TIPO DE TARJETA DE PAGO', 'TipoTarjeta', '2018-10-08 02:14:26'),
(196, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TIPO DE TARJETA DE PAGO', 'TipoTarjeta', '2018-10-08 02:15:38'),
(197, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TIPO DE TARJETA DE PAGO', 'TipoTarjeta', '2018-10-08 02:17:28'),
(198, 'admin', 'ACTUALIZACION', 'TipoTarjeta', 'SE ACTUALIZO TIPO TARJETA:TIPO PRUEBA2', '2018-10-08 02:25:35'),
(199, 'admin', 'ACTUALIZACION', 'TipoTarjeta', 'SE ACTUALIZO TIPO TARJETA:TIPO PRUEBA', '2018-10-08 02:25:42'),
(200, 'admin', 'TIPO DE TARJETA DESHABILITADO', 'PERFIL', 'TIPO DE TARJETA DESHABILITADO :TIPO PRUEBA', '2018-10-08 02:25:47'),
(201, 'admin', 'TIPO DE TARJETA HABILITADO', 'PERFIL', 'TIPO DE TARJETA HABILITADO :TIPO PRUEBA', '2018-10-08 02:25:49'),
(202, 'admin', 'NIVEL DESHABILITADO', 'NIVEL', 'NIVEL DESHABILITADO :SECUNDARIA', '2018-10-08 03:01:02'),
(203, 'admin', 'NIVEL HABILITADO', 'NIVEL', 'NIVEL HABILITADO :SECUNDARIA', '2018-10-08 03:01:05'),
(204, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO NIVEL', 'NIVEL', '2018-10-08 03:01:19'),
(205, 'admin', 'ACTUALIZACION', 'Nivel', 'SE ACTUALIZO NIVEL:NOCTURNO2', '2018-10-08 03:01:28'),
(206, 'admin', 'ACTUALIZACION', 'Nivel', 'SE ACTUALIZO NIVEL:NOCTURNO3', '2018-10-08 03:02:19'),
(207, 'admin', 'ACTUALIZACION', 'Nivel', 'SE ACTUALIZO NIVEL:NOCTURNO3', '2018-10-08 03:02:31'),
(208, 'admin', 'NIVEL DESHABILITADO', 'NIVEL', 'NIVEL DESHABILITADO :SECUNDARIA', '2018-10-08 03:06:25'),
(209, 'admin', 'NIVEL HABILITADO', 'NIVEL', 'NIVEL HABILITADO :SECUNDARIA', '2018-10-08 03:06:27'),
(210, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO NIVEL', 'NIVEL', '2018-10-08 03:06:36'),
(211, 'admin', 'ACTUALIZACION', 'Nivel', 'SE ACTUALIZO NIVEL:aaaaa', '2018-10-08 03:06:50'),
(212, 'admin', 'ACTUALIZACION', 'Nivel', 'SE ACTUALIZO NIVEL:SECUNDARIA2', '2018-10-08 03:08:30'),
(213, 'admin', 'ACTUALIZACION', 'Nivel', 'SE ACTUALIZO NIVEL:SECUNDARIA2', '2018-10-08 03:09:27'),
(214, 'admin', 'ACTUALIZACION', 'Nivel', 'SE ACTUALIZO NIVEL:SECUNDARIA2', '2018-10-08 03:09:40'),
(215, 'admin', 'ACTUALIZACION', 'Nivel', 'SE ACTUALIZO NIVEL:SECUNDARIA2', '2018-10-08 03:10:46'),
(216, 'admin', 'ACTUALIZACION', 'Nivel', 'SE ACTUALIZO NIVEL:PRIMARIA', '2018-10-08 03:10:55'),
(217, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO NIVEL', 'NIVEL', '2018-10-08 03:11:07'),
(218, 'admin', 'ACTUALIZACION', 'Nivel', 'SE ACTUALIZO NIVEL:SECUNDARIA', '2018-10-08 03:11:14'),
(219, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO NIVEL', 'NIVEL', '2018-10-08 03:11:32'),
(220, 'admin', 'GRADO DESHABILITADO', 'GRADO', 'GRADO DESHABILITADO :A', '2018-10-08 03:24:37'),
(221, 'admin', 'GRADO HABILITADO', 'GRADO', 'GRADO HABILITADO :A', '2018-10-08 03:24:44'),
(222, 'admin', 'GRADO DESHABILITADO', 'GRADO', 'GRADO DESHABILITADO :A', '2018-10-08 03:24:48'),
(223, 'admin', 'GRADO HABILITADO', 'GRADO', 'GRADO HABILITADO :A', '2018-10-08 03:24:51'),
(224, 'admin', 'GRADO DESHABILITADO', 'GRADO', 'GRADO DESHABILITADO :K', '2018-10-08 03:24:53'),
(225, 'admin', 'GRADO HABILITADO', 'GRADO', 'GRADO HABILITADO :K', '2018-10-08 03:24:56'),
(226, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO GRADO', 'GRADO', '2018-10-08 03:25:09'),
(227, 'admin', 'ACTUALIZACION', 'GRADO', 'SE ACTUALIZO GRADO:NUEVO GRADO2', '2018-10-08 03:25:19'),
(228, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 03:40:08'),
(229, 'admin', 'SECCION DESHABILITADO', 'SECCION', 'SECCION DESHABILITADO :A', '2018-10-08 03:40:11'),
(230, 'admin', 'SECCION HABILITADO', 'SECCION', 'SECCION HABILITADO :A', '2018-10-08 03:40:18'),
(231, 'admin', 'ACTUALIZACION', 'SECCION', 'SE ACTUALIZO SECCION:AA', '2018-10-08 03:40:23'),
(232, 'admin', 'ACTUALIZACION', 'SECCION', 'SE ACTUALIZO SECCION:A', '2018-10-08 03:40:31'),
(233, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 03:40:39'),
(234, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 03:40:45'),
(235, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 03:40:51'),
(236, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 03:40:58'),
(237, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 03:41:04'),
(238, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 03:41:10'),
(239, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 03:41:17'),
(240, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO GRADO', 'GRADO', '2018-10-08 03:42:13'),
(241, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO GRADO', 'GRADO', '2018-10-08 03:42:24'),
(242, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO GRADO', 'GRADO', '2018-10-08 03:42:34'),
(243, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO GRADO', 'GRADO', '2018-10-08 03:42:45'),
(244, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO GRADO', 'GRADO', '2018-10-08 03:42:57'),
(245, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO GRADO', 'GRADO', '2018-10-08 03:43:10'),
(246, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO GRADO', 'GRADO', '2018-10-08 03:45:21'),
(247, 'admin', 'SECCION DESHABILITADO', 'SECCION', 'SECCION DESHABILITADO :C', '2018-10-08 05:25:02'),
(248, 'admin', 'SECCION HABILITADO', 'SECCION', 'SECCION HABILITADO :C', '2018-10-08 05:25:04'),
(249, 'admin', 'SECCION HABILITADO', 'SECCION', 'SECCION HABILITADO :C', '2018-10-08 05:25:05'),
(250, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 05:25:34'),
(251, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 05:25:40'),
(252, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 05:25:45'),
(253, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 05:25:50'),
(254, 'admin', 'ACTUALIZACION', 'SECCION', 'SE ACTUALIZO SECCION:C', '2018-10-08 05:26:01'),
(255, 'admin', 'ACTUALIZACION', 'SECCION', 'SE ACTUALIZO SECCION:D', '2018-10-08 05:26:07'),
(256, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 05:26:14'),
(257, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 05:26:23'),
(258, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO SECCION', 'SECCION', '2018-10-08 05:26:30'),
(259, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Persona', 'SE REGISTRO PERSONA:vwefv wevwe vwev', '2018-10-08 12:34:12'),
(260, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:vwefv wevwe vwev COMO ALUMNO NUEVO', '2018-10-08 12:34:12'),
(261, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Persona', 'SE REGISTRO PERSONA:ewfwe wef wefwe', '2018-10-08 12:34:59'),
(262, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:ewfwe wef wefwe COMO ALUMNO NUEVO', '2018-10-08 12:34:59'),
(263, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Persona', 'SE REGISTRO PERSONA:jesusin incae carfew', '2018-10-08 12:56:02'),
(264, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:jesusin incae carfew COMO ALUMNO NUEVO', '2018-10-08 12:56:02'),
(265, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:EWFWE WEF WEFWE', '2018-10-08 18:28:32'),
(266, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JESUSINDD INCAEDD CARFEWDD', '2018-10-08 18:28:56'),
(267, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :EWFWE WEF WEFWE', '2018-10-08 18:49:37'),
(268, 'admin', 'PERSONA HABILITADO', 'USUARIO', 'SEPERSONA HABILITADO :EWFWE WEF WEFWE', '2018-10-08 18:49:40'),
(269, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :JESUSINDD INCAEDD CARFEWDD', '2018-10-08 18:49:45'),
(270, 'admin', 'PERSONA HABILITADO', 'USUARIO', 'SEPERSONA HABILITADO :JESUSINDD INCAEDD CARFEWDD', '2018-10-08 18:49:47'),
(271, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :EWFWE WEF WEFWE', '2018-10-08 18:49:49'),
(272, 'admin', 'PERSONA HABILITADO', 'USUARIO', 'SEPERSONA HABILITADO :EWFWE WEF WEFWE', '2018-10-08 18:49:51'),
(273, 'admin', 'TIPO DE TARJETA DESHABILITADO', 'PERFIL', 'TIPO DE TARJETA DESHABILITADO :TARJETA DINNER CLUB', '2018-10-08 22:12:39'),
(274, 'admin', 'TIPO DE TARJETA HABILITADO', 'PERFIL', 'TIPO DE TARJETA HABILITADO :TARJETA DINNER CLUB', '2018-10-08 22:13:00'),
(275, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Persona', 'SE REGISTRO APODERADO:eeee eeeeee eeee', '2018-10-08 22:50:40'),
(276, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:ADMINISTRADOR GENERAL DEL SISTEMA', '2018-10-08 22:58:54'),
(277, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Persona', 'SE ACTUALIZO PERSONA:ADMINISTRADOR GENERAL DEL SISTEMA', '2018-10-08 22:59:03'),
(278, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :EEEE EEEEEE EEEE', '2018-10-08 23:03:35'),
(279, 'admin', 'PERSONA HABILITADO', 'USUARIO', 'SEPERSONA HABILITADO :EEEE EEEEEE EEEE', '2018-10-08 23:03:37'),
(280, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Apoderado', 'SE ACTUALIZO Apoderado:EEEE EEEEEE EEEE', '2018-10-08 23:06:12'),
(281, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Apoderado', 'SE ACTUALIZO Apoderado:EEEEd EEEEEEd EEEEd', '2018-10-08 23:06:22'),
(282, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:alumno prueba prueba COMO ALUMNO NUEVO', '2018-10-09 02:36:09'),
(283, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:sergio inca cardenas COMO ALUMNO NUEVO', '2018-10-10 20:09:41'),
(284, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Persona', 'SE REGISTRO APODERADO:papa apellido p apellid m', '2018-10-10 20:26:35'),
(285, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ELIMINAR', 'Relacion', 'SE QUITO RELACION', '2018-10-10 23:37:42'),
(286, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ELIMINAR', 'Relacion', 'SE QUITO RELACION', '2018-10-10 23:41:10'),
(287, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:alumnoPrueba qfqw qwfqwf COMO ALUMNO NUEVO', '2018-10-10 23:48:02'),
(288, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Relacion', 'SE AGREGO ALUMNO:6 A APODERADO:1', '2018-10-10 23:53:58'),
(289, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ELIMINAR', 'Relacion', 'SE QUITO RELACION', '2018-10-10 23:54:17'),
(290, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ELIMINAR', 'Relacion', 'SE QUITO RELACION', '2018-10-10 23:54:22'),
(291, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ELIMINAR', 'Relacion', 'SE QUITO RELACION', '2018-10-10 23:58:17'),
(292, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ELIMINAR', 'Relacion', 'SE QUITO RELACION', '2018-10-10 23:58:19'),
(293, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ELIMINAR', 'Relacion', 'SE QUITO RELACION', '2018-10-10 23:58:22'),
(294, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 00:46:06'),
(295, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 00:54:21'),
(296, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 00:54:51'),
(297, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 00:56:56'),
(298, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 21:10:34'),
(299, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 21:10:37'),
(300, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 21:10:45'),
(301, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 21:11:09'),
(302, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:4', '2018-10-11 21:31:48'),
(303, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:4', '2018-10-11 21:31:53'),
(304, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 21:32:04'),
(305, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:4', '2018-10-11 21:36:03'),
(306, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 21:36:13'),
(307, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 21:36:39'),
(308, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-11 21:39:11'),
(309, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:4', '2018-10-11 23:29:05'),
(310, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:4', '2018-10-12 23:00:24'),
(311, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :18', '2018-10-12 23:00:27'),
(312, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :18', '2018-10-12 23:07:12'),
(313, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :18', '2018-10-12 23:07:14'),
(314, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :18', '2018-10-12 23:07:17'),
(315, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :18', '2018-10-12 23:07:21'),
(316, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :18', '2018-10-12 23:07:27'),
(317, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :18', '2018-10-12 23:07:31'),
(318, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :18', '2018-10-12 23:11:03'),
(319, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-13 11:48:36'),
(320, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-13 11:48:45'),
(321, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-13 11:49:15'),
(322, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-13 11:49:18'),
(323, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :22', '2018-10-13 11:49:32'),
(324, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:5', '2018-10-13 11:49:45'),
(325, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :22', '2018-10-13 11:49:48'),
(326, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMERO', '2018-10-13 11:58:15'),
(327, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:ESTEFANY INCA CARDENAS', '2018-10-13 11:58:44'),
(328, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:JULIO BENITEZ ROMAN COMO ALUMNO NUEVO', '2018-10-13 11:59:19'),
(329, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:6', '2018-10-13 12:00:03'),
(330, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:6', '2018-10-13 12:00:06'),
(331, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:6', '2018-10-13 12:00:08'),
(332, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:6', '2018-10-13 12:00:10'),
(333, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:6', '2018-10-13 12:00:13'),
(334, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:6', '2018-10-13 12:00:18'),
(335, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:6', '2018-10-13 12:00:21'),
(336, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:6', '2018-10-13 12:00:25'),
(337, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:6', '2018-10-13 12:00:27'),
(338, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:6', '2018-10-13 12:00:29'),
(339, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:7', '2018-10-13 12:02:59'),
(340, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:7', '2018-10-13 12:03:01'),
(341, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:7', '2018-10-13 12:03:03'),
(342, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:7', '2018-10-13 12:03:07'),
(343, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Apoderado', 'SE ACTUALIZO Apoderado:JULIO DOMINGO GUZMAN', '2018-10-13 12:08:03'),
(344, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Persona', 'SE REGISTRO APODERADO:VERONICA PADILLA CARRILLO', '2018-10-13 12:09:06'),
(345, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Relacion', 'SE AGREGO ALUMNO:7 A APODERADO:2', '2018-10-13 12:09:14'),
(346, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ELIMINAR', 'Relacion', 'SE QUITO RELACION', '2018-10-13 12:09:20'),
(347, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Relacion', 'SE AGREGO ALUMNO:7 A APODERADO:2', '2018-10-13 12:09:25'),
(348, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ELIMINAR', 'Relacion', 'SE QUITO RELACION', '2018-10-13 12:09:28'),
(349, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ELIMINAR', 'Relacion', 'SE QUITO RELACION', '2018-10-13 12:09:39'),
(350, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:JOAQUIN PRIALE DOMINGUEZ COMO ALUMNO NUEVO', '2018-10-13 12:21:38'),
(351, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMERO', '2018-10-13 13:33:10'),
(352, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:4', '2018-10-13 13:33:21'),
(353, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:1', '2018-10-13 16:59:10'),
(354, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:1', '2018-10-13 17:01:23'),
(355, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:1', '2018-10-13 17:02:00'),
(356, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 17:03:09'),
(357, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 17:06:31'),
(358, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 17:10:28'),
(359, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:3', '2018-10-13 17:10:58'),
(360, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:3', '2018-10-13 17:24:18'),
(361, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:4', '2018-10-13 17:30:22'),
(362, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:4', '2018-10-13 17:32:46'),
(363, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:4', '2018-10-13 17:33:45'),
(364, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:3', '2018-10-13 17:34:08'),
(365, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:3', '2018-10-13 17:36:34'),
(366, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:3', '2018-10-13 17:38:47'),
(367, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 17:40:39'),
(368, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 17:40:49'),
(369, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 17:40:49'),
(370, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 17:40:56'),
(371, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 17:40:56'),
(372, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 17:40:56'),
(373, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:3', '2018-10-13 17:44:18'),
(374, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 21:00:29'),
(375, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 21:01:26'),
(376, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 21:01:26'),
(377, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 21:01:26'),
(378, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 21:01:26'),
(379, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 22:16:40'),
(380, 'admin', 'PAGO', 'PAGO', 'SE PAGO - CODIGO PLAN:2', '2018-10-13 22:18:52'),
(381, 'admin', 'PERSONA DESHBILITADO', 'USUARIO', 'SEPERSONA DESHBILITADO :JOAQUIN PRIALE DOMINGUEZ', '2018-10-24 14:55:27'),
(382, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TIPO APGO', 'TipoPago', '2018-10-24 15:49:16'),
(383, 'admin', 'TIPO DE PAGO DESHABILITADO', 'TIPOPAGO', 'TIPO DE PAGO DESHABILITADO', '2018-10-24 15:51:41'),
(384, 'admin', 'TIPO DE PAGO HABILITADO', 'TIPOPAGO', 'TIPO DE PAGO HABILITADO', '2018-10-24 15:51:43'),
(385, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TIPO APGO', 'TipoPago', '2018-10-24 15:51:51'),
(386, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'INSERTAR', 'SE REGISTRO TIPO APGO', 'TipoPago', '2018-10-24 15:52:03'),
(387, 'admin', 'PERSONA HABILITADO', 'USUARIO', 'SEPERSONA HABILITADO :JOAQUIN PRIALE DOMINGUEZ', '2018-10-24 16:11:41'),
(388, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :48', '2018-10-24 18:49:57'),
(389, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :48', '2018-10-24 18:50:00'),
(390, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :48', '2018-10-24 18:50:03'),
(391, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :48', '2018-10-24 18:50:05'),
(392, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :60', '2018-10-24 19:36:28'),
(393, 'admin', 'CUOTA ANULADA', 'CUOTA', 'COUTA ANULADA :60', '2018-10-24 19:36:30'),
(394, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:JOAQUIN CARDENAS PRADO COMO ALUMNO NUEVO', '2018-10-24 19:45:11'),
(395, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:MIGUEL ANGEL LOPEZ SUAREZ COMO ALUMNO NUEVO', '2018-10-24 19:46:04'),
(396, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:SANDRA INCA ROMAN COMO ALUMNO NUEVO', '2018-10-24 19:46:29'),
(397, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:MARICIELO ROMERO SU COMO ALUMNO NUEVO', '2018-10-24 19:46:57'),
(398, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:ROMINA ZABALETA GOMEZ COMO ALUMNO NUEVO', '2018-10-24 19:47:24'),
(399, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:GERMAN RAMIREZ ACOSTA COMO ALUMNO NUEVO', '2018-10-27 10:39:30'),
(400, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:LUIS ROMERO SUAREZ COMO ALUMNO NUEVO', '2018-10-27 10:41:51'),
(401, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:LUISA ROSER RUANI COMO ALUMNO NUEVO', '2018-10-27 10:43:49'),
(402, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:LUCAS WEFWEF WEFEW COMO ALUMNO NUEVO', '2018-10-27 10:47:03'),
(403, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:RODRIGO FW WFE COMO ALUMNO NUEVO', '2018-10-27 11:04:02'),
(404, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:PRUEBAf rqwr fwfwef COMO ALUMNO NUEVO', '2018-10-27 11:14:15'),
(405, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:LUCASSS fwefe wfe COMO ALUMNO NUEVO', '2018-10-27 11:18:06'),
(406, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Alumno', 'SE REGISTRO PERSONA:JESUSIN wefew wfefwe COMO ALUMNO NUEVO', '2018-10-27 11:36:28'),
(407, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMERO', '2018-10-27 11:41:58'),
(408, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMERO', '2018-10-27 11:43:35'),
(409, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:SERGIO INCA CARDENAS', '2018-10-27 11:47:00'),
(410, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:ESTEFANY INCA CARDENAS', '2018-10-27 11:47:10'),
(411, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMERO', '2018-10-27 11:49:04'),
(412, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:SERGIO INCA CARDENAS', '2018-10-27 11:49:16'),
(413, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:SERGIO INCA CARDENAS', '2018-10-27 11:49:26'),
(414, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JULIO BENITEZ ROMAN', '2018-10-27 11:50:07'),
(415, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:SERGIO INCA CARDENAS', '2018-10-27 11:50:20'),
(416, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOAQUIN PRIALE DOMINGUEZ', '2018-10-27 11:50:32'),
(417, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOAQUIN CARDENAS PRADO', '2018-10-27 11:50:43'),
(418, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:MIGUEL ANGEL LOPEZ SUAREZ', '2018-10-27 11:50:53'),
(419, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:SANDRA INCA ROMAN', '2018-10-27 11:51:01'),
(420, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:MARICIELO ROMERO SU', '2018-10-27 11:51:12'),
(421, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:ROMINA ZABALETA GOMEZ', '2018-10-27 11:51:25'),
(422, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:MARICIELO ROMERO SU', '2018-10-27 11:51:59'),
(423, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:SERGIO INCA CARDENAS', '2018-10-27 11:56:50'),
(424, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:ESTEFANY INCA CARDENAS', '2018-10-27 12:00:26'),
(425, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:ESTEFANY INCA CARDENAS', '2018-10-27 12:00:56'),
(426, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMERO', '2018-10-27 12:03:32'),
(427, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMERO', '2018-10-27 12:03:58'),
(428, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMERO', '2018-10-27 12:04:44'),
(429, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMERO', '2018-10-27 12:07:02'),
(430, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMERO', '2018-10-27 12:12:01'),
(431, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMERO', '2018-10-27 12:12:31'),
(432, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMERO', '2018-10-27 12:13:23'),
(433, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMERO', '2018-10-27 12:13:40'),
(434, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:SERGIO INCA CARDENAS', '2018-10-27 12:14:17'),
(435, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:ESTEFANY INCA CARDENAS', '2018-10-27 12:14:25'),
(436, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JULIO BENITEZ ROMAN', '2018-10-27 12:14:32'),
(437, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOAQUIN PRIALE DOMINGUEZ', '2018-10-27 12:14:47'),
(438, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOAQUIN CARDENAS PRADO', '2018-10-27 12:14:55'),
(439, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:MIGUEL ANGEL LOPEZ SUAREZ', '2018-10-27 12:15:04'),
(440, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:SANDRA INCA ROMAN', '2018-10-27 12:15:15');
INSERT INTO `bitacora` (`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`, `Detalle`, `fechaRegistro`) VALUES
(441, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:MARICIELO ROMERO SU', '2018-10-27 12:15:24'),
(442, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:ROMINA ZABALETA GOMEZ', '2018-10-27 12:15:33'),
(443, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMERO', '2018-10-27 12:16:01'),
(444, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMERO', '2018-10-27 12:16:19'),
(445, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:MARIA DOMINGUEZ VALENZUELA', '2018-10-27 12:17:10'),
(446, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:ROMULO SILVA FUENTES', '2018-10-27 12:17:32'),
(447, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:ROMULO SILVA FUENTES', '2018-10-27 12:17:43'),
(448, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:ROMULO SILVA FUENTES', '2018-10-27 12:17:52'),
(449, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:LUISA BENITEZ ROMAN', '2018-10-27 12:18:17'),
(450, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:LUISA BENITEZ ROMAN', '2018-10-27 12:22:10'),
(451, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:ROBERTO BENITEZ JULIE', '2018-10-27 12:22:26'),
(452, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:ROBERTO BENITEZ JULIE', '2018-10-27 12:23:05'),
(453, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:ROBERTO BENITEZ JULIE', '2018-10-27 12:23:22'),
(454, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMEROS', '2018-10-27 12:24:03'),
(455, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMEROS', '2018-10-27 12:25:23'),
(456, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMEROS', '2018-10-27 12:25:32'),
(457, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:MARIA DOMINGUEZ VALENZUELA', '2018-10-27 12:26:01'),
(458, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMEROS', '2018-10-27 12:28:45'),
(459, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:ROMULO SILVA FUENTES', '2018-10-27 12:30:00'),
(460, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:ROBERTO BENITEZ JULIE', '2018-10-27 12:40:13'),
(461, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:ROBERTO BENITEZ JULIE', '2018-10-27 12:40:21'),
(462, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMEROS', '2018-10-27 12:40:30'),
(463, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:MARIA DOMINGUEZ VALENZUELA', '2018-10-27 12:40:40'),
(464, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:ROMULO SILVA FUENTES', '2018-10-27 12:40:51'),
(465, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMEROS', '2018-10-27 12:41:04'),
(466, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:MARIA DOMINGUEZ VALENZUELA', '2018-10-27 12:41:21'),
(467, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:ROMULO SILVA FUENTES', '2018-10-27 12:41:29'),
(468, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:MARIA LUISA PRIALE DOMINGUEZ', '2018-10-27 12:41:49'),
(469, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOAQUINA CARDENAS PRADO', '2018-10-27 12:41:59'),
(470, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JESUS INCA ROMAN', '2018-10-27 12:42:13'),
(471, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:MIGUEL ZABALETA GOMEZ', '2018-10-27 12:42:40'),
(472, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jrodriguezr', '2018-10-30 16:03:31'),
(473, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jdomingog', '2018-10-30 16:08:19'),
(474, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'USUARIO', 'SE REGISTRO EL USUARIO:jincar', '2018-10-30 16:09:55'),
(475, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMEROS', '2018-11-03 19:19:29'),
(476, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMEROS', '2018-11-03 19:20:03'),
(477, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMEROS', '2018-11-03 19:21:53'),
(478, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMEROS', '2018-11-03 19:22:13'),
(479, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMEROS', '2018-11-03 19:22:27'),
(480, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'Alumno', 'SE ACTUALIZO Alumno:JOSE RODRIGUEZ ROMEROS', '2018-11-03 19:22:55'),
(481, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'USUARIO', 'SE ACTUALIZO EL USUARIO:jincar', '2018-11-05 02:50:54'),
(482, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'ACTUALIZACION', 'USUARIO', 'SE ACTUALIZO EL USUARIO:jincar', '2018-11-05 02:51:01');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuota`
--

DROP TABLE IF EXISTS `cuota`;
CREATE TABLE IF NOT EXISTS `cuota` (
  `idCuota` int(11) NOT NULL AUTO_INCREMENT,
  `Alumno_idAlumno` int(11) NOT NULL,
  `PlanPago_idPlanPago` int(11) DEFAULT NULL,
  `Importe` decimal(7,2) NOT NULL,
  `Diferencia` decimal(7,2) NOT NULL,
  `Mora` decimal(7,2) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `Mes` int(11) DEFAULT NULL,
  `fechaEmision` date DEFAULT NULL,
  `fechaVencimiento` date DEFAULT NULL,
  `Estado_idEstado` int(11) NOT NULL,
  PRIMARY KEY (`idCuota`),
  KEY `FK_PlanPago_idPlanPago` (`PlanPago_idPlanPago`),
  KEY `FK_Estado_idEstadoCuota` (`Estado_idEstado`),
  KEY `FKALUMNOCUOTA` (`Alumno_idAlumno`)
) ENGINE=InnoDB AUTO_INCREMENT=1039 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `cuota`
--

INSERT INTO `cuota` (`idCuota`, `Alumno_idAlumno`, `PlanPago_idPlanPago`, `Importe`, `Diferencia`, `Mora`, `year`, `Mes`, `fechaEmision`, `fechaVencimiento`, `Estado_idEstado`) VALUES
(883, 5, NULL, '200.00', '0.00', '582.00', 2017, 3, '2017-03-01', '2017-03-30', 7),
(884, 5, NULL, '200.00', '0.00', '551.00', 2017, 4, '2017-04-01', '2017-04-30', 7),
(885, 5, NULL, '200.00', '0.00', '521.00', 2017, 5, '2017-05-01', '2017-05-30', 7),
(886, 5, NULL, '200.00', '0.00', '490.00', 2017, 6, '2017-06-01', '2017-06-30', 7),
(887, 5, NULL, '200.00', '200.00', '0.00', 2017, 7, '2017-07-01', '2017-07-30', 5),
(888, 5, NULL, '200.00', '200.00', '0.00', 2017, 8, '2017-08-01', '2017-08-30', 5),
(889, 5, NULL, '200.00', '200.00', '0.00', 2017, 9, '2017-09-01', '2017-09-30', 5),
(890, 5, NULL, '200.00', '200.00', '0.00', 2017, 10, '2017-10-01', '2017-10-30', 5),
(891, 5, NULL, '200.00', '200.00', '0.00', 2017, 11, '2017-11-01', '2017-11-30', 5),
(892, 5, NULL, '200.00', '200.00', '0.00', 2017, 12, '2017-12-01', '2017-12-30', 5),
(893, 6, NULL, '200.00', '0.00', '582.00', 2017, 3, '2017-03-01', '2017-03-30', 7),
(894, 6, NULL, '200.00', '200.00', '0.00', 2017, 4, '2017-04-01', '2017-04-30', 5),
(895, 6, NULL, '200.00', '200.00', '0.00', 2017, 5, '2017-05-01', '2017-05-30', 5),
(896, 6, NULL, '200.00', '200.00', '0.00', 2017, 6, '2017-06-01', '2017-06-30', 5),
(897, 6, NULL, '200.00', '200.00', '0.00', 2017, 7, '2017-07-01', '2017-07-30', 5),
(898, 6, NULL, '200.00', '200.00', '0.00', 2017, 8, '2017-08-01', '2017-08-30', 5),
(899, 6, NULL, '200.00', '200.00', '0.00', 2017, 9, '2017-09-01', '2017-09-30', 5),
(900, 6, NULL, '200.00', '200.00', '0.00', 2017, 10, '2017-10-01', '2017-10-30', 5),
(901, 6, NULL, '200.00', '200.00', '0.00', 2017, 11, '2017-11-01', '2017-11-30', 5),
(902, 6, NULL, '200.00', '200.00', '0.00', 2017, 12, '2017-12-01', '2017-12-30', 5),
(903, 7, NULL, '200.00', '200.00', '0.00', 2017, 3, '2017-03-01', '2017-03-30', 5),
(904, 7, NULL, '200.00', '200.00', '0.00', 2017, 4, '2017-04-01', '2017-04-30', 5),
(905, 7, NULL, '200.00', '200.00', '0.00', 2017, 5, '2017-05-01', '2017-05-30', 5),
(906, 7, NULL, '200.00', '200.00', '0.00', 2017, 6, '2017-06-01', '2017-06-30', 5),
(907, 7, NULL, '200.00', '200.00', '0.00', 2017, 7, '2017-07-01', '2017-07-30', 5),
(908, 7, NULL, '200.00', '200.00', '0.00', 2017, 8, '2017-08-01', '2017-08-30', 5),
(909, 7, NULL, '200.00', '200.00', '0.00', 2017, 9, '2017-09-01', '2017-09-30', 5),
(910, 7, NULL, '200.00', '200.00', '0.00', 2017, 10, '2017-10-01', '2017-10-30', 5),
(911, 7, NULL, '200.00', '200.00', '0.00', 2017, 11, '2017-11-01', '2017-11-30', 5),
(912, 7, NULL, '200.00', '200.00', '0.00', 2017, 12, '2017-12-01', '2017-12-30', 5),
(913, 8, NULL, '200.00', '200.00', '0.00', 2017, 3, '2017-03-01', '2017-03-30', 5),
(914, 8, NULL, '200.00', '200.00', '0.00', 2017, 4, '2017-04-01', '2017-04-30', 5),
(915, 8, NULL, '200.00', '200.00', '0.00', 2017, 5, '2017-05-01', '2017-05-30', 5),
(916, 8, NULL, '200.00', '200.00', '0.00', 2017, 6, '2017-06-01', '2017-06-30', 5),
(917, 8, NULL, '200.00', '200.00', '0.00', 2017, 7, '2017-07-01', '2017-07-30', 5),
(918, 8, NULL, '200.00', '200.00', '0.00', 2017, 8, '2017-08-01', '2017-08-30', 5),
(919, 8, NULL, '200.00', '200.00', '0.00', 2017, 9, '2017-09-01', '2017-09-30', 5),
(920, 8, NULL, '200.00', '200.00', '0.00', 2017, 10, '2017-10-01', '2017-10-30', 5),
(921, 8, NULL, '200.00', '200.00', '0.00', 2017, 11, '2017-11-01', '2017-11-30', 5),
(922, 8, NULL, '200.00', '200.00', '0.00', 2017, 12, '2017-12-01', '2017-12-30', 5),
(923, 9, NULL, '200.00', '200.00', '0.00', 2017, 3, '2017-03-01', '2017-03-30', 5),
(924, 9, NULL, '200.00', '200.00', '0.00', 2017, 4, '2017-04-01', '2017-04-30', 5),
(925, 9, NULL, '200.00', '200.00', '0.00', 2017, 5, '2017-05-01', '2017-05-30', 5),
(926, 9, NULL, '200.00', '200.00', '0.00', 2017, 6, '2017-06-01', '2017-06-30', 5),
(927, 9, NULL, '200.00', '200.00', '0.00', 2017, 7, '2017-07-01', '2017-07-30', 5),
(928, 9, NULL, '200.00', '200.00', '0.00', 2017, 8, '2017-08-01', '2017-08-30', 5),
(929, 9, NULL, '200.00', '200.00', '0.00', 2017, 9, '2017-09-01', '2017-09-30', 5),
(930, 9, NULL, '200.00', '200.00', '0.00', 2017, 10, '2017-10-01', '2017-10-30', 5),
(931, 9, NULL, '200.00', '200.00', '0.00', 2017, 11, '2017-11-01', '2017-11-30', 5),
(932, 9, NULL, '200.00', '200.00', '0.00', 2017, 12, '2017-12-01', '2017-12-30', 5),
(933, 10, NULL, '200.00', '200.00', '0.00', 2017, 3, '2017-03-01', '2017-03-30', 5),
(934, 10, NULL, '200.00', '200.00', '0.00', 2017, 4, '2017-04-01', '2017-04-30', 5),
(935, 10, NULL, '200.00', '200.00', '0.00', 2017, 5, '2017-05-01', '2017-05-30', 5),
(936, 10, NULL, '200.00', '200.00', '0.00', 2017, 6, '2017-06-01', '2017-06-30', 5),
(937, 10, NULL, '200.00', '200.00', '0.00', 2017, 7, '2017-07-01', '2017-07-30', 5),
(938, 10, NULL, '200.00', '200.00', '0.00', 2017, 8, '2017-08-01', '2017-08-30', 5),
(939, 10, NULL, '200.00', '200.00', '0.00', 2017, 9, '2017-09-01', '2017-09-30', 5),
(940, 10, NULL, '200.00', '200.00', '0.00', 2017, 10, '2017-10-01', '2017-10-30', 5),
(941, 10, NULL, '200.00', '200.00', '0.00', 2017, 11, '2017-11-01', '2017-11-30', 5),
(942, 10, NULL, '200.00', '200.00', '0.00', 2017, 12, '2017-12-01', '2017-12-30', 5),
(943, 11, NULL, '200.00', '200.00', '0.00', 2017, 3, '2017-03-01', '2017-03-30', 5),
(944, 11, NULL, '200.00', '200.00', '0.00', 2017, 4, '2017-04-01', '2017-04-30', 5),
(945, 11, NULL, '200.00', '200.00', '0.00', 2017, 5, '2017-05-01', '2017-05-30', 5),
(946, 11, NULL, '200.00', '200.00', '0.00', 2017, 6, '2017-06-01', '2017-06-30', 5),
(947, 11, NULL, '200.00', '200.00', '0.00', 2017, 7, '2017-07-01', '2017-07-30', 5),
(948, 11, NULL, '200.00', '200.00', '0.00', 2017, 8, '2017-08-01', '2017-08-30', 5),
(949, 11, NULL, '200.00', '200.00', '0.00', 2017, 9, '2017-09-01', '2017-09-30', 5),
(950, 11, NULL, '200.00', '200.00', '0.00', 2017, 10, '2017-10-01', '2017-10-30', 5),
(951, 11, NULL, '200.00', '200.00', '0.00', 2017, 11, '2017-11-01', '2017-11-30', 5),
(952, 11, NULL, '200.00', '200.00', '0.00', 2017, 12, '2017-12-01', '2017-12-30', 5),
(953, 12, NULL, '200.00', '200.00', '0.00', 2017, 3, '2017-03-01', '2017-03-30', 5),
(954, 12, NULL, '200.00', '200.00', '0.00', 2017, 4, '2017-04-01', '2017-04-30', 5),
(955, 12, NULL, '200.00', '200.00', '0.00', 2017, 5, '2017-05-01', '2017-05-30', 5),
(956, 12, NULL, '200.00', '200.00', '0.00', 2017, 6, '2017-06-01', '2017-06-30', 5),
(957, 12, NULL, '200.00', '200.00', '0.00', 2017, 7, '2017-07-01', '2017-07-30', 5),
(958, 12, NULL, '200.00', '200.00', '0.00', 2017, 8, '2017-08-01', '2017-08-30', 5),
(959, 12, NULL, '200.00', '200.00', '0.00', 2017, 9, '2017-09-01', '2017-09-30', 5),
(960, 12, NULL, '200.00', '200.00', '0.00', 2017, 10, '2017-10-01', '2017-10-30', 5),
(961, 12, NULL, '200.00', '200.00', '0.00', 2017, 11, '2017-11-01', '2017-11-30', 5),
(962, 12, NULL, '200.00', '200.00', '0.00', 2017, 12, '2017-12-01', '2017-12-30', 5),
(963, 13, NULL, '200.00', '200.00', '0.00', 2017, 3, '2017-03-01', '2017-03-30', 5),
(964, 13, NULL, '200.00', '200.00', '0.00', 2017, 4, '2017-04-01', '2017-04-30', 5),
(965, 13, NULL, '200.00', '200.00', '0.00', 2017, 5, '2017-05-01', '2017-05-30', 5),
(966, 13, NULL, '200.00', '200.00', '0.00', 2017, 6, '2017-06-01', '2017-06-30', 5),
(967, 13, NULL, '200.00', '200.00', '0.00', 2017, 7, '2017-07-01', '2017-07-30', 5),
(968, 13, NULL, '200.00', '200.00', '0.00', 2017, 8, '2017-08-01', '2017-08-30', 5),
(969, 13, NULL, '200.00', '200.00', '0.00', 2017, 9, '2017-09-01', '2017-09-30', 5),
(970, 13, NULL, '200.00', '200.00', '0.00', 2017, 10, '2017-10-01', '2017-10-30', 5),
(971, 13, NULL, '200.00', '200.00', '0.00', 2017, 11, '2017-11-01', '2017-11-30', 5),
(972, 13, NULL, '200.00', '200.00', '0.00', 2017, 12, '2017-12-01', '2017-12-30', 5),
(973, 4, NULL, '200.00', '0.00', '217.00', 2018, 3, '2018-03-01', '2018-03-30', 7),
(974, 4, NULL, '200.00', '0.00', '186.00', 2018, 4, '2018-04-01', '2018-04-30', 7),
(975, 4, NULL, '200.00', '0.00', '156.00', 2018, 5, '2018-05-01', '2018-05-30', 7),
(976, 4, NULL, '200.00', '0.00', '125.00', 2018, 6, '2018-06-01', '2018-06-30', 7),
(977, 4, NULL, '200.00', '0.00', '95.00', 2018, 7, '2018-07-01', '2018-07-30', 7),
(978, 4, NULL, '200.00', '0.00', '64.00', 2018, 8, '2018-08-01', '2018-08-30', 7),
(979, 4, NULL, '200.00', '0.00', '33.00', 2018, 9, '2018-09-01', '2018-09-30', 7),
(980, 4, NULL, '200.00', '0.00', '3.00', 2018, 10, '2018-10-01', '2018-10-30', 7),
(981, 4, NULL, '200.00', '0.00', '0.00', 2018, 11, '2018-11-01', '2018-11-30', 7),
(982, 4, NULL, '200.00', '0.00', '0.00', 2018, 12, '2018-12-01', '2018-12-30', 7),
(983, 5, NULL, '200.00', '0.00', '217.00', 2018, 3, '2018-03-01', '2018-03-30', 7),
(984, 5, NULL, '200.00', '0.00', '186.00', 2018, 4, '2018-04-01', '2018-04-30', 7),
(985, 5, NULL, '200.00', '0.00', '156.00', 2018, 5, '2018-05-01', '2018-05-30', 7),
(986, 5, NULL, '200.00', '0.00', '125.00', 2018, 6, '2018-06-01', '2018-06-30', 7),
(987, 5, NULL, '200.00', '0.00', '95.00', 2018, 7, '2018-07-01', '2018-07-30', 7),
(988, 5, NULL, '200.00', '0.00', '64.00', 2018, 8, '2018-08-01', '2018-08-30', 7),
(989, 5, NULL, '200.00', '0.00', '33.00', 2018, 9, '2018-09-01', '2018-09-30', 7),
(990, 5, NULL, '200.00', '200.00', '0.00', 2018, 10, '2018-10-01', '2018-10-30', 5),
(991, 5, NULL, '200.00', '200.00', '0.00', 2018, 11, '2018-11-01', '2018-11-30', 5),
(992, 5, NULL, '200.00', '200.00', '0.00', 2018, 12, '2018-12-01', '2018-12-30', 5),
(993, 6, NULL, '200.00', '200.00', '0.00', 2018, 3, '2018-03-01', '2018-03-30', 5),
(994, 6, NULL, '200.00', '200.00', '0.00', 2018, 4, '2018-04-01', '2018-04-30', 5),
(995, 6, NULL, '200.00', '200.00', '0.00', 2018, 5, '2018-05-01', '2018-05-30', 5),
(996, 6, NULL, '200.00', '200.00', '0.00', 2018, 6, '2018-06-01', '2018-06-30', 5),
(997, 6, NULL, '200.00', '200.00', '0.00', 2018, 7, '2018-07-01', '2018-07-30', 5),
(998, 6, NULL, '200.00', '200.00', '0.00', 2018, 8, '2018-08-01', '2018-08-30', 5),
(999, 6, NULL, '200.00', '200.00', '0.00', 2018, 9, '2018-09-01', '2018-09-30', 5),
(1000, 6, NULL, '200.00', '200.00', '0.00', 2018, 10, '2018-10-01', '2018-10-30', 5),
(1001, 6, NULL, '200.00', '200.00', '0.00', 2018, 11, '2018-11-01', '2018-11-30', 5),
(1002, 6, NULL, '200.00', '200.00', '0.00', 2018, 12, '2018-12-01', '2018-12-30', 5),
(1003, 7, NULL, '200.00', '200.00', '0.00', 2018, 3, '2018-03-01', '2018-03-30', 5),
(1004, 7, NULL, '200.00', '200.00', '0.00', 2018, 4, '2018-04-01', '2018-04-30', 5),
(1005, 7, NULL, '200.00', '200.00', '0.00', 2018, 5, '2018-05-01', '2018-05-30', 5),
(1006, 7, NULL, '200.00', '200.00', '0.00', 2018, 6, '2018-06-01', '2018-06-30', 5),
(1007, 7, NULL, '200.00', '200.00', '0.00', 2018, 7, '2018-07-01', '2018-07-30', 5),
(1008, 7, NULL, '200.00', '200.00', '0.00', 2018, 8, '2018-08-01', '2018-08-30', 5),
(1009, 7, NULL, '200.00', '200.00', '0.00', 2018, 9, '2018-09-01', '2018-09-30', 5),
(1010, 7, NULL, '200.00', '200.00', '0.00', 2018, 10, '2018-10-01', '2018-10-30', 5),
(1011, 7, NULL, '200.00', '200.00', '0.00', 2018, 11, '2018-11-01', '2018-11-30', 5),
(1012, 7, NULL, '200.00', '200.00', '0.00', 2018, 12, '2018-12-01', '2018-12-30', 5),
(1013, 8, NULL, '200.00', '200.00', '0.00', 2018, 3, '2018-03-01', '2018-03-30', 5),
(1014, 8, NULL, '200.00', '200.00', '0.00', 2018, 4, '2018-04-01', '2018-04-30', 5),
(1015, 8, NULL, '200.00', '200.00', '0.00', 2018, 5, '2018-05-01', '2018-05-30', 5),
(1016, 8, NULL, '200.00', '200.00', '0.00', 2018, 6, '2018-06-01', '2018-06-30', 5),
(1017, 8, NULL, '200.00', '200.00', '0.00', 2018, 7, '2018-07-01', '2018-07-30', 5),
(1018, 8, NULL, '200.00', '200.00', '0.00', 2018, 8, '2018-08-01', '2018-08-30', 5),
(1019, 8, NULL, '200.00', '200.00', '0.00', 2018, 9, '2018-09-01', '2018-09-30', 5),
(1020, 8, NULL, '200.00', '200.00', '0.00', 2018, 10, '2018-10-01', '2018-10-30', 5),
(1021, 8, NULL, '200.00', '200.00', '0.00', 2018, 11, '2018-11-01', '2018-11-30', 5),
(1022, 8, NULL, '200.00', '200.00', '0.00', 2018, 12, '2018-12-01', '2018-12-30', 5),
(1029, 4, NULL, '200.00', '0.00', '580.00', 2017, 3, '2017-03-01', '2017-03-30', 6),
(1030, 4, NULL, '200.00', '0.00', '549.00', 2017, 4, '2017-04-01', '2017-04-30', 6),
(1031, 4, NULL, '200.00', '0.00', '519.00', 2017, 5, '2017-05-01', '2017-05-30', 6),
(1032, 4, NULL, '200.00', '0.00', '488.00', 2017, 6, '2017-06-01', '2017-06-30', 6),
(1033, 4, NULL, '200.00', '0.00', '458.00', 2017, 7, '2017-07-01', '2017-07-30', 6),
(1034, 4, NULL, '200.00', '0.00', '429.00', 2017, 8, '2017-08-01', '2017-08-30', 7),
(1035, 4, NULL, '200.00', '0.00', '398.00', 2017, 9, '2017-09-01', '2017-09-30', 7),
(1036, 4, NULL, '200.00', '0.00', '368.00', 2017, 10, '2017-10-01', '2017-10-30', 7),
(1037, 4, NULL, '200.00', '0.00', '337.00', 2017, 11, '2017-11-01', '2017-11-30', 7),
(1038, 4, NULL, '200.00', '0.00', '307.00', 2017, 12, '2017-12-01', '2017-12-30', 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estado`
--

DROP TABLE IF EXISTS `estado`;
CREATE TABLE IF NOT EXISTS `estado` (
  `idEstado` int(11) NOT NULL AUTO_INCREMENT,
  `tipoEstado` tinyint(4) NOT NULL,
  `nombreEstado` varchar(50) NOT NULL,
  PRIMARY KEY (`idEstado`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `estado`
--

INSERT INTO `estado` (`idEstado`, `tipoEstado`, `nombreEstado`) VALUES
(1, 1, 'ACTIVO'),
(2, 1, 'INACTIVO'),
(3, 2, 'HABILITADO'),
(4, 2, 'DESHABILITADO'),
(5, 3, 'PENDIENTE'),
(6, 3, 'PAGO PARCIAL'),
(7, 3, 'PAGADO'),
(8, 3, 'ANULADO'),
(9, 4, 'EN PROCESO DE PAGO'),
(10, 4, 'CANCELADO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `generalimportes`
--

DROP TABLE IF EXISTS `generalimportes`;
CREATE TABLE IF NOT EXISTS `generalimportes` (
  `idGeneral` int(11) NOT NULL AUTO_INCREMENT,
  `NombrePago` varchar(100) NOT NULL,
  `Monto` decimal(10,2) NOT NULL,
  `Cuotas` int(11) NOT NULL,
  `Estado_idEstado` int(11) NOT NULL,
  PRIMARY KEY (`idGeneral`),
  KEY `FKImportes` (`Estado_idEstado`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `generalimportes`
--

INSERT INTO `generalimportes` (`idGeneral`, `NombrePago`, `Monto`, `Cuotas`, `Estado_idEstado`) VALUES
(1, 'Pago de Matricula', '250.00', 1, 1),
(3, 'Pago de Computación', '120.00', 1, 1),
(4, 'Pago de Certificado', '100.00', 1, 1),
(5, 'Pago de Ingles', '120.00', 1, 1),
(6, 'Pago Otro', '100.00', 1, 1),
(7, 'Pago Otro', '200.00', 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `grado`
--

DROP TABLE IF EXISTS `grado`;
CREATE TABLE IF NOT EXISTS `grado` (
  `idGrado` int(11) NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(100) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  `Estado_idEstado` int(11) NOT NULL,
  PRIMARY KEY (`idGrado`),
  KEY `FK_Estado_idEstadoGra` (`Estado_idEstado`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `grado`
--

INSERT INTO `grado` (`idGrado`, `Descripcion`, `fechaRegistro`, `Estado_idEstado`) VALUES
(12, '1°  PRIMERO', '2018-10-08 03:42:13', 1),
(13, '2° SEGUNDO', '2018-10-08 03:42:24', 1),
(14, '3° TERCERO', '2018-10-08 03:42:34', 1),
(15, '4° CUARTO', '2018-10-08 03:42:45', 1),
(16, '5° QUINTO', '2018-10-08 03:42:57', 1),
(17, '6°  SEXTO', '2018-10-08 03:43:10', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `login`
--

DROP TABLE IF EXISTS `login`;
CREATE TABLE IF NOT EXISTS `login` (
  `idLogin` int(11) NOT NULL AUTO_INCREMENT,
  `Usuario_idUsuario` int(11) NOT NULL,
  `usuarioLog` varchar(50) NOT NULL,
  `passwordLog` varchar(100) NOT NULL,
  `perfilLog` varchar(150) NOT NULL,
  `fechaLog` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` varchar(50) DEFAULT NULL,
  `fechaLogout` datetime DEFAULT NULL,
  PRIMARY KEY (`idLogin`),
  KEY `Usuario_idUsuario` (`Usuario_idUsuario`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `login`
--

INSERT INTO `login` (`idLogin`, `Usuario_idUsuario`, `usuarioLog`, `passwordLog`, `perfilLog`, `fechaLog`, `ip`, `fechaLogout`) VALUES
(1, 1, 'admin', '$2a$08$RCuzW/8g2Lg4QMNCfmsa/uKp33rvDmdWrC.P40DOECJlMtPu16NMW', 'Administrador', '2018-09-29 14:03:44', '::1', '2018-11-05 02:45:32');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `matricula`
--

DROP TABLE IF EXISTS `matricula`;
CREATE TABLE IF NOT EXISTS `matricula` (
  `idMatricula` int(11) NOT NULL AUTO_INCREMENT,
  `Alumno_idAlumno` int(11) NOT NULL,
  `Nivel_idNivel` int(11) NOT NULL,
  `Grado_idGrado` int(11) NOT NULL,
  `Seccion_idSeccion` int(11) NOT NULL,
  `year` int(11) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  PRIMARY KEY (`idMatricula`),
  KEY `FKM1` (`Alumno_idAlumno`),
  KEY `FKM2` (`Grado_idGrado`),
  KEY `FKM3` (`Seccion_idSeccion`),
  KEY `FKM4` (`Nivel_idNivel`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `matricula`
--

INSERT INTO `matricula` (`idMatricula`, `Alumno_idAlumno`, `Nivel_idNivel`, `Grado_idGrado`, `Seccion_idSeccion`, `year`, `fechaRegistro`) VALUES
(1, 4, 2, 13, 6, 2017, '2018-10-28 00:47:31'),
(2, 5, 2, 13, 7, 2017, '2018-10-28 09:39:31'),
(3, 6, 5, 12, 7, 2017, '2018-10-28 09:39:47'),
(4, 7, 2, 14, 6, 2017, '2018-10-28 09:40:02'),
(5, 8, 2, 14, 7, 2017, '2018-10-28 09:40:17'),
(6, 9, 2, 13, 9, 2017, '2018-10-28 09:40:33'),
(7, 10, 5, 14, 7, 2017, '2018-10-28 09:40:45'),
(8, 11, 2, 15, 7, 2017, '2018-10-28 09:40:59'),
(9, 12, 5, 14, 7, 2017, '2018-10-28 09:41:11'),
(10, 13, 2, 14, 7, 2017, '2018-10-28 09:41:24'),
(11, 4, 2, 12, 6, 2018, '2018-10-28 17:32:18'),
(12, 5, 2, 13, 6, 2018, '2018-10-28 17:32:34'),
(13, 6, 2, 13, 6, 2018, '2018-10-28 17:32:50'),
(14, 7, 2, 13, 7, 2018, '2018-10-30 19:44:33'),
(15, 8, 2, 13, 6, 2018, '2018-10-31 05:21:52');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `nivel`
--

DROP TABLE IF EXISTS `nivel`;
CREATE TABLE IF NOT EXISTS `nivel` (
  `idNivel` int(11) NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(100) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  `Estado_idEstado` int(11) NOT NULL,
  PRIMARY KEY (`idNivel`),
  KEY `FK_Estado_idEstadoNivel` (`Estado_idEstado`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `nivel`
--

INSERT INTO `nivel` (`idNivel`, `Descripcion`, `fechaRegistro`, `Estado_idEstado`) VALUES
(2, 'PRIMARIA', '2018-10-08 00:55:16', 1),
(5, 'SECUNDARIA', '2018-10-08 03:11:07', 1),
(6, 'NOCTURNO', '2018-10-08 03:11:32', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagocabecera`
--

DROP TABLE IF EXISTS `pagocabecera`;
CREATE TABLE IF NOT EXISTS `pagocabecera` (
  `idPago` int(11) NOT NULL AUTO_INCREMENT,
  `Alumno_idAlumno` int(11) NOT NULL,
  `ImporteTotal` decimal(10,2) DEFAULT NULL,
  `ImporteVuelto` decimal(10,2) DEFAULT NULL,
  `ImportePagar` decimal(10,2) DEFAULT NULL,
  `Observaciones` text,
  `TipoTarjeta_idTipoTarjeta` int(11) DEFAULT NULL,
  `NumeroTarjeta` char(20) DEFAULT NULL,
  `CVV` int(3) DEFAULT NULL,
  `Apoderado_idApoderado` int(11) DEFAULT NULL,
  `Estado_idEstado` int(11) DEFAULT NULL,
  `ReciboVoucher` varchar(150) DEFAULT NULL,
  `Documento` text,
  `fechaRegistro` datetime NOT NULL,
  PRIMARY KEY (`idPago`),
  KEY `FK_CAB_AL` (`Alumno_idAlumno`),
  KEY `FK_CAB_AP` (`Apoderado_idApoderado`),
  KEY `FK_CAB_TT` (`TipoTarjeta_idTipoTarjeta`),
  KEY `FKEscABE` (`Estado_idEstado`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `pagocabecera`
--

INSERT INTO `pagocabecera` (`idPago`, `Alumno_idAlumno`, `ImporteTotal`, `ImporteVuelto`, `ImportePagar`, `Observaciones`, `TipoTarjeta_idTipoTarjeta`, `NumeroTarjeta`, `CVV`, `Apoderado_idApoderado`, `Estado_idEstado`, `ReciboVoucher`, `Documento`, `fechaRegistro`) VALUES
(39, 4, '1670.00', '130.00', '1800.00', 'wef', 1, NULL, NULL, NULL, 1, 'COMP-001', 'COMP-001.pdf', '2018-10-31 18:26:49'),
(40, 4, '2156.00', '44.00', '2200.00', 'wefwef', 1, '12121212', 1213, NULL, 1, 'COMP-002', 'COMP-002.pdf', '2018-10-31 18:31:21'),
(41, 4, '658.00', '42.00', '700.00', 'wef', 1, NULL, NULL, NULL, 1, 'COMP-003', 'COMP-003.pdf', '2018-10-31 18:32:10'),
(42, 4, '690.00', '10.00', '700.00', 'weffew', 1, NULL, NULL, NULL, 1, 'COMP-004', 'COMP-004.pdf', '2018-11-02 16:36:17'),
(43, 4, '417.00', '33.00', '450.00', 'srgw', 1, NULL, NULL, NULL, 1, 'COMP-005', 'COMP-005.pdf', '2018-11-02 16:47:19'),
(44, 4, '742.00', '58.00', '800.00', 'awfqwf', 1, NULL, NULL, NULL, 1, 'COMP-006', 'COMP-006.pdf', '2018-11-02 16:54:21'),
(45, 4, '325.00', '25.00', '350.00', 'qwfqe', 1, NULL, NULL, NULL, 1, 'COMP-007', 'COMP-007.pdf', '2018-11-02 17:01:12'),
(46, 4, '295.00', '5.00', '300.00', 'fewfewf', 1, NULL, NULL, NULL, 1, 'COMP-008', NULL, '2018-11-02 17:06:18'),
(47, 4, '629.00', '1.00', '630.00', 'efwef', 1, NULL, NULL, NULL, 1, 'COMP-009', NULL, '2018-11-02 17:07:29'),
(48, 4, '264.00', '36.00', '300.00', 'gsr', 1, NULL, NULL, NULL, 1, 'COMP-0010', NULL, '2018-11-02 17:09:18'),
(49, 4, '233.00', '17.00', '250.00', 'afegf', 1, NULL, NULL, NULL, 1, 'COMP-0011', 'COMP-0011.pdf', '2018-11-02 17:12:01'),
(50, 4, '203.00', '47.00', '250.00', 'fewfe', 1, NULL, NULL, NULL, 1, 'COMP-0012', 'COMP-0012.pdf', '2018-11-02 17:16:37'),
(51, 4, '200.00', '0.00', '200.00', 'rwgwrg', 1, NULL, NULL, NULL, 1, 'COMP-0013', 'COMP-0013.pdf', '2018-11-02 17:18:24'),
(52, 4, '598.00', '2.00', '600.00', 'ergreg', 1, NULL, NULL, NULL, 1, 'COMP-0014', 'COMP-0014.pdf', '2018-11-02 17:22:12'),
(53, 4, '568.00', '32.00', '600.00', 'thet', 1, NULL, NULL, NULL, 1, 'COMP-0015', 'COMP-0015.pdf', '2018-11-02 17:26:17'),
(54, 4, '537.00', '63.00', '600.00', 'rhr', 1, NULL, NULL, NULL, 1, 'COMP-0016', NULL, '2018-11-02 17:30:36'),
(55, 4, '507.00', '93.00', '600.00', 'wfe', 1, NULL, NULL, NULL, 1, 'COMP-0017', 'COMP-0017.pdf', '2018-11-02 17:33:20'),
(56, 4, '200.00', '0.00', '200.00', 'fwef', 1, NULL, NULL, NULL, 1, 'COMP-0018', 'COMP-0018.pdf', '2018-11-02 17:39:30'),
(57, 5, '690.00', '10.00', '700.00', 'asfaf', 1, NULL, NULL, NULL, 1, 'COMP-0019', 'COMP-0019.pdf', '2018-11-02 17:41:31'),
(58, 5, '417.00', '33.00', '450.00', 'fewf', 1, NULL, NULL, NULL, 1, 'COMP-0020', 'COMP-0020.pdf', '2018-11-02 17:42:39'),
(59, 5, '890.00', '10.00', '900.00', 'qwfw', 1, NULL, NULL, NULL, 1, 'COMP-0021', 'COMP-0021.pdf', '2018-11-02 17:50:32'),
(60, 5, '1067.00', '33.00', '1100.00', 'sdgsed', 1, NULL, NULL, NULL, 1, 'COMP-0022', 'COMP-0022.pdf', '2018-11-02 18:04:39'),
(61, 5, '782.00', '18.00', '800.00', 'qefwqw', 1, NULL, NULL, NULL, 1, 'COMP-0023', 'COMP-0023.pdf', '2018-11-02 18:08:35'),
(62, 5, '792.00', '8.00', '800.00', 'qefwef', 1, NULL, NULL, NULL, 1, 'COMP-0024', NULL, '2018-11-02 18:13:29'),
(63, 5, '1472.00', '28.00', '1500.00', 'zv', 1, NULL, NULL, NULL, 1, 'COMP-0025', 'COMP-0025.pdf', '2018-11-02 18:14:38'),
(64, 5, '690.00', '10.00', '700.00', 'rsge', 1, NULL, NULL, NULL, 1, 'COMP-0026', 'COMP-0026.pdf', '2018-11-02 18:16:13'),
(65, 6, '1672.00', '128.00', '1800.00', 'ewfew', 1, NULL, NULL, NULL, 1, 'COMP-0027', 'COMP-0027.pdf', '2018-11-02 18:21:43');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagodetalle`
--

DROP TABLE IF EXISTS `pagodetalle`;
CREATE TABLE IF NOT EXISTS `pagodetalle` (
  `idDetallePago` int(11) NOT NULL AUTO_INCREMENT,
  `Cabecera_idCabecera` int(11) DEFAULT NULL,
  `Alumno_idAlumno` int(11) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `TipoPago` int(11) DEFAULT NULL,
  `NombrePago` varchar(150) NOT NULL,
  `ImportePago` decimal(10,2) NOT NULL,
  `Cuota_idCuota` int(11) DEFAULT NULL,
  `TipoPago_idTipoPago` int(11) DEFAULT NULL,
  `fechaRegistro` datetime NOT NULL,
  `Estado_idEstado` int(11) DEFAULT NULL,
  PRIMARY KEY (`idDetallePago`),
  KEY `FK_PAGODeta` (`Cuota_idCuota`),
  KEY `FK_DETALLEPAGO` (`Alumno_idAlumno`),
  KEY `FK_dETALLETIPOvf` (`TipoPago_idTipoPago`),
  KEY `FKEscABEdwqd` (`Cabecera_idCabecera`),
  KEY `FKEscABwdwqE` (`Estado_idEstado`)
) ENGINE=InnoDB AUTO_INCREMENT=296 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `pagodetalle`
--

INSERT INTO `pagodetalle` (`idDetallePago`, `Cabecera_idCabecera`, `Alumno_idAlumno`, `year`, `TipoPago`, `NombrePago`, `ImportePago`, `Cuota_idCuota`, `TipoPago_idTipoPago`, `fechaRegistro`, `Estado_idEstado`) VALUES
(193, 39, 4, 2017, 1, 'Pago de Matricula', '250.00', NULL, 1, '2018-10-31 05:23:09', 10),
(194, 39, 4, 2017, 1, 'Pago de Computación', '120.00', NULL, 3, '2018-10-31 05:23:09', 10),
(195, 39, 4, 2017, 1, 'Pago de Certificado', '100.00', NULL, 4, '2018-10-31 05:23:09', 10),
(196, 39, 4, 2017, 1, 'Pago de Ingles', '120.00', NULL, 5, '2018-10-31 05:23:09', 10),
(197, 39, 4, 2017, 1, 'Pago Otro', '100.00', NULL, 6, '2018-10-31 05:23:09', 10),
(198, 39, 4, 2017, 1, 'Pago Otro', '200.00', NULL, 7, '2018-10-31 05:23:09', 10),
(199, 39, 4, 2017, 1, 'PENSIÓN MARZO', '200.00', 1029, NULL, '2018-10-31 17:51:22', 10),
(200, 39, 4, 2017, 2, 'MORA DE PENSIÓN MARZO', '580.00', 1029, NULL, '2018-10-31 17:51:22', 10),
(201, 40, 4, 2017, 1, 'PENSIÓN ABRIL', '200.00', 1030, NULL, '2018-10-31 18:30:48', 10),
(202, 40, 4, 2017, 2, 'MORA DE PENSIÓN ABRIL', '549.00', 1030, NULL, '2018-10-31 18:30:48', 10),
(203, 40, 4, 2017, 1, 'PENSIÓN MAYO', '200.00', 1031, NULL, '2018-10-31 18:30:55', 10),
(204, 40, 4, 2017, 2, 'MORA DE PENSIÓN MAYO', '519.00', 1031, NULL, '2018-10-31 18:30:56', 10),
(205, 40, 4, 2017, 1, 'PENSIÓN JUNIO', '200.00', 1032, NULL, '2018-10-31 18:31:06', 10),
(206, 40, 4, 2017, 2, 'MORA DE PENSIÓN JUNIO', '488.00', 1032, NULL, '2018-10-31 18:31:06', 10),
(207, 41, 4, 2017, 1, 'PENSIÓN JULIO', '200.00', 1033, NULL, '2018-10-31 18:31:58', 10),
(208, 41, 4, 2017, 2, 'MORA DE PENSIÓN JULIO', '458.00', 1033, NULL, '2018-10-31 18:31:58', 10),
(211, 42, 4, 2018, 1, 'Pago de Matricula', '250.00', NULL, 1, '2018-11-02 15:56:18', 10),
(212, 42, 4, 2018, 1, 'Pago de Computación', '120.00', NULL, 3, '2018-11-02 15:56:18', 10),
(213, 42, 4, 2018, 1, 'Pago de Certificado', '100.00', NULL, 4, '2018-11-02 15:56:18', 10),
(214, 42, 4, 2018, 1, 'Pago de Ingles', '120.00', NULL, 5, '2018-11-02 15:56:18', 10),
(215, 42, 4, 2018, 1, 'Pago Otro', '100.00', NULL, 6, '2018-11-02 15:56:18', 10),
(220, 43, 4, 2018, 1, 'PENSIÓN MARZO', '200.00', 973, NULL, '2018-11-02 16:47:07', 10),
(221, 43, 4, 2018, 2, 'MORA DE PENSIÓN MARZO', '217.00', 973, NULL, '2018-11-02 16:47:07', 10),
(222, 44, 4, 2018, 1, 'PENSIÓN  ABRIL', '200.00', 974, NULL, '2018-11-02 16:49:36', 10),
(223, 44, 4, 2018, 2, 'ABRIL', '186.00', 974, NULL, '2018-11-02 16:49:36', 10),
(224, 44, 4, 2018, 1, 'PENSIÓN  MAYO', '200.00', 975, NULL, '2018-11-02 16:51:07', 10),
(225, 44, 4, 2018, 2, 'MAYO', '156.00', 975, NULL, '2018-11-02 16:51:07', 10),
(226, 45, 4, 2018, 1, 'PENSIÓN JUNIO', '200.00', 976, NULL, '2018-11-02 17:00:23', 10),
(227, 45, 4, 2018, 2, 'MORA DE PENSIÓN JUNIO', '125.00', 976, NULL, '2018-11-02 17:00:23', 10),
(228, 46, 4, 2018, 1, 'PENSIÓN JULIO', '200.00', 977, NULL, '2018-11-02 17:06:03', 10),
(229, 46, 4, 2018, 2, 'MORA DE PENSIÓN JULIO', '95.00', 977, NULL, '2018-11-02 17:06:03', 10),
(230, 47, 4, 2017, 1, 'PENSIÓN AGOSTO', '200.00', 1034, NULL, '2018-11-02 17:07:16', 10),
(231, 47, 4, 2017, 2, 'MORA DE PENSIÓN AGOSTO', '429.00', 1034, NULL, '2018-11-02 17:07:16', 10),
(232, 48, 4, 2018, 1, 'PENSIÓN AGOSTO', '200.00', 978, NULL, '2018-11-02 17:09:05', 10),
(233, 48, 4, 2018, 2, 'MORA DE PENSIÓN AGOSTO', '64.00', 978, NULL, '2018-11-02 17:09:05', 10),
(234, 49, 4, 2018, 1, 'PENSIÓN SEPTIEMBRE', '200.00', 979, NULL, '2018-11-02 17:11:46', 10),
(235, 49, 4, 2018, 2, 'MORA DE PENSIÓN SEPTIEMBRE', '33.00', 979, NULL, '2018-11-02 17:11:46', 10),
(236, 50, 4, 2018, 1, 'PENSIÓN  OCTUBRE', '200.00', 980, NULL, '2018-11-02 17:16:21', 10),
(237, 50, 4, 2018, 2, 'OCTUBRE', '3.00', 980, NULL, '2018-11-02 17:16:21', 10),
(238, 51, 4, 2018, 1, 'PENSIÓN  NOVIEMBRE', '200.00', 981, NULL, '2018-11-02 17:18:12', 10),
(239, 52, 4, 2017, 1, 'PENSIÓN  SEPTIEMBRE', '200.00', 1035, NULL, '2018-11-02 17:21:57', 10),
(240, 52, 4, 2017, 2, 'SEPTIEMBRE', '398.00', 1035, NULL, '2018-11-02 17:21:57', 10),
(241, 53, 4, 2017, 1, 'PENSIÓN  OCTUBRE', '200.00', 1036, NULL, '2018-11-02 17:26:02', 10),
(242, 53, 4, 2017, 2, 'OCTUBRE', '368.00', 1036, NULL, '2018-11-02 17:26:02', 10),
(243, 54, 4, 2017, 1, 'PENSIÓN  NOVIEMBRE', '200.00', 1037, NULL, '2018-11-02 17:30:23', 10),
(244, 54, 4, 2017, 2, 'NOVIEMBRE', '337.00', 1037, NULL, '2018-11-02 17:30:23', 10),
(245, 55, 4, 2017, 1, 'PENSIÓN  DICIEMBRE', '200.00', 1038, NULL, '2018-11-02 17:33:09', 10),
(246, 55, 4, 2017, 2, 'DICIEMBRE', '307.00', 1038, NULL, '2018-11-02 17:33:09', 10),
(247, 56, 4, 2018, 1, 'PENSIÓN  DICIEMBRE', '200.00', 982, NULL, '2018-11-02 17:39:20', 10),
(248, 57, 5, 2018, 1, 'Pago de Matricula', '250.00', NULL, 1, '2018-11-02 17:41:12', 10),
(249, 57, 5, 2018, 1, 'Pago de Computación', '120.00', NULL, 3, '2018-11-02 17:41:12', 10),
(250, 57, 5, 2018, 1, 'Pago de Certificado', '100.00', NULL, 4, '2018-11-02 17:41:12', 10),
(251, 57, 5, 2018, 1, 'Pago de Ingles', '120.00', NULL, 5, '2018-11-02 17:41:12', 10),
(252, 57, 5, 2018, 1, 'Pago Otro', '100.00', NULL, 6, '2018-11-02 17:41:12', 10),
(253, 58, 5, 2018, 1, 'PENSIÓN MARZO', '200.00', 983, NULL, '2018-11-02 17:42:26', 10),
(254, 58, 5, 2018, 2, 'MORA DE PENSIÓN MARZO', '217.00', 983, NULL, '2018-11-02 17:42:26', 10),
(255, 59, 5, 2017, 1, 'Pago de Matricula', '250.00', NULL, 1, '2018-11-02 17:50:10', 10),
(256, 59, 5, 2017, 1, 'Pago de Computación', '120.00', NULL, 3, '2018-11-02 17:50:19', 10),
(257, 59, 5, 2017, 1, 'Pago de Certificado', '100.00', NULL, 4, '2018-11-02 17:50:19', 10),
(258, 59, 5, 2017, 1, 'Pago de Ingles', '120.00', NULL, 5, '2018-11-02 17:50:19', 10),
(259, 59, 5, 2017, 1, 'Pago Otro', '100.00', NULL, 6, '2018-11-02 17:50:19', 10),
(260, 59, 5, 2017, 1, 'Pago Otro', '200.00', NULL, 7, '2018-11-02 17:50:19', 10),
(261, 60, 5, 2018, 1, 'PENSIÓN  ABRIL', '200.00', 984, NULL, '2018-11-02 18:04:24', 10),
(262, 60, 5, 2018, 2, 'ABRIL', '186.00', 984, NULL, '2018-11-02 18:04:24', 10),
(263, 60, 5, 2018, 1, 'PENSIÓN  MAYO', '200.00', 985, NULL, '2018-11-02 18:04:24', 10),
(264, 60, 5, 2018, 2, 'MAYO', '156.00', 985, NULL, '2018-11-02 18:04:24', 10),
(265, 60, 5, 2018, 1, 'PENSIÓN  JUNIO', '200.00', 986, NULL, '2018-11-02 18:04:24', 10),
(266, 60, 5, 2018, 2, 'JUNIO', '125.00', 986, NULL, '2018-11-02 18:04:24', 10),
(267, 61, 5, 2017, 1, 'PENSIÓN MARZO', '200.00', 883, NULL, '2018-11-02 18:08:25', 10),
(268, 61, 5, 2017, 2, 'MORA DE PENSIÓN MARZO', '582.00', 883, NULL, '2018-11-02 18:08:25', 10),
(269, 62, 5, 2018, 1, 'PENSIÓN  JULIO', '200.00', 987, NULL, '2018-11-02 18:12:01', 10),
(270, 62, 5, 2018, 2, 'JULIO', '95.00', 987, NULL, '2018-11-02 18:12:01', 10),
(271, 62, 5, 2018, 1, 'PENSIÓN  AGOSTO', '200.00', 988, NULL, '2018-11-02 18:12:01', 10),
(272, 62, 5, 2018, 2, 'AGOSTO', '64.00', 988, NULL, '2018-11-02 18:12:01', 10),
(273, 62, 5, 2018, 1, 'PENSIÓN  SEPTIEMBRE', '200.00', 989, NULL, '2018-11-02 18:12:01', 10),
(274, 62, 5, 2018, 2, 'SEPTIEMBRE', '33.00', 989, NULL, '2018-11-02 18:12:01', 10),
(281, 63, 5, 2017, 1, 'PENSIÓN  ABRIL', '200.00', 884, NULL, '2018-11-02 18:14:24', 10),
(282, 63, 5, 2017, 2, 'ABRIL', '551.00', 884, NULL, '2018-11-02 18:14:24', 10),
(283, 63, 5, 2017, 1, 'PENSIÓN  MAYO', '200.00', 885, NULL, '2018-11-02 18:14:24', 10),
(284, 63, 5, 2017, 2, 'MAYO', '521.00', 885, NULL, '2018-11-02 18:14:24', 10),
(285, 64, 5, 2017, 1, 'PENSIÓN  JUNIO', '200.00', 886, NULL, '2018-11-02 18:16:04', 10),
(286, 64, 5, 2017, 2, 'JUNIO', '490.00', 886, NULL, '2018-11-02 18:16:04', 10),
(287, 65, 6, 2017, 1, 'Pago de Matricula', '250.00', NULL, 1, '2018-11-02 18:21:27', 10),
(288, 65, 6, 2017, 1, 'Pago de Computación', '120.00', NULL, 3, '2018-11-02 18:21:27', 10),
(289, 65, 6, 2017, 1, 'Pago de Certificado', '100.00', NULL, 4, '2018-11-02 18:21:27', 10),
(290, 65, 6, 2017, 1, 'Pago de Ingles', '120.00', NULL, 5, '2018-11-02 18:21:27', 10),
(291, 65, 6, 2017, 1, 'Pago Otro', '100.00', NULL, 6, '2018-11-02 18:21:27', 10),
(292, 65, 6, 2017, 1, 'Pago Otro', '200.00', NULL, 7, '2018-11-02 18:21:27', 10),
(293, 65, 6, 2017, 1, 'PENSIÓN  MARZO', '200.00', 893, NULL, '2018-11-02 18:21:27', 10),
(294, 65, 6, 2017, 2, 'MARZO', '582.00', 893, NULL, '2018-11-02 18:21:27', 10),
(295, NULL, 8, 2017, 1, 'Pago de Matricula', '250.00', NULL, 1, '2018-11-05 02:11:24', 9);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `perfil`
--

DROP TABLE IF EXISTS `perfil`;
CREATE TABLE IF NOT EXISTS `perfil` (
  `idPerfil` int(11) NOT NULL AUTO_INCREMENT,
  `nombrePerfil` varchar(50) NOT NULL,
  `descripcionPerfil` text NOT NULL,
  `Estado_idEstado` int(11) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  PRIMARY KEY (`idPerfil`),
  KEY `FK_Estado` (`Estado_idEstado`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `perfil`
--

INSERT INTO `perfil` (`idPerfil`, `nombrePerfil`, `descripcionPerfil`, `Estado_idEstado`, `fechaRegistro`) VALUES
(1, 'ADMINISTRADOR', 'ADMINISTRADOR GENERAL DEL SISTEMA', 1, '2018-09-29 13:29:55'),
(6, 'EMPLEADO', 'EMPLEADO DE LA INSTITUCIÓN ENCARGADA DEL REGISTRO ACADEMICO', 1, '2018-10-07 20:14:07'),
(7, 'APODERADO', 'APODERADO - PADRE DE FAMILIA', 1, '2018-10-08 00:59:45'),
(8, 'ENCARGADO', 'ENCARGADO DEL PROCESO DE MATRICULA', 1, '2018-10-08 01:02:02'),
(9, 'ESTUDIANTE', 'ESTUDIANTES', 1, '2018-10-30 00:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

DROP TABLE IF EXISTS `permisos`;
CREATE TABLE IF NOT EXISTS `permisos` (
  `idPermisos` int(11) NOT NULL AUTO_INCREMENT,
  `Perfil_idPerfil` int(11) NOT NULL,
  `Permiso1` int(11) NOT NULL,
  `Permiso2` int(11) NOT NULL,
  `Permiso3` int(11) NOT NULL,
  PRIMARY KEY (`idPermisos`),
  KEY `FK_Perfil_idPerfil` (`Perfil_idPerfil`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `permisos`
--

INSERT INTO `permisos` (`idPermisos`, `Perfil_idPerfil`, `Permiso1`, `Permiso2`, `Permiso3`) VALUES
(5, 1, 1, 1, 1),
(6, 6, 1, 0, 0),
(7, 7, 1, 0, 0),
(8, 8, 1, 0, 1),
(9, 9, 1, 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `persona`
--

DROP TABLE IF EXISTS `persona`;
CREATE TABLE IF NOT EXISTS `persona` (
  `idPersona` int(11) NOT NULL AUTO_INCREMENT,
  `nombrePersona` varchar(50) NOT NULL,
  `apellidoPaterno` varchar(50) NOT NULL,
  `apellidoMaterno` varchar(50) NOT NULL,
  `DNI` char(8) NOT NULL,
  `fechaNacimiento` date DEFAULT NULL,
  `correo` varchar(50) DEFAULT NULL,
  `telefono` char(10) DEFAULT NULL,
  `direccion` text,
  `Estado_idEstado` int(11) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  PRIMARY KEY (`idPersona`),
  KEY `FK_Estado_idEstado` (`Estado_idEstado`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `persona`
--

INSERT INTO `persona` (`idPersona`, `nombrePersona`, `apellidoPaterno`, `apellidoMaterno`, `DNI`, `fechaNacimiento`, `correo`, `telefono`, `direccion`, `Estado_idEstado`, `fechaRegistro`) VALUES
(1, 'ADMINISTRADOR', 'GENERAL', 'DEL SISTEMA', '47040087', '2018-10-04', 'ADMINISTRADOR@HOTMAIL.COM', '23423423', 'DIRECCION', 1, '2018-09-29 13:45:53'),
(32, 'JOSE', 'RODRIGUEZ', 'ROMEROS', '47034923', '2010-01-21', NULL, NULL, 'AAHH ENRIQUE MILLA OCHOA MZ 853 LT 543', 1, '2018-10-09 02:36:09'),
(33, 'MARIA', 'DOMINGUEZ', 'VALENZUELA', '12412342', '2018-10-02', NULL, '5284039', NULL, 1, '2018-10-10 20:09:41'),
(34, 'JULIO', 'DOMINGO', 'GUZMAN', '42342343', '2018-10-16', NULL, NULL, NULL, 1, '2018-10-10 20:26:35'),
(35, 'ROMULO', 'SILVA', 'FUENTES', '32432434', '2018-10-09', NULL, NULL, NULL, 1, '2018-10-10 23:48:02'),
(36, 'ROBERTO', 'BENITEZ', 'JULIE', '3242343', '2011-03-09', NULL, NULL, NULL, 1, '2018-10-13 11:59:19'),
(37, 'VERONICA', 'PADILLA', 'CARRILLO', '23214123', '2018-10-10', NULL, '927383263', 'LOS URANOS', 1, '2018-10-13 12:09:06'),
(38, 'MARIA LUISA', 'PRIALE', 'DOMINGUEZ', '32423423', '2018-10-09', NULL, NULL, NULL, 1, '2018-10-13 12:21:38'),
(39, 'JOAQUINA', 'CARDENAS', 'PRADO', '47040092', '2000-10-17', NULL, NULL, NULL, 1, '2018-10-24 19:45:11'),
(40, 'MIGUEL ANGEL', 'LOPEZ', 'SUAREZ', '23423423', '2000-10-17', NULL, NULL, NULL, 1, '2018-10-24 19:46:04'),
(41, 'JESUS', 'INCA', 'ROMAN', '21432112', '2000-10-01', NULL, NULL, NULL, 1, '2018-10-24 19:46:29'),
(42, 'MARICIELO', 'ROMERO', 'SU', '23234234', '2000-10-15', NULL, NULL, NULL, 1, '2018-10-24 19:46:57'),
(43, 'MIGUEL', 'ZABALETA', 'GOMEZ', '32423432', '2000-10-20', NULL, NULL, NULL, 1, '2018-10-24 19:47:24'),
(44, 'GERMAN', 'RAMIREZ', 'ACOSTA', '77777777', '2018-10-16', NULL, NULL, NULL, 1, '2018-10-27 10:39:30'),
(45, 'LUIS', 'ROMERO', 'SUAREZ', '66666666', '2018-10-09', NULL, NULL, NULL, 1, '2018-10-27 10:41:51'),
(46, 'LUISA', 'ROSER', 'RUANI', '12131214', '2018-10-18', NULL, NULL, NULL, 1, '2018-10-27 10:43:49'),
(47, 'LUCAS', 'WEFWEF', 'WEFEW', '23423434', '2018-10-10', NULL, NULL, NULL, 1, '2018-10-27 10:47:03'),
(48, 'RODRIGO', 'FW', 'WFE', '66665555', '2018-10-09', NULL, NULL, NULL, 1, '2018-10-27 11:04:02'),
(49, 'PRUEBAF', 'RQWR', 'FWFWEF', '44333344', '2018-10-09', NULL, NULL, NULL, 1, '2018-10-27 11:14:15'),
(50, 'LUCASSS', 'FWEFE', 'WFE', '12333333', '2018-10-02', NULL, NULL, NULL, 1, '2018-10-27 11:18:06'),
(51, 'JESUSIN', 'WEFEW', 'WFEFWE', '12312312', '2018-10-10', NULL, NULL, NULL, 1, '2018-10-27 11:36:28');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planpago`
--

DROP TABLE IF EXISTS `planpago`;
CREATE TABLE IF NOT EXISTS `planpago` (
  `idPlanPago` int(11) NOT NULL AUTO_INCREMENT,
  `Alumno_idAlumno` int(11) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  `Observaciones` text,
  `Estado_idEstado` int(11) NOT NULL,
  PRIMARY KEY (`idPlanPago`),
  KEY `FK_Alumno_idAlumno` (`Alumno_idAlumno`),
  KEY `FK_Estado_idEstadoD` (`Estado_idEstado`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `relacionhijos`
--

DROP TABLE IF EXISTS `relacionhijos`;
CREATE TABLE IF NOT EXISTS `relacionhijos` (
  `idRelacionHijos` int(11) NOT NULL AUTO_INCREMENT,
  `Apoderado_idApoderado` int(11) NOT NULL,
  `Alumno_idAlumno` int(11) NOT NULL,
  `Estado_idEstado` int(11) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  PRIMARY KEY (`idRelacionHijos`),
  KEY `FK_Apoderado_idApoderado` (`Apoderado_idApoderado`),
  KEY `FK_Alumno_idAlumnoE` (`Alumno_idAlumno`),
  KEY `FK_Estado_idEstadoRel` (`Estado_idEstado`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `relacionhijos`
--

INSERT INTO `relacionhijos` (`idRelacionHijos`, `Apoderado_idApoderado`, `Alumno_idAlumno`, `Estado_idEstado`, `fechaRegistro`) VALUES
(2, 1, 5, 1, '2018-10-10 21:00:48'),
(3, 1, 4, 1, '2018-10-10 21:01:07'),
(4, 1, 6, 1, '2018-10-10 23:53:58'),
(5, 2, 7, 2, '2018-10-13 12:09:14');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `seccion`
--

DROP TABLE IF EXISTS `seccion`;
CREATE TABLE IF NOT EXISTS `seccion` (
  `idSeccion` int(1) NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(100) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  `Estado_idEstado` int(11) NOT NULL,
  PRIMARY KEY (`idSeccion`),
  KEY `FK_Estado_idEstadoSe` (`Estado_idEstado`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `seccion`
--

INSERT INTO `seccion` (`idSeccion`, `Descripcion`, `fechaRegistro`, `Estado_idEstado`) VALUES
(5, 'A', '2018-10-08 05:25:34', 1),
(6, 'B', '2018-10-08 05:25:40', 1),
(7, 'C', '2018-10-08 05:25:45', 1),
(8, 'D', '2018-10-08 05:25:50', 1),
(9, 'E', '2018-10-08 05:26:14', 1),
(10, 'F', '2018-10-08 05:26:23', 1),
(11, 'G', '2018-10-08 05:26:30', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipopago`
--

DROP TABLE IF EXISTS `tipopago`;
CREATE TABLE IF NOT EXISTS `tipopago` (
  `idTipoPago` int(11) NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(100) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  `Estado_idEstado` int(11) NOT NULL,
  PRIMARY KEY (`idTipoPago`),
  KEY `FK_Estado_idEstadoTipoPago` (`Estado_idEstado`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `tipopago`
--

INSERT INTO `tipopago` (`idTipoPago`, `Descripcion`, `fechaRegistro`, `Estado_idEstado`) VALUES
(1, 'EFECTIVO', '2018-10-08 19:34:48', 1),
(2, 'TARJETA DE CREDITO', '2018-10-08 19:34:59', 1),
(3, 'DEPOSITO EN CUENTA', '2018-10-08 19:35:19', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipotarjeta`
--

DROP TABLE IF EXISTS `tipotarjeta`;
CREATE TABLE IF NOT EXISTS `tipotarjeta` (
  `idTipoTarjeta` int(11) NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(100) NOT NULL,
  `Estado_idEstado` int(11) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  PRIMARY KEY (`idTipoTarjeta`),
  KEY `FK_Estado_idEstadoE` (`Estado_idEstado`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `tipotarjeta`
--

INSERT INTO `tipotarjeta` (`idTipoTarjeta`, `Descripcion`, `Estado_idEstado`, `fechaRegistro`) VALUES
(1, 'TARJETA VISA', 1, '2018-10-08 01:40:14'),
(2, 'TARJETA MASTER CARD', 1, '2018-10-08 01:40:14'),
(3, 'TARJETA DINNER CLUB', 1, '2018-10-08 01:40:27');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

DROP TABLE IF EXISTS `usuario`;
CREATE TABLE IF NOT EXISTS `usuario` (
  `idUsuario` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(50) NOT NULL,
  `pass` varchar(100) NOT NULL,
  `Perfil_idPerfil` int(11) NOT NULL,
  `Persona_idPersona` int(11) NOT NULL,
  `Estado_idEstado` int(11) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  PRIMARY KEY (`idUsuario`),
  KEY `Perfil_idPerfil` (`Perfil_idPerfil`) USING BTREE,
  KEY `Persona_idPersona` (`Persona_idPersona`) USING BTREE,
  KEY `Estado_idEstado` (`Estado_idEstado`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`idUsuario`, `usuario`, `pass`, `Perfil_idPerfil`, `Persona_idPersona`, `Estado_idEstado`, `fechaRegistro`) VALUES
(1, 'admin', '$2a$08$cA0RkRdv4rPKC/JPT.jn3OGA1lYmji1Wej6nKZSwQImJ/DSBZ7BNS', 1, 1, 1, '2018-09-29 14:03:15'),
(2, 'jrodriguezr', '$2a$08$EML/M.nWFZWz9lHcK/rSVugWcn/V9DfrdKZ72k0CL9mROvwe7tksu', 9, 32, 1, '2018-10-30 16:03:30'),
(3, 'jdomingog', '$2a$08$LMLVjMroYJSNN6DluJQ5MeJEg52TlUZknHxpH5fjHOj326ckY/ywm', 9, 34, 1, '2018-10-30 16:08:18'),
(4, 'jincar', '$2a$08$l8YKNaptY/4kzfHLy6XEfOECM6ngMmlYUWHeNCn4Hg6YUO.kurwya', 9, 41, 1, '2018-10-30 16:09:55');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `year`
--

DROP TABLE IF EXISTS `year`;
CREATE TABLE IF NOT EXISTS `year` (
  `idYear` int(11) NOT NULL AUTO_INCREMENT,
  `year` int(11) NOT NULL,
  PRIMARY KEY (`idYear`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `year`
--

INSERT INTO `year` (`idYear`, `year`) VALUES
(1, 2017),
(2, 2018),
(3, 2019),
(4, 2020);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `alumno`
--
ALTER TABLE `alumno`
  ADD CONSTRAINT `FK_Grado_idGrado` FOREIGN KEY (`Grado_idGrado`) REFERENCES `grado` (`idGrado`),
  ADD CONSTRAINT `FK_Nivel_idNivel` FOREIGN KEY (`Nivel_idNivel`) REFERENCES `nivel` (`idNivel`),
  ADD CONSTRAINT `FK_Persona_idPersona` FOREIGN KEY (`Persona_idPersona`) REFERENCES `persona` (`idPersona`),
  ADD CONSTRAINT `FK_Seccion_idSeccion` FOREIGN KEY (`Seccion_idSeccion`) REFERENCES `seccion` (`idSeccion`);

--
-- Filtros para la tabla `alumnopagos`
--
ALTER TABLE `alumnopagos`
  ADD CONSTRAINT `FK_ALUMNOSPAGOS` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`),
  ADD CONSTRAINT `FK_AlumnoPagosImportes` FOREIGN KEY (`TipoPago_idTipoPago`) REFERENCES `generalimportes` (`idGeneral`),
  ADD CONSTRAINT `FK_Alumno_idAlumnoPago` FOREIGN KEY (`Alumno_idAlumno`) REFERENCES `alumno` (`idAlumno`);

--
-- Filtros para la tabla `apoderado`
--
ALTER TABLE `apoderado`
  ADD CONSTRAINT `FK_Persona_idPersonaApo` FOREIGN KEY (`Persona_idPersona`) REFERENCES `persona` (`idPersona`),
  ADD CONSTRAINT `FK_TipoTarjeta_idTipoTarjeta` FOREIGN KEY (`TipoTarjeta_idTipoTarjeta`) REFERENCES `tipotarjeta` (`idTipoTarjeta`);

--
-- Filtros para la tabla `cuota`
--
ALTER TABLE `cuota`
  ADD CONSTRAINT `FKALUMNOCUOTA` FOREIGN KEY (`Alumno_idAlumno`) REFERENCES `alumno` (`idAlumno`),
  ADD CONSTRAINT `FK_Estado_idEstadoCuota` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`),
  ADD CONSTRAINT `FK_PlanPago_idPlanPago` FOREIGN KEY (`PlanPago_idPlanPago`) REFERENCES `planpago` (`idPlanPago`);

--
-- Filtros para la tabla `generalimportes`
--
ALTER TABLE `generalimportes`
  ADD CONSTRAINT `FKImportes` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`);

--
-- Filtros para la tabla `grado`
--
ALTER TABLE `grado`
  ADD CONSTRAINT `FK_Estado_idEstadoGra` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`);

--
-- Filtros para la tabla `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `FK_Usuario_idUsuario2` FOREIGN KEY (`Usuario_idUsuario`) REFERENCES `usuario` (`idUsuario`);

--
-- Filtros para la tabla `matricula`
--
ALTER TABLE `matricula`
  ADD CONSTRAINT `FKM1` FOREIGN KEY (`Alumno_idAlumno`) REFERENCES `alumno` (`idAlumno`),
  ADD CONSTRAINT `FKM2` FOREIGN KEY (`Grado_idGrado`) REFERENCES `grado` (`idGrado`),
  ADD CONSTRAINT `FKM3` FOREIGN KEY (`Seccion_idSeccion`) REFERENCES `seccion` (`idSeccion`),
  ADD CONSTRAINT `FKM4` FOREIGN KEY (`Nivel_idNivel`) REFERENCES `nivel` (`idNivel`);

--
-- Filtros para la tabla `nivel`
--
ALTER TABLE `nivel`
  ADD CONSTRAINT `FK_Estado_idEstadoNivel` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`);

--
-- Filtros para la tabla `pagocabecera`
--
ALTER TABLE `pagocabecera`
  ADD CONSTRAINT `FKEscABE` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`),
  ADD CONSTRAINT `FK_CAB_AL` FOREIGN KEY (`Alumno_idAlumno`) REFERENCES `alumno` (`idAlumno`),
  ADD CONSTRAINT `FK_CAB_AP` FOREIGN KEY (`Apoderado_idApoderado`) REFERENCES `apoderado` (`idApoderado`),
  ADD CONSTRAINT `FK_CAB_TT` FOREIGN KEY (`TipoTarjeta_idTipoTarjeta`) REFERENCES `tipotarjeta` (`idTipoTarjeta`);

--
-- Filtros para la tabla `pagodetalle`
--
ALTER TABLE `pagodetalle`
  ADD CONSTRAINT `FKEscABEdwqd` FOREIGN KEY (`Cabecera_idCabecera`) REFERENCES `pagocabecera` (`idPago`),
  ADD CONSTRAINT `FKEscABwdwqE` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`),
  ADD CONSTRAINT `FK_DETALLEPAGO` FOREIGN KEY (`Alumno_idAlumno`) REFERENCES `alumno` (`idAlumno`),
  ADD CONSTRAINT `FK_PAGODeta` FOREIGN KEY (`Cuota_idCuota`) REFERENCES `cuota` (`idCuota`),
  ADD CONSTRAINT `FK_dETALLETIPOvf` FOREIGN KEY (`TipoPago_idTipoPago`) REFERENCES `generalimportes` (`idGeneral`);

--
-- Filtros para la tabla `perfil`
--
ALTER TABLE `perfil`
  ADD CONSTRAINT `FK_ESTADO` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`);

--
-- Filtros para la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD CONSTRAINT `FK_Perfil_idPerfil` FOREIGN KEY (`Perfil_idPerfil`) REFERENCES `perfil` (`idPerfil`);

--
-- Filtros para la tabla `persona`
--
ALTER TABLE `persona`
  ADD CONSTRAINT `FK_Estado_idEstado` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`);

--
-- Filtros para la tabla `planpago`
--
ALTER TABLE `planpago`
  ADD CONSTRAINT `FK_Alumno_idAlumno` FOREIGN KEY (`Alumno_idAlumno`) REFERENCES `alumno` (`idAlumno`),
  ADD CONSTRAINT `FK_Estado_idEstadoD` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`);

--
-- Filtros para la tabla `relacionhijos`
--
ALTER TABLE `relacionhijos`
  ADD CONSTRAINT `FK_Alumno_idAlumnoE` FOREIGN KEY (`Alumno_idAlumno`) REFERENCES `alumno` (`idAlumno`),
  ADD CONSTRAINT `FK_Apoderado_idApoderado` FOREIGN KEY (`Apoderado_idApoderado`) REFERENCES `apoderado` (`idApoderado`),
  ADD CONSTRAINT `FK_Estado_idEstadoRel` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`);

--
-- Filtros para la tabla `seccion`
--
ALTER TABLE `seccion`
  ADD CONSTRAINT `FK_Estado_idEstadoSe` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`);

--
-- Filtros para la tabla `tipopago`
--
ALTER TABLE `tipopago`
  ADD CONSTRAINT `FK_Estado_idEstadoTipoPago` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`);

--
-- Filtros para la tabla `tipotarjeta`
--
ALTER TABLE `tipotarjeta`
  ADD CONSTRAINT `FK_Estado_idEstadoE` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `FK_Estado_idEstado2` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`),
  ADD CONSTRAINT `FK_Perfil_idPerfil2` FOREIGN KEY (`Perfil_idPerfil`) REFERENCES `perfil` (`idPerfil`),
  ADD CONSTRAINT `FK_Persona_idPersona2` FOREIGN KEY (`Persona_idPersona`) REFERENCES `persona` (`idPersona`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;