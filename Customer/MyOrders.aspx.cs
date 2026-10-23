using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication1.Helpers;
using WebApplication1.Models;
using WebApplication1.Services;

namespace WebApplication1.CustomerPages
{
    public partial class MyOrders : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Master is CustomerMaster master)
            {
                master.ActiveTab = "my-orders";
            }

            if (!IsPostBack)
            {
                BindMyOrders();
            }
        }

        private void BindMyOrders()
        {
            string custId = Session["CustomerId"] as string ?? "CUST-001";
            var customers = BoxFactoryRepository.GetCustomers();
            var cust = customers.FirstOrDefault(c => c.Id == custId) ?? customers.First();

            var myOrders = BoxFactoryRepository.GetOrders()
                .Where(o => o.CustomerId == cust.Id || o.CompanyName.Equals(cust.Name, StringComparison.OrdinalIgnoreCase))
                .ToList();

            rptCustAllOrders.DataSource = myOrders;
            rptCustAllOrders.DataBind();
        }

        protected void rptCustAllOrders_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewReceipt")
            {
                ShowInvoiceModal(e.CommandArgument.ToString());
            }
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
    }
}
