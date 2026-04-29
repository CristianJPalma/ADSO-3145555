# Ejercicio 07 Resuelto - Trazabilidad de asiento y equipaje por segmento ticketed

## 1. Contexto del ejercicio
Se requiere consultar de forma integrada asiento, cabina y equipaje por ticket_segment, y automatizar una accion posterior cuando se registre equipaje.

---

## 2. Solucion propuesta

### 2.1 Consulta resuelta con INNER JOIN
```sql
SELECT
    t.ticket_number,
    ts.segment_sequence_no,
    f.flight_number,
    cc.class_name AS cabin_class_name,
    aseat.seat_row_number,
    aseat.seat_column_code,
    b.baggage_tag,
    b.baggage_type,
    b.baggage_status
FROM ticket t
INNER JOIN ticket_segment ts
    ON ts.ticket_id = t.ticket_id
INNER JOIN flight_segment fs
    ON fs.flight_segment_id = ts.flight_segment_id
INNER JOIN flight f
    ON f.flight_id = fs.flight_id
LEFT JOIN seat_assignment sa
    ON sa.ticket_segment_id = ts.ticket_segment_id
LEFT JOIN aircraft_seat aseat
    ON aseat.aircraft_seat_id = sa.aircraft_seat_id
LEFT JOIN aircraft_cabin ac
    ON ac.aircraft_cabin_id = aseat.aircraft_cabin_id
INNER JOIN cabin_class cc
    ON cc.cabin_class_id = ac.cabin_class_id
LEFT JOIN baggage b
    ON b.ticket_segment_id = ts.ticket_segment_id
ORDER BY f.service_date DESC, ts.segment_sequence_no ASC;
```

### 2.2 Trigger AFTER resuelto
```sql
DROP TRIGGER IF EXISTS trg_ai_baggage_touch_ticket_segment ON baggage;
DROP FUNCTION IF EXISTS fn_ai_baggage_touch_ticket_segment();

CREATE OR REPLACE FUNCTION fn_ai_baggage_touch_ticket_segment()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE ticket_segment
    SET updated_at = now()
    WHERE ticket_segment_id = NEW.ticket_segment_id;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_ai_baggage_touch_ticket_segment
AFTER INSERT ON baggage
FOR EACH ROW
EXECUTE FUNCTION fn_ai_baggage_touch_ticket_segment();
```

### 2.3 Procedimiento almacenado resuelto
```sql
DROP PROCEDURE IF EXISTS sp_register_baggage(uuid, varchar, varchar, varchar, numeric, timestamptz);

CREATE OR REPLACE PROCEDURE sp_register_baggage(
    p_ticket_segment_id uuid,
    p_baggage_tag varchar,
    p_baggage_type varchar,
    p_baggage_status varchar,
    p_weight_kg numeric,
    p_checked_at timestamptz
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_weight_kg <= 0 THEN
        RAISE EXCEPTION 'El peso debe ser mayor que cero.';
    END IF;

    IF p_baggage_type NOT IN ('CHECKED', 'CARRY_ON', 'SPECIAL') THEN
        RAISE EXCEPTION 'Tipo de equipaje invalido: %', p_baggage_type;
    END IF;

    IF p_baggage_status NOT IN ('REGISTERED', 'LOADED', 'CLAIMED', 'LOST') THEN
        RAISE EXCEPTION 'Estado de equipaje invalido: %', p_baggage_status;
    END IF;

    INSERT INTO baggage (
        ticket_segment_id,
        baggage_tag,
        baggage_type,
        baggage_status,
        weight_kg,
        checked_at
    )
    VALUES (
        p_ticket_segment_id,
        p_baggage_tag,
        p_baggage_type,
        p_baggage_status,
        p_weight_kg,
        p_checked_at
    );
END;
$$;
```

### 2.4 Script de demostracion
```sql
DO $$23.5,
        
DECLARE
    v_ticket_segment_id uuid;
BEGIN
    SELECT ts.ticket_segment_id
    INTO v_ticket_segment_id
    FROM ticket_segment ts
    ORDER BY ts.created_at
    LIMIT 1;

    CALL sp_register_baggage(
        v_ticket_segment_id,
        'BG-DEMO-001',
        'CHECKED',
        'RECEIVED',
        now()
    );
END;
$$;

SELECT
    ts.ticket_segment_id,
    ts.updated_at,
    b.baggage_id,
    b.baggage_tag,
    b.baggage_status,
    b.registered_at
FROM baggage b
INNER JOIN ticket_segment ts
    ON ts.ticket_segment_id = b.ticket_segment_id
ORDER BY b.created_at DESC
LIMIT 5;
```

---

## 3. Validacion final
La solucion cumple con:
- consulta multitabla de ticket, asiento y equipaje,
- trigger AFTER INSERT sobre baggage,
- procedimiento reutilizable para registro de equipaje,
- evidencia de trazabilidad en ticket_segment.updated_at.
