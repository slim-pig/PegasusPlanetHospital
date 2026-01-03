package com.pegasus.hospital.servlet;

import com.pegasus.hospital.entity.*;
import com.pegasus.hospital.service.*;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.*;

/**
 * 管理员Servlet
 * 处理管理员相关的请求
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
@MultipartConfig
public class AdminServlet extends HttpServlet {
    
    private AdminService adminService = new AdminService();
    private DoctorService doctorService = new DoctorService();
    private DepartmentService departmentService = new DepartmentService();
    private AppointmentService appointmentService = new AppointmentService();
    private PatientService patientService = new PatientService();
    private Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "dashboard";
        }
        
        switch (action) {
            case "dashboard":
                showDashboard(request, response);
                break;
            case "doctors":
                listDoctors(request, response);
                break;
            case "doctorForm":
                showDoctorForm(request, response);
                break;
            case "schedules":
                listSchedules(request, response);
                break;
            case "scheduleForm":
                showScheduleForm(request, response);
                break;
            case "appointments":
                listAppointments(request, response);
                break;
            case "patients":
                listPatients(request, response);
                break;
            case "statistics":
                showStatistics(request, response);
                break;
            case "import":
                showImportPage(request, response);
                break;
            default:
                showDashboard(request, response);
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
            case "addDoctor":
                addDoctor(request, response);
                break;
            case "updateDoctor":
                updateDoctor(request, response);
                break;
            case "deleteDoctor":
                deleteDoctor(request, response);
                break;
            case "addSchedule":
                addSchedule(request, response);
                break;
            case "updateSchedule":
                updateSchedule(request, response);
                break;
            case "deleteSchedule":
                deleteSchedule(request, response);
                break;
            case "generateSchedules":
                generateSchedules(request, response);
                break;
            case "importDoctors":
                importDoctors(request, response);
                break;
            case "importSchedules":
                importSchedules(request, response);
                break;
            case "updateAppointmentStatus":
                updateAppointmentStatus(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    /**
     * 更新预约状态
     */
    private void updateAppointmentStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        String appointmentId = request.getParameter("id");
        String status = request.getParameter("status");
        
        if (appointmentId == null || status == null) {
            result.put("success", false);
            result.put("message", "参数不完整");
            out.print(gson.toJson(result));
            out.flush();
            return;
        }
        
        String opResult;
        if ("COMPLETED".equals(status)) {
            opResult = appointmentService.completeAppointment(appointmentId);
        } else if ("CANCELLED".equals(status)) {
            opResult = appointmentService.cancelAppointmentByAdmin(appointmentId, "管理员强制取消");
        } else {
            opResult = "不支持的状态操作";
        }
        
        boolean success = "SUCCESS".equals(opResult);
        result.put("success", success);
        result.put("message", success ? "操作成功" : opResult);
        
        out.print(gson.toJson(result));
        out.flush();
    }

    /**
     * 显示仪表盘
     */
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 获取统计数据
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalDoctors", doctorService.countAll());
        stats.put("totalPatients", patientService.countAll());
        stats.put("totalAppointments", appointmentService.countAll());
        stats.put("todayAppointments", appointmentService.countToday());
        stats.put("departments", departmentService.findAll());
        
        // 获取最近预约
        List<Appointment> recentAppointments = appointmentService.findRecent(10);
        
        request.setAttribute("stats", stats);
        request.setAttribute("recentAppointments", recentAppointments);
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
    
    /**
     * 医生列表
     */
    private void listDoctors(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String deptIdStr = request.getParameter("deptId");
        String keyword = request.getParameter("keyword");
        
        List<Doctor> doctors;
        if (deptIdStr != null && !deptIdStr.isEmpty()) {
            doctors = doctorService.findByDepartment(Integer.parseInt(deptIdStr));
        } else if (keyword != null && !keyword.isEmpty()) {
            doctors = doctorService.search(keyword);
        } else {
            doctors = doctorService.findAll();
        }
        
        List<Department> departments = departmentService.findAll();
        
        request.setAttribute("doctors", doctors);
        request.setAttribute("departments", departments);
        request.setAttribute("selectedDeptId", deptIdStr);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/admin/doctors.jsp").forward(request, response);
    }
    
    /**
     * 显示医生表单
     */
    private void showDoctorForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String doctorId = request.getParameter("id");
        if (doctorId != null && !doctorId.isEmpty()) {
            Doctor doctor = doctorService.findById(doctorId);
            request.setAttribute("doctor", doctor);
        }
        
        List<Department> departments = departmentService.findAll();
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/admin/doctor_form.jsp").forward(request, response);
    }
    
    /**
     * 排班列表
     */
    private void listSchedules(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String doctorId = request.getParameter("doctorId");
        String dateStr = request.getParameter("date");
        
        List<Schedule> schedules;
        if (doctorId != null && !doctorId.isEmpty()) {
            schedules = doctorService.findSchedulesByDoctor(doctorId);
        } else {
            schedules = doctorService.findAllSchedules();
        }
        
        List<Doctor> doctors = doctorService.findAll();
        
        request.setAttribute("schedules", schedules);
        request.setAttribute("doctors", doctors);
        request.setAttribute("selectedDoctorId", doctorId);
        request.getRequestDispatcher("/admin/schedules.jsp").forward(request, response);
    }
    
    /**
     * 显示排班表单
     */
    private void showScheduleForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String scheduleIdStr = request.getParameter("id");
        if (scheduleIdStr != null && !scheduleIdStr.isEmpty()) {
            Schedule schedule = doctorService.findScheduleById(Integer.parseInt(scheduleIdStr));
            request.setAttribute("schedule", schedule);
        }
        
        List<Doctor> doctors = doctorService.findAll();
        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("/admin/schedule_form.jsp").forward(request, response);
    }
    
    /**
     * 预约列表
     */
    private void listAppointments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = request.getParameter("status");
        String dateStr = request.getParameter("date");
        String pageStr = request.getParameter("page");
        
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            page = Integer.parseInt(pageStr);
        }
        
        int pageSize = 20;
        List<Appointment> appointments;
        int total;
        
        if (status != null && !status.isEmpty()) {
            appointments = appointmentService.findByStatus(status, page, pageSize);
            total = appointmentService.countByStatus(status);
        } else {
            appointments = appointmentService.findAll(page, pageSize);
            total = appointmentService.countAll();
        }
        
        int totalPages = (total + pageSize - 1) / pageSize;
        
        request.setAttribute("appointments", appointments);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("total", total);
        request.setAttribute("selectedStatus", status);
        request.getRequestDispatcher("/admin/appointments.jsp").forward(request, response);
    }
    
    /**
     * 患者列表
     */
    private void listPatients(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String pageStr = request.getParameter("page");
        
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            page = Integer.parseInt(pageStr);
        }
        
        int pageSize = 20;
        List<Patient> patients;
        int total;
        
        if (keyword != null && !keyword.isEmpty()) {
            patients = patientService.search(keyword, page, pageSize);
            total = patientService.countByKeyword(keyword);
        } else {
            patients = patientService.findAll(page, pageSize);
            total = patientService.countAll();
        }
        
        int totalPages = (total + pageSize - 1) / pageSize;
        
        request.setAttribute("patients", patients);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("total", total);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/admin/patients.jsp").forward(request, response);
    }
    
    /**
     * 统计页面
     */
    private void showStatistics(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 获取月份参数
        String monthStr = request.getParameter("month");
        String month;
        if (monthStr != null && !monthStr.isEmpty()) {
            month = monthStr;
        } else {
            // 默认当前月
            Calendar cal = Calendar.getInstance();
            month = String.format("%d-%02d", cal.get(Calendar.YEAR), cal.get(Calendar.MONTH) + 1);
        }
        
        // 获取统计数据
        Map<String, Object> deptStats = appointmentService.getStatsByDepartment(month);
        Map<String, Object> doctorStats = appointmentService.getStatsByDoctor(month);
        Map<String, Integer> dailyStats = appointmentService.getDailyStats(month);
        
        request.setAttribute("month", month);
        request.setAttribute("deptStats", deptStats);
        request.setAttribute("doctorStats", doctorStats);
        request.setAttribute("dailyStats", dailyStats);
        request.getRequestDispatcher("/admin/statistics.jsp").forward(request, response);
    }
    
    /**
     * 显示导入页面
     */
    private void showImportPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Department> departments = departmentService.findAll();
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/admin/import.jsp").forward(request, response);
    }
    
    /**
     * 添加医生
     */
    private void addDoctor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Doctor doctor = new Doctor();
        doctor.setName(request.getParameter("name"));
        doctor.setGender(request.getParameter("gender"));
        doctor.setDeptId(Integer.parseInt(request.getParameter("deptId")));
        doctor.setTitle(request.getParameter("title"));
        doctor.setSpecialty(request.getParameter("specialty"));
        doctor.setPhone(request.getParameter("phone"));
        doctor.setEmail(request.getParameter("email"));
        
        String result = doctorService.addDoctor(doctor);
        
        if (result.startsWith("SUCCESS")) {
            response.sendRedirect(request.getContextPath() + "/admin?action=doctors&msg=addSuccess");
        } else {
            request.setAttribute("error", result);
            request.setAttribute("doctor", doctor);
            List<Department> departments = departmentService.findAll();
            request.setAttribute("departments", departments);
            request.getRequestDispatcher("/admin/doctor_form.jsp").forward(request, response);
        }
    }
    
    /**
     * 更新医生
     */
    private void updateDoctor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Doctor doctor = new Doctor();
        doctor.setDoctorId(request.getParameter("doctorId"));
        doctor.setName(request.getParameter("name"));
        doctor.setGender(request.getParameter("gender"));
        doctor.setDeptId(Integer.parseInt(request.getParameter("deptId")));
        doctor.setTitle(request.getParameter("title"));
        doctor.setSpecialty(request.getParameter("specialty"));
        doctor.setPhone(request.getParameter("phone"));
        doctor.setEmail(request.getParameter("email"));
        
        // 设置默认状态为1（在职），防止更新时NPE
        String statusStr = request.getParameter("status");
        if (statusStr != null && !statusStr.isEmpty()) {
            doctor.setStatus(Integer.parseInt(statusStr));
        } else {
            doctor.setStatus(1);
        }
        
        boolean success = doctorService.updateDoctor(doctor).startsWith("SUCCESS");
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin?action=doctors&msg=updateSuccess");
        } else {
            request.setAttribute("error", "更新失败");
            request.setAttribute("doctor", doctor);
            List<Department> departments = departmentService.findAll();
            request.setAttribute("departments", departments);
            request.getRequestDispatcher("/admin/doctor_form.jsp").forward(request, response);
        }
    }
    
    /**
     * 删除医生
     */
    private void deleteDoctor(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        String doctorId = request.getParameter("id");
        if (doctorId == null || doctorId.isEmpty()) {
            result.put("success", false);
            result.put("message", "缺少医生ID");
            out.print(gson.toJson(result));
            out.flush();
            return;
        }
        
        boolean success = doctorService.deleteDoctor(doctorId);
        result.put("success", success);
        result.put("message", success ? "删除成功" : "删除失败，可能有关联的排班或预约");
        
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * 添加排班
     */
    private void addSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Schedule schedule = new Schedule();
        schedule.setDoctorId(request.getParameter("doctorId"));
        schedule.setScheduleDate(java.sql.Date.valueOf(request.getParameter("scheduleDate")));
        schedule.setTimeSlot(request.getParameter("timeSlot"));
        schedule.setMaxPatients(Integer.parseInt(request.getParameter("maxPatients")));
        schedule.setCurrentPatients(0);
        schedule.setStatus(1);
        
        boolean success = doctorService.addSchedule(schedule).startsWith("SUCCESS");
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin?action=schedules&msg=addSuccess");
        } else {
            request.setAttribute("error", "添加排班失败");
            request.setAttribute("schedule", schedule);
            List<Doctor> doctors = doctorService.findAll();
            request.setAttribute("doctors", doctors);
            request.getRequestDispatcher("/admin/schedule_form.jsp").forward(request, response);
        }
    }
    
    /**
     * 更新排班
     */
    private void updateSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Schedule schedule = new Schedule();
        schedule.setScheduleId(Integer.parseInt(request.getParameter("scheduleId")));
        schedule.setDoctorId(request.getParameter("doctorId"));
        schedule.setScheduleDate(java.sql.Date.valueOf(request.getParameter("scheduleDate")));
        schedule.setTimeSlot(request.getParameter("timeSlot"));
        schedule.setMaxPatients(Integer.parseInt(request.getParameter("maxPatients")));
        schedule.setStatus(Integer.parseInt(request.getParameter("status")));
        
        // 补充currentPatients，避免更新时为null
        String currentPatientsStr = request.getParameter("currentPatients");
        if (currentPatientsStr != null && !currentPatientsStr.isEmpty()) {
            schedule.setCurrentPatients(Integer.parseInt(currentPatientsStr));
        } else {
            schedule.setCurrentPatients(0);
        }
        
        boolean success = doctorService.updateSchedule(schedule).startsWith("SUCCESS");
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin?action=schedules&msg=updateSuccess");
        } else {
            request.setAttribute("error", "更新排班失败");
            request.setAttribute("schedule", schedule);
            List<Doctor> doctors = doctorService.findAll();
            request.setAttribute("doctors", doctors);
            request.getRequestDispatcher("/admin/schedule_form.jsp").forward(request, response);
        }
    }
    
    /**
     * 删除排班
     */
    private void deleteSchedule(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        String scheduleIdStr = request.getParameter("id");
        if (scheduleIdStr == null || scheduleIdStr.isEmpty()) {
            result.put("success", false);
            result.put("message", "缺少排班ID");
            out.print(gson.toJson(result));
            out.flush();
            return;
        }
        
        boolean success = doctorService.deleteSchedule(Integer.parseInt(scheduleIdStr));
        result.put("success", success);
        result.put("message", success ? "删除成功" : "删除失败，可能有关联的预约");
        
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * 批量生成排班
     */
    private void generateSchedules(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        String doctorId = request.getParameter("doctorId");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String[] timeSlots = request.getParameterValues("timeSlots");
        String maxPatientsStr = request.getParameter("maxPatients");
        
        if (doctorId == null || startDateStr == null || endDateStr == null || timeSlots == null) {
            result.put("success", false);
            result.put("message", "参数不完整");
            out.print(gson.toJson(result));
            out.flush();
            return;
        }
        
        int maxPatients = maxPatientsStr != null ? Integer.parseInt(maxPatientsStr) : 30;
        java.sql.Date startDate = java.sql.Date.valueOf(startDateStr);
        java.sql.Date endDate = java.sql.Date.valueOf(endDateStr);
        
        int count = doctorService.generateSchedules(doctorId, startDate, endDate, 
                Arrays.asList(timeSlots), maxPatients);
        
        result.put("success", count > 0);
        result.put("message", count > 0 ? "成功生成 " + count + " 条排班记录" : "生成排班失败");
        result.put("count", count);
        
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * 导入医生数据
     */
    private void importDoctors(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Map<String, Object> result = new HashMap<>();
        boolean success = false;
        String message = "";
        
        try {
            if (request.getContentType() == null || !request.getContentType().toLowerCase().startsWith("multipart/")) {
                message = "请选择文件上传";
            } else {
                boolean fileFound = false;
                for (Part part : request.getParts()) {
                    String fileName = part.getSubmittedFileName();
                    if (fileName != null && (fileName.endsWith(".xls") || fileName.endsWith(".xlsx"))) {
                        InputStream is = part.getInputStream();
                        result = doctorService.importFromExcel(is);
                        is.close();
                        fileFound = true;
                        break;
                    }
                }

                
                if (!fileFound) {
                    message = "请选择正确的Excel文件(.xls, .xlsx)";
                } else {
                    success = (Boolean) result.get("success");
                    message = (String) result.get("message");
                }
            }
        } catch (Exception e) {
            message = "导入失败: " + e.getMessage();
            e.printStackTrace();
        }
        
        request.setAttribute("success", success);
        request.setAttribute("message", message);
        showImportPage(request, response);
    }
    
    /**
     * 导入排班数据
     */
    private void importSchedules(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Map<String, Object> result = new HashMap<>();
        boolean success = false;
        String message = "";
        
        try {
            if (request.getContentType() == null || !request.getContentType().toLowerCase().startsWith("multipart/")) {
                message = "请选择文件上传";
            } else {
                boolean fileFound = false;
                for (Part part : request.getParts()) {
                    String fileName = part.getSubmittedFileName();
                    if (fileName != null && (fileName.endsWith(".xls") || fileName.endsWith(".xlsx"))) {
                        InputStream is = part.getInputStream();
                        result = doctorService.importSchedulesFromExcel(is);
                        is.close();
                        fileFound = true;
                        break;
                    }
                }
                
                if (!fileFound) {
                    message = "请选择正确的Excel文件(.xls, .xlsx)";
                } else {
                    success = (Boolean) result.get("success");
                    message = (String) result.get("message");
                }
            }
        } catch (Exception e) {
            message = "导入失败: " + e.getMessage();
            e.printStackTrace();
        }
        
        request.setAttribute("success", success);
        request.setAttribute("message", message);
        showImportPage(request, response);
    }
}
