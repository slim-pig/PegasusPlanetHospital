package com.pegasus.hospital.service;

import com.pegasus.hospital.dao.AppointmentDAO;
import com.pegasus.hospital.dao.ScheduleDAO;
import com.pegasus.hospital.entity.Appointment;
import com.pegasus.hospital.entity.Schedule;
import com.pegasus.hospital.util.CommonUtil;
import com.pegasus.hospital.util.DBUtil;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 预约服务类
 * 处理预约挂号相关的业务逻辑
 * 使用同步锁机制处理并发预约
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class AppointmentService {
    
    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private ScheduleDAO scheduleDAO = new ScheduleDAO();
    
    /** 用于并发控制的锁对象 */
    private static final Object LOCK = new Object();
    
    /**
     * 预约挂号
     * 使用事务和乐观锁控制并发
     * 
     * @param patientId 患者ID
     * @param scheduleId 排班ID
     * @return 操作结果
     */
    public String makeAppointment(String patientId, Integer scheduleId) {
        // 使用同步锁防止并发问题
        synchronized (LOCK) {
            try {
                // 开启事务
                DBUtil.beginTransaction();
                
                // 查询排班信息
                Schedule schedule = scheduleDAO.findById(scheduleId);
                if (schedule == null) {
                    DBUtil.rollback();
                    return "排班信息不存在";
                }
                
                // 检查排班是否可预约
                if (!schedule.isAvailable()) {
                    DBUtil.rollback();
                    return "该时间段已满或已停诊";
                }
                
                // 检查预约日期是否有效（不能预约过去的日期）
                Date today = CommonUtil.getTodayStart();
                if (schedule.getScheduleDate().before(today)) {
                    DBUtil.rollback();
                    return "不能预约过去的日期";
                }
                
                // 检查患者在该时间段是否已有预约
                if (appointmentDAO.hasAppointment(patientId, schedule.getScheduleDate(), schedule.getTimeSlot())) {
                    DBUtil.rollback();
                    return "您在该时间段已有预约";
                }
                
                // 使用乐观锁更新排班的预约数
                int updateResult = scheduleDAO.incrementPatientCount(scheduleId);
                if (updateResult == 0) {
                    DBUtil.rollback();
                    return "预约失败，号源已满";
                }
                
                // 生成预约号
                String appointmentId;
                do {
                    appointmentId = CommonUtil.generateAppointmentId();
                } while (appointmentDAO.exists(appointmentId));
                
                // 创建预约记录
                Appointment appointment = new Appointment();
                appointment.setAppointmentId(appointmentId);
                appointment.setPatientId(patientId);
                appointment.setDoctorId(schedule.getDoctorId());
                appointment.setScheduleId(scheduleId);
                appointment.setAppointmentDate(schedule.getScheduleDate());
                appointment.setTimeSlot(schedule.getTimeSlot());
                appointment.setStatus(Appointment.STATUS_BOOKED);
                
                int insertResult = appointmentDAO.insert(appointment);
                if (insertResult > 0) {
                    DBUtil.commit();
                    return "SUCCESS:" + appointmentId;
                } else {
                    DBUtil.rollback();
                    return "预约失败，请稍后重试";
                }
            } catch (SQLException e) {
                DBUtil.rollback();
                e.printStackTrace();
                return "系统错误：" + e.getMessage();
            }
        }
    }
    
    /**
     * 取消预约
     * 
     * @param appointmentId 预约ID
     * @param patientId 患者ID（验证身份）
     * @param cancelReason 取消原因
     * @return 操作结果
     */
    public String cancelAppointment(String appointmentId, String patientId, String cancelReason) {
        synchronized (LOCK) {
            try {
                // 开启事务
                DBUtil.beginTransaction();
                
                // 查询预约信息
                Appointment appointment = appointmentDAO.findById(appointmentId);
                if (appointment == null) {
                    DBUtil.rollback();
                    return "预约信息不存在";
                }
                
                // 验证患者身份
                if (!appointment.getPatientId().equals(patientId)) {
                    DBUtil.rollback();
                    return "无权取消该预约";
                }
                
                // 检查预约状态
                if (!Appointment.STATUS_BOOKED.equals(appointment.getStatus())) {
                    DBUtil.rollback();
                    return "该预约已取消或已完成，不能再次取消";
                }
                
                // 检查是否可取消（预约时间未过）
                if (!appointment.isCancellable()) {
                    DBUtil.rollback();
                    return "预约时间已过，不能取消";
                }
                
                // 取消预约
                int cancelResult = appointmentDAO.cancel(appointmentId, cancelReason);
                if (cancelResult == 0) {
                    DBUtil.rollback();
                    return "取消失败，请稍后重试";
                }
                
                // 恢复排班的可预约数
                scheduleDAO.decrementPatientCount(appointment.getScheduleId());
                
                DBUtil.commit();
                return "SUCCESS";
            } catch (SQLException e) {
                DBUtil.rollback();
                e.printStackTrace();
                return "系统错误：" + e.getMessage();
            }
        }
    }
    
    /**
     * 取消预约（管理员强制取消）
     * 
     * @param appointmentId 预约ID
     * @param cancelReason 取消原因
     * @return 操作结果
     */
    public String cancelAppointmentByAdmin(String appointmentId, String cancelReason) {
        synchronized (LOCK) {
            try {
                // 开启事务
                DBUtil.beginTransaction();
                
                // 查询预约信息
                Appointment appointment = appointmentDAO.findById(appointmentId);
                if (appointment == null) {
                    DBUtil.rollback();
                    return "预约信息不存在";
                }
                
                // 检查预约状态
                if (!Appointment.STATUS_BOOKED.equals(appointment.getStatus())) {
                    DBUtil.rollback();
                    return "该预约已取消或已完成，不能再次取消";
                }
                
                // 取消预约
                int cancelResult = appointmentDAO.cancel(appointmentId, cancelReason);
                if (cancelResult == 0) {
                    DBUtil.rollback();
                    return "取消失败，请稍后重试";
                }
                
                // 恢复排班的可预约数
                scheduleDAO.decrementPatientCount(appointment.getScheduleId());
                
                DBUtil.commit();
                return "SUCCESS";
            } catch (SQLException e) {
                DBUtil.rollback();
                e.printStackTrace();
                return "系统错误：" + e.getMessage();
            }
        }
    }

    /**
     * 完成预约（由医院操作）
     * 
     * @param appointmentId 预约ID
     * @return 操作结果
     */
    public String completeAppointment(String appointmentId) {
        try {
            int result = appointmentDAO.complete(appointmentId);
            if (result > 0) {
                return "SUCCESS";
            } else {
                return "操作失败，预约可能已取消或已完成";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "系统错误：" + e.getMessage();
        }
    }
    
    /**
     * 根据ID查询预约
     * 
     * @param appointmentId 预约ID
     * @return 预约对象
     */
    public Appointment findById(String appointmentId) {
        try {
            return appointmentDAO.findById(appointmentId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 查询患者的预约记录
     * 
     * @param patientId 患者ID
     * @return 预约列表
     */
    public List<Appointment> findByPatientId(String patientId) {
        try {
            return appointmentDAO.findByPatientId(patientId);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * 查询医生的预约记录
     * 
     * @param doctorId 医生ID
     * @return 预约列表
     */
    public List<Appointment> findByDoctorId(String doctorId) {
        try {
            return appointmentDAO.findByDoctorId(doctorId);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * 查询所有预约
     * 
     * @return 预约列表
     */
    public List<Appointment> findAll() {
        try {
            return appointmentDAO.findAll();
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * 分页查询预约
     * 
     * @param page 页码
     * @param pageSize 每页数量
     * @return 预约列表
     */
    public List<Appointment> findByPage(int page, int pageSize) {
        try {
            return appointmentDAO.findByPage(page, pageSize);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * 查询日期范围内的预约
     * 
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 预约列表
     */
    public List<Appointment> findByDateRange(Date startDate, Date endDate) {
        try {
            return appointmentDAO.findByDateRange(startDate, endDate);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * 统计预约总数
     * 
     * @return 预约总数
     */
    public int count() {
        try {
            return appointmentDAO.count();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
    
    /**
     * 统计各科室预约量
     * 
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 科室预约统计
     */
    public List<Map<String, Object>> countByDepartment(Date startDate, Date endDate) {
        try {
            return appointmentDAO.countByDepartment(startDate, endDate);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * 统计医生工作量
     * 
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 医生工作量统计
     */
    public List<Map<String, Object>> countByDoctor(Date startDate, Date endDate) {
        try {
            return appointmentDAO.countByDoctor(startDate, endDate);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * 根据状态查询预约
     * 
     * @param status 状态
     * @return 预约列表
     */
    public List<Appointment> findAllByStatus(String status) {
        try {
            return appointmentDAO.findByStatus(status);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * 统计所有预约数量
     * 
     * @return 数量
     */
    public int countAll() {
        return count();
    }

    /**
     * 统计今日预约数量
     * 
     * @return 数量
     */
    public int countToday() {
        try {
            Date todayStart = CommonUtil.getTodayStart();
            Date todayEnd = CommonUtil.getTodayEnd();
            List<Appointment> list = appointmentDAO.findByDateRange(todayStart, todayEnd);
            return list.size();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 查询最近的预约
     * 
     * @param limit 数量
     * @return 预约列表
     */
    public List<Appointment> findRecent(int limit) {
        try {
            return appointmentDAO.findByPage(1, limit);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * 分页查询所有预约
     * 
     * @param page 页码
     * @param pageSize 每页数量
     * @return 预约列表
     */
    public List<Appointment> findAll(int page, int pageSize) {
        return findByPage(page, pageSize);
    }

    /**
     * 根据状态分页查询预约
     * 
     * @param status 状态
     * @param page 页码
     * @param pageSize 每页数量
     * @return 预约列表
     */
    public List<Appointment> findByStatus(String status, int page, int pageSize) {
        try {
            List<Appointment> all = appointmentDAO.findByStatus(status);
            int start = (page - 1) * pageSize;
            int end = Math.min(start + pageSize, all.size());
            if (start >= all.size()) {
                return new ArrayList<>();
            }
            return all.subList(start, end);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * 统计指定状态的预约数量
     * 
     * @param status 状态
     * @return 数量
     */
    public int countByStatus(String status) {
        try {
            List<Appointment> list = appointmentDAO.findByStatus(status);
            return list.size();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 获取月度统计数据
     * 
     * @param month 月份 (yyyy-MM)
     * @return 统计数据
     */
    public Map<String, Object> getMonthlyStats(String month) {
        try {
            Date[] dateRange = getMonthDateRange(month);
            if (dateRange == null) {
                return new java.util.HashMap<>();
            }
            return appointmentDAO.getStatsByDateRange(dateRange[0], dateRange[1]);
        } catch (SQLException e) {
            e.printStackTrace();
            return new java.util.HashMap<>();
        }
    }

    /**
     * 获取科室统计数据
     * 
     * @param month 月份 (yyyy-MM)
     * @return 统计数据
     */
    public Map<String, Object> getStatsByDepartment(String month) {
        Map<String, Object> result = new java.util.HashMap<>();
        try {
            Date[] dateRange = getMonthDateRange(month);
            if (dateRange == null) {
                result.put("data", new ArrayList<>());
                return result;
            }
            List<Map<String, Object>> list = appointmentDAO.countByDepartment(dateRange[0], dateRange[1]);
            result.put("data", list);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
            result.put("data", new ArrayList<>());
            return result;
        }
    }

    /**
     * 获取医生统计数据
     * 
     * @param month 月份 (yyyy-MM)
     * @return 统计数据
     */
    public Map<String, Object> getStatsByDoctor(String month) {
        Map<String, Object> result = new java.util.HashMap<>();
        try {
            Date[] dateRange = getMonthDateRange(month);
            if (dateRange == null) {
                result.put("data", new ArrayList<>());
                return result;
            }
            List<Map<String, Object>> list = appointmentDAO.countByDoctor(dateRange[0], dateRange[1]);
            result.put("data", list);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
            result.put("data", new ArrayList<>());
            return result;
        }
    }

    /**
     * 获取每日统计数据
     * 
     * @param month 月份 (yyyy-MM)
     * @return 日期->数量 Map
     */
    public Map<String, Integer> getDailyStats(String month) {
        try {
            Date[] dateRange = getMonthDateRange(month);
            if (dateRange == null) {
                return new java.util.HashMap<>();
            }
            return appointmentDAO.getDailyStatsByDateRange(dateRange[0], dateRange[1]);
        } catch (SQLException e) {
            e.printStackTrace();
            return new java.util.HashMap<>();
        }
    }

    /**
     * 解析月份字符串获取起止日期
     * 
     * @param monthStr 月份字符串 (yyyy-MM)
     * @return [开始日期, 结束日期]
     */
    private Date[] getMonthDateRange(String monthStr) {
        if (CommonUtil.isEmpty(monthStr)) {
            return null;
        }
        try {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM");
            Date date = sdf.parse(monthStr);
            
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.setTime(date);
            
            // 月初
            cal.set(java.util.Calendar.DAY_OF_MONTH, 1);
            cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
            cal.set(java.util.Calendar.MINUTE, 0);
            cal.set(java.util.Calendar.SECOND, 0);
            cal.set(java.util.Calendar.MILLISECOND, 0);
            Date startDate = cal.getTime();
            
            // 月末
            cal.set(java.util.Calendar.DAY_OF_MONTH, cal.getActualMaximum(java.util.Calendar.DAY_OF_MONTH));
            cal.set(java.util.Calendar.HOUR_OF_DAY, 23);
            cal.set(java.util.Calendar.MINUTE, 59);
            cal.set(java.util.Calendar.SECOND, 59);
            cal.set(java.util.Calendar.MILLISECOND, 999);
            Date endDate = cal.getTime();
            
            return new Date[]{startDate, endDate};
        } catch (java.text.ParseException e) {
            e.printStackTrace();
            return null;
        }
    }
}
