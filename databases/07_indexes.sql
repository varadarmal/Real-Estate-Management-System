-- 1. Properties by owner
CREATE INDEX IF NOT EXISTS idx_properties_owner
ON properties(owner_id);

-- 2. Units by property
CREATE INDEX IF NOT EXISTS idx_units_property
ON units(property_id);

-- 3. Leases by tenant
CREATE INDEX IF NOT EXISTS idx_leases_tenant
ON leases(tenant_id);

-- 4. Leases by unit
CREATE INDEX IF NOT EXISTS idx_leases_unit
ON leases(unit_id);

-- 5. Payments by invoice
CREATE INDEX IF NOT EXISTS idx_payments_invoice
ON payments(invoice_id);
