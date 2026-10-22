using System;
using System.Linq;
using System.Web.UI;
using WebApplication1.Services;

namespace WebApplication1.CustomerPages
{
    public partial class CustomerMaster : MasterPage
    {
        public string ActiveTab { get; set; } = "home";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] as string != "Customer")
            {
                Response.Redirect("~/Customer/CustomerLogin.aspx");
                return;
            }

            if (!IsPostBack)
            {
                string custId = Session["CustomerId"] as string ?? "CUST-001";
                var cust = BoxFactoryRepository.GetCustomers().FirstOrDefault(c => c.Id == custId)
                           ?? BoxFactoryRepository.GetCustomers().FirstOrDefault();

                if (cust != null)
                {
                    litAvatar.Text = cust.AvatarInitials ?? "AL";
                    litUserName.Text = cust.Name ?? "Apex Logistics";
                    litTopAvatar.Text = cust.AvatarInitials ?? "AL";
                    litTopShortName.Text = cust.Name != null ? cust.Name.Split(' ')[0] : "Apex";
                }
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
            Session.Remove("CustomerId");
            Response.Redirect("~/Default.aspx");
        }
    }
}
