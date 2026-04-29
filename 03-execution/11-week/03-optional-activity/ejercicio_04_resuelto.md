# Ejercicio 04 Resuelto - Fidelizacion, nivel de cuenta y actividad comercial del cliente

## 1. Contexto del ejercicio
Se requiere consultar clientes con programa de fidelizacion y su actividad comercial, y automatizar una accion posterior al registrar movimientos de millas.

---

## 2. Solucion propuesta

### 2.1 Consulta resuelta con INNER JOIN
```sql
SELECT
    c.customer_id,
    p.first_name,
    p.last_name,
    la.account_number,
    lp.program_name,
    lt.tier_name,
    lat.assigned_at,
    s.sale_code
FROM customer c
INNER JOIN person p
    ON p.person_id = c.person_id
INNER JOIN loyalty_account la
    ON la.customer_id = c.customer_id
INNER JOIN loyalty_program lp
    ON lp.loyalty_program_id = la.loyalty_program_id
INNER JOIN loyalty_account_tier lat
    ON lat.loyalty_account_id = la.loyalty_account_id
INNER JOIN loyalty_tier lt
    ON lt.loyalty_tier_id = lat.loyalty_tier_id
LEFT JOIN reservation r
    ON r.booked_by_customer_id = c.customer_id
LEFT JOIN sale s
    ON s.reservation_id = r.reservation_id
ORDER BY lat.assigned_at DESC;
```

### 2.2 Trigger AFTER resuelto
```sql
DROP TRIGGER IF EXISTS trg_ai_miles_transaction_touch_loyalty_account ON miles_transaction;
DROP FUNCTION IF EXISTS fn_ai_miles_transaction_touch_loyalty_account();

CREATE OR REPLACE FUNCTION fn_ai_miles_transaction_touch_loyalty_account()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE loyalty_account
    SET updated_at = now()
    WHERE loyalty_account_id = NEW.loyalty_account_id;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_ai_miles_transaction_touch_loyalty_account
AFTER INSERT ON miles_transaction
FOR EACH ROW
EXECUTE FUNCTION fn_ai_miles_transaction_touch_loyalty_account();
```

### 2.3 Procedimiento almacenado resuelto
```sql
DROP PROCEDURE IF EXISTS sp_register_miles_transaction(uuid, varchar, integer, timestamptz, varchar, text);

CREATE OR REPLACE PROCEDURE sp_register_miles_transaction(
    p_loyalty_account_id uuid,
    p_transaction_type varchar,
    p_miles_delta integer,
    p_occurred_at timestamptz,
    p_reference_code varchar,
    p_notes text
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_miles_delta = 0 THEN
        RAISE EXCEPTION 'La cantidad de millas no puede ser cero.';
    END IF;

    IF p_transaction_type NOT IN ('EARN', 'REDEEM', 'ADJUST') THEN
        RAISE EXCEPTION 'Tipo de transaccion invalido: %', p_transaction_type;
    END IF;

    INSERT INTO miles_transaction (
        loyalty_account_id,
        transaction_type,
        miles_delta,
        occurred_at,
        reference_code,
        notes
    )
    VALUES (
        p_loyalty_account_id,
        p_transaction_type,
        p_miles_delta,
        p_occurred_at,
        p_reference_code,
        p_notes
    );
END;
$$;
```

### 2.4 Script de demostracion
```sql
DO $$
DECLARE
    v_loyalty_account_id uuid;
BEGIN
    SELECT la.loyalty_account_id
    INTO v_loyalty_account_id
    FROM loyalty_account la
    ORDER BY la.created_at
    LIMITDEMO-EARN-001',
        ' 1;

    CALL sp_register_miles_transaction(
        v_loyalty_account_id,
        'EARN',
        350,
        now(),
        'Acumulacion demo por compra de servicio'
    );
END;
$$;

SELECT
    la.loyalty_account_id,
    la.updated_at,
    mt.miles_transaction_id,
    mt.transaction_type,
    mt.miles_amount,
    mt.event_at
FROM miles_transaction mt
INNER JOIN loyalty_account la
    ON la.loyalty_account_id = mt.loyalty_account_id
ORDER BY mt.created_at DESC
LIMIT 5;
```

---

## 3. Validacion final
La solucion cumple con:
- consulta multitabla de fidelizacion y ventas,
- trigger AFTER INSERT sobre miles_transaction,
- procedimiento reutilizable para registrar millas,
- evidencia de trazabilidad en loyalty_account.
