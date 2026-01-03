package com.pegasus.hospital.entity;

import java.io.Serializable;
import java.util.Date;

/**
 * 预约记录实体类
 * 存储飞马星球医院的预约挂号记录
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class Appointment implements Serializable {
    private static final long serialVersionUID = 1L;
    
    /** 预约号：12位数字（唯一） */
    private String appointmentId;
    
    /** 患者ID */
    private String patientId;
    
    /** 医生ID */
    private String doctorId;
    
    /** 排班ID */
    private Integer scheduleId;
    
    /** 预约日期 */
    private Date appointmentDate;
    
    /** 预约时间段 */
    private String timeSlot;
    
    /** 状态：BOOKED-已预约, CANCELLED-已取消, COMPLETED-已完成 */
    private String status;
    
    /** 取消原因 */
    private String cancelReason;
    
    /** 创建时间 */
    private Date createTime;
    
    /** 更新时间 */
    private Date updateTime;
    
    // 关联查询字段
    /** 患者姓名 */
    private String patientName;
    
    /** 医生姓名 */
    private String doctorName;
    
    /** 医生职称 */
    private String doctorTitle;
    
    /** 科室名称 */
    private String deptName;
    
    /** 患者手机号 */
    private String patientPhone;
    
    // 状态常量
    public static final String STATUS_BOOKED = "BOOKED";
    public static final String STATUS_CANCELLED = "CANCELLED";
    public static final String STATUS_COMPLETED = "COMPLETED";
    
    // 默认构造函数
    public Appointment() {
    }
    
    // 带参构造函数
    public Appointment(String appointmentId, String patientId, String doctorId, 
                       Integer scheduleId, Date appointmentDate, String timeSlot) {
        this.appointmentId = appointmentId;
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.scheduleId = scheduleId;
        this.appointmentDate = appointmentDate;
        this.timeSlot = timeSlot;
        this.status = STATUS_BOOKED;
    }
    
    // Getter和Setter方法
    public String getAppointmentId() {
        return appointmentId;
    }
    
    public void setAppointmentId(String appointmentId) {
        this.appointmentId = appointmentId;
    }
    
    public String getPatientId() {
        return patientId;
    }
    
    public void setPatientId(String patientId) {
        this.patientId = patientId;
    }
    
    public String getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(String doctorId) {
        this.doctorId = doctorId;
    }
    
    public Integer getScheduleId() {
        return scheduleId;
    }
    
    public void setScheduleId(Integer scheduleId) {
        this.scheduleId = scheduleId;
    }
    
    public Date getAppointmentDate() {
        return appointmentDate;
    }
    
    public void setAppointmentDate(Date appointmentDate) {
        this.appointmentDate = appointmentDate;
    }
    
    public String getTimeSlot() {
        return timeSlot;
    }
    
    public void setTimeSlot(String timeSlot) {
        this.timeSlot = timeSlot;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getCancelReason() {
        return cancelReason;
    }
    
    public void setCancelReason(String cancelReason) {
        this.cancelReason = cancelReason;
    }
    
    public Date getCreateTime() {
        return createTime;
    }
    
    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
    
    public Date getUpdateTime() {
        return updateTime;
    }
    
    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }
    
    public String getPatientName() {
        return patientName;
    }
    
    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }
    
    public String getDoctorName() {
        return doctorName;
    }
    
    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }
    
    public String getDoctorTitle() {
        return doctorTitle;
    }
    
    public void setDoctorTitle(String doctorTitle) {
        this.doctorTitle = doctorTitle;
    }
    
    public String getDeptName() {
        return deptName;
    }
    
    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }
    
    public String getPatientPhone() {
        return patientPhone;
    }
    
    public void setPatientPhone(String patientPhone) {
        this.patientPhone = patientPhone;
    }
    
    /**
     * 获取状态显示文本
     * @return 已预约/已取消/已完成
     */
    public String getStatusText() {
        if (status == null) return "未知";
        switch (status) {
            case STATUS_BOOKED: return "已预约";
            case STATUS_CANCELLED: return "已取消";
            case STATUS_COMPLETED: return "已完成";
            default: return "未知";
        }
    }
    
    /**
     * 是否可取消预约
     * 只有已预约状态且预约时间未过才能取消
     * @return true-可取消, false-不可取消
     */
    public boolean isCancellable() {
        if (!STATUS_BOOKED.equals(status)) {
            return false;
        }
        // 检查预约时间是否已过
        if (appointmentDate == null) {
            return false;
        }
        Date now = new Date();
        return appointmentDate.after(now) || isSameDay(appointmentDate, now);
    }
    
    /**
     * 判断两个日期是否是同一天
     */
    private boolean isSameDay(Date date1, Date date2) {
        java.util.Calendar cal1 = java.util.Calendar.getInstance();
        java.util.Calendar cal2 = java.util.Calendar.getInstance();
        cal1.setTime(date1);
        cal2.setTime(date2);
        return cal1.get(java.util.Calendar.YEAR) == cal2.get(java.util.Calendar.YEAR) &&
               cal1.get(java.util.Calendar.DAY_OF_YEAR) == cal2.get(java.util.Calendar.DAY_OF_YEAR);
    }
    
    @Override
    public String toString() {
        return "Appointment{" +
                "appointmentId='" + appointmentId + '\'' +
                ", patientId='" + patientId + '\'' +
                ", doctorId='" + doctorId + '\'' +
                ", appointmentDate=" + appointmentDate +
                ", timeSlot='" + timeSlot + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
