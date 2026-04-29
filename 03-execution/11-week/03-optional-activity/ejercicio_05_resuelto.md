# Ejercicio 05 Resuelto - Trazabilidad de mantenimiento tecnico de aeronaves

## 1. Contexto del ejercicio
Se requiere consultar eventos de mantenimiento por aeronave y automatizar una accion posterior verificable cuando se registra un nuevo evento tecnico.

---

## 2. Solucion propuesta

### 2.1 Consulta resuelta con INNER JOIN
```sql
SELECT
    a.registration_number,
    al.airline_name,
    am.model_name,
    mf.manufacturer_name,
    mt.type_name,
    mp.provider_name,
    me.status_code,
    me.started_at,
    me.completed_at
FROM maintenance_event me
INNER JOIN aircraft a
    ON a.aircraft_id = me.aircraft_id
INNER JOIN airline al
    ON al.airline_id = a.airline_id
INNER JOIN aircraft_model am
    ON am.aircraft_model_id = a.aircraft_model_id
INNER JOIN aircraft_manufacturer mf
    ON mf.aircraft_manufacturer_id = am.aircraft_manufacturer_id
INNER JOIN maintenance_type mt
    ON mt.maintenance_type_id = me.maintenance_type_id
LEFT JOIN maintenance_provider mp
    ON mp.maintenance_provider_id = me.maintenance_provider_id
ORDER BY me.started_at DESC;
```

### 2.2 Trigger AFTER resuelto
```sql
DROP TRIGGER IF EXISTS trg_ai_maintenance_event_touch_aircraft ON maintenance_event;
DROP FUNCTION IF EXISTS fn_ai_maintenance_event_touch_aircraft();

CREATE OR REPLACE FUNCTION fn_ai_maintenance_event_touch_aircraft()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE aircraft
    SET updated_at = now()
    WHERE aircraft_id = NEW.aircraft_id;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_ai_maintenance_event_touch_aircraft
AFTER INSERT ON maintenance_event
FOR EACH ROW
EXECUTE FUNCTION fn_ai_maintenance_event_touch_aircraft();
```

### 2.3 Procedimiento almacenado resuelto
```sql
DROP PROCEDURE IF EXISTS sp_register_maintenance_event(uuid, uuid, uuid, varchar, timestamptz, text);

CREATE OR REPLACE PROCEDURE sp_register_maintenance_event(
    p_aircraft_id uuid,
    p_maintenance_type_id uuid,
    p_maintenance_provider_id uuid,
    p_status_code varchar,
    p_started_at timestamptz,
    p_notes text
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_status_code NOT IN ('PLANNED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED') THEN
        RAISE EXCEPTION 'Status code invalido: %', p_status_code;
    END IF;

    INSERT INTO maintenance_event (
        aircraft_id,
        maintenance_type_id,
        maintenance_provider_id,
        status_code,
        started_at,
        notes
    )
    VALUES (
        p_aircraft_id,
        p_maintenance_type_id,
        p_maintenance_provider_id,
        p_status_code,
        p_started_at,
        p_notes
    );
END;
$$;
```

### 2.4 Script de demostracion
```sql
DO $$
DECLARE
    v_aircraft_id uuid;
    v_maintenance_type_id uuid;
    v_maintenance_provider_id uuid;
BEGIN
    SELECT a.aircraft_id
    INTO v_aircraft_id
    FROM aircraft a
    ORDER BY a.created_at
    LIMIT 1;

    SELECT mt.maintenance_type_id
    INTO v_maintenance_type_id
    FROM maintenance_type mt
    ORDER BY mt.created_at
    LIMIT 1;

    SELECT mp.maintenance_provider_id
    INTO v_maintenance_provider_id
    FROM maintenance_provider mp
    ORDER BY mp.created_at
    LIMIT 1;

    CALL sp_register_maintenance_event(
        v_aircraft_id,
        v_maintenance_type_id,
        v_maintenance_provider_id,
        'PLANNED',
        now(),
        'Evento de mantenimiento demo'
    );
END;
$$;

SELECT
    a.aircraft_id,
    a.updated_at,
    me.maintenance_event_id,
    me.event_status,
    me.started_at
FROM maintenance_event me
INNER JOIN aircraft a
    ON a.aircraft_id = me.aircraft_id
ORDER BY me.created_at DESC
LIMIT 5;
```

---

## 3. Validacion final
La solucion cumple con:
- consulta de mantenimiento con mas de 5 tablas,
- trigger AFTER INSERT sobre maintenance_event,
- procedimiento para registrar eventos,
- evidencia de impacto en aircraft.updated_at.
