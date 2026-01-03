package com.pegasus.hospital.dao;

import com.pegasus.hospital.entity.Doctor;
import com.pegasus.hospital.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 医生数据访问对象
 * 负责医生信息的数据库CRUD操作
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class DoctorDAO {
    
    /**
     * 添加医生
     * 
     * @param doctor 医生对象
     * @return 影响的行数
     * @throws SQLException SQL异常
     */
    public int insert(Doctor doctor) throws SQLException {
        String sql = "INSERT INTO doctor (doctor_id, name, password, dept_id, specialty, title, phone, email, photo, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, doctor.getDoctorId());
            ps.setString(2, doctor.getName());
            ps.setString(3, doctor.getPassword());
            ps.setInt(4, doctor.getDeptId());
            ps.setString(5, doctor.getSpecialty());
            ps.setString(6, doctor.getTitle());
            ps.setString(7, doctor.getPhone());
            ps.setString(8, doctor.getEmail());
            ps.setString(9, doctor.getPhoto());
            ps.setInt(10, doctor.getStatus() != null ? doctor.getStatus() : 1);
            return ps.executeUpdate();
        } finally {
            DBUtil.closeAll(conn, ps, null);
        }
    }
    
    /**
     * 更新医生信息
     * 
     * @param doctor 医生对象
     * @return 影响的行数
     * @throws SQLException SQL异常
     */
    public int update(Doctor doctor) throws SQLException {
        String sql = "UPDATE doctor SET name = ?, dept_id = ?, specialty = ?, title = ?, phone = ?, email = ?, photo = ?, " +
                     "status = ?, update_time = NOW() WHERE doctor_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, doctor.getName());
            ps.setInt(2, doctor.getDeptId());
            ps.setString(3, doctor.getSpecialty());
            ps.setString(4, doctor.getTitle());
            ps.setString(5, doctor.getPhone());
            ps.setString(6, doctor.getEmail());
            ps.setString(7, doctor.getPhoto());
            ps.setInt(8, doctor.getStatus() != null ? doctor.getStatus() : 1);
            ps.setString(9, doctor.getDoctorId());
            return ps.executeUpdate();
        } finally {
            DBUtil.closeAll(conn, ps, null);
        }
    }
    
    /**
     * 删除医生（逻辑删除）
     * 
     * @param doctorId 医生ID
     * @return 影响的行数
     * @throws SQLException SQL异常
     */
    public int delete(String doctorId) throws SQLException {
        String sql = "UPDATE doctor SET status = 0, update_time = NOW() WHERE doctor_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, doctorId);
            return ps.executeUpdate();
        } finally {
            DBUtil.closeAll(conn, ps, null);
        }
    }
    
    /**
     * 根据ID查询医生
     * 
     * @param doctorId 医生ID
     * @return 医生对象
     * @throws SQLException SQL异常
     */
    public Doctor findById(String doctorId) throws SQLException {
        String sql = "SELECT d.*, dept.dept_name FROM doctor d " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "WHERE d.doctor_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, doctorId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToDoctor(rs);
            }
            return null;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 根据科室查询医生
     * 
     * @param deptId 科室ID
     * @return 医生列表
     * @throws SQLException SQL异常
     */
    public List<Doctor> findByDeptId(Integer deptId) throws SQLException {
        String sql = "SELECT d.*, dept.dept_name FROM doctor d " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "WHERE d.dept_id = ? AND d.status = 1 ORDER BY d.doctor_id";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Doctor> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, deptId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToDoctor(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 查询所有医生
     * 
     * @return 医生列表
     * @throws SQLException SQL异常
     */
    public List<Doctor> findAll() throws SQLException {
        String sql = "SELECT d.*, dept.dept_name FROM doctor d " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "WHERE d.status = 1 ORDER BY d.dept_id, d.doctor_id";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Doctor> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToDoctor(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 查询所有医生（包括离职）
     * 
     * @return 医生列表
     * @throws SQLException SQL异常
     */
    public List<Doctor> findAllIncludeInactive() throws SQLException {
        String sql = "SELECT d.*, dept.dept_name FROM doctor d " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "ORDER BY d.dept_id, d.doctor_id";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Doctor> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToDoctor(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 分页查询医生
     * 
     * @param page 页码（从1开始）
     * @param pageSize 每页数量
     * @return 医生列表
     * @throws SQLException SQL异常
     */
    public List<Doctor> findByPage(int page, int pageSize) throws SQLException {
        String sql = "SELECT d.*, dept.dept_name FROM doctor d " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "WHERE d.status = 1 ORDER BY d.dept_id, d.doctor_id LIMIT ?, ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Doctor> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToDoctor(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 统计医生总数
     * 
     * @return 医生总数
     * @throws SQLException SQL异常
     */
    public int count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM doctor WHERE status = 1";
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
     * 检查医生ID是否存在
     * 
     * @param doctorId 医生ID
     * @return true-存在, false-不存在
     * @throws SQLException SQL异常
     */
    public boolean exists(String doctorId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM doctor WHERE doctor_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, doctorId);
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
     * 根据科室ID查询医生
     * 
     * @param deptId 科室ID
     * @return 医生列表
     * @throws SQLException SQL异常
     */
    public List<Doctor> findByDepartmentId(int deptId) throws SQLException {
        String sql = "SELECT d.*, dept.dept_name FROM doctor d " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "WHERE d.dept_id = ? AND d.status = 1 ORDER BY d.doctor_id";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Doctor> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, deptId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToDoctor(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }

    /**
     * 搜索医生
     * 
     * @param keyword 关键字（姓名或专长）
     * @return 医生列表
     * @throws SQLException SQL异常
     */
    public List<Doctor> search(String keyword) throws SQLException {
        String sql = "SELECT d.*, dept.dept_name FROM doctor d " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "WHERE d.status = 1 AND (d.name LIKE ? OR d.specialty LIKE ?) " +
                     "ORDER BY d.dept_id, d.doctor_id";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Doctor> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            String pattern = "%" + keyword + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToDoctor(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }

    /**
     * 登录验证
     * 
     * @param doctorId 医生ID
     * @param password 密码（已加密）
     * @return 医生对象（验证成功）或null（验证失败）
     * @throws SQLException SQL异常
     */
    public Doctor login(String doctorId, String password) throws SQLException {
        String sql = "SELECT d.*, dept.dept_name FROM doctor d " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "WHERE d.doctor_id = ? AND d.password = ? AND d.status = 1";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, doctorId);
            ps.setString(2, password);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToDoctor(rs);
            }
            return null;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * ResultSet映射到Doctor对象
     * 
     * @param rs ResultSet
     * @return Doctor对象
     * @throws SQLException SQL异常
     */
    private Doctor mapResultSetToDoctor(ResultSet rs) throws SQLException {
        Doctor doctor = new Doctor();
        doctor.setDoctorId(rs.getString("doctor_id"));
        doctor.setName(rs.getString("name"));
        doctor.setPassword(rs.getString("password"));
        doctor.setDeptId(rs.getInt("dept_id"));
        doctor.setSpecialty(rs.getString("specialty"));
        doctor.setTitle(rs.getString("title"));
        doctor.setPhone(rs.getString("phone"));
        doctor.setEmail(rs.getString("email"));
        doctor.setPhoto(rs.getString("photo"));
        doctor.setStatus(rs.getInt("status"));
        doctor.setCreateTime(rs.getTimestamp("create_time"));
        doctor.setUpdateTime(rs.getTimestamp("update_time"));
        // 关联字段
        try {
            doctor.setDeptName(rs.getString("dept_name"));
        } catch (SQLException e) {
            // 忽略，可能没有关联查询
        }
        return doctor;
    }
}
