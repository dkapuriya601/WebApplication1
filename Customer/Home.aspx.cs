using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using WebApplication1.Helpers;
using WebApplication1.Models;
using WebApplication1.Services;

namespace WebApplication1.CustomerPages
{
    public partial class Home : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Master is CustomerMaster master)
            {
                master.ActiveTab = "home";
            }

            if (!IsPostBack)
            {
                BindHomeData();
            }
        }

        private void BindHomeData()
        {
            string custId = Session["CustomerId"] as string ?? "CUST-001";
            var customers = BoxFactoryRepository.GetCustomers();
            var cust = customers.FirstOrDefault(c => c.Id == custId) ?? customers.First();

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

            rptCustRecentOrders.DataSource = myOrders.Take(2).ToList();
            rptCustRecentOrders.DataBind();
        }

        public string GetStatusClass(string status) => BoxFactoryHelpers.GetStatusClass(status);
    }
}
