package com.pegasus.hospital.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

/**
 * 数据库工具类
 * 使用HikariCP连接池管理数据库连接
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class DBUtil {
    
    /** 数据源（连接池） */
    private static HikariDataSource dataSource;
    
    /** ThreadLocal存储当前线程的数据库连接（用于事务管理） */
    private static ThreadLocal<Connection> connectionHolder = new ThreadLocal<>();
    
    // 静态代码块，初始化数据库连接池
    static {
        try {
            initDataSource();
        } catch (Throwable e) {
            System.err.println("==========================================");
            System.err.println("FATAL ERROR: 数据库连接池初始化失败");
            System.err.println("错误信息: " + e.getMessage());
            e.printStackTrace();
            System.err.println("==========================================");
            throw new RuntimeException("数据库连接池初始化失败: " + e.getMessage(), e);
        }
    }
    
    /**
     * 初始化数据源
     */
    private static void initDataSource() throws IOException {
        Properties props = new Properties();
        InputStream is = DBUtil.class.getClassLoader().getResourceAsStream("db.properties");
        
        if (is == null) {
            throw new IOException("找不到数据库配置文件 db.properties");
        }
        
        props.load(is);
        is.close();
        
        // 配置HikariCP连接池
        HikariConfig config = new HikariConfig();
        config.setDriverClassName(props.getProperty("db.driver"));
        config.setJdbcUrl(props.getProperty("db.url"));
        config.setUsername(props.getProperty("db.username"));
        config.setPassword(props.getProperty("db.password"));
        
        // 连接池配置
        config.setMaximumPoolSize(Integer.parseInt(props.getProperty("db.pool.maxSize", "20")));
        config.setMinimumIdle(Integer.parseInt(props.getProperty("db.pool.minIdle", "5")));
        config.setConnectionTimeout(Long.parseLong(props.getProperty("db.pool.connectionTimeout", "30000")));
        config.setIdleTimeout(Long.parseLong(props.getProperty("db.pool.idleTimeout", "600000")));
        config.setMaxLifetime(Long.parseLong(props.getProperty("db.pool.maxLifetime", "1800000")));
        
        // 其他优化配置
        config.setPoolName("PegasusHospitalPool");
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
        config.addDataSourceProperty("useServerPrepStmts", "true");
        
        dataSource = new HikariDataSource(config);
        
        System.out.println("数据库连接池初始化成功！");
    }
    
    /**
     * 获取数据库连接
     * 如果当前线程已有连接（事务中），则返回该连接
     * 
     * @return 数据库连接
     * @throws SQLException SQL异常
     */
    public static Connection getConnection() throws SQLException {
        // 先检查ThreadLocal中是否有连接（事务场景）
        Connection conn = connectionHolder.get();
        if (conn != null && !conn.isClosed()) {
            return conn;
        }
        
        // 从连接池获取新连接
        return dataSource.getConnection();
    }
    
    /**
     * 开启事务
     * 
     * @throws SQLException SQL异常
     */
    public static void beginTransaction() throws SQLException {
        Connection conn = dataSource.getConnection();
        conn.setAutoCommit(false);
        connectionHolder.set(conn);
    }
    
    /**
     * 提交事务
     * 
     * @throws SQLException SQL异常
     */
    public static void commit() throws SQLException {
        Connection conn = connectionHolder.get();
        if (conn != null) {
            try {
                conn.commit();
            } finally {
                conn.setAutoCommit(true);
                closeConnection(conn);
                connectionHolder.remove();
            }
        }
    }
    
    /**
     * 回滚事务
     */
    public static void rollback() {
        Connection conn = connectionHolder.get();
        if (conn != null) {
            try {
                conn.rollback();
                conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                closeConnection(conn);
                connectionHolder.remove();
            }
        }
    }
    
    /**
     * 关闭数据库连接
     * 如果是事务中的连接，不关闭（由事务管理）
     * 
     * @param conn 数据库连接
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            // 如果是事务中的连接，不关闭
            if (conn == connectionHolder.get()) {
                return;
            }
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * 关闭PreparedStatement
     * 
     * @param ps PreparedStatement
     */
    public static void closeStatement(PreparedStatement ps) {
        if (ps != null) {
            try {
                ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * 关闭ResultSet
     * 
     * @param rs ResultSet
     */
    public static void closeResultSet(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * 关闭所有资源
     * 
     * @param conn 数据库连接
     * @param ps PreparedStatement
     * @param rs ResultSet
     */
    public static void closeAll(Connection conn, PreparedStatement ps, ResultSet rs) {
        closeResultSet(rs);
        closeStatement(ps);
        closeConnection(conn);
    }
    
    /**
     * 关闭数据源（在应用关闭时调用）
     */
    public static void closeDataSource() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            System.out.println("数据库连接池已关闭");
        }
    }
    
    /**
     * 测试数据库连接
     * 
     * @return true-连接成功, false-连接失败
     */
    public static boolean testConnection() {
        Connection conn = null;
        try {
            conn = getConnection();
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeConnection(conn);
        }
    }
}
