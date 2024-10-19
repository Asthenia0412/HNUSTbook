package service;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //设置请求发来的字符集，避免乱码
        req.setCharacterEncoding("UTF-8");
        //获取用户名和密码
        String username=req.getParameter("username");
        String password=req.getParameter("password");
        //判断用户名密码是否正确（这里只做简单讲解）
        if(username.equals("测试账号")&&password.equals("123456")){
            HttpSession session = req.getSession();
            session.setAttribute("username", username);
            //如果用户名密码正确，则请求转发到登录成功页面
            req.getRequestDispatcher("success.jsp").forward(req,resp);
        }else{
            //否则重定向到登录界面，并提示用户用户名或密码错误
            req.setAttribute("Msg","用户名或密码错误");
            req.getRequestDispatcher("index.jsp").forward(req,resp);
        }
    }
}
