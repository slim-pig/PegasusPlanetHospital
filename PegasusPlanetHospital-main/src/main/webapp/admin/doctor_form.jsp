<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty doctor ? '添加医生' : '编辑医生'} - 飞马星球医院</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        /* ============================
           表单页专属样式
           ============================ */
        :root {
            --bg-color: #f1f5f9;
            --card-bg: #ffffff;
            --text-main: #1e293b;
            --text-sub: #64748b;
            --border-color: #e2e8f0;
            --primary-color: #3b82f6;
            --primary-hover: #2563eb;
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

        /* 顶部导航与标题 */
        .page-header {
            max-width: 800px;
            margin: 0 auto 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .btn-back {
            color: var(--text-sub);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            font-size: 0.95rem;
            transition: color 0.2s;
            padding: 8px 16px;
            border-radius: 8px;
            background: white;
            border: 1px solid var(--border-color);
            box-shadow: 0 1px 2px rgba(0,0,0,0.05);
        }
        .btn-back:hover {
            color: var(--primary-color);
            border-color: var(--primary-color);
        }

        /* 表单卡片 */
        .form-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            box-shadow: var(--shadow-card);
            max-width: 800px;
            margin: 0 auto;
            overflow: hidden;
            border: 1px solid var(--border-color);
        }

        .card-header {
            padding: 24px 32px;
            border-bottom: 1px solid var(--border-color);
            background: #f8fafc;
        }
        .card-title {
            margin: 0;
            font-size: 1.25rem;
            color: var(--text-main);
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-body {
            padding: 32px;
        }

        /* 表单布局 */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
        }
        .form-full {
            grid-column: 1 / -1;
        }

        .form-group {
            margin-bottom: 5px; /* 由grid gap控制间距，这里只做微调 */
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            color: var(--text-main);
            font-weight: 600;
            font-size: 0.9rem;
        }
        .required::after {
            content: "*";
            color: #ef4444;
            margin-left: 4px;
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 0.95rem;
            color: var(--text-main);
            background-color: #fff;
            transition: all 0.2s;
            outline: none;
            appearance: none; /* 移除默认下拉箭头 */
        }
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        
        /* 下拉框自定义箭头 */
        .select-wrapper {
            position: relative;
        }
        .select-wrapper::after {
            content: '\f107';
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-sub);
            pointer-events: none;
        }

        /* 性别选择：分段控制器样式 */
        .gender-group {
            display: flex;
            background: #f1f5f9;
            padding: 4px;
            border-radius: 8px;
            border: 1px solid var(--border-color);
        }
        .gender-option {
            flex: 1;
            position: relative;
        }
        .gender-option input[type="radio"] {
            position: absolute;
            opacity: 0;
            cursor: pointer;
            width: 100%;
            height: 100%;
            z-index: 2;
        }
        .gender-label {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 10px;
            border-radius: 6px;
            color: var(--text-sub);
            font-weight: 500;
            font-size: 0.95rem;
            transition: all 0.2s;
            cursor: pointer;
            gap: 8px;
        }
        .gender-option input:checked + .gender-label {
            background: white;
            color: var(--primary-color);
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            font-weight: 600;
        }
        .gender-option:hover .gender-label {
            color: var(--text-main);
        }

        /* 文本域 */
        textarea.form-control {
            resize: vertical;
            min-height: 120px;
            line-height: 1.6;
        }

        /* 按钮区 */
        .form-actions {
            margin-top: 32px;
            padding-top: 24px;
            border-top: 1px solid var(--border-color);
            display: flex;
            justify-content: flex-end;
            gap: 16px;
        }

        .btn-submit {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 12px 32px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: background 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-submit:hover {
            background-color: var(--primary-hover);
            transform: translateY(-1px);
            box-shadow: 0 4px 6px rgba(59, 130, 246, 0.25);
        }

        /* 错误提示 */
        .alert-danger {
            background: #fef2f2;
            border: 1px solid #fee2e2;
            color: #ef4444;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.95rem;
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="sidebar.jsp" />
        
        <div class="admin-content">
            <div class="page-header">
                <a href="${pageContext.request.contextPath}/admin?action=doctors" class="btn-back">
                    <i class="fas fa-arrow-left"></i> 返回医生列表
                </a>
            </div>
            
            <div class="form-card">
                <div class="card-header">
                    <h2 class="card-title">
                        <i class="fas ${empty doctor ? 'fa-user-plus' : 'fa-user-edit'}" style="color: var(--primary-color);"></i>
                        ${empty doctor ? '添加新医生' : '编辑医生信息'}
                    </h2>
                </div>
                
                <div class="card-body">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i> <span>${error}</span>
                        </div>
                    </c:if>
                    
                    <form action="${pageContext.request.contextPath}/admin" method="post" class="needs-validation">
                        <input type="hidden" name="action" value="${empty doctor ? 'addDoctor' : 'updateDoctor'}">
                        <c:if test="${not empty doctor}">
                            <input type="hidden" name="doctorId" value="${doctor.doctorId}">
                        </c:if>
                        
                        <div class="form-grid">
                            <div class="form-group form-full">
                                <label for="name" class="form-label required">医生姓名</label>
                                <input type="text" class="form-control" id="name" name="name" 
                                       value="${doctor.name}" placeholder="请输入医生真实姓名" required>
                            </div>
                            
                            <div class="form-group form-full">
                                <label class="form-label required">性别</label>
                                <div class="gender-group">
                                    <div class="gender-option">
                                        <input type="radio" name="gender" value="男" id="gender-male" ${empty doctor || doctor.gender == '男' ? 'checked' : ''}>
                                        <label for="gender-male" class="gender-label"><i class="fas fa-mars"></i> 男</label>
                                    </div>
                                    <div class="gender-option">
                                        <input type="radio" name="gender" value="女" id="gender-female" ${doctor.gender == '女' ? 'checked' : ''}>
                                        <label for="gender-female" class="gender-label"><i class="fas fa-venus"></i> 女</label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="deptId" class="form-label required">所属科室</label>
                                <div class="select-wrapper">
                                    <select class="form-control" id="deptId" name="deptId" required>
                                        <option value="">-- 请选择科室 --</option>
                                        <c:forEach items="${departments}" var="dept">
                                            <option value="${dept.deptId}" ${doctor.deptId == dept.deptId ? 'selected' : ''}>${dept.deptName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="title" class="form-label required">专业职称</label>
                                <div class="select-wrapper">
                                    <select class="form-control" id="title" name="title" required>
                                        <option value="住院医师" ${doctor.title == '住院医师' ? 'selected' : ''}>住院医师</option>
                                        <option value="主治医师" ${doctor.title == '主治医师' ? 'selected' : ''}>主治医师</option>
                                        <option value="副主任医师" ${doctor.title == '副主任医师' ? 'selected' : ''}>副主任医师</option>
                                        <option value="主任医师" ${doctor.title == '主任医师' ? 'selected' : ''}>主任医师</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="phone" class="form-label">联系电话</label>
                                <input type="text" class="form-control" id="phone" name="phone" 
                                       value="${doctor.phone}" placeholder="请输入联系方式">
                            </div>
                            
                            <div class="form-group">
                                <label for="email" class="form-label">电子邮箱</label>
                                <input type="email" class="form-control" id="email" name="email" 
                                       value="${doctor.email}" placeholder="example@pegasus.com">
                            </div>
                            
                            <div class="form-group form-full">
                                <label for="specialty" class="form-label">擅长领域 / 个人简介</label>
                                <textarea class="form-control" id="specialty" name="specialty" 
                                          placeholder="请输入医生的擅长领域、研究方向或个人简介..." rows="5">${doctor.specialty}</textarea>
                            </div>
                        </div>
                        
                        <div class="form-actions">
                            <button type="submit" class="btn-submit">
                                <i class="fas fa-save"></i> 保存提交
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>