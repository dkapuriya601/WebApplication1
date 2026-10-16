<%@ Page Title="BoxFactory - Box Manufacturing Management System" Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebApplication1._Default" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>BoxFactory - Box Manufacturing Management System</title>
    
    <!-- BoxFactory Dedicated Stylesheet -->
    <link href="Content/boxfactory.css" rel="stylesheet" type="text/css" />
    <link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />

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
                <asp:HiddenField ID="hfCurrentScreen" runat="server" Value="role-select" />
                <asp:HiddenField ID="hfAdminTab" runat="server" Value="dashboard" />
                <asp:HiddenField ID="hfCustomerTab" runat="server" Value="home" />
                <asp:HiddenField ID="hfActiveModal" runat="server" Value="none" />

                <!-- Top Interactive Figma Prototype Preview & Navigation Bar -->
                <header class="preview-nav-bar" id="previewNavBar">
                    <div class="brand-tag">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path><polyline points="3.27 6.96 12 12.01 20.73 6.96"></polyline><line x1="12" y1="22.08" x2="12" y2="12"></line></svg>
                        <span>FIGMA DESIGN PROTOTYPE</span>
                    </div>
                    <div class="links-wrap">
                        <asp:LinkButton runat="server" CssClass="preview-nav-btn active" OnCommand="btnNavScreen_Command" CommandName="role-select">1. Role Select</asp:LinkButton>
                        <asp:LinkButton runat="server" CssClass="preview-nav-btn" OnCommand="btnNavScreen_Command" CommandName="admin-login">2. Admin Login</asp:LinkButton>
                        <asp:LinkButton runat="server" CssClass="preview-nav-btn" OnCommand="btnNavScreen_Command" CommandName="admin-portal" CommandArgument="dashboard">3. Admin Dashboard</asp:LinkButton>
                        <asp:LinkButton runat="server" CssClass="preview-nav-btn" OnCommand="btnNavScreen_Command" CommandName="admin-portal" CommandArgument="orders">4. Orders</asp:LinkButton>
                        <asp:LinkButton runat="server" CssClass="preview-nav-btn" OnCommand="btnNavScreen_Command" CommandName="admin-portal" CommandArgument="inventory">5. Inventory</asp:LinkButton>
                        <asp:LinkButton runat="server" CssClass="preview-nav-btn" OnCommand="btnNavScreen_Command" CommandName="admin-portal" CommandArgument="customers">6. Customers</asp:LinkButton>
                        <asp:LinkButton runat="server" CssClass="preview-nav-btn" OnCommand="btnNavScreen_Command" CommandName="customer-login">7. Customer Login</asp:LinkButton>
                        <asp:LinkButton runat="server" CssClass="preview-nav-btn" OnCommand="btnNavScreen_Command" CommandName="customer-portal" CommandArgument="home">8. Customer Home</asp:LinkButton>
                        <asp:LinkButton runat="server" CssClass="preview-nav-btn" OnCommand="btnNavScreen_Command" CommandName="customer-portal" CommandArgument="place-order">9. Place Order</asp:LinkButton>
                        <asp:LinkButton runat="server" CssClass="preview-nav-btn" OnCommand="btnNavScreen_Command" CommandName="customer-portal" CommandArgument="track-order">10. Track Order</asp:LinkButton>
                        <asp:LinkButton runat="server" CssClass="preview-nav-btn" OnCommand="btnNavScreen_Command" CommandName="customer-portal" CommandArgument="my-orders">11. My Orders</asp:LinkButton>
                        <asp:LinkButton runat="server" CssClass="preview-nav-btn" style="background:#475569; color:#f1f5f9;" OnClick="btnResetData_Click">↺ Reset Data</asp:LinkButton>
                    </div>
                </header>

                <!-- ========================================================
                     SCREEN 1: ROLE SELECTION LANDING PAGE (Page 1 Top)
                     ======================================================== -->
                <main id="screen-role-select" class='<%= GetScreenClass("role-select") %>'>
                    <div class="auth-page-wrapper">
                        <div class="auth-brand-header">
                            <div class="brand-icon-box">B</div>
                            <h1>BoxFactory</h1>
                            <p>Box Manufacturing Management System</p>
                        </div>

                        <div class="auth-card">
                            <h2 class="auth-card-title">Sign in as</h2>
                            
                            <div class="role-options-list">
                                <!-- Admin Option Card -->
                                <asp:LinkButton runat="server" CssClass="role-select-card" OnCommand="btnNavScreen_Command" CommandName="admin-login" style="text-decoration:none; color:inherit; display:flex;">
                                    <div class="role-icon-box">
                                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 20V10"></path><path d="M12 20V4"></path><path d="M6 20v-6"></path></svg>
                                    </div>
                                    <div class="role-info">
                                        <div class="role-name">Admin</div>
                                        <div class="role-desc">Manage orders, inventory & customers</div>
                                    </div>
                                    <div class="role-arrow">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                    </div>
                                </asp:LinkButton>

                                <!-- Customer Option Card -->
                                <asp:LinkButton runat="server" CssClass="role-select-card role-customer" OnCommand="btnNavScreen_Command" CommandName="customer-login" style="text-decoration:none; color:inherit; display:flex;">
                                    <div class="role-icon-box">
                                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                                    </div>
                                    <div class="role-info">
                                        <div class="role-name">Customer</div>
                                        <div class="role-desc">Place orders, track deliveries & history</div>
                                    </div>
                                    <div class="role-arrow">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                    </div>
                                </asp:LinkButton>
                            </div>

                            <!-- Demo Credentials Helper -->
                            <div class="demo-tips-card">
                                <div class="demo-tips-title">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                                    <span>Demo Access Quick Links</span>
                                </div>
                                <div class="demo-row">
                                    <span>Admin: <code>admin@boxfactory.in | admin123</code></span>
                                    <asp:Button ID="btnQuickAdmin" runat="server" Text="Log In" CssClass="demo-quick-btn" OnClick="btnQuickAdmin_Click" />
                                </div>
                                <div class="demo-row">
                                    <span>Customer: <code>logistics@apex.com | apex123</code></span>
                                    <asp:Button ID="btnQuickCustomer" runat="server" Text="Log In" CssClass="demo-quick-btn" OnClick="btnQuickCustomer_Click" />
                                </div>
                            </div>

                            <div class="auth-footer-tag">BoxFactory Management System</div>
                        </div>
                    </div>
                </main>

                <!-- ========================================================
                     SCREEN 2: ADMIN LOGIN (Page 1 Middle)
                     ======================================================== -->
                <main id="screen-admin-login" class='<%= GetScreenClass("admin-login") %>'>
                    <div class="auth-page-wrapper">
                        <div class="auth-brand-header">
                            <div class="brand-icon-box">B</div>
                            <h1>BoxFactory</h1>
                            <p>Box Manufacturing Management System</p>
                        </div>

                        <div class="auth-card">
                            <div class="auth-card-header-with-icon">
                                <div class="auth-card-icon-pill">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 20V10"></path><path d="M12 20V4"></path><path d="M6 20v-6"></path></svg>
                                </div>
                                <div>
                                    <h2>Admin Login</h2>
                                    <p>Factory management access</p>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Email</label>
                                <asp:TextBox ID="adminLoginEmail" runat="server" TextMode="Email" CssClass="form-control-input" placeholder="admin@boxfactory.in" Text="admin@boxfactory.in" />
                            </div>

                            <div class="form-group">
                                <label class="form-label">Password</label>
                                <div class="password-input-wrapper">
                                    <asp:TextBox ID="adminLoginPassword" runat="server" TextMode="Password" CssClass="form-control-input" placeholder="••••••••" Text="admin123" />
                                    <button type="button" class="password-toggle-btn" onclick="window.BoxApp.togglePassword('adminLoginPassword')">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                    </button>
                                </div>
                            </div>

                            <asp:Button ID="btnAdminLogin" runat="server" Text="Sign In as Admin" CssClass="btn-primary-teal" OnClick="btnAdminLogin_Click" />
                            <asp:LinkButton runat="server" CssClass="btn-back-link" OnCommand="btnNavScreen_Command" CommandName="role-select">← Back</asp:LinkButton>

                            <div class="auth-footer-tag">BoxFactory Management System</div>
                        </div>
                    </div>
                </main>

                <!-- ========================================================
                     SCREEN 10: CUSTOMER LOGIN (Page 4 Middle)
                     ======================================================== -->
                <main id="screen-customer-login" class='<%= GetScreenClass("customer-login") %>'>
                    <div class="auth-page-wrapper">
                        <div class="auth-brand-header">
                            <div class="brand-icon-box purple-theme">B</div>
                            <h1>BoxFactory</h1>
                            <p>Box Manufacturing Management System</p>
                        </div>

                        <div class="auth-card">
                            <div class="auth-card-header-with-icon">
                                <div class="auth-card-icon-pill purple">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                                </div>
                                <div>
                                    <h2>Customer Login</h2>
                                    <p>Client portal & order tracking</p>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Email</label>
                                <asp:TextBox ID="customerLoginEmail" runat="server" TextMode="Email" CssClass="form-control-input purple-focus" placeholder="you@company.com" Text="logistics@apex.com" />
                            </div>

                            <div class="form-group">
                                <label class="form-label">Password</label>
                                <div class="password-input-wrapper">
                                    <asp:TextBox ID="customerLoginPassword" runat="server" TextMode="Password" CssClass="form-control-input purple-focus" placeholder="••••••••" Text="apex123" />
                                    <button type="button" class="password-toggle-btn" onclick="window.BoxApp.togglePassword('customerLoginPassword')">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                    </button>
                                </div>
                            </div>

                            <asp:Button ID="btnCustomerLogin" runat="server" Text="Sign In as Customer" CssClass="btn-primary-purple" OnClick="btnCustomerLogin_Click" />
                            <asp:LinkButton runat="server" CssClass="btn-back-link" OnCommand="btnNavScreen_Command" CommandName="role-select">← Back</asp:LinkButton>

                            <div class="auth-footer-tag">BoxFactory Management System</div>
                        </div>
                    </div>
                </main>

                <!-- ========================================================
                     ADMIN PORTAL SHELL (Screens 3, 4, 8, 9)
                     ======================================================== -->
                <div id="screen-admin-portal" class='<%= GetScreenClass("admin-portal") %>'>
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
                                     TAB 1: ADMIN DASHBOARD (Page 1 Bottom)
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
                                     TAB 2: ADMIN ORDERS (Page 2 Top)
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
                                     TAB 3: ADMIN INVENTORY (Page 3 Bottom)
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
                                     TAB 4: ADMIN CUSTOMERS (Page 4 Top)
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
                                            <div class="kpi-icon-pill green">
                                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                            </div>
                                            <div>
                                                <div class="kpi-value"><asp:Label ID="lblActiveCustomersCountTab" runat="server">7</asp:Label></div>
                                                <div class="kpi-label">Active</div>
                                            </div>
                                        </div>
                                        <div class="kpi-card">
                                            <div class="kpi-icon-pill teal">
                                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 3h12"></path><path d="M6 8h12"></path><path d="m6 13 8.5 8"></path><path d="M6 13h3"></path><path d="M9 13c6.667 0 6.667-10 0-10"></path></svg>
                                            </div>
                                            <div>
                                                <div class="kpi-value"><asp:Label ID="lblTotalRevenueCustomers" runat="server">&#8377;29.9L</asp:Label></div>
                                                <div class="kpi-label">Total Revenue</div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="table-controls-bar">
                                        <div class="filter-pills-group" id="customersFilterPills">
                                            <asp:LinkButton runat="server" CssClass='<%= CustomerSegmentFilter == "All" ? "filter-pill-btn active" : "filter-pill-btn" %>' OnCommand="btnFilterCustomers_Command" CommandName="All">All</asp:LinkButton>
                                            <asp:LinkButton runat="server" CssClass='<%= CustomerSegmentFilter == "Enterprise" ? "filter-pill-btn active" : "filter-pill-btn" %>' OnCommand="btnFilterCustomers_Command" CommandName="Enterprise">Enterprise</asp:LinkButton>
                                            <asp:LinkButton runat="server" CssClass='<%= CustomerSegmentFilter == "Mid-Market" ? "filter-pill-btn active" : "filter-pill-btn" %>' OnCommand="btnFilterCustomers_Command" CommandName="Mid-Market">Mid-Market</asp:LinkButton>
                                            <asp:LinkButton runat="server" CssClass='<%= CustomerSegmentFilter == "SMB" ? "filter-pill-btn active" : "filter-pill-btn" %>' OnCommand="btnFilterCustomers_Command" CommandName="SMB">SMB</asp:LinkButton>
                                        </div>

                                        <div class="search-input-box">
                                            <svg class="search-icon-inside" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                                            <asp:TextBox ID="txtCustomerSearch" runat="server" placeholder="Search customers..." AutoPostBack="true" OnTextChanged="txtCustomerSearch_TextChanged" oninput="window.BoxApp && window.BoxApp.handleCustomerSearch ? window.BoxApp.handleCustomerSearch(this.value) : null" />
                                        </div>
                                    </div>

                                    <!-- 8 Customer Cards in 4x2 Grid -->
                                    <div class="customer-cards-grid" id="adminCustomersGrid">
                                        <asp:Repeater ID="rptCustomers" runat="server" OnItemCommand="rptCustomers_ItemCommand">
                                            <ItemTemplate>
                                                <div class="customer-card">
                                                    <div class="customer-card-header">
                                                        <div class="customer-avatar-box" style='<%# "background-color:" + (Eval("AvatarColor") ?? "#0d9488") + ";" %>'><%# Eval("AvatarInitials") %></div>
                                                        <div>
                                                            <div class="customer-name-text"><%# Eval("Name") %></div>
                                                            <div class="customer-sub-meta"><%# Eval("City") %> • <%# Eval("Segment") %></div>
                                                        </div>
                                                    </div>
                                                    <div class="customer-spec-strip">
                                                        <div class="spec-label-small">Saved Specification</div>
                                                        <div class="spec-value-strong"><%# GetSpecSummary(Eval("DefaultSpec")) %></div>
                                                        <div class="spec-sub-dims"><%# GetSpecDimensions(Eval("DefaultSpec")) %> | Standard Rate: &#8377;<%# GetSpecRate(Eval("DefaultSpec")) %>/box</div>
                                                    </div>
                                                    <div class="customer-stats-bar">
                                                        <div>
                                                            <div class="stat-sub-label">Orders</div>
                                                            <div class="stat-sub-val"><%# Eval("TotalOrders") %></div>
                                                        </div>
                                                        <div style="text-align: right;">
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
                            </div>
                        </main>
                    </div>
                </div>

                <!-- ========================================================
                     CUSTOMER PORTAL SHELL (Screens 11, 12, 13, 14)
                     ======================================================== -->
                <div id="screen-customer-portal" class='<%= GetScreenClass("customer-portal") + " purple-portal" %>'>
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
                                     CUSTOMER TAB 1: HOME (Page 4 Bottom)
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
                                                <div class="quick-action-subtitle">View past invoices & receipts</div>
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
                                     CUSTOMER TAB 2: PLACE ORDER (Page 5 Top)
                                     ============================================== -->
                                <div id="customer-tab-place-order" class="portal-tab-content" style='<%= "display:" + GetCustomerTabDisplay("place-order") + ";" %>'>
                                    <!-- Alert Saved Spec Banner -->
                                    <div class="alert-saved-spec-banner">
                                        <div class="saved-spec-header">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="#15803d" stroke="currentColor" stroke-width="1"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                            <span>YOUR SAVED BOX SPECIFICATION</span>
                                        </div>
                                        <div class="saved-spec-tags-inline" id="placeOrderSpecInline">
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
                                     CUSTOMER TAB 3: TRACK ORDER (Page 5 Middle)
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
                                                        <div class="tracking-detail-val"><asp:Label ID="lblTrackMachines" runat="server">Cutter A & Printer Line 1</asp:Label></div>
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
                                     CUSTOMER TAB 4: MY ORDERS (Page 5 Bottom)
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
                            </div>
                        </main>
                    </div>
                </div>

                <!-- ========================================================
                     MODAL 1: NEW ORDER STEP 1 (Page 2 Middle)
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
                     MODAL 2: REPEAT ORDER STEP 2a (Page 2 Bottom)
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
                            <asp:DropDownList ID="repeatOrderCompanySelect" runat="server" CssClass="form-control-input" onchange="window.BoxApp && window.BoxApp.handleRepeatCompanyChange ? window.BoxApp.handleRepeatCompanyChange(this.value) : null" />
                        </div>

                        <div id="repeatOrderSpecPreview" style="display:none; background:#f0fdfa; border:1px solid #ccfbf1; border-radius:8px; padding:12px; margin-bottom:16px; font-size:12px; color:#0f766e;">
                            <!-- Auto populated spec -->
                        </div>

                        <div class="form-group">
                            <label class="form-label">Quantity (boxes)</label>
                            <asp:TextBox ID="repeatOrderQty" runat="server" TextMode="Number" CssClass="form-control-input" Text="100" min="1" oninput="window.BoxApp && window.BoxApp.updateRepeatOrderPrice ? window.BoxApp.updateRepeatOrderPrice() : null" />
                        </div>

                        <div style="font-size:15px; font-weight:700; color:#0f172a; margin-bottom:14px;" id="repeatOrderTotal">
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
                     MODAL 3: FIRST ORDER - NEW COMPANY STEP 2b (Page 3 Top/Middle)
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

                        <div style="font-size:16px; font-weight:700; color:#0f172a; margin-bottom:12px;" id="firstOrderTotalPreview">
                            <asp:Label ID="firstOrderTotalPreview" runat="server">Total: &#8377;4,900</asp:Label>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Notes (optional)</label>
                            <asp:TextBox ID="firstOrderNotes" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control-input" placeholder="Any special instructions..." />
                        </div>

                        <div class="modal-actions-footer">
                            <button type="button" class="btn-secondary-outline" onclick="window.BoxApp.closeModal('modalFirstOrder')">Cancel</button>
                            <asp:Button ID="btnSubmitFirstOrder" runat="server" Text="Save Spec & Place Order" CssClass="btn-primary-teal" style="width:auto; padding:9px 20px;" OnClick="btnSubmitFirstOrder_Click" />
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
    <script src="Scripts/boxfactory.js" type="text/javascript" charset="utf-8"></script>
</body>
</html>
