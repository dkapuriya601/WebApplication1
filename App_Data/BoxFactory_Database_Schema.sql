-- ========================================================
-- BoxFactory Management System - Database Schema & Seed Data
-- Database Engine: Microsoft SQL Server / SQL Server Express / LocalDB
-- Location: C:\dotnet\WebApplication1\App_Data\BoxFactory_Database_Schema.sql
-- ========================================================

-- Create Database (Optional, run if creating from scratch)
-- CREATE DATABASE BoxFactoryDB;
-- USE BoxFactoryDB;
-- GO

-- 1. CUSTOMERS TABLE
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
CREATE TABLE dbo.Customers (
    CustomerId          VARCHAR(20)     PRIMARY KEY,
    CompanyName         NVARCHAR(150)   NOT NULL,
    City                NVARCHAR(100)   NOT NULL,
    ContactPerson       NVARCHAR(100)   NULL,
    Email               NVARCHAR(100)   NULL,
    Phone               NVARCHAR(50)    NULL,
    FacilityAddress     NVARCHAR(255)   NULL,
    Segment             NVARCHAR(50)    NOT NULL DEFAULT 'Mid-Market', -- Enterprise, Mid-Market, SMB
    Status              NVARCHAR(20)    NOT NULL DEFAULT 'Active',     -- Active, Inactive
    TotalOrders         INT             NOT NULL DEFAULT 0,
    TotalSpent          DECIMAL(18, 2)  NOT NULL DEFAULT 0,
    AvatarInitials      VARCHAR(10)     NULL,
    AvatarColor         VARCHAR(20)     NULL DEFAULT '#0d9488',
    -- Default Saved Box Specification
    DefaultPly          VARCHAR(20)     NOT NULL DEFAULT '5 Ply',
    DefaultGSM          VARCHAR(20)     NOT NULL DEFAULT '150 GSM',
    DefaultLengthCm     DECIMAL(10, 2)  NOT NULL DEFAULT 40,
    DefaultWidthCm      DECIMAL(10, 2)  NOT NULL DEFAULT 30,
    DefaultHeightCm     DECIMAL(10, 2)  NOT NULL DEFAULT 25,
    DefaultBaseRate     DECIMAL(10, 2)  NOT NULL DEFAULT 48.00,
    CreatedAt           DATETIME        NOT NULL DEFAULT GETDATE()
);
GO

-- 2. ORDERS TABLE
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
CREATE TABLE dbo.Orders (
    OrderId             VARCHAR(20)     PRIMARY KEY,
    CustomerId          VARCHAR(20)     NOT NULL,
    CompanyName         NVARCHAR(150)   NOT NULL,
    Ply                 VARCHAR(20)     NOT NULL,
    GSM                 VARCHAR(20)     NOT NULL,
    LengthCm            DECIMAL(10, 2)  NOT NULL,
    WidthCm             DECIMAL(10, 2)  NOT NULL,
    HeightCm            DECIMAL(10, 2)  NOT NULL,
    Quantity            INT             NOT NULL,
    UnitPrice           DECIMAL(10, 2)  NOT NULL,
    TotalPrice          DECIMAL(18, 2)  NOT NULL,
    PlacedBy            NVARCHAR(50)    NOT NULL DEFAULT 'Customer', -- Admin, Customer
    PlacedDate          DATETIME        NOT NULL DEFAULT GETDATE(),
    DueDate             DATETIME        NULL,
    ETA                 NVARCHAR(50)    NULL,
    Status              NVARCHAR(50)    NOT NULL DEFAULT 'In Production', -- Confirmed, In Production, Quality Check, Dispatched, Delivered
    StatusStep          INT             NOT NULL DEFAULT 2,          -- 1 to 5
    IsFirstOrder        BIT             NOT NULL DEFAULT 0,
    IsRepeatOrder       BIT             NOT NULL DEFAULT 0,
    DeliveryAddress     NVARCHAR(255)   NULL,
    ContactNumber       NVARCHAR(50)    NULL,
    Notes               NVARCHAR(500)   NULL,
    MachinesAssigned    NVARCHAR(100)   NULL,
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerId) REFERENCES dbo.Customers(CustomerId)
);
GO

-- 3. RAW MATERIALS INVENTORY TABLE
IF OBJECT_ID('dbo.RawMaterials', 'U') IS NOT NULL DROP TABLE dbo.RawMaterials;
CREATE TABLE dbo.RawMaterials (
    Sku                 VARCHAR(50)     PRIMARY KEY,
    ItemName            NVARCHAR(150)   NOT NULL,
    Category            NVARCHAR(100)   NOT NULL,
    StockQty            DECIMAL(18, 2)  NOT NULL,
    ReorderAt           DECIMAL(18, 2)  NOT NULL,
    Unit                NVARCHAR(20)    NOT NULL, -- kg, liters
    StockLevel          NVARCHAR(20)    NOT NULL DEFAULT 'Good', -- Good, OK, Low
    Supplier            NVARCHAR(150)   NOT NULL
);
GO

-- 4. FINISHED STOCK INVENTORY TABLE
IF OBJECT_ID('dbo.FinishedStock', 'U') IS NOT NULL DROP TABLE dbo.FinishedStock;
CREATE TABLE dbo.FinishedStock (
    ItemCode            VARCHAR(50)     PRIMARY KEY,
    ItemDescription     NVARCHAR(150)   NOT NULL,
    BoxSpecs            NVARCHAR(100)   NOT NULL,
    AvailableQty        INT             NOT NULL DEFAULT 0,
    ReservedQty         INT             NOT NULL DEFAULT 0,
    ReservedFor         NVARCHAR(150)   NULL,
    Pallets             NVARCHAR(50)    NULL,
    StockStatus         NVARCHAR(50)    NOT NULL DEFAULT 'Available'
);
GO

-- 5. FACTORY MACHINES TABLE
IF OBJECT_ID('dbo.Machines', 'U') IS NOT NULL DROP TABLE dbo.Machines;
CREATE TABLE dbo.Machines (
    MachineId           INT IDENTITY(1,1) PRIMARY KEY,
    MachineName         NVARCHAR(100)   NOT NULL,
    MachineStatus       NVARCHAR(50)    NOT NULL, -- Running, Idle, Maintenance
    SpeedMetric         NVARCHAR(100)   NOT NULL,
    ProgressPercent     INT             NOT NULL DEFAULT 0,
    BadgeClass          NVARCHAR(50)    NULL
);
GO

-- ========================================================
-- SEED DATA (Matching Figma Design Exactly)
-- ========================================================

-- Insert Customers
INSERT INTO dbo.Customers (CustomerId, CompanyName, City, ContactPerson, Email, Phone, FacilityAddress, Segment, Status, TotalOrders, TotalSpent, AvatarInitials, AvatarColor, DefaultPly, DefaultGSM, DefaultLengthCm, DefaultWidthCm, DefaultHeightCm, DefaultBaseRate)
VALUES
('CUST-001', N'Apex Logistics', N'Mumbai, MH', N'Rajesh Sharma', N'logistics@apex.com', N'+91 98200 12345', N'Plot 42, Andheri MIDC, Mumbai, Maharashtra 400093', N'Enterprise', N'Active', 18, 432000.00, 'AL', '#10b981', '5 Ply', '150 GSM', 40, 30, 25, 48.00),
('CUST-002', N'Green Pack Co.', N'Pune, MH', N'Vikram Patil', N'orders@greenpack.co', N'+91 98220 54321', N'Plot 18, Bhosari Industrial Area, Pune 411026', N'Enterprise', N'Active', 31, 817000.00, 'GP', '#3b82f6', '3 Ply', '120 GSM', 30, 20, 15, 32.00),
('CUST-003', N'Metro Supplies', N'Bengaluru, KA', N'Anil Kumar', N'purchase@metrosupplies.in', N'+91 98450 67890', N'Whitefield Tech Park Road, Bengaluru 560066', N'Mid-Market', N'Active', 9, 179000.00, 'MS', '#f59e0b', '3 Ply', '150 GSM', 35, 25, 20, 40.00),
('CUST-004', N'StarBrand Inc.', N'Delhi, DL', N'Meera Kapoor', N'supply@starbrand.com', N'+91 98110 33445', N'Okhla Industrial Phase III, New Delhi 110020', N'Mid-Market', N'Active', 14, 365000.00, 'SB', '#059669', '5 Ply', '180 GSM', 45, 35, 30, 52.00),
('CUST-005', N'QuickShip Ltd.', N'Ahmedabad, GJ', N'Hardik Shah', N'packaging@quickship.com', N'+91 98250 88990', N'Sanand GIDC Gateway, Ahmedabad 382110', N'Enterprise', N'Active', 27, 675000.00, 'QS', '#0d9488', '5 Ply', '150 GSM', 40, 30, 20, 45.00),
('CUST-006', N'BlueSky Exports', N'Chennai, TN', N'S. Ramachandran', N'export@bluesky.com', N'+91 98400 11223', N'Ambattur Industrial Estate, Chennai 600058', N'SMB', N'Active', 6, 148000.00, 'BE', '#8b5cf6', '7 Ply', '200 GSM', 50, 40, 30, 68.00),
('CUST-007', N'Nimbus Retail', N'Hyderabad, TS', N'Priya Reddy', N'store@nimbusretail.in', N'+91 98490 77889', N'Cherlapally Industrial Area, Hyderabad 500051', N'SMB', N'Active', 4, 76000.00, 'NR', '#ef4444', '3 Ply', '120 GSM', 25, 20, 15, 28.00),
('CUST-008', N'Crest Distribution', N'Jaipur, RJ', N'Sanjay Choudhary', N'ops@crestdistrib.com', N'+91 98290 66554', N'Sitapura Industrial Area, Jaipur 302022', N'Mid-Market', N'Active', 11, 298000.00, 'CD', '#ec4899', '5 Ply', '180 GSM', 42, 32, 28, 50.00);
GO

-- Insert Orders
INSERT INTO dbo.Orders (OrderId, CustomerId, CompanyName, Ply, GSM, LengthCm, WidthCm, HeightCm, Quantity, UnitPrice, TotalPrice, PlacedBy, PlacedDate, DueDate, ETA, Status, StatusStep, IsFirstOrder, IsRepeatOrder, DeliveryAddress, ContactNumber, Notes, MachinesAssigned)
VALUES
('ORD-1041', 'CUST-001', N'Apex Logistics', '5 Ply', '150 GSM', 40, 30, 25, 500, 48.00, 24000.00, 'Customer', DATEADD(DAY, -3, GETDATE()), DATEADD(DAY, 3, GETDATE()), N'20 Oct 2026', N'In Production', 2, 0, 0, N'Plot 42, Andheri MIDC, Mumbai, Maharashtra 400093', N'+91 98200 12345', N'Fragile dispatch, ensure corner guards applied.', N'Cutter A & Printer Line 1'),
('ORD-1040', 'CUST-002', N'Green Pack Co.', '3 Ply', '120 GSM', 30, 20, 15, 1200, 32.00, 38400.00, 'Customer', DATEADD(DAY, -5, GETDATE()), GETDATE(), N'16 Oct 2026', N'Dispatched', 4, 0, 0, N'Plot 18, Bhosari Industrial Area, Pune 411026', N'+91 98220 54321', N'Standard eco-friendly packaging batch.', N'Completed'),
('ORD-1039', 'CUST-001', N'Apex Logistics', '5 Ply', '150 GSM', 40, 30, 25, 750, 48.00, 36000.00, 'Customer', DATEADD(DAY, -7, GETDATE()), DATEADD(DAY, -3, GETDATE()), N'Delivered', N'Delivered', 5, 0, 1, N'Plot 42, Andheri MIDC, Mumbai, Maharashtra 400093', N'+91 98200 12345', N'Repeat order based on verified spec.', N'Completed'),
('ORD-1038', 'CUST-004', N'StarBrand Inc.', '5 Ply', '180 GSM', 45, 35, 30, 750, 48.00, 36000.00, 'Admin', DATEADD(DAY, -10, GETDATE()), DATEADD(DAY, -4, GETDATE()), N'Delivered', N'Delivered', 5, 1, 0, N'Okhla Industrial Phase III, New Delhi 110020', N'+91 98110 33445', N'Initial onboarding order with custom stamp.', N'Completed'),
('ORD-1037', 'CUST-005', N'QuickShip Ltd.', '5 Ply', '150 GSM', 40, 30, 20, 2000, 45.00, 90000.00, 'Customer', DATEADD(DAY, -12, GETDATE()), DATEADD(DAY, -6, GETDATE()), N'Delivered', N'Delivered', 5, 0, 1, N'Sanand GIDC Gateway, Ahmedabad 382110', N'+91 98250 88990', N'Bulk delivery executed via truckload 4.', N'Completed');
GO

-- Insert Raw Materials
INSERT INTO dbo.RawMaterials (Sku, ItemName, Category, StockQty, ReorderAt, Unit, StockLevel, Supplier)
VALUES
('MAT-011', N'Kraft Paper Roll (200gsm)', N'Paper Roll', 4200, 1000, N'kg', N'Good', N'NorthPaper Ltd'),
('MAT-012', N'Kraft Paper Roll (300gsm)', N'Paper Roll', 980, 1000, N'kg', N'Low', N'NorthPaper Ltd'),
('MAT-013', N'Corrugating Medium', N'Fluting Medium', 3100, 800, N'kg', N'Good', N'FlyteCo'),
('MAT-014', N'Starch Adhesive', N'Adhesive', 620, 300, N'liters', N'OK', N'BoralChem'),
('MAT-015', N'Water-based Ink (Black)', N'Printing Ink', 88, 100, N'liters', N'Low', N'CareInk Co'),
('MAT-016', N'Wax Coating Compound', N'Coating', 190, 200, N'kg', N'OK', N'CustTech');
GO

-- Insert Finished Stock
INSERT INTO dbo.FinishedStock (ItemCode, ItemDescription, BoxSpecs, AvailableQty, ReservedQty, ReservedFor, Pallets, StockStatus)
VALUES
('FIN-501', N'5 Ply Standard Corrugated Box', N'40×30×25 cm', 1450, 500, N'Apex Logistics', N'6 Pallets', N'Ready for Dispatch'),
('FIN-302', N'3 Ply Lightweight Shipping Box', N'30×20×15 cm', 2800, 1200, N'Green Pack Co.', N'8 Pallets', N'Dispatched'),
('FIN-703', N'7 Ply Heavy Duty Export Box', N'50×40×30 cm', 620, 0, N'-', N'3 Pallets', N'Available'),
('FIN-504', N'5 Ply Reinforced Archive Box', N'45×35×30 cm', 900, 750, N'StarBrand Inc.', N'4 Pallets', N'In Production');
GO

-- Insert Machines
INSERT INTO dbo.Machines (MachineName, MachineStatus, SpeedMetric, ProgressPercent, BadgeClass)
VALUES
(N'Cutter A', N'Running', N'87% speed | 420 cuts/hr', 85, N'badge-running'),
(N'Printer Line 1', N'Running', N'65% speed | 2-Color Flexo', 65, N'badge-running'),
(N'Gluer B', N'Idle', N'Warmup ready | Queue: 1,200', 20, N'badge-idle'),
(N'Die-Cut Press', N'Maintenance', N'Blade replacement | Resume: 45m', 0, N'badge-maintenance');
GO
