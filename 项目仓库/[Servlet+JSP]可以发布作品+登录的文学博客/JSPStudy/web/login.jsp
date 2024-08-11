<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html >
<head>
    <link rel="icon" href="favicon.ico" type="image/x-icon">

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: auto;
            background-color: #fff;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #333;
        }
        form {
            margin-top: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
        }
        input[type="text"], textarea {
            width: 80%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        input[type="password"], textarea {
            width: 80%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        input[type="submit"] {
            background-color: #5cb85c;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            width: 100%;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            width: 100%;
            background-color: #4cae4c;
        }
        #preview {
            border: 1px solid #ddd;
            padding: 10px;
            margin-top: 20px;
            background-color: #f9f9f9;
        }
    </style>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<div class="container">
    <form class="form" action="http://localhost:8080/loginServlet"  method="post">
        <h1>${empty requestScope.Msg? "请输入用户名和密码":requestScope.Msg}</h1>
        用户：<input type="text" name="username"><br>
        密码：<input type="password"  name="password">
        <input type="submit" value="登录">
    </form>
</div>
</body>
</html>
