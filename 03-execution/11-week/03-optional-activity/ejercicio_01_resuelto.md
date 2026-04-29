# Ejercicio 01 Resuelto - Flujo de check-in y trazabilidad comercial del pasajero

## 1. Contexto del ejercicio
Se requiere consultar la trazabilidad del pasajero desde reserva hasta segmento de vuelo, y automatizar la generacion del boarding pass al registrar el check-in.

---

## 2. Solucion propuesta

### 2.1 Consulta resuelta con INNER JOIN
```sql
SELECT
    r.reservation_code,
    f.flight_number,
    f.service_date,
    t.ticket_number,
    rp.passenger_sequence_no,
    p.first_name,
    p.last_name,
    fs.segment_number,
    fs.scheduled_departure_at
FROM reservation r
INNER JOIN reservation_passenger rp
    ON rp.reservation_id = r.reservation_id
INNER JOIN person p
    ON p.person_id = rp.person_id
INNER JOIN ticket t
    ON t.reservation_passenger_id = rp.reservation_passenger_id
INNER JOIN ticket_segment ts
    ON ts.ticket_id = t.ticket_id
INNER JOIN flight_segment fs
    ON fs.flight_segment_id = ts.flight_segment_id
INNER JOIN flight f
    ON f.flight_id = fs.flight_id
ORDER BY f.service_date DESC, fs.segment_number ASC;
```

### 2.2 Trigger AFTER resuelto
```sql
DROP TRIGGER IF EXISTS trg_ai_check_in_create_boarding_pass ON check_in;
DROP FUNCTION IF EXISTS fn_ai_check_in_create_boarding_pass();

CREATE OR REPLACE FUNCTION fn_ai_check_in_create_boarding_pass()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    v_boarding_pass_code varchar(40);
    v_barcode_value varchar(120);
BEGIN
    IF EXISTS (
        SELECT 1
        FROM boarding_pass bp
        WHERE bp.check_in_id = NEW.check_in_id
    ) THEN
        RETURN NEW;
    END IF;

    v_boarding_pass_code := 'BP-' || replace(NEW.check_in_id::text, '-', '');
    v_barcode_value := 'BAR-' || replace(NEW.check_in_id::text, '-', '') || '-' || to_char(NEW.checked_in_at, 'YYYYMMDDHH24MISS');

    INSERT INTO boarding_pass (
        check_in_id,
        boarding_pass_code,
        barcode_value,
        issued_at
    )
    VALUES (
        NEW.check_in_id,
        left(v_boarding_pass_code, 40),
        left(v_barcode_value, 120),
        NEW.checked_in_at
    );

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_ai_check_in_create_boarding_pass
AFTER INSERT ON check_in
FOR EACH ROW
EXECUTE FUNCTION fn_ai_check_in_create_boarding_pass();
```

### 2.3 Procedimiento almacenado resuelto
```sql
DROP PROCEDURE IF EXISTS sp_register_check_in(uuid, uuid, uuid, uuid, timestamptz);

CREATE OR REPLACE PROCEDURE sp_register_check_in(
    p_ticket_segment_id uuid,
    p_check_in_status_id uuid,
    p_boarding_group_id uuid,
    p_checked_in_by_user_id uuid,
    p_checked_in_at timestamptz
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO check_in (
        ticket_segment_id,
        check_in_status_id,
        boarding_group_id,
        checked_in_by_user_id,
        checked_in_at
    )
    VALUES (
        p_ticket_segment_id,
        p_check_in_status_id,
        p_boarding_group_id,
        p_checked_in_by_user_id,
        p_checked_in_at
    );
END;
$$;
```

### 2.4 Script de demostracion
```sql
DO $$
DECLARE
    v_ticket_segment_id uuid;
    v_check_in_status_id uuid;
    v_boarding_group_id uuid;
    v_user_account_id uuid;
BEGIN
    SELECT ts.ticket_segment_id
    INTO v_ticket_segment_id
    FROM ticket_segment ts
    ORDER BY ts.created_at
    LIMIT 1;

    SELECT cis.check_in_status_id
    INTO v_check_in_status_id
    FROM check_in_status cis
    ORDER BY cis.created_at
    LIMIT 1;

    SELECT bg.boarding_group_id
    INTO v_boarding_group_id
    FROM boarding_group bg
    ORDER BY bg.created_at
    LIMIT 1;

    SELECT ua.user_account_id
    INTO v_user_account_id
    FROM user_account ua
    ORDER BY ua.created_at
    LIMIT 1;

    CALL sp_register_check_in(
        v_ticket_segment_id,
        v_check_in_status_id,
        v_boarding_group_id,
        v_user_account_id,
        now()
    );
END;
$$;

SELECT
    ci.check_in_id,
    ci.ticket_segment_id,
    ci.checked_in_at,
    bp.boarding_pass_id,
    bp.boarding_pass_code,
    bp.issued_at
FROM check_in ci
INNER JOIN boarding_pass bp
    ON bp.check_in_id = ci.check_in_id
ORDER BY ci.created_at DESC
LIMIT 5;
```

---

## 3. Validacion final
La solucion cumple con:
- consulta con mas de 5 tablas usando INNER JOIN,
- trigger AFTER INSERT en check_in,
- procedimiento reutilizable,
- script de demostracion con evidencia del boarding pass.
