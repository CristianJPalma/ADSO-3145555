-- =============================================================================
-- DATABASE: coffee-shop
-- PostgreSQL DDL - Complete Schema
-- =============================================================================

DROP DATABASE IF EXISTS "coffee-shop";
CREATE DATABASE "coffee-shop";

-- Connect to the database (run this in psql or your client)
-- \c coffee-shop

-- =============================================================================
-- MODULE 2: PARAMETER
-- Base/reference tables (no external dependencies)
-- Chain: type_document → person → file
-- =============================================================================

-- -----------------------------------------------------------------------------
-- TABLE: type_document
-- Stores document types (DNI, Passport, RUC, etc.)
-- -----------------------------------------------------------------------------
CREATE TABLE type_document (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(100)    NOT NULL,
    description     TEXT,
    code            VARCHAR(20)     NOT NULL UNIQUE,

    -- Audit attributes
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ,
    deleted_at      TIMESTAMPTZ,
    created_by      UUID,
    updated_by      UUID,
    deleted_by      UUID,
    status          VARCHAR(20)     NOT NULL DEFAULT 'active'
);

-- -----------------------------------------------------------------------------
-- TABLE: person
-- Stores natural persons (employees, customers, suppliers, etc.)
-- -----------------------------------------------------------------------------
CREATE TABLE person (
    id                  UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name          VARCHAR(100)    NOT NULL,
    last_name           VARCHAR(100)    NOT NULL,
    type_document_id    UUID            NOT NULL REFERENCES type_document(id),
    document_number     VARCHAR(50)     NOT NULL,
    phone               VARCHAR(20),
    address             TEXT,
    birth_date          DATE,

    -- Audit attributes
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ,
    deleted_at          TIMESTAMPTZ,
    created_by          UUID,
    updated_by          UUID,
    deleted_by          UUID,
    status              VARCHAR(20)     NOT NULL DEFAULT 'active',

    CONSTRAINT uq_person_document UNIQUE (type_document_id, document_number)
);

-- -----------------------------------------------------------------------------
-- TABLE: file
-- Stores file metadata (documents, images, attachments)
-- -----------------------------------------------------------------------------
CREATE TABLE file (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(255)    NOT NULL,
    original_name   VARCHAR(255)    NOT NULL,
    mime_type       VARCHAR(100)    NOT NULL,
    size            BIGINT          NOT NULL,
    url             TEXT            NOT NULL,
    entity_name     VARCHAR(100),   -- e.g. 'person', 'product'
    entity_id       UUID,           -- ID of the related entity

    -- Audit attributes
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ,
    deleted_at      TIMESTAMPTZ,
    created_by      UUID,
    updated_by      UUID,
    deleted_by      UUID,
    status          VARCHAR(20)     NOT NULL DEFAULT 'active'
);

-- =============================================================================
-- MODULE 1: SECURITY
-- RBAC (Role-Based Access Control) Implementation
-- Chain: User → Role → Module → View
-- =============================================================================

-- -----------------------------------------------------------------------------
-- TABLE: role
-- Stores organizational roles (Admin, Manager, Cashier, etc.)
-- -----------------------------------------------------------------------------
CREATE TABLE role (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(100)    NOT NULL UNIQUE,
    description     TEXT,

    -- Audit attributes
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ,
    deleted_at      TIMESTAMPTZ,
    created_by      UUID,
    updated_by      UUID,
    deleted_by      UUID,
    status          VARCHAR(20)     NOT NULL DEFAULT 'active'
);

-- -----------------------------------------------------------------------------
-- TABLE: module
-- Groups related functionalities (Security, Inventory, Sales, etc.)
-- -----------------------------------------------------------------------------
CREATE TABLE module (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(100)    NOT NULL UNIQUE,
    description     TEXT,
    icon            VARCHAR(100),
    route           VARCHAR(255),

    -- Audit attributes
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ,
    deleted_at      TIMESTAMPTZ,
    created_by      UUID,
    updated_by      UUID,
    deleted_by      UUID,
    status          VARCHAR(20)     NOT NULL DEFAULT 'active'
);

-- -----------------------------------------------------------------------------
-- TABLE: view
-- Represents specific screens or actions within a module
-- -----------------------------------------------------------------------------
CREATE TABLE view (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(100)    NOT NULL,
    description     TEXT,
    route           VARCHAR(255)    NOT NULL UNIQUE,

    -- Audit attributes
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ,
    deleted_at      TIMESTAMPTZ,
    created_by      UUID,
    updated_by      UUID,
    deleted_by      UUID,
    status          VARCHAR(20)     NOT NULL DEFAULT 'active'
);

-- -----------------------------------------------------------------------------
-- TABLE: user
-- Stores system users
-- NOTE: "user" is a reserved word in PostgreSQL → use double quotes
-- -----------------------------------------------------------------------------
CREATE TABLE "user" (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    username        VARCHAR(100)    NOT NULL UNIQUE,
    email           VARCHAR(255)    NOT NULL UNIQUE,
    password        VARCHAR(255)    NOT NULL,
    person_id       UUID            REFERENCES person(id),   -- FK → Module 2

    -- Audit attributes
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ,
    deleted_at      TIMESTAMPTZ,
    created_by      UUID,
    updated_by      UUID,
    deleted_by      UUID,
    status          VARCHAR(20)     NOT NULL DEFAULT 'active'
);

-- -----------------------------------------------------------------------------
-- TABLE: user_role
-- Many-to-many: users ↔ roles
-- -----------------------------------------------------------------------------
CREATE TABLE user_role (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID            NOT NULL REFERENCES "user"(id),
    role_id         UUID            NOT NULL REFERENCES role(id),

    -- Audit attributes
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ,
    deleted_at      TIMESTAMPTZ,
    created_by      UUID,
    updated_by      UUID,
    deleted_by      UUID,
    status          VARCHAR(20)     NOT NULL DEFAULT 'active',

    CONSTRAINT uq_user_role UNIQUE (user_id, role_id)
);

-- -----------------------------------------------------------------------------
-- TABLE: role_module
-- Many-to-many: roles ↔ modules
-- -----------------------------------------------------------------------------
CREATE TABLE role_module (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id         UUID            NOT NULL REFERENCES role(id),
    module_id       UUID            NOT NULL REFERENCES module(id),

    -- Audit attributes
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ,
    deleted_at      TIMESTAMPTZ,
    created_by      UUID,
    updated_by      UUID,
    deleted_by      UUID,
    status          VARCHAR(20)     NOT NULL DEFAULT 'active',

    CONSTRAINT uq_role_module UNIQUE (role_id, module_id)
);

-- -----------------------------------------------------------------------------
-- TABLE: module_view
-- Many-to-many: modules ↔ views
-- -----------------------------------------------------------------------------
CREATE TABLE module_view (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    module_id       UUID            NOT NULL REFERENCES module(id),
    view_id         UUID            NOT NULL REFERENCES view(id),

    -- Audit attributes
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ,
    deleted_at      TIMESTAMPTZ,
    created_by      UUID,
    updated_by      UUID,
    deleted_by      UUID,
    status          VARCHAR(20)     NOT NULL DEFAULT 'active',

    CONSTRAINT uq_module_view UNIQUE (module_id, view_id)
);

-- =============================================================================
-- MODULE 3: INVENTORY
-- Chain: category → product ← supplier → inventory
-- =============================================================================

-- -----------------------------------------------------------------------------
-- TABLE: category
-- Product categories (Coffee, Food, Beverages, etc.)
-- -----------------------------------------------------------------------------
CREATE TABLE category (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(100)    NOT NULL UNIQUE,
    description     TEXT,
    icon            VARCHAR(100),

    -- Audit attributes
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ,
    deleted_at      TIMESTAMPTZ,
    created_by      UUID            REFERENCES "user"(id),
    updated_by      UUID            REFERENCES "user"(id),
    deleted_by      UUID            REFERENCES "user"(id),
    status          VARCHAR(20)     NOT NULL DEFAULT 'active'
);

-- -----------------------------------------------------------------------------
-- TABLE: supplier
-- Stores supplier information
-- -----------------------------------------------------------------------------
CREATE TABLE supplier (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    person_id       UUID            NOT NULL REFERENCES person(id),
    company_name    VARCHAR(255)    NOT NULL,
    email           VARCHAR(255),
    phone           VARCHAR(20),
    address         TEXT,

    -- Audit attributes
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ,
    deleted_at      TIMESTAMPTZ,
    created_by      UUID            REFERENCES "user"(id),
    updated_by      UUID            REFERENCES "user"(id),
    deleted_by      UUID            REFERENCES "user"(id),
    status          VARCHAR(20)     NOT NULL DEFAULT 'active'
);

-- -----------------------------------------------------------------------------
-- TABLE: product
-- Coffee shop products (drinks, food, merchandise)
-- -----------------------------------------------------------------------------
CREATE TABLE product (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id     UUID            NOT NULL REFERENCES category(id),
    supplier_id     UUID            REFERENCES supplier(id),
    name            VARCHAR(255)    NOT NULL,
    description     TEXT,
    price           NUMERIC(10, 2)  NOT NULL CHECK (price >= 0),
    cost            NUMERIC(10, 2)  NOT NULL CHECK (cost >= 0),
    sku             VARCHAR(100)    UNIQUE,
    image_url       TEXT,

    -- Audit attributes
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ,
    deleted_at      TIMESTAMPTZ,
    created_by      UUID            REFERENCES "user"(id),
    updated_by      UUID            REFERENCES "user"(id),
    deleted_by      UUID            REFERENCES "user"(id),
    status          VARCHAR(20)     NOT NULL DEFAULT 'active'
);

-- -----------------------------------------------------------------------------
-- TABLE: inventory
-- Tracks stock levels for each product
-- -----------------------------------------------------------------------------
CREATE TABLE inventory (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id      UUID            NOT NULL REFERENCES product(id),
    quantity        NUMERIC(10, 2)  NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    min_stock       NUMERIC(10, 2)  NOT NULL DEFAULT 0,
    max_stock       NUMERIC(10, 2),
    unit            VARCHAR(50)     NOT NULL DEFAULT 'units',   -- units, kg, liters

    -- Audit attributes
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ,
    deleted_at      TIMESTAMPTZ,
    created_by      UUID            REFERENCES "user"(id),
    updated_by      UUID            REFERENCES "user"(id),
    deleted_by      UUID            REFERENCES "user"(id),
    status          VARCHAR(20)     NOT NULL DEFAULT 'active',

    CONSTRAINT uq_inventory_product UNIQUE (product_id)
);

-- =============================================================================
-- MODULE 4: SALES
-- Chain: customer → order → order_item ← product
-- =============================================================================

-- -----------------------------------------------------------------------------
-- TABLE: customer
-- Coffee shop customers
-- -----------------------------------------------------------------------------
CREATE TABLE customer (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    person_id       UUID            NOT NULL REFERENCES person(id),
    loyalty_points  INTEGER         NOT NULL DEFAULT 0,
    notes           TEXT,

    -- Audit attributes
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ,
    deleted_at      TIMESTAMPTZ,
    created_by      UUID            REFERENCES "user"(id),
    updated_by      UUID            REFERENCES "user"(id),
    deleted_by      UUID            REFERENCES "user"(id),
    status          VARCHAR(20)     NOT NULL DEFAULT 'active'
);

-- -----------------------------------------------------------------------------
-- TABLE: method_payment
-- Available payment methods (Cash, Credit Card, QR, etc.)
-- -----------------------------------------------------------------------------
CREATE TABLE method_payment (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(100)    NOT NULL UNIQUE,
    description     TEXT,

    -- Audit attributes
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ,
    deleted_at      TIMESTAMPTZ,
    created_by      UUID            REFERENCES "user"(id),
    updated_by      UUID            REFERENCES "user"(id),
    deleted_by      UUID            REFERENCES "user"(id),
    status          VARCHAR(20)     NOT NULL DEFAULT 'active'
);

-- -----------------------------------------------------------------------------
-- TABLE: order
-- Customer orders / sales transactions
-- NOTE: "order" is a reserved word in PostgreSQL → use double quotes
-- -----------------------------------------------------------------------------
CREATE TABLE "order" (
    id                  UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id         UUID            REFERENCES customer(id),   -- nullable: walk-in customer
    user_id             UUID            NOT NULL REFERENCES "user"(id),   -- cashier/staff
    order_number        VARCHAR(50)     NOT NULL UNIQUE,
    order_date          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    subtotal            NUMERIC(10, 2)  NOT NULL DEFAULT 0,
    tax                 NUMERIC(10, 2)  NOT NULL DEFAULT 0,
    discount            NUMERIC(10, 2)  NOT NULL DEFAULT 0,
    total               NUMERIC(10, 2)  NOT NULL DEFAULT 0,
    notes               TEXT,

    -- Audit attributes
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ,
    deleted_at          TIMESTAMPTZ,
    created_by          UUID            REFERENCES "user"(id),
    updated_by          UUID            REFERENCES "user"(id),
    deleted_by          UUID            REFERENCES "user"(id),
    status              VARCHAR(20)     NOT NULL DEFAULT 'pending'
    -- status values: pending, confirmed, in_progress, completed, cancelled
);

-- -----------------------------------------------------------------------------
-- TABLE: order_item
-- Individual line items within an order
-- -----------------------------------------------------------------------------
CREATE TABLE order_item (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id        UUID            NOT NULL REFERENCES "order"(id),
    product_id      UUID            NOT NULL REFERENCES product(id),
    quantity        NUMERIC(10, 2)  NOT NULL CHECK (quantity > 0),
    unit_price      NUMERIC(10, 2)  NOT NULL CHECK (unit_price >= 0),
    discount        NUMERIC(10, 2)  NOT NULL DEFAULT 0,
    subtotal        NUMERIC(10, 2)  NOT NULL DEFAULT 0,
    notes           TEXT,

    -- Audit attributes
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ,
    deleted_at      TIMESTAMPTZ,
    created_by      UUID            REFERENCES "user"(id),
    updated_by      UUID            REFERENCES "user"(id),
    deleted_by      UUID            REFERENCES "user"(id),
    status          VARCHAR(20)     NOT NULL DEFAULT 'active'
);

-- =============================================================================
-- MODULE 5: BILLING
-- Chain: order → invoice → invoice_item
--                       ↘ payment ← method_payment
-- =============================================================================

-- -----------------------------------------------------------------------------
-- TABLE: invoice
-- Official billing document linked to an order
-- -----------------------------------------------------------------------------
CREATE TABLE invoice (
    id                  UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id            UUID            NOT NULL REFERENCES "order"(id),
    customer_id         UUID            REFERENCES customer(id),
    invoice_number      VARCHAR(50)     NOT NULL UNIQUE,
    issue_date          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    due_date            TIMESTAMPTZ,
    subtotal            NUMERIC(10, 2)  NOT NULL DEFAULT 0,
    tax                 NUMERIC(10, 2)  NOT NULL DEFAULT 0,
    discount            NUMERIC(10, 2)  NOT NULL DEFAULT 0,
    total               NUMERIC(10, 2)  NOT NULL DEFAULT 0,
    notes               TEXT,

    -- Audit attributes
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ,
    deleted_at          TIMESTAMPTZ,
    created_by          UUID            REFERENCES "user"(id),
    updated_by          UUID            REFERENCES "user"(id),
    deleted_by          UUID            REFERENCES "user"(id),
    status              VARCHAR(20)     NOT NULL DEFAULT 'draft'
    -- status values: draft, issued, paid, cancelled, void
);

-- -----------------------------------------------------------------------------
-- TABLE: invoice_item
-- Line items detailed on the invoice
-- -----------------------------------------------------------------------------
CREATE TABLE invoice_item (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_id      UUID            NOT NULL REFERENCES invoice(id),
    product_id      UUID            NOT NULL REFERENCES product(id),
    description     TEXT,
    quantity        NUMERIC(10, 2)  NOT NULL CHECK (quantity > 0),
    unit_price      NUMERIC(10, 2)  NOT NULL CHECK (unit_price >= 0),
    discount        NUMERIC(10, 2)  NOT NULL DEFAULT 0,
    subtotal        NUMERIC(10, 2)  NOT NULL DEFAULT 0,

    -- Audit attributes
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ,
    deleted_at      TIMESTAMPTZ,
    created_by      UUID            REFERENCES "user"(id),
    updated_by      UUID            REFERENCES "user"(id),
    deleted_by      UUID            REFERENCES "user"(id),
    status          VARCHAR(20)     NOT NULL DEFAULT 'active'
);

-- -----------------------------------------------------------------------------
-- TABLE: payment
-- Payments applied to invoices
-- -----------------------------------------------------------------------------
CREATE TABLE payment (
    id                  UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_id          UUID            NOT NULL REFERENCES invoice(id),
    method_payment_id   UUID            NOT NULL REFERENCES method_payment(id),
    amount              NUMERIC(10, 2)  NOT NULL CHECK (amount > 0),
    payment_date        TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    reference           VARCHAR(255),   -- transaction/receipt reference
    notes               TEXT,

    -- Audit attributes
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ,
    deleted_at          TIMESTAMPTZ,
    created_by          UUID            REFERENCES "user"(id),
    updated_by          UUID            REFERENCES "user"(id),
    deleted_by          UUID            REFERENCES "user"(id),
    status              VARCHAR(20)     NOT NULL DEFAULT 'completed'
    -- status values: pending, completed, failed, refunded
);

-- =============================================================================
-- INDEXES - Performance optimization for frequent queries
-- =============================================================================

-- ── Module 2: Parameter ──────────────────────────────────────────────────────
CREATE INDEX idx_person_type_document    ON person(type_document_id);
CREATE INDEX idx_person_document_number  ON person(document_number);
CREATE INDEX idx_person_status           ON person(status);
CREATE INDEX idx_person_deleted_at       ON person(deleted_at);

CREATE INDEX idx_file_entity             ON file(entity_name, entity_id);
CREATE INDEX idx_file_status             ON file(status);

-- ── Module 1: Security ───────────────────────────────────────────────────────
CREATE INDEX idx_user_email              ON "user"(email);
CREATE INDEX idx_user_username           ON "user"(username);
CREATE INDEX idx_user_person_id          ON "user"(person_id);
CREATE INDEX idx_user_status             ON "user"(status);
CREATE INDEX idx_user_deleted_at         ON "user"(deleted_at);

CREATE INDEX idx_user_role_user_id       ON user_role(user_id);
CREATE INDEX idx_user_role_role_id       ON user_role(role_id);
CREATE INDEX idx_user_role_status        ON user_role(status);
CREATE INDEX idx_user_role_deleted_at    ON user_role(deleted_at);

CREATE INDEX idx_role_module_role_id     ON role_module(role_id);
CREATE INDEX idx_role_module_module_id   ON role_module(module_id);
CREATE INDEX idx_role_module_status      ON role_module(status);
CREATE INDEX idx_role_module_deleted_at  ON role_module(deleted_at);

CREATE INDEX idx_module_view_module_id   ON module_view(module_id);
CREATE INDEX idx_module_view_view_id     ON module_view(view_id);
CREATE INDEX idx_module_view_status      ON module_view(status);
CREATE INDEX idx_module_view_deleted_at  ON module_view(deleted_at);

-- ── Module 3: Inventory ──────────────────────────────────────────────────────
CREATE INDEX idx_product_category_id     ON product(category_id);
CREATE INDEX idx_product_supplier_id     ON product(supplier_id);
CREATE INDEX idx_product_sku             ON product(sku);
CREATE INDEX idx_product_status          ON product(status);
CREATE INDEX idx_product_deleted_at      ON product(deleted_at);

CREATE INDEX idx_inventory_product_id    ON inventory(product_id);
CREATE INDEX idx_inventory_status        ON inventory(status);

CREATE INDEX idx_supplier_person_id      ON supplier(person_id);
CREATE INDEX idx_supplier_status         ON supplier(status);

-- ── Module 4: Sales ──────────────────────────────────────────────────────────
CREATE INDEX idx_customer_person_id      ON customer(person_id);
CREATE INDEX idx_customer_status         ON customer(status);

CREATE INDEX idx_order_customer_id       ON "order"(customer_id);
CREATE INDEX idx_order_user_id           ON "order"(user_id);
CREATE INDEX idx_order_order_number      ON "order"(order_number);
CREATE INDEX idx_order_order_date        ON "order"(order_date);
CREATE INDEX idx_order_status            ON "order"(status);
CREATE INDEX idx_order_deleted_at        ON "order"(deleted_at);

CREATE INDEX idx_order_item_order_id     ON order_item(order_id);
CREATE INDEX idx_order_item_product_id   ON order_item(product_id);
CREATE INDEX idx_order_item_status       ON order_item(status);

-- ── Module 5: Billing ────────────────────────────────────────────────────────
CREATE INDEX idx_invoice_order_id        ON invoice(order_id);
CREATE INDEX idx_invoice_customer_id     ON invoice(customer_id);
CREATE INDEX idx_invoice_number          ON invoice(invoice_number);
CREATE INDEX idx_invoice_issue_date      ON invoice(issue_date);
CREATE INDEX idx_invoice_status          ON invoice(status);
CREATE INDEX idx_invoice_deleted_at      ON invoice(deleted_at);

CREATE INDEX idx_invoice_item_invoice_id ON invoice_item(invoice_id);
CREATE INDEX idx_invoice_item_product_id ON invoice_item(product_id);

CREATE INDEX idx_payment_invoice_id      ON payment(invoice_id);
CREATE INDEX idx_payment_method_id       ON payment(method_payment_id);
CREATE INDEX idx_payment_date            ON payment(payment_date);
CREATE INDEX idx_payment_status          ON payment(status);