package com.pegasus.hospital.servlet;

import com.pegasus.hospital.service.PatientService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 注册Servlet
 * 处理患者注册请求
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class RegisterServlet extends HttpServlet {
    
    private PatientService patientService = new PatientService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 跳转到注册页面
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String idCard = request.getParameter("idCard");
        String phone = request.getParameter("phone");
        
        // 验证密码确认
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "两次输入的密码不一致");
            request.setAttribute("name", name);
            request.setAttribute("idCard", idCard);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // 调用服务注册
        String result = patientService.register(name, password, idCard, phone);
        
        if (result.startsWith("SUCCESS:")) {
            // 注册成功，获取患者ID
            String patientId = result.substring(8);
            
            // 自动登录：获取患者信息并存入Session
            com.pegasus.hospital.entity.Patient patient = patientService.findById(patientId);
            if (patient != null) {
                request.getSession().setAttribute("patient", patient);
            }
            
            // 重定向到首页，并带上注册成功的消息
            response.sendRedirect(request.getContextPath() + "/index.jsp?msg=registered");
        } else {
            // 注册失败
            request.setAttribute("error", result);
            request.setAttribute("name", name);
            request.setAttribute("idCard", idCard);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
