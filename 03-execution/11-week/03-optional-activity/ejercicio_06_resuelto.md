# Ejercicio 06 Resuelto - Registro de retrasos operativos por segmento de vuelo

## 1. Contexto del ejercicio
Se requiere consultar retrasos por segmento con su contexto operacional, y automatizar una accion posterior cuando se registre una demora.

---

## 2. Solucion propuesta

### 2.1 Consulta resuelta con INNER JOIN
```sql
SELECT
    a.airline_name,
    f.flight_number,
    f.service_date,
    fs.segment_number,
    ao.airport_name AS origin_airport_name,
    ad.airport_name AS destination_airport_name,
    drt.reason_name,
    fd.delay_minutes,
    fd.reported_at
FROM flight_delay fd
INNER JOIN delay_reason_type drt
    ON drt.delay_reason_type_id = fd.delay_reason_type_id
INNER JOIN flight_segment fs
    ON fs.flight_segment_id = fd.flight_segment_id
INNER JOIN flight f
    ON f.flight_id = fs.flight_id
INNER JOIN flight_status fst
    ON fst.flight_status_id = f.flight_status_id
INNER JOIN airline a
    ON a.airline_id = f.airline_id
INNER JOIN airport ao
    ON ao.airport_id = fs.origin_airport_id
INNER JOIN airport ad
    ON ad.airport_id = fs.destination_airport_id
ORDER BY fd.reported_at DESC;
```

### 2.2 Trigger AFTER resuelto
```sql
DROP TRIGGER IF EXISTS trg_ai_flight_delay_touch_flight ON flight_delay;
DROP FUNCTION IF EXISTS fn_ai_flight_delay_touch_flight();

CREATE OR REPLACE FUNCTION fn_ai_flight_delay_touch_flight()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE flight
    SET updated_at = now()
    WHERE flight_id = (
        SELECT fs.flight_id
        FROM flight_segment fs
        WHERE fs.flight_segment_id = NEW.flight_segment_id
    );

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_ai_flight_delay_touch_flight
AFTER INSERT ON flight_delay
FOR EACH ROW
EXECUTE FUNCTION fn_ai_flight_delay_touch_flight();
```

### 2.3 Procedimiento almacenado resuelto
```sql
DROP PROCEDURE IF EXISTS sp_report_flight_delay(uuid, uuid, timestamptz, integer, text);

CREATE OR REPLACE PROCEDURE sp_report_flight_delay(
    p_flight_segment_id uuid,
    p_delay_reason_type_id uuid,
    p_reported_at timestamptz,
    p_delay_minutes integer,
    p_notes text
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_delay_minutes <= 0 THEN
        RAISE EXCEPTION 'Los minutos de retraso deben ser mayores que cero.';
    END IF;

    INSERT INTO flight_delay (
        flight_segment_id,
        delay_reason_type_id,
        reported_at,
        delay_minutes,
        notes
    )
    VALUES (
        p_flight_segment_id,
        p_delay_reason_type_id,
        p_reported_at,
        p_delay_minutes,
        p_notes
    );
END;
$$;
```

### 2.4 Script de demostracion
```sql
DO $$
DECLARE
    v_flight_segment_id uuid;
    v_delay_reason_type_id uuid;
BEGIN
    SELECT fs.flight_segment_id
    INTO v_flight_segment_id
    FROM flight_segment fs
    ORDER BY fs.created_at
    LIMIT 1;

    SELECT drt.delay_reason_type_id
    INTO v_delay_reason_type_id
    FROM delay_reason_type drt
    ORDER BY drt.created_at
    LIMIT 1;

    CALL sp_report_flight_delay(
        v_flight_segment_id,
        v_delay_reason_type_id,
        now(),
        18,
        'Demora demo desde procedimiento'
    );
END;
$$;

SELECT
    f.flight_id,
    f.flight_number,
    f.updated_at,
    fd.flight_delay_id,
    fd.delay_minutes,
    fd.reported_at
FROM flight_delay fd
INNER JOIN flight_segment fs
    ON fs.flight_segment_id = fd.flight_segment_id
INNER JOIN flight f
    ON f.flight_id = fs.flight_id
ORDER BY fd.created_at DESC
LIMIT 5;
```

---

## 3. Validacion final
La solucion cumple con:
- consulta de trazabilidad operacional con INNER JOIN,
- trigger AFTER INSERT sobre flight_delay,
- procedimiento reutilizable,
- evidencia del efecto posterior sobre el vuelo.
