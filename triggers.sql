

DELIMITER //

CREATE TRIGGER trigger_insert_carrera
AFTER INSERT ON carrera
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una accion en la tabla carrera', 'INSERT');
END;

//

DELIMITER ;

DELIMITER //

CREATE TRIGGER trigger_update_carrera
AFTER UPDATE ON carrera
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una accion en la tabla carrera', 'UPDATE');
END;

//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trigger_delete_carrera
AFTER DELETE ON carrera
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Fila eliminada en tu_tabla', 'DELETE');
END;

//

DELIMITER ;



DELIMITER //

-- Trigger para la tabla docente
CREATE TRIGGER trigger_insert_docente
AFTER INSERT ON docente
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla docente', 'INSERT');
END;
//

CREATE TRIGGER trigger_update_docente
AFTER UPDATE ON docente
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla docente', 'UPDATE');
END;
//

CREATE TRIGGER trigger_delete_docente
AFTER DELETE ON docente
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Fila eliminada en la tabla docente', 'DELETE');
END;
//

-- Trigger para la tabla estudiante
CREATE TRIGGER trigger_insert_estudiante
AFTER INSERT ON estudiante
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla estudiante', 'INSERT');
END;
//

CREATE TRIGGER trigger_update_estudiante
AFTER UPDATE ON estudiante
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla estudiante', 'UPDATE');
END;
//

CREATE TRIGGER trigger_delete_estudiante
AFTER DELETE ON estudiante
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Fila eliminada en la tabla estudiante', 'DELETE');
END;
//

-- Trigger para la tabla curso
CREATE TRIGGER trigger_insert_curso
AFTER INSERT ON curso
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla curso', 'INSERT');
END;
//

CREATE TRIGGER trigger_update_curso
AFTER UPDATE ON curso
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla curso', 'UPDATE');
END;
//

CREATE TRIGGER trigger_delete_curso
AFTER DELETE ON curso
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Fila eliminada en la tabla curso', 'DELETE');
END;
//

-- Trigger para la tabla cursohabilitado
CREATE TRIGGER trigger_insert_cursohabilitado
AFTER INSERT ON cursohabilitado
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla cursohabilitado', 'INSERT');
END;
//

CREATE TRIGGER trigger_update_cursohabilitado
AFTER UPDATE ON cursohabilitado
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla cursohabilitado', 'UPDATE');
END;
//

CREATE TRIGGER trigger_delete_cursohabilitado
AFTER DELETE ON cursohabilitado
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Fila eliminada en la tabla cursohabilitado', 'DELETE');
END;
//

-- Trigger para la tabla acta
CREATE TRIGGER trigger_insert_acta
AFTER INSERT ON acta
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla acta', 'INSERT');
END;
//

CREATE TRIGGER trigger_update_acta
AFTER UPDATE ON acta
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla acta', 'UPDATE');
END;
//

CREATE TRIGGER trigger_delete_acta
AFTER DELETE ON acta
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Fila eliminada en la tabla acta', 'DELETE');
END;
//

-- Trigger para la tabla asignado
CREATE TRIGGER trigger_insert_asignado
AFTER INSERT ON asignado
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla asignado', 'INSERT');
END;
//

CREATE TRIGGER trigger_update_asignado
AFTER UPDATE ON asignado
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla asignado', 'UPDATE');
END;
//

CREATE TRIGGER trigger_delete_asignado
AFTER DELETE ON asignado
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Fila eliminada en la tabla asignado', 'DELETE');
END;
//

-- Trigger para la tabla horario
CREATE TRIGGER trigger_insert_horario
AFTER INSERT ON horario
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla horario', 'INSERT');
END;
//

CREATE TRIGGER trigger_update_horario
AFTER UPDATE ON horario
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla horario', 'UPDATE');
END;
//

CREATE TRIGGER trigger_delete_horario
AFTER DELETE ON horario
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Fila eliminada en la tabla horario', 'DELETE');
END;
//

-- Trigger para la tabla nota
CREATE TRIGGER trigger_insert_nota
AFTER INSERT ON nota
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla nota', 'INSERT');
END;
//

CREATE TRIGGER trigger_update_nota
AFTER UPDATE ON nota
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla nota', 'UPDATE');
END;
//

CREATE TRIGGER trigger_delete_nota
AFTER DELETE ON nota
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Fila eliminada en la tabla nota', 'DELETE');
END;
//

-- Trigger para la tabla asignacioncurso
CREATE TRIGGER trigger_insert_asignacioncurso
AFTER INSERT ON asignacioncurso
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla asignacioncurso', 'INSERT');
END;
//

CREATE TRIGGER trigger_update_asignacioncurso
AFTER UPDATE ON asignacioncurso
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla asignacioncurso', 'UPDATE');
END;
//

CREATE TRIGGER trigger_delete_asignacioncurso
AFTER DELETE ON asignacioncurso
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Fila eliminada en la tabla asignacioncurso', 'DELETE');
END;
//

-- Trigger para la tabla desasignacioncurso
CREATE TRIGGER trigger_insert_desasignacioncurso
AFTER INSERT ON desasignacioncurso
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla desasignacioncurso', 'INSERT');
END;
//

CREATE TRIGGER trigger_update_desasignacioncurso
AFTER UPDATE ON desasignacioncurso
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla desasignacioncurso', 'UPDATE');
END;
//

CREATE TRIGGER trigger_delete_desasignacioncurso
AFTER DELETE ON desasignacioncurso
FOR EACH ROW
BEGIN
    INSERT INTO his (fecha, descripcion, tipo)
    VALUES (NOW(), 'Fila eliminada en la tabla desasignacioncurso', 'DELETE');
END;
//

DELIMITER ;
