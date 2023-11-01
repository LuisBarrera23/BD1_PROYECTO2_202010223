DELIMITER //
CREATE PROCEDURE CrearTablas()
BEGIN
    -- Creación de la tabla carrera
    CREATE TABLE IF NOT EXISTS carrera (
        id_carrera INT AUTO_INCREMENT NOT NULL,
        nombre VARCHAR(100) NOT NULL,
        PRIMARY KEY (id_carrera)
    );

    -- Creación de la tabla docente
    CREATE TABLE IF NOT EXISTS docente (
        siif INT NOT NULL,
        dpi BIGINT NOT NULL,
        nombres VARCHAR(100) NOT NULL,
        apellidos VARCHAR(100) NOT NULL,
        fecha_nac DATE NOT NULL,
        correo VARCHAR(100) NOT NULL,
        telefono INT NOT NULL,
        direccion VARCHAR(100) NOT NULL,
        fecha_crea DATE NOT NULL,
        PRIMARY KEY (siif)
    );

    -- Creación de la tabla estudiante
    CREATE TABLE IF NOT EXISTS estudiante (
        carnet BIGINT NOT NULL,
        dpi BIGINT NOT NULL,
        nombres VARCHAR(100) NOT NULL,
        apellidos VARCHAR(100) NOT NULL,
        fecha_nac DATE NOT NULL,
        correo VARCHAR(100) NOT NULL,
        telefono INT NOT NULL,
        direccion VARCHAR(100) NOT NULL,
        creditos INT NOT NULL,
        fecha DATE NOT NULL,
        id_carrera INT NOT NULL,
        PRIMARY KEY (carnet),
        FOREIGN KEY (id_carrera) REFERENCES carrera (id_carrera)
    );

    -- Creación de la tabla curso
    CREATE TABLE IF NOT EXISTS curso (
        codigo_curso INT NOT NULL,
        nombre VARCHAR(100) NOT NULL,
        creditos_necesarios INT NOT NULL,
        creditos_otorga INT NOT NULL,
        obligatorio BOOLEAN NOT NULL,
        id_carrera INT NOT NULL,
        PRIMARY KEY (codigo_curso),
        FOREIGN KEY (id_carrera) REFERENCES carrera (id_carrera)
    );

    -- Creación de la tabla cursohabilitado
    CREATE TABLE IF NOT EXISTS cursohabilitado (
        id_habilitado INT AUTO_INCREMENT NOT NULL,
        ciclo VARCHAR(10) NOT NULL,
        cupo_maximo INT NOT NULL,
        seccion CHAR(1) NOT NULL,
        anio INT NOT NULL,
        codigo_curso INT NOT NULL,
        siif INT NOT NULL,
        PRIMARY KEY (id_habilitado),
        FOREIGN KEY (codigo_curso) REFERENCES curso (codigo_curso),
        FOREIGN KEY (siif) REFERENCES docente (siif)
    );

    -- Creación de la tabla acta
    CREATE TABLE IF NOT EXISTS acta (
        id_acta INT AUTO_INCREMENT NOT NULL,
        fecha DATE NOT NULL,
        hora TIME NOT NULL,
        id_habilitado INT NOT NULL,
        PRIMARY KEY (id_acta),
        FOREIGN KEY (id_habilitado) REFERENCES cursohabilitado (id_habilitado)
    );

    -- Creación de la tabla asignado
    CREATE TABLE IF NOT EXISTS asignado (
        id_asignado INT AUTO_INCREMENT NOT NULL,
        cantidad INT NOT NULL,
        id_habilitado INT NOT NULL,
        PRIMARY KEY (id_asignado),
        FOREIGN KEY (id_habilitado) REFERENCES cursohabilitado (id_habilitado)
    );

    -- Creación de la tabla horario
    CREATE TABLE IF NOT EXISTS horario (
        id_horario INT AUTO_INCREMENT NOT NULL,
        dia INT NOT NULL,
        hora VARCHAR(30) NOT NULL,
        id_habilitado INT NOT NULL,
        PRIMARY KEY (id_horario),
        FOREIGN KEY (id_habilitado) REFERENCES cursohabilitado (id_habilitado)
    );

    -- Creación de la tabla nota
    CREATE TABLE IF NOT EXISTS nota (
        id_nota INT AUTO_INCREMENT NOT NULL,
        nota INT NOT NULL,
        id_habilitado INT NOT NULL,
        anio INT NOT NULL,
        carnet BIGINT NOT NULL,
        PRIMARY KEY (id_nota),
        FOREIGN KEY (id_habilitado) REFERENCES cursohabilitado (id_habilitado),
        FOREIGN KEY (carnet) REFERENCES estudiante (carnet)
    );

    -- Creación de la tabla asignacioncurso
    CREATE TABLE IF NOT EXISTS asignacioncurso (
        id_asignacion INT AUTO_INCREMENT NOT NULL,
        id_habilitado INT NOT NULL,
        carnet BIGINT NOT NULL,
        PRIMARY KEY (id_asignacion),
        FOREIGN KEY (id_habilitado) REFERENCES cursohabilitado (id_habilitado),
        FOREIGN KEY (carnet) REFERENCES estudiante (carnet)
    );

    -- Creación de la tabla desasignacioncurso
    CREATE TABLE IF NOT EXISTS desasignacioncurso (
        id_desasignacion INT AUTO_INCREMENT NOT NULL,
        id_habilitado INT NOT NULL,
        carnet BIGINT NOT NULL,
        PRIMARY KEY (id_desasignacion),
        FOREIGN KEY (id_habilitado) REFERENCES cursohabilitado (id_habilitado),
        FOREIGN KEY (carnet) REFERENCES estudiante (carnet)
    );

    -- Creación de la tabla his
    CREATE TABLE IF NOT EXISTS his (
        id_historial INT AUTO_INCREMENT PRIMARY KEY,
        fecha DATETIME,
        descripcion VARCHAR(200),
        tipo VARCHAR(30)
    );
END //
DELIMITER ;



DELIMITER //
CREATE PROCEDURE ReiniciarTablas()
BEGIN
    -- Desactiva las restricciones de clave foránea
    SET FOREIGN_KEY_CHECKS = 0;

    -- Elimina el contenido de la tabla asignacioncurso
    TRUNCATE TABLE asignacioncurso;

    -- Elimina el contenido de la tabla desasignacioncurso
    TRUNCATE TABLE desasignacioncurso;

    -- Elimina el contenido de la tabla nota
    TRUNCATE TABLE nota;

    -- Elimina el contenido de la tabla horario
    TRUNCATE TABLE horario;

    -- Elimina el contenido de la tabla asignado
    TRUNCATE TABLE asignado;

    -- Elimina el contenido de la tabla acta
    TRUNCATE TABLE acta;

    -- Elimina el contenido de la tabla cursohabilitado
    TRUNCATE TABLE cursohabilitado;

    -- Elimina el contenido de la tabla curso
    TRUNCATE TABLE curso;

    -- Elimina el contenido de la tabla estudiante
    TRUNCATE TABLE estudiante;

    -- Elimina el contenido de la tabla docente
    TRUNCATE TABLE docente;

    -- Elimina el contenido de la tabla carrera
    TRUNCATE TABLE carrera;

    TRUNCATE TABLE his;

    -- Activa nuevamente las restricciones de clave foránea
    SET FOREIGN_KEY_CHECKS = 1;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE EliminarTablas()
BEGIN
    -- Elimina la tabla asignacioncurso
    DROP TABLE IF EXISTS asignacioncurso;

    -- Elimina la tabla desasignacioncurso
    DROP TABLE IF EXISTS desasignacioncurso;

    -- Elimina la tabla nota
    DROP TABLE IF EXISTS nota;

    -- Elimina la tabla horario
    DROP TABLE IF EXISTS horario;

    -- Elimina la tabla asignado
    DROP TABLE IF EXISTS asignado;

    -- Elimina la tabla acta
    DROP TABLE IF EXISTS acta;

    -- Elimina la tabla cursohabilitado
    DROP TABLE IF EXISTS cursohabilitado;

    -- Elimina la tabla curso
    DROP TABLE IF EXISTS curso;

    -- Elimina la tabla estudiante
    DROP TABLE IF EXISTS estudiante;

    -- Elimina la tabla docente
    DROP TABLE IF EXISTS docente;

    -- Elimina la tabla carrera
    DROP TABLE IF EXISTS carrera;


    DROP TABLE IF EXISTS his;
END //
DELIMITER ;

