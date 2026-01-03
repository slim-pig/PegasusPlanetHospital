package com.pegasus.hospital.dao;

import com.pegasus.hospital.entity.Admin;
import com.pegasus.hospital.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 管理员数据访问对象
 * 负责管理员信息的数据库CRUD操作
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class AdminDAO {
    
    /**
     * 添加管理员
     * 
     * @param admin 管理员对象
     * @return 自动生成的管理员ID
     * @throws SQLException SQL异常
     */
    public int insert(Admin admin) throws SQLException {
        String sql = "INSERT INTO admin (username, password, name, phone, role, status) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, admin.getUsername());
            ps.setString(2, admin.getPassword());
            ps.setString(3, admin.getName());
            ps.setString(4, admin.getPhone());
            ps.setString(5, admin.getRole() != null ? admin.getRole() : Admin.ROLE_ADMIN);
            ps.setInt(6, admin.getStatus() != null ? admin.getStatus() : 1);
            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return -1;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 更新管理员信息
     * 
     * @param admin 管理员对象
     * @return 影响的行数
     * @throws SQLException SQL异常
     */
    public int update(Admin admin) throws SQLException {
        String sql = "UPDATE admin SET name = ?, phone = ?, role = ?, status = ?, update_time = NOW() WHERE admin_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, admin.getName());
            ps.setString(2, admin.getPhone());
            ps.setString(3, admin.getRole());
            ps.setInt(4, admin.getStatus());
            ps.setInt(5, admin.getAdminId());
            return ps.executeUpdate();
        } finally {
            DBUtil.closeAll(conn, ps, null);
        }
    }
    
    /**
     * 修改密码
     * 
     * @param adminId 管理员ID
     * @param newPassword 新密码（已加密）
     * @return 影响的行数
     * @throws SQLException SQL异常
     */
    public int updatePassword(Integer adminId, String newPassword) throws SQLException {
        String sql = "UPDATE admin SET password = ?, update_time = NOW() WHERE admin_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setInt(2, adminId);
            return ps.executeUpdate();
        } finally {
            DBUtil.closeAll(conn, ps, null);
        }
    }
    
    /**
     * 更新最后登录时间
     * 
     * @param adminId 管理员ID
     * @return 影响的行数
     * @throws SQLException SQL异常
     */
    public int updateLastLogin(Integer adminId) throws SQLException {
        String sql = "UPDATE admin SET last_login = NOW() WHERE admin_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, adminId);
            return ps.executeUpdate();
        } finally {
            DBUtil.closeAll(conn, ps, null);
        }
    }
    
    /**
     * 删除管理员（逻辑删除）
     * 
     * @param adminId 管理员ID
     * @return 影响的行数
     * @throws SQLException SQL异常
     */
    public int delete(Integer adminId) throws SQLException {
        String sql = "UPDATE admin SET status = 0, update_time = NOW() WHERE admin_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, adminId);
            return ps.executeUpdate();
        } finally {
            DBUtil.closeAll(conn, ps, null);
        }
    }
    
    /**
     * 根据ID查询管理员
     * 
     * @param adminId 管理员ID
     * @return 管理员对象
     * @throws SQLException SQL异常
     */
    public Admin findById(Integer adminId) throws SQLException {
        String sql = "SELECT * FROM admin WHERE admin_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, adminId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToAdmin(rs);
            }
            return null;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 根据用户名查询管理员
     * 
     * @param username 用户名
     * @return 管理员对象
     * @throws SQLException SQL异常
     */
    public Admin findByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM admin WHERE username = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToAdmin(rs);
            }
            return null;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 登录验证
     * 
     * @param username 用户名
     * @param password 密码（已加密）
     * @return 管理员对象（验证成功）或null（验证失败）
     * @throws SQLException SQL异常
     */
    public Admin login(String username, String password) throws SQLException {
        String sql = "SELECT * FROM admin WHERE username = ? AND password = ? AND status = 1";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToAdmin(rs);
            }
            return null;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 查询所有管理员
     * 
     * @return 管理员列表
     * @throws SQLException SQL异常
     */
    public List<Admin> findAll() throws SQLException {
        String sql = "SELECT * FROM admin WHERE status = 1 ORDER BY admin_id";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Admin> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAdmin(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 检查用户名是否存在
     * 
     * @param username 用户名
     * @return true-存在, false-不存在
     * @throws SQLException SQL异常
     */
    public boolean usernameExists(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM admin WHERE username = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * ResultSet映射到Admin对象
     * 
     * @param rs ResultSet
     * @return Admin对象
     * @throws SQLException SQL异常
     */
    private Admin mapResultSetToAdmin(ResultSet rs) throws SQLException {
        Admin admin = new Admin();
        admin.setAdminId(rs.getInt("admin_id"));
        admin.setUsername(rs.getString("username"));
        admin.setPassword(rs.getString("password"));
        admin.setName(rs.getString("name"));
        admin.setPhone(rs.getString("phone"));
        admin.setRole(rs.getString("role"));
        admin.setStatus(rs.getInt("status"));
        admin.setLastLogin(rs.getTimestamp("last_login"));
        admin.setCreateTime(rs.getTimestamp("create_time"));
        admin.setUpdateTime(rs.getTimestamp("update_time"));
        return admin;
    }
}
