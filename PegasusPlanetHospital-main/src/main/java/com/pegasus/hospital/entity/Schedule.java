package com.pegasus.hospital.entity;

import java.io.Serializable;
import java.util.Date;

/**
 * 医生排班实体类
 * 存储飞马星球医院医生的排班信息
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class Schedule implements Serializable {
    private static final long serialVersionUID = 1L;
    
    /** 排班ID */
    private Integer scheduleId;
    
    /** 医生ID */
    private String doctorId;
    
    /** 排班日期 */
    private Date scheduleDate;
    
    /** 时间段（如: 08:00-08:30） */
    private String timeSlot;
    
    /** 最大预约数 */
    private Integer maxPatients;
    
    /** 当前预约数 */
    private Integer currentPatients;
    
    /** 状态：1-可预约, 0-已满, -1-停诊 */
    private Integer status;
    
    /** 创建时间 */
    private Date createTime;
    
    /** 更新时间 */
    private Date updateTime;
    
    /** 医生姓名（关联查询用） */
    private String doctorName;
    
    /** 科室名称（关联查询用） */
    private String deptName;
    
    /** 医生职称（关联查询用） */
    private String doctorTitle;
    
    // 默认构造函数
    public Schedule() {
    }
    
    // 带参构造函数
    public Schedule(String doctorId, Date scheduleDate, String timeSlot, Integer maxPatients) {
        this.doctorId = doctorId;
        this.scheduleDate = scheduleDate;
        this.timeSlot = timeSlot;
        this.maxPatients = maxPatients;
        this.currentPatients = 0;
        this.status = 1;
    }
    
    // Getter和Setter方法
    public Integer getScheduleId() {
        return scheduleId;
    }
    
    public void setScheduleId(Integer scheduleId) {
        this.scheduleId = scheduleId;
    }
    
    public String getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(String doctorId) {
        this.doctorId = doctorId;
    }
    
    public Date getScheduleDate() {
        return scheduleDate;
    }
    
    public void setScheduleDate(Date scheduleDate) {
        this.scheduleDate = scheduleDate;
    }
    
    public String getTimeSlot() {
        return timeSlot;
    }
    
    public void setTimeSlot(String timeSlot) {
        this.timeSlot = timeSlot;
    }
    
    public Integer getMaxPatients() {
        return maxPatients;
    }
    
    public void setMaxPatients(Integer maxPatients) {
        this.maxPatients = maxPatients;
    }
    
    public Integer getCurrentPatients() {
        return currentPatients;
    }
    
    public void setCurrentPatients(Integer currentPatients) {
        this.currentPatients = currentPatients;
    }
    
    public Integer getStatus() {
        return status;
    }
    
    public void setStatus(Integer status) {
        this.status = status;
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
    
    public String getDoctorName() {
        return doctorName;
    }
    
    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }
    
    public String getDeptName() {
        return deptName;
    }
    
    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public String getDoctorTitle() {
        return doctorTitle;
    }

    public void setDoctorTitle(String doctorTitle) {
        this.doctorTitle = doctorTitle;
    }
    
    /**
     * 获取状态显示文本
     * @return 可预约/已满/停诊
     */
    public String getStatusText() {
        if (status == null) return "未知";
        switch (status) {
            case 1: return "可预约";
            case 0: return "已满";
            case -1: return "停诊";
            default: return "未知";
        }
    }
    
    /**
     * 获取剩余可预约数
     * @return 剩余号源数
     */
    public int getAvailableCount() {
        if (maxPatients == null || currentPatients == null) {
            return 0;
        }
        return maxPatients - currentPatients;
    }
    
    /**
     * 是否可预约
     * @return true-可预约, false-不可预约
     */
    public boolean isAvailable() {
        return status != null && status == 1 && getAvailableCount() > 0;
    }
    
    @Override
    public String toString() {
        return "Schedule{" +
                "scheduleId=" + scheduleId +
                ", doctorId='" + doctorId + '\'' +
                ", scheduleDate=" + scheduleDate +
                ", timeSlot='" + timeSlot + '\'' +
                ", maxPatients=" + maxPatients +
                ", currentPatients=" + currentPatients +
                ", status=" + status +
                '}';
    }
}
