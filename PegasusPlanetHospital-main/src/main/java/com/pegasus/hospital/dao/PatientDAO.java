package com.pegasus.hospital.dao;

import com.pegasus.hospital.entity.Patient;
import com.pegasus.hospital.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 患者数据访问对象
 * 负责患者信息的数据库CRUD操作
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class PatientDAO {
    
    /**
     * 添加患者
     * 
     * @param patient 患者对象
     * @return 影响的行数
     * @throws SQLException SQL异常
     */
    public int insert(Patient patient) throws SQLException {
        String sql = "INSERT INTO patient (patient_id, name, password, id_card, phone, gender, birthday, address, email, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, patient.getPatientId());
            ps.setString(2, patient.getName());
            ps.setString(3, patient.getPassword());
            ps.setString(4, patient.getIdCard());
            ps.setString(5, patient.getPhone());
            ps.setString(6, patient.getGender());
            ps.setDate(7, patient.getBirthday() != null ? new java.sql.Date(patient.getBirthday().getTime()) : null);
            ps.setString(8, patient.getAddress());
            ps.setString(9, patient.getEmail());
            ps.setInt(10, patient.getStatus() != null ? patient.getStatus() : 1);
            return ps.executeUpdate();
        } finally {
            DBUtil.closeAll(conn, ps, null);
        }
    }
    
    /**
     * 更新患者信息
     * 
     * @param patient 患者对象
     * @return 影响的行数
     * @throws SQLException SQL异常
     */
    public int update(Patient patient) throws SQLException {
        String sql = "UPDATE patient SET name = ?, phone = ?, gender = ?, birthday = ?, address = ?, email = ?, update_time = NOW() " +
                     "WHERE patient_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, patient.getName());
            ps.setString(2, patient.getPhone());
            ps.setString(3, patient.getGender());
            ps.setDate(4, patient.getBirthday() != null ? new java.sql.Date(patient.getBirthday().getTime()) : null);
            ps.setString(5, patient.getAddress());
            ps.setString(6, patient.getEmail());
            ps.setString(7, patient.getPatientId());
            return ps.executeUpdate();
        } finally {
            DBUtil.closeAll(conn, ps, null);
        }
    }
    
    /**
     * 修改密码
     * 
     * @param patientId 患者ID
     * @param newPassword 新密码（已加密）
     * @return 影响的行数
     * @throws SQLException SQL异常
     */
    public int updatePassword(String patientId, String newPassword) throws SQLException {
        String sql = "UPDATE patient SET password = ?, update_time = NOW() WHERE patient_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setString(2, patientId);
            return ps.executeUpdate();
        } finally {
            DBUtil.closeAll(conn, ps, null);
        }
    }
    
    /**
     * 注销账号（逻辑删除）
     * 
     * @param patientId 患者ID
     * @return 影响的行数
     * @throws SQLException SQL异常
     */
    public int deactivate(String patientId) throws SQLException {
        String sql = "UPDATE patient SET status = 0, update_time = NOW() WHERE patient_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, patientId);
            return ps.executeUpdate();
        } finally {
            DBUtil.closeAll(conn, ps, null);
        }
    }
    
    /**
     * 根据ID查询患者
     * 
     * @param patientId 患者ID
     * @return 患者对象
     * @throws SQLException SQL异常
     */
    public Patient findById(String patientId) throws SQLException {
        String sql = "SELECT * FROM patient WHERE patient_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, patientId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToPatient(rs);
            }
            return null;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 根据身份证号查询患者
     * 
     * @param idCard 身份证号
     * @return 患者对象
     * @throws SQLException SQL异常
     */
    public Patient findByIdCard(String idCard) throws SQLException {
        String sql = "SELECT * FROM patient WHERE id_card = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, idCard);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToPatient(rs);
            }
            return null;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 根据手机号查询患者
     * 
     * @param phone 手机号
     * @return 患者对象
     * @throws SQLException SQL异常
     */
    public Patient findByPhone(String phone) throws SQLException {
        String sql = "SELECT * FROM patient WHERE phone = ? AND status = 1";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, phone);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToPatient(rs);
            }
            return null;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 登录验证
     * 
     * @param patientId 患者ID
     * @param password 密码（已加密）
     * @return 患者对象（验证成功）或null（验证失败）
     * @throws SQLException SQL异常
     */
    public Patient login(String loginId, String password) throws SQLException {
        // 支持使用患者ID或手机号登录
        String sql = "SELECT * FROM patient WHERE (patient_id = ? OR phone = ?) AND password = ? AND status = 1";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, loginId);
            ps.setString(2, loginId);
            ps.setString(3, password);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToPatient(rs);
            }
            return null;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 查询所有患者
     * 
     * @return 患者列表
     * @throws SQLException SQL异常
     */
    public List<Patient> findAll() throws SQLException {
        String sql = "SELECT * FROM patient WHERE status = 1 ORDER BY create_time DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Patient> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToPatient(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 分页查询患者
     * 
     * @param page 页码（从1开始）
     * @param pageSize 每页数量
     * @return 患者列表
     * @throws SQLException SQL异常
     */
    public List<Patient> findByPage(int page, int pageSize) throws SQLException {
        String sql = "SELECT * FROM patient WHERE status = 1 ORDER BY create_time DESC LIMIT ?, ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Patient> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToPatient(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 统计患者总数
     * 
     * @return 患者总数
     * @throws SQLException SQL异常
     */
    public int count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM patient WHERE status = 1";
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
     * 检查患者ID是否存在
     * 
     * @param patientId 患者ID
     * @return true-存在, false-不存在
     * @throws SQLException SQL异常
     */
    public boolean exists(String patientId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM patient WHERE patient_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, patientId);
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
     * 检查身份证号是否已注册
     * 
     * @param idCard 身份证号
     * @return true-已注册, false-未注册
     * @throws SQLException SQL异常
     */
    public boolean idCardExists(String idCard) throws SQLException {
        String sql = "SELECT COUNT(*) FROM patient WHERE id_card = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, idCard);
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
     * 检查手机号是否已注册
     * 
     * @param phone 手机号
     * @return true-已注册, false-未注册
     * @throws SQLException SQL异常
     */
    public boolean phoneExists(String phone) throws SQLException {
        String sql = "SELECT COUNT(*) FROM patient WHERE phone = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, phone);
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
     * 搜索患者
     * 
     * @param keyword 关键字（姓名、手机号或身份证号）
     * @param page 页码
     * @param pageSize 每页数量
     * @return 患者列表
     * @throws SQLException SQL异常
     */
    public List<Patient> search(String keyword, int page, int pageSize) throws SQLException {
        String sql = "SELECT * FROM patient WHERE status = 1 AND (name LIKE ? OR phone LIKE ? OR id_card LIKE ?) " +
                     "ORDER BY create_time DESC LIMIT ?, ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Patient> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            String pattern = "%" + keyword + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            ps.setInt(4, (page - 1) * pageSize);
            ps.setInt(5, pageSize);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToPatient(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }

    /**
     * 统计搜索结果数量
     * 
     * @param keyword 关键字
     * @return 数量
     * @throws SQLException SQL异常
     */
    public int countByKeyword(String keyword) throws SQLException {
        String sql = "SELECT COUNT(*) FROM patient WHERE status = 1 AND (name LIKE ? OR phone LIKE ? OR id_card LIKE ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            String pattern = "%" + keyword + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
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
     * ResultSet映射到Patient对象
     * 
     * @param rs ResultSet
     * @return Patient对象
     * @throws SQLException SQL异常
     */
    private Patient mapResultSetToPatient(ResultSet rs) throws SQLException {
        Patient patient = new Patient();
        patient.setPatientId(rs.getString("patient_id"));
        patient.setName(rs.getString("name"));
        patient.setPassword(rs.getString("password"));
        patient.setIdCard(rs.getString("id_card"));
        patient.setPhone(rs.getString("phone"));
        patient.setGender(rs.getString("gender"));
        patient.setBirthday(rs.getDate("birthday"));
        patient.setAddress(rs.getString("address"));
        patient.setEmail(rs.getString("email"));
        try {
            patient.setBalance(rs.getBigDecimal("balance"));
        } catch (SQLException e) {
            // 忽略列不存在的错误，默认为0
            patient.setBalance(java.math.BigDecimal.ZERO);
        }
        patient.setStatus(rs.getInt("status"));
        patient.setCreateTime(rs.getTimestamp("create_time"));
        patient.setUpdateTime(rs.getTimestamp("update_time"));
        return patient;
    }
}
