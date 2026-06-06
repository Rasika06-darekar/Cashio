<%@ page import="java.util.List"%>
<%@ page import="com.budgetbee.model.Expense"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">
<title>Expense History - Cashio</title>

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
    display:flex;
    align-items:center;
    justify-content:center;
    background:#ffffff10;
    font-size:17px;
}

.nav-item.active .nav-icon{
    background:#ffffff20;
}

/* ── Main ── */

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
    padding:25px;
    border-radius:16px;
    box-shadow:0 2px 12px rgba(0,0,0,0.07);
    border:1px solid #e2e8f0;
}

.search-box{
    display:flex;
    gap:12px;
    flex-wrap:wrap;
    margin-bottom:25px;
    padding:15px;
    background:#f8fafc;
    border-radius:12px;
    border:1px solid #e2e8f0;
}

.search-box input{
    padding:10px 14px;
    border:1px solid #e2e8f0;
    border-radius:8px;
    font-size:13px;
    outline:none;
    background:white;
    flex:1;
    min-width:150px;
}

.search-box input:focus {
    border-color:#0B1F3A;
}

.search-btn{
    background:#0B1F3A;
    color:white;
    border:none;
    padding:10px 18px;
    border-radius:8px;
    cursor:pointer;
    font-size:13px;
    font-weight:600;
    transition:background 0.2s;
}

.search-btn:hover {
    background:#1F3B5C;
}

.clear-btn{
    background:#f1f5f9;
    color:#334155;
    padding:10px 18px;
    border-radius:8px;
    text-decoration:none;
    font-size:13px;
    font-weight:600;
    border:1px solid #e2e8f0;
    transition:background 0.2s;
}

.clear-btn:hover {
    background:#e2e8f0;
}

table{
    width:100%;
    border-collapse:collapse;
}

th{
    background:transparent;
    color:#94a3b8;
    padding:12px;
    text-align:left;
    border-bottom:1px solid #f1f5f9;
    font-size:12px;
    font-weight:600;
    text-transform:uppercase;
    letter-spacing:0.4px;
}

td{
    padding:14px 12px;
    border-bottom:1px solid #f8fafc;
    font-size:13px;
    color:#334155;
}

tr:last-child td {
    border-bottom:none;
}

tr:hover{
    background:#f8fafc;
}

.amount {
    color:#dc2626;
    font-weight:600;
}

.category-badge {
    display:inline-block;
    background:#fee2e2;
    color:#991b1b;
    padding:4px 10px;
    border-radius:20px;
    font-size:12px;
    font-weight:600;
}

.action-btns {
    display:flex;
    gap:8px;
}

.edit-btn{
    background:#2563eb;
    color:white;
    padding:7px 14px;
    border-radius:6px;
    text-decoration:none;
    font-size:12px;
    font-weight:600;
    transition:background 0.2s;
    display:inline-block;
}

.delete-btn{
    background:#dc2626;
    color:white;
    padding:7px 14px;
    border-radius:6px;
    text-decoration:none;
    font-size:12px;
    font-weight:600;
    transition:background 0.2s;
    display:inline-block;
}

.edit-btn:hover{
    background:#1d4ed8;
}

.delete-btn:hover{
    background:#b91c1c;
}

.no-data {
    text-align:center;
    color:#94a3b8;
    padding:40px 20px;
    font-size:14px;
}

</style>

</head>
<body>

<!-- ── Sidebar ── -->
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

    <a href="add-expense.jsp" class="nav-item">
        <div class="nav-icon">💸</div>
        Add Expense
    </a>

    <a href="incomeHistory" class="nav-item">
        <div class="nav-icon">📜</div>
        Income History
    </a>

    <a href="expenseHistory" class="nav-item active">
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

<!-- ── Main ── -->
<div class="main">

    <div class="page-header">
        <h1>Expense History</h1>
        <p>View and manage all your expense records</p>
    </div>

    <div class="card">

        <form method="get" action="expenseHistory">

            <div class="search-box">
                <input type="text"
                       name="category"
                       placeholder="Search by category"
                       value="<%= request.getParameter("category") == null ? "" : request.getParameter("category") %>">

                <input type="date"
                       name="expenseDate"
                       value="<%= request.getParameter("expenseDate") == null ? "" : request.getParameter("expenseDate") %>">

                <input type="number"
                       name="amount"
                       placeholder="Amount"
                       value="<%= request.getParameter("amount") == null ? "" : request.getParameter("amount") %>">

                <button type="submit" class="search-btn">
                    🔍 Search
                </button>

                <a href="expenseHistory" class="clear-btn">
                    Clear Filters
                </a>
            </div>

        </form>

        <table>

            <tr>
                <th>ID</th>
                <th>Amount</th>
                <th>Category</th>
                <th>Date</th>
                <th>Description</th>
                <th>Actions</th>
            </tr>

            <%
            List<Expense> expenseList =
            (List<Expense>) request.getAttribute("expenseList");

            if(expenseList != null && expenseList.size() > 0){

                for(Expense expense : expenseList){
            %>

            <tr>
                <td><%= expense.getExpenseId() %></td>
                <td class="amount">
                    Rs. <%= String.format("%.2f", expense.getAmount()) %>
                </td>
                <td>
                    <span class="category-badge">
                        <%= expense.getCategory() %>
                    </span>
                </td>
                <td><%= expense.getExpenseDate() %></td>
                <td>
                    <%= expense.getDescription() != null && !expense.getDescription().isEmpty() ? 
                        expense.getDescription() : "—" %>
                </td>

                <td>
                    <div class="action-btns">
                        <a class="edit-btn"
                           href="editExpense?id=<%= expense.getExpenseId() %>">
                            ✏️ Edit
                        </a>

                        <a class="delete-btn"
                           href="deleteExpense?id=<%= expense.getExpenseId() %>"
                           onclick="return confirm('Are you sure you want to delete this expense?')">
                            🗑️ Delete
                        </a>
                    </div>
                </td>
            </tr>

            <%
                }
            } else {
            %>

            <tr>
                <td colspan="6" class="no-data">
                    📭 No expense records found
                </td>
            </tr>

            <%
            }
            %>

        </table>

    </div>

</div>

</body>
</html>
