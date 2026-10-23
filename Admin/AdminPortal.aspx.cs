using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using WebApplication1.Helpers;
using WebApplication1.Models;
using WebApplication1.Services;

namespace WebApplication1.AdminPages
{
    public partial class AdminPortal : Page
    {
        // ==========================================
        // PRELOADED JSON FOR CLIENT-SIDE ENGINE
        // ==========================================
        public string PreloadedJsonData { get; set; } = "{}";

        // ==========================================
        // STATE PROPERTIES (ViewState-backed)
        // ==========================================
        public string CurrentAdminTab
        {
            get => ViewState["CurrentAdminTab"] as string ?? "dashboard";
            set => ViewState["CurrentAdminTab"] = value;
        }

        public string OrderStatusFilter
        {
            get => ViewState["OrderStatusFilter"] as string ?? "All";
            set => ViewState["OrderStatusFilter"] = value;
        }

        public string CustomerSegmentFilter
        {
            get => ViewState["CustomerSegmentFilter"] as string ?? "All";
            set => ViewState["CustomerSegmentFilter"] = value;
        }

        // ==========================================
        // PAGE LIFECYCLE
        // ==========================================
        protected void Page_Load(object sender, EventArgs e)
        {
            // Guard: only Admin may access this page
            if (Session["Role"] as string != "Admin")
            {
                Response.Redirect("~/Admin/AdminLogin.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindAllData();
                PopulateStaticDropdowns();
            }
            else
            {
                if (!string.IsNullOrEmpty(hfAdminTab.Value))
                    CurrentAdminTab = hfAdminTab.Value;
            }
        }

        private void PopulateStaticDropdowns()
        {
            if (firstOrderPly.Items.Count == 0)
            {
                firstOrderPly.Items.Add(new ListItem("3 Ply", "3 Ply"));
                firstOrderPly.Items.Add(new ListItem("5 Ply", "5 Ply") { Selected = true });
                firstOrderPly.Items.Add(new ListItem("7 Ply", "7 Ply"));
            }

            if (firstOrderGsm.Items.Count == 0)
            {
                firstOrderGsm.Items.Add(new ListItem("120 GSM", "120 GSM"));
                firstOrderGsm.Items.Add(new ListItem("150 GSM", "150 GSM") { Selected = true });
                firstOrderGsm.Items.Add(new ListItem("180 GSM", "180 GSM"));
                firstOrderGsm.Items.Add(new ListItem("200 GSM", "200 GSM"));
                firstOrderGsm.Items.Add(new ListItem("250 GSM", "250 GSM"));
            }
        }

        // ==========================================
        // DATA BINDING
        // ==========================================
        public void BindAllData()
        {
            BindDashboardKPIs();
            BindRecentOrders();
            BindMachines();
            BindAllOrders();
            BindRawMaterials();
            BindFinishedStock();
            BindCustomers();
            BindRepeatCompanyDropdown();
            BindPreloadedJsonData();
            SyncHiddenFields();
        }

        private void SyncHiddenFields()
        {
            hfAdminTab.Value = CurrentAdminTab;
        }

        public void BindDashboardKPIs()
        {
            var orders    = BoxFactoryRepository.GetOrders();
            var customers = BoxFactoryRepository.GetCustomers();

            int totalBoxes = orders.Sum(o => o.Quantity);
            int pending    = orders.Count(o => !string.Equals(o.Status, "Delivered", StringComparison.OrdinalIgnoreCase));
            int activeCust = customers.Count(c => string.Equals(c.Status, "Active", StringComparison.OrdinalIgnoreCase));
            decimal revenue = orders.Sum(o => o.TotalPrice);

            lblTotalBoxesProduced.Text   = $"{totalBoxes:N0}";
            lblPendingOrdersCount.Text   = $"{pending}";
            lblActiveCustomersCount.Text = $"{activeCust}";
            lblTotalRevenueAmount.Text   = $"&#8377;{revenue / 100000m:0.#}L";

            lblTotalCustomersCount.Text    = $"{customers.Count}";
            lblActiveCustomersCountTab.Text = $"{activeCust}";
            lblTotalRevenueCustomers.Text  = $"&#8377;{customers.Sum(c => c.TotalSpent) / 100000m:0.#}L";
        }

        public void BindRecentOrders()
        {
            var recent = BoxFactoryRepository.GetOrders().Take(4).ToList();
            rptRecentOrders.DataSource = recent;
            rptRecentOrders.DataBind();
        }

        public void BindMachines()
        {
            var machines = BoxFactoryRepository.GetMachines();
            rptMachines.DataSource = machines;
            rptMachines.DataBind();
        }

        public void BindAllOrders()
        {
            var orders = BoxFactoryRepository.GetOrders();

            if (!string.IsNullOrEmpty(OrderStatusFilter) && !OrderStatusFilter.Equals("All", StringComparison.OrdinalIgnoreCase))
                orders = orders.Where(o => string.Equals(o.Status, OrderStatusFilter, StringComparison.OrdinalIgnoreCase)).ToList();

            string search = txtOrderSearch.Text.Trim();
            if (!string.IsNullOrEmpty(search))
                orders = orders.Where(o =>
                    (o.Id != null && o.Id.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0) ||
                    (o.CompanyName != null && o.CompanyName.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0)).ToList();

            rptAllOrders.DataSource = orders;
            rptAllOrders.DataBind();
        }

        public void BindRawMaterials()
        {
            rptRawMaterials.DataSource = BoxFactoryRepository.GetRawMaterials();
            rptRawMaterials.DataBind();
        }

        public void BindFinishedStock()
        {
            rptFinishedStock.DataSource = BoxFactoryRepository.GetFinishedStock();
            rptFinishedStock.DataBind();
        }

        public void BindCustomers()
        {
            var customers = BoxFactoryRepository.GetCustomers();

            if (!string.IsNullOrEmpty(CustomerSegmentFilter) && !CustomerSegmentFilter.Equals("All", StringComparison.OrdinalIgnoreCase))
                customers = customers.Where(c => string.Equals(c.Segment, CustomerSegmentFilter, StringComparison.OrdinalIgnoreCase)).ToList();

            string search = txtCustomerSearch.Text.Trim();
            if (!string.IsNullOrEmpty(search))
                customers = customers.Where(c =>
                    (c.Name != null && c.Name.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0) ||
                    (c.City != null && c.City.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0) ||
                    (c.ContactPerson != null && c.ContactPerson.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0)).ToList();

            rptCustomers.DataSource = customers;
            rptCustomers.DataBind();
        }

        private void BindRepeatCompanyDropdown()
        {
            var customers = BoxFactoryRepository.GetCustomers();
            string prev = repeatOrderCompanySelect.SelectedValue;
            repeatOrderCompanySelect.Items.Clear();
            repeatOrderCompanySelect.Items.Add(new ListItem("-- choose company --", ""));
            foreach (var c in customers)
                repeatOrderCompanySelect.Items.Add(new ListItem(c.Name, c.Id));

            if (!string.IsNullOrEmpty(prev) && repeatOrderCompanySelect.Items.FindByValue(prev) != null)
                repeatOrderCompanySelect.SelectedValue = prev;
        }

        private void BindPreloadedJsonData()
        {
            var payload = new
            {
                customers    = BoxFactoryRepository.GetCustomers(),
                orders       = BoxFactoryRepository.GetOrders(),
                rawMaterials = BoxFactoryRepository.GetRawMaterials(),
                finishedStock = BoxFactoryRepository.GetFinishedStock(),
                machines     = BoxFactoryRepository.GetMachines()
            };
            PreloadedJsonData = JsonConvert.SerializeObject(payload, Formatting.None);
        }

        // ==========================================
        // NAVIGATION EVENTS
        // ==========================================
        protected void btnNavAdminTab_Command(object sender, CommandEventArgs e)
        {
            CurrentAdminTab = e.CommandName;
            BindAllData();
        }

        protected void btnSignOut_Click(object sender, EventArgs e)
        {
            Session.Remove("Role");
            Response.Redirect("~/Default.aspx");
        }

        // ==========================================
        // FILTER & SEARCH EVENTS
        // ==========================================
        protected void btnFilterOrders_Command(object sender, CommandEventArgs e)
        {
            OrderStatusFilter = e.CommandName;
            BindAllOrders();
        }

        protected void txtOrderSearch_TextChanged(object sender, EventArgs e)
        {
            BindAllOrders();
        }

        protected void btnFilterCustomers_Command(object sender, CommandEventArgs e)
        {
            CustomerSegmentFilter = e.CommandName;
            BindCustomers();
        }

        protected void txtCustomerSearch_TextChanged(object sender, EventArgs e)
        {
            BindCustomers();
        }

        // ==========================================
        // REPEATER ITEM COMMANDS
        // ==========================================
        protected void rptAllOrders_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewInvoice")
                ShowInvoiceModal(e.CommandArgument.ToString());
        }

        protected void rptRawMaterials_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Restock")
            {
                string sku = e.CommandArgument.ToString();
                BoxFactoryRepository.RestockRawMaterial(sku, 500);
                ShowToast($"Restocked {sku} with +500!");
                BindRawMaterials();
                BindPreloadedJsonData();
            }
        }

        protected void rptCustomers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetail")
                ShowCustomerModal(e.CommandArgument.ToString());
        }

        // ==========================================
        // MODAL FORM SUBMISSIONS
        // ==========================================
        protected void repeatOrderCompanySelect_SelectedIndexChanged(object sender, EventArgs e)
        {
            string custId = repeatOrderCompanySelect.SelectedValue;
            var cust = BoxFactoryRepository.GetCustomers().FirstOrDefault(c => c.Id == custId);
            if (cust != null && cust.DefaultSpec != null)
            {
                int qty = int.TryParse(repeatOrderQty.Text, out int q) && q > 0 ? q : 100;
                repeatOrderTotal.Text = $"Total: &#8377;{qty * cust.DefaultSpec.BaseRatePerBox:N0}";
            }
        }

        protected void btnSubmitRepeatOrder_Click(object sender, EventArgs e)
        {
            string custId = repeatOrderCompanySelect.SelectedValue;
            if (string.IsNullOrEmpty(custId))
            {
                ShowToast("Please select a company to continue.");
                return;
            }

            int qty = int.TryParse(repeatOrderQty.Text, out int q) && q > 0 ? q : 100;
            var cust = BoxFactoryRepository.GetCustomers().FirstOrDefault(c => c.Id == custId);
            if (cust == null) return;

            var spec = cust.DefaultSpec ?? new BoxSpecification
            {
                Ply = "5 Ply", GSM = "150 GSM",
                Length = 40, Width = 30, Height = 25,
                BaseRatePerBox = 48.00m
            };

            var newOrder = new Order
            {
                CustomerId    = cust.Id,
                CompanyName   = cust.Name,
                Specs         = spec,
                Quantity      = qty,
                UnitPrice     = spec.BaseRatePerBox,
                TotalPrice    = spec.BaseRatePerBox * qty,
                PlacedBy      = "Admin",
                Status        = "In Production",
                StatusStep    = 2,
                IsFirstOrder  = false,
                IsRepeatOrder = true,
                Notes         = string.IsNullOrWhiteSpace(repeatOrderNotes.Text) ? "Repeat order based on verified specs." : repeatOrderNotes.Text,
                DeliveryAddress = cust.Address,
                ContactNumber   = cust.Phone,
                MachinesAssigned = "Cutter A"
            };

            var created = BoxFactoryRepository.AddOrder(newOrder);
            ShowToast($"Repeat order {created.Id} placed for {cust.Name}!");
            hfActiveModal.Value = "none";
            BindAllData();
        }

        protected void btnSubmitFirstOrder_Click(object sender, EventArgs e)
        {
            string compName = firstOrderCompanyName.Text.Trim();
            if (string.IsNullOrEmpty(compName))
            {
                ShowToast("Please enter company name.");
                return;
            }

            string city    = string.IsNullOrWhiteSpace(firstOrderCity.Text)    ? "Mumbai, MH"       : firstOrderCity.Text.Trim();
            string contact = string.IsNullOrWhiteSpace(firstOrderContact.Text) ? "Manager"           : firstOrderContact.Text.Trim();
            string email   = string.IsNullOrWhiteSpace(firstOrderEmail.Text)   ? "contact@company.com" : firstOrderEmail.Text.Trim();
            string ply     = firstOrderPly.SelectedValue;
            string gsm     = firstOrderGsm.SelectedValue;
            decimal l  = decimal.TryParse(firstOrderL.Text, out decimal lv) ? lv : 40;
            decimal w  = decimal.TryParse(firstOrderW.Text, out decimal wv) ? wv : 30;
            decimal h  = decimal.TryParse(firstOrderH.Text, out decimal hv) ? hv : 25;
            int qty    = int.TryParse(firstOrderQty.Text, out int q) && q > 0 ? q : 100;
            string notes = firstOrderNotes.Text.Trim();

            decimal rate = ply.Contains("3") ? 32m : (ply.Contains("7") ? 68m : 48m);

            var spec = new BoxSpecification
            {
                Ply = ply, GSM = gsm,
                Length = l, Width = w, Height = h,
                BaseRatePerBox = rate
            };

            var newCust = new Customer
            {
                Name          = compName,
                City          = city,
                ContactPerson = contact,
                Email         = email,
                Phone         = "+91 98000 00000",
                Address       = $"{compName} Facility, {city}",
                Segment       = "Mid-Market",
                DefaultSpec   = spec
            };

            var createdCust  = BoxFactoryRepository.AddCustomer(newCust);

            var order = new Order
            {
                CustomerId    = createdCust.Id,
                CompanyName   = createdCust.Name,
                Specs         = spec,
                Quantity      = qty,
                UnitPrice     = rate,
                TotalPrice    = rate * qty,
                PlacedBy      = "Admin",
                Status        = "Confirmed",
                StatusStep    = 1,
                IsFirstOrder  = true,
                IsRepeatOrder = false,
                Notes         = notes,
                DeliveryAddress  = createdCust.Address,
                ContactNumber    = createdCust.Phone,
                MachinesAssigned = "Cutter A"
            };

            var createdOrder = BoxFactoryRepository.AddOrder(order);
            ShowToast($"Customer {createdCust.Name} and Order {createdOrder.Id} created!");
            hfActiveModal.Value = "none";
            BindAllData();
        }

        // ==========================================
        // MODAL DISPLAY HELPERS
        // ==========================================
        private void ShowInvoiceModal(string orderId)
        {
            var o = BoxFactoryRepository.GetOrders().FirstOrDefault(ord => ord.Id == orderId);
            if (o == null) return;

            var spec = o.Specs ?? new BoxSpecification { Ply = "5 Ply", GSM = "150 GSM", Length = 40, Width = 30, Height = 25 };
            string html = $@"
<div style='border-bottom:1px solid #e2e8f0; padding-bottom:16px; margin-bottom:16px; display:flex; justify-content:space-between; align-items:flex-start;'>
    <div>
        <div style='font-size:18px; font-weight:800; color:#0f172a;'>BoxFactory Packaging Ltd.</div>
        <div style='font-size:12px; color:#64748b;'>Industrial Area Phase II, Maharashtra, India</div>
    </div>
    <div style='text-align:right;'>
        <span class='badge-status {GetStatusClass(o.Status)}'>{HttpUtility.HtmlEncode(o.Status)}</span>
        <div style='font-size:13px; font-weight:700; margin-top:4px;'>{HttpUtility.HtmlEncode(o.Id)}</div>
    </div>
</div>
<div style='font-size:13px; margin-bottom:16px;'>
    <div><strong>Billed To:</strong> {HttpUtility.HtmlEncode(o.CompanyName)}</div>
    <div><strong>Placed By:</strong> {HttpUtility.HtmlEncode(o.PlacedBy)} on {o.PlacedDate:dd MMM yyyy}</div>
    <div><strong>Delivery Address:</strong> {HttpUtility.HtmlEncode(o.DeliveryAddress ?? "On file")}</div>
</div>
<table class='data-table' style='margin-bottom:16px;'>
    <thead><tr><th>Description</th><th>Qty</th><th>Rate</th><th style='text-align:right;'>Amount</th></tr></thead>
    <tbody><tr>
        <td>Corrugated Box ({spec.Ply}, {spec.GSM})<br/><span style='font-size:11px; color:#64748b;'>{spec.DimensionsFormatted}</span></td>
        <td>{o.Quantity:N0}</td>
        <td>&#8377;{o.UnitPrice:0}</td>
        <td style='text-align:right;'><strong>&#8377;{o.TotalPrice:N0}</strong></td>
    </tr></tbody>
</table>
<div style='display:flex; justify-content:space-between; align-items:center; border-top:1px solid #e2e8f0; padding-top:12px;'>
    <div style='font-size:12px; color:#64748b;'>Includes 18% GST &amp; Shipping</div>
    <div style='font-size:18px; font-weight:800; color:#0f172a;'>Total: &#8377;{o.TotalPrice:N0}</div>
</div>
<div style='display:flex; justify-content:flex-end; gap:10px; margin-top:20px;'>
    <button type='button' class='btn-secondary-outline' onclick='window.print()'>Print Receipt</button>
</div>";

            genericModalTitle.Text     = "Order Receipt &amp; Invoice";
            litGenericModalContent.Text = html;
            hfActiveModal.Value         = "generic";
            ScriptManager.RegisterStartupScript(this, GetType(), "OpenModal",
                "document.getElementById('modalGeneric').classList.add('modal-open');", true);
        }

        private void ShowCustomerModal(string custId)
        {
            var c = BoxFactoryRepository.GetCustomers().FirstOrDefault(cust => cust.Id == custId);
            if (c == null) return;

            var spec = c.DefaultSpec ?? new BoxSpecification { Ply = "5 Ply", GSM = "150 GSM", Length = 40, Width = 30, Height = 25, BaseRatePerBox = 48 };
            string html = $@"
<div style='display:flex; align-items:center; gap:14px; margin-bottom:16px;'>
    <div class='customer-avatar-box' style='background-color:{c.AvatarColor ?? "#0d9488"}; width:50px; height:50px; font-size:18px;'>{HttpUtility.HtmlEncode(c.AvatarInitials)}</div>
    <div>
        <h3 style='font-size:20px; font-weight:700;'>{HttpUtility.HtmlEncode(c.Name)}</h3>
        <div style='font-size:13px; color:#64748b;'>{HttpUtility.HtmlEncode(c.City)} &bull; {HttpUtility.HtmlEncode(c.Segment)}</div>
    </div>
</div>
<div style='background:#f8fafc; border:1px solid #e2e8f0; border-radius:10px; padding:16px; margin-bottom:16px;'>
    <div style='font-size:11px; font-weight:700; color:#64748b; text-transform:uppercase; margin-bottom:8px;'>Saved Box Specification</div>
    <div style='font-size:15px; font-weight:700; color:#0f172a;'>{spec.Ply} &middot; {spec.GSM}</div>
    <div style='font-size:13px; color:#475569; margin-top:2px;'>Dimensions: {spec.DimensionsFormatted} | Standard Rate: &#8377;{spec.BaseRatePerBox:0}/box</div>
</div>
<div style='font-size:13px; margin-bottom:16px;'>
    <div><strong>Contact:</strong> {HttpUtility.HtmlEncode(c.ContactPerson ?? "Primary Contact")}</div>
    <div><strong>Email:</strong> {HttpUtility.HtmlEncode(c.Email)}</div>
    <div><strong>Total Orders:</strong> {c.TotalOrders} | <strong>Total Spent:</strong> &#8377;{Math.Round(c.TotalSpent / 1000m)}K</div>
</div>";

            genericModalTitle.Text     = "Customer Profile";
            litGenericModalContent.Text = html;
            hfActiveModal.Value         = "generic";
            ScriptManager.RegisterStartupScript(this, GetType(), "OpenModal",
                "document.getElementById('modalGeneric').classList.add('modal-open');", true);
        }

        // ==========================================
        // TEMPLATE BINDING HELPERS (delegates to shared BoxFactoryHelpers)
        // ==========================================
        public string GetStatusClass(string status)   => BoxFactoryHelpers.GetStatusClass(status);
        public string GetLevelClass(string level)     => BoxFactoryHelpers.GetLevelClass(level);
        public string GetSpecsText(object specsObj)   => BoxFactoryHelpers.GetSpecsText(specsObj);
        public string FormatDate(object dtObj)        => BoxFactoryHelpers.FormatDate(dtObj);

        public string GetAdminTabDisplay(string tabName) => CurrentAdminTab == tabName ? "block" : "none";
        public string GetAdminTabClass(string tabName)   => CurrentAdminTab == tabName ? "sidebar-nav-item active" : "sidebar-nav-item";

        public void ShowToast(string message)
        {
            toastNotification.Text     = HttpUtility.HtmlEncode(message);
            toastNotification.CssClass = "toast-notice toast-show";
            ScriptManager.RegisterStartupScript(this, GetType(), "ToastAlert_" + Guid.NewGuid().ToString("N"),
                $"if (window.BoxApp && window.BoxApp.showToast) {{ window.BoxApp.showToast('{HttpUtility.JavaScriptStringEncode(message)}'); }}", true);
        }

        // ==========================================
        // STATIC WEBMETHODS (AJAX)
        // ==========================================
        [WebMethod]
        public static string GetLiveState()
        {
            var payload = new
            {
                success      = true,
                customers    = BoxFactoryRepository.GetCustomers(),
                orders       = BoxFactoryRepository.GetOrders(),
                rawMaterials = BoxFactoryRepository.GetRawMaterials(),
                finishedStock = BoxFactoryRepository.GetFinishedStock(),
                machines     = BoxFactoryRepository.GetMachines()
            };
            return JsonConvert.SerializeObject(payload);
        }

        [WebMethod]
        public static string UpdateOrderStatus(string orderId, string status)
        {
            try
            {
                bool success = BoxFactoryRepository.UpdateOrderStatus(orderId, status);
                return JsonConvert.SerializeObject(new { success, message = success ? $"Order {orderId} status updated to {status}" : "Order not found" });
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new { success = false, message = ex.Message });
            }
        }

        [WebMethod]
        public static string RestockItem(string sku, decimal amount)
        {
            try
            {
                bool success = BoxFactoryRepository.RestockRawMaterial(sku, amount);
                return JsonConvert.SerializeObject(new { success, message = success ? $"Restocked {sku} with +{amount}!" : "Item not found" });
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new { success = false, message = ex.Message });
            }
        }

        [WebMethod]
        public static string CreateCompanyAndOrder(string companyName, string city, string contactPerson,
            string email, string ply, string gsm, decimal length, decimal width, decimal height,
            int quantity, string notes)
        {
            try
            {
                decimal rate = ply.Contains("3") ? 32m : (ply.Contains("7") ? 68m : 48m);
                var spec = new BoxSpecification
                {
                    Ply = ply, GSM = gsm,
                    Length = length, Width = width, Height = height,
                    BaseRatePerBox = rate
                };
                var newCust = new Customer
                {
                    Name = companyName,
                    City = string.IsNullOrWhiteSpace(city) ? "Mumbai, MH" : city,
                    ContactPerson = contactPerson,
                    Email  = email,
                    Phone  = "+91 98000 00000",
                    Address = $"{companyName} Industrial Facility, {city}",
                    Segment = "Enterprise",
                    DefaultSpec = spec
                };
                var createdCust  = BoxFactoryRepository.AddCustomer(newCust);
                var order = new Order
                {
                    CustomerId = createdCust.Id, CompanyName = createdCust.Name,
                    Specs = spec, Quantity = quantity, UnitPrice = rate, TotalPrice = rate * quantity,
                    PlacedBy = "Admin", Status = "Confirmed", StatusStep = 1,
                    IsFirstOrder = true, IsRepeatOrder = false, Notes = notes,
                    DeliveryAddress = createdCust.Address, ContactNumber = createdCust.Phone,
                    MachinesAssigned = "Cutter A"
                };
                var createdOrder = BoxFactoryRepository.AddOrder(order);
                return JsonConvert.SerializeObject(new
                {
                    success = true, customer = createdCust, order = createdOrder,
                    message = $"Customer {createdCust.Name} and Order {createdOrder.Id} created successfully!"
                });
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new { success = false, message = ex.Message });
            }
        }

        [WebMethod]
        public static string ResetToDefaults()
        {
            BoxFactoryRepository.ResetToDefault();
            return JsonConvert.SerializeObject(new { success = true, message = "Demo state reset to original Figma design values." });
        }
    }
}
