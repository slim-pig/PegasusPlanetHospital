package com.pegasus.hospital.servlet;

import com.pegasus.hospital.entity.Department;
import com.pegasus.hospital.entity.Doctor;
import com.pegasus.hospital.entity.Schedule;
import com.pegasus.hospital.service.DepartmentService;
import com.pegasus.hospital.service.DoctorService;
import com.pegasus.hospital.service.PatientService;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * API Servlet
 * 提供公共的REST API接口
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class ApiServlet extends HttpServlet {
    
    private DepartmentService departmentService = new DepartmentService();
    private DoctorService doctorService = new DoctorService();
    private PatientService patientService = new PatientService();
    private Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String resource = request.getParameter("resource");
        if (resource == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        response.setContentType("application/json;charset=UTF-8");
        
        switch (resource) {
            case "departments":
                getDepartments(response);
                break;
            case "doctors":
                getDoctors(request, response);
                break;
            case "schedules":
                getSchedules(request, response);
                break;
            case "checkPhone":
                checkPhone(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    /**
     * 获取所有科室
     */
    private void getDepartments(HttpServletResponse response) throws IOException {
        List<Department> departments = departmentService.findAll();
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", departments);
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * 获取医生列表
     */
    private void getDoctors(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String deptIdStr = request.getParameter("deptId");
        List<Doctor> doctors;
        
        if (deptIdStr != null && !deptIdStr.isEmpty()) {
            doctors = doctorService.findByDeptId(Integer.parseInt(deptIdStr));
        } else {
            doctors = doctorService.findAll();
        }
        
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", doctors);
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * 获取排班信息
     */
    private void getSchedules(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String doctorId = request.getParameter("doctorId");
        String dateStr = request.getParameter("date"); // yyyy-MM-dd
        
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        if (doctorId == null || doctorId.isEmpty()) {
            result.put("success", false);
            result.put("message", "缺少医生ID");
            out.print(gson.toJson(result));
            out.flush();
            return;
        }
        
        List<Schedule> schedules;
        if (dateStr != null && !dateStr.isEmpty()) {
            java.sql.Date date = java.sql.Date.valueOf(dateStr);
            schedules = doctorService.findSchedulesByDoctorAndDate(doctorId, date);
        } else {
            schedules = doctorService.findAvailableSchedules(doctorId);
        }
        
        result.put("success", true);
        result.put("data", schedules);
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * 检查手机号是否已注册
     */
    private void checkPhone(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String phone = request.getParameter("phone");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        if (phone == null || phone.isEmpty()) {
            result.put("success", false);
            result.put("message", "缺少手机号");
        } else {
            boolean exists = patientService.isPhoneExists(phone);
            result.put("success", true);
            result.put("exists", exists);
        }
        
        out.print(gson.toJson(result));
        out.flush();
    }
}
