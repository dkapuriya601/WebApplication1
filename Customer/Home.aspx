<%@ Page Title="Customer Home - BoxFactory" Language="C#" MasterPageFile="~/Customer/Customer.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="WebApplication1.CustomerPages.Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageHeaderTitle" runat="server">
    Home
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Gradient Hero Banner -->
    <div class="customer-hero-banner">
        <div class="customer-hero-top">
            <div>
                <div class="hero-welcome-sub">Welcome back</div>
                <h2 class="hero-company-name"><asp:Label ID="custWelcomeName" runat="server">Apex Logistics</asp:Label></h2>
                <div class="hero-cust-id"><asp:Label ID="custIdTag" runat="server">CUST-001 | Mumbai, MH</asp:Label></div>
            </div>
            <div class="hero-stats-pill-group">
                <div class="hero-stat-pill">
                    <div class="hero-stat-num"><asp:Label ID="custStatOrders" runat="server">2</asp:Label></div>
                    <div class="hero-stat-desc">Total Orders</div>
                </div>
                <div class="hero-stat-pill">
                    <div class="hero-stat-num"><asp:Label ID="custStatActive" runat="server">1</asp:Label></div>
                    <div class="hero-stat-desc">Active</div>
                </div>
                <div class="hero-stat-pill">
                    <div class="hero-stat-num"><asp:Label ID="custStatSpent" runat="server">&#8377;60K</asp:Label></div>
                    <div class="hero-stat-desc">Spent</div>
                </div>
            </div>
        </div>
    </div>

    <!-- YOUR BOX SPECIFICATION Card -->
    <div class="specs-panel-card">
        <div class="specs-title-label">YOUR BOX SPECIFICATION</div>
        <div class="specs-grid-4col">
            <div class="spec-block-item">
                <div class="spec-block-label">Ply</div>
                <div class="spec-block-val"><asp:Label ID="custSpecPly" runat="server">5 Ply</asp:Label></div>
            </div>
            <div class="spec-block-item">
                <div class="spec-block-label">GSM</div>
                <div class="spec-block-val"><asp:Label ID="custSpecGsm" runat="server">150 GSM</asp:Label></div>
            </div>
            <div class="spec-block-item">
                <div class="spec-block-label">Dimensions</div>
                <div class="spec-block-val"><asp:Label ID="custSpecDims" runat="server">40&times;30&times;25 cm</asp:Label></div>
            </div>
            <div class="spec-block-item">
                <div class="spec-block-label">Base Rate</div>
                <div class="spec-block-val"><asp:Label ID="custSpecRate" runat="server">&#8377;48/box</asp:Label></div>
            </div>
        </div>
    </div>

    <!-- Quick Actions 2x2 Grid -->
    <div class="quick-actions-2x2-grid">
        <a href="<%= ResolveUrl("~/Customer/PlaceOrder.aspx") %>" class="quick-action-card" style="text-decoration:none; color:inherit;">
            <div class="quick-action-icon">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"></path><line x1="3" y1="6" x2="21" y2="6"></line><path d="M16 10a4 4 0 0 1-8 0"></path></svg>
            </div>
            <div>
                <div class="quick-action-title">Place Order</div>
                <div class="quick-action-subtitle">Fast quantity re-order in 1-click</div>
            </div>
        </a>
        <a href="<%= ResolveUrl("~/Customer/TrackOrder.aspx") %>" class="quick-action-card" style="text-decoration:none; color:inherit;">
            <div class="quick-action-icon">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s-8-4.5-8-11.8A8 8 0 0 1 12 2a8 8 0 0 1 8 8.2c0 7.3-8 11.8-8 11.8z"></path><circle cx="12" cy="10" r="3"></circle></svg>
            </div>
            <div>
                <div class="quick-action-title">Track Order</div>
                <div class="quick-action-subtitle">View live delivery status</div>
            </div>
        </a>
        <a href="<%= ResolveUrl("~/Customer/MyOrders.aspx") %>" class="quick-action-card" style="text-decoration:none; color:inherit;">
            <div class="quick-action-icon">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
            </div>
            <div>
                <div class="quick-action-title">Order History</div>
                <div class="quick-action-subtitle">View past invoices &amp; receipts</div>
            </div>
        </a>
        <div class="quick-action-card" onclick="alert('BoxFactory Dedicated Support Hotline: +91 98-200-88000\nEmail: priority@boxfactory.in\nHours: 24/7 Operations Support')">
            <div class="quick-action-icon">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path></svg>
            </div>
            <div>
                <div class="quick-action-title">Support</div>
                <div class="quick-action-subtitle">+91 98-XXX-XXXX • Need help with specs?</div>
            </div>
        </div>
    </div>

    <!-- Recent Orders Table -->
    <div class="content-panel-card">
        <div class="panel-header-row">
            <h2 class="panel-title">Recent Orders</h2>
            <a href="<%= ResolveUrl("~/Customer/MyOrders.aspx") %>" class="btn-table-action">View All</a>
        </div>
        <div class="data-table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Amount</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody id="custRecentOrderTbody">
                    <asp:Repeater ID="rptCustRecentOrders" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td><strong><%# Eval("Id") %></strong></td>
                                <td><strong>&#8377;<%# string.Format("{0:N0}", Eval("TotalPrice")) %></strong></td>
                                <td><span class='badge-status <%# GetStatusClass((string)Eval("Status")) %>'><%# Eval("Status") %></span></td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>
    </div>
</asp:Content>
