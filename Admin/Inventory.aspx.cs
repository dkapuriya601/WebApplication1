using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication1.Helpers;
using WebApplication1.Services;

namespace WebApplication1.AdminPages
{
    public partial class Inventory : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Master is AdminMaster master)
            {
                master.ActiveTab = "inventory";
            }

            if (!IsPostBack)
            {
                BindInventory();
            }
        }

        private void BindInventory()
        {
            rptRawMaterials.DataSource = BoxFactoryRepository.GetRawMaterials();
            rptRawMaterials.DataBind();

            rptFinishedStock.DataSource = BoxFactoryRepository.GetFinishedStock();
            rptFinishedStock.DataBind();
        }

        protected void rptRawMaterials_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Restock")
            {
                string sku = e.CommandArgument.ToString();
                BoxFactoryRepository.RestockRawMaterial(sku, 500);
                ShowToast($"Restocked {sku} with +500!");
                BindInventory();
            }
        }

        public string GetLevelClass(string level) => BoxFactoryHelpers.GetLevelClass(level);

        public void ShowToast(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "ToastAlert_" + Guid.NewGuid().ToString("N"),
                $"if (window.BoxApp && window.BoxApp.showToast) {{ window.BoxApp.showToast('{HttpUtility.JavaScriptStringEncode(message)}'); }}", true);
        }
    }
}
