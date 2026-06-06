<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">
<title>Cashio - Register</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Segoe UI',sans-serif;
}

body{
    min-height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background:linear-gradient(135deg,#0B1F3A,#1F3B5C);
    padding:20px;
}

.container{
    width:1000px;
    background:white;
    border-radius:25px;
    overflow:hidden;
    display:flex;
    box-shadow:0 10px 40px rgba(0,0,0,0.3);
}

.left{
    width:45%;
    background:linear-gradient(135deg,#0B1F3A,#163D6B);
    color:white;
    padding:60px;
    display:flex;
    flex-direction:column;
    justify-content:center;
}

.left h1{
    font-size:50px;
    margin-bottom:15px;
}

.left p{
    font-size:18px;
    line-height:1.8;
}

.right{
    width:55%;
    padding:40px;
}

.right h2{
    text-align:center;
    color:#0B1F3A;
    margin-bottom:25px;
}

.row{
    display:flex;
    gap:15px;
}

.input-group{
    flex:1;
    margin-bottom:15px;
}

.input-group label{
    display:block;
    margin-bottom:6px;
    font-weight:600;
}

.input-group input{
    width:100%;
    padding:12px;
    border:1px solid #ccc;
    border-radius:10px;
    font-size:14px;
}

.input-group input:focus{
    outline:none;
    border-color:#0B1F3A;
}

button{
    width:100%;
    padding:14px;
    border:none;
    border-radius:10px;
    background:#0B1F3A;
    color:white;
    font-size:16px;
    cursor:pointer;
    margin-top:10px;
}

button:hover{
    background:#163D6B;
}

.login-link{
    text-align:center;
    margin-top:20px;
}

.login-link a{
    color:#0B1F3A;
    text-decoration:none;
    font-weight:bold;
}

</style>

</head>
<body>

<div class="container">

```
<div class="left">

    <h1>💰 Cashio</h1>

    <p>
        Create your account and start tracking
        your income, expenses and savings.
    </p>

    <br>

    <p>
        Smart budgeting made simple.
    </p>

</div>

<div class="right">

    <h2>Create Account</h2>

    <form action="register" method="post">

        <div class="input-group">
            <label>Full Name</label>
            <input type="text" name="fullName" required>
        </div>

        <div class="row">

            <div class="input-group">
                <label>Username</label>
                <input type="text" name="username" required>
            </div>

            <div class="input-group">
                <label>Phone</label>
                <input type="text" name="phone" required>
            </div>

        </div>

        <div class="input-group">
            <label>Email</label>
            <input type="email" name="email" required>
        </div>

        <div class="input-group">
            <label>Password</label>
            <input type="password" name="password" required>
        </div>

        <button type="submit">
            Create Account
        </button>

    </form>

    <div class="login-link">
        Already have an account?
        <a href="login.jsp">Login Here</a>
    </div>

</div>
```

</div>

</body>
</html>
