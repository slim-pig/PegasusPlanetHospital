package com.pegasus.hospital.entity;

import java.io.Serializable;
import java.util.Date;

/**
 * 医生实体类
 * 存储飞马星球医院医生的基本信息
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class Doctor implements Serializable {
    private static final long serialVersionUID = 1L;
    
    /** 医生ID：8位数字组成 */
    private String doctorId;
    
    /** 姓名：最多20个字符 */
    private String name;
    
    /** 密码：不少于4位 */
    private String password;
    
    /** 所属科室ID */
    private Integer deptId;
    
    /** 专长描述：最多200个字符 */
    private String specialty;
    
    /** 职称 */
    private String title;
    
    /** 性别 */
    private String gender;
    
    /** 联系电话 */
    private String phone;
    
    /** 电子邮箱 */
    private String email;
    
    /** 照片路径 */
    private String photo;
    
    /** 状态：1-在职, 0-离职 */
    private Integer status;
    
    /** 创建时间 */
    private Date createTime;
    
    /** 更新时间 */
    private Date updateTime;
    
    /** 科室名称（关联查询用） */
    private String deptName;
    
    // 默认构造函数
    public Doctor() {
    }
    
    // 带参构造函数
    public Doctor(String doctorId, String name, String password, Integer deptId, String specialty) {
        this.doctorId = doctorId;
        this.name = name;
        this.password = password;
        this.deptId = deptId;
        this.specialty = specialty;
        this.status = 1;
    }
    
    // Getter和Setter方法
    public String getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(String doctorId) {
        this.doctorId = doctorId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public Integer getDeptId() {
        return deptId;
    }
    
    public void setDeptId(Integer deptId) {
        this.deptId = deptId;
    }
    
    public String getSpecialty() {
        return specialty;
    }
    
    public void setSpecialty(String specialty) {
        this.specialty = specialty;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getGender() {
        return gender;
    }
    
    public void setGender(String gender) {
        this.gender = gender;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPhoto() {
        return photo;
    }
    
    public void setPhoto(String photo) {
        this.photo = photo;
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
    
    public String getDeptName() {
        return deptName;
    }
    
    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }
    
    /**
     * 获取状态显示文本
     * @return 在职/离职
     */
    public String getStatusText() {
        return status != null && status == 1 ? "在职" : "离职";
    }
    
    @Override
    public String toString() {
        return "Doctor{" +
                "doctorId='" + doctorId + '\'' +
                ", name='" + name + '\'' +
                ", deptId=" + deptId +
                ", specialty='" + specialty + '\'' +
                ", title='" + title + '\'' +
                ", status=" + status +
                '}';
    }
}
