package com.pegasus.hospital.servlet;

import com.pegasus.hospital.entity.Doctor;
import com.pegasus.hospital.entity.Schedule;
import com.pegasus.hospital.service.DepartmentService;
import com.pegasus.hospital.service.DoctorService;
import com.pegasus.hospital.util.CommonUtil;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 医生Servlet
 * 处理医生相关的查询请求
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class DoctorServlet extends HttpServlet {
    
    private DoctorService doctorService = new DoctorService();
    private DepartmentService departmentService = new DepartmentService();
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
                    listDoctorsJson(request, response);
                } else {
                    listDoctors(request, response);
                }
                break;
            case "byDept":
                if (isAjax) {
                    listDoctorsByDeptJson(request, response);
                } else {
                    listDoctorsByDept(request, response);
                }
                break;
            case "detail":
                if (isAjax) {
                    getDoctorJson(request, response);
                } else {
                    getDoctor(request, response);
                }
                break;
            case "schedules":
                getSchedulesJson(request, response);
                break;
            default:
                if (isAjax) {
                    listDoctorsJson(request, response);
                } else {
                    listDoctors(request, response);
                }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * 查询所有医生（页面）
     */
    private void listDoctors(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 获取所有科室供筛选使用
        request.setAttribute("departments", departmentService.findAll());
        
        String deptIdStr = request.getParameter("deptId");
        List<Doctor> doctors;
        
        if (deptIdStr != null && !deptIdStr.isEmpty()) {
            try {
                int deptId = Integer.parseInt(deptIdStr);
                doctors = doctorService.findByDeptId(deptId);
            } catch (NumberFormatException e) {
                doctors = doctorService.findAll();
            }
        } else {
            doctors = doctorService.findAll();
        }
        
        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("/doctor/list.jsp").forward(request, response);
    }
    
    /**
     * 查询所有医生（JSON）
     */
    private void listDoctorsJson(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        List<Doctor> doctors = doctorService.findAll();
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", doctors);
        
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * 按科室查询医生（页面）
     */
    private void listDoctorsByDept(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String deptIdStr = request.getParameter("deptId");
        if (deptIdStr == null || deptIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "缺少科室ID参数");
            return;
        }
        
        try {
            Integer deptId = Integer.parseInt(deptIdStr);
            List<Doctor> doctors = doctorService.findByDeptId(deptId);
            request.setAttribute("doctors", doctors);
            request.setAttribute("deptId", deptId);
            request.getRequestDispatcher("/doctor/list.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "科室ID格式错误");
        }
    }
    
    /**
     * 按科室查询医生（JSON）
     */
    private void listDoctorsByDeptJson(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        String deptIdStr = request.getParameter("deptId");
        if (deptIdStr == null || deptIdStr.isEmpty()) {
            result.put("success", false);
            result.put("message", "缺少科室ID参数");
            out.print(gson.toJson(result));
            out.flush();
            return;
        }
        
        try {
            Integer deptId = Integer.parseInt(deptIdStr);
            List<Doctor> doctors = doctorService.findByDeptId(deptId);
            result.put("success", true);
            result.put("data", doctors);
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "科室ID格式错误");
        }
        
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * 查询医生详情（页面）
     */
    private void getDoctor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String doctorId = request.getParameter("id");
        if (doctorId == null || doctorId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "缺少医生ID参数");
            return;
        }
        
        Doctor doctor = doctorService.findById(doctorId);
        if (doctor == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "医生不存在");
            return;
        }
        
        // 查询医生未来7天的排班
        Date startDate = CommonUtil.getTodayStart();
        Date endDate = CommonUtil.addDays(7);
        List<Schedule> schedules = doctorService.findSchedulesByDoctorAndDateRange(doctorId, startDate, endDate);
        
        request.setAttribute("doctor", doctor);
        request.setAttribute("schedules", schedules);
        request.getRequestDispatcher("/doctor/detail.jsp").forward(request, response);
    }
    
    /**
     * 查询医生详情（JSON）
     */
    private void getDoctorJson(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        String doctorId = request.getParameter("id");
        if (doctorId == null || doctorId.isEmpty()) {
            result.put("success", false);
            result.put("message", "缺少医生ID参数");
            out.print(gson.toJson(result));
            out.flush();
            return;
        }
        
        Doctor doctor = doctorService.findById(doctorId);
        if (doctor == null) {
            result.put("success", false);
            result.put("message", "医生不存在");
        } else {
            result.put("success", true);
            result.put("data", doctor);
        }
        
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * 查询医生排班（JSON）
     */
    private void getSchedulesJson(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        String doctorId = request.getParameter("doctorId");
        String dateStr = request.getParameter("date");
        
        if (doctorId == null || doctorId.isEmpty()) {
            result.put("success", false);
            result.put("message", "缺少医生ID参数");
            out.print(gson.toJson(result));
            out.flush();
            return;
        }
        
        List<Schedule> schedules;
        if (CommonUtil.isNotEmpty(dateStr)) {
            // 查询指定日期的排班
            Date date = CommonUtil.parseDate(dateStr);
            if (date == null) {
                result.put("success", false);
                result.put("message", "日期格式错误");
                out.print(gson.toJson(result));
                out.flush();
                return;
            }
            schedules = doctorService.findAvailableSchedules(doctorId, date);
        } else {
            // 查询未来7天的排班
            Date startDate = CommonUtil.getTodayStart();
            Date endDate = CommonUtil.addDays(7);
            schedules = doctorService.findSchedulesByDoctorAndDateRange(doctorId, startDate, endDate);
        }
        
        result.put("success", true);
        result.put("data", schedules);
        
        out.print(gson.toJson(result));
        out.flush();
    }
}
