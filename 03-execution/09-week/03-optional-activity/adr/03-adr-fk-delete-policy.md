# ADR 0003 — Política de `ON DELETE` en claves foráneas

- **Estado:** proposed
- **Autor:** Equipo de modelado

## Contexto
El modelo tiene numerosas claves foráneas sin comportamiento `ON DELETE` explícito. La opción por defecto (RESTRICT/NO ACTION) puede ser adecuada en muchos casos, pero en relaciones de propiedad la falta de cascada provoca datos huérfanos si la aplicación no los limpia.

## Decisión
- Adoptar `RESTRICT` (o no especificar) como comportamiento por defecto para proteger datos de negocio (ventas, pagos, transacciones).
- Usar `ON DELETE CASCADE` solo en relaciones de pertenencia/propiedad donde el hijo no tiene sentido sin el padre y no hay valor histórico (por ejemplo: `person_document`, `person_contact`).

## Consecuencias
- Evitamos borrados accidentales en datos críticos (financieros, históricos).
- Simplificamos mantenimiento automático de entidades dependientes que son puramente auxiliares.
- Requiere revisar cada FK y aplicar la cláusula explícita según la clasificación: "composición" vs "asociación".

## Ejemplos de aplicación sugerida
- Añadir `ON DELETE CASCADE` a: `person_document (person_id)`, `person_contact (person_id)`, `loyalty_account_tier (loyalty_account_id)` si aplica.
- Mantener NO ACTION/RESTRICT en: `sale`, `payment`, `invoice`, `miles_transaction` (datos financieros/históricos).

## Pasos
1. Catalogar FKs por tipo (composición vs asociación).
2. Aplicar `ALTER TABLE ... DROP CONSTRAINT ...; ADD CONSTRAINT ... FOREIGN KEY (...) REFERENCES ... ON DELETE CASCADE` cuando corresponda.
