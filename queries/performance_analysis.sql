-- Query 1: Analyze tenant-based lease search
EXPLAIN ANALYZE
SELECT *
FROM leases
WHERE tenant_id = 1;


-- Query 2: Analyze property and unit join
EXPLAIN ANALYZE
SELECT
    p.property_name,
    u.unit_number,
    u.monthly_rent
FROM properties p
JOIN units u
    ON p.property_id = u.property_id
WHERE p.city = 'Pune';


-- Query 3: Analyze invoice collection report
EXPLAIN ANALYZE
SELECT
    lease_id,
    SUM(paid_amount) AS total_collection
FROM rent_invoices
GROUP BY lease_id;


-- Query 4: Analyze unpaid invoices
EXPLAIN ANALYZE
SELECT *
FROM rent_invoices
WHERE status = 'Unpaid';
