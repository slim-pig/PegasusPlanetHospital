<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>数据导入 - 飞马星球医院</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        /* ============================
           数据导入页专属样式
           ============================ */
        :root {
            --bg-color: #f1f5f9;
            --card-bg: #ffffff;
            --text-main: #1e293b;
            --text-sub: #64748b;
            --border-color: #e2e8f0;
            --primary-color: #3b82f6;
            --success-color: #10b981;
            --radius: 12px;
            --shadow-card: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
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
            padding: 40px;
            overflow-y: auto;
            background-color: var(--bg-color);
        }

        /* 头部区域 */
        .page-header {
            margin-bottom: 30px;
        }
        .page-title h2 {
            font-size: 1.75rem;
            color: var(--text-main);
            font-weight: 700;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .page-title p {
            color: var(--text-sub);
            font-size: 0.95rem;
        }

        /* 网格布局 */
        .import-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 30px;
        }

        /* 卡片样式 */
        .card {
            background: var(--card-bg);
            border-radius: var(--radius);
            box-shadow: var(--shadow-card);
            border: 1px solid var(--border-color);
            overflow: hidden;
            transition: transform 0.2s;
        }
        .card:hover {
            transform: translateY(-2px);
        }

        .card-header {
            padding: 24px;
            border-bottom: 1px solid var(--border-color);
            background: #f8fafc;
        }
        .card-title {
            margin: 0;
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-main);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .card-body {
            padding: 30px;
        }

        /* 上传区域核心样式 */
        .upload-area {
            border: 2px dashed #cbd5e1;
            border-radius: 12px;
            padding: 40px 20px;
            text-align: center;
            background: #f8fafc;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .upload-area:hover {
            border-color: var(--primary-color);
            background: #eff6ff;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.1);
        }

        .upload-icon-wrapper {
            width: 80px;
            height: 80px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            transition: transform 0.3s;
        }
        .upload-area:hover .upload-icon-wrapper {
            transform: scale(1.1);
        }

        .upload-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-main);
            margin-bottom: 8px;
        }
        .upload-desc {
            color: var(--text-sub);
            font-size: 0.85rem;
        }

        /* 模板说明区域 */
        .template-info {
            margin-top: 25px;
            background: #f1f5f9;
            border-radius: 8px;
            padding: 20px;
            border: 1px solid var(--border-color);
        }
        .info-title {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-main);
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .info-list {
            list-style: none;
            padding: 0;
            margin: 0;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
        }
        .info-item {
            font-size: 0.85rem;
            color: var(--text-sub);
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .info-item::before {
            content: '';
            width: 4px;
            height: 4px;
            background: #94a3b8;
            border-radius: 50%;
        }

        /* 提示框 */
        .alert {
            padding: 16px 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 0.95rem;
            border: 1px solid transparent;
        }
        .alert-success {
            background-color: #f0fdf4;
            color: #166534;
            border-color: #bbf7d0;
        }
        .alert-danger {
            background-color: #fef2f2;
            color: #991b1b;
            border-color: #fecaca;
        }

        /* 响应式 */
        @media (max-width: 900px) {
            .import-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="sidebar.jsp" />
        
        <div class="admin-content">
            <div class="page-header">
                <div class="page-title">
                    <h2><i class="fas fa-cloud-upload-alt" style="color: var(--primary-color);"></i> 数据导入中心</h2>
                    <p>支持批量导入医生信息与排班计划，请使用标准的 Excel 模板格式。</p>
                </div>
            </div>
            
            <c:if test="${not empty message}">
                <div class="alert alert-${success ? 'success' : 'danger'}">
                    <i class="fas fa-${success ? 'check-circle' : 'exclamation-triangle'}"></i> 
                    <span>${message}</span>
                </div>
            </c:if>
            
            <div class="import-grid">
                
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-user-md" style="color: var(--primary-color);"></i> 导入医生数据
                        </h3>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin?action=importDoctors" method="post" enctype="multipart/form-data">
                            <div class="upload-area" onclick="document.getElementById('doctorFile').click()">
                                <div class="upload-icon-wrapper">
                                    <i class="fas fa-file-excel" style="font-size: 32px; color: var(--primary-color);"></i>
                                </div>
                                <h4 class="upload-title">点击或拖拽上传 Excel</h4>
                                <p class="upload-desc">支持格式：.xls, .xlsx (最大 5MB)</p>
                                <input type="file" id="doctorFile" name="file" style="display: none;" accept=".xls,.xlsx" onchange="this.form.submit()">
                            </div>
                        </form>
                        
                        <div class="template-info">
                            <div class="info-title">
                                <i class="fas fa-info-circle"></i> 字段格式要求
                            </div>
                            <ul class="info-list">
                                <li class="info-item">A列: 姓名</li>
                                <li class="info-item">B列: 性别</li>
                                <li class="info-item">C列: 科室ID</li>
                                <li class="info-item">D列: 职称</li>
                                <li class="info-item">E列: 电话</li>
                                <li class="info-item">F列: 邮箱</li>
                                <li class="info-item">G列: 擅长领域</li>
                            </ul>
                        </div>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-calendar-alt" style="color: var(--success-color);"></i> 导入排班数据
                        </h3>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin?action=importSchedules" method="post" enctype="multipart/form-data">
                            <div class="upload-area" onclick="document.getElementById('scheduleFile').click()" style="border-color: #d1fae5;">
                                <div class="upload-icon-wrapper">
                                    <i class="fas fa-clock" style="font-size: 32px; color: var(--success-color);"></i>
                                </div>
                                <h4 class="upload-title">点击或拖拽上传 Excel</h4>
                                <p class="upload-desc">支持格式：.xls, .xlsx (最大 5MB)</p>
                                <input type="file" id="scheduleFile" name="file" style="display: none;" accept=".xls,.xlsx" onchange="this.form.submit()">
                            </div>
                        </form>
                        
                        <div class="template-info">
                            <div class="info-title">
                                <i class="fas fa-info-circle"></i> 字段格式要求
                            </div>
                            <ul class="info-list">
                                <li class="info-item">A列: 医生ID</li>
                                <li class="info-item">B列: 日期 (yyyy-MM-dd)</li>
                                <li class="info-item">C列: 时段 (09:00-09:30)</li>
                                <li class="info-item">D列: 号源数量</li>
                            </ul>
                        </div>
                    </div>
                </div>
                
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>