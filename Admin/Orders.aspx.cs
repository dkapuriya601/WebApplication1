using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication1.Helpers;
using WebApplication1.Models;
using WebApplication1.Services;

namespace WebApplication1.AdminPages
{
    public partial class Orders : Page
    {
        public string OrderStatusFilter
        {
            get => ViewState["OrderStatusFilter"] as string ?? "All";
            set => ViewState["OrderStatusFilter"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Master is AdminMaster master)
            {
                master.ActiveTab = "orders";
            }

            if (!IsPostBack)
            {
                PopulateStaticDropdowns();
                BindOrders();
                BindRepeatCompanyDropdown();
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

        public void BindOrders()
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

        protected void btnFilterOrders_Command(object sender, CommandEventArgs e)
        {
            OrderStatusFilter = e.CommandName;
            BindOrders();
        }

        protected void txtOrderSearch_TextChanged(object sender, EventArgs e)
        {
            BindOrders();
        }

        protected void rptAllOrders_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewInvoice")
            {
                ShowInvoiceModal(e.CommandArgument.ToString());
            }
        }

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
            BindOrders();
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

            var createdCust = BoxFactoryRepository.AddCustomer(newCust);

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
            BindOrders();
            BindRepeatCompanyDropdown();
        }

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
            ScriptManager.RegisterStartupScript(this, GetType(), "OpenModal",
                "document.getElementById('modalGeneric').classList.add('modal-open');", true);
        }

        public string GetStatusClass(string status) => BoxFactoryHelpers.GetStatusClass(status);
        public string GetSpecsText(object specsObj) => BoxFactoryHelpers.GetSpecsText(specsObj);
        public string FormatDate(object dtObj) => BoxFactoryHelpers.FormatDate(dtObj);

        public void ShowToast(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "ToastAlert_" + Guid.NewGuid().ToString("N"),
                $"if (window.BoxApp && window.BoxApp.showToast) {{ window.BoxApp.showToast('{HttpUtility.JavaScriptStringEncode(message)}'); }}", true);
        }
    }
}
