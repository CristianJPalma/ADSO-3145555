-- =============================================================================
-- DML (Seed data) - 5 rows per table
-- Notes:
-- - Uses fixed UUIDs to keep FK relationships consistent.
-- - Assumes the DDL was already executed.
-- - "user" and "order" are reserved words in PostgreSQL → quoted.
-- =============================================================================

BEGIN;

-- =============================================================================
-- MODULE 2: PARAMETER
-- =============================================================================

-- type_document (5)
INSERT INTO type_document (id, name, description, code, created_at, status) VALUES
('11111111-1111-1111-1111-111111111111', 'DNI', 'Documento Nacional de Identidad', 'DNI', NOW(), 'active'),
('11111111-1111-1111-1111-111111111112', 'Passport', 'Pasaporte', 'PASS', NOW(), 'active'),
('11111111-1111-1111-1111-111111111113', 'RUC', 'Registro Único de Contribuyentes', 'RUC', NOW(), 'active'),
('11111111-1111-1111-1111-111111111114', 'Driver License', 'Licencia de Conducir', 'DL', NOW(), 'active'),
('11111111-1111-1111-1111-111111111115', 'Other', 'Otro tipo de documento', 'OTHER', NOW(), 'active');

-- person (5)
INSERT INTO person (
  id, first_name, last_name, type_document_id, document_number, phone, address, birth_date,
  created_at, status
) VALUES
('22222222-2222-2222-2222-222222222221', 'Maria',  'Garcia',  '11111111-1111-1111-1111-111111111111', '12345678',  '+1-555-0101', '123 Main St', '1994-05-12', NOW(), 'active'),
('22222222-2222-2222-2222-222222222222', 'Juan',   'Perez',   '11111111-1111-1111-1111-111111111114', 'D-998877',  '+1-555-0102', '456 Oak Ave', '1990-11-03', NOW(), 'active'),
('22222222-2222-2222-2222-222222222223', 'Carlos', 'Mendoza','11111111-1111-1111-1111-111111111112', 'P1234567',  '+1-555-0103', '789 Pine Rd', '1988-02-20', NOW(), 'active'),
('22222222-2222-2222-2222-222222222224', 'Ana',    'Torres',  '11111111-1111-1111-1111-111111111111', '87654321',  '+1-555-0104', '321 Cedar St','1997-08-15', NOW(), 'active'),
('22222222-2222-2222-2222-222222222225', 'Laura',  'Smith',   '11111111-1111-1111-1111-111111111115', 'X-000111',  '+1-555-0105', '654 Elm Blvd','1992-01-30', NOW(), 'active');

-- file (5)
INSERT INTO file (
  id, name, original_name, mime_type, size, url, entity_name, entity_id,
  created_at, status
) VALUES
('33333333-3333-3333-3333-333333333331', 'profile_maria.jpg',  'maria.jpg',  'image/jpeg',        120345, 'https://cdn.coffee-shop.local/profile/maria.jpg',  'person', '22222222-2222-2222-2222-222222222221', NOW(), 'active'),
('33333333-3333-3333-3333-333333333332', 'profile_juan.jpg',   'juan.jpg',   'image/jpeg',        118002, 'https://cdn.coffee-shop.local/profile/juan.jpg',   'person', '22222222-2222-2222-2222-222222222222', NOW(), 'active'),
('33333333-3333-3333-3333-333333333333', 'contract_supplier.pdf','contract.pdf','application/pdf',  450120, 'https://cdn.coffee-shop.local/docs/contract.pdf',   'supplier', NULL,                               NOW(), 'active'),
('33333333-3333-3333-3333-333333333334', 'menu.pdf',           'menu_v1.pdf', 'application/pdf',   98211,  'https://cdn.coffee-shop.local/docs/menu.pdf',       'module', NULL,                                 NOW(), 'active'),
('33333333-3333-3333-3333-333333333335', 'product_espresso.png','espresso.png','image/png',        77331,  'https://cdn.coffee-shop.local/products/espresso.png','product', NULL,                               NOW(), 'active');

-- =============================================================================
-- MODULE 1: SECURITY
-- =============================================================================

-- role (5)
INSERT INTO role (id, name, description, created_at, status) VALUES
('44444444-4444-4444-4444-444444444441', 'Administrator', 'All permissions', NOW(), 'active'),
('44444444-4444-4444-4444-444444444442', 'Manager',       'Inventory + Sales', NOW(), 'active'),
('44444444-4444-4444-4444-444444444443', 'Cashier',       'Sales operations', NOW(), 'active'),
('44444444-4444-4444-4444-444444444444', 'Warehouse',     'Inventory operations', NOW(), 'active'),
('44444444-4444-4444-4444-444444444445', 'Auditor',       'Read-only audit access', NOW(), 'active');

-- module (5)
INSERT INTO module (id, name, description, icon, route, created_at, status) VALUES
('55555555-5555-5555-5555-555555555551', 'Security',   'Users, roles, permissions', 'shield',  '/security',   NOW(), 'active'),
('55555555-5555-5555-5555-555555555552', 'Inventory',  'Products and stock',        'boxes',   '/inventory',  NOW(), 'active'),
('55555555-5555-5555-5555-555555555553', 'Sales',      'Orders and customers',      'cart',    '/sales',      NOW(), 'active'),
('55555555-5555-5555-5555-555555555554', 'Billing',    'Invoices and payments',     'receipt', '/billing',    NOW(), 'active'),
('55555555-5555-5555-5555-555555555555', 'Reports',    'Dashboards and reports',    'chart',   '/reports',    NOW(), 'active');

-- view (5)
INSERT INTO view (id, name, description, route, created_at, status) VALUES
('66666666-6666-6666-6666-666666666661', 'User Management',    'Manage users',            '/security/users',        NOW(), 'active'),
('66666666-6666-6666-6666-666666666662', 'Role Management',    'Manage roles',            '/security/roles',        NOW(), 'active'),
('66666666-6666-6666-6666-666666666663', 'Product List',       'List products',           '/inventory/products',    NOW(), 'active'),
('66666666-6666-6666-6666-666666666664', 'Order Management',   'Manage orders',           '/sales/orders',          NOW(), 'active'),
('66666666-6666-6666-6666-666666666665', 'Invoice Management', 'Manage invoices',         '/billing/invoices',      NOW(), 'active');

-- user (5)
INSERT INTO "user" (
  id, username, email, password, person_id, created_at, status
) VALUES
('77777777-7777-7777-7777-777777777771', 'system.admin', 'admin@coffeeshop.com',  '$2b$10$hash_admin',  '22222222-2222-2222-2222-222222222221', NOW(), 'active'),
('77777777-7777-7777-7777-777777777772', 'maria.garcia', 'maria.garcia@coffeeshop.com', '$2b$10$hash_maria', '22222222-2222-2222-2222-222222222221', NOW(), 'active'),
('77777777-7777-7777-7777-777777777773', 'juan.perez',   'juan.perez@coffeeshop.com',   '$2b$10$hash_juan',  '22222222-2222-2222-2222-222222222222', NOW(), 'active'),
('77777777-7777-7777-7777-777777777774', 'carlos.m',     'carlos.mendoza@coffeeshop.com','$2b$10$hash_carlos','22222222-2222-2222-2222-222222222223', NOW(), 'active'),
('77777777-7777-7777-7777-777777777775', 'ana.torres',   'ana.torres@coffeeshop.com',   '$2b$10$hash_ana',   '22222222-2222-2222-2222-222222222224', NOW(), 'active');

-- user_role (5)
INSERT INTO user_role (id, user_id, role_id, created_at, created_by, status) VALUES
('88888888-8888-8888-8888-888888888881', '77777777-7777-7777-7777-777777777771', '44444444-4444-4444-4444-444444444441', NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('88888888-8888-8888-8888-888888888882', '77777777-7777-7777-7777-777777777772', '44444444-4444-4444-4444-444444444442', NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('88888888-8888-8888-8888-888888888883', '77777777-7777-7777-7777-777777777773', '44444444-4444-4444-4444-444444444443', NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('88888888-8888-8888-8888-888888888884', '77777777-7777-7777-7777-777777777774', '44444444-4444-4444-4444-444444444444', NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('88888888-8888-8888-8888-888888888885', '77777777-7777-7777-7777-777777777775', '44444444-4444-4444-4444-444444444445', NOW(), '77777777-7777-7777-7777-777777777771', 'active');

-- role_module (5)
INSERT INTO role_module (id, role_id, module_id, created_at, created_by, status) VALUES
('99999999-9999-9999-9999-999999999991', '44444444-4444-4444-4444-444444444441', '55555555-5555-5555-5555-555555555551', NOW(), '77777777-7777-7777-7777-777777777771', 'active'), -- Admin → Security
('99999999-9999-9999-9999-999999999992', '44444444-4444-4444-4444-444444444441', '55555555-5555-5555-5555-555555555552', NOW(), '77777777-7777-7777-7777-777777777771', 'active'), -- Admin → Inventory
('99999999-9999-9999-9999-999999999993', '44444444-4444-4444-4444-444444444442', '55555555-5555-5555-5555-555555555552', NOW(), '77777777-7777-7777-7777-777777777771', 'active'), -- Manager → Inventory
('99999999-9999-9999-9999-999999999994', '44444444-4444-4444-4444-444444444442', '55555555-5555-5555-5555-555555555553', NOW(), '77777777-7777-7777-7777-777777777771', 'active'), -- Manager → Sales
('99999999-9999-9999-9999-999999999995', '44444444-4444-4444-4444-444444444443', '55555555-5555-5555-5555-555555555553', NOW(), '77777777-7777-7777-7777-777777777771', 'active'); -- Cashier → Sales

-- module_view (5)
INSERT INTO module_view (id, module_id, view_id, created_at, created_by, status) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '55555555-5555-5555-5555-555555555551', '66666666-6666-6666-6666-666666666661', NOW(), '77777777-7777-7777-7777-777777777771', 'active'), -- Security → Users
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '55555555-5555-5555-5555-555555555551', '66666666-6666-6666-6666-666666666662', NOW(), '77777777-7777-7777-7777-777777777771', 'active'), -- Security → Roles
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3', '55555555-5555-5555-5555-555555555552', '66666666-6666-6666-6666-666666666663', NOW(), '77777777-7777-7777-7777-777777777771', 'active'), -- Inventory → Products
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa4', '55555555-5555-5555-5555-555555555553', '66666666-6666-6666-6666-666666666664', NOW(), '77777777-7777-7777-7777-777777777771', 'active'), -- Sales → Orders
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa5', '55555555-5555-5555-5555-555555555554', '66666666-6666-6666-6666-666666666665', NOW(), '77777777-7777-7777-7777-777777777771', 'active'); -- Billing → Invoices

-- =============================================================================
-- MODULE 3: INVENTORY
-- =============================================================================

-- category (5)
INSERT INTO category (id, name, description, icon, created_at, created_by, status) VALUES
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1', 'Coffee',      'Coffee beverages', 'coffee', NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2', 'Tea',         'Tea beverages',    'tea',    NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb3', 'Bakery',      'Baked goods',      'bread',  NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb4', 'Sandwiches',  'Sandwiches',       'food',   NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb5', 'Merch',       'Merchandise',      'bag',    NOW(), '77777777-7777-7777-7777-777777777771', 'active');

-- supplier (5)
INSERT INTO supplier (
  id, person_id, company_name, email, phone, address, created_at, created_by, status
) VALUES
('cccccccc-cccc-cccc-cccc-ccccccccccc1', '22222222-2222-2222-2222-222222222225', 'Andes Coffee Beans', 'sales@andesbeans.com', '+1-555-0201', '100 Supplier Way', NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('cccccccc-cccc-cccc-cccc-ccccccccccc2', '22222222-2222-2222-2222-222222222224', 'Green Tea Importers','hello@greentea.com',  '+1-555-0202', '200 Supplier Way', NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('cccccccc-cccc-cccc-cccc-ccccccccccc3', '22222222-2222-2222-2222-222222222223', 'Bakery Partners',    'contact@bakery.com',   '+1-555-0203', '300 Supplier Way', NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('cccccccc-cccc-cccc-cccc-ccccccccccc4', '22222222-2222-2222-2222-222222222222', 'Fresh Foods Co',     'ops@freshfoods.com',    '+1-555-0204', '400 Supplier Way', NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('cccccccc-cccc-cccc-cccc-ccccccccccc5', '22222222-2222-2222-2222-222222222221', 'Coffee Merch Inc',   'merch@coffeemerch.com', '+1-555-0205', '500 Supplier Way', NOW(), '77777777-7777-7777-7777-777777777771', 'active');

-- product (5)
INSERT INTO product (
  id, category_id, supplier_id, name, description, price, cost, sku, image_url,
  created_at, created_by, status
) VALUES
('dddddddd-dddd-dddd-dddd-ddddddddddd1', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1', 'cccccccc-cccc-cccc-cccc-ccccccccccc1',
 'Espresso', 'Single shot espresso', 2.50, 0.60, 'COF-ESP-001', 'https://cdn.coffee-shop.local/products/espresso.png', NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('dddddddd-dddd-dddd-dddd-ddddddddddd2', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1', 'cccccccc-cccc-cccc-cccc-ccccccccccc1',
 'Latte', 'Milk + espresso', 4.50, 1.20, 'COF-LAT-001', NULL, NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('dddddddd-dddd-dddd-dddd-ddddddddddd3', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2', 'cccccccc-cccc-cccc-cccc-ccccccccccc2',
 'Green Tea', 'Hot green tea', 3.00, 0.80, 'TEA-GRN-001', NULL, NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('dddddddd-dddd-dddd-dddd-ddddddddddd4', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb3', 'cccccccc-cccc-cccc-cccc-ccccccccccc3',
 'Croissant', 'Butter croissant', 3.25, 0.90, 'BAK-CRO-001', NULL, NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('dddddddd-dddd-dddd-dddd-ddddddddddd5', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb5', 'cccccccc-cccc-cccc-cccc-ccccccccccc5',
 'Coffee Mug', 'Branded mug 12oz', 12.00, 4.00, 'MER-MUG-001', NULL, NOW(), '77777777-7777-7777-7777-777777777771', 'active');

-- inventory (5)
INSERT INTO inventory (
  id, product_id, quantity, min_stock, max_stock, unit,
  created_at, created_by, status
) VALUES
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee1', 'dddddddd-dddd-dddd-dddd-ddddddddddd1', 120, 20, 500, 'units', NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee2', 'dddddddd-dddd-dddd-dddd-ddddddddddd2',  80, 15, 300, 'units', NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee3', 'dddddddd-dddd-dddd-dddd-ddddddddddd3',  60, 10, 200, 'units', NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4', 'dddddddd-dddd-dddd-dddd-ddddddddddd4',  40, 10, 150, 'units', NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee5', 'dddddddd-dddd-dddd-dddd-ddddddddddd5',  25,  5, 100, 'units', NOW(), '77777777-7777-7777-7777-777777777771', 'active');

-- =============================================================================
-- MODULE 4: SALES (+ Method_payment)
-- =============================================================================

-- customer (5)
INSERT INTO customer (
  id, person_id, loyalty_points, notes, created_at, created_by, status
) VALUES
('ffffffff-ffff-ffff-ffff-fffffffffff1', '22222222-2222-2222-2222-222222222221', 120, 'Frequent customer', NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('ffffffff-ffff-ffff-ffff-fffffffffff2', '22222222-2222-2222-2222-222222222222',  45, NULL,               NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('ffffffff-ffff-ffff-ffff-fffffffffff3', '22222222-2222-2222-2222-222222222223',  10, NULL,               NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('ffffffff-ffff-ffff-ffff-fffffffffff4', '22222222-2222-2222-2222-222222222224',   0, 'New customer',       NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('ffffffff-ffff-ffff-ffff-fffffffffff5', '22222222-2222-2222-2222-222222222225', 300, 'VIP',                NOW(), '77777777-7777-7777-7777-777777777771', 'active');

-- method_payment (5)
INSERT INTO method_payment (id, name, description, created_at, created_by, status) VALUES
('12121212-1212-1212-1212-121212121211', 'Cash',        'Cash payment', NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('12121212-1212-1212-1212-121212121212', 'Credit Card', 'Visa/Mastercard', NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('12121212-1212-1212-1212-121212121213', 'Debit Card',  'Debit payment', NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('12121212-1212-1212-1212-121212121214', 'QR',          'QR code payment', NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('12121212-1212-1212-1212-121212121215', 'Transfer',    'Bank transfer', NOW(), '77777777-7777-7777-7777-777777777771', 'active');

-- "order" (5)
INSERT INTO "order" (
  id, customer_id, user_id, order_number, order_date, subtotal, tax, discount, total, notes,
  created_at, created_by, status
) VALUES
('13131313-1313-1313-1313-131313131311', 'ffffffff-ffff-ffff-ffff-fffffffffff1', '77777777-7777-7777-7777-777777777773',
 'ORD-0001', NOW() - INTERVAL '4 days',  7.00, 0.70, 0.00,  7.70, NULL, NOW(), '77777777-7777-7777-7777-777777777771', 'completed'),
('13131313-1313-1313-1313-131313131312', 'ffffffff-ffff-ffff-ffff-fffffffffff2', '77777777-7777-7777-7777-777777777773',
 'ORD-0002', NOW() - INTERVAL '3 days',  4.50, 0.45, 0.00,  4.95, NULL, NOW(), '77777777-7777-7777-7777-777777777771', 'completed'),
('13131313-1313-1313-1313-131313131313', 'ffffffff-ffff-ffff-ffff-fffffffffff3', '77777777-7777-7777-7777-777777777772',
 'ORD-0003', NOW() - INTERVAL '2 days',  3.25, 0.33, 0.25,  3.33, 'Promo applied', NOW(), '77777777-7777-7777-7777-777777777771', 'completed'),
('13131313-1313-1313-1313-131313131314', NULL,                                    '77777777-7777-7777-7777-777777777772',
 'ORD-0004', NOW() - INTERVAL '1 days', 12.00, 1.20, 0.00, 13.20, 'Walk-in', NOW(), '77777777-7777-7777-7777-777777777771', 'completed'),
('13131313-1313-1313-1313-131313131315', 'ffffffff-ffff-ffff-ffff-fffffffffff5', '77777777-7777-7777-7777-777777777773',
 'ORD-0005', NOW(),                     9.00, 0.90, 1.00,  8.90, 'VIP discount', NOW(), '77777777-7777-7777-7777-777777777771', 'pending');

-- order_item (5)
INSERT INTO order_item (
  id, order_id, product_id, quantity, unit_price, discount, subtotal, notes,
  created_at, created_by, status
) VALUES
('14141414-1414-1414-1414-141414141411', '13131313-1313-1313-1313-131313131311', 'dddddddd-dddd-dddd-dddd-ddddddddddd1', 2, 2.50, 0.00, 5.00, NULL, NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('14141414-1414-1414-1414-141414141412', '13131313-1313-1313-1313-131313131311', 'dddddddd-dddd-dddd-dddd-ddddddddddd4', 1, 3.25, 0.00, 3.25, NULL, NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('14141414-1414-1414-1414-141414141413', '13131313-1313-1313-1313-131313131312', 'dddddddd-dddd-dddd-dddd-ddddddddddd2', 1, 4.50, 0.00, 4.50, NULL, NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('14141414-1414-1414-1414-141414141414', '13131313-1313-1313-1313-131313131313', 'dddddddd-dddd-dddd-dddd-ddddddddddd4', 1, 3.25, 0.25, 3.00, 'Coupon', NOW(), '77777777-7777-7777-7777-777777777771', 'active'),
('14141414-1414-1414-1414-141414141415', '13131313-1313-1313-1313-131313131315', 'dddddddd-dddd-dddd-dddd-ddddddddddd3', 2, 3.00, 0.00, 6.00, NULL, NOW(), '77777777-7777-7777-7777-777777777771', 'active');

INSERT INTO invoice (
  id, order_id, customer_id, invoice_number, issue_date, due_date,
  subtotal, tax, discount, total, notes,
  created_at, created_by, status
) VALUES
('15151515-1515-1515-1515-151515151511', '13131313-1313-1313-1313-131313131311', 'ffffffff-ffff-ffff-ffff-fffffffffff1',
 'INV-0001', NOW() - INTERVAL '4 days', NOW() - INTERVAL '3 days', 7.00, 0.70, 0.00, 7.70, NULL,
 NOW(), '77777777-7777-7777-7777-777777777771', 'paid'),

('15151515-1515-1515-1515-151515151512', '13131313-1313-1313-1313-131313131312', 'ffffffff-ffff-ffff-ffff-fffffffffff2',
 'INV-0002', NOW() - INTERVAL '3 days', NOW() - INTERVAL '2 days', 4.50, 0.45, 0.00, 4.95, NULL,
 NOW(), '77777777-7777-7777-7777-777777777771', 'paid'),

('15151515-1515-1515-1515-151515151513', '13131313-1313-1313-1313-131313131313', 'ffffffff-ffff-ffff-ffff-fffffffffff3',
 'INV-0003', NOW() - INTERVAL '2 days', NOW() - INTERVAL '1 days', 3.25, 0.33, 0.25, 3.33, 'Promo applied',
 NOW(), '77777777-7777-7777-7777-777777777771', 'paid'),

('15151515-1515-1515-1515-151515151514', '13131313-1313-1313-1313-131313131314', NULL,
 'INV-0004', NOW() - INTERVAL '1 days', NOW(), 12.00, 1.20, 0.00, 13.20, 'Walk-in',
 NOW(), '77777777-7777-7777-7777-777777777771', 'paid'),

('15151515-1515-1515-1515-151515151515', '13131313-1313-1313-1313-131313131315', 'ffffffff-ffff-ffff-ffff-fffffffffff5',
 'INV-0005', NOW(), NOW() + INTERVAL '7 days', 9.00, 0.90, 1.00, 8.90, 'VIP discount',
 NOW(), '77777777-7777-7777-7777-777777777771', 'issued');

-- invoice_item (5)
INSERT INTO invoice_item (
  id, invoice_id, product_id, description, quantity, unit_price, discount, subtotal,
  created_at, created_by, status
) VALUES
('16161616-1616-1616-1616-161616161611', '15151515-1515-1515-1515-151515151511', 'dddddddd-dddd-dddd-dddd-ddddddddddd1',
 'Espresso', 2, 2.50, 0.00, 5.00, NOW(), '77777777-7777-7777-7777-777777777771', 'active'),

('16161616-1616-1616-1616-161616161612', '15151515-1515-1515-1515-151515151511', 'dddddddd-dddd-dddd-dddd-ddddddddddd4',
 'Croissant', 1, 3.25, 0.00, 3.25, NOW(), '77777777-7777-7777-7777-777777777771', 'active'),

('16161616-1616-1616-1616-161616161613', '15151515-1515-1515-1515-151515151512', 'dddddddd-dddd-dddd-dddd-ddddddddddd2',
 'Latte', 1, 4.50, 0.00, 4.50, NOW(), '77777777-7777-7777-7777-777777777771', 'active'),

('16161616-1616-1616-1616-161616161614', '15151515-1515-1515-1515-151515151513', 'dddddddd-dddd-dddd-dddd-ddddddddddd4',
 'Croissant (coupon)', 1, 3.25, 0.25, 3.00, NOW(), '77777777-7777-7777-7777-777777777771', 'active'),

('16161616-1616-1616-1616-161616161615', '15151515-1515-1515-1515-151515151515', 'dddddddd-dddd-dddd-dddd-ddddddddddd3',
 'Green Tea', 2, 3.00, 0.00, 6.00, NOW(), '77777777-7777-7777-7777-777777777771', 'active');

-- payment (5)
INSERT INTO payment (
  id, invoice_id, method_payment_id, amount, payment_date, reference, notes,
  created_at, created_by, status
) VALUES
('17171717-1717-1717-1717-171717171711', '15151515-1515-1515-1515-151515151511', '12121212-1212-1212-1212-121212121211',
 7.70, NOW() - INTERVAL '4 days', 'CASH-0001', NULL, NOW(), '77777777-7777-7777-7777-777777777771', 'completed'),

('17171717-1717-1717-1717-171717171712', '15151515-1515-1515-1515-151515151512', '12121212-1212-1212-1212-121212121212',
 4.95, NOW() - INTERVAL '3 days', 'CC-0002', 'VISA', NOW(), '77777777-7777-7777-7777-777777777771', 'completed'),

('17171717-1717-1717-1717-171717171713', '15151515-1515-1515-1515-151515151513', '12121212-1212-1212-1212-121212121214',
 3.33, NOW() - INTERVAL '2 days', 'QR-0003', NULL, NOW(), '77777777-7777-7777-7777-777777777771', 'completed'),

('17171717-1717-1717-1717-171717171714', '15151515-1515-1515-1515-151515151514', '12121212-1212-1212-1212-121212121213',
 13.20, NOW() - INTERVAL '1 days', 'DC-0004', NULL, NOW(), '77777777-7777-7777-7777-777777777771', 'completed'),

('17171717-1717-1717-1717-171717171715', '15151515-1515-1515-1515-151515151515', '12121212-1212-1212-1212-121212121215',
 8.90, NOW(), 'TR-0005', 'Pending bank confirmation', NOW(), '77777777-7777-7777-7777-777777777771', 'pending');

COMMIT;