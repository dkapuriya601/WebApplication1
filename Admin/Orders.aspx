<%@ Page Title="Orders - BoxFactory Admin" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Orders.aspx.cs" Inherits="WebApplication1.AdminPages.Orders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageHeaderTitle" runat="server">
    Orders
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="table-controls-bar">
        <div class="search-input-box">
            <svg class="search-icon-inside" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
            <asp:TextBox ID="txtOrderSearch" runat="server" placeholder="Search by order ID or company..." AutoPostBack="true" OnTextChanged="txtOrderSearch_TextChanged" />
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
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ModalContent" runat="server">
    <!-- MODAL 1: NEW ORDER STEP 1 -->
    <div id="modalNewOrderStep1" class="modal-overlay-backdrop">
        <div class="modal-container-card">
            <button type="button" class="modal-close-cross" onclick="window.BoxApp.closeModal('modalNewOrderStep1')">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
            </button>
            <h3 class="modal-heading">New Order</h3>
            <p class="modal-subheading">Choose the order type to continue</p>

            <div class="new-order-type-cards">
                <div class="order-type-card-choice" onclick="window.BoxApp.selectOrderType('repeat')">
                    <div class="choice-icon-box">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 4 23 10 17 10"></polyline><polyline points="1 20 1 14 7 14"></polyline><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path></svg>
                    </div>
                    <div>
                        <div class="choice-title">Repeat Order</div>
                        <div class="choice-desc">Company already on file — fast order based on saved specs</div>
                    </div>
                </div>

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

    <!-- MODAL 2: REPEAT ORDER -->
    <div id="modalRepeatOrder" class="modal-overlay-backdrop">
        <div class="modal-container-card">
            <button type="button" class="modal-close-cross" onclick="window.BoxApp.closeModal('modalRepeatOrder')">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
            </button>
            <h3 class="modal-heading">New Order</h3>
            <p class="modal-subheading">Choose the order type to continue</p>

            <div class="form-group">
                <label class="form-label">Select Company</label>
                <asp:DropDownList ID="repeatOrderCompanySelect" runat="server" CssClass="form-control-input" AutoPostBack="true" OnSelectedIndexChanged="repeatOrderCompanySelect_SelectedIndexChanged" />
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

    <!-- MODAL 3: FIRST ORDER - NEW COMPANY -->
    <div id="modalFirstOrder" class="modal-overlay-backdrop">
        <div class="modal-container-card" style="max-width: 620px;">
            <button type="button" class="modal-close-cross" onclick="window.BoxApp.closeModal('modalFirstOrder')">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
            </button>
            <h3 class="modal-heading">New Order</h3>
            <p class="modal-subheading">This company's box specification will be saved permanently for future repeat orders.</p>

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

    <!-- MODAL 4: INVOICE / RECEIPT -->
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
