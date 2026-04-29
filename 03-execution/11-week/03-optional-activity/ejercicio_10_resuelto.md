# Ejercicio 10 Resuelto - Identidad del pasajero y trazabilidad documental

## 1. Contexto del ejercicio
Se requiere consultar identidad, documentos, contactos y participacion en reservas, y automatizar una accion posterior al registrar documentos de persona.

---

## 2. Solucion propuesta

### 2.1 Consulta resuelta con INNER JOIN
```sql
SELECT
    p.first_name,
    p.last_name,
    pt.type_name AS person_type_name,
    dt.type_name AS document_type_name,
    pd.document_number,
    ct.type_name AS contact_type_name,
    pc.contact_value,
    r.reservation_code,
    rp.passenger_sequence_no
FROM person p
INNER JOIN person_type pt
    ON pt.person_type_id = p.person_type_id
INNER JOIN person_document pd
    ON pd.person_id = p.person_id
INNER JOIN document_type dt
    ON dt.document_type_id = pd.document_type_id
INNER JOIN person_contact pc
    ON pc.person_id = p.person_id
INNER JOIN contact_type ct
    ON ct.contact_type_id = pc.contact_type_id
INNER JOIN reservation_passenger rp
    ON rp.person_id = p.person_id
INNER JOIN reservation r
    ON r.reservation_id = rp.reservation_id
ORDER BY r.created_at DESC, rp.passenger_sequence_no ASC;
```

### 2.2 Trigger AFTER resuelto
```sql
DROP TRIGGER IF EXISTS trg_ai_person_document_touch_person ON person_document;
DROP FUNCTION IF EXISTS fn_ai_person_document_touch_person();

CREATE OR REPLACE FUNCTION fn_ai_person_document_touch_person()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE person
    SET updated_at = now()
    WHERE person_id = NEW.person_id;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_ai_person_document_touch_person
AFTER INSERT OR UPDATE ON person_document
FOR EACH ROW
EXECUTE FUNCTION fn_ai_person_document_touch_person();
```

### 2.3 Procedimiento almacenado resuelto
```sql
DROP PROCEDURE IF EXISTS sp_register_person_document(uuid, uuid, varchar, uuid, date, date);

CREATE OR REPLACE PROCEDURE sp_register_person_document(
    p_person_id uuid,
    p_document_type_id uuid,
    p_document_number varchar,
    p_issuing_country_id uuid,
    p_issued_on date,
    p_expires_on date
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_expires_on < p_issued_on THEN
        RAISE EXCEPTION 'Fecha de expiracion no puede ser anterior a fecha de emision.';
    END IF;

    INSERT INTO person_document (
        person_id,
        document_type_id,
        document_number,
        issuing_country_id,
        issued_on,
        expires_on
    )
    VALUES (
        p_person_id,
        p_document_type_id,
        p_document_number,
        p_issuing_country_id,
        p_issued_on,
        p_expires_on
    );
END;
$$;
```

### 2.4 Script de demostracion
```sql
DO $$
DECLARE
    v_person_id uuid;
    v_document_type_id uuid;
    v_issuer_country_id uuid;
BEGIN
    SELECT p.person_id
    INTO v_person_id
    FROM person p
    ORDER BY p.created_at
    LIMIT 1;

    SELECT dt.document_type_id
    INTO v_document_type_id
    FROM document_type dt
    ORDER BY dt.created_at
    LIMIT 1;

    SELECT c.country_id
    INTO v_issuer_country_id
    FROM country c
    ORDER BY c.created_at
    LIMIT 1;

    CALL sp_register_person_document(
        v_person_id,
        v_document_type_id,
        'DOC-DEMO-2026-001',
        v_issuer_country_id,
        current_date,
        current_date + interval '5 years'
    );
END;
$$;

SELECT
    p.person_id,
    p.updated_at,
    pd.person_document_id,
    pd.document_number,
    pd.issue_date,
    pd.expiry_date
FROM person_document pd
INNER JOIN person p
    ON p.person_id = pd.person_id
WHERE pd.document_number = 'DOC-DEMO-2026-001'
ORDER BY pd.created_at DESC;
```

---

## 3. Validacion final
La solucion cumple con:
- consulta de identidad con INNER JOIN sobre 8 tablas,
- trigger AFTER INSERT/UPDATE sobre person_document,
- procedimiento de registro documental,
- evidencia de trazabilidad en person.updated_at.
