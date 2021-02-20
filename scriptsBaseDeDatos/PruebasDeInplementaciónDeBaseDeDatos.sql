---------------------------------
--    Usar la Base de Datos    --
---------------------------------
USE cbbawebcamm;

/*-----------------------------------------
Tabla perfil  

Se va a tratar de violar todas las restriciones que implementamos.

	-- Restricción de Nulabilidad
	-- Restricción de Chequeo de Valores
	-- Restricción de Unicidad
	-- Llave Primaria
	-- Campo autoGenerado
------------------------------------------*/

/*1.- Se va a insertar un registro sin ningun error */
INSERT INTO `perfil` (`id`, `nombre`, `estado`) VALUES
(2, 'Secretaria', 1)


-- Insertamos otros datos de perfil --
INSERT INTO `perfil` (`id`, `nombre`, `estado`) VALUES
(3, 'Administrador', 1),
(4, 'Ventas ticket', 1);
-- Mensaje del DBMS Registros sin errores
/* Filas afectadas: 2  Filas encontradas: 0  Advertencias: 0  Duración 
   para 1 consulta: 0,032 seg. */


-- Violación de la llave primria duplicada --
INSERT INTO `perfil` (`id`, `nombre`, `estado`) VALUES
(2, 'Secretaria', 1)
-- Mensaje del mnejador de la base de datos
/* Error de SQL (1062): Duplicate entry '2' for key 'perfil.PRIMARY' */
/* Filas afectadas: 0  Filas encontradas: 0  Advertencias: 0  Duración
   para 0 de 1 consulta: 0,000 seg. */


-- Violacion del tipo de datos estado TINYINT(1) --
-- Ingresar la restriccion de un solo valor --
ALTER TABLE perfil 
ADD CONSTRAINT check_estado CHECK (`estado` <= 1);


-- Ejecutamos la consulta para la restricción TINYINT(1) --
INSERT INTO `perfil` (`id`, `nombre`, `estado`) VALUES
(5, 'Gerente', 11888)
-- Mensaje del mnejador de la base de datos
/* Error de SQL (3819): Check constraint 'check_estado' is violated. */
/* Filas afectadas: 0  Filas encontradas: 0  Advertencias: 0  Duración 
para 0 de 1 consulta: 0,000 seg. */


-- Anulacion de la llave primaria --
INSERT INTO `perfil` (`id`, `nombre`, `estado`) VALUES
(null, 'Gerente', 1)
/*Cuando es un campo autoincremental es indiferente poner nulo o vacio
  ya que el campo genera un ic automatico*/
-- Mensaje del mnejador de la base de datos
/* Filas afectadas: 1  Filas encontradas: 0  Advertencias: 0  Duración 
para 1 consulta: 0,031 seg. */
  

-- Restricción de Unicidad --
INSERT INTO `perfil` (`id`, `nombre`, `estado`) VALUES
(null, 'Gerente', 1)
-- Mensaje del mnejador de la base de datos
/* Error de SQL (1062): Duplicate entry 'Gerente' for key 'perfil.nombre' */
/* Filas afectadas: 0  Filas encontradas: 0  Advertencias: 0  Duración para 
0 de 1 consulta: 0,000 seg. */
  
-- Ver datos insertados
SELECT * FROM perfil;
/*
	Aunque parezcan ordenados por algún campo (Típicamente la Llave primaria)
	SQL NO garantiza el orden en el que se regresan las filas ya que:
	Los conjuntos NO tienen ORDEN!
*/


-- Atomicidad de la transacción --
/* Toda transacción es un solo ente y toda la transacción debe ejecutarse
   por completo.
	Si alguna instruccion falla entonces ninguna instrución dentro de la
	transacción debe ser ejecutada */
INSERT INTO `permisos` (`id`, `permiso`) VALUES
 	(1, 'Control de categorias'),
	(5, 'Control de eventos'),
	(4, 'Control de invitados'),
	(2, 'Control de participantes'),
	(1, 'Control de usuarios');    /*Esta llave primaria esta duplicada*/

--Revisemos nuestros paises de nuevo
SELECT * FROM permisos;
-- No hay ningun registro... La transacción falló y NINGUNA inserción se realizó

-- Transacción con diferentes Instrucciones
START TRANSACTION;
    INSERT INTO `permisos` (`id`, `permiso`) VALUES
      (1, 'Control de categorias'),
      (5, 'Control de eventos'),
      (4, 'Control de invitados'),
      (2, 'Control de participantes'),
      (3, 'Control de usuarios');    /*Esta llave primaria esta duplicada*/ 


ROLLBACK; -- Cancela la transacción (si no se aplico commit)
COMMIT; -- Confirma la transacción (Ya no se puede hacer un rollback)




/*-----------------------------------------
Tabla de perfil_permisos
	-- Llave Foránea
	   -- Acciones sobre la Relación
	   
DROP TABLE IF EXISTS `perfil_permisos`;
CREATE TABLE IF NOT EXISTS `perfil_permisos` (
  `perfil_id` int UNSIGNED NOT NULL,
  `permisos_id` int UNSIGNED NOT NULL,
  PRIMARY KEY (`perfil_id`,`permisos_id`),
  KEY `FK_permisos_en_perfilPermiso` (`permisos_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-----------------------------------------------*/

-- Insertemos algunos registros
/*Asignemos a un perfil  Gerente con diferentes tipos de permiso (Control de categorias)*/
INSERT INTO `perfil_permisos` (`perfil_id`, `permisos_id`) VALUES
(9,1);
/* Se ha insertado correctamente */
/* Filas afectadas: 1  Filas encontradas: 0  Advertencias: 0  Duración para 1 consulta: 0,031 seg. */


/* LLave primaria compuesta duplicada*/
INSERT INTO `perfil_permisos` (`perfil_id`, `permisos_id`) VALUES
(9,1);
/* Error de SQL (1062): Duplicate entry '9-1' for key 'perfil_permisos.PRIMARY' */
/* Filas afectadas: 0  Filas encontradas: 0  Advertencias: 0  Duración para 0 de 1 consulta: 0,000 seg. */

SELECT * FROM perfil;
SELECT * FROM permisos;
SELECT * FROM perfil_permisos;
/*
	Probemos las Actualizaciones y Eliminaciones en Cascada
	Actualicemos el Código de perfil de Gerente:
*/
UPDATE	perfil			-- Modificar la Tabla perfil
SET		id = 10 -- Poner el valor 10 el el Campo id Llave primaria
WHERE	id = 9; -- En TODOS los registros que tengan id = 9

-- Verifiquemos el Cambio y la Actualización en Cascada
SELECT * FROM perfil;
SELECT * FROM perfil_permisos;

-- Ahora la Eliminación en Cascada
DELETE FROM `cbbawebcamm`.`perfil`  -- Borrar de la Tabla Paises
WHERE  `id`=10;                     -- TODOS los registros que tengan id = 10

-- Verifiquemos la Eliminación en Cascada
SELECT * FROM perfil;
/*El registro con id 10 no se elimino por que forma parte
 en otra tabla como llave foranea y su eliminacion esta Restringida*/
 
 /* Error de SQL (1451): Cannot delete or update a parent row: a foreign 
 key constraint fails (`cbbawebcamm`.`perfil_permisos`, CONSTRAINT 
 `FK_perfil_permisos_cbbawebcamm.perfil` FOREIGN KEY (`perfil_id`) REFERENCES `perfil` 
 (`id`) ON DELETE RESTRICT ON UPDATE CASCADE) */
/* Filas afectadas: 0  Filas encontradas: 0  Advertencias: 0  Duración para 0 de 2 
consultas: 0,000 seg. */


/*-----------------------------------------
Tabla usuarios

	-- Restricción de Nulabilidad
	-- Restricción de Chequeo de Valores
	-- Campo autoGenerado
	-- Restricciones de tipo llave foranea
	-- Restricción de Unicidad
-----------------*/

/*Restricción de nulabilidad*/
-- El nombre de usuario esta restringido por un not null no acepta nulos.
INSERT INTO `usuarios` (
`id`, `carnet`, `nombres`, `apellidos`, 
`imagen`, `email`, `password`, `estado`, `perfil_id`) 
VALUES(7, 6406765, 'Janet', 'Salinas', '16051036472.jpg', 'janet@hotmail.com', 
'ba9d541fab3c4edd9a2b97ea40584fb41d6d261cee69e69e940a4f6ba26d9952', 1, 2);
-- Mensaje del manejador de la base de datos
/* Error de SQL (1048): Column 'carnet' cannot be null */
/* Filas afectadas: 0  Filas encontradas: 0  Advertencias: 0  Duración para 0 de 1 consulta: 0,000 seg. */


/*Restriccion de chequeo de valores*/
-- Violacion del tipo de datos estado TINYINT(1) --
-- Ingresar la restriccion de un solo valor --
ALTER TABLE usuarios 
ADD CONSTRAINT check_estado_user CHECK (`estado` <= 1);

-- El registro no se va a realizar por que existe una restriccion de chequeo de
 valores
-- con estado=11 y esta restringido por un 0 y 1
INSERT INTO `usuarios` (
`id`, `carnet`, `nombres`, `apellidos`, 
`imagen`, `email`, `password`, `estado`, `perfil_id`) 
VALUES(7, 3658965, 'Janet', 'Salinas', '16051036472.jpg', 'janet@hotmail.com', 
'ba9d541fab3c4edd9a2b97ea40584fb41d6d261cee69e69e940a4f6ba26d9952', 11, 2);
/* Error de SQL (3819): Check constraint 'check_estado_user' is violated. */
/* Filas afectadas: 0  Filas encontradas: 0  Advertencias: 0  Duración para 0
 de 1 consulta: 0,000 seg. */


/*Campo autoGenerado*/

/*	El campo Cod_Acad es Manejado por el RDBMS... 
	No podemos asignarle un Valor Nosotros (Existen Excepciones) */
	
INSERT INTO `usuarios` (
`id`, `carnet`, `nombres`, `apellidos`, 
`imagen`, `email`, `password`, `estado`, `perfil_id`) 
VALUES(O, 3658965, 'Janet', 'Salinas', '16051036472.jpg', 'janet@hotmail.com', 
'ba9d541fab3c4edd9a2b97ea40584fb41d6d261cee69e69e940a4f6ba26d9952', 1, 2);
/* Error de SQL (1054): Unknown column 'O' in 'field list' */
/* Filas afectadas: 0  Filas encontradas: 0  Advertencias: 0  Duración para 0 
de 1 consulta: 0,000 seg. */

-- Eliminamos el id = o
INSERT INTO `usuarios` (`carnet`, `nombres`, `apellidos`, 
`imagen`, `email`, `password`, `estado`, `perfil_id`) 
VALUES(3658965, 'Janet', 'Salinas', '16051036472.jpg', 'janet@hotmail.com', 
'ba9d541fab3c4edd9a2b97ea40584fb41d6d261cee69e69e940a4f6ba26d9952', 1, 2);

-- Atomaticamente el RDBMS asigno un id al registro
/* Filas afectadas: 1  Filas encontradas: 0  Advertencias: 0  Duración
 para 1 consulta: 0,172 seg. */

-- Verifiquemos que el registro se creo correctamente 
SELECT * FROM usuarios;


-- Ingresemos un nuevo registro  con un FK que no existe
INSERT INTO `usuarios` (`carnet`, `nombres`, `apellidos`, 
`imagen`, `email`, `password`, `estado`, `perfil_id`) 
VALUES('64067688', 'Maria del Carmen', 'Zalazar', 
'160510414106.jpg', 'maria@hotmail.com', 
'2249a090f11321a195804ff56a7d1feebcde039f707e7d999a29c2dbeb91fb0e', 1, 22);

/* Error de SQL (1452): Cannot add or update a child row: a foreign key 
constraint fails (`cbbawebcamm`.`usuarios`, CONSTRAINT 
`FK_usuarios_cbbawebcamm.perfil` FOREIGN KEY (`perfil_id`) REFERENCES `perfil` 
(`id`) ON DELETE RESTRICT ON UPDATE CASCADE) */
/* Filas afectadas: 0  Filas encontradas: 0  Advertencias: 0  Duración para
 0 de 1 consulta: 0,000 seg. */
 
 -- No permite registrar porque El FK no exite
 
 
 -- Ingresemos un nuevo registro  con un FK que si existe
INSERT INTO `usuarios` (`carnet`, `nombres`, `apellidos`, 
`imagen`, `email`, `password`, `estado`, `perfil_id`) 
VALUES('64067688', 'Maria del Carmen', 'Zalazar', 
'160510414106.jpg', 'maria@hotmail.com', 
'2249a090f11321a195804ff56a7d1feebcde039f707e7d999a29c2dbeb91fb0e', 1, 4);

/* Filas afectadas: 1  Filas encontradas: 0  Advertencias: 0  
Duración para 1 consulta: 0,063 seg. */

-- La consulta ingreso correctamente

-- Verificamos la consulta
SELECT * FROM usuarios;


/*--------------------------------------------------------------------------------------
Cod id = 4?   Porqué no 2 que es el valor siguiente?

	Para evitar posibles conflictos generados por la Concurrencia,
	El valor de los campos IDENTITY se incrementa ANTES de comenzar a hacer la Inserción
	y el valor obtenido NO puede volver a ser generado.
---------------------------------------------------------------------------------------*/

-- Forma explicita de insertar un valor id 2 o 3

INSERT INTO `usuarios` (`id`,`carnet`, `nombres`, `apellidos`, 
`imagen`, `email`, `password`, `estado`, `perfil_id`) 
VALUES(2,'64067677', 'Faviana', 'Salinas', 
'160510414106.jpg', 'faviana@hotmail.com', 
'2249a090f11321a195804ff56a7d1feebcde039f707e7d999a29c2dbeb91fb0e', 1, 4);


-- Verificamos el registro insertado
SELECT * FROM usuarios;


-- Insertar datos en la tabla invitados
INSERT INTO `invitados` (`carnet`, `nombres`, `apellidos`, `descripcion`, 
`imagen`, `estado`, `usuarios_id`) VALUES
('6406766', 'David', 'Salinas Poma', 'Desarrollador web en Angular.\nEncargado de
 redes de datos, aplicaciones y soporte técnico informático en GADC.',
  '1605109880David.jpg', 1, 4),
('5656545', 'Rodrigo', 'Pinto Crispin', 'Desarrollador web en Angular. 
Encargado de redes de datos, aplicaciones y soporte técnico informático
 en GADC.', '1605117979Rodrigo.jpg', 1, 4),
('78945621', 'Alexander', 'Rodríguez Camacho', 'Desarrollador web en 
Angular. Encargado de redes de datos, aplicaciones y soporte técnico 
informático en GADC.', '1605118008alex.jpg', 1, 4),
('98744663', 'Lorena', 'Soria', 'Desarrollador web en Angular. Encargado
 de redes de datos, aplicaciones y soporte técnico informático en GADC.',
  '1605118046Mary.jpg', 1, 4),
('457966453', 'Freddy', 'Figueredo Quinteros', 'Desarrollador web en Angular. 
Encargado de redes de datos, aplicaciones y soporte técnico informático en 
GADC.', '1605119855Fredy.jpg', 1, 4),
('3265981635', 'Cristian', 'Cruz Cabrera', 'Desarrollador web en Angular. 
Encargado de redes de datos, aplicaciones y soporte técnico informático en GADC.', 
'1605118141fernando.jpg', 1, 4);

/* Filas afectadas: 6  Filas encontradas: 0  Advertencias: 0  Duración para 1 
consulta: 0,781 seg. */


-- Violacion del tipo de datos estado TINYINT(1) --
-- Ingresar la restriccion de un solo valor --
ALTER TABLE invitados 
ADD CONSTRAINT checkInvitados CHECK (`estado` <= 1);

-- Verificamos el registro insertado
SELECT * FROM invitados;


-- Insertar datos en la tabla categorias
INSERT INTO `categoria` (`id`, `nombre`, `icono`, `estado`, `usuarios_id`) VALUES
(1, 'Seminario', 'fa fa-university', 1, 4),
(2, 'Conferencias', 'fa fa-comment', 1, 4),
(3, 'Talleres', 'fa ', 1, 4);

-- Violacion del tipo de datos estado TINYINT(1) --
-- Ingresar la restriccion de un solo valor --
ALTER TABLE categoria 
ADD CONSTRAINT checkCategoria CHECK (`estado` <= 1);

-- Verificamos el registro insertado
SELECT * FROM categoria;


-- Insertar datos en la tabla eventofecha
INSERT INTO `eventofecha` (`id`, `fecha_evento`, `estado`) VALUES
(1, '2021-03-05', 1),
(2, '2021-03-06', 1),
(3, '2021-03-07', 1);

-- Violacion del tipo de datos estado TINYINT(1) --
-- Ingresar la restriccion de un solo valor --
ALTER TABLE eventofecha 
ADD CONSTRAINT check_eventoFecha CHECK (`estado` <= 1);

-- Verificamos el registro insertado
SELECT * FROM eventofecha;


-- Insertar datos en la tabla eventohora
INSERT INTO `eventohora` (`id`, `hora_evento`, `estado`) VALUES
(1, '09:00:00', 1),
(2, '10:00:00', 1),
(3, '11:00:00', 1),
(4, '12:00:00', 1),
(5, '14:00:00', 1),
(6, '15:00:00', 1),
(7, '16:00:00', 1),
(8, '17:00:00', 1),
(9, '18:00:00', 1),
(10, '19:00:00', 1);

-- Violacion del tipo de datos estado TINYINT(1) --
-- Ingresar la restriccion de un solo valor --
ALTER TABLE eventohora
ADD CONSTRAINT checkHora CHECK (`estado` <= 1);

-- Verificamos el registro insertado
SELECT * FROM eventohora;



-- Insertar datos en la tabla eventohora
-- Violacion del tipo de datos estado TINYINT(1) --
-- Ingresar la restriccion de un solo valor --
ALTER TABLE eventos
ADD CONSTRAINT checkEventos CHECK (`estado` <= 1);
INSERT INTO `eventos` (`id`, `nombre_evento`, `estado`, 
`categoria_id`, `invitados_id`, `usuarios_id`) VALUES
(62, 'Responsive Web Design', 1, 3, 2, 7),
(63, 'Flexbox', 1, 3, 2, 7),
(64, 'HTML5 y CSS3', 1, 3, 3, 7),
(65, 'Drupal', 1, 3, 4, 7),
(66, 'WordPress', 1, 3, 5, 7),
(67, 'Como ser freelancer', 1, 2, 6, 7),
(68, 'Tecnologías del Futuro', 1, 2, 1, 7),
(69, 'Seguridad en la Web', 1, 2, 2, 7),
(70, 'Diseño UI y UX para app Webs', 1, 1, 6, 7),
(71, 'AngularJS', 1, 3, 1, 7),
(72, 'PHP y MySQL', 1, 3, 2, 7),
(73, 'JavaScript Avanzado', 1, 3, 3, 7),
(74, 'SEO en Google', 1, 3, 4, 7),
(75, 'De Photoshop a HTML5 y CSS3', 1, 3, 5, 7),
(76, 'PHP Intermedio y Avanzado', 1, 3, 6, 7),
(77, 'Como crear una tienda online que venda millones en', 1, 2, 6, 7),
(78, 'Los mejores lugares para encontrar trabajo', 1, 2, 1, 7),
(79, 'Pasos para crear un negocio rentable ', 1, 2, 2, 7),
(80, 'Aprende a Programar en una mañana', 1, 1, 3, 7),
(81, 'Diseño UI y UX para móviles', 1, 1, 5, 7),
(82, 'Laravel', 1, 3, 1, 7),
(83, 'Crea tu propia API', 1, 3, 2, 7),
(84, 'JavaScript y jQuery', 1, 3, 3, 7),
(85, 'Creando Plantillas para WordPress', 1, 3, 4, 7),
(86, 'Tiendas Virtuales en Magento', 1, 3, 5, 7),
(87, 'Como hacer Marketing en línea', 1, 2, 4, 7),
(88, '¿Con que lenguaje debo empezar?', 1, 2, 2, 7),
(89, 'Frameworks y librerias Open Source', 1, 2, 3, 7),
(90, 'Creando una App en Android en una mañana', 1, 1, 4, 7),
(91, 'Creando una App en iOS en una tarde', 1, 1, 1, 7);
-- Verificamos el registro insertado
SELECT * FROM eventos;


-- Insertar datos en la tabla fechahora
INSERT INTO `fechahora` (`eventofecha_id`, `eventohora_id`, 
`eventos_id`) VALUES
(1, 1, 62),
(3, 8, 65),
(2, 2, 70),
(3, 6, 77),
(2, 3, 80),
(1, 2, 87);
/* Filas afectadas: 6  Filas encontradas: 0  Advertencias: 0  
Duración para 1 consulta: 0,234 seg. */
-- Verificamos el registro insertado
SELECT * FROM fechahora;


-- Insertar datos en la tabla regalos
-- Violacion del tipo de datos estado TINYINT(1) --
-- Ingresar la restriccion de un solo valor --
ALTER TABLE regalos
ADD CONSTRAINT checkRegalos CHECK (`estado` <= 1);

INSERT INTO `regalos` (`id`, `nombre`, `estado`, `usuarios_id`) VALUES
(2, 'Lapiceros del Evento', 1, 7),
(10, 'Poleras con logo de Angular', 1, 7),
(11, 'CD del evento', 1, 7),
(13, 'Una etiqueta del evento', 1, 7);


-- Verificamos el registro insertado
SELECT * FROM regalos;


-- Insertar datos en la tabla participante_cliente
INSERT INTO `participante_cliente` (`id`, `carnet`, `nombres`, 
`apellidos`, `email`) VALUES
(1, '6406766', 'joel', 'Apaza Montecinos', 'joel@hotmail.com'),
(2, '6596866', 'Lizeth', 'Paniagua Cartagena', 'lizeth@hotmail.com'),
(3, '2454636', 'Ronal Javier', 'Poma Flores', 'ronal@hotmail.com');
/* Filas afectadas: 3  Filas encontradas: 0  Advertencias: 0  
Duración para 1 consulta: 0,062 seg. */

-- Verificamos el registro insertado
SELECT * FROM participante_cliente;


-- Insertar datos en la tabla participante_cliente
-- Violacion del tipo de datos estado TINYINT(1) --
-- Ingresar la restriccion de un solo valor --
ALTER TABLE participantes
ADD CONSTRAINT checkParticipantes CHECK (`estado` <= 1);
INSERT INTO `participantes` (`codigo_compra`, `pases_eventos`, `total_pago`, 
`estado`, `regalos_id`, `usuarios_id`, `participante_cliente_id`) VALUES
(1, '[\"1 Pases: Dos dias - Bs. 150.-\", \"1 Polera: Bs. 37.20.-\", 
\"1 Etiquetas: Bs. 10.-\"]', 197.2, 1, 11, 7, 2),
(2, '[\"1 Pases: Un dia - Bs. 100.-\", \"1 Polera: Bs. 37.20.-\", 
\"1 Etiquetas: Bs. 10.-\"]', 197.2, 1, 2, 7, 2),
(3, '[\"1 Pases: Tres dias - Bs 200.-\", \"1 Polera: Bs. 37.20.-\", 
\"1 Etiquetas: Bs. 10.-\"]', 197.2, 1, 13, 7, 1),
(4, '[\"1 Pases: Tres dias - Bs 200.-\", \"1 Polera: Bs. 37.20.-\", 
\"1 Etiquetas: Bs. 10.-\"]', 197.2, 1, 11, 7, 3),
(5, '[\"1 Pases: Dos dias- Bs. 150.-\", \"1 Polera: Bs. 37.20.-\", 
\"1 Etiquetas: Bs. 10.-\"]', 197.2, 1, 11, 7, 2);
/* Filas afectadas: 5  Filas encontradas: 0  Advertencias: 0  Duración para 
1 consulta: 0,031 seg. */


-- Verificamos el registro insertado
SELECT * FROM participantes;
