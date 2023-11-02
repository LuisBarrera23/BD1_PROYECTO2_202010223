DELIMITER $$

CREATE FUNCTION soloLetras(str VARCHAR(100))
RETURNS BOOLEAN DETERMINISTIC
BEGIN
    DECLARE resultado BOOLEAN;
    SET resultado = str REGEXP '^[a-zA-Zaáéíóú ]*$';
    RETURN resultado;
END $$

DELIMITER ;


DELIMITER //
CREATE FUNCTION ConvertirFecha(fecha_str VARCHAR(15)) RETURNS DATE
DETERMINISTIC
NO SQL
BEGIN
    DECLARE fecha DATE;
    
    SET fecha = STR_TO_DATE(fecha_str, '%d-%m-%Y');
    
    RETURN fecha;
END //
DELIMITER ;


DELIMITER $$
CREATE FUNCTION validarCorreo(correo VARCHAR(60))
RETURNS BOOLEAN DETERMINISTIC
BEGIN
RETURN IF 
(correo REGEXP '^[a-zA-Z0-9]+@[a-zA-Z]+(\.[a-zA-Z]+)+$',true,false);
END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION validarCiclo(ciclo VARCHAR(2))
RETURNS BOOLEAN DETERMINISTIC
BEGIN
RETURN IF 
(BINARY ciclo = '1S' 
OR BINARY ciclo= '2S' 
OR BINARY ciclo= 'VD' 
OR BINARY ciclo= 'VJ', TRUE, FALSE);
END $$
DELIMITER ;



DELIMITER //

CREATE FUNCTION ValidateDate(fecha VARCHAR(255)) RETURNS BOOLEAN
DETERMINISTIC
NO SQL
BEGIN
    -- Validar que la fecha tenga el formato correcto
    IF NOT REGEXP_LIKE(fecha, '^[0-9]{1,2}-[0-9]{1,2}-[0-9]{4}$') THEN
        RETURN FALSE;
    END IF;
    -- La fecha es válida
    RETURN TRUE;
END;
//

DELIMITER ;