package com.pegasus.hospital.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 登录验证过滤器
 * 检查用户是否已登录，未登录则重定向到登录页面
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class AuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初始化
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // 获取请求路径
        String path = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // 获取Session
        HttpSession session = httpRequest.getSession(false);
        
        // 检查是否是管理员页面
        if (path.startsWith(contextPath + "/admin")) {
            // 排除登录页面
            if (path.endsWith("/admin/login.jsp")) {
                chain.doFilter(request, response);
                return;
            }
            
            // 检查管理员是否已登录
            if (session == null || session.getAttribute("admin") == null) {
                httpResponse.sendRedirect(contextPath + "/admin/login.jsp");
                return;
            }
        }
        // 检查是否是患者页面
        else if (path.startsWith(contextPath + "/patient") || path.startsWith(contextPath + "/appointment")) {
            // 检查患者是否已登录
            if (session == null || session.getAttribute("patient") == null) {
                httpResponse.sendRedirect(contextPath + "/login.jsp?error=needLogin");
                return;
            }
        }
        
        // 继续过滤链
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // 清理资源
    }
}
