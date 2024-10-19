<%@ page import="java.io.File" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>我的博客</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f4f4f4;
    }
    .navbar {
      background-color: #3f72af;
      overflow: hidden;
    }
    .navbar a {
      float: left;
      display: block;
      color: white;
      text-align: center;
      padding: 14px 20px;
      text-decoration: none;
    }
    .navbar a:hover {
      background-color: #ddd;
      color: black;
    }
    .sidebar {
      background-color: #112d4e;
      float: left;
      width: 20%;
      padding-top:20%;
      height: 100%;
      color: white;
      padding: 15px;
    }
    .main-content {
      width: 80%;
      padding-left: 25%;
    }
    .blog-list {
      list-style-type: none;
      padding: 0;
      width:60%
    }
    .blog-list li {
      background-color: #fff;
      margin-bottom: 10px;
      padding: 10px;
      border-radius: 5px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }
    .blog-list li a {
      text-decoration: none;
      color: #333;
      font-weight: bold;
    }
    .blog-list li a:hover {
      color: #5cb85c;
    }
  </style>
</head>
<body>
<div class="navbar">
  <a href="index.jsp">首页</a>
  <a href="newBlog.jsp">新建博客</a>
  <a href="login.jsp">登录博客账号</a>
</div>
<link rel="icon" href="favicon.ico" type="image/x-icon">

<div class="sidebar">
  <h3>公告</h3>
  <p>欢迎 用户【${sessionScope.username}】 来到我的博客！</p><br>
  <p> </p>
  <p>本博客的技术栈为jsp+Servlet</p>
  <p>前端没有使用任何框架和组件库,仅仅使用最基础的html,css,js完成代码构建</p>
  <p>在前端的业务逻辑中,大量使用jsp来完成功能</p>
  <p>我们使用的Tomcat版本为9.0.89</p>
  <p>在后端的用户登录里,我们采取Session+Servlet来实现需求</p>
  <p>这种经典的技术栈组合,在2000年左右盛极一时</p>
  <p>但是伴随着技术的迭代更新,前后端分离式开发取代了这种高度耦合的技术体系</p>
  <p>除去我这样尝试重走经典技术路线,学习前人经验的情况外,大约只有在高校的课堂里才会看到这种陈旧的技术被应用了</p>
  <!-- 在这里可以添加更多的公告内容 -->
</div>

<div class="main-content">
  <h1>我的博客</h1>
  <h2>博客列表</h2>
  <ul class="blog-list">
    <!-- 读取本地文件，并为每个文件创建一个超链接 -->
    <%
      File directory = new File(request.getServletContext().getRealPath("/") + "blogs");
      File[] files = directory.listFiles();
      if (files != null) {
        for (File file : files) {
          String fileName = file.getName();
          // 删除.html后缀
          String blogTitle = fileName.replace(".html", "");
    %>
    <li><a href="blogs/<%= fileName %>"><%= blogTitle %></a></li>
    <%
        }
      }
    %>
  </ul>
</div>

<script>
  // 如果需要的话，可以在这里添加JavaScript代码
</script>
</body>
</html>
