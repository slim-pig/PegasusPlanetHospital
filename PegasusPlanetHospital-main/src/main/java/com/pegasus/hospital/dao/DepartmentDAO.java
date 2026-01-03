package com.pegasus.hospital.dao;

import com.pegasus.hospital.entity.Department;
import com.pegasus.hospital.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 科室数据访问对象
 * 负责科室信息的数据库CRUD操作
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class DepartmentDAO {
    
    /**
     * 添加科室
     * 
     * @param department 科室对象
     * @return 自动生成的科室ID
     * @throws SQLException SQL异常
     */
    public int insert(Department department) throws SQLException {
        String sql = "INSERT INTO department (dept_name, description, location, phone, status) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, department.getDeptName());
            ps.setString(2, department.getDescription());
            ps.setString(3, department.getLocation());
            ps.setString(4, department.getPhone());
            ps.setInt(5, department.getStatus() != null ? department.getStatus() : 1);
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
     * 更新科室信息
     * 
     * @param department 科室对象
     * @return 影响的行数
     * @throws SQLException SQL异常
     */
    public int update(Department department) throws SQLException {
        String sql = "UPDATE department SET dept_name = ?, description = ?, location = ?, phone = ?, status = ?, " +
                     "update_time = NOW() WHERE dept_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, department.getDeptName());
            ps.setString(2, department.getDescription());
            ps.setString(3, department.getLocation());
            ps.setString(4, department.getPhone());
            ps.setInt(5, department.getStatus());
            ps.setInt(6, department.getDeptId());
            return ps.executeUpdate();
        } finally {
            DBUtil.closeAll(conn, ps, null);
        }
    }
    
    /**
     * 删除科室（逻辑删除）
     * 
     * @param deptId 科室ID
     * @return 影响的行数
     * @throws SQLException SQL异常
     */
    public int delete(Integer deptId) throws SQLException {
        String sql = "UPDATE department SET status = 0, update_time = NOW() WHERE dept_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, deptId);
            return ps.executeUpdate();
        } finally {
            DBUtil.closeAll(conn, ps, null);
        }
    }
    
    /**
     * 根据ID查询科室
     * 
     * @param deptId 科室ID
     * @return 科室对象
     * @throws SQLException SQL异常
     */
    public Department findById(Integer deptId) throws SQLException {
        String sql = "SELECT d.*, (SELECT COUNT(*) FROM doctor WHERE dept_id = d.dept_id AND status = 1) as doctor_count " +
                     "FROM department d WHERE d.dept_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, deptId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToDepartment(rs);
            }
            return null;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 根据名称查询科室
     * 
     * @param deptName 科室名称
     * @return 科室对象
     * @throws SQLException SQL异常
     */
    public Department findByName(String deptName) throws SQLException {
        String sql = "SELECT d.*, (SELECT COUNT(*) FROM doctor WHERE dept_id = d.dept_id AND status = 1) as doctor_count " +
                     "FROM department d WHERE d.dept_name = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, deptName);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToDepartment(rs);
            }
            return null;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 查询所有科室
     * 
     * @return 科室列表
     * @throws SQLException SQL异常
     */
    public List<Department> findAll() throws SQLException {
        String sql = "SELECT d.*, (SELECT COUNT(*) FROM doctor WHERE dept_id = d.dept_id AND status = 1) as doctor_count " +
                     "FROM department d WHERE d.status = 1 ORDER BY d.dept_id";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Department> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToDepartment(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 查询所有科室（包括停用）
     * 
     * @return 科室列表
     * @throws SQLException SQL异常
     */
    public List<Department> findAllIncludeInactive() throws SQLException {
        String sql = "SELECT d.*, (SELECT COUNT(*) FROM doctor WHERE dept_id = d.dept_id AND status = 1) as doctor_count " +
                     "FROM department d ORDER BY d.dept_id";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Department> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToDepartment(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 统计科室总数
     * 
     * @return 科室总数
     * @throws SQLException SQL异常
     */
    public int count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM department WHERE status = 1";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 检查科室名称是否存在
     * 
     * @param deptName 科室名称
     * @return true-存在, false-不存在
     * @throws SQLException SQL异常
     */
    public boolean nameExists(String deptName) throws SQLException {
        String sql = "SELECT COUNT(*) FROM department WHERE dept_name = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, deptName);
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
     * ResultSet映射到Department对象
     * 
     * @param rs ResultSet
     * @return Department对象
     * @throws SQLException SQL异常
     */
    private Department mapResultSetToDepartment(ResultSet rs) throws SQLException {
        Department department = new Department();
        department.setDeptId(rs.getInt("dept_id"));
        department.setDeptName(rs.getString("dept_name"));
        department.setDescription(rs.getString("description"));
        department.setLocation(rs.getString("location"));
        department.setPhone(rs.getString("phone"));
        department.setStatus(rs.getInt("status"));
        department.setCreateTime(rs.getTimestamp("create_time"));
        department.setUpdateTime(rs.getTimestamp("update_time"));
        // 医生数量
        try {
            department.setDoctorCount(rs.getInt("doctor_count"));
        } catch (SQLException e) {
            // 忽略
        }
        return department;
    }
}
