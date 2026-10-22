<%@ Page Title="Admin Dashboard - BoxFactory" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="WebApplication1.AdminPages.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageHeaderTitle" runat="server">
    Dashboard
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
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
                <a href="<%= ResolveUrl("~/Admin/Orders.aspx") %>" class="btn-table-action">View All</a>
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
</asp:Content>
