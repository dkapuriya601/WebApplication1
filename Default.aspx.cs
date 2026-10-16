using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using WebApplication1.Models;
using WebApplication1.Services;

namespace WebApplication1
{
    public partial class _Default : Page
    {
        public string PreloadedJsonData { get; set; } = "{}";

        public string CurrentScreen
        {
            get => ViewState["CurrentScreen"] as string ?? "role-select";
            set => ViewState["CurrentScreen"] = value;
        }

        public string CurrentAdminTab
        {
            get => ViewState["CurrentAdminTab"] as string ?? "dashboard";
            set => ViewState["CurrentAdminTab"] = value;
        }

        public string CurrentCustomerTab
        {
            get => ViewState["CurrentCustomerTab"] as string ?? "home";
            set => ViewState["CurrentCustomerTab"] = value;
        }

        public string CurrentCustomerId
        {
            get => ViewState["CurrentCustomerId"] as string ?? "CUST-001";
            set => ViewState["CurrentCustomerId"] = value;
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

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindAllData();
                PopulateStaticDropdowns();
            }
            else
            {
                // Synchronize state from client hidden fields if present
                if (!string.IsNullOrEmpty(hfCurrentScreen.Value))
                    CurrentScreen = hfCurrentScreen.Value;
                if (!string.IsNullOrEmpty(hfAdminTab.Value))
                    CurrentAdminTab = hfAdminTab.Value;
                if (!string.IsNullOrEmpty(hfCustomerTab.Value))
                    CurrentCustomerTab = hfCustomerTab.Value;
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

        public void BindAllData()
        {
            BindDashboardKPIs();
            BindRecentOrders();
            BindMachines();
            BindAllOrders();
            BindRawMaterials();
            BindFinishedStock();
            BindCustomers();
            BindCustomerPortal();
            BindRepeatCompanyDropdown();
            BindPreloadedJsonData();
            SyncHiddenFields();
        }

        private void SyncHiddenFields()
        {
            hfCurrentScreen.Value = CurrentScreen;
            hfAdminTab.Value = CurrentAdminTab;
            hfCustomerTab.Value = CurrentCustomerTab;
        }

        public void BindDashboardKPIs()
        {
            var orders = BoxFactoryRepository.GetOrders();
            var customers = BoxFactoryRepository.GetCustomers();

            int totalBoxes = orders.Sum(o => o.Quantity);
            int pending = orders.Count(o => !string.Equals(o.Status, "Delivered", StringComparison.OrdinalIgnoreCase));
            int activeCust = customers.Count(c => string.Equals(c.Status, "Active", StringComparison.OrdinalIgnoreCase));
            decimal revenue = orders.Sum(o => o.TotalPrice);

            lblTotalBoxesProduced.Text = $"{totalBoxes:N0}";
            lblPendingOrdersCount.Text = $"{pending}";
            lblActiveCustomersCount.Text = $"{activeCust}";
            lblTotalRevenueAmount.Text = $"&#8377;{revenue / 100000m:0.#}L";

            lblTotalCustomersCount.Text = $"{customers.Count}";
            lblActiveCustomersCountTab.Text = $"{activeCust}";
            lblTotalRevenueCustomers.Text = $"&#8377;{customers.Sum(c => c.TotalSpent) / 100000m:0.#}L";
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
            {
                orders = orders.Where(o => string.Equals(o.Status, OrderStatusFilter, StringComparison.OrdinalIgnoreCase)).ToList();
            }

            string search = txtOrderSearch.Text.Trim();
            if (!string.IsNullOrEmpty(search))
            {
                orders = orders.Where(o => (o.Id != null && o.Id.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0) ||
                                           (o.CompanyName != null && o.CompanyName.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0)).ToList();
            }

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
            {
                customers = customers.Where(c => string.Equals(c.Segment, CustomerSegmentFilter, StringComparison.OrdinalIgnoreCase)).ToList();
            }

            string search = txtCustomerSearch.Text.Trim();
            if (!string.IsNullOrEmpty(search))
            {
                customers = customers.Where(c => (c.Name != null && c.Name.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0) ||
                                                 (c.City != null && c.City.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0) ||
                                                 (c.ContactPerson != null && c.ContactPerson.IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0)).ToList();
            }

            rptCustomers.DataSource = customers;
            rptCustomers.DataBind();
        }

        public void BindCustomerPortal()
        {
            var customers = BoxFactoryRepository.GetCustomers();
            var cust = customers.FirstOrDefault(c => c.Id == CurrentCustomerId) ?? customers.First();

            custWelcomeName.Text = HttpUtility.HtmlEncode(cust.Name);
            custIdTag.Text = $"{cust.Id} | {cust.City}";

            var myOrders = BoxFactoryRepository.GetOrders()
                .Where(o => o.CustomerId == cust.Id || o.CompanyName.Equals(cust.Name, StringComparison.OrdinalIgnoreCase))
                .ToList();

            int activeCount = myOrders.Count(o => !string.Equals(o.Status, "Delivered", StringComparison.OrdinalIgnoreCase));
            custStatOrders.Text = myOrders.Count.ToString();
            custStatActive.Text = activeCount.ToString();
            custStatSpent.Text = $"&#8377;{Math.Round(cust.TotalSpent / 1000m)}K";

            var spec = cust.DefaultSpec ?? new BoxSpecification
            {
                Ply = "5 Ply",
                GSM = "150 GSM",
                Length = 40,
                Width = 30,
                Height = 25,
                BaseRatePerBox = 48.00m
            };

            custSpecPly.Text = spec.Ply;
            custSpecGsm.Text = spec.GSM;
            custSpecDims.Text = $"{spec.Length}&times;{spec.Width}&times;{spec.Height} cm";
            custSpecRate.Text = $"&#8377;{spec.BaseRatePerBox:0}/box";

            placeOrderSpecInline.Text = $"{spec.Ply} &middot; {spec.GSM} &middot; {spec.Length}&times;{spec.Width}&times;{spec.Height} cm";
            summaryBoxType.Text = spec.Ply;
            summaryBoxGsm.Text = spec.GSM;
            summaryBoxSize.Text = $"{spec.Length}&times;{spec.Width}&times;{spec.Height} cm";
            summaryBoxRate.Text = $"&#8377;{spec.BaseRatePerBox:0}/box";

            int qty = int.TryParse(placeOrderQtyInput.Text, out int q) && q > 0 ? q : 100;
            summaryBoxQty.Text = $"{qty} boxes";
            summaryTotalVal.Text = $"&#8377;{qty * spec.BaseRatePerBox:N0}";

            rptCustRecentOrders.DataSource = myOrders.Take(2).ToList();
            rptCustRecentOrders.DataBind();

            rptCustAllOrders.DataSource = myOrders;
            rptCustAllOrders.DataBind();

            // Bind active tracking order
            var activeOrder = myOrders.FirstOrDefault(o => !string.Equals(o.Status, "Delivered", StringComparison.OrdinalIgnoreCase))
                              ?? myOrders.FirstOrDefault();

            if (activeOrder != null)
            {
                pnlActiveTrackOrder.Visible = true;
                lblTrackOrderId.Text = activeOrder.Id;
                lblTrackStatusBadge.Text = activeOrder.Status;
                lblTrackStatusBadge.CssClass = $"badge-status {GetStatusClass(activeOrder.Status)}";
                lblTrackSpecs.Text = activeOrder.Specs != null ? $"{activeOrder.Specs.Ply} &middot; {activeOrder.Specs.GSM} &middot; {activeOrder.Specs.DimensionsFormatted}" : "5 Ply";
                lblTrackQty.Text = $"{activeOrder.Quantity:N0} boxes";
                lblTrackAmount.Text = $"&#8377;{activeOrder.TotalPrice:N0}";
                lblTrackETA.Text = activeOrder.ETA ?? "21 Oct 2026";
                lblTrackMachines.Text = activeOrder.MachinesAssigned ?? "Cutter A & Printer Line 1";
                lblTrackAddress.Text = activeOrder.DeliveryAddress ?? cust.Address;
                lblTrackContact.Text = activeOrder.ContactNumber ?? cust.Phone;
            }
            else
            {
                pnlActiveTrackOrder.Visible = false;
            }
        }

        private void BindRepeatCompanyDropdown()
        {
            var customers = BoxFactoryRepository.GetCustomers();
            string prev = repeatOrderCompanySelect.SelectedValue;
            repeatOrderCompanySelect.Items.Clear();
            repeatOrderCompanySelect.Items.Add(new ListItem("-- choose company --", ""));
            foreach (var c in customers)
            {
                repeatOrderCompanySelect.Items.Add(new ListItem(c.Name, c.Id));
            }
            if (!string.IsNullOrEmpty(prev) && repeatOrderCompanySelect.Items.FindByValue(prev) != null)
            {
                repeatOrderCompanySelect.SelectedValue = prev;
            }
        }

        private void BindPreloadedJsonData()
        {
            var payload = new
            {
                customers = BoxFactoryRepository.GetCustomers(),
                orders = BoxFactoryRepository.GetOrders(),
                rawMaterials = BoxFactoryRepository.GetRawMaterials(),
                finishedStock = BoxFactoryRepository.GetFinishedStock(),
                machines = BoxFactoryRepository.GetMachines()
            };

            PreloadedJsonData = JsonConvert.SerializeObject(payload, Formatting.None);
        }

        public void ShowToast(string message)
        {
            toastNotification.Text = HttpUtility.HtmlEncode(message);
            toastNotification.CssClass = "toast-notice toast-show";
            ScriptManager.RegisterStartupScript(this, GetType(), "ToastAlert_" + Guid.NewGuid().ToString("N"),
                $"if (window.BoxApp && window.BoxApp.showToast) {{ window.BoxApp.showToast('{HttpUtility.JavaScriptStringEncode(message)}'); }}", true);
        }

        // ==========================================
        // AUTHENTICATION & NAVIGATION EVENTS
        // ==========================================
        protected void btnAdminLogin_Click(object sender, EventArgs e)
        {
            string email = adminLoginEmail.Text.Trim();
            string pwd = adminLoginPassword.Text.Trim();

            if ((email.Equals("admin@boxfactory.in", StringComparison.OrdinalIgnoreCase) && pwd == "admin123") ||
                email.IndexOf("admin", StringComparison.OrdinalIgnoreCase) >= 0)
            {
                CurrentScreen = "admin-portal";
                CurrentAdminTab = "dashboard";
                ShowToast("Welcome back, Factory Admin!");
                BindAllData();
            }
            else
            {
                ShowToast("Invalid Admin credentials. Try admin@boxfactory.in / admin123");
            }
        }

        protected void btnCustomerLogin_Click(object sender, EventArgs e)
        {
            string email = customerLoginEmail.Text.Trim();
            var customers = BoxFactoryRepository.GetCustomers();
            var cust = customers.FirstOrDefault(c => c.Email.Equals(email, StringComparison.OrdinalIgnoreCase))
                       ?? customers.FirstOrDefault();

            if (cust != null)
            {
                CurrentCustomerId = cust.Id;
                CurrentScreen = "customer-portal";
                CurrentCustomerTab = "home";
                ShowToast($"Welcome back, {cust.Name}!");
                BindAllData();
            }
            else
            {
                ShowToast("Customer account not found.");
            }
        }

        protected void btnQuickAdmin_Click(object sender, EventArgs e)
        {
            adminLoginEmail.Text = "admin@boxfactory.in";
            adminLoginPassword.Text = "admin123";
            btnAdminLogin_Click(sender, e);
        }

        protected void btnQuickCustomer_Click(object sender, EventArgs e)
        {
            customerLoginEmail.Text = "logistics@apex.com";
            customerLoginPassword.Text = "apex123";
            btnCustomerLogin_Click(sender, e);
        }

        protected void btnSignOut_Click(object sender, EventArgs e)
        {
            CurrentScreen = "role-select";
            ShowToast("Signed out successfully.");
            SyncHiddenFields();
        }

        protected void btnNavScreen_Command(object sender, CommandEventArgs e)
        {
            CurrentScreen = e.CommandName;
            if (!string.IsNullOrEmpty((string)e.CommandArgument))
            {
                if (CurrentScreen == "admin-portal")
                    CurrentAdminTab = (string)e.CommandArgument;
                else if (CurrentScreen == "customer-portal")
                    CurrentCustomerTab = (string)e.CommandArgument;
            }
            BindAllData();
        }

        protected void btnNavAdminTab_Command(object sender, CommandEventArgs e)
        {
            CurrentAdminTab = e.CommandName;
            BindAllData();
        }

        protected void btnNavCustomerTab_Command(object sender, CommandEventArgs e)
        {
            CurrentCustomerTab = e.CommandName;
            BindAllData();
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
        // ORDER STATUS UPDATE & REPEATERS
        // ==========================================
        protected void ddlStatusSelect_SelectedIndexChanged(object sender, EventArgs e)
        {
            var ddl = (DropDownList)sender;
            var item = (RepeaterItem)ddl.NamingContainer;
            var hfOrderId = (HiddenField)item.FindControl("hfOrderId");

            if (hfOrderId != null && !string.IsNullOrEmpty(hfOrderId.Value))
            {
                string orderId = hfOrderId.Value;
                string newStatus = ddl.SelectedValue;
                BoxFactoryRepository.UpdateOrderStatus(orderId, newStatus);
                ShowToast($"Order {orderId} status updated to {newStatus}");
                BindAllData();
            }
        }

        protected void rptAllOrders_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewInvoice")
            {
                string orderId = e.CommandArgument.ToString();
                ShowInvoiceModal(orderId);
            }
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
            {
                string custId = e.CommandArgument.ToString();
                ShowCustomerModal(custId);
            }
        }

        protected void rptCustAllOrders_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewReceipt")
            {
                string orderId = e.CommandArgument.ToString();
                ShowInvoiceModal(orderId);
            }
        }

        // ==========================================
        // CUSTOMER PLACE ORDER
        // ==========================================
        protected void btnSubmitCustomerOrder_Click(object sender, EventArgs e)
        {
            int qty = int.TryParse(placeOrderQtyInput.Text, out int q) && q > 0 ? q : 100;
            var customers = BoxFactoryRepository.GetCustomers();
            var cust = customers.FirstOrDefault(c => c.Id == CurrentCustomerId) ?? customers.First();

            var spec = cust.DefaultSpec ?? new BoxSpecification
            {
                Ply = "5 Ply",
                GSM = "150 GSM",
                Length = 40,
                Width = 30,
                Height = 25,
                BaseRatePerBox = 48.00m
            };

            var newOrder = new Order
            {
                CustomerId = cust.Id,
                CompanyName = cust.Name,
                Specs = spec,
                Quantity = qty,
                UnitPrice = spec.BaseRatePerBox,
                TotalPrice = spec.BaseRatePerBox * qty,
                PlacedBy = "Customer",
                Status = "In Production",
                StatusStep = 2,
                IsFirstOrder = false,
                IsRepeatOrder = true,
                Notes = string.IsNullOrWhiteSpace(placeOrderNotes.Text) ? "Repeat order based on saved specifications." : placeOrderNotes.Text,
                DeliveryAddress = string.IsNullOrWhiteSpace(placeOrderAddress.Text) ? cust.Address : placeOrderAddress.Text,
                ContactNumber = string.IsNullOrWhiteSpace(placeOrderPhone.Text) ? cust.Phone : placeOrderPhone.Text,
                MachinesAssigned = "Cutter A & Printer Line 1"
            };

            var created = BoxFactoryRepository.AddOrder(newOrder);
            ShowToast($"Order {created.Id} placed successfully! Sent to production.");
            CurrentCustomerTab = "track-order";
            BindAllData();
        }

        // ==========================================
        // MODAL ACTIONS
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
                Ply = "5 Ply",
                GSM = "150 GSM",
                Length = 40,
                Width = 30,
                Height = 25,
                BaseRatePerBox = 48.00m
            };

            var newOrder = new Order
            {
                CustomerId = cust.Id,
                CompanyName = cust.Name,
                Specs = spec,
                Quantity = qty,
                UnitPrice = spec.BaseRatePerBox,
                TotalPrice = spec.BaseRatePerBox * qty,
                PlacedBy = "Admin",
                Status = "In Production",
                StatusStep = 2,
                IsFirstOrder = false,
                IsRepeatOrder = true,
                Notes = string.IsNullOrWhiteSpace(repeatOrderNotes.Text) ? "Repeat order based on verified specs." : repeatOrderNotes.Text,
                DeliveryAddress = cust.Address,
                ContactNumber = cust.Phone,
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

            string city = string.IsNullOrWhiteSpace(firstOrderCity.Text) ? "Mumbai, MH" : firstOrderCity.Text.Trim();
            string contact = string.IsNullOrWhiteSpace(firstOrderContact.Text) ? "Manager" : firstOrderContact.Text.Trim();
            string email = string.IsNullOrWhiteSpace(firstOrderEmail.Text) ? "contact@company.com" : firstOrderEmail.Text.Trim();
            string ply = firstOrderPly.SelectedValue;
            string gsm = firstOrderGsm.SelectedValue;
            decimal l = decimal.TryParse(firstOrderL.Text, out decimal lv) ? lv : 40;
            decimal w = decimal.TryParse(firstOrderW.Text, out decimal wv) ? wv : 30;
            decimal h = decimal.TryParse(firstOrderH.Text, out decimal hv) ? hv : 25;
            int qty = int.TryParse(firstOrderQty.Text, out int q) && q > 0 ? q : 100;
            string notes = firstOrderNotes.Text.Trim();

            decimal rate = ply.Contains("3") ? 32m : (ply.Contains("7") ? 68m : 48m);

            var spec = new BoxSpecification
            {
                Ply = ply,
                GSM = gsm,
                Length = l,
                Width = w,
                Height = h,
                BaseRatePerBox = rate
            };

            var newCust = new Customer
            {
                Name = compName,
                City = city,
                ContactPerson = contact,
                Email = email,
                Phone = "+91 98000 00000",
                Address = $"{compName} Facility, {city}",
                Segment = "Mid-Market",
                DefaultSpec = spec
            };

            var createdCust = BoxFactoryRepository.AddCustomer(newCust);

            var order = new Order
            {
                CustomerId = createdCust.Id,
                CompanyName = createdCust.Name,
                Specs = spec,
                Quantity = qty,
                UnitPrice = rate,
                TotalPrice = rate * qty,
                PlacedBy = "Admin",
                Status = "Confirmed",
                StatusStep = 1,
                IsFirstOrder = true,
                IsRepeatOrder = false,
                Notes = notes,
                DeliveryAddress = createdCust.Address,
                ContactNumber = createdCust.Phone,
                MachinesAssigned = "Cutter A"
            };

            var createdOrder = BoxFactoryRepository.AddOrder(order);
            ShowToast($"Customer {createdCust.Name} and Order {createdOrder.Id} created!");
            hfActiveModal.Value = "none";
            BindAllData();
        }

        protected void btnResetData_Click(object sender, EventArgs e)
        {
            BoxFactoryRepository.ResetToDefault();
            CurrentScreen = "role-select";
            CurrentAdminTab = "dashboard";
            CurrentCustomerTab = "home";
            ShowToast("Demo state reset to original Figma design data.");
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
    <div style='font-size:12px; color:#64748b;'>Includes 18% GST & Shipping</div>
    <div style='font-size:18px; font-weight:800; color:#0f172a;'>Total: &#8377;{o.TotalPrice:N0}</div>
</div>
<div style='display:flex; justify-content:flex-end; gap:10px; margin-top:20px;'>
    <button type='button' class='btn-secondary-outline' onclick='window.print()'>Print Receipt</button>
</div>";

            genericModalTitle.Text = "Order Receipt & Invoice";
            litGenericModalContent.Text = html;
            hfActiveModal.Value = "generic";
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

            genericModalTitle.Text = "Customer Profile";
            litGenericModalContent.Text = html;
            hfActiveModal.Value = "generic";
            ScriptManager.RegisterStartupScript(this, GetType(), "OpenModal",
                "document.getElementById('modalGeneric').classList.add('modal-open');", true);
        }

        // ==========================================
        // PUBLIC TEMPLATE BINDING HELPERS
        // ==========================================
        public string GetStatusClass(string status)
        {
            if (string.IsNullOrEmpty(status)) return "confirmed";
            switch (status.ToLower())
            {
                case "confirmed": return "confirmed";
                case "in production": return "in-production";
                case "quality check": return "quality-check";
                case "dispatched": return "dispatched";
                case "delivered": return "delivered";
                case "pending": return "pending";
                default: return "confirmed";
            }
        }

        public string GetLevelClass(string level)
        {
            if (string.IsNullOrEmpty(level)) return "ok";
            switch (level.ToLower())
            {
                case "good": return "good";
                case "low": return "low";
                default: return "ok";
            }
        }

        public string GetSpecsText(object specsObj)
        {
            if (specsObj is BoxSpecification spec)
                return $"{spec.Ply} &middot; {spec.GSM}";
            return "5 Ply &middot; 150 GSM";
        }

        public string GetSpecSummary(object specsObj)
        {
            if (specsObj is BoxSpecification spec)
                return $"{spec.Ply} &middot; {spec.GSM}";
            return "5 Ply &middot; 150 GSM";
        }

        public string GetSpecDimensions(object specsObj)
        {
            if (specsObj is BoxSpecification spec)
                return $"Dimensions: {spec.DimensionsFormatted}";
            return "Dimensions: 40&times;30&times;25 cm";
        }

        public string GetSpecRate(object specsObj)
        {
            if (specsObj is BoxSpecification spec)
                return spec.BaseRatePerBox.ToString("0");
            return "48";
        }

        public string FormatDate(object dtObj)
        {
            if (dtObj is DateTime dt)
                return dt.ToString("dd MMM yyyy");
            return "18 Oct 2026";
        }

        public string GetScreenClass(string screenName)
        {
            return CurrentScreen == screenName ? "screen-view active-screen" : "screen-view";
        }

        public string GetAdminTabDisplay(string tabName)
        {
            return CurrentAdminTab == tabName ? "block" : "none";
        }

        public string GetAdminTabClass(string tabName)
        {
            return CurrentAdminTab == tabName ? "sidebar-nav-item active" : "sidebar-nav-item";
        }

        public string GetCustomerTabDisplay(string tabName)
        {
            return CurrentCustomerTab == tabName ? "block" : "none";
        }

        public string GetCustomerTabClass(string tabName)
        {
            return CurrentCustomerTab == tabName ? "sidebar-nav-item active" : "sidebar-nav-item";
        }

        // ==========================================
        // AJAX WEBMETHODS (RETRO-COMPATIBILITY)
        // ==========================================
        [WebMethod]
        public static string GetLiveState()
        {
            var payload = new
            {
                success = true,
                customers = BoxFactoryRepository.GetCustomers(),
                orders = BoxFactoryRepository.GetOrders(),
                rawMaterials = BoxFactoryRepository.GetRawMaterials(),
                finishedStock = BoxFactoryRepository.GetFinishedStock(),
                machines = BoxFactoryRepository.GetMachines()
            };
            return JsonConvert.SerializeObject(payload);
        }

        [WebMethod]
        public static string PlaceOrder(string customerId, string companyName, int quantity, string notes, string deliveryAddress, string contactNumber)
        {
            try
            {
                var customers = BoxFactoryRepository.GetCustomers();
                var cust = customers.FirstOrDefault(c => c.Id == customerId || c.Name.Equals(companyName, StringComparison.OrdinalIgnoreCase))
                           ?? customers.First();

                var spec = cust.DefaultSpec ?? new BoxSpecification
                {
                    Ply = "5 Ply",
                    GSM = "150 GSM",
                    Length = 40,
                    Width = 30,
                    Height = 25,
                    BaseRatePerBox = 48.00m
                };

                var newOrder = new Order
                {
                    CustomerId = cust.Id,
                    CompanyName = cust.Name,
                    Specs = spec,
                    Quantity = quantity,
                    UnitPrice = spec.BaseRatePerBox,
                    TotalPrice = spec.BaseRatePerBox * quantity,
                    PlacedBy = "Customer",
                    Status = "In Production",
                    StatusStep = 2,
                    IsFirstOrder = false,
                    IsRepeatOrder = true,
                    Notes = string.IsNullOrWhiteSpace(notes) ? "Repeat order based on saved specifications." : notes,
                    DeliveryAddress = string.IsNullOrWhiteSpace(deliveryAddress) ? cust.Address : deliveryAddress,
                    ContactNumber = string.IsNullOrWhiteSpace(contactNumber) ? cust.Phone : contactNumber,
                    MachinesAssigned = "Cutter A & Printer Line 1"
                };

                var created = BoxFactoryRepository.AddOrder(newOrder);
                return JsonConvert.SerializeObject(new { success = true, order = created, message = $"Order {created.Id} placed successfully!" });
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new { success = false, message = ex.Message });
            }
        }

        [WebMethod]
        public static string CreateCompanyAndOrder(string companyName, string city, string contactPerson, string email,
                                                  string ply, string gsm, decimal length, decimal width, decimal height,
                                                  int quantity, string notes)
        {
            try
            {
                decimal rate = ply.Contains("3") ? 32m : (ply.Contains("7") ? 68m : 48m);
                var spec = new BoxSpecification
                {
                    Ply = ply,
                    GSM = gsm,
                    Length = length,
                    Width = width,
                    Height = height,
                    BaseRatePerBox = rate
                };

                var newCust = new Customer
                {
                    Name = companyName,
                    City = string.IsNullOrWhiteSpace(city) ? "Mumbai, MH" : city,
                    ContactPerson = contactPerson,
                    Email = email,
                    Phone = "+91 98000 00000",
                    Address = $"{companyName} Industrial Facility, {city}",
                    Segment = "Enterprise",
                    DefaultSpec = spec
                };

                var createdCust = BoxFactoryRepository.AddCustomer(newCust);

                var order = new Order
                {
                    CustomerId = createdCust.Id,
                    CompanyName = createdCust.Name,
                    Specs = spec,
                    Quantity = quantity,
                    UnitPrice = rate,
                    TotalPrice = rate * quantity,
                    PlacedBy = "Admin",
                    Status = "Confirmed",
                    StatusStep = 1,
                    IsFirstOrder = true,
                    IsRepeatOrder = false,
                    Notes = notes,
                    DeliveryAddress = createdCust.Address,
                    ContactNumber = createdCust.Phone,
                    MachinesAssigned = "Cutter A"
                };

                var createdOrder = BoxFactoryRepository.AddOrder(order);

                return JsonConvert.SerializeObject(new
                {
                    success = true,
                    customer = createdCust,
                    order = createdOrder,
                    message = $"Customer {createdCust.Name} and Order {createdOrder.Id} created successfully!"
                });
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new { success = false, message = ex.Message });
            }
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
        public static string ResetToDefaults()
        {
            BoxFactoryRepository.ResetToDefault();
            return JsonConvert.SerializeObject(new { success = true, message = "Demo state reset to original Figma design values." });
        }
    }
}