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

                            <!-- Validation Summary -->
                            <asp:ValidationSummary 
                                ID="vsAdminLogin" 
                                runat="server" 
                                ValidationGroup="AdminLoginGroup" 
                                CssClass="validation-summary-box" 
                                HeaderText="Please correct the following errors:" 
                                DisplayMode="BulletList" 
                                ShowSummary="true" 
                                ShowMessageBox="false" />

                            <!-- Error message banner -->
                            <asp:Label ID="lblError" runat="server" CssClass="form-error-msg" Visible="false" />

                            <div class="form-group">
                                <label class="form-label">Email</label>
                                <asp:TextBox ID="adminLoginEmail" runat="server" TextMode="Email" CssClass="form-control-input" placeholder="admin@boxfactory.in" />
                                <asp:RequiredFieldValidator 
                                    ID="rfvAdminEmail" 
                                    runat="server" 
                                    ControlToValidate="adminLoginEmail" 
                                    ErrorMessage="Email address is required." 
                                    Display="Dynamic" 
                                    CssClass="validation-error-text" 
                                    ValidationGroup="AdminLoginGroup" 
                                    SetFocusOnError="true" />
                                <asp:RegularExpressionValidator 
                                    ID="revAdminEmail" 
                                    runat="server" 
                                    ControlToValidate="adminLoginEmail" 
                                    ErrorMessage="Please enter a valid email address." 
                                    ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" 
                                    Display="Dynamic" 
                                    CssClass="validation-error-text" 
                                    ValidationGroup="AdminLoginGroup" 
                                    SetFocusOnError="true" />
                            </div>

                            <div class="form-group">
                                <label class="form-label">Password</label>
                                <div class="password-input-wrapper">
                                    <asp:TextBox ID="adminLoginPassword" runat="server" TextMode="Password" CssClass="form-control-input" placeholder="••••••••" />
                                    <button type="button" class="password-toggle-btn" onclick="window.BoxApp.togglePassword('adminLoginPassword')">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                    </button>
                                </div>
                                <asp:RequiredFieldValidator 
                                    ID="rfvAdminPassword" 
                                    runat="server" 
                                    ControlToValidate="adminLoginPassword" 
                                    ErrorMessage="Password is required." 
                                    Display="Dynamic" 
                                    CssClass="validation-error-text" 
                                    ValidationGroup="AdminLoginGroup" 
                                    SetFocusOnError="true" />
                                <asp:RegularExpressionValidator 
                                    ID="revAdminPassword" 
                                    runat="server" 
                                    ControlToValidate="adminLoginPassword" 
                                    ErrorMessage="Password must be at least 6 characters." 
                                    ValidationExpression="^.{6,}$" 
                                    Display="Dynamic" 
                                    CssClass="validation-error-text" 
                                    ValidationGroup="AdminLoginGroup" 
                                    SetFocusOnError="true" />
                            </div>

                            <asp:Button 
                                ID="btnAdminLogin" 
                                runat="server" 
                                Text="Sign In as Admin" 
                                CssClass="btn-primary-teal" 
                                OnClick="btnAdminLogin_Click" 
                                ValidationGroup="AdminLoginGroup" 
                                CausesValidation="true" />

                            <a href="~/" runat="server" class="btn-back-link">← Back</a>

                            <!-- Demo Credentials Helper -->
                            <div class="demo-tips-card" style="margin-top: 18px;">
                                <div class="demo-tips-title">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                                    <span>Demo Admin Credentials</span>
                                </div>
                                <div class="demo-row">
                                    <span><code>admin@boxfactory.in | admin123</code></span>
                                    <button type="button" class="demo-quick-btn" onclick="window.BoxApp.quickFillAdmin()">Autofill</button>
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
    <script src="<%= ResolveUrl("~/Scripts/boxfactory.js") %>" type="text/javascript" charset="utf-8"></script>
</body>
</html>
