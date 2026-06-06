<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Set Budget</title>

<style>

body{
    font-family:Segoe UI;
    background:#f4f7fc;
    display:flex;
    justify-content:center;
    align-items:center;
    height:100vh;
}

.card{
    background:white;
    padding:30px;
    border-radius:20px;
    width:400px;
    box-shadow:0 4px 15px rgba(0,0,0,0.1);
}

input{
    width:100%;
    padding:12px;
    margin-top:15px;
    margin-bottom:20px;
}

button{
    width:100%;
    padding:12px;
    background:#007bff;
    color:white;
    border:none;
    border-radius:10px;
    cursor:pointer;
}

</style>

</head>
<body>

<div class="card">

<h2>Set Monthly Budget</h2>

<form action="setBudget" method="post">

<input
type="number"
name="budget"
placeholder="Enter Monthly Budget"
required>

<button type="submit">
Save Budget
</button>

</form>

</div>

</body>
</html>