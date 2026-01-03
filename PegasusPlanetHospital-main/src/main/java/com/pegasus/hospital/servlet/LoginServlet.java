package com.pegasus.hospital.servlet;

import com.pegasus.hospital.entity.Admin;
import com.pegasus.hospital.entity.Patient;
import com.pegasus.hospital.service.AdminService;
import com.pegasus.hospital.service.PatientService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * 登录 Servlet
 * 统一处理管理员与患者登录
 *
 * 【修正版】
 * - 修复了 502 Bad Gateway 问题
 * - 移除了与云网关冲突的手动连接控制
 * - 回归标准的 sendRedirect 重定向
 */
public class LoginServlet extends HttpServlet {

    private final PatientService patientService = new PatientService();
    private final AdminService adminService = new AdminService();

    /**
     * 处理CORS预检请求
     */
    @Override
    protected void doOptions(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        setCorsHeaders(resp);
        resp.setStatus(HttpServletResponse.SC_OK);
    }

    private void setCorsHeaders(HttpServletResponse response) {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");
        response.setHeader("Access-Control-Max-Age", "3600");
        response.setHeader("Access-Control-Allow-Headers", "x-requested-with, Authorization, Content-Type");
    }

    /**
     * GET 请求
     * - action=logout：登出
     * - 其他：跳转登录页
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setCorsHeaders(response);

        String action = request.getParameter("action");

        // 处理登出
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            // 使用 forward 避免 302 被拦截 (内部跳转不需要 sendRedirect)
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }

        // 进入登录页面
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    /**
     * POST 请求
     * 处理登录逻辑
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 防止中文乱码
        request.setCharacterEncoding("UTF-8");
        
        String role = request.getParameter("role");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 使用 getContextPath() 确保路径在云端和本地都能正确运行
        String targetUrl = request.getContextPath() + "/index.jsp"; 
        
        try {
            // ===== 管理员登录 =====
            if ("admin".equals(role)) {
                Admin admin = adminService.login(username, password);
                if (admin != null) {
                    HttpSession session = request.getSession(true);
                    session.setAttribute("admin", admin);
                    session.setAttribute("userType", "admin");
                    targetUrl = request.getContextPath() + "/admin?action=dashboard";
                } else {
                    // 登录失败，为了用户体验，建议带上错误参数 (可选)
                    targetUrl = request.getContextPath() + "/admin/login.jsp?error=invalid";
                }
            }
            // ===== 患者登录 =====
            else {
                Patient patient = patientService.login(username, password);
                if (patient != null) {
                    HttpSession session = request.getSession(true);
                    session.setAttribute("patient", patient);
                    session.setAttribute("userType", "patient");
                    targetUrl = request.getContextPath() + "/patient?action=index";
                } else {
                    targetUrl = request.getContextPath() + "/login.jsp?error=invalid";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            targetUrl = request.getContextPath() + "/login.jsp?error=server";
        }

        // ========== 核心修复 ==========
        // 1. 发送标准 HTTP 302 重定向
        // Tomcat 会自动处理 Content-Length 和 Keep-Alive，不会惹恼华为云网关
        response.sendRedirect(targetUrl);
        
        // 2. 结束方法，防止后续代码继续执行
        return;
    }
}