using System;
using System.Web.UI;

namespace WebApplication1.AdminPages
{
    public partial class AdminMaster : MasterPage
    {
        public string ActiveTab { get; set; } = "dashboard";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] as string != "Admin")
            {
                Response.Redirect("~/Admin/AdminLogin.aspx");
            }
        }

        public string GetNavClass(string tab)
        {
            return string.Equals(ActiveTab, tab, StringComparison.OrdinalIgnoreCase) 
                ? "sidebar-nav-item active" 
                : "sidebar-nav-item";
        }

        protected void btnSignOut_Click(object sender, EventArgs e)
        {
            Session.Remove("Role");
            Response.Redirect("~/Default.aspx");
        }
    }
}
