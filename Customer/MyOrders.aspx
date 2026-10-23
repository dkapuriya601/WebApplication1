<%@ Page Title="My Orders - BoxFactory" Language="C#" MasterPageFile="~/Customer/Customer.Master" AutoEventWireup="true" CodeBehind="MyOrders.aspx.cs" Inherits="WebApplication1.CustomerPages.MyOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageHeaderTitle" runat="server">
    My Orders
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="panel-header-row" style="margin-bottom: 16px;">
        <h2 class="panel-title">All Orders</h2>
        <a href="<%= ResolveUrl("~/Customer/PlaceOrder.aspx") %>" class="btn-teal-action" style="background:var(--purple-600); text-decoration:none;">+ New Order</a>
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
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ModalContent" runat="server">
    <!-- MODAL: INVOICE / RECEIPT -->
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
