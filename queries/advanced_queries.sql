-- Query 7: Rank properties by rental income
SELECT
    property_name,
    total_income,
    RANK() OVER (
        ORDER BY total_income DESC
    ) AS income_rank
FROM
(
    SELECT
        p.property_name,
        SUM(i.paid_amount) AS total_income
    FROM properties p
    JOIN units u ON p.property_id = u.property_id
    JOIN leases l ON u.unit_id = l.unit_id
    JOIN rent_invoices i ON l.lease_id = i.lease_id
    GROUP BY p.property_id, p.property_name
) AS property_income;


-- Query 8: Find the second-highest monthly rent
SELECT DISTINCT monthly_rent
FROM
(
    SELECT
        monthly_rent,
        DENSE_RANK() OVER (
            ORDER BY monthly_rent DESC
        ) AS rent_rank
    FROM leases
) AS ranked_rents
WHERE rent_rank = 2;


-- Query 9: Find leases expiring in the next 60 days
SELECT
    t.tenant_name,
    p.property_name,
    l.end_date
FROM leases l
JOIN tenants t ON l.tenant_id = t.tenant_id
JOIN units u ON l.unit_id = u.unit_id
JOIN properties p ON u.property_id = p.property_id
WHERE l.status = 'Active'
AND l.end_date BETWEEN CURRENT_DATE
                   AND CURRENT_DATE + 60
ORDER BY l.end_date;


-- Query 10: Calculate month-over-month rental collections
WITH monthly_revenue AS
(
    SELECT
        DATE_TRUNC('month', i.billing_period)::DATE AS month,
        SUM(i.paid_amount) AS revenue
    FROM rent_invoices i
    GROUP BY DATE_TRUNC('month', i.billing_period)
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (
        ORDER BY month
    ) AS previous_month_revenue,
    revenue - LAG(revenue) OVER (
        ORDER BY month
    ) AS revenue_difference
FROM monthly_revenue
ORDER BY month;
