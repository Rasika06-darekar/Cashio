<%@ page import="com.budgetbee.dao.UserDAO" %>
<%@ page import="com.budgetbee.model.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
if (session.getAttribute("userEmail") == null) {
    response.sendRedirect("login.jsp");
    return;
}
String email = (String) session.getAttribute("userEmail");
UserDAO dao = new UserDAO();
User user = dao.getUserByEmail(email);
if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Cashio - Settings</title>
<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:Segoe UI,sans-serif; }

body { background:#f4f7fc; display:flex; min-height:100vh; }
/* ── Sidebar ── */
.sidebar{
    width:240px; min-height:100vh;
    background:#0B1F3A;
    padding:28px 16px;
    position:fixed; left:0; top:0;
    display:flex; flex-direction:column;
    gap:4px;
}
.sidebar-logo{
    display:flex; align-items:center;
    gap:10px; padding:0 8px;
    margin-bottom:32px;
}
.sidebar-logo span{
    font-size:22px; font-weight:800;
    color:white; letter-spacing:-.5px;
}
.sidebar-logo span b{ color:#4ade80; }
.nav-item{
    display:flex; align-items:center;
    gap:12px; padding:12px 14px;
    border-radius:12px; color:#9fb3c8;
    text-decoration:none; font-size:14px;
    font-weight:500; transition:all 0.2s;
}
.nav-item:hover{
    background:#1F3B5C; color:white;
}
.nav-item.active{
    background:#1F3B5C; color:white;
    font-weight:600;
}
.nav-item .nav-icon{
    width:36px; height:36px;
    border-radius:10px;
    display:flex; align-items:center;
    justify-content:center; font-size:17px;
    background:#ffffff10;
}
.nav-item.active .nav-icon{ background:#ffffff20; }

.main { margin-left:240px; padding:35px 40px; flex:1; }

.page-header {
    margin-bottom:30px;
    padding-bottom:15px;
    border-bottom:2px solid #e2e8f0;
}
.page-header h1 {
    color:#0B1F3A; font-size:26px; font-weight:700;
}
.page-header p { color:#64748b; margin-top:5px; font-size:14px; }

/* Profile Card */
.profile-card {
    background:white;
    border-radius:16px;
    box-shadow:0 2px 12px rgba(0,0,0,0.07);
    margin-bottom:30px;
    overflow:hidden;
}
.profile-card-header {
    background:linear-gradient(135deg,#0B1F3A,#1F3B5C);
    padding:25px 30px;
    display:flex;
    align-items:center;
    gap:20px;
}
.profile-avatar {
    width:70px; height:70px;
    border-radius:50%;
    background:#ffffff30;
    border:3px solid #ffffff50;
    display:flex; align-items:center;
    justify-content:center;
    font-size:28px; color:white;
    font-weight:bold;
}
.profile-card-header h2 {
    color:white; font-size:20px; margin-bottom:4px;
}
.profile-card-header p { color:#9fb3c8; font-size:13px; }

.profile-card-body { padding:0 30px; }
.info-row {
    display:flex; justify-content:space-between;
    align-items:center;
    padding:16px 0;
    border-bottom:1px solid #f1f5f9;
}
.info-row:last-child { border-bottom:none; }
.info-label {
    color:#64748b; font-size:13px;
    display:flex; align-items:center; gap:8px;
}
.info-label .dot {
    width:8px; height:8px; border-radius:50%;
    background:#0B1F3A; display:inline-block;
}
.info-value { color:#0B1F3A; font-weight:600; font-size:14px; }

/* Settings Grid */
.section-title {
    color:#0B1F3A; font-size:17px;
    font-weight:700; margin-bottom:16px;
    display:flex; align-items:center; gap:8px;
}
.section-title::after {
    content:''; flex:1; height:2px;
    background:#e2e8f0; border-radius:2px;
}

.settings-grid {
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(260px,1fr));
    gap:16px;
    margin-bottom:30px;
}

.setting-card {
    background:white;
    border-radius:14px;
    padding:22px;
    box-shadow:0 2px 12px rgba(0,0,0,0.06);
    border:1px solid #e2e8f0;
    transition:all 0.25s;
    display:flex;
    flex-direction:column;
    gap:8px;
}
.setting-card:hover {
    transform:translateY(-3px);
    box-shadow:0 8px 24px rgba(11,31,58,0.12);
    border-color:#0B1F3A30;
}
.setting-icon {
    width:42px; height:42px;
    border-radius:10px;
    display:flex; align-items:center;
    justify-content:center;
    font-size:20px;
    margin-bottom:4px;
}
.setting-card h3 {
    color:#0B1F3A; font-size:15px; font-weight:600;
}
.setting-card p {
    color:#64748b; font-size:12px; line-height:1.5;
    flex:1;
}
.btn {
    display:inline-block; text-decoration:none;
    background:#0B1F3A; color:white;
    padding:9px 18px; border-radius:8px;
    font-size:13px; font-weight:600;
    text-align:center; transition:background 0.2s;
    margin-top:6px; width:fit-content;
}
.btn:hover { background:#1F3B5C; }

/* Dark Mode Toggle */
.toggle-row {
    display:flex; align-items:center;
    justify-content:space-between; margin-top:6px;
}
.switch {
    position:relative; display:inline-block;
    width:52px; height:28px;
}
.switch input { opacity:0; width:0; height:0; }
.slider {
    position:absolute; cursor:pointer;
    top:0; left:0; right:0; bottom:0;
    background:#cbd5e1; transition:.3s;
    border-radius:28px;
}
.slider:before {
    position:absolute; content:"";
    height:20px; width:20px;
    left:4px; bottom:4px;
    background:white; transition:.3s;
    border-radius:50%;
}
input:checked + .slider { background:#0B1F3A; }
input:checked + .slider:before { transform:translateX(24px); }

/* Alert */
.alert {
    padding:12px 18px; border-radius:10px;
    margin-bottom:20px; font-size:14px;
    font-weight:500;
}
.alert-success {
    background:#d4edda; color:#155724;
    border:1px solid #c3e6cb;
}
</style>
</head>
<body>

<%
if(request.getParameter("profileUpdated") != null ||
   request.getParameter("emailUpdated") != null ||
   request.getParameter("phoneUpdated") != null ||
   request.getParameter("passwordUpdated") != null){
%>
<script>
window.onload = function(){
    const params = new URLSearchParams(window.location.search);
    if(params.has("profileUpdated"))
        showAlert("Profile Updated Successfully!");
    else if(params.has("emailUpdated"))
        showAlert("Email Updated Successfully!");
    else if(params.has("phoneUpdated"))
        showAlert("Phone Number Updated Successfully!");
    else if(params.has("passwordUpdated"))
        showAlert("Password Changed Successfully!");
}
function showAlert(msg){
    const div = document.createElement("div");
    div.className = "alert alert-success";
    div.innerHTML = "✅ " + msg;
    document.querySelector(".main").prepend(div);
    setTimeout(()=> div.remove(), 3000);
}
</script>
<% } %>


<!-- Sidebar -->
<div class="sidebar">
    <div class="sidebar-logo">
        <span>Cash<b>io</b></span>
    </div>
    <a href="dashboard" class="nav-item">
        <div class="nav-icon">🏠</div> Dashboard
    </a>
    <a href="income.jsp" class="nav-item">
        <div class="nav-icon">💵</div> Add Income
    </a>
    <a href="add-expense.jsp" class="nav-item">
        <div class="nav-icon">💸</div> Add Expense
    </a>
    <a href="incomeHistory" class="nav-item">
        <div class="nav-icon">📜</div> Income History
    </a>
    <a href="expenseHistory" class="nav-item">
        <div class="nav-icon">🧾</div> Expense History
    </a>
    <a href="reports" class="nav-item">
        <div class="nav-icon">📊</div> Reports
    </a>
    <a href="settings.jsp" class="nav-item active">
        <div class="nav-icon">⚙️</div> Settings
    </a>
    <a href="logout" class="nav-item"
        style="margin-top:auto;">
        <div class="nav-icon">🚪</div> Logout
    </a>
</div>


<!-- Main -->
<div class="main">

    <div class="page-header">
        <h1>Profile Settings</h1>
        <p>Manage your account details and preferences</p>
    </div>

    <!-- Profile Card -->
    <div class="profile-card">
        <div class="profile-card-header">
            <div class="profile-avatar">
                <%= user.getFullName() != null ?
                    String.valueOf(user.getFullName().charAt(0)).toUpperCase()
                    : "U" %>
            </div>
            <div>
                <h2><%= user.getFullName() %></h2>
                <p><%= user.getEmail() %></p>
            </div>
        </div>
        <div class="profile-card-body">
            <div class="info-row">
                <span class="info-label">
                    <span class="dot"></span> Full Name
                </span>
                <span class="info-value">
                    <%= user.getFullName() %>
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">
                    <span class="dot"></span> Username
                </span>
                <span class="info-value">
                    <%= user.getUsername() %>
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">
                    <span class="dot"></span> Email Address
                </span>
                <span class="info-value">
                    <%= user.getEmail() %>
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">
                    <span class="dot"></span> Phone Number
                </span>
                <span class="info-value">
                    <%= user.getPhone() != null &&
                        !user.getPhone().isEmpty() ?
                        user.getPhone() : "Not set" %>
                </span>
            </div>
        </div>
    </div>

    <!-- Settings Cards -->
    <div class="section-title">Account Settings</div>

    <div class="settings-grid">

        <div class="setting-card">
            <div class="setting-icon"
                style="background:#e8f0fe;">✏</div>
            <h3>Edit Profile</h3>
            <p>Update your full name and personal information.</p>
            <a href="editProfile.jsp" class="btn">Open</a>
        </div>

        <div class="setting-card">
            <div class="setting-icon"
                style="background:#e8f5e9;">📧</div>
            <h3>Update Email</h3>
            <p>Change your registered email address.</p>
            <a href="updateEmail.jsp" class="btn">Open</a>
        </div>

        <div class="setting-card">
            <div class="setting-icon"
                style="background:#fff3e0;">📱</div>
            <h3>Update Phone</h3>
            <p>Update your contact phone number.</p>
            <a href="updatePhone.jsp" class="btn">Open</a>
        </div>

        <div class="setting-card">
            <div class="setting-icon"
                style="background:#fce4ec;">🔒</div>
            <h3>Change Password</h3>
            <p>Keep your account secure with a strong password.</p>
            <a href="changePassword.jsp" class="btn">Open</a>
        </div>

        <div class="setting-card">
            <div class="setting-icon"
                style="background:#e8eaf6;">🖼️</div>
            <h3>Profile Picture</h3>
            <p>Upload or update your profile photo.</p>
            <a href="uploads.jsp" class="btn">Open</a>
        </div>

        <div class="setting-card">
            <div class="setting-icon"
                style="background:#e3f2fd;">🌙</div>
            <h3>Dark Mode</h3>
            <p>Switch between light and dark theme.</p>
            <div class="toggle-row">
                <span style="font-size:13px;color:#64748b;">
                    Enable dark theme
                </span>
                <label class="switch">
                    <input type="checkbox" id="darkMode">
                    <span class="slider"></span>
                </label>
            </div>
        </div>

    </div>
</div>

<script>
const toggle = document.getElementById("darkMode");
toggle.addEventListener("change", function(){
    if(this.checked){
        document.body.style.background = "#0f172a";
        document.querySelectorAll(
            ".setting-card,.profile-card,.main")
        .forEach(el => {
            el.style.background = "#1e293b";
            el.style.color = "white";
        });
        document.querySelectorAll(
            ".setting-card h3,.info-value,.page-header h1")
        .forEach(el => el.style.color = "white");
        document.querySelectorAll(
            ".setting-card p,.info-label,.page-header p")
        .forEach(el => el.style.color = "#94a3b8");
    } else {
        location.reload();
    }
});
</script>
</body>
</html>
