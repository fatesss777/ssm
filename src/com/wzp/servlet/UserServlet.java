package com.wzp.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.wzp.bean.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = "/userServlet",name = "userServlet")
public class UserServlet extends HttpServlet
{
    Map<Integer, List<User>> map = new HashMap<>();

    public UserServlet()
    {
        List<User> list = new ArrayList<>();
        list.add(new User(1, "嘤嘤嘤", "123"));
        list.add(new User(2, "哈哈哈", "456"));
        list.add(new User(3, "嘎嘎嘎", "789"));
        map.put(1, list);

        list = new ArrayList<>();
        list.add(new User(1, "aaa", "123"));
        list.add(new User(2, "bbb", "456"));
        list.add(new User(3, "ccc", "789"));
        map.put(2, list);

        list = new ArrayList<>();
        list.add(new User(1, "111", "123"));
        list.add(new User(2, "222", "456"));
        list.add(new User(3, "333", "789"));
        map.put(3, list);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
    {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
    {
        System.out.println("doPost start");
        //resp.setContentType("text/xml");
        //获取浏览器地址栏里的mapKey的值
        int mapKey = Integer.parseInt(req.getParameter("mapKey"));

        List<User> list = map.get(mapKey);
        /*StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("<users>");
        for (User user : list)
        {
            stringBuffer.append("<user>");
            stringBuffer.append("<id>").append(user.getId()).append("</id>");
            stringBuffer.append("<name>").append(user.getName()).append("</name>");
            stringBuffer.append("<password>").append(user.getPassword()).append("</password>");
            stringBuffer.append("</user>");
        }
        stringBuffer.append("</users>");

        resp.getWriter().write(stringBuffer.toString());*/

        ObjectMapper objectMapper = new ObjectMapper();
        String json = objectMapper.writeValueAsString(list);
        System.out.println(json);
        resp.getWriter().write(json);

    }
}
