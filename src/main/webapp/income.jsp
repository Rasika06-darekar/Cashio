<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>


<html>
<head>
<meta charset="UTF-8">
<title>Add Income - Cashio</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Segoe UI',sans-serif;
}

/* Sidebar */

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
    letter-spacing:-0.5px;
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
    transition:0.2s;
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

.logout-btn{
    margin-top:auto;
}

.main{
    margin-left:270px;
    padding:40px;
}
.form-card{
    background:white;
    max-width:700px;
    padding:30px;
    border-radius:20px;
    box-shadow:0 5px 15px rgba(0,0,0,0.1);
}

.form-card h2{
    color:#0B1F3A;
    margin-bottom:25px;
}

.form-group{
    margin-bottom:20px;
}

.form-group label{
    display:block;
    margin-bottom:8px;
    font-weight:600;
}

.form-group input,
.form-group textarea{
    width:100%;
    padding:12px;
    border:1px solid #ccc;
    border-radius:10px;
    font-size:15px;
}

.form-group textarea{
    height:120px;
    resize:none;
}

.form-group input:focus,
.form-group textarea:focus{
    outline:none;
    border-color:#0B1F3A;
}

button{
    width:100%;
    padding:14px;
    border:none;
    border-radius:10px;
    background:#0B1F3A;
    color:white;
    font-size:16px;
    cursor:pointer;
}

button:hover{
    background:#163D6B;
}

</style>

</head>
<body>


<!-- Sidebar -->
<div class="sidebar">
    <div class="sidebar-logo">
        <span>Cash<b>io</b></span>
    </div>
    <a href="dashboard" class="nav-item active">
    <div class="nav-icon">🏠</div>
    Dashboard
</a>

<a href="income.jsp" class="nav-item">
    <div class="nav-icon">💵</div>
    Add Income
</a>

<a href="add-expense.jsp" class="nav-item">
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

<a href="logout" class="nav-item logout-btn">
    <div class="nav-icon">🚪</div>
    Logout
</a>
</div>

</div>

<div class="main">

<div class="form-card">

    <h2>Add Income</h2>

    <form action="addIncome" method="post">

        <div class="form-group">
            <label>Amount</label>
            <input type="number"
                   step="0.01"
                   name="amount"
                   required>
        </div>

        <div class="form-group">
            <label>Source</label>
            <input type="text"
                   name="source"
                   required>
        </div>

        <div class="form-group">
            <label>Income Date</label>
            <input type="date"
                   name="incomeDate"
                   required>
        </div>

        <div class="form-group">
            <label>Description</label>
            <textarea name="description"></textarea>
        </div>

        <button type="submit">
            Save Income
        </button>

    </form>

</div>


</div>

</body>
</html>
