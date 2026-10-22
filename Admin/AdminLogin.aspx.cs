using System;
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
            string email = adminLoginEmail.Text.Trim();
            string pwd   = adminLoginPassword.Text.Trim();

            if ((email.Equals("admin@boxfactory.in", StringComparison.OrdinalIgnoreCase) && pwd == "admin123") ||
                email.IndexOf("admin", StringComparison.OrdinalIgnoreCase) >= 0)
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
