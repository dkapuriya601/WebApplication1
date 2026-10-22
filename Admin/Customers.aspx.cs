using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication1.Models;
using WebApplication1.Services;

namespace WebApplication1.AdminPages
{
    public partial class Customers : Page
    {
        public string CustomerSegmentFilter
        {
            get => ViewState["CustomerSegmentFilter"] as string ?? "All";
            set => ViewState["CustomerSegmentFilter"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Master is AdminMaster master)
            {
                master.ActiveTab = "customers";
            }

            if (!IsPostBack)
            {
                BindCustomerStats();
                BindCustomers();
            }
        }

        private void BindCustomerStats()
        {
            var customers = BoxFactoryRepository.GetCustomers();
            int activeCust = customers.Count(c => string.Equals(c.Status, "Active", StringComparison.OrdinalIgnoreCase));
            decimal revenue = customers.Sum(c => c.TotalSpent);

            lblTotalCustomersCount.Text = $"{customers.Count}";
            lblActiveCustomersCountTab.Text = $"{activeCust}";
            lblTotalRevenueCustomers.Text = $"&#8377;{revenue / 100000m:0.#}L";
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

        protected void btnFilterCustomers_Command(object sender, CommandEventArgs e)
        {
            CustomerSegmentFilter = e.CommandName;
            BindCustomers();
        }

        protected void txtCustomerSearch_TextChanged(object sender, EventArgs e)
        {
            BindCustomers();
        }

        protected void rptCustomers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetail")
            {
                ShowCustomerModal(e.CommandArgument.ToString());
            }
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
            ScriptManager.RegisterStartupScript(this, GetType(), "OpenModal",
                "document.getElementById('modalGeneric').classList.add('modal-open');", true);
        }
    }
}
