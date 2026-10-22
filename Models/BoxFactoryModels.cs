using System;
using System.Collections.Generic;
using System.Linq;

namespace WebApplication1.Models
{
    public class BoxSpecification
    {
        public string Ply { get; set; } // e.g. "5 Ply"
        public string GSM { get; set; } // e.g. "150 GSM"
        public decimal Length { get; set; } // cm
        public decimal Width { get; set; } // cm
        public decimal Height { get; set; } // cm
        public decimal BaseRatePerBox { get; set; } // e.g. 48.00

        public string DimensionsFormatted => $"{Length}×{Width}×{Height} cm";
        public string SummaryFormatted => $"{Ply} · {GSM} / {DimensionsFormatted}";
    }

    public class Customer
    {
        public string Id { get; set; } // Primary Key (e.g. CUST-001)
        public string Name { get; set; }
        public string City { get; set; }
        public string ContactPerson { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string Address { get; set; }
        public string Segment { get; set; } // "Enterprise", "Mid-Market", "SMB"
        public string Status { get; set; } // "Active", "Inactive"
        public int TotalOrders { get; set; }
        public decimal TotalSpent { get; set; }
        public string TotalSpentFormatted => $"\u20B9{TotalSpent / 1000m:0}K";
        public string AvatarInitials { get; set; }
        public string AvatarColor { get; set; }
        public BoxSpecification DefaultSpec { get; set; }
    }

    public class Order
    {
        public string Id { get; set; } // Primary Key (e.g. ORD-1041)
        public string CustomerId { get; set; } // Foreign Key -> Customer.Id
        public string CompanyName { get; set; }
        public BoxSpecification Specs { get; set; }
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal TotalPrice { get; set; }
        public string PlacedBy { get; set; } // "Customer", "Admin"
        public DateTime PlacedDate { get; set; }
        public DateTime DueDate { get; set; }
        public string ETA { get; set; }
        public string Status { get; set; } // "Pending", "Confirmed", "In Production", "Quality Check", "Dispatched", "Delivered"
        public int StatusStep { get; set; } // 1..5
        public bool IsFirstOrder { get; set; }
        public bool IsRepeatOrder { get; set; }
        public string Notes { get; set; }
        public string DeliveryAddress { get; set; }
        public string ContactNumber { get; set; }
        public string MachinesAssigned { get; set; }
    }

    public class Supplier
    {
        public int Id { get; set; } // Primary Key
        public string Code { get; set; }
        public string Name { get; set; }
        public string ContactPerson { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
    }

    public class InventoryItem
    {
        public string Sku { get; set; } // Primary Key (e.g. MAT-011)
        public string Name { get; set; }
        public string Category { get; set; }
        public decimal StockQty { get; set; }
        public decimal ReorderAt { get; set; }
        public string Unit { get; set; } // "kg", "liters"
        public string Level { get; set; } // "Good", "OK", "Low"
        public int? SupplierId { get; set; } // Foreign Key -> Supplier.Id
        public string Supplier { get; set; }
    }

    public class FinishedStockItem
    {
        public string ItemCode { get; set; } // Primary Key (e.g. FIN-501)
        public string Description { get; set; }
        public string BoxSpecs { get; set; }
        public int AvailableQty { get; set; }
        public int ReservedQty { get; set; }
        public string CustomerId { get; set; } // Foreign Key -> Customer.Id
        public string OrderId { get; set; }    // Foreign Key -> Order.Id
        public string ReservedFor { get; set; }
        public string Pallets { get; set; }
        public string Status { get; set; }
    }

    public class Machine
    {
        public int Id { get; set; } // Primary Key
        public string Name { get; set; }
        public string Status { get; set; } // "Running", "Idle", "Maintenance"
        public string SpeedMetric { get; set; }
        public int ProgressPercent { get; set; }
        public string BadgeClass { get; set; }
    }

    public class UserAccount
    {
        public int Id { get; set; } // Primary Key
        public string Email { get; set; }
        public string FullName { get; set; }
        public string Role { get; set; } // "Admin", "Customer"
        public string CustomerId { get; set; } // Foreign Key -> Customer.Id
        public bool IsActive { get; set; }
    }

    public class OrderStatusHistoryItem
    {
        public int Id { get; set; } // Primary Key
        public string OrderId { get; set; } // Foreign Key -> Order.Id
        public int StepNumber { get; set; }
        public string StepName { get; set; }
        public bool IsCompleted { get; set; }
        public DateTime? CompletedAt { get; set; }
        public string Notes { get; set; }
    }

    public class OrderMachineAssignment
    {
        public int Id { get; set; } // Primary Key
        public string OrderId { get; set; } // Foreign Key -> Order.Id
        public int MachineId { get; set; }  // Foreign Key -> Machine.Id
        public string MachineName { get; set; }
        public string Status { get; set; }
    }

    public class OrderMaterialUsage
    {
        public int Id { get; set; } // Primary Key
        public string OrderId { get; set; } // Foreign Key -> Order.Id
        public string Sku { get; set; }     // Foreign Key -> InventoryItem.Sku
        public decimal QuantityUsed { get; set; }
        public string Unit { get; set; }
    }
}
