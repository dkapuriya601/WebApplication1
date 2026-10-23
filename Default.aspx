<%@ Page Title="BoxFactory - Sign In" Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebApplication1._Default" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>BoxFactory - Sign In</title>
    <link href="Content/boxfactory.css" rel="stylesheet" type="text/css" />
    <link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
</head>
<body>
    <form id="form1" runat="server" ClientIDMode="Static">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />

        <asp:UpdatePanel ID="upMain" runat="server" UpdateMode="Always">
            <ContentTemplate>

                <!-- Role Selection Screen -->
                <main id="screen-role-select" class="screen-view active-screen">
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
                                <asp:LinkButton runat="server" CssClass="role-select-card" OnClick="btnGoAdminLogin_Click" style="text-decoration:none; color:inherit; display:flex;">
                                    <div class="role-icon-box">
                                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 20V10"></path><path d="M12 20V4"></path><path d="M6 20v-6"></path></svg>
                                    </div>
                                    <div class="role-info">
                                        <div class="role-name">Admin</div>
                                        <div class="role-desc">Manage orders, inventory &amp; customers</div>
                                    </div>
                                    <div class="role-arrow">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                    </div>
                                </asp:LinkButton>

                                <!-- Customer Option Card -->
                                <asp:LinkButton runat="server" CssClass="role-select-card role-customer" OnClick="btnGoCustomerLogin_Click" style="text-decoration:none; color:inherit; display:flex;">
                                    <div class="role-icon-box">
                                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                                    </div>
                                    <div class="role-info">
                                        <div class="role-name">Customer</div>
                                        <div class="role-desc">Place orders, track deliveries &amp; history</div>
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

                <!-- Toast Notification Alert -->
                <asp:Label ID="toastNotification" runat="server" CssClass="toast-notice" />

            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
    <script src="Scripts/boxfactory.js" type="text/javascript" charset="utf-8"></script>
</body>
</html>
