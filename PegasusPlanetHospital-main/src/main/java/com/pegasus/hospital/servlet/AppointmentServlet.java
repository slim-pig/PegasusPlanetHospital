package com.pegasus.hospital.servlet;

import com.pegasus.hospital.entity.Appointment;
import com.pegasus.hospital.entity.Patient;
import com.pegasus.hospital.entity.Schedule;
import com.pegasus.hospital.service.AppointmentService;
import com.pegasus.hospital.service.DoctorService;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 预约Servlet
 * 处理预约挂号相关的请求
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class AppointmentServlet extends HttpServlet {
    
    private AppointmentService appointmentService = new AppointmentService();
    private DoctorService doctorService = new DoctorService();
    private Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        // 判断是否是Ajax请求
        String accept = request.getHeader("Accept");
        boolean isAjax = accept != null && accept.contains("application/json");
        
        switch (action) {
            case "list":
                if (isAjax) {
                    listAppointmentsJson(request, response);
                } else {
                    listAppointments(request, response);
                }
                break;
            case "detail":
                if (isAjax) {
                    getAppointmentJson(request, response);
                } else {
                    getAppointment(request, response);
                }
                break;
            case "book":
                showBookForm(request, response);
                break;
            default:
                if (isAjax) {
                    listAppointmentsJson(request, response);
                } else {
                    listAppointments(request, response);
                }
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
        
        // 判断是否是Ajax请求
        String accept = request.getHeader("Accept");
        boolean isAjax = accept != null && accept.contains("application/json");
        
        switch (action) {
            case "book":
                if (isAjax) {
                    makeAppointmentJson(request, response);
                } else {
                    makeAppointment(request, response);
                }
                break;
            case "cancel":
                if (isAjax) {
                    cancelAppointmentJson(request, response);
                } else {
                    cancelAppointment(request, response);
                }
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    /**
     * 显示患者的预约列表（页面）
     */
    private void listAppointments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Patient patient = (Patient) session.getAttribute("patient");
        
        List<Appointment> appointments = appointmentService.findByPatientId(patient.getPatientId());
        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("/patient/appointments.jsp").forward(request, response);
    }
    
    /**
     * 显示患者的预约列表（JSON）
     */
    private void listAppointmentsJson(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        Patient patient = (Patient) session.getAttribute("patient");
        
        List<Appointment> appointments = appointmentService.findByPatientId(patient.getPatientId());
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", appointments);
        
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * 显示预约详情（页面）
     */
    private void getAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String appointmentId = request.getParameter("id");
        if (appointmentId == null || appointmentId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "缺少预约ID参数");
            return;
        }
        
        Appointment appointment = appointmentService.findById(appointmentId);
        if (appointment == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "预约不存在");
            return;
        }
        
        // 验证是否是当前用户的预约
        HttpSession session = request.getSession();
        Patient patient = (Patient) session.getAttribute("patient");
        if (!appointment.getPatientId().equals(patient.getPatientId())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权查看该预约");
            return;
        }
        
        request.setAttribute("appointment", appointment);
        request.getRequestDispatcher("/patient/appointment_detail.jsp").forward(request, response);
    }
    
    /**
     * 显示预约详情（JSON）
     */
    private void getAppointmentJson(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        String appointmentId = request.getParameter("id");
        if (appointmentId == null || appointmentId.isEmpty()) {
            result.put("success", false);
            result.put("message", "缺少预约ID参数");
            out.print(gson.toJson(result));
            out.flush();
            return;
        }
        
        Appointment appointment = appointmentService.findById(appointmentId);
        if (appointment == null) {
            result.put("success", false);
            result.put("message", "预约不存在");
        } else {
            result.put("success", true);
            result.put("data", appointment);
        }
        
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * 显示预约表单
     */
    private void showBookForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String scheduleIdStr = request.getParameter("scheduleId");
        if (scheduleIdStr != null && !scheduleIdStr.isEmpty()) {
            try {
                Integer scheduleId = Integer.parseInt(scheduleIdStr);
                Schedule schedule = doctorService.findScheduleById(scheduleId);
                if (schedule != null) {
                    request.setAttribute("schedule", schedule);
                }
            } catch (NumberFormatException e) {
                // 忽略
            }
        }
        request.getRequestDispatcher("/patient/book.jsp").forward(request, response);
    }
    
    /**
     * 预约挂号（页面）
     */
    private void makeAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Patient patient = (Patient) session.getAttribute("patient");
        
        if (patient == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String scheduleIdStr = request.getParameter("scheduleId");
        if (scheduleIdStr == null || scheduleIdStr.isEmpty()) {
            request.setAttribute("error", "请选择预约时间段");
            request.getRequestDispatcher("/patient/book.jsp").forward(request, response);
            return;
        }
        
        try {
            Integer scheduleId = Integer.parseInt(scheduleIdStr);
            String result = appointmentService.makeAppointment(patient.getPatientId(), scheduleId);
            
            if (result.startsWith("SUCCESS:")) {
                String appointmentId = result.substring(8);
                response.sendRedirect(request.getContextPath() + "/appointment?action=detail&id=" + appointmentId + "&success=1");
            } else {
                request.setAttribute("error", result);
                Schedule schedule = doctorService.findScheduleById(scheduleId);
                request.setAttribute("schedule", schedule);
                request.getRequestDispatcher("/patient/book.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "参数格式错误");
            request.getRequestDispatcher("/patient/book.jsp").forward(request, response);
        }
    }
    
    /**
     * 预约挂号（JSON）
     */
    private void makeAppointmentJson(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        HttpSession session = request.getSession();
        Patient patient = (Patient) session.getAttribute("patient");
        
        if (patient == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            out.print(gson.toJson(result));
            out.flush();
            return;
        }
        
        String scheduleIdStr = request.getParameter("scheduleId");
        if (scheduleIdStr == null || scheduleIdStr.isEmpty()) {
            result.put("success", false);
            result.put("message", "请选择预约时间段");
            out.print(gson.toJson(result));
            out.flush();
            return;
        }
        
        try {
            Integer scheduleId = Integer.parseInt(scheduleIdStr);
            String serviceResult = appointmentService.makeAppointment(patient.getPatientId(), scheduleId);
            
            if (serviceResult.startsWith("SUCCESS:")) {
                String appointmentId = serviceResult.substring(8);
                result.put("success", true);
                result.put("message", "预约成功");
                result.put("appointmentId", appointmentId);
            } else {
                result.put("success", false);
                result.put("message", serviceResult);
            }
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "参数格式错误");
        }
        
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * 取消预约（页面）
     */
    private void cancelAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Patient patient = (Patient) session.getAttribute("patient");
        
        String appointmentId = request.getParameter("id");
        String cancelReason = request.getParameter("reason");
        
        if (appointmentId == null || appointmentId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "缺少预约ID参数");
            return;
        }
        
        String result = appointmentService.cancelAppointment(appointmentId, patient.getPatientId(), cancelReason);
        
        if ("SUCCESS".equals(result)) {
            response.sendRedirect(request.getContextPath() + "/appointment?action=list&msg=cancelSuccess");
        } else {
            request.setAttribute("error", result);
            Appointment appointment = appointmentService.findById(appointmentId);
            request.setAttribute("appointment", appointment);
            request.getRequestDispatcher("/patient/appointment_detail.jsp").forward(request, response);
        }
    }
    
    /**
     * 取消预约（JSON）
     */
    private void cancelAppointmentJson(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        HttpSession session = request.getSession();
        Patient patient = (Patient) session.getAttribute("patient");
        
        if (patient == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            out.print(gson.toJson(result));
            out.flush();
            return;
        }
        
        String appointmentId = request.getParameter("id");
        String cancelReason = request.getParameter("reason");
        
        if (appointmentId == null || appointmentId.isEmpty()) {
            result.put("success", false);
            result.put("message", "缺少预约ID参数");
            out.print(gson.toJson(result));
            out.flush();
            return;
        }
        
        String serviceResult = appointmentService.cancelAppointment(appointmentId, patient.getPatientId(), cancelReason);
        
        if ("SUCCESS".equals(serviceResult)) {
            result.put("success", true);
            result.put("message", "取消成功");
        } else {
            result.put("success", false);
            result.put("message", serviceResult);
        }
        
        out.print(gson.toJson(result));
        out.flush();
    }
}
