<%@ page contentType="text/html;charset=UTF-8" %>

<%
String currentEmail =
(String)session.getAttribute("userEmail");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Email</title>

<style>

body{
    font-family:Segoe UI;
    background:#f4f7fc;
    padding:40px;
}

.card{
    max-width:550px;
    margin:auto;
    background:white;
    padding:30px;
    border-radius:15px;
    box-shadow:0 4px 15px rgba(0,0,0,0.1);
}

input{
    width:100%;
    padding:12px;
    margin-top:8px;
    margin-bottom:20px;
}

button{
    background:#007bff;
    color:white;
    border:none;
    padding:12px 25px;
    border-radius:8px;
    cursor:pointer;
}

button:hover{
    background:#0056b3;
}

</style>

</head>
<body>
<%
if(request.getParameter("mismatch") != null){
%>
<script>
alert("❌ Emails do not match!");
</script>
<%
}

if(request.getParameter("error") != null){
%>
<script>
alert("❌ Email update failed!");
</script>
<%
}
%>
<div class="card">

<h2>Update Email</h2>

<form action="updateEmail" method="post">

<label>Current Email</label>
<input type="email"
       value="<%= currentEmail %>"
       readonly>

<label>New Email</label>
<input type="email"
       name="newEmail"
       required>

<label>Confirm Email</label>
<input type="email"
       name="confirmEmail"
       required>

<button type="submit">
Update Email
</button>

</form>

</div>

</body>
</html>