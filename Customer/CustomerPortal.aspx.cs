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

namespace WebApplication1.CustomerPages
{
    public partial class CustomerPortal : Page
    {
        // ==========================================
        // PRELOADED JSON FOR CLIENT-SIDE ENGINE
        // ==========================================
        public string PreloadedJsonData { get; set; } = "{}";

        // ==========================================
        // STATE PROPERTIES (ViewState-backed)
        // ==========================================
        public string CurrentCustomerTab
        {
            get => ViewState["CurrentCustomerTab"] as string ?? "home";
            set => ViewState["CurrentCustomerTab"] = value;
        }

        public string CurrentCustomerId
        {
            get => ViewState["CurrentCustomerId"] as string ?? (Session["CustomerId"] as string ?? "CUST-001");
            set => ViewState["CurrentCustomerId"] = value;
        }

        // ==========================================
        // PAGE LIFECYCLE
        // ==========================================
        protected void Page_Load(object sender, EventArgs e)
        {
            // Guard: only Customer may access this page
            if (Session["Role"] as string != "Customer")
            {
                Response.Redirect("~/Customer/CustomerLogin.aspx");
                return;
            }

            if (!IsPostBack)
            {
                if (Session["CustomerId"] != null)
                {
                    CurrentCustomerId = Session["CustomerId"].ToString();
                }

                BindAllData();
            }
            else
            {
                if (!string.IsNullOrEmpty(hfCustomerTab.Value))
                    CurrentCustomerTab = hfCustomerTab.Value;
            }
        }

        // ==========================================
        // DATA BINDING
        // ==========================================
        public void BindAllData()
        {
            BindCustomerPortal();
            BindPreloadedJsonData();
            SyncHiddenFields();
        }

        private void SyncHiddenFields()
        {
            hfCustomerTab.Value = CurrentCustomerTab;
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

        // ==========================================
        // NAVIGATION EVENTS
        // ==========================================
        protected void btnNavCustomerTab_Command(object sender, CommandEventArgs e)
        {
            CurrentCustomerTab = e.CommandName;
            BindAllData();
        }

        protected void btnSignOut_Click(object sender, EventArgs e)
        {
            Session.Remove("Role");
            Session.Remove("CustomerId");
            Response.Redirect("~/Default.aspx");
        }

        // ==========================================
        // ORDER ACTIONS
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

        protected void rptCustAllOrders_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewReceipt")
            {
                string orderId = e.CommandArgument.ToString();
                ShowInvoiceModal(orderId);
            }
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

            genericModalTitle.Text = "Order Receipt &amp; Invoice";
            litGenericModalContent.Text = html;
            ScriptManager.RegisterStartupScript(this, GetType(), "OpenModal",
                "document.getElementById('modalGeneric').classList.add('modal-open');", true);
        }

        // ==========================================
        // TEMPLATE BINDING HELPERS
        // ==========================================
        public string GetStatusClass(string status) => BoxFactoryHelpers.GetStatusClass(status);
        public string GetSpecsText(object specsObj) => BoxFactoryHelpers.GetSpecsText(specsObj);
        public string FormatDate(object dtObj) => BoxFactoryHelpers.FormatDate(dtObj);

        public string GetCustomerTabDisplay(string tabName) => CurrentCustomerTab == tabName ? "block" : "none";
        public string GetCustomerTabClass(string tabName) => CurrentCustomerTab == tabName ? "sidebar-nav-item active" : "sidebar-nav-item";

        public void ShowToast(string message)
        {
            toastNotification.Text = HttpUtility.HtmlEncode(message);
            toastNotification.CssClass = "toast-notice toast-show";
            ScriptManager.RegisterStartupScript(this, GetType(), "ToastAlert_" + Guid.NewGuid().ToString("N"),
                $"if (window.BoxApp && window.BoxApp.showToast) {{ window.BoxApp.showToast('{HttpUtility.JavaScriptStringEncode(message)}'); }}", true);
        }

        // ==========================================
        // STATIC WEBMETHODS (AJAX)
        // ==========================================
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
    }
}
