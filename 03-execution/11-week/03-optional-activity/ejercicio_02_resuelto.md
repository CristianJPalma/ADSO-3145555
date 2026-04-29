# Ejercicio 02 Resuelto - Control de pagos y trazabilidad de transacciones financieras

## 1. Contexto del ejercicio
Se requiere consultar el flujo venta-pago-transaccion y automatizar un efecto posterior sobre refund dentro del dominio PAYMENT.

---

## 2. Solucion propuesta

### 2.1 Consulta resuelta con INNER JOIN
```sql
SELECT
    s.sale_code,
    r.reservation_code,
    p.payment_reference,
    ps.status_name AS payment_status_name,
    pm.method_name AS payment_method_name,
    pt.transaction_reference,
    pt.transaction_type,
    pt.transaction_amount,
    c.iso_currency_code
FROM sale s
INNER JOIN reservation r
    ON r.reservation_id = s.reservation_id
INNER JOIN payment p
    ON p.sale_id = s.sale_id
INNER JOIN payment_status ps
    ON ps.payment_status_id = p.payment_status_id
INNER JOIN payment_method pm
    ON pm.payment_method_id = p.payment_method_id
INNER JOIN payment_transaction pt
    ON pt.payment_id = p.payment_id
INNER JOIN currency c
    ON c.currency_id = p.currency_id
ORDER BY pt.processed_at DESC, s.sold_at DESC;
```

### 2.2 Trigger AFTER resuelto
```sql
DROP TRIGGER IF EXISTS trg_ai_payment_transaction_create_refund ON payment_transaction;
DROP FUNCTION IF EXISTS fn_ai_payment_transaction_create_refund();

CREATE OR REPLACE FUNCTION fn_ai_payment_transaction_create_refund()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    v_refund_reference varchar(40);
BEGIN
    IF upper(NEW.transaction_type) NOT IN ('REFUND', 'REVERSAL') THEN
        RETURN NEW;
    END IF;

    v_refund_reference := 'RF-' || replace(NEW.payment_transaction_id::text, '-', '');

    IF EXISTS (
        SELECT 1
        FROM refund r
        WHERE r.payment_id = NEW.payment_id
          AND r.refund_reference = left(v_refund_reference, 40)
    ) THEN
        RETURN NEW;
    END IF;

    INSERT INTO refund (
        payment_id,
        refund_reference,
        amount,
        requested_at,
        processed_at,
        refund_reason
    )
    VALUES (
        NEW.payment_id,
        left(v_refund_reference, 40),
        NEW.transaction_amount,
        NEW.processed_at,
        NEW.processed_at,
        COALESCE(NEW.provider_message, 'Refund generado desde payment_transaction')
    );

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_ai_payment_transaction_create_refund
AFTER INSERT ON payment_transaction
FOR EACH ROW
EXECUTE FUNCTION fn_ai_payment_transaction_create_refund();
```

### 2.3 Procedimiento almacenado resuelto
```sql
DROP PROCEDURE IF EXISTS sp_register_payment_transaction(uuid, varchar, varchar, numeric, timestamptz, text);

CREATE OR REPLACE PROCEDURE sp_register_payment_transaction(
    p_payment_id uuid,
    p_transaction_reference varchar,
    p_transaction_type varchar,
    p_transaction_amount numeric,
    p_processed_at timestamptz,
    p_provider_message text
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_transaction_amount <= 0 THEN
        RAISE EXCEPTION 'El monto procesado debe ser mayor que cero.';
    END IF;

    INSERT INTO payment_transaction (
        payment_id,
        transaction_reference,
        transaction_type,
        transaction_amount,
        processed_at,
        provider_message
    )
    VALUES (
        p_payment_id,
        p_transaction_reference,
        p_transaction_type,
        p_transaction_amount,
        p_processed_at,
        p_provider_message
    );
END;
$$;
```

### 2.4 Script de demostracion
```sql
DO $$
DECLARE
    v_payment_id uuid;
BEGIN
    SELECT p.payment_id
    INTO v_payment_id
    FROM payment p
    ORDER BY p.created_at
    LIMIT 1;

    CALL sp_register_payment_transaction(
        v_payment_id,
        'TX-REF-DEMO-001',
        'REFUND',
        25.50,
        now(),
        'Demostracion de transaccion de refund'
    );
END;
$$;

SELECT
    pt.payment_transaction_id,
    pt.payment_id,
    pt.transaction_type,
    pt.transaction_amount,
    pt.processed_at,
    r.refund_id,
    r.refund_reference,
    r.amount
FROM payment_transaction pt
LEFT JOIN refund r
    ON r.payment_id = pt.payment_id
WHERE pt.transaction_reference = 'TX-REF-DEMO-001'
ORDER BY pt.created_at DESC;
```

---

## 3. Validacion final
La solucion cumple con:
- consulta de mas de 5 tablas del dominio comercial/financiero,
- trigger AFTER INSERT sobre payment_transaction,
- procedimiento para registrar transacciones,
- evidencia posterior en refund.
