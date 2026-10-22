-- ==============================================================================
-- Migration: Add Foreign Keys Where Needed to BoxFactory Database
-- ==============================================================================

-- 1. Create Suppliers Table if not exists
IF OBJECT_ID('dbo.Suppliers', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Suppliers (
        SupplierId          INT IDENTITY(1,1)   NOT NULL,
        SupplierCode        VARCHAR(20)         NOT NULL UNIQUE,
        SupplierName        NVARCHAR(150)       NOT NULL UNIQUE,
        ContactPerson       NVARCHAR(100)       NULL,
        Email               NVARCHAR(120)       NULL,
        Phone               NVARCHAR(50)        NULL,
        Address             NVARCHAR(255)       NULL,
        City                NVARCHAR(100)       NULL,
        CreatedAt           DATETIME2           NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT PK_Suppliers PRIMARY KEY CLUSTERED (SupplierId)
    );

    INSERT INTO dbo.Suppliers (SupplierCode, SupplierName, ContactPerson, Email, Phone, Address, City)
    VALUES
        ('SUP-001', N'NorthPaper Ltd', N'A. Verma',     N'sales@northpaper.com',   N'+91 11 2345 6789', N'Phase II Industrial Area', N'New Delhi'),
        ('SUP-002', N'FlyteCo',         N'R. Mehta',     N'contact@flyteco.in',     N'+91 22 8765 4321', N'Turbhe MIDC',             N'Navi Mumbai'),
        ('SUP-003', N'BoralChem',       N'K. Singhania', N'orders@boralchem.com',   N'+91 79 3456 7890', N'Vatva GIDC',              N'Ahmedabad'),
        ('SUP-004', N'CareInk Co',      N'S. Nair',      N'support@careink.co.in',  N'+91 44 4567 8901', N'Guindy Industrial Estate', N'Chennai'),
        ('SUP-005', N'CustTech',        N'P. Deshmukh',  N'info@custtech.in',       N'+91 20 6789 0123', N'Chakan MIDC',             N'Pune');
    PRINT 'Suppliers table created and seeded.';
END
GO

-- 2. Add SupplierId and Foreign Key to RawMaterials
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'RawMaterials' AND COLUMN_NAME = 'SupplierId')
BEGIN
    ALTER TABLE dbo.RawMaterials ADD SupplierId INT NULL;
    PRINT 'Added SupplierId column to RawMaterials.';
END
GO

UPDATE rm
SET rm.SupplierId = s.SupplierId
FROM dbo.RawMaterials rm
INNER JOIN dbo.Suppliers s ON rm.Supplier = s.SupplierName
WHERE rm.SupplierId IS NULL;
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_RawMaterials_Suppliers')
BEGIN
    ALTER TABLE dbo.RawMaterials
    ADD CONSTRAINT FK_RawMaterials_Suppliers
    FOREIGN KEY (SupplierId) REFERENCES dbo.Suppliers(SupplierId)
    ON UPDATE CASCADE ON DELETE SET NULL;
    PRINT 'Added FK_RawMaterials_Suppliers.';
END
GO

-- 3. Add CustomerId and OrderId and Foreign Keys to FinishedStock
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'FinishedStock' AND COLUMN_NAME = 'CustomerId')
BEGIN
    ALTER TABLE dbo.FinishedStock ADD CustomerId VARCHAR(20) NULL;
    PRINT 'Added CustomerId column to FinishedStock.';
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'FinishedStock' AND COLUMN_NAME = 'OrderId')
BEGIN
    ALTER TABLE dbo.FinishedStock ADD OrderId VARCHAR(20) NULL;
    PRINT 'Added OrderId column to FinishedStock.';
END
GO

UPDATE dbo.FinishedStock SET CustomerId = 'CUST-001', OrderId = 'ORD-1041' WHERE ItemCode = 'FIN-501';
UPDATE dbo.FinishedStock SET CustomerId = 'CUST-002', OrderId = 'ORD-1040' WHERE ItemCode = 'FIN-302';
UPDATE dbo.FinishedStock SET CustomerId = 'CUST-004', OrderId = 'ORD-1038' WHERE ItemCode = 'FIN-504';
UPDATE dbo.FinishedStock SET CustomerId = NULL,       OrderId = NULL       WHERE ItemCode = 'FIN-703';
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_FinishedStock_Customers')
BEGIN
    ALTER TABLE dbo.FinishedStock
    ADD CONSTRAINT FK_FinishedStock_Customers
    FOREIGN KEY (CustomerId) REFERENCES dbo.Customers(CustomerId)
    ON UPDATE CASCADE ON DELETE SET NULL;
    PRINT 'Added FK_FinishedStock_Customers.';
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_FinishedStock_Orders')
BEGIN
    ALTER TABLE dbo.FinishedStock
    ADD CONSTRAINT FK_FinishedStock_Orders
    FOREIGN KEY (OrderId) REFERENCES dbo.Orders(OrderId)
    ON UPDATE CASCADE ON DELETE SET NULL;
    PRINT 'Added FK_FinishedStock_Orders.';
END
GO

-- 4. Create OrderMachines Junction Table (Many-to-Many: Orders <-> Machines)
IF OBJECT_ID('dbo.OrderMachines', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.OrderMachines (
        OrderMachineId      INT IDENTITY(1,1)   NOT NULL,
        OrderId             VARCHAR(20)         NOT NULL,
        MachineId           INT                 NOT NULL,
        AssignedDate        DATETIME2           NOT NULL DEFAULT SYSUTCDATETIME(),
        Status              VARCHAR(50)         NOT NULL DEFAULT 'In Production',
        CONSTRAINT PK_OrderMachines PRIMARY KEY CLUSTERED (OrderMachineId),
        CONSTRAINT FK_OrderMachines_Orders FOREIGN KEY (OrderId) REFERENCES dbo.Orders(OrderId) ON UPDATE CASCADE ON DELETE CASCADE,
        CONSTRAINT FK_OrderMachines_Machines FOREIGN KEY (MachineId) REFERENCES dbo.Machines(MachineId) ON UPDATE CASCADE ON DELETE CASCADE,
        CONSTRAINT UQ_OrderMachines_Order_Machine UNIQUE (OrderId, MachineId)
    );

    INSERT INTO dbo.OrderMachines (OrderId, MachineId, Status)
    VALUES
        ('ORD-1041', 1, 'Running'),
        ('ORD-1041', 2, 'Running'),
        ('ORD-1040', 3, 'Completed');
    PRINT 'OrderMachines junction table created and seeded.';
END
GO

-- 5. Create OrderMaterials Junction Table (Bill of Materials: Orders <-> RawMaterials)
IF OBJECT_ID('dbo.OrderMaterials', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.OrderMaterials (
        OrderMaterialId     INT IDENTITY(1,1)   NOT NULL,
        OrderId             VARCHAR(20)         NOT NULL,
        Sku                 VARCHAR(50)         NOT NULL,
        QuantityUsed        DECIMAL(18, 2)      NOT NULL,
        Unit                VARCHAR(20)         NOT NULL,
        CONSTRAINT PK_OrderMaterials PRIMARY KEY CLUSTERED (OrderMaterialId),
        CONSTRAINT FK_OrderMaterials_Orders FOREIGN KEY (OrderId) REFERENCES dbo.Orders(OrderId) ON UPDATE CASCADE ON DELETE CASCADE,
        CONSTRAINT FK_OrderMaterials_RawMaterials FOREIGN KEY (Sku) REFERENCES dbo.RawMaterials(Sku) ON UPDATE CASCADE ON DELETE CASCADE,
        CONSTRAINT UQ_OrderMaterials_Order_Sku UNIQUE (OrderId, Sku)
    );

    INSERT INTO dbo.OrderMaterials (OrderId, Sku, QuantityUsed, Unit)
    VALUES
        ('ORD-1041', 'MAT-011', 250.00, 'kg'),
        ('ORD-1041', 'MAT-013', 180.00, 'kg'),
        ('ORD-1041', 'MAT-014', 35.00,  'liters'),
        ('ORD-1041', 'MAT-015', 5.50,   'liters');
    PRINT 'OrderMaterials junction table created and seeded.';
END
GO

-- 6. Ensure Performance Indexes on All Foreign Key Columns
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_FinishedStock_CustomerId')
    CREATE NONCLUSTERED INDEX IX_FinishedStock_CustomerId ON dbo.FinishedStock(CustomerId);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_FinishedStock_OrderId')
    CREATE NONCLUSTERED INDEX IX_FinishedStock_OrderId ON dbo.FinishedStock(OrderId);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_RawMaterials_SupplierId')
    CREATE NONCLUSTERED INDEX IX_RawMaterials_SupplierId ON dbo.RawMaterials(SupplierId);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_OrderMachines_OrderId')
    CREATE NONCLUSTERED INDEX IX_OrderMachines_OrderId ON dbo.OrderMachines(OrderId);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_OrderMachines_MachineId')
    CREATE NONCLUSTERED INDEX IX_OrderMachines_MachineId ON dbo.OrderMachines(MachineId);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_OrderMaterials_OrderId')
    CREATE NONCLUSTERED INDEX IX_OrderMaterials_OrderId ON dbo.OrderMaterials(OrderId);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_OrderMaterials_Sku')
    CREATE NONCLUSTERED INDEX IX_OrderMaterials_Sku ON dbo.OrderMaterials(Sku);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Users_CustomerId')
    CREATE NONCLUSTERED INDEX IX_Users_CustomerId ON dbo.Users(CustomerId);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_OrderStatusHistory_OrderId')
    CREATE NONCLUSTERED INDEX IX_OrderStatusHistory_OrderId ON dbo.OrderStatusHistory(OrderId);
GO

PRINT 'Foreign key migration completed successfully!';
