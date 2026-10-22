using System;
using System.Linq;
using System.Web.UI;
using WebApplication1.Helpers;
using WebApplication1.Models;
using WebApplication1.Services;

namespace WebApplication1.CustomerPages
{
    public partial class TrackOrder : Page
    {
        public int CurrentStatusStep { get; set; } = 2;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Master is CustomerMaster master)
            {
                master.ActiveTab = "track-order";
            }

            if (!IsPostBack)
            {
                string orderId = Session["LastPlacedOrderId"] as string ?? Request.QueryString["orderId"];
                if (!string.IsNullOrEmpty(orderId))
                {
                    trackSearchInput.Text = orderId;
                    Session.Remove("LastPlacedOrderId");
                }

                LoadTrackOrder(trackSearchInput.Text.Trim());
            }
        }

        protected void btnTrackSearch_Click(object sender, EventArgs e)
        {
            LoadTrackOrder(trackSearchInput.Text.Trim());
        }

        private void LoadTrackOrder(string queryId)
        {
            string custId = Session["CustomerId"] as string ?? "CUST-001";
            var orders = BoxFactoryRepository.GetOrders();

            Order target = null;
            if (!string.IsNullOrEmpty(queryId))
            {
                target = orders.FirstOrDefault(o => o.Id.Equals(queryId, StringComparison.OrdinalIgnoreCase));
            }

            if (target == null)
            {
                // Fallback to active order of the customer
                target = orders.FirstOrDefault(o => (o.CustomerId == custId) && !string.Equals(o.Status, "Delivered", StringComparison.OrdinalIgnoreCase))
                         ?? orders.FirstOrDefault(o => o.CustomerId == custId);
            }

            if (target != null)
            {
                pnlActiveTrackOrder.Visible = true;
                pnlNotFound.Visible = false;
                trackSearchInput.Text = target.Id;
                lblTrackOrderId.Text = target.Id;
                lblTrackStatusBadge.Text = target.Status;
                lblTrackStatusBadge.CssClass = $"badge-status {GetStatusClass(target.Status)}";
                lblTrackSpecs.Text = target.Specs != null ? $"{target.Specs.Ply} &middot; {target.Specs.GSM} &middot; {target.Specs.DimensionsFormatted}" : "5 Ply";
                lblTrackQty.Text = $"{target.Quantity:N0} boxes";
                lblTrackAmount.Text = $"&#8377;{target.TotalPrice:N0}";
                lblTrackETA.Text = target.ETA ?? "21 Oct 2026";
                lblTrackMachines.Text = target.MachinesAssigned ?? "Cutter A & Printer Line 1";
                lblTrackAddress.Text = target.DeliveryAddress ?? "On file";
                lblTrackContact.Text = target.ContactNumber ?? "On file";

                CurrentStatusStep = target.StatusStep > 0 ? target.StatusStep : 2;
            }
            else
            {
                pnlActiveTrackOrder.Visible = false;
                pnlNotFound.Visible = true;
            }
        }

        public string GetStepClass(int stepNumber)
        {
            if (stepNumber < CurrentStatusStep)
                return "stepper-step completed";
            if (stepNumber == CurrentStatusStep)
                return "stepper-step active";
            return "stepper-step";
        }

        public string GetStatusClass(string status) => BoxFactoryHelpers.GetStatusClass(status);
    }
}
