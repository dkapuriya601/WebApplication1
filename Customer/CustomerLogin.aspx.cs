using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
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
            lblError.Visible = false;
            lblError.Text = string.Empty;

            // 1. Check client & server-side Validator controls
            if (!Page.IsValid)
            {
                return;
            }

            string email = (customerLoginEmail.Text ?? string.Empty).Trim();
            string pwd   = (customerLoginPassword.Text ?? string.Empty).Trim();

            // 2. Explicit server-side validation checks
            if (string.IsNullOrEmpty(email))
            {
                lblError.Text = "Email address is required.";
                lblError.Visible = true;
                return;
            }

            if (!Regex.IsMatch(email, @"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"))
            {
                lblError.Text = "Please enter a valid email address.";
                lblError.Visible = true;
                return;
            }

            if (string.IsNullOrEmpty(pwd))
            {
                lblError.Text = "Password is required.";
                lblError.Visible = true;
                return;
            }

            if (pwd.Length < 6)
            {
                lblError.Text = "Password must be at least 6 characters long.";
                lblError.Visible = true;
                return;
            }

            // 3. Credential authentication against customers repository
            var customers = BoxFactoryRepository.GetCustomers();
            var cust = customers.FirstOrDefault(c => c.Email.Equals(email, StringComparison.OrdinalIgnoreCase));

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
