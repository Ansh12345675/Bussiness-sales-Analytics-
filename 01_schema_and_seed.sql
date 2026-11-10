/*
    SQL Server demo database for the optional Power BI learning workflow.
    Safe to rerun: the database and table are created only when absent, and
    the small sample is inserted only when the table is empty.
*/
IF DB_ID(N'SalesAnalyticsDemo') IS NULL
BEGIN
    CREATE DATABASE SalesAnalyticsDemo;
END;
GO

USE SalesAnalyticsDemo;
GO

IF OBJECT_ID(N'dbo.Sales', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Sales
    (
        SalesID       int             NOT NULL,
        OrderID       varchar(20)     NOT NULL,
        OrderDate     date            NOT NULL,
        CustomerID    varchar(20)     NOT NULL,
        CustomerName  nvarchar(100)   NOT NULL,
        Segment       nvarchar(30)    NOT NULL,
        City          nvarchar(60)    NOT NULL,
        State         nvarchar(60)    NOT NULL,
        Region        nvarchar(30)    NOT NULL,
        ProductID     varchar(20)     NOT NULL,
        ProductName   nvarchar(100)   NOT NULL,
        Category      nvarchar(40)    NOT NULL,
        Quantity      int             NOT NULL,
        UnitPrice     decimal(12, 2)  NOT NULL,
        DiscountPct   decimal(5, 4)   NOT NULL,
        Revenue       decimal(12, 2)  NOT NULL,
        UnitCost      decimal(12, 2)  NOT NULL,
        Cost          decimal(12, 2)  NOT NULL,
        Profit        decimal(12, 2)  NOT NULL,
        PaymentMethod nvarchar(30)    NOT NULL,
        SalesChannel  nvarchar(30)    NOT NULL,
        CONSTRAINT PK_Sales PRIMARY KEY (SalesID),
        CONSTRAINT UQ_Sales_OrderID UNIQUE (OrderID),
        CONSTRAINT CK_Sales_Quantity CHECK (Quantity > 0),
        CONSTRAINT CK_Sales_DiscountPct CHECK (DiscountPct >= 0 AND DiscountPct < 1),
        CONSTRAINT CK_Sales_Amounts CHECK
            (UnitPrice >= 0 AND UnitCost >= 0 AND Revenue >= 0 AND Cost >= 0)
    );

    CREATE INDEX IX_Sales_OrderDate ON dbo.Sales (OrderDate);
    CREATE INDEX IX_Sales_CustomerID ON dbo.Sales (CustomerID);
    CREATE INDEX IX_Sales_Category ON dbo.Sales (Category);
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Sales)
BEGIN
    INSERT INTO dbo.Sales
    (
        SalesID, OrderID, OrderDate, CustomerID, CustomerName, Segment,
        City, State, Region, ProductID, ProductName, Category, Quantity,
        UnitPrice, DiscountPct, Revenue, UnitCost, Cost, Profit,
        PaymentMethod, SalesChannel
    )
    VALUES
        (1, 'ORD-2025-0001', '2025-01-08', 'CUST-001', N'Avery Johnson', N'Consumer', N'Austin', N'Texas', N'South', 'P-001', N'Wireless Mouse', N'Electronics', 2, 29.99, 0.0000, 59.98, 12.00, 24.00, 35.98, N'Credit Card', N'Online'),
        (2, 'ORD-2025-0002', '2025-01-12', 'CUST-002', N'Jordan Lee', N'Corporate', N'Seattle', N'Washington', N'West', 'P-005', N'Ergonomic Chair', N'Furniture', 1, 249.00, 0.1000, 224.10, 145.00, 145.00, 79.10, N'PayPal', N'Online'),
        (3, 'ORD-2025-0003', '2025-01-19', 'CUST-003', N'Taylor Morgan', N'Small Business', N'Denver', N'Colorado', N'West', 'P-009', N'Hardcover Notebook Set', N'Office Supplies', 3, 18.50, 0.0500, 52.73, 7.00, 21.00, 31.73, N'Debit Card', N'Retail'),
        (4, 'ORD-2025-0004', '2025-02-02', 'CUST-001', N'Avery Johnson', N'Consumer', N'Austin', N'Texas', N'South', 'P-003', N'USB-C Hub', N'Electronics', 1, 54.99, 0.0000, 54.99, 26.00, 26.00, 28.99, N'Credit Card', N'Online'),
        (5, 'ORD-2025-0005', '2025-02-11', 'CUST-004', N'Casey Patel', N'Consumer', N'Chicago', N'Illinois', N'Midwest', 'P-006', N'Compact Desk', N'Furniture', 1, 189.00, 0.1500, 160.65, 110.00, 110.00, 50.65, N'Credit Card', N'Retail'),
        (6, 'ORD-2025-0006', '2025-02-25', 'CUST-005', N'Riley Chen', N'Corporate', N'Boston', N'Massachusetts', N'Northeast', 'P-010', N'Gel Pen Pack', N'Office Supplies', 5, 8.99, 0.0000, 44.95, 2.50, 12.50, 32.45, N'Bank Transfer', N'Online'),
        (7, 'ORD-2025-0007', '2025-03-04', 'CUST-006', N'Morgan Brooks', N'Small Business', N'Phoenix', N'Arizona', N'West', 'P-002', N'Bluetooth Keyboard', N'Electronics', 2, 69.00, 0.0500, 131.10, 32.00, 64.00, 67.10, N'Debit Card', N'Online'),
        (8, 'ORD-2025-0008', '2025-03-14', 'CUST-002', N'Jordan Lee', N'Corporate', N'Seattle', N'Washington', N'West', 'P-007', N'LED Desk Lamp', N'Furniture', 2, 42.50, 0.0000, 85.00, 18.00, 36.00, 49.00, N'PayPal', N'Retail'),
        (9, 'ORD-2025-0009', '2025-03-22', 'CUST-007', N'Quinn Davis', N'Consumer', N'Miami', N'Florida', N'South', 'P-011', N'Printer Paper Ream', N'Office Supplies', 4, 12.25, 0.1000, 44.10, 5.00, 20.00, 24.10, N'Credit Card', N'Online'),
        (10, 'ORD-2025-0010', '2025-04-03', 'CUST-008', N'Jamie Rivera', N'Consumer', N'Portland', N'Oregon', N'West', 'P-004', N'Noise-Canceling Headphones', N'Electronics', 1, 129.99, 0.0500, 123.49, 72.00, 72.00, 51.49, N'Credit Card', N'Online'),
        (11, 'ORD-2025-0011', '2025-04-17', 'CUST-003', N'Taylor Morgan', N'Small Business', N'Denver', N'Colorado', N'West', 'P-008', N'Filing Cabinet', N'Furniture', 1, 159.00, 0.0000, 159.00, 98.00, 98.00, 61.00, N'Bank Transfer', N'Retail'),
        (12, 'ORD-2025-0012', '2025-05-06', 'CUST-009', N'Alex Kim', N'Corporate', N'New York', N'New York', N'Northeast', 'P-012', N'Wireless Mouse', N'Electronics', 3, 29.99, 0.1000, 80.97, 12.00, 36.00, 44.97, N'Credit Card', N'Online');
END;
GO

SELECT COUNT_BIG(*) AS SalesRowCount FROM dbo.Sales;
GO
