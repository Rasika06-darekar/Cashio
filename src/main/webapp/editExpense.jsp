<%@ page import="com.budgetbee.model.Expense" %>

<%
Expense expense =
(Expense)request.getAttribute("expense");
%>

<!DOCTYPE html>

<html>
<head>

<meta charset="UTF-8">

<title>Edit Expense</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Segoe UI,sans-serif;
}

body{
    background:#f4f7fc;
    display:flex;
    justify-content:center;
    align-items:center;
    min-height:100vh;
}

.container{

    width:500px;
    background:white;

    padding:35px;

    border-radius:20px;

    box-shadow:
    0 10px 30px rgba(0,0,0,0.08);
}

h2{

    text-align:center;

    margin-bottom:25px;

    color:#dc3545;
}

label{

    display:block;

    margin-bottom:8px;

    font-weight:600;

    color:#444;
}

input{

    width:100%;

    padding:12px;

    border:1px solid #ddd;

    border-radius:10px;

    margin-bottom:18px;

    font-size:15px;
}

input:focus{

    outline:none;

    border-color:#dc3545;
}

button{

    width:100%;

    padding:14px;

    border:none;

    border-radius:10px;

    background:#dc3545;

    color:white;

    font-size:16px;

    font-weight:bold;

    cursor:pointer;

    transition:0.3s;
}

button:hover{

    background:#c82333;
}

.back-btn{

    display:block;

    text-align:center;

    margin-top:15px;

    text-decoration:none;

    color:#0B1F3A;

    font-weight:bold;
}

</style>

</head>

<body>

<div class="container">

<h2>Edit Expense</h2>

<form action="updateExpense"
method="post">

<input type="hidden"
name="expenseId"
value="<%= expense.getExpenseId() %>">

<label>Amount</label>

<input
type="number"
step="0.01"
name="amount"
value="<%= expense.getAmount() %>"
required>

<label>Category</label>

<input
type="text"
name="category"
value="<%= expense.getCategory() %>"
required>

<label>Date</label>

<input
type="date"
name="expenseDate"
value="<%= expense.getExpenseDate() %>"
required>

<label>Description</label>

<input
type="text"
name="description"
value="<%= expense.getDescription() %>">

<button type="submit">

Update Expense

</button>

</form>

<a class="back-btn"
href="expenseHistory">
Back to Expense History

</a>

</div>

</body>
</html>
