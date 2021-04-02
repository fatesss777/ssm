package com.wzp.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import java.io.IOException;

@WebFilter(urlPatterns = "/*")
public class CharacterFilter implements Filter
{
    @Override
    public void init(FilterConfig filterConfig) throws ServletException
    {
        System.out.println("过滤器启动");
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException
    {
        servletRequest.setCharacterEncoding("utf-8");
        servletResponse.setContentType("text/html");
        servletResponse.setCharacterEncoding("utf-8");
        System.out.println("设置过滤器");
        filterChain.doFilter(servletRequest,servletResponse);
    }

    @Override
    public void destroy()
    {
        System.out.println("过滤器销毁");
    }
}
