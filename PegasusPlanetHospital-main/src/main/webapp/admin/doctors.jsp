<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>医生管理 - 飞马星球医院</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        /* ============================
           Doctor Management Page Styles
           ============================ */
        :root {
            --bg-color: #f1f5f9;
            --card-bg: #ffffff;
            --text-main: #1e293b;
            --text-sub: #64748b;
            --border-color: #e2e8f0;
            --primary-color: #3b82f6;
            --success-color: #10b981;
            --danger-color: #ef4444;
            --radius: 10px;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.05);
        }

        body {
            background-color: var(--bg-color);
            margin: 0;
            font-family: 'Inter', sans-serif;
        }

        .admin-layout {
            display: flex;
            min-height: 100vh;
        }

        .admin-content {
            flex: 1;
            padding: 30px 40px;
            overflow-y: auto;
            background-color: var(--bg-color);
        }

        /* Header Section */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }
        .page-title h2 {
            font-size: 1.5rem;
            color: var(--text-main);
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Action Buttons (Top Right) */
        .header-actions {
            display: flex;
            gap: 12px;
        }
        .btn-action {
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }
        .btn-primary:hover {
            background-color: #2563eb;
            transform: translateY(-1px);
        }
        .btn-success {
            background-color: var(--success-color); /* Import Green */
            color: white;
        }
        .btn-success:hover {
            background-color: #059669;
            transform: translateY(-1px);
        }

        /* Filter Toolbar */
        .filter-toolbar {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 16px 20px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            display: flex;
            align-items: center;
        }
        
        .search-form {
            display: flex;
            gap: 15px;
            align-items: center;
            width: 100%;
        }

        .form-control {
            padding: 10px 15px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 0.9rem;
            color: var(--text-main);
            background-color: #f8fafc;
            transition: all 0.2s;
            outline: none;
            box-sizing: border-box;
        }
        .form-control:focus {
            background-color: #fff;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .btn-search {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 10px 24px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: background 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-search:hover {
            background-color: #2563eb;
        }

        /* Table Card */
        .table-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            overflow: hidden;
        }

        .table-responsive {
            width: 100%;
            overflow-x: auto;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            white-space: nowrap;
        }

        .table th {
            background-color: #f8fafc;
            color: var(--text-sub);
            font-weight: 600;
            font-size: 0.85rem;
            text-align: left;
            padding: 16px 24px;
            border-bottom: 1px solid var(--border-color);
        }

        .table td {
            padding: 16px 24px;
            color: var(--text-main);
            font-size: 0.9rem;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }

        .table tbody tr:hover {
            background-color: #f8fafc;
        }
        .table tbody tr:last-child td {
            border-bottom: none;
        }

        /* Doctor Avatar/Icon Placeholder */
        .doctor-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: #eff6ff;
            color: var(--primary-color);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.85rem;
            margin-right: 10px;
        }

        /* Tags for Dept/Title */
        .tag {
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 500;
            display: inline-block;
        }
        .tag-dept {
            background: #f1f5f9;
            color: var(--text-sub);
            border: 1px solid #e2e8f0;
        }
        .tag-title {
            background: #fff7ed;
            color: #ea580c; /* Orange for title */
            border: 1px solid #ffedd5;
        }

        .gender-tag {
            font-size: 0.85rem;
        }
        .gender-male { color: #3b82f6; }
        .gender-female { color: #ec4899; }

        /* Action Buttons inside table */
        .action-group {
            display: flex;
            gap: 8px;
        }
        .btn-sm {
            padding: 6px 10px;
            border-radius: 6px;
            font-size: 0.8rem;
            cursor: pointer;
            border: 1px solid var(--border-color);
            background: white;
            color: var(--text-sub);
            display: inline-flex;
            align-items: center;
            gap: 4px;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-sm:hover {
            border-color: var(--primary-color);
            color: var(--primary-color);
        }
        .btn-sm-schedule {
            color: #0ea5e9; /* Sky blue */
            border-color: #e0f2fe;
            background: #f0f9ff;
        }
        .btn-sm-schedule:hover {
            background: #0ea5e9;
            color: white;
            border-color: #0ea5e9;
        }
        .btn-sm-delete {
            color: var(--danger-color);
            border-color: #fee2e2;
            background: #fef2f2;
        }
        .btn-sm-delete:hover {
            background: var(--danger-color);
            color: white;
            border-color: var(--danger-color);
        }

        /* Alerts */
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-success {
            background-color: #f0fdf4;
            color: #16a34a;
            border: 1px solid #dcfce7;
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="sidebar.jsp" />
        
        <div class="admin-content">
            <div class="page-header">
                <div class="page-title">
                    <h2><i class="fas fa-user-md" style="color: var(--primary-color);"></i> 医生管理</h2>
                </div>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/admin?action=doctorForm" class="btn-action btn-primary">
                        <i class="fas fa-plus"></i> 添加新医生
                    </a>
                    <a href="${pageContext.request.contextPath}/admin?action=import" class="btn-action btn-success">
                        <i class="fas fa-file-import"></i> 批量导入数据
                    </a>
                </div>
            </div>
            
            <c:if test="${not empty param.msg}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> 
                    <span>
                        <c:if test="${param.msg == 'addSuccess'}">医生信息添加成功！</c:if>
                        <c:if test="${param.msg == 'updateSuccess'}">医生信息更新成功！</c:if>
                    </span>
                </div>
            </c:if>
            
            <div class="filter-toolbar">
                <form action="${pageContext.request.contextPath}/admin" method="get" class="search-form">
                    <input type="hidden" name="action" value="doctors">
                    
                    <div style="position: relative; width: 220px;">
                        <select name="deptId" class="form-control" style="width: 100%; padding-left: 35px; appearance: none;" onchange="this.form.submit()">
                            <option value="">所有科室</option>
                            <c:forEach items="${departments}" var="dept">
                                <option value="${dept.deptId}" ${selectedDeptId == dept.deptId ? 'selected' : ''}>${dept.deptName}</option>
                            </c:forEach>
                        </select>
                        <i class="fas fa-filter" style="position: absolute; left: 12px; top: 12px; color: #94a3b8; pointer-events: none;"></i>
                        <i class="fas fa-chevron-down" style="position: absolute; right: 12px; top: 12px; font-size: 0.8rem; color: #94a3b8; pointer-events: none;"></i>
                    </div>
                    
                    <div style="position: relative; flex: 1; max-width: 400px;">
                        <input type="text" name="keyword" class="form-control" 
                               placeholder="搜索医生姓名或工号..." 
                               value="${keyword}" 
                               style="width: 100%; padding-left: 35px;">
                        <i class="fas fa-search" style="position: absolute; left: 12px; top: 12px; color: #94a3b8;"></i>
                    </div>
                    
                    <button type="submit" class="btn-search">
                        搜索
                    </button>
                </form>
            </div>
            
            <div class="table-card">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>工号 ID</th>
                                <th>医生姓名</th>
                                <th>性别</th>
                                <th>所属科室</th>
                                <th>专业职称</th>
                                <th>联系电话</th>
                                <th>操作管理</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${doctors}" var="doctor">
                                <tr>
                                    <td style="font-family: monospace; color: var(--text-sub);">#${doctor.doctorId}</td>
                                    <td>
                                        <div style="display: flex; align-items: center;">
                                            <div class="doctor-avatar">
                                                <i class="fas fa-user"></i>
                                            </div>
                                            <span style="font-weight: 600;">${doctor.name}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="gender-tag ${doctor.gender == 'M' || doctor.gender == '男' ? 'gender-male' : 'gender-female'}">
                                            <i class="fas ${doctor.gender == 'M' || doctor.gender == '男' ? 'fa-male' : 'fa-venus'}"></i> 
                                            ${doctor.gender == 'M' ? '男' : (doctor.gender == 'F' ? '女' : doctor.gender)}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="tag tag-dept">${doctor.deptName}</span>
                                    </td>
                                    <td>
                                        <span class="tag tag-title">${doctor.title}</span>
                                    </td>
                                    <td style="color: var(--text-sub);">
                                        <i class="fas fa-phone-alt" style="font-size: 0.8rem; margin-right: 4px;"></i> 
                                        ${doctor.phone}
                                    </td>
                                    <td>
                                        <div class="action-group">
                                            <a href="${pageContext.request.contextPath}/admin?action=doctorForm&id=${doctor.doctorId}" class="btn-sm" title="编辑信息">
                                                <i class="fas fa-edit"></i> 编辑
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin?action=schedules&doctorId=${doctor.doctorId}" class="btn-sm btn-sm-schedule" title="排班管理">
                                                <i class="fas fa-calendar-alt"></i> 排班
                                            </a>
                                            <button onclick="deleteDoctor('${doctor.doctorId}')" class="btn-sm btn-sm-delete" title="删除医生">
                                                <i class="fas fa-trash-alt"></i> 删除
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <%-- Empty State --%>
                            <c:if test="${empty doctors}">
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 40px; color: var(--text-sub);">
                                        <i class="fas fa-user-slash" style="font-size: 40px; margin-bottom: 10px; opacity: 0.5;"></i>
                                        <p>未找到相关医生记录，请尝试调整筛选条件。</p>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        function deleteDoctor(id) {
            if (confirm('警告：确定要删除该医生吗？\n\n此操作将同时删除该医生的排班信息，且不可恢复！')) {
                fetch('${pageContext.request.contextPath}/admin', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'Accept': 'application/json'
                    },
                    body: 'action=deleteDoctor&id=' + id
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Slight delay for better UX
                        setTimeout(() => location.reload(), 200);
                    } else {
                        alert('删除操作失败: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('网络请求失败，请检查服务器连接');
                });
            }
        }
    </script>
</body>
</html>