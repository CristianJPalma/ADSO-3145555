# Requerimientos del Sistema — Sistema de Gestión de Pedidos (Cafetín SENA Industrial)

## 1. Requerimientos funcionales (RF)

**RF-01.** El sistema debe permitir al **Usuario** visualizar el catálogo de productos disponibles en el cafetín.  

**RF-02.** El sistema debe permitir al **Usuario** seleccionar productos, agregarlos a un carrito de compras y modificar sus cantidades.  

**RF-03.** El sistema debe permitir al **Usuario** confirmar el pedido generado desde el carrito de compras.  

**RF-04.** El sistema debe registrar cada pedido confirmado con un **identificador** y un **estado inicial**.  

**RF-05.** El sistema debe permitir al **Personal del Cafetín** visualizar la lista de pedidos realizados.  

**RF-06.** El sistema debe permitir al **Personal del Cafetín** cambiar el estado de los pedidos durante su proceso de atención.  

---

## 2. Requerimientos no funcionales (RNF)

**RNF-01.** El sistema debe restringir el acceso a las funcionalidades según el **rol del usuario**.  

**RNF-02.** El sistema debe ser fácil de usar, permitiendo realizar un pedido en **pocos pasos**.  

**RNF-03.** El sistema debe responder a las acciones del usuario en un **tiempo adecuado**.  

**RNF-04.** El sistema debe ser accesible desde un **navegador web**.  

**RNF-05.** El sistema debe garantizar la **integridad y consistencia** de la información de los pedidos.  

---

## 3. Reglas de negocio (RN)

**RN-01.** Solo el **Usuario** puede crear y confirmar pedidos.  

**RN-02.** Todo pedido confirmado debe iniciar con el estado **“pendiente”**.  

**RN-03.** Solo el **Personal del Cafetín** está autorizado para cambiar el estado de los pedidos.  

**RN-04.** El estado de un pedido debe seguir el flujo: **pendiente → en preparación → listo → entregado**.  

**RN-05.** Un pedido marcado como **“entregado”** no puede ser modificado.  