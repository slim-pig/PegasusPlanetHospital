<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>患者管理 - 飞马星球医院</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        /* ============================
           患者管理页专属样式
           ============================ */
        :root {
            --bg-color: #f1f5f9;
            --card-bg: #ffffff;
            --text-main: #1e293b;
            --text-sub: #64748b;
            --border-color: #e2e8f0;
            --primary-color: #3b82f6;
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

        /* 顶部标题区 */
        .page-header {
            margin-bottom: 24px;
        }
        .page-title h2 {
            font-size: 1.5rem;
            color: var(--text-main);
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .page-subtitle {
            margin-top: 5px;
            color: var(--text-sub);
            font-size: 0.9rem;
            margin-left: 36px; /* 对齐图标 */
        }

        /* 筛选工具栏 */
        .filter-toolbar {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 16px 20px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
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

        /* 数据表格卡片 */
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

        /* 特殊列样式 */
        .col-id {
            font-family: 'Menlo', 'Monaco', 'Courier New', monospace;
            color: var(--text-sub);
            font-size: 0.85rem;
        }
        
        .patient-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .patient-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: #f1f5f9;
            color: #64748b;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.85rem;
        }
        .patient-name {
            font-weight: 600;
            color: var(--text-main);
        }

        .gender-tag {
            font-size: 0.85rem;
        }
        .gender-male { color: #3b82f6; }
        .gender-female { color: #ec4899; }

        .info-with-icon {
            display: flex;
            align-items: center;
            gap: 6px;
            color: var(--text-main);
        }
        .info-icon {
            color: var(--text-sub);
            font-size: 0.8rem;
        }

    </style>
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="sidebar.jsp" />
        
        <div class="admin-content">
            <div class="page-header">
                <div class="page-title">
                    <h2><i class="fas fa-users" style="color: var(--primary-color);"></i> 患者管理</h2>
                </div>
                <div class="page-subtitle">查看及管理所有注册患者的档案信息</div>
            </div>
            
            <div class="filter-toolbar">
                <form action="${pageContext.request.contextPath}/admin" method="get" class="search-form">
                    <input type="hidden" name="action" value="patients">
                    
                    <div style="position: relative; flex: 1; max-width: 400px;">
                        <input type="text" name="keyword" class="form-control" 
                               placeholder="输入患者姓名、手机号或身份证号..." 
                               value="${param.keyword}" 
                               style="width: 100%; padding-left: 35px;">
                        <i class="fas fa-search" style="position: absolute; left: 12px; top: 12px; color: #94a3b8;"></i>
                    </div>
                    
                    <button type="submit" class="btn-search">
                        搜索患者
                    </button>
                </form>
            </div>
            
            <div class="table-card">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID 编号</th>
                                <th>患者姓名</th>
                                <th>性别</th>
                                <th>出生日期</th>
                                <th>联系电话</th>
                                <th>身份证号</th>
                                <th>注册时间</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${patients}" var="patient">
                                <tr>
                                    <td class="col-id">#${patient.patientId}</td>
                                    <td>
                                        <div class="patient-info">
                                            <div class="patient-avatar">
                                                <i class="fas fa-user"></i>
                                            </div>
                                            <span class="patient-name">${patient.name}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="gender-tag ${patient.gender == 'M' || patient.gender == '男' ? 'gender-male' : 'gender-female'}">
                                            <i class="fas ${patient.gender == 'M' || patient.gender == '男' ? 'fa-male' : 'fa-venus'}"></i> 
                                            ${patient.gender == 'M' ? '男' : (patient.gender == 'F' ? '女' : patient.gender)}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="info-with-icon">
                                            <i class="fas fa-birthday-cake info-icon"></i>
                                            ${patient.birthday}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="info-with-icon">
                                            <i class="fas fa-phone-alt info-icon"></i>
                                            ${patient.phone}
                                        </div>
                                    </td>
                                    <td class="col-id">
                                        <i class="far fa-id-card info-icon" style="margin-right: 4px;"></i>
                                        ${patient.idCard}
                                    </td>
                                    <td style="color: var(--text-sub); font-size: 0.85rem;">
                                        ${patient.createTime}
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <%-- 空状态展示 --%>
                            <c:if test="${empty patients}">
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 50px; color: var(--text-sub);">
                                        <i class="fas fa-search-minus" style="font-size: 40px; margin-bottom: 10px; opacity: 0.5;"></i>
                                        <p>未找到匹配的患者档案</p>
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
</body>
</html>