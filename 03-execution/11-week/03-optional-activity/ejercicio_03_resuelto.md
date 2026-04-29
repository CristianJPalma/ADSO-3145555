# Ejercicio 03 Resuelto - Facturacion e integracion entre venta, impuestos y detalle facturable

## 1. Contexto del ejercicio
Se requiere consultar la integracion entre venta, factura y lineas facturables, y automatizar una accion posterior sobre la cabecera de factura cuando se inserta una linea.

---

## 2. Solucion propuesta

### 2.1 Consulta resuelta con INNER JOIN
```sql
SELECT
    s.sale_code,
    i.invoice_number,
    ist.status_name AS invoice_status_name,
    il.line_number,
    il.line_description,
    il.quantity,
    il.unit_price,
    t.tax_name,
    c.iso_currency_code
FROM sale s
INNER JOIN invoice i
    ON i.sale_id = s.sale_id
INNER JOIN invoice_status ist
    ON ist.invoice_status_id = i.invoice_status_id
INNER JOIN invoice_line il
    ON il.invoice_id = i.invoice_id
LEFT JOIN tax t
    ON t.tax_id = il.tax_id
INNER JOIN currency c
    ON c.currency_id = i.currency_id
ORDER BY i.issued_at DESC, il.line_number ASC;
```

### 2.2 Trigger AFTER resuelto
```sql
DROP TRIGGER IF EXISTS trg_ai_invoice_line_touch_invoice ON invoice_line;
DROP FUNCTION IF EXISTS fn_ai_invoice_line_touch_invoice();

CREATE OR REPLACE FUNCTION fn_ai_invoice_line_touch_invoice()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE invoice
    SET updated_at = now()
    WHERE invoice_id = NEW.invoice_id;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_ai_invoice_line_touch_invoice
AFTER INSERT ON invoice_line
FOR EACH ROW
EXECUTE FUNCTION fn_ai_invoice_line_touch_invoice();
```

### 2.3 Procedimiento almacenado resuelto
```sql
DROP PROCEDURE IF EXISTS sp_add_invoice_line(uuid, uuid, varchar, numeric, numeric);

CREATE OR REPLACE PROCEDURE sp_add_invoice_line(
    p_invoice_id uuid,
    p_tax_id uuid,
    p_line_description varchar,
    p_quantity numeric,
    p_unit_price numeric
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_line_number integer;
BEGIN
    IF p_quantity <= 0 THEN
        RAISE EXCEPTION 'La cantidad debe ser mayor que cero.';
    END IF;

    IF p_unit_price < 0 THEN
        RAISE EXCEPTION 'El valor unitario no puede ser negativo.';
    END IF;

    SELECT COALESCE(MAX(il.line_number), 0) + 1
    INTO v_line_number
    FROM invoice_line il
    WHERE il.invoice_id = p_invoice_id;

    INSERT INTO invoice_line (
        invoice_id,
        tax_id,
        line_number,
        line_description,
        quantity,
        unit_price
    )
    VALUES (
        p_invoice_id,
        p_tax_id,
        v_line_number,
        p_line_description,
        p_quantity,
        p_unit_price
    );
END;
$$;
```

### 2.4 Script de demostracion
```sql
DO $$
DECLARE
    v_invoice_id uuid;
    v_tax_id uuid;
BEGIN
    SELECT i.invoice_id
    INTO v_invoice_id
    FROM invoice i
    ORDER BY i.created_at
    LIMIT 1;

    SELECT t.tax_id
    INTO v_tax_id
    FROM tax t
    ORDER BY t.created_at
    LIMIT 1;

    CALL sp_add_invoice_line(
        v_invoice_id,
        v_tax_id,
        'Linea demo para validacion del trigger',
        1,
        99.90
    );
END;
$$;

SELECT
    i.invoice_id,
    i.invoice_number,
    i.updated_at,
    il.invoice_line_id,
    il.line_number,
    il.line_description
FROM invoice i
INNER JOIN invoice_line il
    ON il.invoice_id = i.invoice_id
ORDER BY il.created_at DESC
LIMIT 5;
```

---

## 3. Validacion final
La solucion cumple con:
- consulta con INNER JOIN sobre 6 tablas,
- trigger AFTER INSERT en invoice_line,
- procedimiento reutilizable para lineas,
- evidencia de actualizacion en invoice.updated_at.
