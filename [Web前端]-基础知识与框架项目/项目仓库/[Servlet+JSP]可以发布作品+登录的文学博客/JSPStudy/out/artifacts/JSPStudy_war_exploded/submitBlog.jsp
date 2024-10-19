<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.OutputStreamWriter" %>
<%@ page import="java.io.IOException" %>
<html>
<head>
    <title>博客提交成功</title>
</head>
<body>
<link rel="icon" href="favicon.ico" type="image/x-icon">

    <%
        request.setCharacterEncoding("UTF-8"); // 设置请求编码为UTF-8
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String font = request.getParameter("font");
        String color = request.getParameter("color");
        String fileName = title.replace(" ", "_") + ".html"; // 将标题中的空格替换为下划线，并添加.html后缀

        try {
            // 获取服务器路径，并创建blogs目录（如果不存在）
            String path = request.getServletContext().getRealPath("/") + "blogs";
            File blogDir = new File(path);
            if (!blogDir.exists()) {
                blogDir.mkdirs();
            }

// 替换换行符为HTML的<br>标签
            content = content.replaceAll("\n", "<br>");

// 创建并写入文件，使用UTF-8编码
            FileOutputStream fos = new FileOutputStream(path + File.separator + fileName);
            OutputStreamWriter osw = new OutputStreamWriter(fos, "UTF-8");
            osw.write("<a href='/index.jsp' style='display:inline-block;padding:10px 20px;background-color:#4CAF50;color:white;text-decoration:none;border-radius:5px;'>返回博客主页</a>");
            osw.write("<html><head><meta charset=\"UTF-8\"><title>" + title + "</title>");
            osw.write("<style>");
            osw.write("body { font-family: Arial, sans-serif; background-color: #e0e0e0; margin: 0; padding: 0; }");
            osw.write(".container { width: 80%; margin: 0 auto; padding: 20px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); background-color: #f9f9f9; }");
            osw.write(".title { font-size: 28px; font-weight: bold; text-align: center; margin-bottom: 20px; color: #333; }");
            osw.write(".content { font-family: '楷体', serif; font-size: 18px; text-align: justify; color: #333; line-height: 1.6; margin: 0 auto; max-width: 800px; padding: 0 20px; }");
            osw.write("</style></head><body>");
            osw.write("<div class='container'>");
            osw.write("<div class='title'>" + title + "</div>");
            osw.write("<div class='content'>" + content + "</div>");
            osw.write("</div></body></html>");
            osw.close();

            out.println("<h1>博客提交成功</h1>");
            out.println("<p>您的博客已经保存，并可以在以下链接查看:</p>");
            out.println("<a href='blogs/" + fileName + "'>" + title + "</a>");

        } catch (IOException e) {
            out.println("<h1>博客提交失败</h1>");
            out.println("<p>发生错误：" + e.getMessage() + "</p>");
        }
    %>
</body>
</html>
