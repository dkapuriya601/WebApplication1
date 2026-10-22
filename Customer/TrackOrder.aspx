<%@ Page Title="Track Order - BoxFactory" Language="C#" MasterPageFile="~/Customer/Customer.Master" AutoEventWireup="true" CodeBehind="TrackOrder.aspx.cs" Inherits="WebApplication1.CustomerPages.TrackOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageHeaderTitle" runat="server">
    Track Order
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="track-search-card">
        <h2 class="panel-title">Track Your Order</h2>
        <div class="track-input-row">
            <asp:TextBox ID="trackSearchInput" runat="server" CssClass="form-control-input purple-focus" placeholder="Enter Order ID e.g. ORD-1041" />
            <asp:Button ID="btnTrackSearch" runat="server" Text="Track" CssClass="btn-primary-purple" style="width:auto; padding:10px 24px;" OnClick="btnTrackSearch_Click" />
        </div>
    </div>

    <div class="panel-title" style="margin-bottom:14px;">Active Order Status</div>
    <div id="custTrackingCardContainer">
        <asp:Panel ID="pnlActiveTrackOrder" runat="server">
            <div class="order-tracking-card">
                <div class="tracking-top-bar">
                    <div>
                        <div class="tracking-order-title"><asp:Label ID="lblTrackOrderId" runat="server">ORD-1041</asp:Label></div>
                        <div class="tracking-order-sub"><asp:Label ID="lblTrackSpecs" runat="server">5 Ply &middot; 150 GSM &middot; 40&times;30&times;25 cm</asp:Label></div>
                    </div>
                    <asp:Label ID="lblTrackStatusBadge" runat="server" CssClass="badge-status in-production">In Production</asp:Label>
                </div>

                <!-- 5-Step Stepper -->
                <div class="order-progress-stepper">
                    <div class='<%= GetStepClass(1) %>'>
                        <div class="step-dot-wrap"><div class="step-dot"></div></div>
                        <div class="step-title">Confirmed</div>
                    </div>
                    <div class='<%= GetStepClass(2) %>'>
                        <div class="step-dot-wrap"><div class="step-dot"></div></div>
                        <div class="step-title">Production</div>
                    </div>
                    <div class='<%= GetStepClass(3) %>'>
                        <div class="step-dot-wrap"><div class="step-dot"></div></div>
                        <div class="step-title">Quality Check</div>
                    </div>
                    <div class='<%= GetStepClass(4) %>'>
                        <div class="step-dot-wrap"><div class="step-dot"></div></div>
                        <div class="step-title">Dispatched</div>
                    </div>
                    <div class='<%= GetStepClass(5) %>'>
                        <div class="step-dot-wrap"><div class="step-dot"></div></div>
                        <div class="step-title">Delivered</div>
                    </div>
                </div>

                <!-- Meta Details Grid -->
                <div class="tracking-details-grid">
                    <div>
                        <div class="tracking-detail-label">Quantity</div>
                        <div class="tracking-detail-val"><asp:Label ID="lblTrackQty" runat="server">500 boxes</asp:Label></div>
                    </div>
                    <div>
                        <div class="tracking-detail-label">Amount</div>
                        <div class="tracking-detail-val"><asp:Label ID="lblTrackAmount" runat="server">&#8377;24,000</asp:Label></div>
                    </div>
                    <div>
                        <div class="tracking-detail-label">Estimated Delivery</div>
                        <div class="tracking-detail-val"><asp:Label ID="lblTrackETA" runat="server">21 Oct 2026</asp:Label></div>
                    </div>
                    <div>
                        <div class="tracking-detail-label">Assigned Machines</div>
                        <div class="tracking-detail-val"><asp:Label ID="lblTrackMachines" runat="server">Cutter A &amp; Printer Line 1</asp:Label></div>
                    </div>
                </div>

                <div style="font-size:12px; color:#64748b; margin-top:12px; border-top:1px dashed #e2e8f0; padding-top:10px;">
                    <strong>Delivery Address:</strong> <asp:Label ID="lblTrackAddress" runat="server">Plot 42, Andheri MIDC, Mumbai, Maharashtra 400093</asp:Label> |
                    <strong>Contact:</strong> <asp:Label ID="lblTrackContact" runat="server">+91 98200 12345</asp:Label>
                </div>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlNotFound" runat="server" Visible="false" CssClass="content-panel-card" style="text-align:center; padding:32px;">
            <p style="color:#64748b; font-size:15px;">No matching order found for tracking.</p>
        </asp:Panel>
    </div>
</asp:Content>
