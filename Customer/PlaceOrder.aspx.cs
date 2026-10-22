using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using WebApplication1.Models;
using WebApplication1.Services;

namespace WebApplication1.CustomerPages
{
    public partial class PlaceOrder : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Master is CustomerMaster master)
            {
                master.ActiveTab = "place-order";
            }

            if (!IsPostBack)
            {
                BindSpecSummary();
            }
        }

        private void BindSpecSummary()
        {
            string custId = Session["CustomerId"] as string ?? "CUST-001";
            var customers = BoxFactoryRepository.GetCustomers();
            var cust = customers.FirstOrDefault(c => c.Id == custId) ?? customers.First();

            var spec = cust.DefaultSpec ?? new BoxSpecification
            {
                Ply = "5 Ply",
                GSM = "150 GSM",
                Length = 40,
                Width = 30,
                Height = 25,
                BaseRatePerBox = 48.00m
            };

            placeOrderSpecInline.Text = $"{spec.Ply} &middot; {spec.GSM} &middot; {spec.Length}&times;{spec.Width}&times;{spec.Height} cm";
            summaryBoxType.Text = spec.Ply;
            summaryBoxGsm.Text = spec.GSM;
            summaryBoxSize.Text = $"{spec.Length}&times;{spec.Width}&times;{spec.Height} cm";
            summaryBoxRate.Text = $"&#8377;{spec.BaseRatePerBox:0}/box";

            int qty = int.TryParse(placeOrderQtyInput.Text, out int q) && q > 0 ? q : 100;
            summaryBoxQty.Text = $"{qty} boxes";
            summaryTotalVal.Text = $"&#8377;{qty * spec.BaseRatePerBox:N0}";

            placeOrderAddress.Text = cust.Address ?? "";
            placeOrderPhone.Text = cust.Phone ?? "";
        }

        protected void btnSubmitCustomerOrder_Click(object sender, EventArgs e)
        {
            int qty = int.TryParse(placeOrderQtyInput.Text, out int q) && q > 0 ? q : 100;
            string custId = Session["CustomerId"] as string ?? "CUST-001";
            var customers = BoxFactoryRepository.GetCustomers();
            var cust = customers.FirstOrDefault(c => c.Id == custId) ?? customers.First();

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
            Session["LastPlacedOrderId"] = created.Id;
            Response.Redirect("~/Customer/TrackOrder.aspx");
        }
    }
}
