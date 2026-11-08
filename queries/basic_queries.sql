-- Query 1: Find all properties located in Pune
SELECT *
FROM properties
WHERE city = 'Pune';


-- Query 2: Find tenants paying more than ₹20,000 monthly
SELECT
    t.tenant_name,
    l.monthly_rent
FROM tenants t
JOIN leases l
    ON t.tenant_id = l.tenant_id
WHERE l.monthly_rent > 20000;


-- Query 3: Find total units in each property
SELECT
    p.property_name,
    COUNT(u.unit_id) AS total_units
FROM properties p
LEFT JOIN units u
    ON p.property_id = u.property_id
GROUP BY p.property_id, p.property_name;
