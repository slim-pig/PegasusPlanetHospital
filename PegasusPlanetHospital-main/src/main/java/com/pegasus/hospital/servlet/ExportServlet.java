package com.pegasus.hospital.servlet;

import com.pegasus.hospital.entity.Appointment;
import com.pegasus.hospital.entity.Patient;
import com.pegasus.hospital.service.AppointmentService;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 * 导出Servlet
 * 处理Excel导出请求
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class ExportServlet extends HttpServlet {
    
    private AppointmentService appointmentService = new AppointmentService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");
        if (type == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "缺少导出类型参数");
            return;
        }
        
        switch (type) {
            case "myAppointments":
                exportMyAppointments(request, response);
                break;
            case "allAppointments":
            case "all":
                exportAllAppointments(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "不支持的导出类型");
        }
    }
    
    /**
     * 导出当前患者的预约记录
     */
    private void exportMyAppointments(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        Patient patient = (Patient) session.getAttribute("patient");
        
        if (patient == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "请先登录");
            return;
        }
        
        List<Appointment> appointments = appointmentService.findByPatientId(patient.getPatientId());
        
        // 创建工作簿
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("我的预约记录");
        
        // 创建标题样式
        HSSFCellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFillForegroundColor(IndexedColors.ROYAL_BLUE.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setBorderBottom(BorderStyle.THIN);
        headerStyle.setBorderTop(BorderStyle.THIN);
        headerStyle.setBorderLeft(BorderStyle.THIN);
        headerStyle.setBorderRight(BorderStyle.THIN);
        
        HSSFFont headerFont = workbook.createFont();
        headerFont.setColor(IndexedColors.WHITE.getIndex());
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);
        
        // 创建数据样式
        HSSFCellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setAlignment(HorizontalAlignment.CENTER);
        dataStyle.setBorderBottom(BorderStyle.THIN);
        dataStyle.setBorderTop(BorderStyle.THIN);
        dataStyle.setBorderLeft(BorderStyle.THIN);
        dataStyle.setBorderRight(BorderStyle.THIN);
        
        // 创建标题行
        String[] headers = {"预约编号", "科室", "医生", "职称", "预约日期", "时间段", "状态", "预约时间"};
        HSSFRow headerRow = sheet.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            HSSFCell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
            sheet.setColumnWidth(i, 4000);
        }
        
        // 填充数据
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        
        int rowNum = 1;
        for (Appointment appointment : appointments) {
            HSSFRow row = sheet.createRow(rowNum++);
            
            createCell(row, 0, appointment.getAppointmentId(), dataStyle);
            createCell(row, 1, appointment.getDeptName(), dataStyle);
            createCell(row, 2, appointment.getDoctorName(), dataStyle);
            createCell(row, 3, appointment.getDoctorTitle(), dataStyle);
            createCell(row, 4, dateFormat.format(appointment.getAppointmentDate()), dataStyle);
            createCell(row, 5, getTimeSlotText(appointment.getTimeSlot()), dataStyle);
            createCell(row, 6, getStatusText(appointment.getStatus()), dataStyle);
            createCell(row, 7, dateTimeFormat.format(appointment.getCreateTime()), dataStyle);
        }
        
        // 设置响应头
        response.setContentType("application/vnd.ms-excel");
        String fileName = "我的预约记录_" + new SimpleDateFormat("yyyyMMdd").format(new java.util.Date()) + ".xls";
        response.setHeader("Content-Disposition", "attachment;filename=" + 
                new String(fileName.getBytes("UTF-8"), "ISO-8859-1"));
        
        // 写入响应
        OutputStream out = response.getOutputStream();
        workbook.write(out);
        out.flush();
        workbook.close();
    }
    
    /**
     * 导出所有预约记录（管理员）
     */
    private void exportAllAppointments(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "需要管理员权限");
            return;
        }
        
        String status = request.getParameter("status");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        
        List<Appointment> appointments;
        if (startDate != null && endDate != null && !startDate.isEmpty() && !endDate.isEmpty()) {
            appointments = appointmentService.findByDateRange(
                    java.sql.Date.valueOf(startDate), 
                    java.sql.Date.valueOf(endDate));
        } else if (status != null && !status.isEmpty()) {
            appointments = appointmentService.findAllByStatus(status);
        } else {
            appointments = appointmentService.findAll();
        }
        
        // 创建工作簿
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("预约记录");
        
        // 创建标题样式
        HSSFCellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFillForegroundColor(IndexedColors.ROYAL_BLUE.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setBorderBottom(BorderStyle.THIN);
        headerStyle.setBorderTop(BorderStyle.THIN);
        headerStyle.setBorderLeft(BorderStyle.THIN);
        headerStyle.setBorderRight(BorderStyle.THIN);
        
        HSSFFont headerFont = workbook.createFont();
        headerFont.setColor(IndexedColors.WHITE.getIndex());
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);
        
        // 创建数据样式
        HSSFCellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setAlignment(HorizontalAlignment.CENTER);
        dataStyle.setBorderBottom(BorderStyle.THIN);
        dataStyle.setBorderTop(BorderStyle.THIN);
        dataStyle.setBorderLeft(BorderStyle.THIN);
        dataStyle.setBorderRight(BorderStyle.THIN);
        
        // 创建标题行
        String[] headers = {"预约编号", "患者姓名", "患者电话", "科室", "医生", "职称", 
                "预约日期", "时间段", "状态", "预约时间", "取消原因"};
        HSSFRow headerRow = sheet.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            HSSFCell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
            sheet.setColumnWidth(i, 4000);
        }
        
        // 填充数据
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        
        int rowNum = 1;
        for (Appointment appointment : appointments) {
            HSSFRow row = sheet.createRow(rowNum++);
            
            createCell(row, 0, appointment.getAppointmentId(), dataStyle);
            createCell(row, 1, appointment.getPatientName(), dataStyle);
            createCell(row, 2, appointment.getPatientPhone(), dataStyle);
            createCell(row, 3, appointment.getDeptName(), dataStyle);
            createCell(row, 4, appointment.getDoctorName(), dataStyle);
            createCell(row, 5, appointment.getDoctorTitle(), dataStyle);
            createCell(row, 6, dateFormat.format(appointment.getAppointmentDate()), dataStyle);
            createCell(row, 7, getTimeSlotText(appointment.getTimeSlot()), dataStyle);
            createCell(row, 8, getStatusText(appointment.getStatus()), dataStyle);
            createCell(row, 9, dateTimeFormat.format(appointment.getCreateTime()), dataStyle);
            createCell(row, 10, appointment.getCancelReason() != null ? appointment.getCancelReason() : "", dataStyle);
        }
        
        // 设置响应头
        response.setContentType("application/vnd.ms-excel");
        String fileName = "预约记录_" + new SimpleDateFormat("yyyyMMdd").format(new java.util.Date()) + ".xls";
        response.setHeader("Content-Disposition", "attachment;filename=" + 
                new String(fileName.getBytes("UTF-8"), "ISO-8859-1"));
        
        // 写入响应
        OutputStream out = response.getOutputStream();
        workbook.write(out);
        out.flush();
        workbook.close();
    }
    
    /**
     * 创建单元格
     */
    private void createCell(HSSFRow row, int column, String value, HSSFCellStyle style) {
        HSSFCell cell = row.createCell(column);
        cell.setCellValue(value != null ? value : "");
        cell.setCellStyle(style);
    }
    
    /**
     * 获取时间段文本
     */
    private String getTimeSlotText(String timeSlot) {
        if (timeSlot == null) return "";
        switch (timeSlot) {
            case "MORNING": return "上午";
            case "AFTERNOON": return "下午";
            case "EVENING": return "晚上";
            default: return timeSlot;
        }
    }
    
    /**
     * 获取状态文本
     */
    private String getStatusText(String status) {
        if (status == null) return "";
        switch (status) {
            case "BOOKED": return "已预约";
            case "CANCELLED": return "已取消";
            case "COMPLETED": return "已完成";
            default: return status;
        }
    }
}
