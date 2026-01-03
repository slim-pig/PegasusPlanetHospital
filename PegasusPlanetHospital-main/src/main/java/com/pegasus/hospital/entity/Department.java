package com.pegasus.hospital.entity;

import java.io.Serializable;
import java.util.Date;

/**
 * 科室实体类
 * 存储飞马星球医院科室的基本信息
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class Department implements Serializable {
    private static final long serialVersionUID = 1L;
    
    /** 科室ID */
    private Integer deptId;
    
    /** 科室名称：最多30个字符 */
    private String deptName;
    
    /** 科室描述 */
    private String description;
    
    /** 科室位置 */
    private String location;
    
    /** 科室电话 */
    private String phone;
    
    /** 状态：1-正常, 0-停用 */
    private Integer status;
    
    /** 创建时间 */
    private Date createTime;
    
    /** 更新时间 */
    private Date updateTime;
    
    /** 医生数量（统计用） */
    private Integer doctorCount;
    
    // 默认构造函数
    public Department() {
    }
    
    // 带参构造函数
    public Department(String deptName, String description) {
        this.deptName = deptName;
        this.description = description;
        this.status = 1;
    }
    
    // Getter和Setter方法
    public Integer getDeptId() {
        return deptId;
    }
    
    public void setDeptId(Integer deptId) {
        this.deptId = deptId;
    }
    
    public String getDeptName() {
        return deptName;
    }
    
    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
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
    
    public Integer getDoctorCount() {
        return doctorCount;
    }
    
    public void setDoctorCount(Integer doctorCount) {
        this.doctorCount = doctorCount;
    }
    
    /**
     * 获取状态显示文本
     * @return 正常/停用
     */
    public String getStatusText() {
        return status != null && status == 1 ? "正常" : "停用";
    }
    
    @Override
    public String toString() {
        return "Department{" +
                "deptId=" + deptId +
                ", deptName='" + deptName + '\'' +
                ", description='" + description + '\'' +
                ", location='" + location + '\'' +
                ", status=" + status +
                '}';
    }
}
