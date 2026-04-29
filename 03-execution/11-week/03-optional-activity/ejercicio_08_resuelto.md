# Ejercicio 08 Resuelto - Seguridad: usuarios, roles y permisos

## 1. Contexto del ejercicio
Se requiere consultar el mapa de autorizacion de usuarios y automatizar una accion posterior cuando se asigne un rol a una cuenta.

---

## 2. Solucion propuesta

### 2.1 Consulta resuelta con INNER JOIN
```sql
SELECT
    p.first_name,
    p.last_name,
    ua.username,
    us.status_name AS user_status_name,
    sr.role_name,
    ur.assigned_at,
    sp.permission_name
FROM person p
INNER JOIN user_account ua
    ON ua.person_id = p.person_id
INNER JOIN user_status us
    ON us.user_status_id = ua.user_status_id
INNER JOIN user_role ur
    ON ur.user_account_id = ua.user_account_id
INNER JOIN security_role sr
    ON sr.security_role_id = ur.security_role_id
INNER JOIN role_permission rp
    ON rp.security_role_id = sr.security_role_id
INNER JOIN security_permission sp
    ON sp.security_permission_id = rp.security_permission_id
ORDER BY ua.username, sr.role_name, sp.permission_name;
```

### 2.2 Trigger AFTER resuelto
```sql
DROP TRIGGER IF EXISTS trg_ai_user_role_touch_user_account ON user_role;
DROP FUNCTION IF EXISTS fn_ai_user_role_touch_user_account();

CREATE OR REPLACE FUNCTION fn_ai_user_role_touch_user_account()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE user_account
    SET updated_at = now()
    WHERE user_account_id = NEW.user_account_id;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_ai_user_role_touch_user_account
AFTER INSERT ON user_role
FOR EACH ROW
EXECUTE FUNCTION fn_ai_user_role_touch_user_account();
```

### 2.3 Procedimiento almacenado resuelto
```sql
DROP PROCEDURE IF EXISTS sp_assign_user_role(uuid, uuid, uuid);

CREATE OR REPLACE PROCEDURE sp_assign_user_role(
    p_user_account_id uuid,
    p_security_role_id uuid,
    p_assigned_by_user_id uuid
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM user_role ur
        WHERE ur.user_account_id = p_user_account_id
          AND ur.security_role_id = p_security_role_id
    ) THEN
        RAISE NOTICE 'La asignacion ya existe para el usuario % y rol %.', p_user_account_id, p_security_role_id;
        RETURN;
    END IF;

    INSERT INTO user_role (
        user_account_id,
        security_role_id,
        assigned_by_user_id
    )
    VALUES (
        p_user_account_id,
        p_security_role_id,
        p_assigned_by_user_id
    );
END;
$$;
```

### 2.4 Script de demostracion
```sql
DO $$
DECLARE
    v_user_account_id uuid;
    v_security_role_id uuid;
    v_assigned_by_user_id uuid;
BEGIN
    SELECT ua.user_account_id
    INTO v_user_account_id
    FROM user_account ua
    ORDER BY ua.created_at
    LIMIT 1;

    SELECT sr.security_role_id
    INTO v_security_role_id
    FROM security_role sr
    ORDER BY sr.created_at
    LIMIT 1;

    SELECT ua.user_account_id
    INTO v_assigned_by_user_id
    FROM user_account ua
    ORDER BY ua.created_at
    LIMIT 1;

    CALL sp_assign_user_role(
        v_user_account_id,
        v_security_role_id,
        v_assigned_by_user_id
    );
END;
$$;

SELECT
    ua.user_account_id,
    ua.username,
    ua.updated_at,
    ur.user_role_id,
    ur.assigned_at
FROM user_role ur
INNER JOIN user_account ua
    ON ua.user_account_id = ur.user_account_id
ORDER BY ur.created_at DESC
LIMIT 5;
```

---

## 3. Validacion final
La solucion cumple con:
- consulta de seguridad con INNER JOIN en 7 tablas,
- trigger AFTER INSERT sobre user_role,
- procedimiento para asignar roles,
- evidencia del efecto posterior en user_account.
