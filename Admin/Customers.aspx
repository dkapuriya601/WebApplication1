<%@ Page Title="Customers - BoxFactory Admin" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Customers.aspx.cs" Inherits="WebApplication1.AdminPages.Customers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageHeaderTitle" runat="server">
    Customers
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
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
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ModalContent" runat="server">
    <!-- MODAL: CUSTOMER PROFILE -->
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
</asp:Content>
