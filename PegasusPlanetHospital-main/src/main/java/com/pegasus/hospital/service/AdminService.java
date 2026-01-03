package com.pegasus.hospital.service;

import com.pegasus.hospital.dao.AdminDAO;
import com.pegasus.hospital.entity.Admin;
import com.pegasus.hospital.util.CommonUtil;

import java.sql.SQLException;
import java.util.List;

/**
 * 管理员服务类
 * 处理管理员相关的业务逻辑
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class AdminService {
    
    private AdminDAO adminDAO = new AdminDAO();
    
    /**
     * 管理员登录
     * 
     * @param username 用户名
     * @param password 密码
     * @return 管理员对象或null
     */
    public Admin login(String username, String password) {
        try {
            if (CommonUtil.isEmpty(username) || CommonUtil.isEmpty(password)) {
                return null;
            }
            String encryptedPassword = CommonUtil.md5(password);
            Admin admin = adminDAO.login(username, encryptedPassword);
            if (admin != null) {
                // 更新最后登录时间
                adminDAO.updateLastLogin(admin.getAdminId());
            }
            return admin;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 添加管理员
     * 
     * @param admin 管理员对象
     * @return 操作结果
     */
    public String addAdmin(Admin admin) {
        try {
            // 验证用户名
            if (CommonUtil.isEmpty(admin.getUsername())) {
                return "用户名不能为空";
            }
            
            // 验证密码
            if (!CommonUtil.isValidPassword(admin.getPassword())) {
                return "密码不能少于4位";
            }
            
            // 检查用户名是否已存在
            if (adminDAO.usernameExists(admin.getUsername())) {
                return "该用户名已存在";
            }
            
            // 加密密码
            admin.setPassword(CommonUtil.md5(admin.getPassword()));
            admin.setStatus(1);
            
            int adminId = adminDAO.insert(admin);
            if (adminId > 0) {
                return "SUCCESS:" + adminId;
            } else {
                return "添加失败，请稍后重试";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "系统错误：" + e.getMessage();
        }
    }
    
    /**
     * 更新管理员信息
     * 
     * @param admin 管理员对象
     * @return 操作结果
     */
    public String updateAdmin(Admin admin) {
        try {
            int result = adminDAO.update(admin);
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
     * 修改密码
     * 
     * @param adminId 管理员ID
     * @param oldPassword 旧密码
     * @param newPassword 新密码
     * @return 操作结果
     */
    public String changePassword(Integer adminId, String oldPassword, String newPassword) {
        try {
            // 验证旧密码
            Admin admin = adminDAO.findById(adminId);
            if (admin == null) {
                return "管理员不存在";
            }
            if (!admin.getPassword().equals(CommonUtil.md5(oldPassword))) {
                return "原密码错误";
            }
            
            // 验证新密码
            if (!CommonUtil.isValidPassword(newPassword)) {
                return "新密码不能少于4位";
            }
            
            int result = adminDAO.updatePassword(adminId, CommonUtil.md5(newPassword));
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
     * 删除管理员
     * 
     * @param adminId 管理员ID
     * @return 操作结果
     */
    public boolean deleteAdmin(Integer adminId) {
        try {
            return adminDAO.delete(adminId) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 根据ID查询管理员
     * 
     * @param adminId 管理员ID
     * @return 管理员对象
     */
    public Admin findById(Integer adminId) {
        try {
            return adminDAO.findById(adminId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 查询所有管理员
     * 
     * @return 管理员列表
     */
    public List<Admin> findAll() {
        try {
            return adminDAO.findAll();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
