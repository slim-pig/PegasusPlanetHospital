package com.pegasus.hospital.util;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class UpdateDB {
    public static void main(String[] args) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "ALTER TABLE patient ADD COLUMN balance DECIMAL(10,2) DEFAULT 0.00 COMMENT '账户余额'";
            stmt = conn.prepareStatement(sql);
            stmt.executeUpdate();
            System.out.println("Database updated successfully: Added balance column to patient table.");
        } catch (Exception e) {
            System.out.println("Error updating database: " + e.getMessage());
            // e.printStackTrace();
        } finally {
            DBUtil.closeAll(conn, stmt, null);
        }
    }
}
