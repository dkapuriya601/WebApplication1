<%@ Page Title="Inventory - BoxFactory Admin" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Inventory.aspx.cs" Inherits="WebApplication1.AdminPages.Inventory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageHeaderTitle" runat="server">
    Inventory
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
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
</asp:Content>
