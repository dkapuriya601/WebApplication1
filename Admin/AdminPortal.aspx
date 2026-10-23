<%@ Page Title="BoxFactory - Admin Portal" Language="C#" AutoEventWireup="true" CodeBehind="AdminPortal.aspx.cs" Inherits="WebApplication1.AdminPages.AdminPortal" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>BoxFactory - Admin Portal</title>

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
                <asp:HiddenField ID="hfAdminTab" runat="server" Value="dashboard" />
                <asp:HiddenField ID="hfActiveModal" runat="server" Value="none" />

                <!-- ========================================================
                     ADMIN PORTAL SHELL (Dashboard, Orders, Inventory, Customers)
                     ======================================================== -->
                <div id="screen-admin-portal" class="screen-view active-screen">
                    <div class="app-container">
                        <!-- Admin Sidebar -->
                        <aside class="app-sidebar">
                            <div class="sidebar-header">
                                <div class="sidebar-logo-icon">B</div>
                                <div style="flex-grow: 1;">
                                    <div class="sidebar-brand-text">BoxFactory</div>
                                    <span class="portal-tag-badge">ADMIN PANEL</span>
                                </div>
                            </div>

                            <div class="sidebar-section-label">FACTORY</div>

                            <ul class="sidebar-menu">
                                <li class='<%= GetAdminTabClass("dashboard") %>'>
                                    <asp:LinkButton runat="server" OnCommand="btnNavAdminTab_Command" CommandName="dashboard" style="display:flex; align-items:center; gap:12px; color:inherit; text-decoration:none; width:100%;">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                                        <span>Dashboard</span>
                                    </asp:LinkButton>
                                </li>
                                <li class='<%= GetAdminTabClass("orders") %>'>
                                    <asp:LinkButton runat="server" OnCommand="btnNavAdminTab_Command" CommandName="orders" style="display:flex; align-items:center; gap:12px; color:inherit; text-decoration:none; width:100%;">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                                        <span>Orders</span>
                                    </asp:LinkButton>
                                </li>
                                <li class='<%= GetAdminTabClass("inventory") %>'>
                                    <asp:LinkButton runat="server" OnCommand="btnNavAdminTab_Command" CommandName="inventory" style="display:flex; align-items:center; gap:12px; color:inherit; text-decoration:none; width:100%;">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path><polyline points="3.27 6.96 12 12.01 20.73 6.96"></polyline><line x1="12" y1="22.08" x2="12" y2="12"></line></svg>
                                        <span>Inventory</span>
                                    </asp:LinkButton>
                                </li>
                                <li class='<%= GetAdminTabClass("customers") %>'>
                                    <asp:LinkButton runat="server" OnCommand="btnNavAdminTab_Command" CommandName="customers" style="display:flex; align-items:center; gap:12px; color:inherit; text-decoration:none; width:100%;">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                                        <span>Customers</span>
                                    </asp:LinkButton>
                                </li>
                            </ul>

                            <div class="sidebar-footer-user">
                                <div class="user-profile-summary">
                                    <div class="avatar-circle">AD</div>
                                    <div>
                                        <div class="user-name-tag">Admin</div>
                                        <div class="user-role-subtext">Factory Manager</div>
                                    </div>
                                </div>
                                <asp:Button ID="btnSignOutAdmin" runat="server" Text="Sign Out" CssClass="btn-signout" OnClick="btnSignOut_Click" />
                            </div>
                        </aside>

                        <!-- Admin Main Content -->
                        <main class="app-main">
                            <div class="portal-topbar">
                                <h1 class="portal-page-title" id="adminPageTitle">
                                    <%= CurrentAdminTab == "dashboard" ? "Dashboard" : (CurrentAdminTab == "orders" ? "Orders" : (CurrentAdminTab == "inventory" ? "Inventory" : "Customers")) %>
                                </h1>
                                <div class="live-indicator-pill">
                                    <span class="pulse-dot"></span>
                                    <span>Production: Live</span>
                                </div>
                            </div>

                            <div class="portal-content-body">

                                <!-- ==============================================
                                     TAB 1: ADMIN DASHBOARD
                                     ============================================== -->
                                <div id="admin-tab-dashboard" class="portal-tab-content" style='<%= "display:" + GetAdminTabDisplay("dashboard") + ";" %>'>
                                    <!-- 4 KPI Stat Cards -->
                                    <div class="kpi-cards-grid">
                                        <div class="kpi-card">
                                            <div class="kpi-icon-pill teal">
                                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path></svg>
                                            </div>
                                            <div>
                                                <div class="kpi-value"><asp:Label ID="lblTotalBoxesProduced" runat="server">4,820</asp:Label></div>
                                                <div class="kpi-label">Total Boxes Produced</div>
                                            </div>
                                        </div>
                                        <div class="kpi-card">
                                            <div class="kpi-icon-pill amber">
                                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                            </div>
                                            <div>
                                                <div class="kpi-value"><asp:Label ID="lblPendingOrdersCount" runat="server">38</asp:Label></div>
                                                <div class="kpi-label">Pending Orders</div>
                                            </div>
                                        </div>
                                        <div class="kpi-card">
                                            <div class="kpi-icon-pill purple">
                                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle></svg>
                                            </div>
                                            <div>
                                                <div class="kpi-value"><asp:Label ID="lblActiveCustomersCount" runat="server">24</asp:Label></div>
                                                <div class="kpi-label">Active Customers</div>
                                            </div>
                                        </div>
                                        <div class="kpi-card">
                                            <div class="kpi-icon-pill green">
                                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 3h12"></path><path d="M6 8h12"></path><path d="m6 13 8.5 8"></path><path d="M6 13h3"></path><path d="M9 13c6.667 0 6.667-10 0-10"></path></svg>
                                            </div>
                                            <div>
                                                <div class="kpi-value"><asp:Label ID="lblTotalRevenueAmount" runat="server">&#8377;70L</asp:Label></div>
                                                <div class="kpi-label">Total Revenue</div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Dashboard Main Columns -->
                                    <div class="dashboard-columns">
                                        <!-- Left: Recent Orders Table -->
                                        <div class="content-panel-card">
                                            <div class="panel-header-row">
                                                <h2 class="panel-title">Recent Orders</h2>
                                                <asp:LinkButton runat="server" CssClass="btn-table-action" OnCommand="btnNavAdminTab_Command" CommandName="orders">View All</asp:LinkButton>
                                            </div>
                                            <div class="data-table-container">
                                                <table class="data-table">
                                                    <thead>
                                                        <tr>
                                                            <th>Order</th>
                                                            <th>Customer</th>
                                                            <th>Qty</th>
                                                            <th>Status</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="adminRecentOrdersTbody">
                                                        <asp:Repeater ID="rptRecentOrders" runat="server">
                                                            <ItemTemplate>
                                                                <tr>
                                                                    <td><span class="order-id-link"><%# Eval("Id") %></span></td>
                                                                    <td><div class="order-company-title"><%# Eval("CompanyName") %></div></td>
                                                                    <td><strong><%# string.Format("{0:N0}", Eval("Quantity")) %></strong></td>
                                                                    <td><span class='badge-status <%# GetStatusClass((string)Eval("Status")) %>'><%# Eval("Status") %></span></td>
                                                                </tr>
                                                            </ItemTemplate>
                                                        </asp:Repeater>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>

                                        <!-- Right: Machines Card -->
                                        <div class="content-panel-card">
                                            <div class="panel-header-row">
                                                <h2 class="panel-title">Machines</h2>
                                            </div>
                                            <div class="machines-list" id="adminMachinesList">
                                                <asp:Repeater ID="rptMachines" runat="server">
                                                    <ItemTemplate>
                                                        <div class="machine-status-row">
                                                            <div class="machine-name-line">
                                                                <span class="machine-name-text"><%# Eval("Name") %></span>
                                                                <span class='badge-machine <%# Eval("BadgeClass") %>'><%# Eval("Status") %></span>
                                                            </div>
                                                            <div class="machine-progress-bg">
                                                                <div class="machine-progress-fill" style='<%# "width:" + Eval("ProgressPercent") + "%;" %>'></div>
                                                            </div>
                                                            <div class="machine-subtext"><%# Eval("SpeedMetric") %></div>
                                                        </div>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- ==============================================
                                     TAB 2: ADMIN ORDERS
                                     ============================================== -->
                                <div id="admin-tab-orders" class="portal-tab-content" style='<%= "display:" + GetAdminTabDisplay("orders") + ";" %>'>
                                    <div class="table-controls-bar">
                                        <div class="search-input-box">
                                            <svg class="search-icon-inside" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                                            <asp:TextBox ID="txtOrderSearch" runat="server" placeholder="Search by order ID or company..." AutoPostBack="true" OnTextChanged="txtOrderSearch_TextChanged" oninput="window.BoxApp && window.BoxApp.handleOrderSearch ? window.BoxApp.handleOrderSearch(this.value) : null" />
                                        </div>

                                        <div class="filter-pills-group" id="ordersFilterPills">
                                            <asp:LinkButton runat="server" CssClass='<%= OrderStatusFilter == "All" ? "filter-pill-btn active" : "filter-pill-btn" %>' OnCommand="btnFilterOrders_Command" CommandName="All">All</asp:LinkButton>
                                            <asp:LinkButton runat="server" CssClass='<%= OrderStatusFilter == "Pending" ? "filter-pill-btn active" : "filter-pill-btn" %>' OnCommand="btnFilterOrders_Command" CommandName="Pending">Pending</asp:LinkButton>
                                            <asp:LinkButton runat="server" CssClass='<%= OrderStatusFilter == "Confirmed" ? "filter-pill-btn active" : "filter-pill-btn" %>' OnCommand="btnFilterOrders_Command" CommandName="Confirmed">Confirmed</asp:LinkButton>
                                            <asp:LinkButton runat="server" CssClass='<%= OrderStatusFilter == "In Production" ? "filter-pill-btn active" : "filter-pill-btn" %>' OnCommand="btnFilterOrders_Command" CommandName="In Production">In Production</asp:LinkButton>
                                            <asp:LinkButton runat="server" CssClass='<%= OrderStatusFilter == "Quality Check" ? "filter-pill-btn active" : "filter-pill-btn" %>' OnCommand="btnFilterOrders_Command" CommandName="Quality Check">Quality Check</asp:LinkButton>
                                            <asp:LinkButton runat="server" CssClass='<%= OrderStatusFilter == "Dispatched" ? "filter-pill-btn active" : "filter-pill-btn" %>' OnCommand="btnFilterOrders_Command" CommandName="Dispatched">Dispatched</asp:LinkButton>
                                            <asp:LinkButton runat="server" CssClass='<%= OrderStatusFilter == "Delivered" ? "filter-pill-btn active" : "filter-pill-btn" %>' OnCommand="btnFilterOrders_Command" CommandName="Delivered">Delivered</asp:LinkButton>
                                        </div>

                                        <button type="button" class="btn-teal-action" onclick="window.BoxApp.openNewOrderModal()">
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                                            <span>New Order</span>
                                        </button>
                                    </div>

                                    <div class="content-panel-card">
                                        <div class="data-table-container">
                                            <table class="data-table">
                                                <thead>
                                                    <tr>
                                                        <th>Order ID</th>
                                                        <th>Company</th>
                                                        <th>Box Specs</th>
                                                        <th>Qty</th>
                                                        <th>Price</th>
                                                        <th>Placed By</th>
                                                        <th>Status</th>
                                                        <th>Due Date</th>
                                                        <th>Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="adminAllOrdersTbody">
                                                    <asp:Repeater ID="rptAllOrders" runat="server" OnItemCommand="rptAllOrders_ItemCommand">
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td>
                                                                    <span class="order-id-link"><%# Eval("Id") %></span>
                                                                    <%# (bool)Eval("IsFirstOrder") ? "<span class=\"badge-status first-order-badge\" style=\"margin-left: 6px;\">FIRST ORDER</span>" : "" %>
                                                                </td>
                                                                <td><div class="order-company-title"><%# Eval("CompanyName") %></div></td>
                                                                <td><%# GetSpecsText(Eval("Specs")) %></td>
                                                                <td><strong><%# string.Format("{0:N0}", Eval("Quantity")) %></strong></td>
                                                                <td><strong>&#8377;<%# string.Format("{0:N0}", Eval("TotalPrice")) %></strong></td>
                                                                <td><span style="font-size: 12px; color: #475569;"><%# (string)Eval("PlacedBy") == "Admin" ? "🛠 Admin" : "👤 Customer" %></span></td>
                                                                <td>
                                                                    <span class='badge-status <%# GetStatusClass((string)Eval("Status")) %>'><%# Eval("Status") %></span>
                                                                </td>
                                                                <td><span style="font-size: 12px; color: #64748b;"><%# FormatDate(Eval("DueDate")) %></span></td>
                                                                <td>
                                                                    <asp:LinkButton ID="btnViewInvoice" runat="server" CssClass="btn-table-action" CommandName="ViewInvoice" CommandArgument='<%# Eval("Id") %>'>View</asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>

                                <!-- ==============================================
                                     TAB 3: ADMIN INVENTORY
                                     ============================================== -->
                                <div id="admin-tab-inventory" class="portal-tab-content" style='<%= "display:" + GetAdminTabDisplay("inventory") + ";" %>'>
                                    <div class="inventory-tabs-switch">
                                        <button type="button" class="inventory-tab-btn active" data-inv-tab="raw" onclick="window.BoxApp.setInventoryTab('raw')">Raw Materials</button>
                                        <button type="button" class="inventory-tab-btn" data-inv-tab="finished" onclick="window.BoxApp.setInventoryTab('finished')">Finished Stock</button>
                                    </div>

                                    <!-- Raw Materials Table -->
                                    <div id="inventoryRawMaterialsSection" class="content-panel-card">
                                        <div class="data-table-container">
                                            <table class="data-table">
                                                <thead>
                                                    <tr>
                                                        <th>SKU / Item</th>
                                                        <th>Stock</th>
                                                        <th>Reorder At</th>
                                                        <th>Level</th>
                                                        <th>Supplier</th>
                                                        <th>Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="inventoryRawMaterialsTbody">
                                                    <asp:Repeater ID="rptRawMaterials" runat="server" OnItemCommand="rptRawMaterials_ItemCommand">
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td><strong><%# Eval("Name") %></strong><br/><span style="font-size: 11px; color: #64748b;"><%# Eval("Sku") %> • <%# Eval("Category") %></span></td>
                                                                <td><strong><%# string.Format("{0:N0}", Eval("StockQty")) %> <%# Eval("Unit") %></strong></td>
                                                                <td><%# string.Format("{0:N0}", Eval("ReorderAt")) %> <%# Eval("Unit") %></td>
                                                                <td><span class='badge-level <%# GetLevelClass((string)Eval("Level")) %>'><%# Eval("Level") %></span></td>
                                                                <td><%# Eval("Supplier") %></td>
                                                                <td>
                                                                    <asp:LinkButton ID="btnRestockMaterial" runat="server" CssClass="btn-table-action" CommandName="Restock" CommandArgument='<%# Eval("Sku") %>'>+ Restock 500</asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>

                                    <!-- Finished Stock Table -->
                                    <div id="inventoryFinishedStockSection" class="content-panel-card" style="display:none;">
                                        <div class="data-table-container">
                                            <table class="data-table">
                                                <thead>
                                                    <tr>
                                                        <th>Item Code / Description</th>
                                                        <th>Box Specs</th>
                                                        <th>Available Stock</th>
                                                        <th>Reserved Qty</th>
                                                        <th>Pallets</th>
                                                        <th>Status</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="inventoryFinishedStockTbody">
                                                    <asp:Repeater ID="rptFinishedStock" runat="server">
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td><strong><%# Eval("ItemCode") %></strong><br/><span style="font-size: 11px; color: #64748b;"><%# Eval("Description") %></span></td>
                                                                <td><%# Eval("BoxSpecs") %></td>
                                                                <td><strong><%# string.Format("{0:N0}", Eval("AvailableQty")) %> boxes</strong></td>
                                                                <td><%# string.Format("{0:N0}", Eval("ReservedQty")) %> (<%# Eval("ReservedFor") %>)</td>
                                                                <td><%# Eval("Pallets") %></td>
                                                                <td><span class="badge-status in-production"><%# Eval("Status") %></span></td>
                                                            </tr>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>

                                <!-- ==============================================
                                     TAB 4: ADMIN CUSTOMERS
                                     ============================================== -->
                                <div id="admin-tab-customers" class="portal-tab-content" style='<%= "display:" + GetAdminTabDisplay("customers") + ";" %>'>
                                    <!-- 3 Top Stats Cards -->
                                    <div class="kpi-cards-grid three-cards">
                                        <div class="kpi-card">
                                            <div class="kpi-icon-pill purple">
                                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle></svg>
                                            </div>
                                            <div>
                                                <div class="kpi-value"><asp:Label ID="lblTotalCustomersCount" runat="server">8</asp:Label></div>
                                                <div class="kpi-label">Total Customers</div>
                                            </div>
                                        </div>
                                        <div class="kpi-card">
                                            <div class="kpi-icon-pill teal">
                                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                            </div>
                                            <div>
                                                <div class="kpi-value"><asp:Label ID="lblActiveCustomersCountTab" runat="server">8</asp:Label></div>
                                                <div class="kpi-label">Active</div>
                                            </div>
                                        </div>
                                        <div class="kpi-card">
                                            <div class="kpi-icon-pill green">
                                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 3h12"></path><path d="M6 8h12"></path><path d="m6 13 8.5 8"></path><path d="M6 13h3"></path><path d="M9 13c6.667 0 6.667-10 0-10"></path></svg>
                                            </div>
                                            <div>
                                                <div class="kpi-value"><asp:Label ID="lblTotalRevenueCustomers" runat="server">&#8377;29L</asp:Label></div>
                                                <div class="kpi-label">Total Revenue</div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Search and filter bar -->
                                    <div class="table-controls-bar" style="margin-bottom: 16px;">
                                        <div class="search-input-box">
                                            <svg class="search-icon-inside" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                                            <asp:TextBox ID="txtCustomerSearch" runat="server" placeholder="Search customers..." AutoPostBack="true" OnTextChanged="txtCustomerSearch_TextChanged" />
                                        </div>
                                        <div class="filter-pills-group">
                                            <asp:LinkButton runat="server" CssClass='<%= CustomerSegmentFilter == "All" ? "filter-pill-btn active" : "filter-pill-btn" %>' OnCommand="btnFilterCustomers_Command" CommandName="All">All</asp:LinkButton>
                                            <asp:LinkButton runat="server" CssClass='<%= CustomerSegmentFilter == "Enterprise" ? "filter-pill-btn active" : "filter-pill-btn" %>' OnCommand="btnFilterCustomers_Command" CommandName="Enterprise">Enterprise</asp:LinkButton>
                                            <asp:LinkButton runat="server" CssClass='<%= CustomerSegmentFilter == "Mid-Market" ? "filter-pill-btn active" : "filter-pill-btn" %>' OnCommand="btnFilterCustomers_Command" CommandName="Mid-Market">Mid-Market</asp:LinkButton>
                                            <asp:LinkButton runat="server" CssClass='<%= CustomerSegmentFilter == "SMB" ? "filter-pill-btn active" : "filter-pill-btn" %>' OnCommand="btnFilterCustomers_Command" CommandName="SMB">SMB</asp:LinkButton>
                                        </div>
                                    </div>

                                    <!-- Customer Cards Grid -->
                                    <div class="customers-cards-grid" id="customersCardsGrid">
                                        <asp:Repeater ID="rptCustomers" runat="server" OnItemCommand="rptCustomers_ItemCommand">
                                            <ItemTemplate>
                                                <div class="customer-profile-card">
                                                    <div class="customer-card-top">
                                                        <div class="customer-avatar-box" style='background-color:<%# Eval("AvatarColor") %>'><%# Eval("AvatarInitials") %></div>
                                                        <div class="customer-card-info">
                                                            <div class="customer-card-name"><%# Eval("Name") %></div>
                                                            <div class="customer-card-meta"><%# Eval("City") %> · <%# Eval("Segment") %></div>
                                                            <div class="customer-card-contact"><%# Eval("ContactPerson") %></div>
                                                        </div>
                                                        <span class='badge-status <%# (string)Eval("Status") == "Active" ? "delivered" : "pending" %>'><%# Eval("Status") %></span>
                                                    </div>
                                                    <div class="customer-card-stats-row">
                                                        <div>
                                                            <div class="stat-sub-label">Orders</div>
                                                            <div class="stat-sub-val"><%# Eval("TotalOrders") %></div>
                                                        </div>
                                                        <div>
                                                            <div class="stat-sub-label">Total Spent</div>
                                                            <div class="stat-sub-val">&#8377;<%# Eval("TotalSpentFormatted") != null ? Eval("TotalSpentFormatted").ToString().TrimStart('₹', '\u20B9') : (Convert.ToDecimal(Eval("TotalSpent")) / 1000m).ToString("0") + "K" %></div>
                                                        </div>
                                                    </div>
                                                    <div style="margin-top: 12px; display: flex; justify-content: flex-end;">
                                                        <asp:LinkButton ID="btnCustDetail" runat="server" CssClass="btn-table-action" CommandName="ViewDetail" CommandArgument='<%# Eval("Id") %>'>View Profile</asp:LinkButton>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>
                                </div>

                            </div><!-- /portal-content-body -->
                        </main>
                    </div><!-- /app-container -->
                </div><!-- /screen-admin-portal -->

                <!-- ========================================================
                     MODAL 1: NEW ORDER STEP 1
                     ======================================================== -->
                <div id="modalNewOrderStep1" class="modal-overlay-backdrop">
                    <div class="modal-container-card">
                        <button type="button" class="modal-close-cross" onclick="window.BoxApp.closeModal('modalNewOrderStep1')">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                        </button>
                        <h3 class="modal-heading">New Order</h3>
                        <p class="modal-subheading">Choose the order type to continue</p>

                        <div class="new-order-type-cards">
                            <!-- Option 1: Repeat Order -->
                            <div class="order-type-card-choice" onclick="window.BoxApp.selectOrderType('repeat')">
                                <div class="choice-icon-box">
                                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 4 23 10 17 10"></polyline><polyline points="1 20 1 14 7 14"></polyline><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path></svg>
                                </div>
                                <div>
                                    <div class="choice-title">Repeat Order</div>
                                    <div class="choice-desc">Company already on file — fast order based on saved specs</div>
                                </div>
                            </div>

                            <!-- Option 2: First Order - New Company -->
                            <div class="order-type-card-choice" onclick="window.BoxApp.selectOrderType('new-company')">
                                <div class="choice-icon-box">
                                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><line x1="12" y1="8" x2="12" y2="16"></line><line x1="8" y1="12" x2="16" y2="12"></line></svg>
                                </div>
                                <div>
                                    <div class="choice-title">First Order — New Company</div>
                                    <div class="choice-desc">Save box specs (ply, GSM, size) for this company</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ========================================================
                     MODAL 2: REPEAT ORDER
                     ======================================================== -->
                <div id="modalRepeatOrder" class="modal-overlay-backdrop">
                    <div class="modal-container-card">
                        <button type="button" class="modal-close-cross" onclick="window.BoxApp.closeModal('modalRepeatOrder')">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                        </button>
                        <h3 class="modal-heading">New Order</h3>
                        <p class="modal-subheading">Choose the order type to continue</p>

                        <div class="form-group">
                            <label class="form-label">Select Company</label>
                            <asp:DropDownList ID="repeatOrderCompanySelect" runat="server" CssClass="form-control-input" AutoPostBack="true" OnSelectedIndexChanged="repeatOrderCompanySelect_SelectedIndexChanged" onchange="window.BoxApp && window.BoxApp.handleRepeatCompanyChange ? window.BoxApp.handleRepeatCompanyChange(this.value) : null" />
                        </div>

                        <div id="repeatOrderSpecPreview" style="display:none; background:#f0fdfa; border:1px solid #ccfbf1; border-radius:8px; padding:12px; margin-bottom:16px; font-size:12px; color:#0f766e;">
                            <!-- Auto populated spec -->
                        </div>

                        <div class="form-group">
                            <label class="form-label">Quantity (boxes)</label>
                            <asp:TextBox ID="repeatOrderQty" runat="server" TextMode="Number" CssClass="form-control-input" Text="100" min="1" oninput="window.BoxApp && window.BoxApp.updateRepeatOrderPrice ? window.BoxApp.updateRepeatOrderPrice() : null" />
                        </div>

                        <div style="font-size:15px; font-weight:700; color:#0f172a; margin-bottom:14px;" id="repeatOrderTotalWrapper">
                            <asp:Label ID="repeatOrderTotal" runat="server">Total: &#8377;4,800</asp:Label>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Notes (optional)</label>
                            <asp:TextBox ID="repeatOrderNotes" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control-input" placeholder="Any special instructions..." />
                        </div>

                        <div class="modal-actions-footer">
                            <button type="button" class="btn-secondary-outline" onclick="window.BoxApp.closeModal('modalRepeatOrder')">Cancel</button>
                            <asp:Button ID="btnSubmitRepeatOrder" runat="server" Text="Place Repeat Order" CssClass="btn-primary-teal" style="width:auto; padding:9px 20px;" OnClick="btnSubmitRepeatOrder_Click" />
                        </div>
                    </div>
                </div>

                <!-- ========================================================
                     MODAL 3: FIRST ORDER - NEW COMPANY
                     ======================================================== -->
                <div id="modalFirstOrder" class="modal-overlay-backdrop">
                    <div class="modal-container-card" style="max-width: 620px;">
                        <button type="button" class="modal-close-cross" onclick="window.BoxApp.closeModal('modalFirstOrder')">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                        </button>
                        <h3 class="modal-heading">New Order</h3>
                        <p class="modal-subheading">This company's box specification will be saved permanently for future repeat orders.</p>

                        <!-- Company Details -->
                        <div class="modal-form-section-title">Company Details</div>
                        <div class="form-row-2col">
                            <div class="form-group">
                                <label class="form-label">Company Name</label>
                                <asp:TextBox ID="firstOrderCompanyName" runat="server" CssClass="form-control-input" placeholder="e.g. Apex Logistics" />
                            </div>
                            <div class="form-group">
                                <label class="form-label">City</label>
                                <asp:TextBox ID="firstOrderCity" runat="server" CssClass="form-control-input" placeholder="e.g. Mumbai, MH" />
                            </div>
                        </div>
                        <div class="form-row-2col">
                            <div class="form-group">
                                <label class="form-label">Contact Person</label>
                                <asp:TextBox ID="firstOrderContact" runat="server" CssClass="form-control-input" placeholder="Full name" />
                            </div>
                            <div class="form-group">
                                <label class="form-label">Email</label>
                                <asp:TextBox ID="firstOrderEmail" runat="server" TextMode="Email" CssClass="form-control-input" placeholder="contact@company.com" />
                            </div>
                        </div>

                        <!-- Box Specification -->
                        <div class="modal-form-section-title">Box Specification</div>
                        <div class="form-row-2col">
                            <div class="form-group">
                                <label class="form-label">Ply</label>
                                <asp:DropDownList ID="firstOrderPly" runat="server" CssClass="form-control-input" />
                            </div>
                            <div class="form-group">
                                <label class="form-label">GSM of Paper</label>
                                <asp:DropDownList ID="firstOrderGsm" runat="server" CssClass="form-control-input" />
                            </div>
                        </div>

                        <label class="form-label">Box Dimensions (cm)</label>
                        <div class="form-row-3col">
                            <div class="form-group">
                                <span style="font-size:11px; color:#64748b;">Length (L)</span>
                                <asp:TextBox ID="firstOrderL" runat="server" TextMode="Number" CssClass="form-control-input" Text="40" />
                            </div>
                            <div class="form-group">
                                <span style="font-size:11px; color:#64748b;">Width (W)</span>
                                <asp:TextBox ID="firstOrderW" runat="server" TextMode="Number" CssClass="form-control-input" Text="30" />
                            </div>
                            <div class="form-group">
                                <span style="font-size:11px; color:#64748b;">Height (H)</span>
                                <asp:TextBox ID="firstOrderH" runat="server" TextMode="Number" CssClass="form-control-input" Text="25" />
                            </div>
                        </div>

                        <!-- Order Details -->
                        <div class="modal-form-section-title">Order Details</div>
                        <div class="form-group">
                            <label class="form-label">Quantity (boxes)</label>
                            <asp:TextBox ID="firstOrderQty" runat="server" TextMode="Number" CssClass="form-control-input" Text="100" min="1" oninput="window.BoxApp && window.BoxApp.calculateFirstOrderPrice ? window.BoxApp.calculateFirstOrderPrice() : null" />
                        </div>

                        <div style="font-size:16px; font-weight:700; color:#0f172a; margin-bottom:12px;" id="firstOrderTotalPreviewWrapper">
                            <asp:Label ID="firstOrderTotalPreview" runat="server">Total: &#8377;4,900</asp:Label>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Notes (optional)</label>
                            <asp:TextBox ID="firstOrderNotes" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control-input" placeholder="Any special instructions..." />
                        </div>

                        <div class="modal-actions-footer">
                            <button type="button" class="btn-secondary-outline" onclick="window.BoxApp.closeModal('modalFirstOrder')">Cancel</button>
                            <asp:Button ID="btnSubmitFirstOrder" runat="server" Text="Save Spec &amp; Place Order" CssClass="btn-primary-teal" style="width:auto; padding:9px 20px;" OnClick="btnSubmitFirstOrder_Click" />
                        </div>
                    </div>
                </div>

                <!-- ========================================================
                     MODAL 4: GENERIC MODAL (Customer Details / Invoice Receipt)
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
