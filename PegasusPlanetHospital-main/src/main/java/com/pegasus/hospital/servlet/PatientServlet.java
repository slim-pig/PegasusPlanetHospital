package com.pegasus.hospital.servlet;

import com.pegasus.hospital.entity.Patient;
import com.pegasus.hospital.entity.Appointment;
import com.pegasus.hospital.service.PatientService;
import com.pegasus.hospital.service.AppointmentService;
import com.pegasus.hospital.util.CommonUtil;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;
import java.util.stream.Collectors;

/**
 * 患者Servlet
 * 处理患者相关的操作请求
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class PatientServlet extends HttpServlet {
    
    private PatientService patientService = new PatientService();
    private AppointmentService appointmentService = new AppointmentService();
    private Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "index";
        }
        
        switch (action) {
            case "index":
                showIndex(request, response);
                break;
            case "profile":
                showProfileForm(request, response);
                break;
            case "password":
                showPasswordForm(request, response);
                break;
            case "deactivate":
                deactivateAccount(request, response);
                break;
            default:
                showIndex(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        switch (action) {
            case "update":
                updateInfo(request, response);
                break;
            case "password":
                changePassword(request, response);
                break;
            case "deactivate":
                deactivateAccount(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    /**
     * 显示个人中心首页
     */
    private void showIndex(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Patient patient = (Patient) session.getAttribute("patient");
        
        // 刷新患者信息
        if (patient != null) {
            patient = patientService.findById(patient.getPatientId());
            session.setAttribute("patient", patient);
            
            // 获取预约统计信息
            List<Appointment> appointments = appointmentService.findByPatientId(patient.getPatientId());
            
            int appointmentCount = appointments.size();
            long completedCount = appointments.stream()
                    .filter(a -> Appointment.STATUS_COMPLETED.equals(a.getStatus()))
                    .count();
            long upcomingCount = appointments.stream()
                    .filter(a -> Appointment.STATUS_BOOKED.equals(a.getStatus()))
                    .count();
            
            // 获取近期预约（前5条）
            List<Appointment> recentAppointments = appointments.stream()
                    .sorted((a1, a2) -> a2.getAppointmentDate().compareTo(a1.getAppointmentDate())) // 按日期降序
                    .limit(5)
                    .collect(Collectors.toList());
            
            request.setAttribute("appointmentCount", appointmentCount);
            request.setAttribute("completedCount", completedCount);
            request.setAttribute("upcomingCount", upcomingCount);
            request.setAttribute("recentAppointments", recentAppointments);
        }
        
        request.setAttribute("patient", patient);
        request.getRequestDispatcher("/patient/index.jsp").forward(request, response);
    }
    
    /**
     * 显示修改资料表单
     */
    private void showProfileForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Patient patient = (Patient) session.getAttribute("patient");
        request.setAttribute("patient", patient);
        request.getRequestDispatcher("/patient/profile.jsp").forward(request, response);
    }
    
    /**
     * 显示修改密码表单
     */
    private void showPasswordForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/patient/password.jsp").forward(request, response);
    }
    
    /**
     * 显示注销账号表单
     */
    private void showDeactivateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/patient/deactivate.jsp").forward(request, response);
    }
    
    /**
     * 更新患者信息
     */
    private void updateInfo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Patient currentPatient = (Patient) session.getAttribute("patient");
        
        // 获取表单数据
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String birthdayStr = request.getParameter("birthday");
        
        // 更新患者对象
        currentPatient.setName(name);
        currentPatient.setPhone(phone);
        currentPatient.setGender(gender);
        currentPatient.setAddress(address);
        currentPatient.setEmail(email);
        if (CommonUtil.isNotEmpty(birthdayStr)) {
            currentPatient.setBirthday(CommonUtil.parseDate(birthdayStr));
        }
        
        // 调用服务更新
        String result = patientService.updateInfo(currentPatient);
        
        if ("SUCCESS".equals(result)) {
            // 刷新Session中的患者信息
            session.setAttribute("patient", patientService.findById(currentPatient.getPatientId()));
            request.setAttribute("msg", "信息修改成功");
        } else {
            request.setAttribute("error", result);
        }
        
        request.setAttribute("patient", currentPatient);
        request.getRequestDispatcher("/patient/profile.jsp").forward(request, response);
    }
    
    /**
     * 修改密码
     */
    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Patient patient = (Patient) session.getAttribute("patient");
        
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // 验证确认密码
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "两次输入的新密码不一致");
            request.getRequestDispatcher("/patient/password.jsp").forward(request, response);
            return;
        }
        
        // 调用服务修改密码
        String result = patientService.changePassword(patient.getPatientId(), oldPassword, newPassword);
        
        if ("SUCCESS".equals(result)) {
            request.setAttribute("msg", "密码修改成功");
        } else {
            request.setAttribute("error", result);
        }
        
        request.getRequestDispatcher("/patient/password.jsp").forward(request, response);
    }
    
    /**
     * 注销账号
     */
    private void deactivateAccount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Patient patient = (Patient) session.getAttribute("patient");
        
        if (patient == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String password = request.getParameter("password");
        boolean success;
        
        if (password != null && !password.isEmpty()) {
            // 带密码验证的注销
            success = patientService.deactivate(patient.getPatientId(), password);
        } else {
            // 直接注销（来自链接点击）
            success = patientService.deactivate(patient.getPatientId());
        }
        
        if (success) {
            // 注销成功，清除Session并重定向到首页
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/index.jsp?msg=accountDeactivated");
        } else {
            if (password != null) {
                request.setAttribute("error", "密码错误或注销失败");
                request.getRequestDispatcher("/patient/profile.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/patient?action=index&error=deactivateFailed");
            }
        }
    }
}
