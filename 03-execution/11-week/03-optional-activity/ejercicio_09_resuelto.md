# Ejercicio 09 Resuelto - Publicacion de tarifas y trazabilidad comercial

## 1. Contexto del ejercicio
Se requiere consultar la relacion entre tarifas, rutas y emisiones comerciales, y automatizar una accion posterior al registrar una nueva tarifa.

---

## 2. Solucion propuesta

### 2.1 Consulta resuelta con INNER JOIN
```sql
SELECT
    al.airline_name,
    f.fare_code,
    fc.fare_class_name,
    ao.airport_name AS origin_airport_name,
    ad.airport_name AS destination_airport_name,
    c.iso_currency_code,
    r.reservation_code,
    s.sale_code,
    t.ticket_number
FROM fare f
INNER JOIN airline al
    ON al.airline_id = f.airline_id
INNER JOIN fare_class fc
    ON fc.fare_class_id = f.fare_class_id
INNER JOIN airport ao
    ON ao.airport_id = f.origin_airport_id
INNER JOIN airport ad
    ON ad.airport_id = f.destination_airport_id
INNER JOIN currency c
    ON c.currency_id = f.currency_id
INNER JOIN ticket t
    ON t.fare_id = f.fare_id
INNER JOIN sale s
    ON s.sale_id = t.sale_id
INNER JOIN reservation r
    ON r.reservation_id = s.reservation_id
ORDER BY s.sold_at DESC;
```

### 2.2 Trigger AFTER resuelto
```sql
DROP TRIGGER IF EXISTS trg_ai_fare_touch_airline ON fare;
DROP FUNCTION IF EXISTS fn_ai_fare_touch_airline();

CREATE OR REPLACE FUNCTION fn_ai_fare_touch_airline()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE airline
    SET updated_at = now()
    WHERE airline_id = NEW.airline_id;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_ai_fare_touch_airline
AFTER INSERT ON fare
FOR EACH ROW
EXECUTE FUNCTION fn_ai_fare_touch_airline();
```

### 2.3 Procedimiento almacenado resuelto
```sql
DROP PROCEDURE IF EXISTS sp_publish_fare(uuid, uuid, uuid, uuid, uuid, numeric, date, date, varchar);

CREATE OR REPLACE PROCEDURE sp_publish_fare(
    p_airline_id uuid,
    p_origin_airport_id uuid,
    p_destination_airport_id uuid,
    p_fare_class_id uuid,
    p_currency_id uuid,
    p_base_amount numeric,
    p_valid_from date,
    p_valid_to date,
    p_fare_code varchar
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_base_amount <= 0 THEN
        RAISE EXCEPTION 'El monto base debe ser mayor que cero.';
    END IF;

    IF p_valid_to < p_valid_from THEN
        RAISE EXCEPTION 'Fecha valida_to no puede ser anterior a valid_from.';
    END IF;

    INSERT INTO fare (
        airline_id,
        origin_airport_id,
        destination_airport_id,
        fare_class_id,
        currency_id,
        base_amount,
        valid_from,
        valid_to,
        fare_code
    )
    VALUES (
        p_airline_id,
        p_origin_airport_id,
        p_destination_airport_id,
        p_fare_class_id,
        p_currency_id,
        p_base_amount,
        p_valid_from,
        p_valid_to,
        p_fare_code
    );
END;
$$;
```

### 2.4 Script de demostracion
```sql
DO $$
DECLARE
    v_airline_id uuid;
    v_origin_airport_id uuid;
    v_destination_airport_id uuid;
    v_fare_class_id uuid;
    v_currency_id uuid;
BEGIN
    SELECT al.airline_id INTO v_airline_id FROM airline al ORDER BY al.created_at LIMIT 1;
    SELECT a.airport_id INTO v_origin_airport_id FROM airport a ORDER BY a.created_at LIMIT 1;
    SELECT a.airport_id INTO v_destination_airport_id FROM airport a ORDER BY a.created_at DESC LIMIT 1;
    SELECT fc.fare_class_id INTO v_fare_class_id FROM fare_class fc ORDER BY fc.created_at LIMIT 1;
    SELECT c.currency_id INTO v_currency_id FROM currency c ORDER BY c.created_at LIMIT 1;

    CALL sp_publish_fare(
        v_airline_id,
        v_origin_airport_id,
        current_date,
        current_datee_class_id,
        v_currency_id,
        320.00,
        now(),
        now() + interval '30 days',
        'FARE-DEMO-001'
    );
END;
$$;

SELECT
    al.airline_id,
    al.airline_name,
    al.updated_at,
    f.fare_id,
    f.fare_code,
    f.base_amount
FROM fare f
INNER JOIN airline al
    ON al.airline_id = f.airline_id
WHERE f.fare_code = 'FARE-DEMO-001'
ORDER BY f.created_at DESC;
```

---

## 3. Validacion final
La solucion cumple con:
- consulta comercial con INNER JOIN sobre 9 tablas,
- trigger AFTER INSERT sobre fare,
- procedimiento de publicacion de tarifa,
- evidencia posterior en airline.updated_at.
