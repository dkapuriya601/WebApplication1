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
        public string Id { get; set; }
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
        public string Id { get; set; }
        public string CustomerId { get; set; }
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

    public class InventoryItem
    {
        public string Sku { get; set; }
        public string Name { get; set; }
        public string Category { get; set; }
        public decimal StockQty { get; set; }
        public decimal ReorderAt { get; set; }
        public string Unit { get; set; } // "kg", "liters"
        public string Level { get; set; } // "Good", "OK", "Low"
        public string Supplier { get; set; }
    }

    public class FinishedStockItem
    {
        public string ItemCode { get; set; }
        public string Description { get; set; }
        public string BoxSpecs { get; set; }
        public int AvailableQty { get; set; }
        public int ReservedQty { get; set; }
        public string ReservedFor { get; set; }
        public string Pallets { get; set; }
        public string Status { get; set; }
    }

    public class Machine
    {
        public string Name { get; set; }
        public string Status { get; set; } // "Running", "Idle", "Maintenance"
        public string SpeedMetric { get; set; }
        public int ProgressPercent { get; set; }
        public string BadgeClass { get; set; }
    }
}
