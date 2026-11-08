-- Query 4: Find tenants who have not paid complete rent
SELECT DISTINCT
    t.tenant_name,
    i.total_amount,
    i.paid_amount
FROM tenants t
JOIN leases l
    ON t.tenant_id = l.tenant_id
JOIN rent_invoices i
    ON l.lease_id = i.lease_id
WHERE i.paid_amount < i.total_amount;


-- Query 5: Find properties generating the highest rental income
SELECT
    p.property_name,
    SUM(i.paid_amount) AS total_collection
FROM properties p
JOIN units u
    ON p.property_id = u.property_id
JOIN leases l
    ON u.unit_id = l.unit_id
JOIN rent_invoices i
    ON l.lease_id = i.lease_id
GROUP BY p.property_id, p.property_name
ORDER BY total_collection DESC;


-- Query 6: Find properties whose rental income is above average
SELECT
    p.property_name,
    SUM(i.paid_amount) AS income
FROM properties p
JOIN units u ON p.property_id = u.property_id
JOIN leases l ON u.unit_id = l.unit_id
JOIN rent_invoices i ON l.lease_id = i.lease_id
GROUP BY p.property_id, p.property_name
HAVING SUM(i.paid_amount) >
(
    SELECT AVG(property_income)
    FROM
    (
        SELECT SUM(i2.paid_amount) AS property_income
        FROM properties p2
        JOIN units u2 ON p2.property_id = u2.property_id
        JOIN leases l2 ON u2.unit_id = l2.unit_id
        JOIN rent_invoices i2 ON l2.lease_id = i2.lease_id
        GROUP BY p2.property_id
    ) AS income_data
);
