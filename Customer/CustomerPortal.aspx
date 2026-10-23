<%@ Page Title="BoxFactory - Customer Portal" Language="C#" AutoEventWireup="true" CodeBehind="CustomerPortal.aspx.cs" Inherits="WebApplication1.CustomerPages.CustomerPortal" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>BoxFactory - Customer Portal</title>

    <!-- BoxFactory Dedicated Stylesheet -->
    <link href="<%= ResolveUrl("~/Content/boxfactory.css") %>" rel="stylesheet" type="text/css" />
    <link rel="shortcut icon" href="<%= ResolveUrl("~/favicon.ico") %>" type="image/x-icon" />

    <!-- Preloaded JSON Data from Server -->
    <script type="text/javascript">
        window.preloadedBoxData = <%= PreloadedJsonData %>;
    </script>
</head>
<body>
    <form id="form1" runat="server" ClientIDMode="Static">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />

        <asp:UpdatePanel ID="upMain" runat="server" UpdateMode="Always">
            <ContentTemplate>

                <!-- Hidden State Sync Fields -->
                <asp:HiddenField ID="hfCustomerTab" runat="server" Value="home" />

                <!-- ========================================================
                     CUSTOMER PORTAL SHELL (Home, Place Order, Track, My Orders)
                     ======================================================== -->
                <div id="screen-customer-portal" class="screen-view active-screen purple-portal">
                    <div class="app-container">
                        <!-- Customer Sidebar -->
                        <aside class="app-sidebar">
                            <div class="sidebar-header">
                                <div class="sidebar-logo-icon">B</div>
                                <div style="flex-grow: 1;">
                                    <div class="sidebar-brand-text">BoxFactory</div>
                                    <span class="portal-tag-badge purple-badge">CUSTOMER PORTAL</span>
                                </div>
                            </div>

                            <div class="sidebar-section-label">PORTAL</div>

                            <ul class="sidebar-menu">
                                <li class='<%= GetCustomerTabClass("home") %>'>
                                    <asp:LinkButton runat="server" OnCommand="btnNavCustomerTab_Command" CommandName="home" style="display:flex; align-items:center; gap:12px; color:inherit; text-decoration:none; width:100%;">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                                        <span>Home</span>
                                    </asp:LinkButton>
                                </li>
                                <li class='<%= GetCustomerTabClass("place-order") %>'>
                                    <asp:LinkButton runat="server" OnCommand="btnNavCustomerTab_Command" CommandName="place-order" style="display:flex; align-items:center; gap:12px; color:inherit; text-decoration:none; width:100%;">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg>
                                        <span>Place Order</span>
                                    </asp:LinkButton>
                                </li>
                                <li class='<%= GetCustomerTabClass("track-order") %>'>
                                    <asp:LinkButton runat="server" OnCommand="btnNavCustomerTab_Command" CommandName="track-order" style="display:flex; align-items:center; gap:12px; color:inherit; text-decoration:none; width:100%;">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg>
                                        <span>Track Order</span>
                                    </asp:LinkButton>
                                </li>
                                <li class='<%= GetCustomerTabClass("my-orders") %>'>
                                    <asp:LinkButton runat="server" OnCommand="btnNavCustomerTab_Command" CommandName="my-orders" style="display:flex; align-items:center; gap:12px; color:inherit; text-decoration:none; width:100%;">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                                        <span>My Orders</span>
                                    </asp:LinkButton>
                                </li>
                            </ul>

                            <div class="sidebar-footer-user">
                                <div class="user-profile-summary">
                                    <div class="avatar-circle purple-avatar">AL</div>
                                    <div>
                                        <div class="user-name-tag">Apex Logistics</div>
                                        <div class="user-role-subtext">Verified Client</div>
                                    </div>
                                </div>
                                <asp:Button ID="btnSignOutCustomer" runat="server" Text="Sign Out" CssClass="btn-signout" OnClick="btnSignOut_Click" />
                            </div>
                        </aside>

                        <!-- Customer Main Content -->
                        <main class="app-main">
                            <div class="portal-topbar">
                                <h1 class="portal-page-title" id="customerPageTitle">
                                    <%= CurrentCustomerTab == "home" ? "Home" : (CurrentCustomerTab == "place-order" ? "Place Order" : (CurrentCustomerTab == "track-order" ? "Track Order" : "My Orders")) %>
                                </h1>
                                <div style="display:flex; align-items:center; gap: 8px;">
                                    <span style="font-size:13px; font-weight:700; color:#334155;">Apex</span>
                                    <div class="avatar-circle purple-avatar" style="width:30px; height:30px; font-size:11px;">AL</div>
                                </div>
                            </div>

                            <div class="portal-content-body">

                                <!-- ==============================================
                                     CUSTOMER TAB 1: HOME
                                     ============================================== -->
                                <div id="customer-tab-home" class="portal-tab-content" style='<%= "display:" + GetCustomerTabDisplay("home") + ";" %>'>
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
                                        <asp:LinkButton runat="server" CssClass="quick-action-card" OnCommand="btnNavCustomerTab_Command" CommandName="place-order" style="text-decoration:none; color:inherit;">
                                            <div class="quick-action-icon">
                                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"></path><line x1="3" y1="6" x2="21" y2="6"></line><path d="M16 10a4 4 0 0 1-8 0"></path></svg>
                                            </div>
                                            <div>
                                                <div class="quick-action-title">Place Order</div>
                                                <div class="quick-action-subtitle">Fast quantity re-order in 1-click</div>
                                            </div>
                                        </asp:LinkButton>
                                        <asp:LinkButton runat="server" CssClass="quick-action-card" OnCommand="btnNavCustomerTab_Command" CommandName="track-order" style="text-decoration:none; color:inherit;">
                                            <div class="quick-action-icon">
                                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s-8-4.5-8-11.8A8 8 0 0 1 12 2a8 8 0 0 1 8 8.2c0 7.3-8 11.8-8 11.8z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                                            </div>
                                            <div>
                                                <div class="quick-action-title">Track Order</div>
                                                <div class="quick-action-subtitle">View live delivery status</div>
                                            </div>
                                        </asp:LinkButton>
                                        <asp:LinkButton runat="server" CssClass="quick-action-card" OnCommand="btnNavCustomerTab_Command" CommandName="my-orders" style="text-decoration:none; color:inherit;">
                                            <div class="quick-action-icon">
                                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
                                            </div>
                                            <div>
                                                <div class="quick-action-title">Order History</div>
                                                <div class="quick-action-subtitle">View past invoices &amp; receipts</div>
                                            </div>
                                        </asp:LinkButton>
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
                                            <asp:LinkButton runat="server" CssClass="btn-table-action" OnCommand="btnNavCustomerTab_Command" CommandName="my-orders">View All</asp:LinkButton>
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
                                </div>

                                <!-- ==============================================
                                     CUSTOMER TAB 2: PLACE ORDER
                                     ============================================== -->
                                <div id="customer-tab-place-order" class="portal-tab-content" style='<%= "display:" + GetCustomerTabDisplay("place-order") + ";" %>'>
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
                                </div>

                                <!-- ==============================================
                                     CUSTOMER TAB 3: TRACK ORDER
                                     ============================================== -->
                                <div id="customer-tab-track-order" class="portal-tab-content" style='<%= "display:" + GetCustomerTabDisplay("track-order") + ";" %>'>
                                    <div class="track-search-card">
                                        <h2 class="panel-title">Track Your Order</h2>
                                        <div class="track-input-row">
                                            <asp:TextBox ID="trackSearchInput" runat="server" CssClass="form-control-input purple-focus" placeholder="Enter Order ID e.g. ORD-1041" Text="ORD-1041" />
                                            <asp:Button ID="btnTrackSearch" runat="server" Text="Track" CssClass="btn-primary-purple" style="width:auto; padding:10px 24px;" OnCommand="btnNavCustomerTab_Command" CommandName="track-order" />
                                        </div>
                                    </div>

                                    <div class="panel-title" style="margin-bottom:14px;">Active Orders</div>
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
                                                    <div class="stepper-step completed">
                                                        <div class="step-dot-wrap"><div class="step-dot"></div></div>
                                                        <div class="step-title">Confirmed</div>
                                                    </div>
                                                    <div class="stepper-step active">
                                                        <div class="step-dot-wrap"><div class="step-dot"></div></div>
                                                        <div class="step-title">Production</div>
                                                    </div>
                                                    <div class="stepper-step">
                                                        <div class="step-dot-wrap"><div class="step-dot"></div></div>
                                                        <div class="step-title">Quality Check</div>
                                                    </div>
                                                    <div class="stepper-step">
                                                        <div class="step-dot-wrap"><div class="step-dot"></div></div>
                                                        <div class="step-title">Dispatched</div>
                                                    </div>
                                                    <div class="stepper-step">
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
                                    </div>
                                </div>

                                <!-- ==============================================
                                     CUSTOMER TAB 4: MY ORDERS
                                     ============================================== -->
                                <div id="customer-tab-my-orders" class="portal-tab-content" style='<%= "display:" + GetCustomerTabDisplay("my-orders") + ";" %>'>
                                    <div class="panel-header-row" style="margin-bottom: 16px;">
                                        <h2 class="panel-title">All Orders</h2>
                                        <asp:LinkButton runat="server" CssClass="btn-teal-action" style="background:var(--purple-600);" OnCommand="btnNavCustomerTab_Command" CommandName="place-order">+ New Order</asp:LinkButton>
                                    </div>

                                    <div class="content-panel-card">
                                        <div class="data-table-container">
                                            <table class="data-table">
                                                <thead>
                                                    <tr>
                                                        <th>Order ID</th>
                                                        <th>Ply / Specs</th>
                                                        <th>Qty</th>
                                                        <th>Amount</th>
                                                        <th>Placed On</th>
                                                        <th>ETA</th>
                                                        <th>Status</th>
                                                        <th>Invoice</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="custAllOrdersTbody">
                                                    <asp:Repeater ID="rptCustAllOrders" runat="server" OnItemCommand="rptCustAllOrders_ItemCommand">
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td><span class="order-id-link"><%# Eval("Id") %></span><%# (bool)Eval("IsRepeatOrder") ? "<span class=\"badge-status first-order-badge\" style=\"background:#ede9fe; color:#6d28d9; border-color:#ddd6fe; margin-left:6px;\">REPEAT ORDER</span>" : "" %></td>
                                                                <td><%# GetSpecsText(Eval("Specs")) %></td>
                                                                <td><strong><%# string.Format("{0:N0}", Eval("Quantity")) %></strong></td>
                                                                <td><strong>&#8377;<%# string.Format("{0:N0}", Eval("TotalPrice")) %></strong></td>
                                                                <td><span style="font-size: 12px; color: #64748b;"><%# FormatDate(Eval("PlacedDate")) %></span></td>
                                                                <td><span style="font-size: 12px; font-weight:600; color: #334155;"><%# Eval("ETA") ?? "20 Oct 2026" %></span></td>
                                                                <td><span class='badge-status <%# GetStatusClass((string)Eval("Status")) %>'><%# Eval("Status") %></span></td>
                                                                <td><asp:LinkButton ID="btnViewReceipt" runat="server" CssClass="btn-table-action" CommandName="ViewReceipt" CommandArgument='<%# Eval("Id") %>'>Receipt</asp:LinkButton></td>
                                                            </tr>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>

                            </div><!-- /portal-content-body -->
                        </main>
                    </div><!-- /app-container -->
                </div><!-- /screen-customer-portal -->

                <!-- ========================================================
                     MODAL: INVOICE / RECEIPT
                     ======================================================== -->
                <div id="modalGeneric" class="modal-overlay-backdrop">
                    <div class="modal-container-card">
                        <button type="button" class="modal-close-cross" onclick="window.BoxApp.closeModal('modalGeneric')">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                        </button>
                        <asp:Label ID="genericModalTitle" runat="server" CssClass="modal-heading">Details</asp:Label>
                        <div id="genericModalBody" style="margin-top:16px;">
                            <asp:Literal ID="litGenericModalContent" runat="server" />
                        </div>
                    </div>
                </div>

                <!-- Toast Notification Alert -->
                <asp:Label ID="toastNotification" runat="server" CssClass="toast-notice" />

            </ContentTemplate>
        </asp:UpdatePanel>
    </form>

    <!-- Client-Side Engine -->
    <script src="<%= ResolveUrl("~/Scripts/boxfactory.js") %>" type="text/javascript" charset="utf-8"></script>
</body>
</html>
