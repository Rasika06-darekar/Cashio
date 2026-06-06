<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Change Password</title>

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

.links{
    margin-top:20px;
    text-align:center;
}

.links a{
    text-decoration:none;
    color:#007bff;
    font-weight:bold;
}

.links a:hover{
    text-decoration:underline;
}

</style>

</head>
<body>

<%
if(request.getParameter("wrongCurrent") != null){
%>
<script>
alert("❌ Current Password Incorrect!");
</script>
<%
}

if(request.getParameter("mismatch") != null){
%>
<script>
alert("❌ Passwords do not match!");
</script>
<%
}

if(request.getParameter("error") != null){
%>
<script>
alert("❌ Password update failed!");
</script>
<%
}
%>

<div class="card">

    <h2>Change Password</h2>

    <form action="changePassword" method="post">

        <label>Current Password</label>
        <input type="password"
               name="currentPassword"
               required>

        <label>New Password</label>
        <input type="password"
               name="newPassword"
               required>

        <label>Confirm Password</label>
        <input type="password"
               name="confirmPassword"
               required>

        <button type="submit">
            Change Password
        </button>

    </form>

    <div class="links">

        <a href="forgotPassword.jsp">
            Forgot Current Password?
        </a>

        <br><br>

        <a href="settings.jsp">
            ← Back to Settings
        </a>

    </div>

</div>

</body>
</html>