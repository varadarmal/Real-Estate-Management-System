CREATE OR REPLACE FUNCTION update_invoice_payment_status()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_invoice_id INT;
    v_total_paid NUMERIC(12,2);
BEGIN

    IF TG_OP = 'DELETE' THEN
        v_invoice_id := OLD.invoice_id;
    ELSE
        v_invoice_id := NEW.invoice_id;
    END IF;

    SELECT COALESCE(SUM(amount), 0)
    INTO v_total_paid
    FROM payments
    WHERE invoice_id = v_invoice_id;

    UPDATE rent_invoices
    SET
        paid_amount = v_total_paid,
        status = CASE
            WHEN v_total_paid = 0 THEN 'Unpaid'
            WHEN v_total_paid < total_amount THEN 'Partial'
            ELSE 'Paid'
        END
    WHERE invoice_id = v_invoice_id;

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;

    RETURN NEW;

END;
$$;

CREATE TRIGGER trg_update_invoice_status
AFTER INSERT OR UPDATE OR DELETE
ON payments
FOR EACH ROW
EXECUTE FUNCTION update_invoice_payment_status();

INSERT INTO payments
(invoice_id, amount, payment_method, transaction_reference)
VALUES
(2, 10000, 'UPI', 'TXN1002');

SELECT *
FROM rent_invoices;

CREATE OR REPLACE FUNCTION update_unit_occupancy()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    IF TG_OP = 'INSERT' THEN

        UPDATE units
        SET status = 'Occupied'
        WHERE unit_id = NEW.unit_id;

    ELSIF TG_OP = 'UPDATE' THEN

        IF OLD.unit_id <> NEW.unit_id THEN
            UPDATE units
            SET status = 'Vacant'
            WHERE unit_id = OLD.unit_id;

            UPDATE units
            SET status = 'Occupied'
            WHERE unit_id = NEW.unit_id;
        END IF;

    ELSIF TG_OP = 'DELETE' THEN

        UPDATE units
        SET status = 'Vacant'
        WHERE unit_id = OLD.unit_id;

    END IF;

    RETURN COALESCE(NEW, OLD);

END;
$$;

CREATE TRIGGER trg_update_unit_occupancy
AFTER INSERT OR UPDATE OR DELETE
ON leases
FOR EACH ROW
EXECUTE FUNCTION update_unit_occupancy();

ALTER TABLE properties
ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

CREATE OR REPLACE FUNCTION update_modified_time()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    NEW.updated_at = CURRENT_TIMESTAMP;

    RETURN NEW;

END;
$$;

CREATE TRIGGER trg_property_updated_at
BEFORE UPDATE
ON properties
FOR EACH ROW
EXECUTE FUNCTION update_modified_time();

UPDATE properties
SET city = 'Mumbai'
WHERE property_id = 1;

SELECT property_name, city, updated_at
FROM properties;
