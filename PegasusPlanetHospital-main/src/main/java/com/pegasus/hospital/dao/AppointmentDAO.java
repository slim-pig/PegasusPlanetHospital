package com.pegasus.hospital.dao;

import com.pegasus.hospital.entity.Appointment;
import com.pegasus.hospital.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

/**
 * 预约数据访问对象
 * 负责预约信息的数据库CRUD操作
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class AppointmentDAO {
    
    /**
     * 添加预约
     * 
     * @param appointment 预约对象
     * @return 影响的行数
     * @throws SQLException SQL异常
     */
    public int insert(Appointment appointment) throws SQLException {
        String sql = "INSERT INTO appointment (appointment_id, patient_id, doctor_id, schedule_id, " +
                     "appointment_date, time_slot, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, appointment.getAppointmentId());
            ps.setString(2, appointment.getPatientId());
            ps.setString(3, appointment.getDoctorId());
            ps.setInt(4, appointment.getScheduleId());
            ps.setDate(5, new java.sql.Date(appointment.getAppointmentDate().getTime()));
            ps.setString(6, appointment.getTimeSlot());
            ps.setString(7, appointment.getStatus() != null ? appointment.getStatus() : Appointment.STATUS_BOOKED);
            return ps.executeUpdate();
        } finally {
            DBUtil.closeAll(conn, ps, null);
        }
    }
    
    /**
     * 取消预约
     * 
     * @param appointmentId 预约ID
     * @param cancelReason 取消原因
     * @return 影响的行数
     * @throws SQLException SQL异常
     */
    public int cancel(String appointmentId, String cancelReason) throws SQLException {
        String sql = "UPDATE appointment SET status = ?, cancel_reason = ?, update_time = NOW() " +
                     "WHERE appointment_id = ? AND status = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, Appointment.STATUS_CANCELLED);
            ps.setString(2, cancelReason);
            ps.setString(3, appointmentId);
            ps.setString(4, Appointment.STATUS_BOOKED);
            return ps.executeUpdate();
        } finally {
            DBUtil.closeAll(conn, ps, null);
        }
    }
    
    /**
     * 完成预约
     * 
     * @param appointmentId 预约ID
     * @return 影响的行数
     * @throws SQLException SQL异常
     */
    public int complete(String appointmentId) throws SQLException {
        String sql = "UPDATE appointment SET status = ?, update_time = NOW() " +
                     "WHERE appointment_id = ? AND status = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, Appointment.STATUS_COMPLETED);
            ps.setString(2, appointmentId);
            ps.setString(3, Appointment.STATUS_BOOKED);
            return ps.executeUpdate();
        } finally {
            DBUtil.closeAll(conn, ps, null);
        }
    }
    
    /**
     * 根据ID查询预约
     * 
     * @param appointmentId 预约ID
     * @return 预约对象
     * @throws SQLException SQL异常
     */
    public Appointment findById(String appointmentId) throws SQLException {
        String sql = "SELECT a.*, p.name as patient_name, p.phone as patient_phone, " +
                     "d.name as doctor_name, dept.dept_name " +
                     "FROM appointment a " +
                     "LEFT JOIN patient p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN doctor d ON a.doctor_id = d.doctor_id " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "WHERE a.appointment_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, appointmentId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToAppointment(rs);
            }
            return null;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 根据患者ID查询预约
     * 
     * @param patientId 患者ID
     * @return 预约列表
     * @throws SQLException SQL异常
     */
    public List<Appointment> findByPatientId(String patientId) throws SQLException {
        String sql = "SELECT a.*, p.name as patient_name, p.phone as patient_phone, " +
                     "d.name as doctor_name, d.title as doctor_title, dept.dept_name " +
                     "FROM appointment a " +
                     "LEFT JOIN patient p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN doctor d ON a.doctor_id = d.doctor_id " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "WHERE a.patient_id = ? " +
                     "ORDER BY a.appointment_date DESC, a.time_slot DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Appointment> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, patientId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAppointment(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 根据医生ID查询预约
     * 
     * @param doctorId 医生ID
     * @return 预约列表
     * @throws SQLException SQL异常
     */
    public List<Appointment> findByDoctorId(String doctorId) throws SQLException {
        String sql = "SELECT a.*, p.name as patient_name, p.phone as patient_phone, " +
                     "d.name as doctor_name, dept.dept_name " +
                     "FROM appointment a " +
                     "LEFT JOIN patient p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN doctor d ON a.doctor_id = d.doctor_id " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "WHERE a.doctor_id = ? " +
                     "ORDER BY a.appointment_date DESC, a.time_slot DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Appointment> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, doctorId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAppointment(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 查询患者在指定时间段是否已有预约
     * 
     * @param patientId 患者ID
     * @param date 日期
     * @param timeSlot 时间段
     * @return true-已有预约, false-没有预约
     * @throws SQLException SQL异常
     */
    public boolean hasAppointment(String patientId, Date date, String timeSlot) throws SQLException {
        String sql = "SELECT COUNT(*) FROM appointment WHERE patient_id = ? AND appointment_date = ? " +
                     "AND time_slot = ? AND status = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, patientId);
            ps.setDate(2, new java.sql.Date(date.getTime()));
            ps.setString(3, timeSlot);
            ps.setString(4, Appointment.STATUS_BOOKED);
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
     * 检查预约ID是否存在
     * 
     * @param appointmentId 预约ID
     * @return true-存在, false-不存在
     * @throws SQLException SQL异常
     */
    public boolean exists(String appointmentId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM appointment WHERE appointment_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, appointmentId);
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
     * 查询所有预约
     * 
     * @return 预约列表
     * @throws SQLException SQL异常
     */
    public List<Appointment> findAll() throws SQLException {
        String sql = "SELECT a.*, p.name as patient_name, p.phone as patient_phone, " +
                     "d.name as doctor_name, d.title as doctor_title, dept.dept_name " +
                     "FROM appointment a " +
                     "LEFT JOIN patient p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN doctor d ON a.doctor_id = d.doctor_id " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "ORDER BY a.appointment_date DESC, a.time_slot DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Appointment> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAppointment(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 分页查询预约
     * 
     * @param page 页码
     * @param pageSize 每页数量
     * @return 预约列表
     * @throws SQLException SQL异常
     */
    public List<Appointment> findByPage(int page, int pageSize) throws SQLException {
        String sql = "SELECT a.*, p.name as patient_name, p.phone as patient_phone, " +
                     "d.name as doctor_name, d.title as doctor_title, dept.dept_name " +
                     "FROM appointment a " +
                     "LEFT JOIN patient p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN doctor d ON a.doctor_id = d.doctor_id " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "ORDER BY a.create_time DESC LIMIT ?, ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Appointment> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAppointment(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 查询日期范围内的预约
     * 
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 预约列表
     * @throws SQLException SQL异常
     */
    public List<Appointment> findByDateRange(Date startDate, Date endDate) throws SQLException {
        String sql = "SELECT a.*, p.name as patient_name, p.phone as patient_phone, " +
                     "d.name as doctor_name, d.title as doctor_title, dept.dept_name " +
                     "FROM appointment a " +
                     "LEFT JOIN patient p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN doctor d ON a.doctor_id = d.doctor_id " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "WHERE a.appointment_date BETWEEN ? AND ? " +
                     "ORDER BY a.appointment_date, a.time_slot";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Appointment> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setDate(1, new java.sql.Date(startDate.getTime()));
            ps.setDate(2, new java.sql.Date(endDate.getTime()));
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAppointment(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 统计预约总数
     * 
     * @return 预约总数
     * @throws SQLException SQL异常
     */
    public int count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM appointment";
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
     * 统计各科室预约量
     * 
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 科室预约统计
     * @throws SQLException SQL异常
     */
    public List<Map<String, Object>> countByDepartment(Date startDate, Date endDate) throws SQLException {
        String sql = "SELECT dept.dept_name, " +
                     "COUNT(*) as total, " +
                     "SUM(CASE WHEN a.status = 'BOOKED' THEN 1 ELSE 0 END) as booked, " +
                     "SUM(CASE WHEN a.status = 'COMPLETED' THEN 1 ELSE 0 END) as completed, " +
                     "SUM(CASE WHEN a.status = 'CANCELLED' THEN 1 ELSE 0 END) as cancelled " +
                     "FROM appointment a " +
                     "LEFT JOIN doctor d ON a.doctor_id = d.doctor_id " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "WHERE a.appointment_date BETWEEN ? AND ? " +
                     "GROUP BY dept.dept_id, dept.dept_name " +
                     "ORDER BY total DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Map<String, Object>> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setDate(1, new java.sql.Date(startDate.getTime()));
            ps.setDate(2, new java.sql.Date(endDate.getTime()));
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("deptName", rs.getString("dept_name"));
                map.put("total", rs.getInt("total"));
                map.put("booked", rs.getInt("booked"));
                map.put("completed", rs.getInt("completed"));
                map.put("cancelled", rs.getInt("cancelled"));
                list.add(map);
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 统计医生工作量
     * 
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 医生工作量统计
     * @throws SQLException SQL异常
     */
    public List<Map<String, Object>> countByDoctor(Date startDate, Date endDate) throws SQLException {
        String sql = "SELECT d.doctor_id, d.name as doctor_name, dept.dept_name, " +
                     "COUNT(*) as total, " +
                     "SUM(CASE WHEN a.status = 'BOOKED' THEN 1 ELSE 0 END) as booked, " +
                     "SUM(CASE WHEN a.status = 'COMPLETED' THEN 1 ELSE 0 END) as completed, " +
                     "SUM(CASE WHEN a.status = 'CANCELLED' THEN 1 ELSE 0 END) as cancelled " +
                     "FROM appointment a " +
                     "LEFT JOIN doctor d ON a.doctor_id = d.doctor_id " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "WHERE a.appointment_date BETWEEN ? AND ? " +
                     "GROUP BY d.doctor_id, d.name, dept.dept_name " +
                     "ORDER BY total DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Map<String, Object>> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setDate(1, new java.sql.Date(startDate.getTime()));
            ps.setDate(2, new java.sql.Date(endDate.getTime()));
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("doctorId", rs.getString("doctor_id"));
                map.put("doctorName", rs.getString("doctor_name"));
                map.put("deptName", rs.getString("dept_name"));
                map.put("total", rs.getInt("total"));
                map.put("booked", rs.getInt("booked"));
                map.put("completed", rs.getInt("completed"));
                map.put("cancelled", rs.getInt("cancelled"));
                list.add(map);
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 统计日期范围内的总体预约情况
     * 
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 统计结果
     * @throws SQLException SQL异常
     */
    public Map<String, Object> getStatsByDateRange(Date startDate, Date endDate) throws SQLException {
        String sql = "SELECT COUNT(*) as total, " +
                     "SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END) as completed, " +
                     "SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END) as cancelled " +
                     "FROM appointment WHERE appointment_date BETWEEN ? AND ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Map<String, Object> result = new HashMap<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setDate(1, new java.sql.Date(startDate.getTime()));
            ps.setDate(2, new java.sql.Date(endDate.getTime()));
            rs = ps.executeQuery();
            if (rs.next()) {
                result.put("total", rs.getInt("total"));
                result.put("completed", rs.getInt("completed"));
                result.put("cancelled", rs.getInt("cancelled"));
            } else {
                result.put("total", 0);
                result.put("completed", 0);
                result.put("cancelled", 0);
            }
            return result;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }

    /**
     * 统计日期范围内的每日预约数量
     * 
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 每日统计结果
     * @throws SQLException SQL异常
     */
    public Map<String, Integer> getDailyStatsByDateRange(Date startDate, Date endDate) throws SQLException {
        String sql = "SELECT DATE_FORMAT(appointment_date, '%Y-%m-%d') as day, COUNT(*) as count " +
                     "FROM appointment WHERE appointment_date BETWEEN ? AND ? " +
                     "GROUP BY day ORDER BY day";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Map<String, Integer> result = new HashMap<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setDate(1, new java.sql.Date(startDate.getTime()));
            ps.setDate(2, new java.sql.Date(endDate.getTime()));
            rs = ps.executeQuery();
            while (rs.next()) {
                result.put(rs.getString("day"), rs.getInt("count"));
            }
            return result;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 根据状态查询预约
     * 
     * @param status 状态
     * @return 预约列表
     * @throws SQLException SQL异常
     */
    public List<Appointment> findByStatus(String status) throws SQLException {
        String sql = "SELECT a.*, p.name as patient_name, p.phone as patient_phone, " +
                     "d.name as doctor_name, d.title as doctor_title, dept.dept_name " +
                     "FROM appointment a " +
                     "LEFT JOIN patient p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN doctor d ON a.doctor_id = d.doctor_id " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "WHERE a.status = ? " +
                     "ORDER BY a.appointment_date DESC, a.time_slot DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Appointment> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAppointment(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }

    /**
     * ResultSet映射到Appointment对象
     * 
     * @param rs ResultSet
     * @return Appointment对象
     * @throws SQLException SQL异常
     */
    private Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
        Appointment appointment = new Appointment();
        appointment.setAppointmentId(rs.getString("appointment_id"));
        appointment.setPatientId(rs.getString("patient_id"));
        appointment.setDoctorId(rs.getString("doctor_id"));
        appointment.setScheduleId(rs.getInt("schedule_id"));
        appointment.setAppointmentDate(rs.getDate("appointment_date"));
        appointment.setTimeSlot(rs.getString("time_slot"));
        appointment.setStatus(rs.getString("status"));
        appointment.setCancelReason(rs.getString("cancel_reason"));
        appointment.setCreateTime(rs.getTimestamp("create_time"));
        appointment.setUpdateTime(rs.getTimestamp("update_time"));
        // 关联字段
        try {
            appointment.setPatientName(rs.getString("patient_name"));
            appointment.setPatientPhone(rs.getString("patient_phone"));
            appointment.setDoctorName(rs.getString("doctor_name"));
            try {
                appointment.setDoctorTitle(rs.getString("doctor_title"));
            } catch (SQLException e) {
                // 忽略
            }
            appointment.setDeptName(rs.getString("dept_name"));
        } catch (SQLException e) {
            // 忽略
        }
        return appointment;
    }
}
