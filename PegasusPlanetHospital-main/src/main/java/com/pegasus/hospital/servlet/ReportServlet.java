package com.pegasus.hospital.servlet;

import com.pegasus.hospital.service.AppointmentService;
import com.pegasus.hospital.service.DepartmentService;
import com.pegasus.hospital.service.DoctorService;
import com.pegasus.hospital.service.PatientService;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 报表Servlet
 * 处理PDF报表生成请求
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class ReportServlet extends HttpServlet {
    
    private AppointmentService appointmentService = new AppointmentService();
    private DepartmentService departmentService = new DepartmentService();
    private DoctorService doctorService = new DoctorService();
    private PatientService patientService = new PatientService();
    
    // 中文字体
    private BaseFont bfChinese;
    
    @Override
    public void init() throws ServletException {
        try {
            // 使用iText-Asian中的中文字体
            bfChinese = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
        } catch (Exception e) {
            throw new ServletException("初始化中文字体失败", e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 验证管理员权限
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "需要管理员权限");
            return;
        }
        
        String type = request.getParameter("type");
        if (type == null) {
            type = "monthly";
        }
        
        switch (type) {
            case "monthly":
                generateMonthlyReport(request, response);
                break;
            case "department":
                generateDepartmentReport(request, response);
                break;
            case "doctor":
                generateDoctorReport(request, response);
                break;
            default:
                generateMonthlyReport(request, response);
        }
    }
    
    /**
     * 生成月度统计报表
     */
    private void generateMonthlyReport(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // 获取月份参数
        String monthStr = request.getParameter("month");
        String month;
        if (monthStr != null && !monthStr.isEmpty()) {
            month = monthStr;
        } else {
            Calendar cal = Calendar.getInstance();
            month = String.format("%d-%02d", cal.get(Calendar.YEAR), cal.get(Calendar.MONTH) + 1);
        }
        
        try {
            // 创建文档
            Document document = new Document(PageSize.A4);
            
            // 设置响应头
            response.setContentType("application/pdf");
            String fileName = "月度统计报表_" + month + ".pdf";
            response.setHeader("Content-Disposition", "attachment;filename=" + 
                    new String(fileName.getBytes("UTF-8"), "ISO-8859-1"));
            
            OutputStream out = response.getOutputStream();
            PdfWriter writer = PdfWriter.getInstance(document, out);
            
            document.open();
            
            // 字体定义
            Font titleFont = new Font(bfChinese, 20, Font.BOLD, BaseColor.DARK_GRAY);
            Font subtitleFont = new Font(bfChinese, 14, Font.BOLD, BaseColor.DARK_GRAY);
            Font headerFont = new Font(bfChinese, 11, Font.BOLD, BaseColor.WHITE);
            Font normalFont = new Font(bfChinese, 10, Font.NORMAL);
            Font smallFont = new Font(bfChinese, 9, Font.NORMAL, BaseColor.GRAY);
            
            // 标题
            Paragraph title = new Paragraph("飞马星球医院", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);
            
            Paragraph subtitle = new Paragraph("月度预约统计报表 (" + month + ")", subtitleFont);
            subtitle.setAlignment(Element.ALIGN_CENTER);
            subtitle.setSpacingBefore(10);
            subtitle.setSpacingAfter(20);
            document.add(subtitle);
            
            // 生成时间
            Paragraph genTime = new Paragraph("生成时间: " + 
                    new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()), smallFont);
            genTime.setAlignment(Element.ALIGN_RIGHT);
            genTime.setSpacingAfter(20);
            document.add(genTime);
            
            // 总体统计
            document.add(new Paragraph("一、总体统计", subtitleFont));
            document.add(Chunk.NEWLINE);
            
            Map<String, Object> monthlyStats = appointmentService.getMonthlyStats(month);
            PdfPTable summaryTable = new PdfPTable(4);
            summaryTable.setWidthPercentage(100);
            
            addTableHeader(summaryTable, new String[]{"总预约数", "已完成", "已取消", "完成率"}, headerFont);
            
            int total = (int) monthlyStats.getOrDefault("total", 0);
            int completed = (int) monthlyStats.getOrDefault("completed", 0);
            int cancelled = (int) monthlyStats.getOrDefault("cancelled", 0);
            double rate = total > 0 ? (completed * 100.0 / total) : 0;
            
            addTableRow(summaryTable, new String[]{
                    String.valueOf(total),
                    String.valueOf(completed),
                    String.valueOf(cancelled),
                    String.format("%.1f%%", rate)
            }, normalFont);
            
            document.add(summaryTable);
            document.add(Chunk.NEWLINE);
            
            // 科室统计
            document.add(new Paragraph("二、科室预约统计", subtitleFont));
            document.add(Chunk.NEWLINE);
            
            Map<String, Object> deptStats = appointmentService.getStatsByDepartment(month);
            @SuppressWarnings("unchecked")
            java.util.List<Map<String, Object>> deptList = (java.util.List<Map<String, Object>>) deptStats.get("data");
            
            if (deptList != null && !deptList.isEmpty()) {
                PdfPTable deptTable = new PdfPTable(4);
                deptTable.setWidthPercentage(100);
                
                addTableHeader(deptTable, new String[]{"科室名称", "预约数量", "已完成", "占比"}, headerFont);
                
                for (Map<String, Object> dept : deptList) {
                    int deptTotal = ((Number) dept.getOrDefault("total", 0)).intValue();
                    int deptCompleted = ((Number) dept.getOrDefault("completed", 0)).intValue();
                    double deptRate = total > 0 ? (deptTotal * 100.0 / total) : 0;
                    
                    addTableRow(deptTable, new String[]{
                            (String) dept.get("deptName"),
                            String.valueOf(deptTotal),
                            String.valueOf(deptCompleted),
                            String.format("%.1f%%", deptRate)
                    }, normalFont);
                }
                
                document.add(deptTable);
            }
            document.add(Chunk.NEWLINE);
            
            // 医生统计
            document.add(new Paragraph("三、医生预约统计（Top 10）", subtitleFont));
            document.add(Chunk.NEWLINE);
            
            Map<String, Object> doctorStats = appointmentService.getStatsByDoctor(month);
            @SuppressWarnings("unchecked")
            java.util.List<Map<String, Object>> doctorList = (java.util.List<Map<String, Object>>) doctorStats.get("data");
            
            if (doctorList != null && !doctorList.isEmpty()) {
                PdfPTable doctorTable = new PdfPTable(5);
                doctorTable.setWidthPercentage(100);
                
                addTableHeader(doctorTable, new String[]{"排名", "医生姓名", "科室", "预约数量", "已完成"}, headerFont);
                
                int rank = 1;
                for (Map<String, Object> doctor : doctorList) {
                    if (rank > 10) break;
                    
                    addTableRow(doctorTable, new String[]{
                            String.valueOf(rank++),
                            (String) doctor.get("doctorName"),
                            (String) doctor.get("deptName"),
                            String.valueOf(((Number) doctor.getOrDefault("total", 0)).intValue()),
                            String.valueOf(((Number) doctor.getOrDefault("completed", 0)).intValue())
                    }, normalFont);
                }
                
                document.add(doctorTable);
            }
            document.add(Chunk.NEWLINE);
            
            // 每日统计
            document.add(new Paragraph("四、每日预约趋势", subtitleFont));
            document.add(Chunk.NEWLINE);
            
            Map<String, Integer> dailyStats = appointmentService.getDailyStats(month);
            if (dailyStats != null && !dailyStats.isEmpty()) {
                PdfPTable dailyTable = new PdfPTable(7);
                dailyTable.setWidthPercentage(100);
                
                // 按周显示
                java.util.List<String> sortedDates = new ArrayList<>(dailyStats.keySet());
                Collections.sort(sortedDates);
                
                // 简化显示：显示日期和数量
                addTableHeader(dailyTable, new String[]{"日期", "数量", "日期", "数量", "日期", "数量", "日期/数量"}, headerFont);
                
                int col = 0;
                String[] rowData = new String[7];
                Arrays.fill(rowData, "");
                
                for (String date : sortedDates) {
                    if (col < 6) {
                        rowData[col] = date.substring(8); // 只显示日
                        rowData[col + 1] = String.valueOf(dailyStats.get(date));
                        col += 2;
                    }
                    if (col >= 6) {
                        rowData[6] = date.substring(8) + "/" + dailyStats.get(date);
                        addTableRow(dailyTable, rowData, normalFont);
                        col = 0;
                        Arrays.fill(rowData, "");
                    }
                }
                
                if (col > 0) {
                    addTableRow(dailyTable, rowData, normalFont);
                }
                
                document.add(dailyTable);
            }
            
            // 页脚
            document.add(Chunk.NEWLINE);
            document.add(Chunk.NEWLINE);
            Paragraph footer = new Paragraph("— 飞马星球医院信息管理系统 —", smallFont);
            footer.setAlignment(Element.ALIGN_CENTER);
            document.add(footer);
            
            document.close();
            out.flush();
            
        } catch (DocumentException e) {
            throw new IOException("生成PDF失败: " + e.getMessage(), e);
        }
    }
    
    /**
     * 生成科室报表
     */
    private void generateDepartmentReport(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String deptIdStr = request.getParameter("deptId");
        String month = request.getParameter("month");
        
        if (month == null || month.isEmpty()) {
            Calendar cal = Calendar.getInstance();
            month = String.format("%d-%02d", cal.get(Calendar.YEAR), cal.get(Calendar.MONTH) + 1);
        }
        
        try {
            Document document = new Document(PageSize.A4);
            
            response.setContentType("application/pdf");
            String fileName = "科室报表_" + month + ".pdf";
            response.setHeader("Content-Disposition", "attachment;filename=" + 
                    new String(fileName.getBytes("UTF-8"), "ISO-8859-1"));
            
            OutputStream out = response.getOutputStream();
            PdfWriter.getInstance(document, out);
            
            document.open();
            
            Font titleFont = new Font(bfChinese, 18, Font.BOLD);
            Font subtitleFont = new Font(bfChinese, 12, Font.BOLD);
            Font headerFont = new Font(bfChinese, 10, Font.BOLD, BaseColor.WHITE);
            Font normalFont = new Font(bfChinese, 9, Font.NORMAL);
            
            Paragraph title = new Paragraph("飞马星球医院 - 科室预约报表", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);
            
            // 获取科室统计数据
            Map<String, Object> deptStats = appointmentService.getStatsByDepartment(month);
            @SuppressWarnings("unchecked")
            java.util.List<Map<String, Object>> deptList = (java.util.List<Map<String, Object>>) deptStats.get("data");
            
            if (deptList != null) {
                document.add(new Paragraph("统计月份: " + month, subtitleFont));
                document.add(Chunk.NEWLINE);
                
                PdfPTable table = new PdfPTable(5);
                table.setWidthPercentage(100);
                
                addTableHeader(table, new String[]{"科室名称", "总预约", "已完成", "已取消", "完成率"}, headerFont);
                
                for (Map<String, Object> dept : deptList) {
                    int total = ((Number) dept.getOrDefault("total", 0)).intValue();
                    int completed = ((Number) dept.getOrDefault("completed", 0)).intValue();
                    int cancelled = ((Number) dept.getOrDefault("cancelled", 0)).intValue();
                    double rate = total > 0 ? (completed * 100.0 / total) : 0;
                    
                    addTableRow(table, new String[]{
                            (String) dept.get("deptName"),
                            String.valueOf(total),
                            String.valueOf(completed),
                            String.valueOf(cancelled),
                            String.format("%.1f%%", rate)
                    }, normalFont);
                }
                
                document.add(table);
            }
            
            document.close();
            out.flush();
            
        } catch (DocumentException e) {
            throw new IOException("生成PDF失败: " + e.getMessage(), e);
        }
    }
    
    /**
     * 生成医生报表
     */
    private void generateDoctorReport(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String month = request.getParameter("month");
        
        if (month == null || month.isEmpty()) {
            Calendar cal = Calendar.getInstance();
            month = String.format("%d-%02d", cal.get(Calendar.YEAR), cal.get(Calendar.MONTH) + 1);
        }
        
        try {
            Document document = new Document(PageSize.A4);
            
            response.setContentType("application/pdf");
            String fileName = "医生工作量报表_" + month + ".pdf";
            response.setHeader("Content-Disposition", "attachment;filename=" + 
                    new String(fileName.getBytes("UTF-8"), "ISO-8859-1"));
            
            OutputStream out = response.getOutputStream();
            PdfWriter.getInstance(document, out);
            
            document.open();
            
            Font titleFont = new Font(bfChinese, 18, Font.BOLD);
            Font subtitleFont = new Font(bfChinese, 12, Font.BOLD);
            Font headerFont = new Font(bfChinese, 10, Font.BOLD, BaseColor.WHITE);
            Font normalFont = new Font(bfChinese, 9, Font.NORMAL);
            
            Paragraph title = new Paragraph("飞马星球医院 - 医生工作量报表", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);
            
            document.add(new Paragraph("统计月份: " + month, subtitleFont));
            document.add(Chunk.NEWLINE);
            
            // 获取医生统计数据
            Map<String, Object> doctorStats = appointmentService.getStatsByDoctor(month);
            @SuppressWarnings("unchecked")
            java.util.List<Map<String, Object>> doctorList = (java.util.List<Map<String, Object>>) doctorStats.get("data");
            
            if (doctorList != null) {
                PdfPTable table = new PdfPTable(6);
                table.setWidthPercentage(100);
                
                addTableHeader(table, new String[]{"排名", "医生", "科室", "总预约", "已完成", "完成率"}, headerFont);
                
                int rank = 1;
                for (Map<String, Object> doctor : doctorList) {
                    int total = ((Number) doctor.getOrDefault("total", 0)).intValue();
                    int completed = ((Number) doctor.getOrDefault("completed", 0)).intValue();
                    double rate = total > 0 ? (completed * 100.0 / total) : 0;
                    
                    addTableRow(table, new String[]{
                            String.valueOf(rank++),
                            (String) doctor.get("doctorName"),
                            (String) doctor.get("deptName"),
                            String.valueOf(total),
                            String.valueOf(completed),
                            String.format("%.1f%%", rate)
                    }, normalFont);
                }
                
                document.add(table);
            }
            
            document.close();
            out.flush();
            
        } catch (DocumentException e) {
            throw new IOException("生成PDF失败: " + e.getMessage(), e);
        }
    }
    
    /**
     * 添加表格标题行
     */
    private void addTableHeader(PdfPTable table, String[] headers, Font font) {
        for (String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header, font));
            cell.setBackgroundColor(new BaseColor(51, 122, 183));
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setPadding(8);
            table.addCell(cell);
        }
    }
    
    /**
     * 添加表格数据行
     */
    private void addTableRow(PdfPTable table, String[] values, Font font) {
        for (String value : values) {
            PdfPCell cell = new PdfPCell(new Phrase(value != null ? value : "", font));
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setPadding(6);
            table.addCell(cell);
        }
    }
}
