package com.pegasus.hospital.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 字符编码过滤器
 * 设置请求和响应的字符编码为UTF-8
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class CharacterEncodingFilter implements Filter {
    
    private String encoding = "UTF-8";
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String encodingParam = filterConfig.getInitParameter("encoding");
        if (encodingParam != null && !encodingParam.isEmpty()) {
            this.encoding = encodingParam;
        }
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // 设置请求编码
        httpRequest.setCharacterEncoding(encoding);
        
        // 设置响应编码
        httpResponse.setCharacterEncoding(encoding);
        
        String uri = httpRequest.getRequestURI();
        if (uri.endsWith(".css")) {
            httpResponse.setContentType("text/css;charset=" + encoding);
        } else if (uri.endsWith(".js")) {
            httpResponse.setContentType("application/javascript;charset=" + encoding);
        }
        
        // 继续过滤链
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // 清理资源
    }
}
