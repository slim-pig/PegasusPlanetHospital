package com.pegasus.hospital.service;

import com.pegasus.hospital.dao.DepartmentDAO;
import com.pegasus.hospital.dao.DoctorDAO;
import com.pegasus.hospital.dao.ScheduleDAO;
import com.pegasus.hospital.entity.Doctor;
import com.pegasus.hospital.entity.Schedule;
import com.pegasus.hospital.util.CommonUtil;
import com.pegasus.hospital.util.DBUtil;
import org.apache.poi.ss.usermodel.*;
import java.io.InputStream;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 医生服务类
 * 处理医生相关的业务逻辑
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class DoctorService {
    
    private DoctorDAO doctorDAO = new DoctorDAO();
    private ScheduleDAO scheduleDAO = new ScheduleDAO();
    private DepartmentDAO departmentDAO = new DepartmentDAO();
    
    /**
     * 添加医生
     * 
     * @param doctor 医生对象
     * @return 操作结果
     */
    public String addDoctor(Doctor doctor) {
        try {
            // 验证姓名
            if (CommonUtil.isEmpty(doctor.getName()) || doctor.getName().length() > 20) {
                return "姓名不能为空且不能超过20个字符";
            }
            
            // 验证密码
            if (!CommonUtil.isValidPassword(doctor.getPassword())) {
                return "密码不能少于4位";
            }
            
            // 验证科室
            if (doctor.getDeptId() == null || departmentDAO.findById(doctor.getDeptId()) == null) {
                return "请选择有效的科室";
            }
            
            // 验证专长描述
            if (doctor.getSpecialty() != null && doctor.getSpecialty().length() > 200) {
                return "专长描述不能超过200个字符";
            }
            
            // 生成医生ID或使用指定的ID
            String doctorId = doctor.getDoctorId();
            if (CommonUtil.isEmpty(doctorId)) {
                do {
                    doctorId = CommonUtil.generateDoctorId();
                } while (doctorDAO.exists(doctorId));
                doctor.setDoctorId(doctorId);
            } else {
                // 验证医生ID格式
                if (!CommonUtil.isValidDoctorId(doctorId)) {
                    return "医生ID格式不正确（应为8位数字）";
                }
                // 检查ID是否已存在
                if (doctorDAO.exists(doctorId)) {
                    return "该医生ID已存在";
                }
            }
            
            // 加密密码
            doctor.setPassword(CommonUtil.md5(doctor.getPassword()));
            doctor.setStatus(1);
            
            int result = doctorDAO.insert(doctor);
            if (result > 0) {
                return "SUCCESS:" + doctorId;
            } else {
                return "添加失败，请稍后重试";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "系统错误：" + e.getMessage();
        }
    }
    
    /**
     * 批量添加医生
     * 
     * @param doctors 医生列表
     * @return 操作结果（成功数量/总数量）
     */
    public String batchAddDoctors(List<Doctor> doctors) {
        int successCount = 0;
        int totalCount = doctors.size();
        StringBuilder errors = new StringBuilder();
        
        for (Doctor doctor : doctors) {
            String result = addDoctor(doctor);
            if (result.startsWith("SUCCESS")) {
                successCount++;
            } else {
                errors.append(doctor.getName()).append(": ").append(result).append("\n");
            }
        }
        
        if (successCount == totalCount) {
            return "SUCCESS:全部导入成功，共" + successCount + "条记录";
        } else {
            return "部分导入成功：" + successCount + "/" + totalCount + "\n失败记录：\n" + errors.toString();
        }
    }
    
    /**
     * 更新医生信息
     * 
     * @param doctor 医生对象
     * @return 操作结果
     */
    public String updateDoctor(Doctor doctor) {
        try {
            // 验证姓名
            if (CommonUtil.isEmpty(doctor.getName()) || doctor.getName().length() > 20) {
                return "姓名不能为空且不能超过20个字符";
            }
            
            // 验证科室
            if (doctor.getDeptId() == null) {
                return "请选择科室";
            }
            
            // 验证专长描述
            if (doctor.getSpecialty() != null && doctor.getSpecialty().length() > 200) {
                return "专长描述不能超过200个字符";
            }
            
            int result = doctorDAO.update(doctor);
            if (result > 0) {
                return "SUCCESS";
            } else {
                return "修改失败，请稍后重试";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "系统错误：" + e.getMessage();
        }
    }
    
    /**
     * 删除医生
     * 
     * @param doctorId 医生ID
     * @return 操作结果
     */
    public boolean deleteDoctor(String doctorId) {
        try {
            return doctorDAO.delete(doctorId) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 根据ID查询医生
     * 
     * @param doctorId 医生ID
     * @return 医生对象
     */
    public Doctor findById(String doctorId) {
        try {
            return doctorDAO.findById(doctorId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 根据科室查询医生
     * 
     * @param deptId 科室ID
     * @return 医生列表
     */
    public List<Doctor> findByDeptId(Integer deptId) {
        try {
            return doctorDAO.findByDeptId(deptId);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * 查询所有医生
     * 
     * @return 医生列表
     */
    public List<Doctor> findAll() {
        try {
            return doctorDAO.findAll();
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * 查询所有医生（包括离职）
     * 
     * @return 医生列表
     */
    public List<Doctor> findAllIncludeInactive() {
        try {
            return doctorDAO.findAllIncludeInactive();
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * 分页查询医生
     * 
     * @param page 页码
     * @param pageSize 每页数量
     * @return 医生列表
     */
    public List<Doctor> findByPage(int page, int pageSize) {
        try {
            return doctorDAO.findByPage(page, pageSize);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * 统计医生总数
     * 
     * @return 医生总数
     */
    public int count() {
        try {
            return doctorDAO.count();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
    
    /**
     * 添加排班
     * 
     * @param schedule 排班对象
     * @return 操作结果
     */
    public String addSchedule(Schedule schedule) {
        try {
            // 验证医生
            if (CommonUtil.isEmpty(schedule.getDoctorId())) {
                return "请选择医生";
            }
            
            // 验证日期
            if (schedule.getScheduleDate() == null) {
                return "请选择排班日期";
            }
            
            // 验证时间段
            if (CommonUtil.isEmpty(schedule.getTimeSlot())) {
                return "请选择时间段";
            }
            
            // 检查是否已存在相同排班
            if (scheduleDAO.exists(schedule.getDoctorId(), schedule.getScheduleDate(), schedule.getTimeSlot())) {
                return "该时间段已有排班";
            }
            
            schedule.setMaxPatients(schedule.getMaxPatients() != null ? schedule.getMaxPatients() : 5);
            schedule.setCurrentPatients(0);
            schedule.setStatus(1);
            
            int scheduleId = scheduleDAO.insert(schedule);
            if (scheduleId > 0) {
                return "SUCCESS:" + scheduleId;
            } else {
                return "添加排班失败";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "系统错误：" + e.getMessage();
        }
    }
    
    /**
     * 批量添加排班
     * 
     * @param schedules 排班列表
     * @return 操作结果
     */
    public String batchAddSchedules(List<Schedule> schedules) {
        try {
            // 过滤已存在的排班
            List<Schedule> newSchedules = new ArrayList<>();
            for (Schedule schedule : schedules) {
                if (!scheduleDAO.exists(schedule.getDoctorId(), schedule.getScheduleDate(), schedule.getTimeSlot())) {
                    schedule.setMaxPatients(schedule.getMaxPatients() != null ? schedule.getMaxPatients() : 5);
                    schedule.setCurrentPatients(0);
                    schedule.setStatus(1);
                    newSchedules.add(schedule);
                }
            }
            
            if (newSchedules.isEmpty()) {
                return "没有新的排班需要添加";
            }
            
            int count = scheduleDAO.batchInsert(newSchedules);
            return "SUCCESS:成功添加" + count + "条排班记录";
        } catch (SQLException e) {
            e.printStackTrace();
            return "系统错误：" + e.getMessage();
        }
    }
    
    /**
     * 为医生生成未来N天的排班
     * 
     * @param doctorId 医生ID
     * @param days 天数
     * @return 生成的排班数量
     */
    public int generateSchedules(String doctorId, int days) {
        try {
            List<Schedule> schedules = new ArrayList<>();
            Calendar cal = Calendar.getInstance();
            
            // 时间段
            String[] timeSlots = {
                "08:00-08:30", "08:30-09:00", "09:00-09:30", "09:30-10:00", "10:00-10:30", "10:30-11:00",
                "14:00-14:30", "14:30-15:00", "15:00-15:30", "15:30-16:00", "16:00-16:30", "16:30-17:00"
            };
            
            for (int i = 0; i < days; i++) {
                Date date = cal.getTime();
                int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
                
                // 只在工作日排班（周一到周五）
                if (dayOfWeek != Calendar.SATURDAY && dayOfWeek != Calendar.SUNDAY) {
                    for (String timeSlot : timeSlots) {
                        if (!scheduleDAO.exists(doctorId, date, timeSlot)) {
                            Schedule schedule = new Schedule(doctorId, date, timeSlot, 5);
                            schedules.add(schedule);
                        }
                    }
                }
                
                cal.add(Calendar.DAY_OF_MONTH, 1);
            }
            
            if (schedules.isEmpty()) {
                return 0;
            }
            
            return scheduleDAO.batchInsert(schedules);
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
    
    /**
     * 查询医生某日期的排班
     * 
     * @param doctorId 医生ID
     * @param date 日期
     * @return 排班列表
     */
    public List<Schedule> findSchedulesByDoctorAndDate(String doctorId, Date date) {
        try {
            return scheduleDAO.findByDoctorAndDate(doctorId, date);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * 查询医生日期范围内的排班
     * 
     * @param doctorId 医生ID
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 排班列表
     */
    public List<Schedule> findSchedulesByDoctorAndDateRange(String doctorId, Date startDate, Date endDate) {
        try {
            return scheduleDAO.findByDoctorAndDateRange(doctorId, startDate, endDate);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * 查询医生某日期可预约的排班
     * 
     * @param doctorId 医生ID
     * @param date 日期
     * @return 排班列表
     */
    public List<Schedule> findAvailableSchedules(String doctorId, Date date) {
        try {
            return scheduleDAO.findAvailableByDoctorAndDate(doctorId, date);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * 查询医生所有可预约的排班（未来）
     * 
     * @param doctorId 医生ID
     * @return 排班列表
     */
    public List<Schedule> findAvailableSchedules(String doctorId) {
        try {
            return scheduleDAO.findAvailableByDoctor(doctorId);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * 查询所有排班
     * 
     * @return 排班列表
     */
    public List<Schedule> findAllSchedules() {
        try {
            return scheduleDAO.findAll();
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * 根据ID查询排班
     * 
     * @param scheduleId 排班ID
     * @return 排班对象
     */
    public Schedule findScheduleById(Integer scheduleId) {
        try {
            return scheduleDAO.findById(scheduleId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 删除排班（只能删除没有预约的排班）
     * 
     * @param scheduleId 排班ID
     * @return 操作结果
     */
    public boolean deleteSchedule(Integer scheduleId) {
        try {
            return scheduleDAO.delete(scheduleId) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 统计医生总数
     * 
     * @return 数量
     */
    public int countAll() {
        try {
            return doctorDAO.count();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 根据科室查询医生
     * 
     * @param deptId 科室ID
     * @return 医生列表
     */
    public List<Doctor> findByDepartment(int deptId) {
        try {
            return doctorDAO.findByDepartmentId(deptId);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * 搜索医生
     * 
     * @param keyword 关键字
     * @return 医生列表
     */
    public List<Doctor> search(String keyword) {
        try {
            return doctorDAO.search(keyword);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * 查询医生的排班
     * 
     * @param doctorId 医生ID
     * @return 排班列表
     */
    public List<Schedule> findSchedulesByDoctor(String doctorId) {
        try {
            return scheduleDAO.findByDoctorId(doctorId);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * 更新排班
     * 
     * @param schedule 排班对象
     * @return 操作结果
     */
    public String updateSchedule(Schedule schedule) {
        try {
            int result = scheduleDAO.update(schedule);
            return result > 0 ? "SUCCESS" : "更新失败";
        } catch (SQLException e) {
            e.printStackTrace();
            return "系统错误：" + e.getMessage();
        }
    }

    /**
     * 批量生成排班
     * 
     * @param doctorId 医生ID
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @param timeSlots 时间段列表
     * @param maxAppointments 最大预约数
     * @return 生成的排班数量
     */
    public int generateSchedules(String doctorId, Date startDate, Date endDate, List<String> timeSlots, int maxAppointments) {
        int count = 0;
        Calendar cal = Calendar.getInstance();
        cal.setTime(startDate);
        while (!cal.getTime().after(endDate)) {
            Date currentDate = cal.getTime();
            for (String slot : timeSlots) {
                try {
                    if (!scheduleDAO.exists(doctorId, currentDate, slot)) {
                        Schedule s = new Schedule();
                        s.setDoctorId(doctorId);
                        s.setScheduleDate(currentDate);
                        s.setTimeSlot(slot);
                        s.setMaxPatients(maxAppointments);
                        s.setCurrentPatients(0);
                        s.setStatus(1); // Available
                        scheduleDAO.insert(s);
                        count++;
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            cal.add(Calendar.DAY_OF_MONTH, 1);
        }
        return count;
    }

    /**
     * 从Excel导入医生
     * 
     * @param inputStream 输入流
     * @return 操作结果
     */
    public java.util.Map<String, Object> importFromExcel(InputStream inputStream) {
        java.util.Map<String, Object> result = new HashMap<>();
        int successCount = 0;
        int failCount = 0;
        List<String> errors = new ArrayList<>();

        try (Workbook workbook = WorkbookFactory.create(inputStream)) {
            Sheet sheet = workbook.getSheetAt(0);
            for (Row row : sheet) {
                if (row.getRowNum() == 0) continue; // Skip header

                try {
                    Doctor doctor = new Doctor();
                    // Cell 0: Name
                    doctor.setName(getCellValue(row.getCell(0)));
                    // Cell 1: Gender
                    doctor.setGender(getCellValue(row.getCell(1)));
                    // Cell 2: DeptId
                    String deptIdStr = getCellValue(row.getCell(2));
                    if (deptIdStr != null && !deptIdStr.isEmpty()) {
                         try {
                             doctor.setDeptId((int) Double.parseDouble(deptIdStr));
                         } catch (NumberFormatException e) {
                             doctor.setDeptId(Integer.parseInt(deptIdStr));
                         }
                    }
                    // Cell 3: Title
                    doctor.setTitle(getCellValue(row.getCell(3)));
                    // Cell 4: Phone
                    doctor.setPhone(getCellValue(row.getCell(4)));
                    // Cell 5: Email
                    doctor.setEmail(getCellValue(row.getCell(5)));
                    // Cell 6: Specialty
                    doctor.setSpecialty(getCellValue(row.getCell(6)));
                    
                    // Default password
                    doctor.setPassword("123456");

                    String addResult = addDoctor(doctor);
                    if (addResult != null && addResult.startsWith("SUCCESS")) {
                        successCount++;
                    } else {
                        failCount++;
                        errors.add("Row " + (row.getRowNum() + 1) + ": " + addResult);
                    }
                } catch (Exception e) {
                    failCount++;
                    errors.add("Row " + (row.getRowNum() + 1) + ": " + e.getMessage());
                }
            }
            result.put("success", true);
            result.put("message", "导入完成。成功: " + successCount + ", 失败: " + failCount);
            result.put("errors", errors);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "导入失败: " + e.getMessage());
        }
        return result;
    }

    /**
     * 从Excel导入排班
     * 
     * @param inputStream 输入流
     * @return 操作结果
     */
    public java.util.Map<String, Object> importSchedulesFromExcel(InputStream inputStream) {
        java.util.Map<String, Object> result = new HashMap<>();
        int successCount = 0;
        int failCount = 0;
        List<String> errors = new ArrayList<>();

        try (Workbook workbook = WorkbookFactory.create(inputStream)) {
            Sheet sheet = workbook.getSheetAt(0);
            for (Row row : sheet) {
                if (row.getRowNum() == 0) continue; // Skip header

                try {
                    Schedule s = new Schedule();
                    
                    // Cell 0: DoctorID
                    String docId = getCellValue(row.getCell(0));
                    if (docId != null && docId.contains(".")) {
                        docId = String.valueOf((long) Double.parseDouble(docId));
                    }
                    s.setDoctorId(docId);

                    // Cell 1: Date
                    Cell dateCell = row.getCell(1);
                    if (dateCell != null) {
                        if (DateUtil.isCellDateFormatted(dateCell)) {
                            s.setScheduleDate(dateCell.getDateCellValue());
                        } else {
                             // Try parsing string if needed, or throw error
                             // Assuming format yyyy-MM-dd if string
                             // But for now let's rely on Excel date format
                        }
                    }

                    // Cell 2: TimeSlot
                    s.setTimeSlot(getCellValue(row.getCell(2)));

                    // Cell 3: MaxPatients
                    String maxP = getCellValue(row.getCell(3));
                    if (maxP != null) {
                         s.setMaxPatients((int) Double.parseDouble(maxP));
                    }
                    
                    s.setCurrentPatients(0);
                    s.setStatus(1);

                    if (!scheduleDAO.exists(s.getDoctorId(), s.getScheduleDate(), s.getTimeSlot())) {
                        scheduleDAO.insert(s);
                        successCount++;
                    } else {
                        failCount++;
                        errors.add("Row " + (row.getRowNum() + 1) + ": 排班已存在");
                    }
                } catch (Exception e) {
                    failCount++;
                    errors.add("Row " + (row.getRowNum() + 1) + ": " + e.getMessage());
                }
            }
            result.put("success", true);
            result.put("message", "导入完成。成功: " + successCount + ", 失败: " + failCount);
            result.put("errors", errors);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "导入失败: " + e.getMessage());
        }
        return result;
    }

    private String getCellValue(Cell cell) {
        if (cell == null) return "";
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue();
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    return cell.getDateCellValue().toString();
                } else {
                    return String.valueOf(cell.getNumericCellValue());
                }
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            case FORMULA:
                return cell.getCellFormula();
            default:
                return "";
        }
    }
}
