<%@ page contentType="text/html;charset=UTF-8" %>

<%
String email =
(String)session.getAttribute("userEmail");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Phone Number</title>

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

</style>

</head>
<body>

<%
if(request.getParameter("error") != null){
%>
<script>
alert("❌ Phone update failed!");
</script>
<%
}
%>

<div class="card">

<h2>Update Phone Number</h2>

<form action="updatePhone" method="post">

<label>New Phone Number</label>

<input type="text"
       name="phone"
       required>

<button type="submit">
Update Phone
</button>

</form>

</div>

</body>
</html>