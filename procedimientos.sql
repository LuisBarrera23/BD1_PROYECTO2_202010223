DELIMITER //

CREATE PROCEDURE crearCarrera(IN nombreCarrera VARCHAR(100))
BEGIN
    DECLARE nombreValido BOOLEAN;
    
    SET nombreValido = soloLetras(nombreCarrera);

    IF nombreValido THEN
        IF NOT EXISTS (SELECT * FROM carrera WHERE nombre = nombreCarrera) THEN
            INSERT INTO carrera (nombre) VALUES (nombreCarrera);
            SELECT 'Carrera creada exitosamente.';
        ELSE
            SELECT 'Error: La carrera ya existe.';
        END IF;
    ELSE
        SELECT 'Error: El nombre de la carrera debe contener solo letras y espacios.';
    END IF;
END;
//

DELIMITER ;


DELIMITER //
CREATE PROCEDURE registrarEstudiante(
    IN p_carnet BIGINT,
    IN p_nombres VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_fecha_nac VARCHAR(15),
    IN p_correo VARCHAR(100),
    IN p_telefono INT,
    IN p_direccion VARCHAR(100),
    IN p_dpi BIGINT,
    IN p_id_carrera INT
)
BEGIN
    DECLARE correoValido BOOLEAN;
    SET correoValido = validarCorreo(p_correo);
    IF NOT correoValido THEN
        SELECT 'Correo no valido';
    ELSEIF EXISTS (SELECT * FROM estudiante WHERE carnet = p_carnet) THEN
        SELECT 'Ya existe un estudiante con ese carnet';
    ELSEIF NOT (ValidateDate(p_fecha_nac)) THEN
        SELECT 'Formato de fecha no valido';
	ELSEIF NOT EXISTS (SELECT * FROM carrera WHERE id_carrera = p_id_carrera) THEN
		SELECT 'No existe el id de la carrera ingresada';
    ELSE
        SET p_fecha_nac = ConvertirFecha(p_fecha_nac);
        INSERT INTO estudiante (carnet, dpi, nombres, apellidos, fecha_nac, correo, telefono, direccion, creditos, fecha, id_carrera)
        VALUES (p_carnet, p_dpi, p_nombres, p_apellidos, p_fecha_nac, p_correo, p_telefono, p_direccion, 0, CURDATE(), p_id_carrera);
        SELECT 'Estudiante registrado con exito';
    END IF;

END //
DELIMITER ;





DELIMITER //
CREATE PROCEDURE registrarDocente(
    IN p_nombres VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_fecha_nac VARCHAR(15),
    IN p_correo VARCHAR(100),
    IN p_telefono INT,
    IN p_direccion VARCHAR(100),
    IN p_dpi BIGINT,
    IN p_siif INT
)
BEGIN
    DECLARE correoValido BOOLEAN;
    DECLARE fecha DATE;
    SET correoValido = validarCorreo(p_correo);
    
    IF NOT correoValido THEN
        SELECT 'Correo no valido';
    ELSEIF EXISTS (SELECT * FROM docente WHERE siif = p_siif) THEN
        SELECT 'Ya existe un docente con ese siif';
    ELSEIF NOT (ValidateDate(p_fecha_nac)) THEN
        SELECT 'Formato de fecha no valido';
    ELSE
        
        SET fecha = ConvertirFecha(p_fecha_nac);
        INSERT INTO docente (siif, dpi, nombres, apellidos, fecha_nac, correo, telefono, direccion, fecha_crea)
        VALUES (p_siif, p_dpi, p_nombres, p_apellidos, fecha, p_correo, p_telefono, p_direccion, CURDATE());
    END IF;
END //
DELIMITER ;






DELIMITER //
CREATE PROCEDURE crearCurso(
    IN p_codigo_curso INT,
    IN p_nombre VARCHAR(100),
    IN p_creditos_necesarios INT,
    IN p_creditos_otorga INT,
    IN p_id_carrera INT,
    IN p_obligatorio BOOLEAN
)
BEGIN
    DECLARE idCarreraExistente INT;
    
    IF EXISTS (SELECT * FROM curso WHERE codigo_curso = p_codigo_curso) THEN
        SELECT 'Ya existe un curso con ese código';
    ELSEIF p_creditos_necesarios < 0 OR p_creditos_otorga <= 0 THEN
        SELECT 'Los créditos deben ser valores enteros positivos';
    ELSE
        SELECT id_carrera INTO idCarreraExistente FROM carrera WHERE id_carrera = p_id_carrera;
        
        IF idCarreraExistente IS NULL THEN
            SELECT 'La carrera con el ID especificado no existe';
        ELSE
            INSERT INTO curso (codigo_curso, nombre, creditos_necesarios, creditos_otorga, obligatorio, id_carrera)
            VALUES (p_codigo_curso, p_nombre, p_creditos_necesarios, p_creditos_otorga, p_obligatorio, p_id_carrera);
            SELECT 'Curso registrado con éxito';
        END IF;
    END IF;
END //
DELIMITER ;





DELIMITER //
CREATE PROCEDURE habilitarCurso(
    IN p_codigo_curso INT,
    IN p_ciclo VARCHAR(10),
    IN p_siif INT,
    IN p_cupo_maximo INT,
    IN p_seccion CHAR(1)
)
BEGIN
    DECLARE cursoExistente INT;
    DECLARE docenteExistente INT;
    DECLARE p_anio INT;
    DECLARE p_id_habilitado INT;
    
    -- Obtener el año actual
    SET p_anio = YEAR(CURDATE());
    
    IF NOT validarCiclo(p_ciclo) THEN
        SELECT 'Ciclo no válido';
    -- Verifica si el curso ya está habilitado en el mismo ciclo y sección
    ELSEIF NOT EXISTS (
        SELECT * FROM curso
        WHERE codigo_curso = p_codigo_curso
    ) THEN
        SELECT 'El curso no existe';
    ELSEIF EXISTS (
        SELECT * FROM cursohabilitado
        WHERE codigo_curso = p_codigo_curso AND ciclo = p_ciclo AND seccion = p_seccion
    ) THEN
        SELECT 'El curso ya está habilitado en el mismo ciclo y sección';
    ELSE
        SELECT siif INTO docenteExistente FROM docente WHERE siif = p_siif;
        
        IF docenteExistente IS NULL THEN
            SELECT 'El docente con ese siif no existe';
        ELSEIF p_cupo_maximo <= 0 THEN
            SELECT 'El cupo máximo debe ser un valor entero positivo';
        ELSEIF LENGTH(p_seccion) <> 1 OR NOT p_seccion REGEXP '^[A-Za-z]$' COLLATE utf8mb4_general_ci THEN
            SELECT 'La sección debe ser una letra';
        ELSE
            INSERT INTO cursohabilitado (ciclo, cupo_maximo, seccion, anio, codigo_curso, siif)
            VALUES (p_ciclo, p_cupo_maximo, UPPER(p_seccion), p_anio, p_codigo_curso, p_siif);
            
            SET p_id_habilitado = LAST_INSERT_ID();
            
            INSERT INTO asignado (cantidad, id_habilitado)
            VALUES (0, p_id_habilitado);
            
            SELECT 'Curso habilitado con éxito';
        END IF;
    END IF;
END //
DELIMITER ;




DELIMITER //

CREATE PROCEDURE agregarHorario(
    IN p_id_habilitado INT,
    IN p_dia INT,
    IN p_hora VARCHAR(30)
)
BEGIN

    IF NOT EXISTS (
        SELECT * FROM cursohabilitado
        WHERE id_habilitado = p_id_habilitado
    ) THEN
        SELECT 'El id_habilitado no existe en la tabla cursohabilitado';
    ELSEIF p_dia < 1 OR p_dia > 7 THEN
        SELECT 'El valor de dia debe estar entre 1 y 7';
    ELSE
        -- Insertar el registro en la tabla horario si todas las validaciones son exitosas
        INSERT INTO horario (dia, hora, id_habilitado)
        VALUES (p_dia, p_hora, p_id_habilitado);
        SELECT 'Horario agregado con éxito';
    END IF;
END //

DELIMITER ;






DELIMITER //

CREATE PROCEDURE asignarCurso(
    IN p_codigo_curso INT,
    IN p_ciclo VARCHAR(10),
    IN p_seccion CHAR(1),
    IN p_carnet BIGINT
)
BEGIN
    DECLARE creditos_estudiante INT;
    DECLARE p_creditos_necesarios INT;
    DECLARE id_carrera_curso INT;
    DECLARE cupo_maximo_curso INT;
    DECLARE id_carrera_estudiante INT;
    DECLARE cantidad_asignado INT;
    DECLARE p_id_habilitado INT;
    
    IF NOT EXISTS (
        SELECT * FROM estudiante
        WHERE carnet = p_carnet
    ) THEN
        SELECT 'El estudiante con ese carnet no existe en la tabla estudiante';
    ELSEIF NOT EXISTS (
        SELECT *
        FROM cursohabilitado
        WHERE ciclo = p_ciclo AND seccion = p_seccion AND codigo_curso = p_codigo_curso AND anio = YEAR(CURDATE())
    ) THEN
        SELECT 'No hay curso habilitado con las características proporcionadas';
    ELSE
        -- Obtener el número de créditos del estudiante
        SELECT creditos, id_carrera INTO creditos_estudiante, id_carrera_estudiante
        FROM estudiante
        WHERE carnet = p_carnet;
        
        SELECT cupo_maximo, id_habilitado INTO cupo_maximo_curso, p_id_habilitado
        FROM cursohabilitado
        WHERE ciclo = p_ciclo AND seccion = p_seccion AND codigo_curso = p_codigo_curso;
        
        -- Obtener creditos_necesarios e id_carrera del curso
        SELECT creditos_necesarios, id_carrera INTO p_creditos_necesarios, id_carrera_curso
        FROM curso
        WHERE codigo_curso = p_codigo_curso;
        
        -- Obtener el valor de cantidad de la tabla asignado
        SELECT cantidad INTO cantidad_asignado
        FROM asignado
        WHERE id_habilitado = p_id_habilitado;
        
        -- Verificar si el estudiante ya se encuentra asignado a este curso en esta u otra sección
        IF EXISTS (SELECT * FROM asignacioncurso WHERE carnet = p_carnet AND id_habilitado = p_id_habilitado) THEN
            SELECT 'El estudiante ya se encuentra asignado a este curso en esta u otra sección';
        ELSEIF creditos_estudiante < p_creditos_necesarios THEN
            SELECT 'El estudiante no cuenta con los créditos necesarios';
        ELSEIF NOT (id_carrera_estudiante = id_carrera_curso OR id_carrera_curso = 0) THEN
            SELECT 'El estudiante no pertenece a la carrera del curso';
        ELSEIF cantidad_asignado = cupo_maximo_curso THEN
            SELECT 'El curso ya llegó al máximo de asignados';
        ELSE
            -- Insertar el registro en la tabla asignacioncurso si todas las validaciones son exitosas
            INSERT INTO asignacioncurso (id_habilitado, carnet)
            VALUES (p_id_habilitado, p_carnet);

            UPDATE asignado
            SET cantidad = cantidad + 1
            WHERE id_habilitado = p_id_habilitado;

            SELECT 'Curso asignado al estudiante con éxito';
        END IF;
    END IF;
END //

DELIMITER ;




DELIMITER //

CREATE PROCEDURE desasignarCurso(
    IN p_codigo_curso INT,
    IN p_ciclo VARCHAR(10),
    IN p_seccion CHAR(1),
    IN p_carnet BIGINT
)
BEGIN
    DECLARE p_id_habilitado INT;
    
    IF NOT EXISTS (
        SELECT * FROM estudiante
        WHERE carnet = p_carnet
    ) THEN
        SELECT 'El estudiante con ese carnet no existe en la tabla estudiante';
    ELSEIF NOT EXISTS (
        SELECT *
        FROM cursohabilitado
        WHERE ciclo = p_ciclo AND seccion = p_seccion AND codigo_curso = p_codigo_curso AND anio = YEAR(CURDATE())
    ) THEN
        SELECT 'No hay curso habilitado con las características proporcionadas';
    ELSE
        
        SELECT id_habilitado INTO p_id_habilitado
        FROM cursohabilitado
        WHERE ciclo = p_ciclo AND seccion = p_seccion AND codigo_curso = p_codigo_curso;
        
        -- Verificar si el estudiante ya se encuentra asignado a este curso en esta u otra sección
        IF NOT EXISTS (SELECT * FROM asignacioncurso WHERE carnet = p_carnet AND id_habilitado = p_id_habilitado) THEN
            SELECT 'El estudiante NO se encuentra asignado a este curso en esta u otra sección';
        ELSE
            -- Insertar el registro en la tabla asignacioncurso si todas las validaciones son exitosas
            INSERT INTO desasignacioncurso (id_habilitado, carnet)
            VALUES (p_id_habilitado, p_carnet);

            DELETE FROM asignacioncurso
            WHERE carnet = p_carnet AND id_habilitado = p_id_habilitado;

            UPDATE asignado
            SET cantidad = cantidad - 1
            WHERE id_habilitado = p_id_habilitado;

            SELECT 'Curso desasignado al estudiante con éxito';
        END IF;
    END IF;
END //

DELIMITER ;






DELIMITER //

CREATE PROCEDURE ingresarNota(
    IN p_codigo_curso INT,
    IN p_ciclo VARCHAR(10),
    IN p_seccion CHAR(1),
    IN p_carnet BIGINT,
    IN p_nota DECIMAL(5, 2)
)
BEGIN
    DECLARE p_id_habilitado INT;
    DECLARE p_nota_redondeada INT;
    DECLARE p_creditos_otorga INT;
    DECLARE p_anio INT;
    
    SET p_anio = YEAR(CURDATE());

    IF NOT EXISTS (
        SELECT * FROM estudiante
        WHERE carnet = p_carnet
    ) THEN
        SELECT 'El estudiante con ese carnet no existe en la tabla estudiante';
    ELSEIF NOT EXISTS (
        SELECT *
        FROM cursohabilitado
        WHERE ciclo = p_ciclo AND seccion = p_seccion AND codigo_curso = p_codigo_curso AND anio = YEAR(CURDATE())
    ) THEN
        SELECT 'No hay curso habilitado con las características proporcionadas';
    ELSE
        
        SELECT id_habilitado INTO p_id_habilitado
        FROM cursohabilitado
        WHERE ciclo = p_ciclo AND seccion = p_seccion AND codigo_curso = p_codigo_curso;
        SET p_nota_redondeada = ROUND(p_nota);

        SELECT creditos_otorga INTO p_creditos_otorga
        FROM curso
        WHERE codigo_curso = p_codigo_curso;
        
        -- Verificar si el estudiante ya se encuentra asignado a este curso en esta u otra sección
        IF NOT EXISTS (SELECT * FROM asignacioncurso WHERE carnet = p_carnet AND id_habilitado = p_id_habilitado) THEN
            SELECT 'El estudiante NO se encuentra asignado a este curso en esta u otra sección';
        ELSEIF p_nota_redondeada < 0 THEN
            SELECT 'La nota no puede ser negativa';
        ELSEIF EXISTS (SELECT * FROM nota WHERE carnet = p_carnet AND id_habilitado = p_id_habilitado) THEN
            SELECT 'Ya hay una nota cargada para este estudiante';
        ELSE
            
            -- Insertar el registro en la tabla nota
            INSERT INTO nota (nota, id_habilitado, anio, carnet)
            VALUES (p_nota_redondeada, p_id_habilitado, p_anio, p_carnet);  

            IF p_nota_redondeada >= 61 THEN
                -- Sumar p_creditos_otorga a los créditos del estudiante
                UPDATE estudiante
                SET creditos = creditos + p_creditos_otorga
                WHERE carnet = p_carnet;
            END IF;

            SELECT 'Nota cargada correctamente al estudiante';
        END IF;
    END IF;
END //

DELIMITER ;





DELIMITER //

CREATE PROCEDURE generarActa(
    IN p_codigo_curso INT,
    IN p_ciclo VARCHAR(10),
    IN p_seccion CHAR(1)
)
BEGIN
    DECLARE p_id_habilitado INT;
    DECLARE contador_actual INT;
    DECLARE contador_notas INT;
    
    IF NOT EXISTS (
        SELECT *
        FROM cursohabilitado
        WHERE ciclo = p_ciclo AND seccion = p_seccion AND codigo_curso = p_codigo_curso AND anio = YEAR(CURDATE())
    ) THEN
        SELECT 'No hay curso habilitado con las características proporcionadas';
    ELSE
        
        SELECT id_habilitado INTO p_id_habilitado
        FROM cursohabilitado
        WHERE ciclo = p_ciclo AND seccion = p_seccion AND codigo_curso = p_codigo_curso;

        SELECT cantidad INTO contador_actual
        FROM asignado
        WHERE id_habilitado = p_id_habilitado;

        SELECT COUNT(*) INTO contador_notas
        FROM nota
        WHERE id_habilitado = p_id_habilitado;
        
        IF EXISTS (SELECT * FROM acta WHERE id_habilitado = p_id_habilitado) THEN
            SELECT 'Ya hay una acta cargada para este curso';
        ELSEIF (contador_actual != contador_notas) THEN
            SELECT 'No se han cargado las notas de todos los estudiantes';
        ELSE
            
            -- Insertar el registro en la tabla acta
            INSERT INTO acta (fecha, hora, id_habilitado)
            VALUES (CURDATE(), CURTIME(), p_id_habilitado);
            
            SELECT 'Acta cargada correctamente';
        END IF;
    END IF;
END //

DELIMITER ;

-- AREA DE CONSULTAS ===============================================================================

DELIMITER //

CREATE PROCEDURE consultarPensum(
    IN p_id_carrera INT
)
BEGIN
    -- Consulta los cursos de la carrera específica
    SELECT codigo_curso, nombre, creditos_necesarios,
           CASE WHEN obligatorio = 1 THEN 'Sí' ELSE 'No' END AS obligatorio
    FROM curso
    WHERE id_carrera = p_id_carrera OR id_carrera = 0;
END //

DELIMITER ;



DELIMITER //

CREATE PROCEDURE consultarEstudiante(
    IN p_carnet BIGINT
)
BEGIN
    DECLARE v_nombre_completo VARCHAR(200);
    DECLARE v_carrera_nombre VARCHAR(100);

    SELECT CONCAT(nombres, ' ', apellidos) INTO v_nombre_completo
    FROM estudiante
    WHERE carnet = p_carnet;

    SELECT nombre INTO v_carrera_nombre
    FROM carrera
    WHERE id_carrera = (SELECT id_carrera FROM estudiante WHERE carnet = p_carnet);

    SELECT carnet, v_nombre_completo AS "Nombre completo", fecha_nac, correo, telefono, direccion, dpi, v_carrera_nombre AS "Carrera", creditos
    FROM estudiante
    WHERE carnet = p_carnet;
END //

DELIMITER ;




DELIMITER //

CREATE PROCEDURE consultarDocente(
    IN p_siif INT
)
BEGIN
    DECLARE v_nombre_completo VARCHAR(200);

    SELECT CONCAT(nombres, ' ', apellidos) INTO v_nombre_completo
    FROM docente
    WHERE siif = p_siif;

    SELECT siif, v_nombre_completo AS "Nombre", fecha_nac AS 'Fecha_de_nacimiento', correo, telefono, direccion, dpi
    FROM docente
    WHERE siif = p_siif;
END //

DELIMITER ;





DELIMITER //

CREATE PROCEDURE consultarAsignados(
    IN p_codigo_curso INT,
    IN p_ciclo VARCHAR(10),
    IN p_anio INT,
    IN p_seccion CHAR(1)
)
BEGIN
    -- Declaración de variables
    DECLARE v_id_habilitado INT;

    -- Obtener id_habilitado con los parámetros proporcionados
    SELECT id_habilitado INTO v_id_habilitado
    FROM cursohabilitado
    WHERE codigo_curso = p_codigo_curso
    AND ciclo = p_ciclo
    AND anio = p_anio
    AND seccion = p_seccion;

    IF v_id_habilitado IS NULL THEN
        SELECT 'No se encontró un curso habilitado con esos parámetros.';
    ELSE
        SELECT e.carnet, CONCAT(e.nombres, ' ', e.apellidos) AS nombre_completo, e.creditos
        FROM estudiante e
        JOIN asignacioncurso a ON e.carnet = a.carnet
        WHERE a.id_habilitado = v_id_habilitado;
    END IF;
END //

DELIMITER ;





DELIMITER //

CREATE PROCEDURE consultarAprobacion(
    IN p_codigo_curso INT,
    IN p_ciclo VARCHAR(10),
    IN p_anio INT,
    IN p_seccion CHAR(1)
)
BEGIN
    -- Declaración de variables
    DECLARE v_id_habilitado INT;

    -- Obtener id_habilitado con los parámetros proporcionados
    SELECT id_habilitado INTO v_id_habilitado
    FROM cursohabilitado
    WHERE codigo_curso = p_codigo_curso
    AND ciclo = p_ciclo
    AND anio = p_anio
    AND seccion = p_seccion;

    IF v_id_habilitado IS NULL THEN
        SELECT 'No se encontró un curso habilitado con esos parámetros.';
    ELSE
        -- Consultar la aprobación de los estudiantes
        SELECT c.codigo_curso, e.carnet, CONCAT(e.nombres, ' ', e.apellidos) AS nombre_completo,
        CASE
            WHEN n.nota >= 61 THEN 'APROBADO'
            ELSE 'DESAPROBADO'
        END AS estado_aprobacion
        FROM estudiante e
        JOIN nota n ON e.carnet = n.carnet
        JOIN cursohabilitado c ON n.id_habilitado = c.id_habilitado
        WHERE c.id_habilitado = v_id_habilitado;
    END IF;
END //

DELIMITER ;




DELIMITER //

CREATE PROCEDURE consultarActas(
    IN p_codigo_curso INT
)
BEGIN
    -- Consultar actas
    SELECT c.codigo_curso, ch.seccion, 
           CASE ch.ciclo
               WHEN '1S' THEN 'PRIMER SEMESTRE'
               WHEN '2S' THEN 'SEGUNDO SEMESTRE'
               WHEN 'VJ' THEN 'VACACIONES DE JUNIO'
               WHEN 'VD' THEN 'VACACIONES DE DICIEMBRE'
               ELSE ch.ciclo
           END AS ciclo,
           ch.anio,
           asig.cantidad AS cantidad_estudiantes,
           a.fecha, a.hora
    FROM cursohabilitado ch
    INNER JOIN curso c ON ch.codigo_curso = c.codigo_curso
    LEFT JOIN asignado asig ON ch.id_habilitado = asig.id_habilitado
    INNER JOIN acta a ON ch.id_habilitado = a.id_habilitado
    WHERE c.codigo_curso = p_codigo_curso
    ORDER BY a.fecha, a.hora;
END //

DELIMITER ;





DELIMITER //

CREATE PROCEDURE consultarDesasignacion(
    IN p_codigo_curso INT,
    IN p_ciclo VARCHAR(10),
    IN p_anio INT,
    IN p_seccion CHAR(1)
)
BEGIN
    DECLARE p_id_habilitado INT;
    DECLARE cantidad_asignados INT;
    DECLARE cantidad_desasignados INT;
    DECLARE porcentaje_desasignacion DECIMAL(5, 2);
    
    -- Obtener el id_habilitado
    SELECT id_habilitado INTO p_id_habilitado
    FROM cursohabilitado
    WHERE codigo_curso = p_codigo_curso AND ciclo = p_ciclo AND anio = p_anio AND seccion = p_seccion;

    -- Contar la cantidad de estudiantes asignados
    SELECT cantidad INTO cantidad_asignados
    FROM asignado
    WHERE id_habilitado = p_id_habilitado;

    -- Contar la cantidad de estudiantes desasignados
    SELECT COUNT(*) INTO cantidad_desasignados
    FROM desasignacioncurso
    WHERE id_habilitado = p_id_habilitado;

    -- Calcular el porcentaje de desasignación
    SET porcentaje_desasignacion=0;
    IF (cantidad_asignados != 0) THEN
		SET porcentaje_desasignacion = (cantidad_desasignados / cantidad_asignados) * 100;
	ELSEIF (cantidad_asignados = 0 AND cantidad_desasignados !=0)THEN
		SET porcentaje_desasignacion = 100;
    END IF;

    -- Generar los resultados
    SELECT
        p_codigo_curso AS 'Código de curso',
        p_seccion AS 'Sección',
        CASE
            WHEN p_ciclo = '1S' THEN 'PRIMER SEMESTRE'
            WHEN p_ciclo = '2S' THEN 'SEGUNDO SEMESTRE'
            WHEN p_ciclo = 'VJ' THEN 'VACACIONES DE JUNIO'
            WHEN p_ciclo = 'VD' THEN 'VACACIONES DE DICIEMBRE'
            ELSE p_ciclo
        END AS 'Ciclo',
        p_anio AS 'Año',
        cantidad_asignados AS 'Cantidad de estudiantes asignados',
        cantidad_desasignados AS 'Cantidad de estudiantes desasignados',
        porcentaje_desasignacion AS 'Porcentaje de desasignación';
END //

DELIMITER ;

