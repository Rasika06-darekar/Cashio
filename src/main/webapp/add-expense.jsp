<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Expense - Cashio</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Segoe UI',sans-serif;
}

body{
    background:#f4f7fc;
    display:flex;
    min-height:100vh;
}

/* ── Sidebar ── */
.sidebar{
    width:240px;
    min-height:100vh;
    background:#0B1F3A;
    padding:28px 16px;
    position:fixed;
    left:0;
    top:0;
    display:flex;
    flex-direction:column;
    gap:4px;
}

.sidebar-logo{
    display:flex;
    align-items:center;
    gap:10px;
    padding:0 8px;
    margin-bottom:32px;
}

.sidebar-logo span{
    font-size:22px;
    font-weight:800;
    color:white;
    letter-spacing:-.5px;
}

.sidebar-logo span b{
    color:#4ade80;
}

.nav-item{
    display:flex;
    align-items:center;
    gap:12px;
    padding:12px 14px;
    border-radius:12px;
    color:#9fb3c8;
    text-decoration:none;
    font-size:14px;
    font-weight:500;
    transition:all 0.2s;
}

.nav-item:hover{
    background:#1F3B5C;
    color:white;
}

.nav-item.active{
    background:#1F3B5C;
    color:white;
    font-weight:600;
}

.nav-icon{
    width:36px;
    height:36px;
    border-radius:10px;
    background:#ffffff10;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:17px;
}

.nav-item.active .nav-icon{
    background:#ffffff20;
}

.main{
    margin-left:240px;
    flex:1;
    padding:35px 40px;
}

.page-header {
    margin-bottom:30px;
    padding-bottom:15px;
    border-bottom:2px solid #e2e8f0;
}

.page-header h1 {
    color:#0B1F3A;
    font-size:26px;
    font-weight:700;
}

.page-header p {
    color:#64748b;
    margin-top:5px;
    font-size:14px;
}

.card{
    background:white;
    max-width:700px;
    padding:30px;
    border-radius:16px;
    box-shadow:0 2px 12px rgba(0,0,0,0.07);
    border:1px solid #e2e8f0;
}

.form-group{
    margin-bottom:20px;
}

label{
    display:block;
    margin-bottom:8px;
    font-weight:600;
    color:#0B1F3A;
    font-size:13px;
}

input,
textarea,
select{
    width:100%;
    padding:12px 14px;
    border:1px solid #e2e8f0;
    border-radius:10px;
    font-size:14px;
    font-family:'Segoe UI',sans-serif;
    outline:none;
    transition:border-color 0.2s;
}

input:focus,
textarea:focus,
select:focus{
    border-color:#0B1F3A;
}

textarea{
    resize:none;
    height:120px;
}

button{
    width:100%;
    padding:12px 18px;
    background:#dc2626;
    color:white;
    border:none;
    border-radius:10px;
    font-size:15px;
    font-weight:600;
    cursor:pointer;
    transition:background 0.2s;
}

button:hover{
    background:#b91c1c;
}

.toast{
    position:fixed;
    top:20px;
    right:20px;
    padding:15px 25px;
    border-radius:10px;
    color:white;
    font-weight:bold;
    z-index:9999;
    animation:fadeOut 4s forwards;
}

.success{
    background:#16a34a;
}

.error{
    background:#dc2626;
}

@keyframes fadeOut{
    0%{
        opacity:1;
    }
    80%{
        opacity:1;
    }
    100%{
        opacity:0;
        visibility:hidden;
    }
}

</style>

</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <div class="sidebar-logo">
        <span>Cash<b>io</b></span>
    </div>
    <a href="dashboard" class="nav-item">
        <div class="nav-icon">🏠</div>
        Dashboard
    </a>
    <a href="income.jsp" class="nav-item">
        <div class="nav-icon">💵</div>
        Add Income
    </a>
    <a href="add-expense.jsp" class="nav-item active">
        <div class="nav-icon">💸</div>
        Add Expense
    </a>
    <a href="incomeHistory" class="nav-item">
        <div class="nav-icon">📜</div>
        Income History
    </a>
    <a href="expenseHistory" class="nav-item">
        <div class="nav-icon">🧾</div>
        Expense History
    </a>
    <a href="reports" class="nav-item">
        <div class="nav-icon">📊</div>
        Reports
    </a>
    <a href="settings.jsp" class="nav-item">
        <div class="nav-icon">⚙️</div>
        Settings
    </a>
    <a href="logout" class="nav-item" style="margin-top:auto;">
        <div class="nav-icon">🚪</div>
        Logout
    </a>
</div>

<!-- Main Content -->
<div class="main">

    <div class="page-header">
        <h1>Add Expense</h1>
        <p>Record a new expense transaction</p>
    </div>

    <div class="card">

        <form action="addExpense" method="post">

            <div class="form-group">
                <label>Amount (Rs.)</label>
                <input type="number"
                       step="0.01"
                       name="amount"
                       placeholder="Enter amount"
                       required>
            </div>

            <div class="form-group">
                <label>Category</label>
                <input type="text"
                       name="category"
                       placeholder="e.g., Food, Transport, Shopping"
                       required>
            </div>

            <div class="form-group">
                <label>Expense Date</label>
                <input type="date"
                       name="expenseDate"
                       required>
            </div>

            <div class="form-group">
                <label>Description</label>
                <textarea name="description"
                          placeholder="Add any notes about this expense (optional)"></textarea>
            </div>

            <button type="submit">
                💾 Save Expense
            </button>

        </form>

    </div>

</div>

<%
String success = request.getParameter("success");
String error = request.getParameter("error");
%>

<% if(success != null){ %>
<div class="toast success">
    ✅ Expense Added Successfully
</div>
<% } %>

<% if(error != null){ %>
<div class="toast error">
    ❌ Failed To Save Expense
</div>
<% } %>

</body>
</html>
