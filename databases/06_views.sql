CREATE OR REPLACE VIEW property_tenant_details AS
SELECT
    p.property_name,
    p.city,
    u.unit_number,
    t.tenant_name,
    l.monthly_rent,
    l.start_date,
    l.end_date
FROM properties p
JOIN units u
    ON p.property_id = u.property_id
JOIN leases l
    ON u.unit_id = l.unit_id
JOIN tenants t
    ON l.tenant_id = t.tenant_id;

SELECT * FROM property_tenant_details;

CREATE OR REPLACE VIEW outstanding_rent_report AS
SELECT
    i.invoice_id,
    t.tenant_name,
    p.property_name,
    u.unit_number,
    i.total_amount,
    i.paid_amount,
    i.total_amount - i.paid_amount AS outstanding_amount,
    i.due_date,
    CASE
        WHEN i.paid_amount = i.total_amount THEN 'Paid'
        WHEN i.due_date < CURRENT_DATE THEN 'Overdue'
        ELSE 'Pending'
    END AS payment_status
FROM rent_invoices i
JOIN leases l
    ON i.lease_id = l.lease_id
JOIN tenants t
    ON l.tenant_id = t.tenant_id
JOIN units u
    ON l.unit_id = u.unit_id
JOIN properties p
    ON u.property_id = p.property_id
WHERE i.paid_amount < i.total_amount;

SELECT *
FROM outstanding_rent_report;

CREATE OR REPLACE VIEW property_occupancy_report AS
SELECT
    p.property_id,
    p.property_name,
    p.city,

    COUNT(u.unit_id) AS total_units,

    COUNT(u.unit_id) FILTER (
        WHERE u.status = 'Occupied'
    ) AS occupied_units,

    COUNT(u.unit_id) FILTER (
        WHERE u.status = 'Vacant'
    ) AS vacant_units,

    ROUND(
        COUNT(u.unit_id) FILTER (
            WHERE u.status = 'Occupied'
        ) * 100.0 /
        NULLIF(COUNT(u.unit_id), 0),
        2
    ) AS occupancy_percentage

FROM properties p
LEFT JOIN units u
    ON p.property_id = u.property_id
GROUP BY
    p.property_id,
    p.property_name,
    p.city;

SELECT *
FROM property_occupancy_report;
