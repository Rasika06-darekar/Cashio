<%@ page import="com.budgetbee.dao.UserDAO" %>
<%@ page import="com.budgetbee.model.User" %>

<%
if(session.getAttribute("userEmail") == null){
    response.sendRedirect("login.jsp");
    return;
}

String email =
(String)session.getAttribute("userEmail");

UserDAO dao =
new UserDAO();

User user =
dao.getUserByEmail(email);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Profile</title>

<style>

body{
    font-family:Segoe UI;
    background:#f4f7fc;
    padding:40px;
}

.card{
    max-width:600px;
    margin:auto;
    background:white;
    padding:30px;
    border-radius:15px;
    box-shadow:0 4px 15px rgba(0,0,0,0.1);
    margin-bottom:20px;
}

h2{
    color:#0B1F3A;
    margin-bottom:20px;
}

label{
    font-weight:bold;
}

input{
    width:100%;
    padding:12px;
    margin-top:8px;
    margin-bottom:20px;
    border:1px solid #ddd;
    border-radius:8px;
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

table{
    width:100%;
    border-collapse:collapse;
}

table td{
    padding:12px;
    border-bottom:1px solid #eee;
}

</style>

</head>

<body>
<%
if(request.getParameter("error") != null){
%>
<script>
alert("❌ Unable to update profile!");
</script>
<%
}
%>
<!-- Edit Profile Form -->

<div class="card">

<h2>Edit Profile</h2>

<form action="editProfile" method="post">

    <label>Full Name</label>

    <input type="text"
           name="fullName"
           value="<%= user.getFullName() %>"
           required>

    <label>Username</label>

    <input type="text"
           name="username"
           value="<%= user.getUsername() %>"
           required>

    <button type="submit">
        Save Changes
    </button>

</form>

</div>

<!-- User Details -->

<div class="card">

<h2>Current User Details</h2>

<table>

<tr>
    <td><b>Full Name</b></td>
    <td><%= user.getFullName() %></td>
</tr>

<tr>
    <td><b>Username</b></td>
    <td><%= user.getUsername() %></td>
</tr>

<tr>
    <td><b>Email</b></td>
    <td><%= user.getEmail() %></td>
</tr>

<tr>
    <td><b>Phone</b></td>
    <td><%= user.getPhone() %></td>
</tr>

</table>

</div>

</body>
</html>