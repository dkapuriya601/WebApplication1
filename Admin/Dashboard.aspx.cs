using System;
using System.Linq;
using System.Web.UI;
using WebApplication1.Helpers;
using WebApplication1.Services;

namespace WebApplication1.AdminPages
{
    public partial class Dashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Master is AdminMaster master)
            {
                master.ActiveTab = "dashboard";
            }

            if (!IsPostBack)
            {
                BindDashboardData();
            }
        }

        private void BindDashboardData()
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

            rptRecentOrders.DataSource = orders.Take(4).ToList();
            rptRecentOrders.DataBind();

            rptMachines.DataSource = BoxFactoryRepository.GetMachines();
            rptMachines.DataBind();
        }

        public string GetStatusClass(string status) => BoxFactoryHelpers.GetStatusClass(status);
    }
}
