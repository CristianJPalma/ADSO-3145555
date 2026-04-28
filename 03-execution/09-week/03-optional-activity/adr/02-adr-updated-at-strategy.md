# ADR 0002 — Estrategia para `updated_at` (timestamps)

- **Estado:** proposed

- **Autor:** Equipo de modelado

## Contexto
El esquema crea en muchas tablas las columnas `created_at` y `updated_at` con `DEFAULT now()`. Sin embargo, `updated_at` no se actualiza automáticamente en UPDATE solo por el DEFAULT.

## Problema
Sin una política clara, `updated_at` queda desactualizado a menos que la aplicación siempre lo maneje. Esto genera inconsistencias y pérdida de trazabilidad cuando hay múltiples orígenes de actualización.

## Decisión
Implementar una función y trigger a nivel de base de datos que actualice `updated_at = now()` en cada UPDATE para las tablas que usan ambos campos. Alternativa aceptable: si un caso requiere control manual, permitir que la aplicación establezca `updated_at` explícitamente y documentarlo.

## Consecuencias
- Garantiza consistencia y evita dependencia exclusiva de la lógica de aplicación.
- Añade ligera sobrecarga en cada UPDATE (mínima).
- Requiere crear un `plpgsql` helper y triggers para las tablas objetivo.

## Ejemplo (SQL)
CREATE OR REPLACE FUNCTION audit.updated_at_trigger()
RETURNS trigger AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Luego: CREATE TRIGGER tr_table_updated_at BEFORE UPDATE ON my_table FOR EACH ROW EXECUTE FUNCTION audit.updated_at_trigger();

## Recomendación de aplicación
- Aplicar triggers a todas las tablas que incluyen `updated_at` salvo aquellas donde `updated_at` deba conservarse manualmente (documentar excepciones).
