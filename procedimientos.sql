DELIMITER //

CREATE PROCEDURE crearCarrera(IN nombreCarrera VARCHAR(100))
BEGIN
    DECLARE nombreValido BOOLEAN;
    
    -- Utilizar la función soloLetras para validar el nombre
    SET nombreValido = soloLetras(nombreCarrera);

    IF nombreValido THEN
        -- Verificar si la carrera con el mismo nombre ya existe
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