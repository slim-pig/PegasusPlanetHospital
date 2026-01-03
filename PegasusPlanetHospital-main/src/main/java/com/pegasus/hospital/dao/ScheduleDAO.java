package com.pegasus.hospital.dao;

import com.pegasus.hospital.entity.Schedule;
import com.pegasus.hospital.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 排班数据访问对象
 * 负责医生排班信息的数据库CRUD操作
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class ScheduleDAO {
    
    /**
     * 添加排班
     * 
     * @param schedule 排班对象
     * @return 自动生成的排班ID
     * @throws SQLException SQL异常
     */
    public int insert(Schedule schedule) throws SQLException {
        String sql = "INSERT INTO schedule (doctor_id, schedule_date, time_slot, max_patients, current_patients, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, schedule.getDoctorId());
            ps.setDate(2, new java.sql.Date(schedule.getScheduleDate().getTime()));
            ps.setString(3, schedule.getTimeSlot());
            ps.setInt(4, schedule.getMaxPatients() != null ? schedule.getMaxPatients() : 10);
            ps.setInt(5, schedule.getCurrentPatients() != null ? schedule.getCurrentPatients() : 0);
            ps.setInt(6, schedule.getStatus() != null ? schedule.getStatus() : 1);
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
     * 批量添加排班
     * 
     * @param schedules 排班列表
     * @return 成功添加的数量
     * @throws SQLException SQL异常
     */
    public int batchInsert(List<Schedule> schedules) throws SQLException {
        String sql = "INSERT INTO schedule (doctor_id, schedule_date, time_slot, max_patients, current_patients, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            int count = 0;
            for (Schedule schedule : schedules) {
                ps.setString(1, schedule.getDoctorId());
                ps.setDate(2, new java.sql.Date(schedule.getScheduleDate().getTime()));
                ps.setString(3, schedule.getTimeSlot());
                ps.setInt(4, schedule.getMaxPatients() != null ? schedule.getMaxPatients() : 10);
                ps.setInt(5, schedule.getCurrentPatients() != null ? schedule.getCurrentPatients() : 0);
                ps.setInt(6, schedule.getStatus() != null ? schedule.getStatus() : 1);
                ps.addBatch();
                count++;
                // 每100条执行一次
                if (count % 100 == 0) {
                    ps.executeBatch();
                }
            }
            ps.executeBatch();
            return count;
        } finally {
            DBUtil.closeAll(conn, ps, null);
        }
    }
    
    /**
     * 更新排班信息
     * 
     * @param schedule 排班对象
     * @return 影响的行数
     * @throws SQLException SQL异常
     */
    public int update(Schedule schedule) throws SQLException {
        String sql = "UPDATE schedule SET doctor_id = ?, schedule_date = ?, time_slot = ?, max_patients = ?, " +
                     "current_patients = ?, status = ?, update_time = NOW() WHERE schedule_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, schedule.getDoctorId());
            ps.setDate(2, new java.sql.Date(schedule.getScheduleDate().getTime()));
            ps.setString(3, schedule.getTimeSlot());
            ps.setInt(4, schedule.getMaxPatients());
            ps.setInt(5, schedule.getCurrentPatients() != null ? schedule.getCurrentPatients() : 0);
            ps.setInt(6, schedule.getStatus());
            ps.setInt(7, schedule.getScheduleId());
            return ps.executeUpdate();
        } finally {
            DBUtil.closeAll(conn, ps, null);
        }
    }
    
    /**
     * 增加预约数（使用乐观锁）
     * 
     * @param scheduleId 排班ID
     * @return 影响的行数
     * @throws SQLException SQL异常
     */
    public int incrementPatientCount(Integer scheduleId) throws SQLException {
        String sql = "UPDATE schedule SET current_patients = current_patients + 1, " +
                     "status = CASE WHEN current_patients + 1 >= max_patients THEN 0 ELSE status END, " +
                     "update_time = NOW() " +
                     "WHERE schedule_id = ? AND current_patients < max_patients AND status = 1";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, scheduleId);
            return ps.executeUpdate();
        } finally {
            DBUtil.closeAll(conn, ps, null);
        }
    }
    
    /**
     * 减少预约数
     * 
     * @param scheduleId 排班ID
     * @return 影响的行数
     * @throws SQLException SQL异常
     */
    public int decrementPatientCount(Integer scheduleId) throws SQLException {
        String sql = "UPDATE schedule SET current_patients = CASE WHEN current_patients > 0 THEN current_patients - 1 ELSE 0 END, " +
                     "status = CASE WHEN current_patients > 0 THEN 1 ELSE status END, " +
                     "update_time = NOW() " +
                     "WHERE schedule_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, scheduleId);
            return ps.executeUpdate();
        } finally {
            DBUtil.closeAll(conn, ps, null);
        }
    }
    
    /**
     * 删除排班
     * 
     * @param scheduleId 排班ID
     * @return 影响的行数
     * @throws SQLException SQL异常
     */
    public int delete(Integer scheduleId) throws SQLException {
        String sql = "DELETE FROM schedule WHERE schedule_id = ? AND current_patients = 0";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, scheduleId);
            return ps.executeUpdate();
        } finally {
            DBUtil.closeAll(conn, ps, null);
        }
    }
    
    /**
     * 根据ID查询排班
     * 
     * @param scheduleId 排班ID
     * @return 排班对象
     * @throws SQLException SQL异常
     */
    public Schedule findById(Integer scheduleId) throws SQLException {
        String sql = "SELECT s.*, d.name as doctor_name, d.title as doctor_title, dept.dept_name " +
                     "FROM schedule s " +
                     "LEFT JOIN doctor d ON s.doctor_id = d.doctor_id " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "WHERE s.schedule_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, scheduleId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToSchedule(rs);
            }
            return null;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 根据医生ID和日期查询排班
     * 
     * @param doctorId 医生ID
     * @param date 日期
     * @return 排班列表
     * @throws SQLException SQL异常
     */
    public List<Schedule> findByDoctorAndDate(String doctorId, Date date) throws SQLException {
        String sql = "SELECT s.*, d.name as doctor_name, d.title as doctor_title, dept.dept_name " +
                     "FROM schedule s " +
                     "LEFT JOIN doctor d ON s.doctor_id = d.doctor_id " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "WHERE s.doctor_id = ? AND s.schedule_date = ? " +
                     "ORDER BY s.time_slot";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Schedule> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, doctorId);
            ps.setDate(2, new java.sql.Date(date.getTime()));
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToSchedule(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 根据医生ID查询日期范围内的排班
     * 
     * @param doctorId 医生ID
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 排班列表
     * @throws SQLException SQL异常
     */
    public List<Schedule> findByDoctorAndDateRange(String doctorId, Date startDate, Date endDate) throws SQLException {
        String sql = "SELECT s.*, d.name as doctor_name, d.title as doctor_title, dept.dept_name " +
                     "FROM schedule s " +
                     "LEFT JOIN doctor d ON s.doctor_id = d.doctor_id " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "WHERE s.doctor_id = ? AND s.schedule_date BETWEEN ? AND ? " +
                     "ORDER BY s.schedule_date, s.time_slot";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Schedule> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, doctorId);
            ps.setDate(2, new java.sql.Date(startDate.getTime()));
            ps.setDate(3, new java.sql.Date(endDate.getTime()));
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToSchedule(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 查询医生某日期可预约的排班
     * 
     * @param doctorId 医生ID
     * @param date 日期
     * @return 排班列表
     * @throws SQLException SQL异常
     */
    public List<Schedule> findAvailableByDoctorAndDate(String doctorId, Date date) throws SQLException {
        String sql = "SELECT s.*, d.name as doctor_name, d.title as doctor_title, dept.dept_name " +
                     "FROM schedule s " +
                     "LEFT JOIN doctor d ON s.doctor_id = d.doctor_id " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "WHERE s.doctor_id = ? AND s.schedule_date = ? AND s.status = 1 " +
                     "AND s.current_patients < s.max_patients " +
                     "ORDER BY s.time_slot";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Schedule> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, doctorId);
            ps.setDate(2, new java.sql.Date(date.getTime()));
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToSchedule(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }

    /**
     * 查询医生所有可预约的排班（未来）
     * 
     * @param doctorId 医生ID
     * @return 排班列表
     * @throws SQLException SQL异常
     */
    public List<Schedule> findAvailableByDoctor(String doctorId) throws SQLException {
        String sql = "SELECT s.*, d.name as doctor_name, d.title as doctor_title, dept.dept_name " +
                     "FROM schedule s " +
                     "LEFT JOIN doctor d ON s.doctor_id = d.doctor_id " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "WHERE s.doctor_id = ? AND s.schedule_date >= CURDATE() AND s.status = 1 " +
                     "AND s.current_patients < s.max_patients " +
                     "ORDER BY s.schedule_date, s.time_slot";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Schedule> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, doctorId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToSchedule(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * 查询医生的排班
     * 
     * @param doctorId 医生ID
     * @return 排班列表
     * @throws SQLException SQL异常
     */
    public List<Schedule> findByDoctorId(String doctorId) throws SQLException {
        String sql = "SELECT s.*, d.name as doctor_name, d.title as doctor_title, dept.dept_name " +
                     "FROM schedule s " +
                     "LEFT JOIN doctor d ON s.doctor_id = d.doctor_id " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "WHERE s.doctor_id = ? " +
                     "ORDER BY s.schedule_date, s.time_slot";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Schedule> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, doctorId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToSchedule(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }

    /**
     * 检查排班是否存在
     * 
     * @param doctorId 医生ID
     * @param date 日期
     * @param timeSlot 时间段
     * @return true-存在, false-不存在
     * @throws SQLException SQL异常
     */
    public boolean exists(String doctorId, Date date, String timeSlot) throws SQLException {
        String sql = "SELECT COUNT(*) FROM schedule WHERE doctor_id = ? AND schedule_date = ? AND time_slot = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, doctorId);
            ps.setDate(2, new java.sql.Date(date.getTime()));
            ps.setString(3, timeSlot);
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
     * 查询所有排班
     * 
     * @return 排班列表
     * @throws SQLException SQL异常
     */
    public List<Schedule> findAll() throws SQLException {
        String sql = "SELECT s.*, d.name as doctor_name, d.title as doctor_title, dept.dept_name " +
                     "FROM schedule s " +
                     "LEFT JOIN doctor d ON s.doctor_id = d.doctor_id " +
                     "LEFT JOIN department dept ON d.dept_id = dept.dept_id " +
                     "WHERE s.schedule_date >= CURDATE() " +
                     "ORDER BY s.schedule_date, s.time_slot";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Schedule> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToSchedule(rs));
            }
            return list;
        } finally {
            DBUtil.closeAll(conn, ps, rs);
        }
    }
    
    /**
     * ResultSet映射到Schedule对象
     * 
     * @param rs ResultSet
     * @return Schedule对象
     * @throws SQLException SQL异常
     */
    private Schedule mapResultSetToSchedule(ResultSet rs) throws SQLException {
        Schedule schedule = new Schedule();
        schedule.setScheduleId(rs.getInt("schedule_id"));
        schedule.setDoctorId(rs.getString("doctor_id"));
        schedule.setScheduleDate(rs.getDate("schedule_date"));
        schedule.setTimeSlot(rs.getString("time_slot"));
        schedule.setMaxPatients(rs.getInt("max_patients"));
        schedule.setCurrentPatients(rs.getInt("current_patients"));
        schedule.setStatus(rs.getInt("status"));
        schedule.setCreateTime(rs.getTimestamp("create_time"));
        schedule.setUpdateTime(rs.getTimestamp("update_time"));
        // 关联字段
        try {
            schedule.setDoctorName(rs.getString("doctor_name"));
            schedule.setDeptName(rs.getString("dept_name"));
            schedule.setDoctorTitle(rs.getString("doctor_title"));
        } catch (SQLException e) {
            // 忽略
        }
        return schedule;
    }
}
