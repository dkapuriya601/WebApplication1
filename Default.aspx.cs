using System;
using System.Web;
using System.Web.UI;
using WebApplication1.Services;

namespace WebApplication1
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // If already authenticated, redirect directly to the appropriate portal
            if (Session["Role"] as string == "Admin")
                Response.Redirect("~/Admin/Dashboard.aspx");
            else if (Session["Role"] as string == "Customer")
                Response.Redirect("~/Customer/Home.aspx");
        }

        // Navigate to Admin login page
        protected void btnGoAdminLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/AdminLogin.aspx");
        }

        // Navigate to Customer login page
        protected void btnGoCustomerLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Customer/CustomerLogin.aspx");
        }

        // Quick demo login: Admin
        protected void btnQuickAdmin_Click(object sender, EventArgs e)
        {
            Session["Role"] = "Admin";
            Response.Redirect("~/Admin/Dashboard.aspx");
        }

        // Quick demo login: Customer (Apex Logistics)
        protected void btnQuickCustomer_Click(object sender, EventArgs e)
        {
            var customers = BoxFactoryRepository.GetCustomers();
            var cust = customers[0]; // Apex Logistics is the first record
            Session["Role"]       = "Customer";
            Session["CustomerId"] = cust.Id;
            Response.Redirect("~/Customer/Home.aspx");
        }

        public void ShowToast(string message)
        {
            toastNotification.Text = HttpUtility.HtmlEncode(message);
            toastNotification.CssClass = "toast-notice toast-show";
        }
    }
}