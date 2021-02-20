----------------------------------------
--    Creación de la Base de Datos    --
----------------------------------------
CREATE DATABASE cbbawebcamm;




---------------------------------
--    Usar la Base de Datos    --
---------------------------------
USE cbbawebcamm;

/*-----------------------------------------
Tabla perfil

	-- Restricción de Nulabilidad
	-- Restricción de Chequeo de Valores
	-- Restricción de Unicidad
	-- Llave Primaria
	-- Campo autoGenerado
------------------------------------------*/
CREATE TABLE `perfil` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT, /* Campo autogenerado*/
	`nombre` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
	`estado` TINYINT(1) NOT NULL DEFAULT '1',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `nombre` (`nombre`) USING BTREE /*Restricción de Unicidad*/
)
COMMENT='Guarda los roles de usuario del sistema'
COLLATE='utf8_general_ci'
ENGINE=INNODB


-- Ingresar una restriccion --
ALTER TABLE perfil 
ADD CONSTRAINT check_estado CHECK (`estado` <= 1);

-- Para Eliminar una restriccion --
ALTER TABLE perfil DROP CHECK ;



/*-----------------------------------------
Tabla permisos

	-- Restricción de Nulabilidad
	-- Restricción de Chequeo de Valores
	-- Restricción de Unicidad
	-- Llave Primaria
	-- Campo autoGenerado
------------------------------------------*/
CREATE TABLE `permisos` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,   /* Campo autogenerado*/
	`permiso` VARCHAR(100) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `permiso` (`permiso`) USING BTREE /*Restricción de Unicidad*/
)
COLLATE='utf8_general_ci'
ENGINE=INNODB;


/*-----------------------------------------
Tabla perfil_permisos

	-- Restricción de Nulabilidad
	-- Restricción de Chequeo de Valores
	-- Llave Primaria compuesta
	-- Campo autoGenerado
	-- Restricciones de tipo llave foranea
------------------------------------------*/
CREATE TABLE `perfil_permisos` (
	`perfil_id` INT(10) UNSIGNED NOT NULL,
	`permisos_id` INT(10) UNSIGNED NOT NULL,
	PRIMARY KEY (`perfil_id`, `permisos_id`) USING BTREE,
	INDEX `FK_permisos_en_perfilPermiso` (`permisos_id`) USING BTREE,
	CONSTRAINT `FK_perfil_en_perfilPermiso` FOREIGN KEY (`perfil_id`) REFERENCES `cbbawebcam`.`perfil` (`id`) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT `FK_permisos_en_perfilPermiso` FOREIGN KEY (`permisos_id`) REFERENCES `cbbawebcam`.`permisos` (`id`) ON UPDATE CASCADE ON DELETE RESTRICT
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

/*-----------------------------------------
Tabla usuarios

	-- Restricción de Nulabilidad
	-- Restricción de Chequeo de Valores
	-- Campo autoGenerado
	-- Restricciones de tipo llave foranea
	-- Valor por defecto si no se suministra uno al insertar el registro.
	-- Restricción de Unicidad
------------------------------------------*/
CREATE TABLE `usuarios` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,  /*Llave primaria con campo autogenerado*/
	`carnet` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
	`nombres` VARCHAR(150) NOT NULL COLLATE 'utf8_general_ci',
	`apellidos` VARCHAR(150) NOT NULL COLLATE 'utf8_general_ci',
	`imagen` VARCHAR(150) NOT NULL COLLATE 'utf8_general_ci',
	`email` VARCHAR(200) NOT NULL COLLATE 'utf8_general_ci',
	`password` VARCHAR(150) NOT NULL COLLATE 'utf8_general_ci',
	`estado` TINYINT(1) NOT NULL DEFAULT '1', /*Valor por defecto*/
	`perfil_id` INT(10) UNSIGNED NOT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `carnet` (`carnet`) USING BTREE, /*Restricción de Unicidad*/
	INDEX `FK_perfil_en_usuarios` (`perfil_id`) USING BTREE,
	CONSTRAINT `FK_perfil_en_usuarios` FOREIGN KEY (`perfil_id`) REFERENCES `cbbawebcam`.`perfil` (`id`) ON UPDATE CASCADE ON DELETE RESTRICT
)
COMMENT='registra usuarios del sistema'
COLLATE='utf8_general_ci'
ENGINE=INNODB;

/*-----------------------------------------
Tabla invitados

	-- Restricción de Nulabilidad
	-- Restricción de Chequeo de Valores
	-- Campo autoGenerado
	-- Restricciones de tipo llave foranea
	-- Valor por defecto si no se suministra uno al insertar el registro.
	-- Restricción de Unicidad.
------------------------------------------*/
CREATE TABLE `invitados` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,   /*Llave primaria con campo autogenerado*/
	`carnet` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
	`nombres` VARCHAR(150) NOT NULL COLLATE 'utf8_general_ci',
	`apellidos` VARCHAR(150) NOT NULL COLLATE 'utf8_general_ci',
	`descripcion` VARCHAR(500) NOT NULL COLLATE 'utf8_general_ci',
	`imagen` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
	`estado` TINYINT(1) NOT NULL DEFAULT '1', /*Valor por defecto*/
	`usuarios_id` INT(10) UNSIGNED NOT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `carnet` (`carnet`) USING BTREE, /*Restricción de Unicidad*/
	INDEX `FK_usuarios_en_invitados` (`usuarios_id`) USING BTREE,
	CONSTRAINT `FK_usuarios_en_invitados` FOREIGN KEY (`usuarios_id`) REFERENCES `cbbawebcam`.`usuarios` (`id`) ON UPDATE CASCADE ON DELETE NO ACTION
)
COMMENT='registra los invitados  que disertantarn en cbbaWebcam'
COLLATE='utf8_general_ci'
ENGINE=INNODB;

/*-----------------------------------------
Tabla categoria

	-- Restricción de Nulabilidad
	-- Restricción de Chequeo de Valores
	-- Campo autoGenerado
	-- Restricciones de tipo llave foranea
	-- Valor por defecto si no se suministra uno al insertar el registro.
	-- Restricción de Unicidad.
------------------------------------------*/
CREATE TABLE `categoria` ( 
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT, /*Llave primaria con campo autogenerado*/
	`nombre` VARCHAR(200) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`icono` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`estado` TINYINT(1) NOT NULL DEFAULT '1', /*Valor por defecto*/
	`usuarios_id` INT(10) UNSIGNED NOT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `eventoCategoria` (`nombre`) USING BTREE, /*Restricción de Unicidad*/
	INDEX `FK_usuarios_en_categoria` (`usuarios_id`) USING BTREE,
	CONSTRAINT `FK_usuarios_en_categoria` FOREIGN KEY (`usuarios_id`) REFERENCES `cbbawebcam`.`usuarios` (`id`) ON UPDATE CASCADE ON DELETE NO ACTION
)
COMMENT='registra la categoria del evento...'
COLLATE='utf8_general_ci'
ENGINE=INNODB;

/*-----------------------------------------
Tabla eventos

	-- Restricción de Nulabilidad
	-- Restricción de Chequeo de Valores
	-- Campo autoGenerado
	-- Restricciones de tipo llave foranea
	-- Valor por defecto si no se suministra uno al insertar el registro.
------------------------------------------*/
CREATE TABLE `eventos` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,   /*Llave primaria con campo autogenerado*/
	`nombre_evento` VARCHAR(100) NOT NULL COLLATE 'utf8_general_ci',
	`estado` TINYINT(1) NOT NULL DEFAULT '1',  /*Valor por defecto*/
	`categoria_id` INT(10) UNSIGNED NOT NULL,
	`invitados_id` INT(10) UNSIGNED NOT NULL,
	`usuarios_id` INT(10) UNSIGNED NOT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	INDEX `FK_categoria_en_eventos` (`categoria_id`) USING BTREE,
	INDEX `FK_invitados_en_eventos` (`invitados_id`) USING BTREE,
	INDEX `FK_usuarios_en_eventos` (`usuarios_id`) USING BTREE,
	CONSTRAINT `FK_categoria_en_eventos` FOREIGN KEY (`categoria_id`) REFERENCES `cbbawebcam`.`categoria` (`id`) ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT `FK_invitados_en_eventos` FOREIGN KEY (`invitados_id`) REFERENCES `cbbawebcam`.`invitados` (`id`) ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT `FK_usuarios_en_eventos` FOREIGN KEY (`usuarios_id`) REFERENCES `cbbawebcam`.`usuarios` (`id`) ON UPDATE CASCADE ON DELETE NO ACTION
)
COMMENT='Guarda todos los eventos a realizarse de cbbawWebcam'
COLLATE='utf8_general_ci'
ENGINE=INNODB;

/*-----------------------------------------
Tabla eventofecha

	-- Restricción de Nulabilidad
	-- Restricción de Chequeo de Valores
	-- Campo autoGenerado
	-- Valor por defecto si no se suministra uno al insertar el registro.
	-- Restricción de Unicidad.
------------------------------------------*/
CREATE TABLE `eventofecha` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT, /*Llave primaria con campo autogenerado*/
	`fecha_evento` DATE NOT NULL,
	`estado` TINYINT(3) NOT NULL DEFAULT '1',  /* Valor por defecto*/
	PRIMARY KEY (`id`) USING BTREE, 
	UNIQUE INDEX `fecha_evento` (`fecha_evento`) USING BTREE    /*Restricción de unicidad*/
)
COMMENT='En esta tabla se almacena la fecha disponibles para los eventos.'
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB

/*-----------------------------------------
Tabla eventohora

	-- Restricción de Nulabilidad
	-- Restricción de Chequeo de Valores
	-- Campo autoGenerado
	-- Valor por defecto si no se suministra uno al insertar el registro.
	-- Restricción de Unicidad.
------------------------------------------*/
CREATE TABLE `eventohora` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,  /*Llave primaria con campo autogenerado*/
	`hora_evento` TIME NULL DEFAULT NULL,
	`estado` TINYINT(3) NOT NULL DEFAULT '1',  /* Valor por defecto*/
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `hora_evento` (`hora_evento`) USING BTREE   /*Restricción de unicidad*/
)
COMMENT='Aqui se almacena las horas que se degisnaran a los eventos'
COLLATE='utf8mb4_general_ci'
ENGINE=INNODB;

/*-----------------------------------------
Tabla de RELACIÓN fechahora

	-- Restricción de Nulabilidad
	-- Restricción de Chequeo de Valores
	-- Restricciones de tipo llave foranea
	-- Llave primaria compuesta.
------------------------------------------*/
CREATE TABLE `fechahora` (
	`eventofecha_id` INT(10) UNSIGNED NOT NULL,
	`eventohora_id` INT(10) UNSIGNED NOT NULL,
	`eventos_id` INT(10) UNSIGNED NOT NULL,
	PRIMARY KEY (`eventofecha_id`, `eventohora_id`) USING BTREE,  /*Llave primaria compuesta*/
	INDEX `FK_eventohora_en_fecha_hora` (`eventohora_id`) USING BTREE,
	INDEX `FK_eventos_en_fecha_hora` (`eventos_id`) USING BTREE,
	CONSTRAINT `FK_eventofecha_en_fecha_hora` FOREIGN KEY (`eventofecha_id`) REFERENCES `cbbawebcam`.`eventofecha` (`id`) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT `FK_eventohora_en_fecha_hora` FOREIGN KEY (`eventohora_id`) REFERENCES `cbbawebcam`.`eventohora` (`id`) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT `FK_eventos_en_fecha_hora` FOREIGN KEY (`eventos_id`) REFERENCES `cbbawebcam`.`eventos` (`id`) ON UPDATE CASCADE ON DELETE RESTRICT
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;

/*-----------------------------------------
Tabla participante_cliente

	-- Restricción de Nulabilidad
	-- Restricción de Chequeo de Valores
	-- Llave primaria.
	-- Restricción de Unicidad.
------------------------------------------*/
CREATE TABLE `participante_cliente` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,   /*Llave primaria con campo autogenerado*/
	`carnet` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`nombres` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',  /*Chequeo de valores*/
	`apellidos` VARCHAR(100) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`email` VARCHAR(100) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
	`estado` TINYINT(3) NOT NULL DEFAULT '1',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `carnet` (`carnet`) USING BTREE   /*Restricción de unicidad*/
)
COLLATE='utf8_general_ci'
ENGINE=INNODB;

/*-----------------------------------------
Tabla regalos

	-- Restricción de Nulabilidad
	-- Restricción de Chequeo de Valores
	-- Llave primaria.
	-- Restricción de Unicidad.
	-- Valor por defecto si no se suministra uno al insertar el registro.
	-- Restricciones de tipo llave foranea
------------------------------------------*/
CREATE TABLE `regalos` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,   /*Llave primaria con campo autogenerado*/
	`nombre` VARCHAR(100) NOT NULL COLLATE 'utf8_general_ci',  /*Chequeo de valores*/
	`estado` TINYINT(1) NOT NULL DEFAULT '1',  /*Valor por defecto*/
	`usuarios_id` INT(10) UNSIGNED NOT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `nombre_regalo` (`nombre`) USING BTREE,  /*Restricción de Unicidad.*/
	INDEX `FK_usuarios_en_regalos` (`usuarios_id`) USING BTREE,
	CONSTRAINT `FK_usuarios_en_regalos` FOREIGN KEY (`usuarios_id`) REFERENCES `cbbawebcam`.`usuarios` (`id`) ON UPDATE CASCADE ON DELETE NO ACTION
)
COMMENT='Se almacena los registros de  los regalos que ofrece cbbawebcam'
COLLATE='utf8_general_ci'
ENGINE=INNODB;

/*-----------------------------------------
Tabla participantes

	-- Restricción de Nulabilidad
	-- Restricción de Chequeo de Valores
	-- Llave primaria.
	-- Valor por defecto si no se suministra uno al insertar el registro.
	-- Restricciones de tipo llave foranea
------------------------------------------*/
CREATE TABLE `participantes` (
	`codigo_compra` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`pases_eventos` JSON NOT NULL,
	`total_pago` FLOAT UNSIGNED NOT NULL,
	`estado` TINYINT(1) NOT NULL DEFAULT '1',
	`regalos_id` INT(10) UNSIGNED NOT NULL,
	`usuarios_id` INT(10) UNSIGNED NOT NULL,
	`participante_cliente_id` INT(10) UNSIGNED NOT NULL,
	PRIMARY KEY (`codigo_compra`) USING BTREE,
	INDEX `FK_regalos_en_compraevento` (`regalos_id`) USING BTREE,
	INDEX `FK_usuarios_en_compraevento` (`usuarios_id`) USING BTREE,
	INDEX `FK_paricipantes_en_compraventa` (`participante_cliente_id`) USING BTREE,
	CONSTRAINT `FK_participantecliente_en_participantes` FOREIGN KEY (`participante_cliente_id`) REFERENCES `cbbawebcam`.`participante_cliente` (`id`) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT `FK_regalos_en_compraevento` FOREIGN KEY (`regalos_id`) REFERENCES `cbbawebcam`.`regalos` (`id`) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT `FK_usuarios_en_compraevento` FOREIGN KEY (`usuarios_id`) REFERENCES `cbbawebcam`.`usuarios` (`id`) ON UPDATE CASCADE ON DELETE RESTRICT
)
COMMENT='Guarda todos a todos los participantes que se inscribieron a la conferencia'
COLLATE='utf8_general_ci'
ENGINE=INNODB;