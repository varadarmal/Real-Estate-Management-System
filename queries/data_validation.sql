-- Query 1: Check duplicate owner emails
SELECT
    email,
    COUNT(*) AS duplicate_count
FROM owners
GROUP BY email
HAVING COUNT(*) > 1;


-- Query 2: Check duplicate tenant emails
SELECT
    email,
    COUNT(*) AS duplicate_count
FROM tenants
GROUP BY email
HAVING COUNT(*) > 1;


-- Query 3: Find invalid lease date ranges
SELECT *
FROM leases
WHERE end_date < start_date;


-- Query 4: Find invoices with invalid payment amounts
SELECT *
FROM rent_invoices
WHERE paid_amount > total_amount
   OR paid_amount < 0;


-- Query 5: Find units with negative rent
SELECT *
FROM units
WHERE monthly_rent < 0;


-- Query 6: Find payments with non-positive amounts
SELECT *
FROM payments
WHERE amount <= 0;


-- Query 7: Check invoices with inconsistent payment status
SELECT *
FROM rent_invoices
WHERE
    (paid_amount = 0 AND status <> 'Unpaid')
    OR
    (paid_amount > 0 AND paid_amount < total_amount
        AND status <> 'Partial')
    OR
    (paid_amount = total_amount AND status <> 'Paid');
