using System;
using System.Collections.Generic;
using System.Linq;
using WebApplication1.Models;

namespace WebApplication1.Services
{
    public static class BoxFactoryRepository
    {
        private static readonly object _lock = new object();
        private static List<Customer> _customers;
        private static List<Order> _orders;
        private static List<InventoryItem> _rawMaterials;
        private static List<FinishedStockItem> _finishedStock;
        private static List<Machine> _machines;

        static BoxFactoryRepository()
        {
            SeedData();
        }

        public static void ResetToDefault()
        {
            lock (_lock)
            {
                SeedData();
            }
        }

        private static void SeedData()
        {
            _customers = new List<Customer>
            {
                new Customer
                {
                    Id = "CUST-001",
                    Name = "Apex Logistics",
                    City = "Mumbai, MH",
                    ContactPerson = "Rajesh Sharma",
                    Email = "logistics@apex.com",
                    Phone = "+91 98200 12345",
                    Address = "Plot 42, Andheri MIDC, Mumbai, Maharashtra 400093",
                    Segment = "Enterprise",
                    Status = "Active",
                    TotalOrders = 18,
                    TotalSpent = 432000m,
                    AvatarInitials = "AL",
                    AvatarColor = "#10b981", // Emerald
                    DefaultSpec = new BoxSpecification
                    {
                        Ply = "5 Ply",
                        GSM = "150 GSM",
                        Length = 40,
                        Width = 30,
                        Height = 25,
                        BaseRatePerBox = 48.00m
                    }
                },
                new Customer
                {
                    Id = "CUST-002",
                    Name = "Green Pack Co.",
                    City = "Pune, MH",
                    ContactPerson = "Vikram Patil",
                    Email = "orders@greenpack.co",
                    Phone = "+91 98220 54321",
                    Address = "Plot 18, Bhosari Industrial Area, Pune 411026",
                    Segment = "Enterprise",
                    Status = "Active",
                    TotalOrders = 31,
                    TotalSpent = 817000m,
                    AvatarInitials = "GP",
                    AvatarColor = "#3b82f6", // Blue
                    DefaultSpec = new BoxSpecification
                    {
                        Ply = "3 Ply",
                        GSM = "120 GSM",
                        Length = 30,
                        Width = 20,
                        Height = 15,
                        BaseRatePerBox = 32.00m
                    }
                },
                new Customer
                {
                    Id = "CUST-003",
                    Name = "Metro Supplies",
                    City = "Bengaluru, KA",
                    ContactPerson = "Anil Kumar",
                    Email = "purchase@metrosupplies.in",
                    Phone = "+91 98450 67890",
                    Address = "Whitefield Tech Park Road, Bengaluru 560066",
                    Segment = "Mid-Market",
                    Status = "Active",
                    TotalOrders = 9,
                    TotalSpent = 179000m,
                    AvatarInitials = "MS",
                    AvatarColor = "#f59e0b", // Amber
                    DefaultSpec = new BoxSpecification
                    {
                        Ply = "3 Ply",
                        GSM = "150 GSM",
                        Length = 35,
                        Width = 25,
                        Height = 20,
                        BaseRatePerBox = 40.00m
                    }
                },
                new Customer
                {
                    Id = "CUST-004",
                    Name = "StarBrand Inc.",
                    City = "Delhi, DL",
                    ContactPerson = "Meera Kapoor",
                    Email = "supply@starbrand.com",
                    Phone = "+91 98110 33445",
                    Address = "Okhla Industrial Phase III, New Delhi 110020",
                    Segment = "Mid-Market",
                    Status = "Active",
                    TotalOrders = 14,
                    TotalSpent = 365000m,
                    AvatarInitials = "SB",
                    AvatarColor = "#059669", // Dark Green
                    DefaultSpec = new BoxSpecification
                    {
                        Ply = "5 Ply",
                        GSM = "180 GSM",
                        Length = 45,
                        Width = 35,
                        Height = 30,
                        BaseRatePerBox = 52.00m
                    }
                },
                new Customer
                {
                    Id = "CUST-005",
                    Name = "QuickShip Ltd.",
                    City = "Ahmedabad, GJ",
                    ContactPerson = "Hardik Shah",
                    Email = "packaging@quickship.com",
                    Phone = "+91 98250 88990",
                    Address = "Sanand GIDC Gateway, Ahmedabad 382110",
                    Segment = "Enterprise",
                    Status = "Active",
                    TotalOrders = 27,
                    TotalSpent = 675000m,
                    AvatarInitials = "QS",
                    AvatarColor = "#0d9488", // Teal
                    DefaultSpec = new BoxSpecification
                    {
                        Ply = "5 Ply",
                        GSM = "150 GSM",
                        Length = 40,
                        Width = 30,
                        Height = 20,
                        BaseRatePerBox = 45.00m
                    }
                },
                new Customer
                {
                    Id = "CUST-006",
                    Name = "BlueSky Exports",
                    City = "Chennai, TN",
                    ContactPerson = "S. Ramachandran",
                    Email = "export@bluesky.com",
                    Phone = "+91 98400 11223",
                    Address = "Ambattur Industrial Estate, Chennai 600058",
                    Segment = "SMB",
                    Status = "Active",
                    TotalOrders = 6,
                    TotalSpent = 148000m,
                    AvatarInitials = "BE",
                    AvatarColor = "#8b5cf6", // Purple
                    DefaultSpec = new BoxSpecification
                    {
                        Ply = "7 Ply",
                        GSM = "200 GSM",
                        Length = 50,
                        Width = 40,
                        Height = 30,
                        BaseRatePerBox = 68.00m
                    }
                },
                new Customer
                {
                    Id = "CUST-007",
                    Name = "Nimbus Retail",
                    City = "Hyderabad, TS",
                    ContactPerson = "Priya Reddy",
                    Email = "store@nimbusretail.in",
                    Phone = "+91 98490 77889",
                    Address = "Cherlapally Industrial Area, Hyderabad 500051",
                    Segment = "SMB",
                    Status = "Active",
                    TotalOrders = 4,
                    TotalSpent = 76000m,
                    AvatarInitials = "NR",
                    AvatarColor = "#ef4444", // Red
                    DefaultSpec = new BoxSpecification
                    {
                        Ply = "3 Ply",
                        GSM = "120 GSM",
                        Length = 25,
                        Width = 20,
                        Height = 15,
                        BaseRatePerBox = 28.00m
                    }
                },
                new Customer
                {
                    Id = "CUST-008",
                    Name = "Crest Distribution",
                    City = "Jaipur, RJ",
                    ContactPerson = "Sanjay Choudhary",
                    Email = "ops@crestdistrib.com",
                    Phone = "+91 98290 66554",
                    Address = "Sitapura Industrial Area, Jaipur 302022",
                    Segment = "Mid-Market",
                    Status = "Active",
                    TotalOrders = 11,
                    TotalSpent = 298000m,
                    AvatarInitials = "CD",
                    AvatarColor = "#ec4899", // Pink
                    DefaultSpec = new BoxSpecification
                    {
                        Ply = "5 Ply",
                        GSM = "180 GSM",
                        Length = 42,
                        Width = 32,
                        Height = 28,
                        BaseRatePerBox = 50.00m
                    }
                }
            };

            _orders = new List<Order>
            {
                new Order
                {
                    Id = "ORD-1041",
                    CustomerId = "CUST-001",
                    CompanyName = "Apex Logistics",
                    Specs = new BoxSpecification { Ply = "5 Ply", GSM = "150 GSM", Length = 40, Width = 30, Height = 25, BaseRatePerBox = 48.00m },
                    Quantity = 500,
                    UnitPrice = 48.00m,
                    TotalPrice = 24000.00m,
                    PlacedBy = "Customer",
                    PlacedDate = DateTime.Now.AddDays(-3),
                    DueDate = DateTime.Now.AddDays(3),
                    ETA = DateTime.Now.AddDays(5).ToString("dd MMM yyyy"),
                    Status = "In Production",
                    StatusStep = 2,
                    IsFirstOrder = false,
                    IsRepeatOrder = false,
                    Notes = "Fragile dispatch, ensure corner guards applied.",
                    DeliveryAddress = "Plot 42, Andheri MIDC, Mumbai, Maharashtra 400093",
                    ContactNumber = "+91 98200 12345",
                    MachinesAssigned = "Cutter A & Printer Line 1"
                },
                new Order
                {
                    Id = "ORD-1040",
                    CustomerId = "CUST-002",
                    CompanyName = "Green Pack Co.",
                    Specs = new BoxSpecification { Ply = "3 Ply", GSM = "120 GSM", Length = 30, Width = 20, Height = 15, BaseRatePerBox = 32.00m },
                    Quantity = 1200,
                    UnitPrice = 32.00m,
                    TotalPrice = 38400.00m,
                    PlacedBy = "Customer",
                    PlacedDate = DateTime.Now.AddDays(-5),
                    DueDate = DateTime.Now.AddDays(0),
                    ETA = DateTime.Now.AddDays(1).ToString("dd MMM yyyy"),
                    Status = "Dispatched",
                    StatusStep = 4,
                    IsFirstOrder = false,
                    IsRepeatOrder = false,
                    Notes = "Standard eco-friendly packaging batch.",
                    DeliveryAddress = "Plot 18, Bhosari Industrial Area, Pune 411026",
                    ContactNumber = "+91 98220 54321",
                    MachinesAssigned = "Completed"
                },
                new Order
                {
                    Id = "ORD-1039",
                    CustomerId = "CUST-001",
                    CompanyName = "Apex Logistics",
                    Specs = new BoxSpecification { Ply = "5 Ply", GSM = "150 GSM", Length = 40, Width = 30, Height = 25, BaseRatePerBox = 48.00m },
                    Quantity = 750,
                    UnitPrice = 48.00m,
                    TotalPrice = 36000.00m,
                    PlacedBy = "Customer",
                    PlacedDate = DateTime.Now.AddDays(-7),
                    DueDate = DateTime.Now.AddDays(-3),
                    ETA = "Delivered",
                    Status = "Delivered",
                    StatusStep = 5,
                    IsFirstOrder = false,
                    IsRepeatOrder = true,
                    Notes = "Repeat order based on verified spec.",
                    DeliveryAddress = "Plot 42, Andheri MIDC, Mumbai, Maharashtra 400093",
                    ContactNumber = "+91 98200 12345",
                    MachinesAssigned = "Completed"
                },
                new Order
                {
                    Id = "ORD-1038",
                    CustomerId = "CUST-004",
                    CompanyName = "StarBrand Inc.",
                    Specs = new BoxSpecification { Ply = "5 Ply", GSM = "180 GSM", Length = 45, Width = 35, Height = 30, BaseRatePerBox = 48.00m },
                    Quantity = 750,
                    UnitPrice = 48.00m,
                    TotalPrice = 36000.00m,
                    PlacedBy = "Admin",
                    PlacedDate = DateTime.Now.AddDays(-10),
                    DueDate = DateTime.Now.AddDays(-4),
                    ETA = "Delivered",
                    Status = "Delivered",
                    StatusStep = 5,
                    IsFirstOrder = true,
                    IsRepeatOrder = false,
                    Notes = "Initial onboarding order with custom stamp.",
                    DeliveryAddress = "Okhla Industrial Phase III, New Delhi 110020",
                    ContactNumber = "+91 98110 33445",
                    MachinesAssigned = "Completed"
                },
                new Order
                {
                    Id = "ORD-1037",
                    CustomerId = "CUST-005",
                    CompanyName = "QuickShip Ltd.",
                    Specs = new BoxSpecification { Ply = "5 Ply", GSM = "150 GSM", Length = 40, Width = 30, Height = 20, BaseRatePerBox = 45.00m },
                    Quantity = 2000,
                    UnitPrice = 45.00m,
                    TotalPrice = 90000.00m,
                    PlacedBy = "Customer",
                    PlacedDate = DateTime.Now.AddDays(-12),
                    DueDate = DateTime.Now.AddDays(-6),
                    ETA = "Delivered",
                    Status = "Delivered",
                    StatusStep = 5,
                    IsFirstOrder = false,
                    IsRepeatOrder = true,
                    Notes = "Bulk delivery executed via truckload 4.",
                    DeliveryAddress = "Sanand GIDC Gateway, Ahmedabad 382110",
                    ContactNumber = "+91 98250 88990",
                    MachinesAssigned = "Completed"
                }
            };

            _rawMaterials = new List<InventoryItem>
            {
                new InventoryItem { Sku = "MAT-011", Name = "Kraft Paper Roll (200gsm)", Category = "Paper Roll", StockQty = 4200, ReorderAt = 1000, Unit = "kg", Level = "Good", Supplier = "NorthPaper Ltd" },
                new InventoryItem { Sku = "MAT-012", Name = "Kraft Paper Roll (300gsm)", Category = "Paper Roll", StockQty = 980, ReorderAt = 1000, Unit = "kg", Level = "Low", Supplier = "NorthPaper Ltd" },
                new InventoryItem { Sku = "MAT-013", Name = "Corrugating Medium", Category = "Fluting Medium", StockQty = 3100, ReorderAt = 800, Unit = "kg", Level = "Good", Supplier = "FlyteCo" },
                new InventoryItem { Sku = "MAT-014", Name = "Starch Adhesive", Category = "Adhesive", StockQty = 620, ReorderAt = 300, Unit = "liters", Level = "OK", Supplier = "BoralChem" },
                new InventoryItem { Sku = "MAT-015", Name = "Water-based Ink (Black)", Category = "Printing Ink", StockQty = 88, ReorderAt = 100, Unit = "liters", Level = "Low", Supplier = "CareInk Co" },
                new InventoryItem { Sku = "MAT-016", Name = "Wax Coating Compound", Category = "Coating", StockQty = 190, ReorderAt = 200, Unit = "kg", Level = "OK", Supplier = "CustTech" }
            };

            _finishedStock = new List<FinishedStockItem>
            {
                new FinishedStockItem { ItemCode = "FIN-501", Description = "5 Ply Standard Corrugated Box", BoxSpecs = "40×30×25 cm", AvailableQty = 1450, ReservedQty = 500, ReservedFor = "Apex Logistics", Pallets = "6 Pallets", Status = "Ready for Dispatch" },
                new FinishedStockItem { ItemCode = "FIN-302", Description = "3 Ply Lightweight Shipping Box", BoxSpecs = "30×20×15 cm", AvailableQty = 2800, ReservedQty = 1200, ReservedFor = "Green Pack Co.", Pallets = "8 Pallets", Status = "Dispatched" },
                new FinishedStockItem { ItemCode = "FIN-703", Description = "7 Ply Heavy Duty Export Box", BoxSpecs = "50×40×30 cm", AvailableQty = 620, ReservedQty = 0, ReservedFor = "-", Pallets = "3 Pallets", Status = "Available" },
                new FinishedStockItem { ItemCode = "FIN-504", Description = "5 Ply Reinforced Archive Box", BoxSpecs = "45×35×30 cm", AvailableQty = 900, ReservedQty = 750, ReservedFor = "StarBrand Inc.", Pallets = "4 Pallets", Status = "In Production" }
            };

            _machines = new List<Machine>
            {
                new Machine { Name = "Cutter A", Status = "Running", SpeedMetric = "87% speed | 420 cuts/hr", ProgressPercent = 85, BadgeClass = "badge-running" },
                new Machine { Name = "Printer Line 1", Status = "Running", SpeedMetric = "65% speed | 2-Color Flexo", ProgressPercent = 65, BadgeClass = "badge-running" },
                new Machine { Name = "Gluer B", Status = "Idle", SpeedMetric = "Warmup ready | Queue: 1,200", ProgressPercent = 20, BadgeClass = "badge-idle" },
                new Machine { Name = "Die-Cut Press", Status = "Maintenance", SpeedMetric = "Blade replacement | Resume: 45m", ProgressPercent = 0, BadgeClass = "badge-maintenance" }
            };
        }

        public static List<Customer> GetCustomers()
        {
            lock (_lock) { return _customers.ToList(); }
        }

        public static List<Order> GetOrders()
        {
            lock (_lock) { return _orders.ToList(); }
        }

        public static List<InventoryItem> GetRawMaterials()
        {
            lock (_lock) { return _rawMaterials.ToList(); }
        }

        public static List<FinishedStockItem> GetFinishedStock()
        {
            lock (_lock) { return _finishedStock.ToList(); }
        }

        public static List<Machine> GetMachines()
        {
            lock (_lock) { return _machines.ToList(); }
        }

        public static Order AddOrder(Order order)
        {
            lock (_lock)
            {
                if (string.IsNullOrEmpty(order.Id))
                {
                    int maxId = 1041;
                    foreach (var o in _orders)
                    {
                        if (o.Id.StartsWith("ORD-") && int.TryParse(o.Id.Substring(4), out int num) && num > maxId)
                        {
                            maxId = num;
                        }
                    }
                    order.Id = $"ORD-{maxId + 1}";
                }
                order.PlacedDate = DateTime.Now;
                order.DueDate = DateTime.Now.AddDays(7);
                order.ETA = DateTime.Now.AddDays(6).ToString("dd MMM yyyy");
                _orders.Insert(0, order);

                // Update customer order count
                var cust = _customers.FirstOrDefault(c => c.Id == order.CustomerId || c.Name.Equals(order.CompanyName, StringComparison.OrdinalIgnoreCase));
                if (cust != null)
                {
                    cust.TotalOrders += 1;
                    cust.TotalSpent += order.TotalPrice;
                }

                return order;
            }
        }

        public static bool UpdateOrderStatus(string orderId, string newStatus)
        {
            lock (_lock)
            {
                var order = _orders.FirstOrDefault(o => o.Id == orderId);
                if (order == null) return false;
                order.Status = newStatus;
                switch (newStatus.ToLower())
                {
                    case "confirmed": order.StatusStep = 1; break;
                    case "in production": order.StatusStep = 2; break;
                    case "quality check": order.StatusStep = 3; break;
                    case "dispatched": order.StatusStep = 4; break;
                    case "delivered": order.StatusStep = 5; break;
                    default: order.StatusStep = 1; break;
                }
                return true;
            }
        }

        public static bool RestockRawMaterial(string sku, decimal amount)
        {
            lock (_lock)
            {
                var item = _rawMaterials.FirstOrDefault(m => m.Sku == sku);
                if (item == null) return false;
                item.StockQty += amount;
                if (item.StockQty >= item.ReorderAt * 1.5m)
                    item.Level = "Good";
                else if (item.StockQty >= item.ReorderAt)
                    item.Level = "OK";
                else
                    item.Level = "Low";
                return true;
            }
        }

        public static Customer AddCustomer(Customer customer)
        {
            lock (_lock)
            {
                if (string.IsNullOrEmpty(customer.Id))
                {
                    customer.Id = $"CUST-00{_customers.Count + 1}";
                }
                customer.Status = "Active";
                customer.TotalOrders = 0;
                customer.TotalSpent = 0;
                if (string.IsNullOrEmpty(customer.AvatarInitials))
                {
                    var parts = customer.Name.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                    customer.AvatarInitials = parts.Length > 1 
                        ? $"{parts[0][0]}{parts[1][0]}".ToUpper() 
                        : (parts.Length == 1 && parts[0].Length > 1 ? parts[0].Substring(0, 2).ToUpper() : "CO");
                }
                if (string.IsNullOrEmpty(customer.AvatarColor))
                {
                    customer.AvatarColor = "#0d9488";
                }
                _customers.Add(customer);
                return customer;
            }
        }
    }
}
