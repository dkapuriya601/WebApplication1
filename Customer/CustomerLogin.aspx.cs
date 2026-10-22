using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using WebApplication1.Services;

namespace WebApplication1.CustomerPages
{
    public partial class CustomerLogin : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // If already authenticated as customer, skip the login page
            if (Session["Role"] as string == "Customer")
                Response.Redirect("~/Customer/Home.aspx");
        }

        protected void btnCustomerLogin_Click(object sender, EventArgs e)
        {
            string email = customerLoginEmail.Text.Trim();
            var customers = BoxFactoryRepository.GetCustomers();
            var cust = customers.FirstOrDefault(c => c.Email.Equals(email, StringComparison.OrdinalIgnoreCase))
                       ?? customers.FirstOrDefault();

            if (cust != null)
            {
                Session["Role"]       = "Customer";
                Session["CustomerId"] = cust.Id;
                Response.Redirect("~/Customer/Home.aspx");
            }
            else
            {
                lblError.Text    = "Customer account not found. Try logistics@apex.com / apex123";
                lblError.Visible = true;
            }
        }

        public void ShowToast(string message)
        {
            toastNotification.Text     = HttpUtility.HtmlEncode(message);
            toastNotification.CssClass = "toast-notice toast-show";
        }
    }
}
