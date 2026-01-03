package com.pegasus.hospital.service;

import com.pegasus.hospital.dao.DepartmentDAO;
import com.pegasus.hospital.entity.Department;
import com.pegasus.hospital.util.CommonUtil;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * 科室服务类
 * 处理科室相关的业务逻辑
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class DepartmentService {
    
    private DepartmentDAO departmentDAO = new DepartmentDAO();
    
    /**
     * 添加科室
     * 
     * @param department 科室对象
     * @return 操作结果
     */
    public String addDepartment(Department department) {
        try {
            // 验证科室名称
            if (CommonUtil.isEmpty(department.getDeptName()) || department.getDeptName().length() > 30) {
                return "科室名称不能为空且不能超过30个字符";
            }
            
            // 检查名称是否已存在
            if (departmentDAO.nameExists(department.getDeptName())) {
                return "该科室名称已存在";
            }
            
            department.setStatus(1);
            int deptId = departmentDAO.insert(department);
            if (deptId > 0) {
                return "SUCCESS:" + deptId;
            } else {
                return "添加失败，请稍后重试";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "系统错误：" + e.getMessage();
        }
    }
    
    /**
     * 更新科室信息
     * 
     * @param department 科室对象
     * @return 操作结果
     */
    public String updateDepartment(Department department) {
        try {
            // 验证科室名称
            if (CommonUtil.isEmpty(department.getDeptName()) || department.getDeptName().length() > 30) {
                return "科室名称不能为空且不能超过30个字符";
            }
            
            int result = departmentDAO.update(department);
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
     * 删除科室
     * 
     * @param deptId 科室ID
     * @return 操作结果
     */
    public boolean deleteDepartment(Integer deptId) {
        try {
            return departmentDAO.delete(deptId) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 根据ID查询科室
     * 
     * @param deptId 科室ID
     * @return 科室对象
     */
    public Department findById(Integer deptId) {
        try {
            return departmentDAO.findById(deptId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 根据名称查询科室
     * 
     * @param deptName 科室名称
     * @return 科室对象
     */
    public Department findByName(String deptName) {
        try {
            return departmentDAO.findByName(deptName);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 查询所有科室
     * 
     * @return 科室列表
     */
    public List<Department> findAll() {
        try {
            return departmentDAO.findAll();
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * 查询所有科室（包括停用）
     * 
     * @return 科室列表
     */
    public List<Department> findAllIncludeInactive() {
        try {
            return departmentDAO.findAllIncludeInactive();
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * 统计科室总数
     * 
     * @return 科室总数
     */
    public int count() {
        try {
            return departmentDAO.count();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
}
