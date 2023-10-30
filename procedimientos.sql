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
    -- Verifica que el docente con el siif exista en la tabla docente
    ELSE
        SELECT siif INTO docenteExistente FROM docente WHERE siif = p_siif;
        
        IF docenteExistente IS NULL THEN
            SELECT 'El docente con ese siif no existe';
        -- Verifica que el cupo máximo sea un valor entero positivo
        ELSEIF p_cupo_maximo <= 0 THEN
            SELECT 'El cupo máximo debe ser un valor entero positivo';
        -- Verifica que la sección sea una letra y la guarda en mayúscula
        ELSEIF LENGTH(p_seccion) <> 1 OR NOT BINARY p_seccion REGEXP '^[A-Za-z]$' THEN
            SELECT 'La sección debe ser una letra';
        ELSE
            -- Inserta el registro si todas las validaciones son exitosas
            INSERT INTO cursohabilitado (ciclo, cupo_maximo, seccion, anio, codigo_curso, siif)
            VALUES (p_ciclo, p_cupo_maximo, UPPER(p_seccion), p_anio, p_codigo_curso, p_siif);
            SELECT 'Curso habilitado con éxito';
        END IF;
    END IF;
END //
DELIMITER ;
