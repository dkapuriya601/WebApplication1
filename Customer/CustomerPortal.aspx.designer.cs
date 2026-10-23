namespace WebApplication1.CustomerPages
{
    public partial class CustomerPortal
    {
        protected global::System.Web.UI.HtmlControls.HtmlForm form1;
        protected global::System.Web.UI.ScriptManager ScriptManager1;
        protected global::System.Web.UI.UpdatePanel upMain;
        protected global::System.Web.UI.WebControls.HiddenField hfCustomerTab;
        protected global::System.Web.UI.WebControls.Button btnSignOutCustomer;

        // Customer Home
        protected global::System.Web.UI.WebControls.Label custWelcomeName;
        protected global::System.Web.UI.WebControls.Label custIdTag;
        protected global::System.Web.UI.WebControls.Label custStatOrders;
        protected global::System.Web.UI.WebControls.Label custStatActive;
        protected global::System.Web.UI.WebControls.Label custStatSpent;
        protected global::System.Web.UI.WebControls.Label custSpecPly;
        protected global::System.Web.UI.WebControls.Label custSpecGsm;
        protected global::System.Web.UI.WebControls.Label custSpecDims;
        protected global::System.Web.UI.WebControls.Label custSpecRate;
        protected global::System.Web.UI.WebControls.Repeater rptCustRecentOrders;

        // Place Order
        protected global::System.Web.UI.WebControls.Label placeOrderSpecInline;
        protected global::System.Web.UI.WebControls.TextBox placeOrderQtyInput;
        protected global::System.Web.UI.WebControls.TextBox placeOrderAddress;
        protected global::System.Web.UI.WebControls.TextBox placeOrderPhone;
        protected global::System.Web.UI.WebControls.TextBox placeOrderNotes;
        protected global::System.Web.UI.WebControls.Label summaryBoxType;
        protected global::System.Web.UI.WebControls.Label summaryBoxGsm;
        protected global::System.Web.UI.WebControls.Label summaryBoxSize;
        protected global::System.Web.UI.WebControls.Label summaryBoxQty;
        protected global::System.Web.UI.WebControls.Label summaryBoxRate;
        protected global::System.Web.UI.WebControls.Label summaryTotalVal;
        protected global::System.Web.UI.WebControls.Button btnSubmitCustomerOrder;

        // Track Order
        protected global::System.Web.UI.WebControls.TextBox trackSearchInput;
        protected global::System.Web.UI.WebControls.Button btnTrackSearch;
        protected global::System.Web.UI.WebControls.Panel pnlActiveTrackOrder;
        protected global::System.Web.UI.WebControls.Label lblTrackOrderId;
        protected global::System.Web.UI.WebControls.Label lblTrackSpecs;
        protected global::System.Web.UI.WebControls.Label lblTrackStatusBadge;
        protected global::System.Web.UI.WebControls.Label lblTrackQty;
        protected global::System.Web.UI.WebControls.Label lblTrackAmount;
        protected global::System.Web.UI.WebControls.Label lblTrackETA;
        protected global::System.Web.UI.WebControls.Label lblTrackMachines;
        protected global::System.Web.UI.WebControls.Label lblTrackAddress;
        protected global::System.Web.UI.WebControls.Label lblTrackContact;

        // My Orders
        protected global::System.Web.UI.WebControls.Repeater rptCustAllOrders;

        // Generic Modal
        protected global::System.Web.UI.WebControls.Label genericModalTitle;
        protected global::System.Web.UI.WebControls.Literal litGenericModalContent;
        protected global::System.Web.UI.WebControls.Label toastNotification;
    }
}
