INSERT INTO owners (owner_name, email, phone)
VALUES
('Rahul Sharma', 'rahul@gmail.com', '9876543210'),
('Amit Patil', 'amit@gmail.com', '9876543211'),
('Sneha Deshmukh', 'sneha@gmail.com', '9876543212');

INSERT INTO properties
(owner_id, property_name, property_type, address, city, state)
VALUES
(1, 'Green Valley Apartments', 'Residential',
 'MG Road', 'Pune', 'Maharashtra'),

(1, 'Sunrise Residency', 'Residential',
 'Baner Road', 'Pune', 'Maharashtra'),

(2, 'Tech Park Plaza', 'Commercial',
 'Hinjewadi', 'Pune', 'Maharashtra'),

(3, 'Lake View Towers', 'Residential',
 'Gangapur Road', 'Nashik', 'Maharashtra');

INSERT INTO units
(property_id, unit_number, bedrooms, monthly_rent, status)
VALUES
(1, 'A101', 2, 18000, 'Occupied'),
(1, 'A102', 3, 25000, 'Occupied'),
(1, 'A103', 2, 20000, 'Vacant'),
(2, 'B101', 2, 22000, 'Occupied'),
(2, 'B102', 1, 15000, 'Vacant'),
(3, 'C101', 0, 50000, 'Occupied'),
(3, 'C102', 0, 45000, 'Vacant'),
(4, 'D101', 3, 28000, 'Occupied');

INSERT INTO tenants (tenant_name, email, phone)
VALUES
('Varad Armal', 'varad@gmail.com', '9000000001'),
('Vivek Sharma', 'vivek@gmail.com', '9000000002'),
('Krishna Patil', 'krishna@gmail.com', '9000000003'),
('Akshat Joshi', 'akshat@gmail.com', '9000000004'),
('Rohan Kulkarni', 'rohan@gmail.com', '9000000005');

INSERT INTO leases
(unit_id, tenant_id, start_date, end_date,
 monthly_rent, security_deposit, status)
VALUES
(1, 1, '2026-01-01', '2026-12-31', 18000, 36000, 'Active'),
(2, 2, '2026-03-01', '2027-02-28', 25000, 50000, 'Active'),
(4, 3, '2026-04-01', '2027-03-31', 22000, 44000, 'Active'),
(6, 4, '2026-01-01', '2026-12-31', 50000, 100000, 'Active'),
(8, 5, '2026-05-01', '2027-04-30', 28000, 56000, 'Active');

INSERT INTO maintenance_requests
(unit_id, tenant_id, description, priority, status, estimated_cost)
VALUES
(1, 1, 'Water leakage in bathroom', 'High', 'Pending', 2500),
(2, 2, 'Air conditioning repair', 'Medium', 'In Progress', 4000),
(4, 3, 'Electrical wiring issue', 'Urgent', 'Pending', 6000),
(6, 4, 'Office lighting replacement', 'Low', 'Completed', 1500);
