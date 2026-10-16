-- ==============================================================================
-- PROJECT: BoxFactory Management System
-- FILE: BoxFactory_Complete_Database.sql
-- DESCRIPTION: Complete database script containing all tables, constraints,
--              relationships, and seed data in a single file.
-- COMPATIBILITY: Microsoft SQL Server / Azure SQL / LocalDB
-- LOCATION: C:\dotnet\WebApplication1\App_Data\BoxFactory_Complete_Database.sql
-- ==============================================================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'BoxFactoryDB')
BEGIN
    CREATE DATABASE BoxFactoryDB;
END
GO

USE BoxFactoryDB;
GO

-- ==============================================================================
-- 1. DROP EXISTING TABLES (Reverse Dependency Order)
-- ==============================================================================
IF OBJECT_ID('dbo.OrderStatusHistory', 'U') IS NOT NULL DROP TABLE dbo.OrderStatusHistory;
IF OBJECT_ID('dbo.Orders', 'U')             IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.FinishedStock', 'U')      IS NOT NULL DROP TABLE dbo.FinishedStock;
IF OBJECT_ID('dbo.RawMaterials', 'U')       IS NOT NULL DROP TABLE dbo.RawMaterials;
IF OBJECT_ID('dbo.Machines', 'U')           IS NOT NULL DROP TABLE dbo.Machines;
IF OBJECT_ID('dbo.Users', 'U')              IS NOT NULL DROP TABLE dbo.Users;
IF OBJECT_ID('dbo.Customers', 'U')          IS NOT NULL DROP TABLE dbo.Customers;
GO

-- ==============================================================================
-- 2. TABLE DEFINITIONS
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- TABLE 1: Customers
-- Stores client companies, segments, spending, and permanent box specifications.
-- ------------------------------------------------------------------------------
CREATE TABLE dbo.Customers (
    CustomerId          VARCHAR(20)         NOT NULL,
    CompanyName         NVARCHAR(150)       NOT NULL,
    City                NVARCHAR(100)       NOT NULL,
    ContactPerson       NVARCHAR(100)       NOT NULL,
    Email               NVARCHAR(120)       NOT NULL,
    Phone               NVARCHAR(50)        NOT NULL,
    FacilityAddress     NVARCHAR(255)       NOT NULL,
    Segment             VARCHAR(30)         NOT NULL DEFAULT 'Mid-Market',  -- Enterprise, Mid-Market, SMB
    Status              VARCHAR(20)         NOT NULL DEFAULT 'Active',      -- Active, Inactive
    TotalOrders         INT                 NOT NULL DEFAULT 0,
    TotalSpent          DECIMAL(18, 2)      NOT NULL DEFAULT 0.00,
    AvatarInitials      VARCHAR(10)         NOT NULL,
    AvatarColor         VARCHAR(20)         NOT NULL DEFAULT '#0d9488',
    -- Default / Permanent Box Specifications
    DefaultPly          VARCHAR(20)         NOT NULL DEFAULT '5 Ply',
    DefaultGSM          VARCHAR(20)         NOT NULL DEFAULT '150 GSM',
    DefaultLengthCm     DECIMAL(10, 2)      NOT NULL DEFAULT 40.00,
    DefaultWidthCm      DECIMAL(10, 2)      NOT NULL DEFAULT 30.00,
    DefaultHeightCm     DECIMAL(10, 2)      NOT NULL DEFAULT 25.00,
    DefaultBaseRate     DECIMAL(10, 2)      NOT NULL DEFAULT 48.00,
    CreatedAt           DATETIME2           NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt           DATETIME2           NULL,
    CONSTRAINT PK_Customers PRIMARY KEY CLUSTERED (CustomerId)
);
GO

-- ------------------------------------------------------------------------------
-- TABLE 2: Users (Authentication & Role Management)
-- Stores credentials for factory admins and portal clients.
-- ------------------------------------------------------------------------------
CREATE TABLE dbo.Users (
    UserId              INT IDENTITY(1,1)   NOT NULL,
    Email               NVARCHAR(120)       NOT NULL UNIQUE,
    PasswordHash        NVARCHAR(255)       NOT NULL,
    FullName            NVARCHAR(120)       NOT NULL,
    UserRole            VARCHAR(30)         NOT NULL,                       -- Admin, Customer
    CustomerId          VARCHAR(20)         NULL,                           -- Linked Customer account (if Customer role)
    IsActive            BIT                 NOT NULL DEFAULT 1,
    LastLoginAt         DATETIME2           NULL,
    CreatedAt           DATETIME2           NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_Users PRIMARY KEY CLUSTERED (UserId),
    CONSTRAINT FK_Users_Customers FOREIGN KEY (CustomerId) REFERENCES dbo.Customers (CustomerId) ON DELETE SET NULL
);
GO

-- ------------------------------------------------------------------------------
-- TABLE 3: Orders
-- Master table for all factory and customer repeat orders.
-- ------------------------------------------------------------------------------
CREATE TABLE dbo.Orders (
    OrderId             VARCHAR(20)         NOT NULL,
    CustomerId          VARCHAR(20)         NOT NULL,
    CompanyName         NVARCHAR(150)       NOT NULL,
    -- Box Specifications for this Order
    Ply                 VARCHAR(20)         NOT NULL,                       -- 3 Ply, 5 Ply, 7 Ply
    GSM                 VARCHAR(20)         NOT NULL,                       -- 120 GSM, 150 GSM, 180 GSM, 200 GSM
    LengthCm            DECIMAL(10, 2)      NOT NULL,
    WidthCm             DECIMAL(10, 2)      NOT NULL,
    HeightCm            DECIMAL(10, 2)      NOT NULL,
    Quantity            INT                 NOT NULL,
    UnitPrice           DECIMAL(10, 2)      NOT NULL,
    TotalPrice          DECIMAL(18, 2)      NOT NULL,
    PlacedBy            VARCHAR(30)         NOT NULL DEFAULT 'Customer',    -- Customer, Admin
    PlacedDate          DATETIME2           NOT NULL DEFAULT SYSUTCDATETIME(),
    DueDate             DATETIME2           NULL,
    ETA                 NVARCHAR(50)        NULL,
    Status              VARCHAR(50)         NOT NULL DEFAULT 'In Production',-- Confirmed, In Production, Quality Check, Dispatched, Delivered
    StatusStep          INT                 NOT NULL DEFAULT 2,             -- 1: Confirmed, 2: In Production, 3: QC, 4: Dispatched, 5: Delivered
    IsFirstOrder        BIT                 NOT NULL DEFAULT 0,
    IsRepeatOrder       BIT                 NOT NULL DEFAULT 0,
    DeliveryAddress     NVARCHAR(255)       NOT NULL,
    ContactNumber       NVARCHAR(50)        NOT NULL,
    Notes               NVARCHAR(500)       NULL,
    MachinesAssigned    NVARCHAR(100)       NULL,                           -- e.g. Cutter A & Printer Line 1
    Carrier             NVARCHAR(100)       NULL DEFAULT 'Apex Express Cargo',
    CONSTRAINT PK_Orders PRIMARY KEY CLUSTERED (OrderId),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerId) REFERENCES dbo.Customers (CustomerId)
);
GO

-- ------------------------------------------------------------------------------
-- TABLE 4: OrderStatusHistory
-- Audit timeline log for tracking live progress of orders (Figma 5-step tracker).
-- ------------------------------------------------------------------------------
CREATE TABLE dbo.OrderStatusHistory (
    HistoryId           INT IDENTITY(1,1)   NOT NULL,
    OrderId             VARCHAR(20)         NOT NULL,
    StepNumber          INT                 NOT NULL,                       -- 1 to 5
    StepName            VARCHAR(50)         NOT NULL,                       -- Confirmed, In Production, Quality Check, Dispatched, Delivered
    IsCompleted         BIT                 NOT NULL DEFAULT 0,
    CompletedAt         DATETIME2           NULL,
    Notes               NVARCHAR(255)       NULL,
    CONSTRAINT PK_OrderStatusHistory PRIMARY KEY CLUSTERED (HistoryId),
    CONSTRAINT FK_OrderStatusHistory_Orders FOREIGN KEY (OrderId) REFERENCES dbo.Orders (OrderId) ON DELETE CASCADE
);
GO

-- ------------------------------------------------------------------------------
-- TABLE 5: RawMaterials
-- Warehouse inventory tracking of corrugated paper rolls, adhesives, and inks.
-- ------------------------------------------------------------------------------
CREATE TABLE dbo.RawMaterials (
    Sku                 VARCHAR(50)         NOT NULL,                       -- e.g. MAT-011
    ItemName            NVARCHAR(150)       NOT NULL,
    Category            NVARCHAR(100)       NOT NULL,                       -- Paper Roll, Fluting Medium, Adhesive, Printing Ink, Coating
    StockQty            DECIMAL(18, 2)      NOT NULL,
    ReorderAt           DECIMAL(18, 2)      NOT NULL,
    Unit                VARCHAR(20)         NOT NULL,                       -- kg, liters
    StockLevel          VARCHAR(20)         NOT NULL DEFAULT 'Good',        -- Good, OK, Low
    Supplier            NVARCHAR(150)       NOT NULL,
    UpdatedAt           DATETIME2           NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_RawMaterials PRIMARY KEY CLUSTERED (Sku)
);
GO

-- ------------------------------------------------------------------------------
-- TABLE 6: FinishedStock
-- Ready corrugated box inventory stacked on pallets in the warehouse.
-- ------------------------------------------------------------------------------
CREATE TABLE dbo.FinishedStock (
    ItemCode            VARCHAR(50)         NOT NULL,                       -- e.g. FIN-501
    ItemDescription     NVARCHAR(150)       NOT NULL,
    BoxSpecs            NVARCHAR(100)       NOT NULL,                       -- 40×30×25 cm
    AvailableQty        INT                 NOT NULL DEFAULT 0,
    ReservedQty         INT                 NOT NULL DEFAULT 0,
    ReservedFor         NVARCHAR(150)       NULL,                           -- Linked company name
    Pallets             VARCHAR(50)         NULL,                           -- e.g. 6 Pallets
    StockStatus         VARCHAR(50)         NOT NULL DEFAULT 'Available',   -- Ready for Dispatch, Dispatched, Available, In Production
    CONSTRAINT PK_FinishedStock PRIMARY KEY CLUSTERED (ItemCode)
);
GO

-- ------------------------------------------------------------------------------
-- TABLE 7: Machines
-- Real-time factory equipment monitoring, speeds, statuses, and maintenance.
-- ------------------------------------------------------------------------------
CREATE TABLE dbo.Machines (
    MachineId           INT IDENTITY(1,1)   NOT NULL,
    MachineName         NVARCHAR(100)       NOT NULL UNIQUE,
    MachineStatus       VARCHAR(50)         NOT NULL,                       -- Running, Idle, Maintenance
    SpeedMetric         NVARCHAR(100)       NOT NULL,                       -- e.g. 87% speed | 420 cuts/hr
    ProgressPercent     INT                 NOT NULL DEFAULT 0,
    BadgeClass          VARCHAR(50)         NOT NULL DEFAULT 'badge-running',
    LastCheckedAt       DATETIME2           NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_Machines PRIMARY KEY CLUSTERED (MachineId)
);
GO

-- ==============================================================================
-- 3. INDEXES FOR HIGH QUERY PERFORMANCE
-- ==============================================================================
CREATE NONCLUSTERED INDEX IX_Orders_CustomerId ON dbo.Orders(CustomerId);
CREATE NONCLUSTERED INDEX IX_Orders_Status ON dbo.Orders(Status);
CREATE NONCLUSTERED INDEX IX_Customers_Segment ON dbo.Customers(Segment);
CREATE NONCLUSTERED INDEX IX_RawMaterials_StockLevel ON dbo.RawMaterials(StockLevel);
GO

-- ==============================================================================
-- 4. SEED DATA (EXACT FIGMA MOCKUP DATA)
-- ==============================================================================

-- Seed Customers (Page 4 Top)
INSERT INTO dbo.Customers 
    (CustomerId, CompanyName, City, ContactPerson, Email, Phone, FacilityAddress, Segment, Status, TotalOrders, TotalSpent, AvatarInitials, AvatarColor, DefaultPly, DefaultGSM, DefaultLengthCm, DefaultWidthCm, DefaultHeightCm, DefaultBaseRate)
VALUES
    ('CUST-001', N'Apex Logistics',     N'Mumbai, MH',    N'Rajesh Sharma',    N'logistics@apex.com',        N'+91 98200 12345', N'Plot 42, Andheri MIDC, Mumbai, Maharashtra 400093', N'Enterprise', 'Active', 18, 432000.00, 'AL', '#10b981', '5 Ply', '150 GSM', 40, 30, 25, 48.00),
    ('CUST-002', N'Green Pack Co.',     N'Pune, MH',      N'Vikram Patil',     N'orders@greenpack.co',       N'+91 98220 54321', N'Plot 18, Bhosari Industrial Area, Pune 411026',      N'Enterprise', 'Active', 31, 817000.00, 'GP', '#3b82f6', '3 Ply', '120 GSM', 30, 20, 15, 32.00),
    ('CUST-003', N'Metro Supplies',     N'Bengaluru, KA', N'Anil Kumar',       N'purchase@metrosupplies.in', N'+91 98450 67890', N'Whitefield Tech Park Road, Bengaluru 560066',          N'Mid-Market', 'Active', 9,  179000.00, 'MS', '#f59e0b', '3 Ply', '150 GSM', 35, 25, 20, 40.00),
    ('CUST-004', N'StarBrand Inc.',     N'Delhi, DL',     N'Meera Kapoor',     N'supply@starbrand.com',      N'+91 98110 33445', N'Okhla Industrial Phase III, New Delhi 110020',        N'Mid-Market', 'Active', 14, 365000.00, 'SB', '#059669', '5 Ply', '180 GSM', 45, 35, 30, 52.00),
    ('CUST-005', N'QuickShip Ltd.',     N'Ahmedabad, GJ', N'Hardik Shah',      N'packaging@quickship.com',   N'+91 98250 88990', N'Sanand GIDC Gateway, Ahmedabad 382110',               N'Enterprise', 'Active', 27, 675000.00, 'QS', '#0d9488', '5 Ply', '150 GSM', 40, 30, 20, 45.00),
    ('CUST-006', N'BlueSky Exports',    N'Chennai, TN',   N'S. Ramachandran',  N'export@bluesky.com',        N'+91 98400 11223', N'Ambattur Industrial Estate, Chennai 600058',           N'SMB',        'Active', 6,  148000.00, 'BE', '#8b5cf6', '7 Ply', '200 GSM', 50, 40, 30, 68.00),
    ('CUST-007', N'Nimbus Retail',      N'Hyderabad, TS', N'Priya Reddy',      N'store@nimbusretail.in',     N'+91 98490 77889', N'Cherlapally Industrial Area, Hyderabad 500051',        N'SMB',        'Active', 4,   76000.00, 'NR', '#ef4444', '3 Ply', '120 GSM', 25, 20, 15, 28.00),
    ('CUST-008', N'Crest Distribution', N'Jaipur, RJ',    N'Sanjay Choudhary', N'ops@crestdistrib.com',      N'+91 98290 66554', N'Sitapura Industrial Area, Jaipur 302022',             N'Mid-Market', 'Active', 11, 298000.00, 'CD', '#ec4899', '5 Ply', '180 GSM', 42, 32, 28, 50.00);
GO

-- Seed Users (Admin & Customer Portal Login Credentials)
INSERT INTO dbo.Users (Email, PasswordHash, FullName, UserRole, CustomerId)
VALUES
    (N'admin@boxfactory.in', N'admin123', N'Factory Manager', N'Admin', NULL),
    (N'logistics@apex.com',  N'apex123',  N'Apex Logistics Portal', N'Customer', 'CUST-001');
GO

-- Seed Orders (Pages 1, 2, 4, 5)
INSERT INTO dbo.Orders 
    (OrderId, CustomerId, CompanyName, Ply, GSM, LengthCm, WidthCm, HeightCm, Quantity, UnitPrice, TotalPrice, PlacedBy, PlacedDate, DueDate, ETA, Status, StatusStep, IsFirstOrder, IsRepeatOrder, DeliveryAddress, ContactNumber, Notes, MachinesAssigned, Carrier)
VALUES
    ('ORD-1041', 'CUST-001', N'Apex Logistics',  '5 Ply', '150 GSM', 40, 30, 25, 500,  48.00, 24000.00, 'Customer', DATEADD(DAY, -3, SYSUTCDATETIME()), DATEADD(DAY, 3, SYSUTCDATETIME()), N'20 Oct 2026', N'In Production', 2, 0, 0, N'Plot 42, Andheri MIDC, Mumbai, Maharashtra 400093', N'+91 98200 12345', N'Fragile dispatch, ensure corner guards applied.', N'Cutter A & Printer Line 1', N'Apex Express Cargo'),
    ('ORD-1040', 'CUST-002', N'Green Pack Co.',  '3 Ply', '120 GSM', 30, 20, 15, 1200, 32.00, 38400.00, 'Customer', DATEADD(DAY, -5, SYSUTCDATETIME()), SYSUTCDATETIME(),                   N'16 Oct 2026', N'Dispatched',    4, 0, 0, N'Plot 18, Bhosari Industrial Area, Pune 411026',      N'+91 98220 54321', N'Standard eco-friendly packaging batch.',          N'Completed',               N'BlueDart Freight'),
    ('ORD-1039', 'CUST-001', N'Apex Logistics',  '5 Ply', '150 GSM', 40, 30, 25, 750,  48.00, 36000.00, 'Customer', DATEADD(DAY, -7, SYSUTCDATETIME()), DATEADD(DAY, -3, SYSUTCDATETIME()),N'Delivered',   N'Delivered',     5, 0, 1, N'Plot 42, Andheri MIDC, Mumbai, Maharashtra 400093', N'+91 98200 12345', N'Repeat order based on verified spec.',         N'Completed',               N'Apex Express Cargo'),
    ('ORD-1038', 'CUST-004', N'StarBrand Inc.',  '5 Ply', '180 GSM', 45, 35, 30, 750,  48.00, 36000.00, 'Admin',    DATEADD(DAY, -10,SYSUTCDATETIME()), DATEADD(DAY, -4, SYSUTCDATETIME()),N'Delivered',   N'Delivered',     5, 1, 0, N'Okhla Industrial Phase III, New Delhi 110020',        N'+91 98110 33445', N'Initial onboarding order with custom stamp.', N'Completed',               N'Delhivery Heavy'),
    ('ORD-1037', 'CUST-005', N'QuickShip Ltd.',  '5 Ply', '150 GSM', 40, 30, 20, 2000, 45.00, 90000.00, 'Customer', DATEADD(DAY, -12,SYSUTCDATETIME()), DATEADD(DAY, -6, SYSUTCDATETIME()),N'Delivered',   N'Delivered',     5, 0, 1, N'Sanand GIDC Gateway, Ahmedabad 382110',               N'+91 98250 88990', N'Bulk delivery executed via truckload 4.',      N'Completed',               N'GATI KWE');
GO

-- Seed Timeline Tracking for Active Order ORD-1041 (Page 5 Middle)
INSERT INTO dbo.OrderStatusHistory (OrderId, StepNumber, StepName, IsCompleted, CompletedAt, Notes)
VALUES
    ('ORD-1041', 1, 'Order Confirmed',  1, DATEADD(DAY, -3, SYSUTCDATETIME()), N'Specifications verified against CUST-001 master contract.'),
    ('ORD-1041', 2, 'In Production',    1, DATEADD(DAY, -1, SYSUTCDATETIME()), N'Corrugation completed, printing line active.'),
    ('ORD-1041', 3, 'Quality Check',    0, NULL,                               N'Pending post-gluing dimensional inspection.'),
    ('ORD-1041', 4, 'Dispatched',       0, NULL,                               N'Awaiting loading onto truck.'),
    ('ORD-1041', 5, 'Delivered',        0, NULL,                               N'Expected delivery at Mumbai MIDC facility.');
GO

-- Seed Raw Materials (Page 3 Bottom)
INSERT INTO dbo.RawMaterials (Sku, ItemName, Category, StockQty, ReorderAt, Unit, StockLevel, Supplier)
VALUES
    ('MAT-011', N'Kraft Paper Roll (200gsm)', N'Paper Roll',      4200.00, 1000.00, 'kg',     'Good', N'NorthPaper Ltd'),
    ('MAT-012', N'Kraft Paper Roll (300gsm)', N'Paper Roll',       980.00, 1000.00, 'kg',     'Low',  N'NorthPaper Ltd'),
    ('MAT-013', N'Corrugating Medium',        N'Fluting Medium',  3100.00,  800.00, 'kg',     'Good', N'FlyteCo'),
    ('MAT-014', N'Starch Adhesive',           N'Adhesive',         620.00,  300.00, 'liters', 'OK',   N'BoralChem'),
    ('MAT-015', N'Water-based Ink (Black)',   N'Printing Ink',      88.00,  100.00, 'liters', 'Low',  N'CareInk Co'),
    ('MAT-016', N'Wax Coating Compound',      N'Coating',          190.00,  200.00, 'kg',     'OK',   N'CustTech');
GO

-- Seed Finished Stock (Page 3 Bottom)
INSERT INTO dbo.FinishedStock (ItemCode, ItemDescription, BoxSpecs, AvailableQty, ReservedQty, ReservedFor, Pallets, StockStatus)
VALUES
    ('FIN-501', N'5 Ply Standard Corrugated Box',  N'40×30×25 cm', 1450, 500,  N'Apex Logistics',  '6 Pallets', N'Ready for Dispatch'),
    ('FIN-302', N'3 Ply Lightweight Shipping Box', N'30×20×15 cm', 2800, 1200, N'Green Pack Co.',  '8 Pallets', N'Dispatched'),
    ('FIN-703', N'7 Ply Heavy Duty Export Box',    N'50×40×30 cm',  620, 0,    N'-',               '3 Pallets', N'Available'),
    ('FIN-504', N'5 Ply Reinforced Archive Box',   N'45×35×30 cm',  900, 750,  N'StarBrand Inc.',  '4 Pallets', N'In Production');
GO

-- Seed Machines (Page 1 Bottom)
INSERT INTO dbo.Machines (MachineName, MachineStatus, SpeedMetric, ProgressPercent, BadgeClass)
VALUES
    (N'Cutter A',        'Running',     N'87% speed | 420 cuts/hr',        85, 'badge-running'),
    (N'Printer Line 1',  'Running',     N'65% speed | 2-Color Flexo',      65, 'badge-running'),
    (N'Gluer B',         'Idle',        N'Warmup ready | Queue: 1,200',    20, 'badge-idle'),
    (N'Die-Cut Press',   'Maintenance', N'Blade replacement | Resume: 45m', 0, 'badge-maintenance');
GO
