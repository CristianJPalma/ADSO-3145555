# ADR 0004 — Eliminar restricción única redundante en `ticket_segment`

- **Estado:** proposed
- **Autor:** Equipo de modelado

## Contexto
La tabla `ticket_segment` declara `ticket_segment_id` como `PRIMARY KEY` y además incluye la restricción `CONSTRAINT uq_ticket_segment_pair UNIQUE (ticket_segment_id, flight_segment_id)`.

## Problema
La restricción `UNIQUE` sobre `(ticket_segment_id, flight_segment_id)` es redundante porque `ticket_segment_id` es único por sí mismo (PK). Mantenerla añade complejidad y ruido al esquema.

## Decisión
Eliminar la restricción `uq_ticket_segment_pair` para evitar redundancia. Si la intención era garantizar la unicidad del par `(ticket_id, flight_segment_id)` ya existe la restricción `uq_ticket_segment_flight` y debe conservarse.

## Consecuencias
- Simplifica el esquema y evita confusión al revisar constraints.
- Si hay código que depende del nombre de la constraint, deberá actualizarse.

## Acción recomendada
Ejecutar: `ALTER TABLE ticket_segment DROP CONSTRAINT IF EXISTS uq_ticket_segment_pair;`
