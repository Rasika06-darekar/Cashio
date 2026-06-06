<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Registration Successful</title>

<style>

body{
    margin:0;
    padding:0;
    font-family:Segoe UI,sans-serif;
    background:#f4f7fc;
    display:flex;
    justify-content:center;
    align-items:center;
    height:100vh;
}

.success-card{
    background:white;
    padding:40px;
    border-radius:20px;
    text-align:center;
    box-shadow:0 5px 20px rgba(0,0,0,0.1);
    width:450px;
}

.success-icon{
    font-size:70px;
    color:#28a745;
}

h2{
    color:#0B1F3A;
    margin-top:15px;
}

p{
    color:#666;
    margin-bottom:25px;
}

.btn{
    display:inline-block;
    padding:12px 25px;
    background:#007bff;
    color:white;
    text-decoration:none;
    border-radius:10px;
    font-weight:bold;
}

.btn:hover{
    background:#0056b3;
}

</style>

</head>

<body>

<div class="success-card">

    <div class="success-icon">
        ✓
    </div>

    <h2>Registration Successful</h2>

    <p>
        Your account has been created successfully.
        You can now login and start managing your finances.
    </p>

    <a href="login.jsp" class="btn">
        Login Now
    </a>

    <br><br>

    <a href="register.jsp">
        Register Another User
    </a>

</div>

</body>
</html>