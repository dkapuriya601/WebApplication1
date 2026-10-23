using System;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;

namespace WebApplication1.AdminPages
{
    public partial class AdminLogin : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // If already authenticated as admin, skip the login page
            if (Session["Role"] as string == "Admin")
                Response.Redirect("~/Admin/Dashboard.aspx");
        }

        protected void btnAdminLogin_Click(object sender, EventArgs e)
        {
            lblError.Visible = false;
            lblError.Text = string.Empty;

            // 1. Check client & server-side Validator controls
            if (!Page.IsValid)
            {
                return;
            }

            string email = (adminLoginEmail.Text ?? string.Empty).Trim();
            string pwd   = (adminLoginPassword.Text ?? string.Empty).Trim();

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

            // 3. Credential authentication
            if ((email.Equals("admin@boxfactory.in", StringComparison.OrdinalIgnoreCase) && pwd == "admin123") ||
                (email.IndexOf("admin", StringComparison.OrdinalIgnoreCase) >= 0 && pwd == "admin123"))
            {
                Session["Role"] = "Admin";
                Response.Redirect("~/Admin/Dashboard.aspx");
            }
            else
            {
                lblError.Text    = "Invalid Admin credentials. Try admin@boxfactory.in / admin123";
                lblError.Visible = true;
            }
        }

        public void ShowToast(string message)
        {
            toastNotification.Text      = HttpUtility.HtmlEncode(message);
            toastNotification.CssClass  = "toast-notice toast-show";
        }
    }
}
