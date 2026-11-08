CREATE TABLE owners (
    owner_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    owner_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE properties (
    property_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    owner_id INT NOT NULL,
    property_name VARCHAR(100) NOT NULL,
    property_type VARCHAR(30),
    address TEXT NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_property_owner
        FOREIGN KEY (owner_id)
        REFERENCES owners(owner_id)
);

CREATE TABLE units (
    unit_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    property_id INT NOT NULL,
    unit_number VARCHAR(20) NOT NULL,
    bedrooms INT DEFAULT 1,
    monthly_rent NUMERIC(12,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Vacant',

    CONSTRAINT fk_unit_property
        FOREIGN KEY (property_id)
        REFERENCES properties(property_id),

    CONSTRAINT uq_property_unit
        UNIQUE (property_id, unit_number),

    CONSTRAINT chk_unit_rent
        CHECK (monthly_rent > 0),

    CONSTRAINT chk_unit_status
        CHECK (status IN ('Vacant', 'Occupied', 'Maintenance'))
);

CREATE TABLE tenants (
    tenant_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tenant_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE leases (
    lease_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    unit_id INT NOT NULL,
    tenant_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    monthly_rent NUMERIC(12,2) NOT NULL,
    security_deposit NUMERIC(12,2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'Active',

    FOREIGN KEY (unit_id) REFERENCES units(unit_id),
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),

    CHECK (end_date >= start_date),
    CHECK (monthly_rent > 0),
    CHECK (security_deposit >= 0),
    CHECK (status IN ('Active', 'Expired', 'Terminated'))
);

CREATE TABLE rent_invoices (
    invoice_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    lease_id INT NOT NULL,
    billing_period DATE NOT NULL,
    total_amount NUMERIC(12,2) NOT NULL,
    paid_amount NUMERIC(12,2) DEFAULT 0,
    due_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Unpaid',

    FOREIGN KEY (lease_id) REFERENCES leases(lease_id),

    UNIQUE (lease_id, billing_period),

    CHECK (total_amount > 0),
    CHECK (paid_amount >= 0 AND paid_amount <= total_amount),
    CHECK (status IN ('Unpaid', 'Partial', 'Paid'))
);

CREATE TABLE payments (
    payment_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    invoice_id INT NOT NULL,
    amount NUMERIC(12,2) NOT NULL,
    payment_date DATE DEFAULT CURRENT_DATE,
    payment_method VARCHAR(30),
    transaction_reference VARCHAR(100) UNIQUE,

    FOREIGN KEY (invoice_id)
        REFERENCES rent_invoices(invoice_id),

    CHECK (amount > 0)
);

CREATE TABLE maintenance_requests (
    request_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    unit_id INT NOT NULL,
    tenant_id INT NOT NULL,
    description TEXT NOT NULL,
    priority VARCHAR(20) DEFAULT 'Medium',
    status VARCHAR(20) DEFAULT 'Pending',
    estimated_cost NUMERIC(12,2),
    request_date DATE DEFAULT CURRENT_DATE,
    completed_date DATE,

    FOREIGN KEY (unit_id) REFERENCES units(unit_id),
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),

    CHECK (priority IN ('Low', 'Medium', 'High', 'Urgent')),
    CHECK (status IN ('Pending', 'In Progress', 'Completed', 'Cancelled')),
    CHECK (estimated_cost IS NULL OR estimated_cost >= 0)
);
