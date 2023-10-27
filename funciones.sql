DELIMITER $$

CREATE FUNCTION soloLetras(str VARCHAR(100))
RETURNS BOOLEAN DETERMINISTIC
BEGIN
    DECLARE resultado BOOLEAN;
    SET resultado = str REGEXP '^[a-zA-Zaáéíóú ]*$';
    RETURN resultado;
END $$

DELIMITER ;
