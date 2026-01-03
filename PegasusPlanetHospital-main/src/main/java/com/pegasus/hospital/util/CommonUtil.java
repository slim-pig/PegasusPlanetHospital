package com.pegasus.hospital.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Random;
import java.util.regex.Pattern;

/**
 * 通用工具类
 * 提供字符串处理、日期处理、加密等常用功能
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class CommonUtil {
    
    // 日期格式化器
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");
    private static final SimpleDateFormat DATETIME_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private static final SimpleDateFormat TIME_FORMAT = new SimpleDateFormat("HH:mm");
    
    // 正则表达式
    private static final Pattern PHONE_PATTERN = Pattern.compile("^1[3-9]\\d{9}$");
    private static final Pattern ID_CARD_PATTERN = Pattern.compile("^\\d{17}[\\dXx]$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$");
    
    /**
     * 判断字符串是否为空
     * 
     * @param str 字符串
     * @return true-为空, false-不为空
     */
    public static boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
    
    /**
     * 判断字符串是否不为空
     * 
     * @param str 字符串
     * @return true-不为空, false-为空
     */
    public static boolean isNotEmpty(String str) {
        return !isEmpty(str);
    }
    
    /**
     * MD5加密
     * 
     * @param str 原始字符串
     * @return 加密后的字符串
     */
    public static String md5(String str) {
        if (isEmpty(str)) {
            return null;
        }
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] bytes = md.digest(str.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                String hex = Integer.toHexString(b & 0xff);
                if (hex.length() == 1) {
                    sb.append("0");
                }
                sb.append(hex);
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 生成患者ID（10位数字）
     * 
     * @return 患者ID
     */
    public static String generatePatientId() {
        Random random = new Random();
        StringBuilder sb = new StringBuilder();
        // 第一位1-9
        sb.append(random.nextInt(9) + 1);
        // 后9位0-9
        for (int i = 0; i < 9; i++) {
            sb.append(random.nextInt(10));
        }
        return sb.toString();
    }
    
    /**
     * 生成医生ID（8位数字）
     * 
     * @return 医生ID
     */
    public static String generateDoctorId() {
        Random random = new Random();
        StringBuilder sb = new StringBuilder();
        // 第一位1-9
        sb.append(random.nextInt(9) + 1);
        // 后7位0-9
        for (int i = 0; i < 7; i++) {
            sb.append(random.nextInt(10));
        }
        return sb.toString();
    }
    
    /**
     * 生成预约号（12位数字）
     * 格式：年月日(8位) + 4位随机数
     * 
     * @return 预约号
     */
    public static String generateAppointmentId() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String dateStr = sdf.format(new Date());
        Random random = new Random();
        StringBuilder sb = new StringBuilder(dateStr);
        for (int i = 0; i < 4; i++) {
            sb.append(random.nextInt(10));
        }
        return sb.toString();
    }
    
    /**
     * 验证手机号格式
     * 
     * @param phone 手机号
     * @return true-格式正确, false-格式错误
     */
    public static boolean isValidPhone(String phone) {
        if (isEmpty(phone)) {
            return false;
        }
        return PHONE_PATTERN.matcher(phone).matches();
    }
    
    /**
     * 验证身份证号格式（简单验证18位）
     * 
     * @param idCard 身份证号
     * @return true-格式正确, false-格式错误
     */
    public static boolean isValidIdCard(String idCard) {
        if (isEmpty(idCard)) {
            return false;
        }
        return ID_CARD_PATTERN.matcher(idCard).matches();
    }
    
    /**
     * 验证邮箱格式
     * 
     * @param email 邮箱
     * @return true-格式正确, false-格式错误
     */
    public static boolean isValidEmail(String email) {
        if (isEmpty(email)) {
            return true; // 邮箱非必填
        }
        return EMAIL_PATTERN.matcher(email).matches();
    }
    
    /**
     * 验证密码格式（不少于4位）
     * 
     * @param password 密码
     * @return true-格式正确, false-格式错误
     */
    public static boolean isValidPassword(String password) {
        return isNotEmpty(password) && password.length() >= 4;
    }
    
    /**
     * 验证患者ID格式（10位数字）
     * 
     * @param patientId 患者ID
     * @return true-格式正确, false-格式错误
     */
    public static boolean isValidPatientId(String patientId) {
        if (isEmpty(patientId)) {
            return false;
        }
        return patientId.matches("^\\d{10}$");
    }
    
    /**
     * 验证医生ID格式（8位数字）
     * 
     * @param doctorId 医生ID
     * @return true-格式正确, false-格式错误
     */
    public static boolean isValidDoctorId(String doctorId) {
        if (isEmpty(doctorId)) {
            return false;
        }
        return doctorId.matches("^\\d{8}$");
    }
    
    /**
     * 根据身份证号计算年龄
     * 
     * @param idCard 身份证号
     * @return 年龄
     */
    public static int getAgeByIdCard(String idCard) {
        if (!isValidIdCard(idCard)) {
            return 0;
        }
        String birthYear = idCard.substring(6, 10);
        int year = Integer.parseInt(birthYear);
        Calendar cal = Calendar.getInstance();
        int currentYear = cal.get(Calendar.YEAR);
        return currentYear - year;
    }
    
    /**
     * 根据身份证号获取性别
     * 
     * @param idCard 身份证号
     * @return M-男, F-女
     */
    public static String getGenderByIdCard(String idCard) {
        if (!isValidIdCard(idCard)) {
            return null;
        }
        int genderNum = Integer.parseInt(idCard.substring(16, 17));
        return genderNum % 2 == 1 ? "M" : "F";
    }
    
    /**
     * 根据身份证号获取出生日期
     * 
     * @param idCard 身份证号
     * @return 出生日期
     */
    public static Date getBirthdayByIdCard(String idCard) {
        if (!isValidIdCard(idCard)) {
            return null;
        }
        String birthStr = idCard.substring(6, 14);
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
            return sdf.parse(birthStr);
        } catch (ParseException e) {
            return null;
        }
    }
    
    /**
     * 格式化日期
     * 
     * @param date 日期
     * @return 格式化后的日期字符串 (yyyy-MM-dd)
     */
    public static String formatDate(Date date) {
        if (date == null) {
            return "";
        }
        synchronized (DATE_FORMAT) {
            return DATE_FORMAT.format(date);
        }
    }
    
    /**
     * 格式化日期时间
     * 
     * @param date 日期
     * @return 格式化后的日期时间字符串 (yyyy-MM-dd HH:mm:ss)
     */
    public static String formatDateTime(Date date) {
        if (date == null) {
            return "";
        }
        synchronized (DATETIME_FORMAT) {
            return DATETIME_FORMAT.format(date);
        }
    }
    
    /**
     * 解析日期字符串
     * 
     * @param dateStr 日期字符串 (yyyy-MM-dd)
     * @return 日期对象
     */
    public static Date parseDate(String dateStr) {
        if (isEmpty(dateStr)) {
            return null;
        }
        try {
            synchronized (DATE_FORMAT) {
                return DATE_FORMAT.parse(dateStr);
            }
        } catch (ParseException e) {
            return null;
        }
    }
    
    /**
     * 解析日期时间字符串
     * 
     * @param dateTimeStr 日期时间字符串 (yyyy-MM-dd HH:mm:ss)
     * @return 日期对象
     */
    public static Date parseDateTime(String dateTimeStr) {
        if (isEmpty(dateTimeStr)) {
            return null;
        }
        try {
            synchronized (DATETIME_FORMAT) {
                return DATETIME_FORMAT.parse(dateTimeStr);
            }
        } catch (ParseException e) {
            return null;
        }
    }
    
    /**
     * 获取指定天数后的日期
     * 
     * @param days 天数（正数为将来，负数为过去）
     * @return 日期
     */
    public static Date addDays(int days) {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, days);
        return cal.getTime();
    }
    
    /**
     * 获取指定日期加上指定天数后的日期
     * 
     * @param date 原日期
     * @param days 天数
     * @return 新日期
     */
    public static Date addDays(Date date, int days) {
        if (date == null) {
            return null;
        }
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.add(Calendar.DAY_OF_MONTH, days);
        return cal.getTime();
    }
    
    /**
     * 获取今天的开始时间（00:00:00）
     * 
     * @return 今天开始时间
     */
    public static Date getTodayStart() {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        return cal.getTime();
    }
    
    /**
     * 获取今天的结束时间（23:59:59）
     * 
     * @return 今天结束时间
     */
    public static Date getTodayEnd() {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 23);
        cal.set(Calendar.MINUTE, 59);
        cal.set(Calendar.SECOND, 59);
        cal.set(Calendar.MILLISECOND, 999);
        return cal.getTime();
    }
    
    /**
     * 获取本月第一天
     * 
     * @return 本月第一天
     */
    public static Date getMonthStart() {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.DAY_OF_MONTH, 1);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        return cal.getTime();
    }
    
    /**
     * 获取本月最后一天
     * 
     * @return 本月最后一天
     */
    public static Date getMonthEnd() {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
        cal.set(Calendar.HOUR_OF_DAY, 23);
        cal.set(Calendar.MINUTE, 59);
        cal.set(Calendar.SECOND, 59);
        cal.set(Calendar.MILLISECOND, 999);
        return cal.getTime();
    }
    
    /**
     * 获取星期几
     * 
     * @param date 日期
     * @return 星期几（中文）
     */
    public static String getDayOfWeek(Date date) {
        if (date == null) {
            return "";
        }
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        String[] weeks = {"星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"};
        return weeks[cal.get(Calendar.DAY_OF_WEEK) - 1];
    }
    
    /**
     * 脱敏处理 - 手机号
     * 
     * @param phone 手机号
     * @return 脱敏后的手机号 (138****8888)
     */
    public static String maskPhone(String phone) {
        if (isEmpty(phone) || phone.length() < 11) {
            return phone;
        }
        return phone.substring(0, 3) + "****" + phone.substring(7);
    }
    
    /**
     * 脱敏处理 - 身份证号
     * 
     * @param idCard 身份证号
     * @return 脱敏后的身份证号 (110***********1234)
     */
    public static String maskIdCard(String idCard) {
        if (isEmpty(idCard) || idCard.length() < 18) {
            return idCard;
        }
        return idCard.substring(0, 3) + "***********" + idCard.substring(14);
    }
    
    /**
     * 脱敏处理 - 姓名
     * 
     * @param name 姓名
     * @return 脱敏后的姓名 (张**)
     */
    public static String maskName(String name) {
        if (isEmpty(name)) {
            return name;
        }
        if (name.length() == 1) {
            return "*";
        }
        if (name.length() == 2) {
            return name.charAt(0) + "*";
        }
        StringBuilder sb = new StringBuilder();
        sb.append(name.charAt(0));
        for (int i = 1; i < name.length() - 1; i++) {
            sb.append("*");
        }
        sb.append(name.charAt(name.length() - 1));
        return sb.toString();
    }
}
