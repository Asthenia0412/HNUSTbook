<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="icon" href="favicon.ico" type="image/x-icon">

    <title>新建博客</title>
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
            width: 100%;
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
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #4cae4c;
        }
        #preview {
            border: 1px solid #ddd;
            padding: 10px;
            margin-top: 20px;
            background-color: #f9f9f9;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>新建博客</h1>
        <form action="submitBlog.jsp" method="post">
            <label for="title">博客标题:</label>
            <input type="text" id="title" name="title" required>
            <br>
            <label for="content">博客内容:</label>
            <br>
            <textarea id="content" name="content" rows="10" cols="50" onkeyup="previewContent()" required></textarea>
            <br>
            <label for="font">字体:</label>
            <select id="font" name="font" onchange="previewContent()">
                <option value="Arial">Arial</option>
                <option value="Times New Roman">Times New Roman</option>
                <option value="Verdana">Verdana</option>
            </select>
            <br>
            <label for="color">颜色:</label>
            <input type="color" id="color" name="color" onchange="previewContent()">
            <br>
            <input type="submit" value="提交">
        </form>
        <div id="preview">
            <h2>预览</h2>
            <div id="previewContent" style="font-family: Arial; color: black;"></div>
        </div>
    </div>
    <script>
        function previewContent() {
            var title = document.getElementById('title').value;
            var content = document.getElementById('content').value;
            var font = document.getElementById('font').value;
            var color = document.getElementById('color').value;
            var previewContent = document.getElementById('previewContent');

            // 替换换行符为HTML的<br>标签以保持格式
            var contentWithBreaks = content.replace(/\n/g, '<br>');

            // 设置预览区域的HTML内容和样式
            previewContent.innerHTML = '<h2>' + title + '</h2>' + contentWithBreaks;
            previewContent.style.fontFamily = font;
            previewContent.style.color = color;
        }
    </script>

</body>
</html>
