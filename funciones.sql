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

CREATE FUNCTION ValidateDate(inputDate VARCHAR(10)) RETURNS BOOLEAN
DETERMINISTIC
NO SQL
BEGIN
    DECLARE validDate BOOLEAN;
    SET validDate = FALSE;

    IF CHAR_LENGTH(inputDate) = 10 THEN
        IF inputDate REGEXP '^[0-3][0-9]-[0-1][0-9]-[0-9]{4}$' THEN
            SET validDate = TRUE; -- La fecha es válida.
        END IF;
    END IF;

    RETURN validDate;
END;
//

DELIMITER ;
