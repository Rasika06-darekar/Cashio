
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Upload Profile Picture</title>

<style>

body{
    font-family:Segoe UI,sans-serif;
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
    width:450px;
    box-shadow:0 4px 15px rgba(0,0,0,0.1);
}

h2{
    color:#0B1F3A;
    margin-bottom:20px;
    text-align:center;
}

input[type=file]{
    width:100%;
    padding:12px;
    border:1px solid #ddd;
    border-radius:10px;
}

button{
    width:100%;
    margin-top:20px;
    padding:12px;
    background:#007bff;
    color:white;
    border:none;
    border-radius:10px;
    cursor:pointer;
    font-size:16px;
}

button:hover{
    background:#0056b3;
}

.back-btn{
    display:block;
    text-align:center;
    margin-top:15px;
    text-decoration:none;
    color:#0B1F3A;
}

</style>

</head>
<body>

<div class="card">

    <h2>Upload Profile Picture</h2>

    <form action="uploadProfile"
          method="post"
          enctype="multipart/form-data">

        <input type="file"
               name="profilePic"
               accept="image/*"
               required>

        <button type="submit">
            Upload Picture
        </button>

    </form>

    <a href="dashboard" class="back-btn">
         Back to Dashboard
    </a>

</div>

</body>
</html>

