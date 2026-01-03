package com.pegasus.hospital.servlet;

import com.pegasus.hospital.entity.Department;
import com.pegasus.hospital.service.DepartmentService;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 科室Servlet
 * 处理科室相关的查询请求
 * 
 * @author Pegasus Hospital Team
 * @version 1.0
 */
public class DepartmentServlet extends HttpServlet {
    
    private DepartmentService departmentService = new DepartmentService();
    private Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        // 判断是否是Ajax请求
        String accept = request.getHeader("Accept");
        boolean isAjax = accept != null && accept.contains("application/json");
        
        switch (action) {
            case "list":
                if (isAjax) {
                    listDepartmentsJson(request, response);
                } else {
                    listDepartments(request, response);
                }
                break;
            case "detail":
                if (isAjax) {
                    getDepartmentJson(request, response);
                } else {
                    getDepartment(request, response);
                }
                break;
            default:
                if (isAjax) {
                    listDepartmentsJson(request, response);
                } else {
                    listDepartments(request, response);
                }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * 查询所有科室（页面）
     */
    private void listDepartments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Department> departments = departmentService.findAll();
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/department/list.jsp").forward(request, response);
    }
    
    /**
     * 查询所有科室（JSON）
     */
    private void listDepartmentsJson(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        List<Department> departments = departmentService.findAll();
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", departments);
        
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * 查询科室详情（页面）
     */
    private void getDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String deptIdStr = request.getParameter("id");
        if (deptIdStr == null || deptIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "缺少科室ID参数");
            return;
        }
        
        try {
            Integer deptId = Integer.parseInt(deptIdStr);
            Department department = departmentService.findById(deptId);
            
            if (department == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "科室不存在");
                return;
            }
            
            request.setAttribute("department", department);
            request.getRequestDispatcher("/department/detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "科室ID格式错误");
        }
    }
    
    /**
     * 查询科室详情（JSON）
     */
    private void getDepartmentJson(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        String deptIdStr = request.getParameter("id");
        if (deptIdStr == null || deptIdStr.isEmpty()) {
            result.put("success", false);
            result.put("message", "缺少科室ID参数");
            out.print(gson.toJson(result));
            out.flush();
            return;
        }
        
        try {
            Integer deptId = Integer.parseInt(deptIdStr);
            Department department = departmentService.findById(deptId);
            
            if (department == null) {
                result.put("success", false);
                result.put("message", "科室不存在");
            } else {
                result.put("success", true);
                result.put("data", department);
            }
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "科室ID格式错误");
        }
        
        out.print(gson.toJson(result));
        out.flush();
    }
}
