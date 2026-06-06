<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">
<title>Cashio Login</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Segoe UI',sans-serif;
}

body{
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background:linear-gradient(135deg,#0B1F3A,#1F3B5C);
}

.container{
    width:900px;
    height:550px;
    background:white;
    border-radius:25px;
    overflow:hidden;
    display:flex;
    box-shadow:0 10px 40px rgba(0,0,0,0.3);
}

.left{
    width:50%;
    background:linear-gradient(135deg,#0B1F3A,#163D6B);
    color:white;
    padding:60px;
    display:flex;
    flex-direction:column;
    justify-content:center;
}

.left h1{
    font-size:55px;
    margin-bottom:15px;
}

.left p{
    font-size:20px;
    line-height:1.8;
}

.left span{
    color:#FFD700;
}

.right{
    width:50%;
    padding:60px;
    display:flex;
    flex-direction:column;
    justify-content:center;
}

.right h2{
    text-align:center;
    margin-bottom:30px;
    color:#0B1F3A;
}

.input-group{
    margin-bottom:20px;
}

.input-group label{
    display:block;
    margin-bottom:8px;
    font-weight:600;
}

.input-group input{
    width:100%;
    padding:15px;
    border:1px solid #ccc;
    border-radius:10px;
    font-size:15px;
}

.input-group input:focus{
    outline:none;
    border-color:#0B1F3A;
}

button{
    width:100%;
    padding:15px;
    border:none;
    border-radius:10px;
    background:#0B1F3A;
    color:white;
    font-size:18px;
    cursor:pointer;
    transition:.3s;
}

button:hover{
    background:#163D6B;
}

.register{
    text-align:center;
    margin-top:20px;
}

.register a{
    color:#0B1F3A;
    text-decoration:none;
    font-weight:bold;
}

</style>

</head>
<body>
<%
if(request.getParameter("passwordReset") != null){
%>
<script>
alert("✅ Password Reset Successfully! Please Login.");
</script>
<%
}
%>
<div class="container">


<div class="left">
    <h1>💰 Cashio</h1>

    <p>
        Track. <span>Save.</span> Grow.
    </p>

    <br>

    <p>
        Manage your income, expenses and savings
        with a modern personal finance dashboard.
    </p>
</div>

<div class="right">

    <h2>Welcome Back</h2>

    <form action="login" method="post">

        <div class="input-group">
            <label>Email</label>
            <input type="email" name="email" required>
        </div>

        <div class="input-group">
            <label>Password</label>
            <input type="password" name="password" required>
        </div>

        <button type="submit">
            Login
        </button>

    </form>
	<a href="forgotPassword.jsp"
   style="
   color:#007bff;
   text-decoration:none;
   font-weight:bold;">
   Forgot Password?
</a>
    <div class="register">
        Don't have an account?
        <a href="register.jsp">Register Now</a>
    </div>

</div>
<br><br>



</div>

</body>
</html>
