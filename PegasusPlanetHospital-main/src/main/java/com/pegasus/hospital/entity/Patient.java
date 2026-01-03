package com.pegasus.hospital.entity;

import java.io.Serializable;
import java.util.Date;

/**
 * 患者实体类
 * 存储飞马星球医院患者的基本信息
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class Patient implements Serializable {
    private static final long serialVersionUID = 1L;
    
    /** 患者ID：10位数字组成 */
    private String patientId;
    
    /** 姓名：最多20个字符 */
    private String name;
    
    /** 密码：不少于4位 */
    private String password;
    
    /** 身份证号：18位数字 */
    private String idCard;
    
    /** 手机号 */
    private String phone;
    
    /** 性别：M(男)或F(女) */
    private String gender;
    
    /** 出生日期 */
    private Date birthday;
    
    /** 地址 */
    private String address;
    
    /** 电子邮箱 */
    private String email;
    
    /** 账户余额 */
    private java.math.BigDecimal balance;

    /** 状态：1-正常, 0-已注销 */
    private Integer status;
    
    /** 创建时间 */
    private Date createTime;
    
    /** 更新时间 */
    private Date updateTime;
    
    // 默认构造函数
    public Patient() {
    }
    
    // 带参构造函数
    public Patient(String patientId, String name, String password, String idCard, 
                   String phone, String gender) {
        this.patientId = patientId;
        this.name = name;
        this.password = password;
        this.idCard = idCard;
        this.phone = phone;
        this.gender = gender;
        this.status = 1;
    }
    
    // Getter和Setter方法
    public String getPatientId() {
        return patientId;
    }
    
    public void setPatientId(String patientId) {
        this.patientId = patientId;
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
    
    public String getIdCard() {
        return idCard;
    }
    
    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getGender() {
        return gender;
    }
    
    public void setGender(String gender) {
        this.gender = gender;
    }
    
    public Date getBirthday() {
        return birthday;
    }
    
    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }

    public java.math.BigDecimal getBalance() {
        return balance;
    }

    public void setBalance(java.math.BigDecimal balance) {
        this.balance = balance;
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
    
    /**
     * 获取性别显示文本
     * @return 男/女
     */
    public String getGenderText() {
        return "M".equals(gender) ? "男" : "女";
    }
    
    /**
     * 获取状态显示文本
     * @return 正常/已注销
     */
    public String getStatusText() {
        return status != null && status == 1 ? "正常" : "已注销";
    }
    
    /**
     * 计算年龄
     * @return 年龄
     */
    public int getAge() {
        if (birthday == null) {
            return 0;
        }
        java.util.Calendar cal = java.util.Calendar.getInstance();
        int currentYear = cal.get(java.util.Calendar.YEAR);
        cal.setTime(birthday);
        int birthYear = cal.get(java.util.Calendar.YEAR);
        return currentYear - birthYear;
    }
    
    @Override
    public String toString() {
        return "Patient{" +
                "patientId='" + patientId + '\'' +
                ", name='" + name + '\'' +
                ", idCard='" + idCard + '\'' +
                ", phone='" + phone + '\'' +
                ", gender='" + gender + '\'' +
                ", status=" + status +
                '}';
    }
}
