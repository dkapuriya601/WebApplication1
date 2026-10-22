<%@ Page Title="BoxFactory - Admin Login" Language="C#" AutoEventWireup="true" CodeBehind="AdminLogin.aspx.cs" Inherits="WebApplication1.AdminPages.AdminLogin" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>BoxFactory - Admin Login</title>
    <link href="<%= ResolveUrl("~/Content/boxfactory.css") %>" rel="stylesheet" type="text/css" />
    <link rel="shortcut icon" href="<%= ResolveUrl("~/favicon.ico") %>" type="image/x-icon" />
</head>
<body>
    <form id="form1" runat="server" ClientIDMode="Static">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />

        <asp:UpdatePanel ID="upMain" runat="server" UpdateMode="Always">
            <ContentTemplate>

                <main id="screen-admin-login" class="screen-view active-screen">
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

                            <!-- Error message -->
                            <asp:Label ID="lblError" runat="server" CssClass="form-error-msg" Visible="false" />

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
                            <a href="~/" runat="server" class="btn-back-link">← Back</a>

                            <div class="auth-footer-tag">BoxFactory Management System</div>
                        </div>
                    </div>
                </main>

                <!-- Toast Notification Alert -->
                <asp:Label ID="toastNotification" runat="server" CssClass="toast-notice" />

            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
    <script src="<%= ResolveUrl("~/Scripts/boxfactory.js") %>" type="text/javascript" charset="utf-8"></script>
</body>
</html>
