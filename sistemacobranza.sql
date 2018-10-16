-- phpMyAdmin SQL Dump
-- version 4.7.9
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 12-10-2018 a las 12:47:26
-- Versión del servidor: 5.7.21
-- Versión de PHP: 5.6.35    ykgykgkygkgkgk

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
DROP PROCEDURE IF EXISTS `SP_ALUMNO_ACTUALIZAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ALUMNO_ACTUALIZAR` (IN `nombre` VARCHAR(100), IN `apellidoP` VARCHAR(100), IN `apellidoM` VARCHAR(100), IN `DNI` INT(10), IN `fechaNacimiento` DATE, IN `correo` VARCHAR(100), IN `telefono` INT(10), IN `Direccion` TEXT, IN `estado` INT(11), IN `nivel` INT(11), IN `grado` INT(11), IN `seccion` INT(11), IN `imagenU` INT(11), IN `idPersonaU` INT(11), IN `idAlumnoU` INT(11), IN `creador` INT(11))  NO SQL
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
if(imagenU='0')then
SET imagenU=null;
end if;

UPDATE `persona` SET `nombrePersona`=UPPER(nombre),`apellidoPaterno`=UPPER(apellidoP),`apellidoMaterno`=UPPER(apellidoM),`DNI`=DNI,`fechaNacimiento`=fechaNacimiento,`correo`=UPPER(correo),`telefono`=telefono,`direccion`=UPPER(Direccion),`Estado_idEstado`=estado WHERE `idPersona`=idPersonaU;

UPDATE `alumno` SET `imagen`=imagenU,`Nivel_idNivel`=nivel,`Grado_idGrado`=grado,`Seccion_idSeccion`=seccion WHERE `idAlumno`=idAlumnoU;

/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=creador);

INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'ACTUALIZACION','Alumno',CONCAT('SE ACTUALIZO Alumno:',nombre,' ',apellidoP,' ',apellidoM),NOW());
END$$

DROP PROCEDURE IF EXISTS `SP_ALUMNO_LISTAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ALUMNO_LISTAR` ()  NO SQL
BEGIN

SELECT
(SELECT COUNT(*) FROM planpago pa WHERE pa.Alumno_idAlumno=al.idAlumno) as PlanP,p.idPersona,al.idAlumno,CONCAT(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombrePersona,p.DNI,p.fechaRegistro,e.idEstado as Estado_idEstado,e.nombreEstado,n.idNivel,n.Descripcion as NivelNombre,g.idGrado,g.Descripcion as GradoNombre,s.idSeccion,s.Descripcion as SeccionNombre
FROM persona p INNER JOIN alumno al ON al.Persona_idPersona=p.idPersona INNER JOIN estado e ON e.idEstado=p.Estado_idEstado INNER JOIN nivel n ON n.idNivel=al.Nivel_idNivel INNER JOIN grado g ON g.idGrado=al.Grado_idGrado INNER JOIN seccion s ON s.idSeccion=al.Seccion_idSeccion;


END$$

DROP PROCEDURE IF EXISTS `SP_ALUMNO_RECUPERAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ALUMNO_RECUPERAR` (IN `idPersonaE` INT(11), IN `idAlumnoE` INT(11))  NO SQL
BEGIN

SELECT
(SELECT COUNT(*) FROM planpago pa WHERE pa.Alumno_idAlumno=al.idAlumno) as PlanP,p.idPersona,al.idAlumno,p.nombrePersona,p.apellidoPaterno,p.apellidoMaterno,p.DNI,p.fechaRegistro,p.fechaNacimiento,p.correo,p.telefono,p.direccion,e.idEstado as Estado_idEstado,e.nombreEstado,n.idNivel,n.Descripcion as NivelNombre,g.idGrado,g.Descripcion as GradoNombre,s.idSeccion,s.Descripcion as SeccionNombre,pla.fechaRegistro as fechaMatricula,pla.montoCuota,pla.montoMatricula,pla.otroPago1,pla.otroPago2,pla.Observaciones FROM persona p INNER JOIN alumno al ON al.Persona_idPersona=p.idPersona INNER JOIN estado e ON e.idEstado=p.Estado_idEstado INNER JOIN nivel n ON n.idNivel=al.Nivel_idNivel INNER JOIN grado g ON g.idGrado=al.Grado_idGrado INNER JOIN seccion s ON s.idSeccion=al.Seccion_idSeccion
LEFT JOIN planpago pla ON pla.Alumno_idAlumno=al.idAlumno
WHERE p.idPersona=idPersonaE and al.idAlumno=idAlumnoE;


END$$

DROP PROCEDURE IF EXISTS `SP_ALUMNO_REGISTRO`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ALUMNO_REGISTRO` (IN `nombre` VARCHAR(100), IN `apellidoP` VARCHAR(100), IN `apellidoM` VARCHAR(100), IN `DNI` INT(11), IN `fechaNacimiento` DATE, IN `correo` VARCHAR(100), IN `telefono` INT, IN `Direccion` TEXT, IN `estado` INT(11), IN `imagen` VARCHAR(100), IN `nivel` INT(11), IN `grado` INT(11), IN `seccion` INT(11), IN `creador` INT(11))  NO SQL
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
if(imagen='0')THEN
SET imagen=null;
end if;

INSERT INTO `persona`(`idPersona`, `nombrePersona`, `apellidoPaterno`, `apellidoMaterno`, `DNI`, `fechaNacimiento`, `correo`, `telefono`, `direccion`, `Estado_idEstado`, `fechaRegistro`) VALUES (NULL,UPPER(nombre),UPPER(apellidoP),UPPER(apellidoM),DNI,fechaNacimiento,UPPER(correo),telefono,UPPER(Direccion),estado,NOW());


SET idPersonaNew=(SELECT LAST_INSERT_ID());


INSERT INTO `alumno`(`idAlumno`, `imagen`, `Persona_idPersona`, `Nivel_idNivel`, `Grado_idGrado`, `Seccion_idSeccion`, `fechaRegistro`) VALUES (NULL,imagen,idPersonaNew,nivel,grado,seccion,NOW());

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


SELECT cu.idCuota, cu.Estado_idEstado,e.nombreEstado,cu.Importe,cu.Diferencia,cu.fechaRegistro,cu.fechaVencimiento FROM alumno al INNER JOIN planpago pla ON pla.Alumno_idAlumno=al.idAlumno INNER JOIN cuota cu ON cu.PlanPago_idPlanPago=pla.idPlanPago INNER JOIN estado e ON e.idEstado=cu.Estado_idEstado
WHERE al.idAlumno=idAlumnoU;

END$$

DROP PROCEDURE IF EXISTS `SP_CUOTA_AGREGAR`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CUOTA_AGREGAR` (IN `idALumnoU` INT(11), IN `creador` INT(11))  NO SQL
BEGIN

DECLARE montoCuotaV DECIMAL(7,2);
DECLARE idPlanV INT (4);


 DECLARE c1 CURSOR FOR
SELECT pla.montoCuota,pla.idPlanPago FROM planpago pla INNER JOIN alumno al ON al.idAlumno=pla.Alumno_idAlumno where al.idAlumno=idALumnoU;

open c1;
fetch c1 into montoCuotaV,idPlanV;

INSERT INTO `cuota`(`idCuota`, `PlanPago_idPlanPago`, `Importe`, `Diferencia`, `fechaRegistro`, `fechaVencimiento`, `Estado_idEstado`) VALUES (NULL,idPlanV,montoCuotaV,montoCuotaV,NOW(),DATE(DATE_ADD(now(), INTERVAL 1 MONTH)),5);


/* ------ REGISTRO DE BITACORA ------ */
SET @NombreUsuario=(SELECT concat(p.nombrePersona,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as NombresPersona FROM usuario u inner join persona p ON p.idPersona=u.Persona_idPersona WHERE u.idUsuario=creador);


INSERT INTO `bitacora`(`idBitacora`, `usuarioAccion`, `Accion`, `tablaAccion`,`Detalle`, `fechaRegistro`) VALUES (null,@NombreUsuario,'REGISTRO','Cuota',CONCAT('SE REGISTRO Cuota Nueva:',idALumnoU),NOW());

CLOSE c1;

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
if(pass='-1')then

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
  `Nivel_idNivel` int(11) NOT NULL,
  `Grado_idGrado` int(11) NOT NULL,
  `Seccion_idSeccion` int(11) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  PRIMARY KEY (`idAlumno`),
  KEY `FK_Persona_idPersona` (`Persona_idPersona`),
  KEY `FK_Nivel_idNivel` (`Nivel_idNivel`),
  KEY `FK_Grado_idGrado` (`Grado_idGrado`),
  KEY `FK_Seccion_idSeccion` (`Seccion_idSeccion`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `alumno`
--

INSERT INTO `alumno` (`idAlumno`, `imagen`, `Persona_idPersona`, `Nivel_idNivel`, `Grado_idGrado`, `Seccion_idSeccion`, `fechaRegistro`) VALUES
(4, NULL, 32, 2, 13, 8, '2018-10-09 02:36:09'),
(5, NULL, 33, 2, 14, 6, '2018-10-10 20:09:41'),
(6, NULL, 35, 2, 14, 9, '2018-10-10 23:48:02');

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `apoderado`
--

INSERT INTO `apoderado` (`idApoderado`, `Persona_idPersona`, `TipoTarjeta_idTipoTarjeta`, `Detalle`, `fechaRegistro`) VALUES
(1, 34, NULL, NULL, '2018-10-10 20:26:35');

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
) ENGINE=InnoDB AUTO_INCREMENT=310 DEFAULT CHARSET=latin1;

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
(309, 'ADMINISTRADOR GENERAL DEL SISTEMA', 'REGISTRO', 'Cuota', 'SE REGISTRO Cuota Nueva:4', '2018-10-11 23:29:05');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuota`
--

DROP TABLE IF EXISTS `cuota`;
CREATE TABLE IF NOT EXISTS `cuota` (
  `idCuota` int(11) NOT NULL AUTO_INCREMENT,
  `PlanPago_idPlanPago` int(11) NOT NULL,
  `Importe` decimal(7,2) NOT NULL,
  `Diferencia` decimal(7,2) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  `fechaVencimiento` date NOT NULL,
  `Estado_idEstado` int(11) NOT NULL,
  PRIMARY KEY (`idCuota`),
  KEY `FK_PlanPago_idPlanPago` (`PlanPago_idPlanPago`),
  KEY `FK_Estado_idEstadoCuota` (`Estado_idEstado`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `cuota`
--

INSERT INTO `cuota` (`idCuota`, `PlanPago_idPlanPago`, `Importe`, `Diferencia`, `fechaRegistro`, `fechaVencimiento`, `Estado_idEstado`) VALUES
(17, 1, '500.00', '500.00', '2018-10-11 23:29:05', '2018-11-11', 5);

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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

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
(8, 3, 'ANULADO');

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
(1, 1, 'admin', '$2a$08$RCuzW/8g2Lg4QMNCfmsa/uKp33rvDmdWrC.P40DOECJlMtPu16NMW', 'Administrador', '2018-09-29 14:03:44', '::1', '2018-10-08 01:25:10');

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
-- Estructura de tabla para la tabla `pago`
--

DROP TABLE IF EXISTS `pago`;
CREATE TABLE IF NOT EXISTS `pago` (
  `idPago` int(11) NOT NULL AUTO_INCREMENT,
  `Persona_idPersona` int(11) NOT NULL,
  `Cuota_idCuota` int(11) NOT NULL,
  `Importe` decimal(7,2) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  `TipoPago_idTipoPago` int(11) NOT NULL,
  `Estado_idEstado` int(11) NOT NULL,
  PRIMARY KEY (`idPago`),
  KEY `FK_Persona_idPersonaS` (`Persona_idPersona`),
  KEY `FK_Cuota_idCuota` (`Cuota_idCuota`),
  KEY `FK_Estado_idEstadoCu` (`Estado_idEstado`),
  KEY `FK_TipoPago_idTipoPago` (`TipoPago_idTipoPago`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `perfil`
--

INSERT INTO `perfil` (`idPerfil`, `nombrePerfil`, `descripcionPerfil`, `Estado_idEstado`, `fechaRegistro`) VALUES
(1, 'ADMINISTRADOR', 'ADMINISTRADOR GENERAL DEL SISTEMA', 1, '2018-09-29 13:29:55'),
(6, 'EMPLEADO', 'EMPLEADO DE LA INSTITUCIÓN ENCARGADA DEL REGISTRO ACADEMICO', 1, '2018-10-07 20:14:07'),
(7, 'APODERADO', 'APODERADO - PADRE DE FAMILIA', 1, '2018-10-08 00:59:45'),
(8, 'ENCARGADO', 'ENCARGADO DEL PROCESO DE MATRICULA', 1, '2018-10-08 01:02:02');

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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `permisos`
--

INSERT INTO `permisos` (`idPermisos`, `Perfil_idPerfil`, `Permiso1`, `Permiso2`, `Permiso3`) VALUES
(5, 1, 1, 1, 1),
(6, 6, 1, 0, 0),
(7, 7, 1, 0, 0),
(8, 8, 1, 0, 1);

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
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `persona`
--

INSERT INTO `persona` (`idPersona`, `nombrePersona`, `apellidoPaterno`, `apellidoMaterno`, `DNI`, `fechaNacimiento`, `correo`, `telefono`, `direccion`, `Estado_idEstado`, `fechaRegistro`) VALUES
(1, 'ADMINISTRADOR', 'GENERAL', 'DEL SISTEMA', '47040087', '2018-10-04', 'ADMINISTRADOR@HOTMAIL.COM', '55555', 'DIRECCION', 1, '2018-09-29 13:45:53'),
(32, 'ALUMNO', 'PRUEBA', 'PRUEBA', '23423432', '2018-10-10', NULL, NULL, NULL, 1, '2018-10-09 02:36:09'),
(33, 'SERGIO', 'INCA', 'CARDENAS', '12412342', '2018-10-02', NULL, '5284039', NULL, 1, '2018-10-10 20:09:41'),
(34, 'PAPA', 'APELLIDO P', 'APELLID M', '42342343', '2018-10-16', NULL, NULL, NULL, 1, '2018-10-10 20:26:35'),
(35, 'ALUMNOPRUEBA', 'QFQW', 'QWFQWF', '21312312', '2018-10-09', NULL, NULL, NULL, 1, '2018-10-10 23:48:02');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planpago`
--

DROP TABLE IF EXISTS `planpago`;
CREATE TABLE IF NOT EXISTS `planpago` (
  `idPlanPago` int(11) NOT NULL AUTO_INCREMENT,
  `Alumno_idAlumno` int(11) NOT NULL,
  `fechaRegistro` datetime NOT NULL,
  `montoCuota` decimal(7,2) NOT NULL,
  `montoMatricula` decimal(7,2) NOT NULL,
  `otroPago1` decimal(7,2) DEFAULT NULL,
  `otroPago2` decimal(7,2) DEFAULT NULL,
  `Observaciones` text,
  `Estado_idEstado` int(11) NOT NULL,
  PRIMARY KEY (`idPlanPago`),
  KEY `FK_Alumno_idAlumno` (`Alumno_idAlumno`),
  KEY `FK_Estado_idEstadoD` (`Estado_idEstado`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `planpago`
--

INSERT INTO `planpago` (`idPlanPago`, `Alumno_idAlumno`, `fechaRegistro`, `montoCuota`, `montoMatricula`, `otroPago1`, `otroPago2`, `Observaciones`, `Estado_idEstado`) VALUES
(1, 4, '2018-10-09 03:29:16', '500.00', '400.00', '0.00', '0.00', '', 1),
(2, 5, '2018-10-10 20:25:19', '350.00', '400.00', '0.00', '0.00', 'MATRICULA', 1);

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `relacionhijos`
--

INSERT INTO `relacionhijos` (`idRelacionHijos`, `Apoderado_idApoderado`, `Alumno_idAlumno`, `Estado_idEstado`, `fechaRegistro`) VALUES
(2, 1, 5, 1, '2018-10-10 21:00:48'),
(3, 1, 4, 1, '2018-10-10 21:01:07'),
(4, 1, 6, 1, '2018-10-10 23:53:58');

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`idUsuario`, `usuario`, `pass`, `Perfil_idPerfil`, `Persona_idPersona`, `Estado_idEstado`, `fechaRegistro`) VALUES
(1, 'admin', '$2a$08$Vo4zFrwFG.k2ZHhln/fQVu5NoeJdzJUSG6HOVA6fBCknS/umS0bki', 1, 1, 1, '2018-09-29 14:03:15');

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
-- Filtros para la tabla `apoderado`
--
ALTER TABLE `apoderado`
  ADD CONSTRAINT `FK_Persona_idPersonaApo` FOREIGN KEY (`Persona_idPersona`) REFERENCES `persona` (`idPersona`),
  ADD CONSTRAINT `FK_TipoTarjeta_idTipoTarjeta` FOREIGN KEY (`TipoTarjeta_idTipoTarjeta`) REFERENCES `tipotarjeta` (`idTipoTarjeta`);

--
-- Filtros para la tabla `cuota`
--
ALTER TABLE `cuota`
  ADD CONSTRAINT `FK_Estado_idEstadoCuota` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`),
  ADD CONSTRAINT `FK_PlanPago_idPlanPago` FOREIGN KEY (`PlanPago_idPlanPago`) REFERENCES `planpago` (`idPlanPago`);

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
-- Filtros para la tabla `nivel`
--
ALTER TABLE `nivel`
  ADD CONSTRAINT `FK_Estado_idEstadoNivel` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`);

--
-- Filtros para la tabla `pago`
--
ALTER TABLE `pago`
  ADD CONSTRAINT `FK_Cuota_idCuota` FOREIGN KEY (`Cuota_idCuota`) REFERENCES `cuota` (`idCuota`),
  ADD CONSTRAINT `FK_Estado_idEstadoCu` FOREIGN KEY (`Estado_idEstado`) REFERENCES `estado` (`idEstado`),
  ADD CONSTRAINT `FK_Persona_idPersonaS` FOREIGN KEY (`Persona_idPersona`) REFERENCES `persona` (`idPersona`),
  ADD CONSTRAINT `FK_TipoPago_idTipoPago` FOREIGN KEY (`TipoPago_idTipoPago`) REFERENCES `tipopago` (`idTipoPago`);

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
