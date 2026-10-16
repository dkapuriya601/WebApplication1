# BoxFactory Management System - Database Tables Reference

All database tables for the BoxFactory system are structured in the unified SQL script:
📁 **[`C:\dotnet\WebApplication1\App_Data\BoxFactory_Complete_Database.sql`](file:///C:/dotnet/WebApplication1/App_Data/BoxFactory_Complete_Database.sql)**

---

### 1. `Customers` Table
Stores registered enterprise and mid-market customer accounts, their contact info, total orders/spend, and permanent box specifications.

| Column Name | Data Type | Nullable | Primary/Foreign Key | Default Value | Description |
|---|---|---|---|---|---|
| `CustomerId` | `VARCHAR(20)` | No | **PK** | - | Unique ID (e.g. `CUST-001`, `CUST-002`) |
| `CompanyName` | `NVARCHAR(150)` | No | - | - | Company name (e.g. `Apex Logistics`) |
| `City` | `NVARCHAR(100)` | No | - | - | City & State (e.g. `Mumbai, MH`) |
| `ContactPerson` | `NVARCHAR(100)` | No | - | - | Primary liaison name |
| `Email` | `NVARCHAR(120)` | No | - | - | Contact email |
| `Phone` | `NVARCHAR(50)` | No | - | - | Contact phone |
| `FacilityAddress`| `NVARCHAR(255)` | No | - | - | Delivery & warehouse address |
| `Segment` | `VARCHAR(30)` | No | - | `'Mid-Market'` | Category: `Enterprise`, `Mid-Market`, `SMB` |
| `Status` | `VARCHAR(20)` | No | - | `'Active'` | Account status: `Active`, `Inactive` |
| `TotalOrders` | `INT` | No | - | `0` | Cumulative orders count |
| `TotalSpent` | `DECIMAL(18,2)` | No | - | `0.00` | Lifetime order total in ₹ |
| `AvatarInitials`| `VARCHAR(10)` | No | - | - | Two-letter initials badge (e.g. `AL`) |
| `AvatarColor` | `VARCHAR(20)` | No | - | `'#0d9488'` | Hex color code for avatar background |
| `DefaultPly` | `VARCHAR(20)` | No | - | `'5 Ply'` | Saved box spec: `3 Ply`, `5 Ply`, `7 Ply` |
| `DefaultGSM` | `VARCHAR(20)` | No | - | `'150 GSM'` | Paper GSM: `120 GSM`, `150 GSM`, `180 GSM` |
| `DefaultLengthCm`| `DECIMAL(10,2)`| No | - | `40.00` | Default box length (cm) |
| `DefaultWidthCm` | `DECIMAL(10,2)`| No | - | `30.00` | Default box width (cm) |
| `DefaultHeightCm`| `DECIMAL(10,2)`| No | - | `25.00` | Default box height (cm) |
| `DefaultBaseRate`| `DECIMAL(10,2)`| No | - | `48.00` | Contract rate per box in ₹ |
| `CreatedAt` | `DATETIME2` | No | - | `SYSUTCDATETIME()`| Record creation timestamp |

---

### 2. `Users` Table (Authentication & Access Control)
Stores login credentials and roles for the Admin Panel and Customer Portal.

| Column Name | Data Type | Nullable | Primary/Foreign Key | Default Value | Description |
|---|---|---|---|---|---|
| `UserId` | `INT` | No | **PK (Identity)** | - | Auto-increment primary key |
| `Email` | `NVARCHAR(120)` | No | **Unique** | - | Login email (e.g. `admin@boxfactory.in`) |
| `PasswordHash` | `NVARCHAR(255)` | No | - | - | Stored password / hash (e.g. `admin123`) |
| `FullName` | `NVARCHAR(120)` | No | - | - | Display name |
| `UserRole` | `VARCHAR(30)` | No | - | - | Role: `Admin` or `Customer` |
| `CustomerId` | `VARCHAR(20)` | Yes | **FK → Customers**| `NULL` | Linked customer ID (for Customer accounts) |
| `IsActive` | `BIT` | No | - | `1` | Flag: `1` = active, `0` = disabled |
| `LastLoginAt` | `DATETIME2` | Yes | - | `NULL` | Timestamp of last access |

---

### 3. `Orders` Table
Central order management table tracking all manufacturing jobs placed by factory managers and clients.

| Column Name | Data Type | Nullable | Primary/Foreign Key | Default Value | Description |
|---|---|---|---|---|---|
| `OrderId` | `VARCHAR(20)` | No | **PK** | - | Unique order code (e.g. `ORD-1041`) |
| `CustomerId` | `VARCHAR(20)` | No | **FK → Customers**| - | Client who ordered |
| `CompanyName` | `NVARCHAR(150)` | No | - | - | Company name at time of order |
| `Ply` | `VARCHAR(20)` | No | - | - | Box ply: `3 Ply`, `5 Ply`, `7 Ply` |
| `GSM` | `VARCHAR(20)` | No | - | - | Paper GSM weight (e.g. `150 GSM`) |
| `LengthCm` | `DECIMAL(10,2)` | No | - | - | Box length in cm |
| `WidthCm` | `DECIMAL(10,2)` | No | - | - | Box width in cm |
| `HeightCm` | `DECIMAL(10,2)` | No | - | - | Box height in cm |
| `Quantity` | `INT` | No | - | - | Total boxes ordered |
| `UnitPrice` | `DECIMAL(10,2)` | No | - | - | Unit price per box in ₹ |
| `TotalPrice` | `DECIMAL(18,2)` | No | - | - | Total invoice amount in ₹ (`Qty × Rate`) |
| `PlacedBy` | `VARCHAR(30)` | No | - | `'Customer'` | Placed via: `Customer` or `Admin` |
| `PlacedDate` | `DATETIME2` | No | - | `SYSUTCDATETIME()`| Date order submitted |
| `DueDate` | `DATETIME2` | Yes | - | `NULL` | Manufacturing deadline |
| `ETA` | `NVARCHAR(50)` | Yes | - | `NULL` | Estimated delivery (e.g. `20 Oct 2026`) |
| `Status` | `VARCHAR(50)` | No | - | `'In Production'` | State: `Confirmed`, `In Production`, `Quality Check`, `Dispatched`, `Delivered` |
| `StatusStep` | `INT` | No | - | `2` | Active progress node index (`1` to `5`) |
| `IsFirstOrder` | `BIT` | No | - | `0` | Flag for new company onboarding badge |
| `IsRepeatOrder`| `BIT` | No | - | `0` | Flag for 1-click repeat reorder badge |
| `DeliveryAddress`| `NVARCHAR(255)`| No | - | - | Destination address |
| `ContactNumber`| `NVARCHAR(50)` | No | - | - | Driver/logistics contact number |
| `Notes` | `NVARCHAR(500)` | Yes | - | `NULL` | Special handling instructions |
| `MachinesAssigned`| `NVARCHAR(100)`| Yes | - | `NULL` | Assigned production line (e.g. `Cutter A`) |
| `Carrier` | `NVARCHAR(100)` | Yes | - | `'Apex Express Cargo'` | Logistics partner name |

---

### 4. `OrderStatusHistory` Table (Visual Step Progress Tracker)
Underpins the 5-step visual tracking timeline displayed in the Customer Portal.

| Column Name | Data Type | Nullable | Primary/Foreign Key | Description |
|---|---|---|---|---|
| `HistoryId` | `INT` | No | **PK (Identity)** | Auto-increment ID |
| `OrderId` | `VARCHAR(20)` | No | **FK → Orders** | Associated order |
| `StepNumber` | `INT` | No | - | `1` to `5` |
| `StepName` | `VARCHAR(50)` | No | - | `Confirmed`, `In Production`, `Quality Check`, `Dispatched`, `Delivered` |
| `IsCompleted` | `BIT` | No | - | `1` = finished, `0` = pending |
| `CompletedAt` | `DATETIME2` | Yes | - | Timestamp when step completed |
| `Notes` | `NVARCHAR(255)` | Yes | - | Inspection/progress logs |

---

### 5. `RawMaterials` Table
Tracks corrugated manufacturing supplies in the factory warehouse.

| Column Name | Data Type | Nullable | Primary/Foreign Key | Description |
|---|---|---|---|---|
| `Sku` | `VARCHAR(50)` | No | **PK** | Item code (e.g. `MAT-011`, `MAT-012`) |
| `ItemName` | `NVARCHAR(150)` | No | - | Item description (e.g. `Kraft Paper Roll (200gsm)`) |
| `Category` | `NVARCHAR(100)` | No | - | Material type (`Paper Roll`, `Adhesive`, `Ink`, `Coating`) |
| `StockQty` | `DECIMAL(18,2)` | No | - | Current inventory quantity in stock |
| `ReorderAt` | `DECIMAL(18,2)` | No | - | Minimum safety stock reorder threshold |
| `Unit` | `VARCHAR(20)` | No | - | Measurement unit (`kg`, `liters`) |
| `StockLevel` | `VARCHAR(20)` | No | - | Current status badge: `Good`, `OK`, `Low` |
| `Supplier` | `NVARCHAR(150)` | No | - | Vendor name (e.g. `NorthPaper Ltd`) |

---

### 6. `FinishedStock` Table
Tracks completed corrugated boxes ready on pallets in the warehouse.

| Column Name | Data Type | Nullable | Primary/Foreign Key | Description |
|---|---|---|---|---|
| `ItemCode` | `VARCHAR(50)` | No | **PK** | Finished SKU (e.g. `FIN-501`, `FIN-302`) |
| `ItemDescription`| `NVARCHAR(150)` | No | - | Product description |
| `BoxSpecs` | `NVARCHAR(100)` | No | - | Dimensions (`40×30×25 cm`) |
| `AvailableQty` | `INT` | No | - | Pallet count available for immediate dispatch |
| `ReservedQty` | `INT` | No | - | Quantity reserved for active orders |
| `ReservedFor` | `NVARCHAR(150)` | Yes | - | Customer company name |
| `Pallets` | `VARCHAR(50)` | Yes | - | Number of pallets (e.g. `6 Pallets`) |
| `StockStatus` | `VARCHAR(50)` | No | - | Status: `Ready for Dispatch`, `Dispatched`, `Available` |

---

### 7. `Machines` Table
Live machine monitor powering the status bars on the Admin Dashboard.

| Column Name | Data Type | Nullable | Primary/Foreign Key | Description |
|---|---|---|---|---|
| `MachineId` | `INT` | No | **PK (Identity)** | Auto-increment machine ID |
| `MachineName` | `NVARCHAR(100)` | No | **Unique** | Machine name (`Cutter A`, `Printer Line 1`, `Gluer B`, `Die-Cut Press`) |
| `MachineStatus`| `VARCHAR(50)` | No | - | Status: `Running`, `Idle`, `Maintenance` |
| `SpeedMetric` | `NVARCHAR(100)` | No | - | Live metric (e.g. `87% speed \| 420 cuts/hr`) |
| `ProgressPercent`| `INT` | No | - | Progress bar fill percentage (`0` to `100`) |
| `BadgeClass` | `VARCHAR(50)` | No | - | CSS badge style class |
