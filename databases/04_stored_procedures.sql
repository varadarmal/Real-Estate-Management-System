CREATE OR REPLACE PROCEDURE generate_monthly_invoices(
    p_billing_period DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_first_day DATE;
    v_last_day DATE;
BEGIN
    v_first_day :=
        DATE_TRUNC('month', p_billing_period)::DATE;

    v_last_day :=
        (v_first_day + INTERVAL '1 month - 1 day')::DATE;

    INSERT INTO rent_invoices
    (
        lease_id,
        billing_period,
        total_amount,
        due_date
    )
    SELECT
        lease_id,
        v_first_day,
        monthly_rent,
        v_first_day + 4
    FROM leases
    WHERE start_date <= v_last_day
      AND end_date >= v_first_day
      AND status <> 'Terminated'
    ON CONFLICT (lease_id, billing_period)
    DO NOTHING;

    RAISE NOTICE 'Monthly invoices generated successfully';

END;
$$;

CALL generate_monthly_invoices('2026-10-01');

CREATE OR REPLACE PROCEDURE record_payment(
    p_invoice_id INT,
    p_amount NUMERIC,
    p_method VARCHAR,
    p_reference VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN

    IF p_amount <= 0 THEN
        RAISE EXCEPTION 'Payment amount must be positive';
    END IF;

    INSERT INTO payments
    (
        invoice_id,
        amount,
        payment_date,
        payment_method,
        transaction_reference
    )
    VALUES
    (
        p_invoice_id,
        p_amount,
        CURRENT_DATE,
        p_method,
        p_reference
    );

    RAISE NOTICE 'Payment recorded successfully';

END;
$$;

CALL record_payment(
    1,
    18000,
    'UPI',
    'TXN1001'
);
