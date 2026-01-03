package com.pegasus.hospital.entity;

import java.io.Serializable;
import java.util.Date;

/**
 * 管理员实体类
 * 存储飞马星球医院管理员的基本信息
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class Admin implements Serializable {
    private static final long serialVersionUID = 1L;
    
    /** 管理员ID */
    private Integer adminId;
    
    /** 用户名 */
    private String username;
    
    /** 密码 */
    private String password;
    
    /** 姓名 */
    private String name;
    
    /** 电话 */
    private String phone;
    
    /** 角色：ADMIN-管理员, SUPER-超级管理员 */
    private String role;
    
    /** 状态：1-正常, 0-禁用 */
    private Integer status;
    
    /** 最后登录时间 */
    private Date lastLogin;
    
    /** 创建时间 */
    private Date createTime;
    
    /** 更新时间 */
    private Date updateTime;
    
    // 角色常量
    public static final String ROLE_ADMIN = "ADMIN";
    public static final String ROLE_SUPER = "SUPER";
    
    // 默认构造函数
    public Admin() {
    }
    
    // 带参构造函数
    public Admin(String username, String password, String name) {
        this.username = username;
        this.password = password;
        this.name = name;
        this.role = ROLE_ADMIN;
        this.status = 1;
    }
    
    // Getter和Setter方法
    public Integer getAdminId() {
        return adminId;
    }
    
    public void setAdminId(Integer adminId) {
        this.adminId = adminId;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public Integer getStatus() {
        return status;
    }
    
    public void setStatus(Integer status) {
        this.status = status;
    }
    
    public Date getLastLogin() {
        return lastLogin;
    }
    
    public void setLastLogin(Date lastLogin) {
        this.lastLogin = lastLogin;
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
     * 获取角色显示文本
     * @return 管理员/超级管理员
     */
    public String getRoleText() {
        return ROLE_SUPER.equals(role) ? "超级管理员" : "管理员";
    }
    
    /**
     * 获取状态显示文本
     * @return 正常/禁用
     */
    public String getStatusText() {
        return status != null && status == 1 ? "正常" : "禁用";
    }
    
    /**
     * 是否是超级管理员
     * @return true-是, false-否
     */
    public boolean isSuperAdmin() {
        return ROLE_SUPER.equals(role);
    }
    
    @Override
    public String toString() {
        return "Admin{" +
                "adminId=" + adminId +
                ", username='" + username + '\'' +
                ", name='" + name + '\'' +
                ", role='" + role + '\'' +
                ", status=" + status +
                '}';
    }
}
