<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Forgot Password</title>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<%
if(request.getParameter("emailNotFound") != null){
%>
<script>
Swal.fire({
    icon: 'error',
    title: 'Email Not Found',
    text: 'Please enter a registered email.'
});
</script>
<%
}

if(request.getParameter("mismatch") != null){
%>
<script>
Swal.fire({
    icon: 'warning',
    title: 'Password Mismatch',
    text: 'New Password and Confirm Password do not match.'
});
</script>
<%
}

if(request.getParameter("error") != null){
%>
<script>
Swal.fire({
    icon: 'error',
    title: 'Error',
    text: 'Something went wrong. Please try again.'
});
</script>
<%
}
%>

<style>
body{
    font-family: Arial, sans-serif;
    background:#f4f6f9;
    display:flex;
    justify-content:center;
    align-items:center;
    height:100vh;
}

.container{
    background:white;
    padding:30px;
    border-radius:12px;
    box-shadow:0 4px 15px rgba(0,0,0,0.1);
    width:350px;
}

h2{
    text-align:center;
    margin-bottom:20px;
}

input{
    width:100%;
    padding:10px;
    margin-top:5px;
    margin-bottom:15px;
    border:1px solid #ccc;
    border-radius:5px;
}

button{
    width:100%;
    padding:10px;
    border:none;
    background:#0B1F3A;
    color:white;
    border-radius:5px;
    cursor:pointer;
    font-size:16px;
}

button:hover{
    background:#1F3B5C;
}
</style>

</head>
<body>

<div class="container">

    <h2>Forgot Password</h2>

    <form action="forgotPassword" method="post">

        <label>Email</label>
        <input type="email" name="email" required>

        <label>New Password</label>
        <input type="password" name="newPassword" required>

        <label>Confirm Password</label>
        <input type="password" name="confirmPassword" required>

        <button type="submit">
            Reset Password
        </button>

    </form>

</div>

</body>
</html>