namespace WebApplication1.AdminPages
{
    public partial class AdminPortal
    {
        protected global::System.Web.UI.HtmlControls.HtmlForm form1;
        protected global::System.Web.UI.ScriptManager ScriptManager1;
        protected global::System.Web.UI.UpdatePanel upMain;
        protected global::System.Web.UI.WebControls.HiddenField hfAdminTab;
        protected global::System.Web.UI.WebControls.HiddenField hfActiveModal;
        protected global::System.Web.UI.WebControls.Button btnSignOutAdmin;

        // KPI
        protected global::System.Web.UI.WebControls.Label lblTotalBoxesProduced;
        protected global::System.Web.UI.WebControls.Label lblPendingOrdersCount;
        protected global::System.Web.UI.WebControls.Label lblActiveCustomersCount;
        protected global::System.Web.UI.WebControls.Label lblTotalRevenueAmount;

        // Dashboard
        protected global::System.Web.UI.WebControls.Repeater rptRecentOrders;
        protected global::System.Web.UI.WebControls.Repeater rptMachines;

        // Orders Tab
        protected global::System.Web.UI.WebControls.TextBox txtOrderSearch;
        protected global::System.Web.UI.WebControls.Repeater rptAllOrders;

        // Inventory Tab
        protected global::System.Web.UI.WebControls.Repeater rptRawMaterials;
        protected global::System.Web.UI.WebControls.Repeater rptFinishedStock;

        // Customers Tab
        protected global::System.Web.UI.WebControls.Label lblTotalCustomersCount;
        protected global::System.Web.UI.WebControls.Label lblActiveCustomersCountTab;
        protected global::System.Web.UI.WebControls.Label lblTotalRevenueCustomers;
        protected global::System.Web.UI.WebControls.TextBox txtCustomerSearch;
        protected global::System.Web.UI.WebControls.Repeater rptCustomers;

        // Modals
        protected global::System.Web.UI.WebControls.DropDownList repeatOrderCompanySelect;
        protected global::System.Web.UI.WebControls.TextBox repeatOrderQty;
        protected global::System.Web.UI.WebControls.Label repeatOrderTotal;
        protected global::System.Web.UI.WebControls.TextBox repeatOrderNotes;
        protected global::System.Web.UI.WebControls.Button btnSubmitRepeatOrder;

        protected global::System.Web.UI.WebControls.TextBox firstOrderCompanyName;
        protected global::System.Web.UI.WebControls.TextBox firstOrderCity;
        protected global::System.Web.UI.WebControls.TextBox firstOrderContact;
        protected global::System.Web.UI.WebControls.TextBox firstOrderEmail;
        protected global::System.Web.UI.WebControls.DropDownList firstOrderPly;
        protected global::System.Web.UI.WebControls.DropDownList firstOrderGsm;
        protected global::System.Web.UI.WebControls.TextBox firstOrderL;
        protected global::System.Web.UI.WebControls.TextBox firstOrderW;
        protected global::System.Web.UI.WebControls.TextBox firstOrderH;
        protected global::System.Web.UI.WebControls.TextBox firstOrderQty;
        protected global::System.Web.UI.WebControls.Label firstOrderTotalPreview;
        protected global::System.Web.UI.WebControls.TextBox firstOrderNotes;
        protected global::System.Web.UI.WebControls.Button btnSubmitFirstOrder;

        protected global::System.Web.UI.WebControls.Label genericModalTitle;
        protected global::System.Web.UI.WebControls.Literal litGenericModalContent;
        protected global::System.Web.UI.WebControls.Label toastNotification;
    }
}
