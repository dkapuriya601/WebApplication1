<%@ Page Title="Place Order - BoxFactory" Language="C#" MasterPageFile="~/Customer/Customer.Master" AutoEventWireup="true" CodeBehind="PlaceOrder.aspx.cs" Inherits="WebApplication1.CustomerPages.PlaceOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageHeaderTitle" runat="server">
    Place Order
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Alert Saved Spec Banner -->
    <div class="alert-saved-spec-banner">
        <div class="saved-spec-header">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="#15803d" stroke="currentColor" stroke-width="1"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
            <span>YOUR SAVED BOX SPECIFICATION</span>
        </div>
        <div class="saved-spec-tags-inline" id="placeOrderSpecInlineWrapper">
            <asp:Label ID="placeOrderSpecInline" runat="server">5 Ply &middot; 150 GSM &middot; 40&times;30&times;25 cm</asp:Label>
        </div>
        <div class="saved-spec-note">Box spec is fixed by the factory. Only quantity can be changed for repeat orders.</div>
    </div>

    <div class="place-order-layout">
        <!-- Form Column -->
        <div class="content-panel-card">
            <h2 class="panel-title" style="margin-bottom: 18px;">Order Details</h2>

            <div class="form-group">
                <label class="form-label">Quantity (number of boxes)</label>
                <asp:TextBox ID="placeOrderQtyInput" runat="server" TextMode="Number" CssClass="form-control-input purple-focus" Text="100" min="1" step="50" oninput="window.BoxApp && window.BoxApp.updatePlaceOrderSummary ? window.BoxApp.updatePlaceOrderSummary() : null" />
            </div>

            <div class="form-group">
                <label class="form-label">Delivery Address</label>
                <asp:TextBox ID="placeOrderAddress" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control-input purple-focus" Text="Apex Logistics, Plot 42, Andheri MIDC, Mumbai, Maharashtra 400093" />
            </div>

            <div class="form-group">
                <label class="form-label">Contact Number</label>
                <asp:TextBox ID="placeOrderPhone" runat="server" CssClass="form-control-input purple-focus" Text="+91 98200 12345" />
            </div>

            <div class="form-group">
                <label class="form-label">Notes (optional)</label>
                <asp:TextBox ID="placeOrderNotes" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control-input purple-focus" placeholder="Special instructions e.g. pallet strapping, moisture wrap..." />
            </div>
        </div>

        <!-- Summary Column -->
        <div class="order-summary-card">
            <h2 class="panel-title" style="margin-bottom: 16px;">Order Summary</h2>

            <div class="summary-item-row">
                <span>Box Type</span>
                <strong><asp:Label ID="summaryBoxType" runat="server">5 Ply</asp:Label></strong>
            </div>
            <div class="summary-item-row">
                <span>GSM</span>
                <strong><asp:Label ID="summaryBoxGsm" runat="server">150 GSM</asp:Label></strong>
            </div>
            <div class="summary-item-row">
                <span>Size</span>
                <strong><asp:Label ID="summaryBoxSize" runat="server">40&times;30&times;25 cm</asp:Label></strong>
            </div>
            <div class="summary-item-row">
                <span>Quantity</span>
                <strong><asp:Label ID="summaryBoxQty" runat="server">100 boxes</asp:Label></strong>
            </div>
            <div class="summary-item-row">
                <span>Rate</span>
                <strong><asp:Label ID="summaryBoxRate" runat="server">&#8377;48/box</asp:Label></strong>
            </div>

            <div class="summary-item-row bold-total">
                <span>Total</span>
                <span style="color:var(--purple-700);"><asp:Label ID="summaryTotalVal" runat="server">&#8377;4,800</asp:Label></span>
            </div>
            <div class="summary-subtext">GST included &bull; Est delivery 5-7 days</div>

            <asp:Button ID="btnSubmitCustomerOrder" runat="server" Text="Place Order" CssClass="btn-primary-purple" OnClick="btnSubmitCustomerOrder_Click" />
        </div>
    </div>
</asp:Content>
