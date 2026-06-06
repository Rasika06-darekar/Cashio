<%@ page import="com.budgetbee.model.Income" %>

<%
Income income =
(Income)request.getAttribute("income");
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>Edit Income</title>

<style>

body{
    font-family:Segoe UI;
    background:#f4f7fc;
    padding:40px;
}

.container{
    width:500px;
    margin:auto;
    background:white;
    padding:30px;
    border-radius:15px;
    box-shadow:0 0 10px rgba(0,0,0,0.1);
}

input{
    width:100%;
    padding:12px;
    margin-top:8px;
    margin-bottom:15px;
}

button{
    width:100%;
    padding:12px;
    background:#28a745;
    color:white;
    border:none;
    border-radius:8px;
    cursor:pointer;
}

</style>

</head>

<body>

<div class="container">

<h2>Edit Income</h2>

<form action="updateIncome" method="post">

<input type="hidden"
name="incomeId"
value="<%= income.getIncomeId() %>">

<label>Amount</label>

<input type="number"
name="amount"
value="<%= income.getAmount() %>">

<label>Source</label>

<input type="text"
name="source"
value="<%= income.getSource() %>">

<label>Date</label>

<input type="date"
name="incomeDate"
value="<%= income.getIncomeDate() %>">

<label>Description</label>

<input type="text"
name="description"
value="<%= income.getDescription() %>">

<button type="submit">

Update Income

</button>

</form>

</div>

</body>
</html>