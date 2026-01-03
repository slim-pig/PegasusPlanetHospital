package com.pegasus.hospital.service;

import com.pegasus.hospital.dao.PatientDAO;
import com.pegasus.hospital.entity.Patient;
import com.pegasus.hospital.util.CommonUtil;
import com.pegasus.hospital.util.DBUtil;

import java.sql.SQLException;
import java.util.List;

/**
 * 患者服务类
 * 处理患者相关的业务逻辑
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class PatientService {
    
    private PatientDAO patientDAO = new PatientDAO();
    
    /**
     * 患者注册
     * 年满10岁的飞马人可以申请注册
     * 
     * @param name 姓名
     * @param password 密码
     * @param idCard 身份证号
     * @param phone 手机号
     * @return 注册结果信息
     */
    public String register(String name, String password, String idCard, String phone) {
        try {
            // 验证姓名
            if (CommonUtil.isEmpty(name) || name.length() > 20) {
                return "姓名不能为空且不能超过20个字符";
            }
            
            // 验证密码
            if (!CommonUtil.isValidPassword(password)) {
                return "密码不能少于4位";
            }
            
            // 验证身份证号
            if (!CommonUtil.isValidIdCard(idCard)) {
                return "身份证号格式不正确（应为18位）";
            }
            
            // 验证年龄（年满10岁）
            int age = CommonUtil.getAgeByIdCard(idCard);
            if (age < 10) {
                return "年龄未满10岁，不能注册";
            }
            
            // 验证手机号
            if (!CommonUtil.isValidPhone(phone)) {
                return "手机号格式不正确";
            }
            
            // 检查身份证号是否已注册
            if (patientDAO.idCardExists(idCard)) {
                return "该身份证号已注册";
            }
            
            // 生成患者ID
            String patientId;
            do {
                patientId = CommonUtil.generatePatientId();
            } while (patientDAO.exists(patientId));
            
            // 创建患者对象
            Patient patient = new Patient();
            patient.setPatientId(patientId);
            patient.setName(name);
            patient.setPassword(CommonUtil.md5(password));
            patient.setIdCard(idCard);
            patient.setPhone(phone);
            patient.setGender(CommonUtil.getGenderByIdCard(idCard));
            patient.setBirthday(CommonUtil.getBirthdayByIdCard(idCard));
            patient.setStatus(1);
            
            // 保存到数据库
            int result = patientDAO.insert(patient);
            if (result > 0) {
                return "SUCCESS:" + patientId;
            } else {
                return "注册失败，请稍后重试";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "系统错误：" + e.getMessage();
        }
    }
    
    /**
     * 检查手机号是否已注册
     * 
     * @param phone 手机号
     * @return true-已注册, false-未注册
     */
    public boolean isPhoneExists(String phone) {
        try {
            return patientDAO.phoneExists(phone);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 患者登录
     * 
     * @param patientId 患者ID
     * @param password 密码
     * @return 患者对象或null
     */
    public Patient login(String patientId, String password) {
        try {
            if (CommonUtil.isEmpty(patientId) || CommonUtil.isEmpty(password)) {
                return null;
            }
            String encryptedPassword = CommonUtil.md5(password);
            return patientDAO.login(patientId, encryptedPassword);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 注销账号
     * 
     * @param patientId 患者ID
     * @param password 密码（验证身份）
     * @return 操作结果
     */
    public boolean deactivate(String patientId, String password) {
        try {
            // 验证密码
            Patient patient = login(patientId, password);
            if (patient == null) {
                return false;
            }
            return patientDAO.deactivate(patientId) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 注销账号 (无需密码验证)
     * 
     * @param patientId 患者ID
     * @return 操作结果
     */
    public boolean deactivate(String patientId) {
        try {
            return patientDAO.deactivate(patientId) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 修改患者信息
     * ID和身份证号不可修改
     * 
     * @param patient 患者对象
     * @return 操作结果
     */
    public String updateInfo(Patient patient) {
        try {
            // 验证姓名
            if (CommonUtil.isEmpty(patient.getName()) || patient.getName().length() > 20) {
                return "姓名不能为空且不能超过20个字符";
            }
            
            // 验证手机号
            if (!CommonUtil.isValidPhone(patient.getPhone())) {
                return "手机号格式不正确";
            }
            
            // 验证性别
            if ("男".equals(patient.getGender())) {
                patient.setGender("M");
            } else if ("女".equals(patient.getGender())) {
                patient.setGender("F");
            }
            
            if (!"M".equals(patient.getGender()) && !"F".equals(patient.getGender())) {
                return "性别格式不正确";
            }
            
            // 验证邮箱
            if (CommonUtil.isNotEmpty(patient.getEmail()) && !CommonUtil.isValidEmail(patient.getEmail())) {
                return "邮箱格式不正确";
            }
            
            int result = patientDAO.update(patient);
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
     * @param patientId 患者ID
     * @param oldPassword 旧密码
     * @param newPassword 新密码
     * @return 操作结果
     */
    public String changePassword(String patientId, String oldPassword, String newPassword) {
        try {
            // 验证旧密码
            Patient patient = login(patientId, oldPassword);
            if (patient == null) {
                return "原密码错误";
            }
            
            // 验证新密码
            if (!CommonUtil.isValidPassword(newPassword)) {
                return "新密码不能少于4位";
            }
            
            int result = patientDAO.updatePassword(patientId, CommonUtil.md5(newPassword));
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
     * 根据ID查询患者
     * 
     * @param patientId 患者ID
     * @return 患者对象
     */
    public Patient findById(String patientId) {
        try {
            return patientDAO.findById(patientId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 根据身份证号查询患者
     * 
     * @param idCard 身份证号
     * @return 患者对象
     */
    public Patient findByIdCard(String idCard) {
        try {
            return patientDAO.findByIdCard(idCard);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 查询所有患者
     * 
     * @return 患者列表
     */
    public List<Patient> findAll() {
        try {
            return patientDAO.findAll();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 分页查询患者
     * 
     * @param page 页码
     * @param pageSize 每页数量
     * @return 患者列表
     */
    public List<Patient> findByPage(int page, int pageSize) {
        try {
            return patientDAO.findByPage(page, pageSize);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 统计患者总数
     * 
     * @return 患者总数
     */
    public int count() {
        try {
            return patientDAO.count();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 统计患者总数 (Alias for count)
     * 
     * @return 数量
     */
    public int countAll() {
        return count();
    }

    /**
     * 分页查询所有患者 (Alias for findByPage)
     * 
     * @param page 页码
     * @param pageSize 每页数量
     * @return 患者列表
     */
    public List<Patient> findAll(int page, int pageSize) {
        return findByPage(page, pageSize);
    }

    /**
     * 搜索患者
     * 
     * @param keyword 关键字
     * @param page 页码
     * @param pageSize 每页数量
     * @return 患者列表
     */
    public List<Patient> search(String keyword, int page, int pageSize) {
        try {
            return patientDAO.search(keyword, page, pageSize);
        } catch (SQLException e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    /**
     * 统计搜索结果数量
     * 
     * @param keyword 关键字
     * @return 数量
     */
    public int countByKeyword(String keyword) {
        try {
            return patientDAO.countByKeyword(keyword);
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
}
