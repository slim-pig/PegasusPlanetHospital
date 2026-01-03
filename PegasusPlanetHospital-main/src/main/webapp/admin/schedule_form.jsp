<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty schedule ? '添加排班' : '编辑排班'} - 飞马星球医院</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        /* ============================
           排班表单专属样式
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
            --shadow-card: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
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

        /* 顶部导航 */
        .page-header {
            max-width: 700px;
            margin: 0 auto 24px;
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
            background: white;
            padding: 8px 16px;
            border-radius: 8px;
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
            max-width: 700px;
            margin: 0 auto;
            overflow: hidden;
            border: 1px solid var(--border-color);
        }

        .card-header {
            padding: 24px 32px;
            border-bottom: 1px solid var(--border-color);
            background: linear-gradient(to right, #f8fafc, #ffffff);
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

        /* 表单网格布局 */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
        }
        .form-full {
            grid-column: 1 / -1;
        }

        .form-group {
            margin-bottom: 5px;
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

        /* 输入框容器 */
        .input-wrapper {
            position: relative;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 16px 12px 40px; /* 左侧留出图标位置 */
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 0.95rem;
            color: var(--text-main);
            background-color: #fff;
            transition: all 0.2s;
            outline: none;
            appearance: none;
        }
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        /* 输入框内部图标 */
        .input-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            pointer-events: none;
            transition: color 0.2s;
        }
        .form-control:focus + .input-icon {
            color: var(--primary-color);
        }

        /* 下拉箭头自定义 */
        .select-arrow {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-sub);
            pointer-events: none;
            font-size: 0.8rem;
        }

        /* 提交按钮 */
        .form-actions {
            margin-top: 32px;
            padding-top: 24px;
            border-top: 1px solid var(--border-color);
            display: flex;
            justify-content: flex-end;
        }
        .btn-submit {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 12px 40px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 6px rgba(59, 130, 246, 0.2);
        }
        .btn-submit:hover {
            background-color: var(--primary-hover);
            transform: translateY(-1px);
            box-shadow: 0 6px 8px rgba(59, 130, 246, 0.3);
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
                <a href="${pageContext.request.contextPath}/admin?action=schedules" class="btn-back">
                    <i class="fas fa-arrow-left"></i> 返回排班列表
                </a>
            </div>
            
            <div class="form-card">
                <div class="card-header">
                    <h2 class="card-title">
                        <i class="fas ${empty schedule ? 'fa-calendar-plus' : 'fa-calendar-check'}" style="color: var(--primary-color);"></i>
                        ${empty schedule ? '新增排班计划' : '编辑排班信息'}
                    </h2>
                </div>
                
                <div class="card-body">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i> <span>${error}</span>
                        </div>
                    </c:if>
                    
                    <form action="${pageContext.request.contextPath}/admin" method="post" class="needs-validation">
                        <input type="hidden" name="action" value="${empty schedule ? 'addSchedule' : 'updateSchedule'}">
                        <c:if test="${not empty schedule}">
                            <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">
                        </c:if>
                        
                        <div class="form-grid">
                            <div class="form-group form-full">
                                <label for="doctorId" class="form-label required">执勤医生</label>
                                <div class="input-wrapper">
                                    <select class="form-control" id="doctorId" name="doctorId" required>
                                        <option value="">-- 请选择医生 --</option>
                                        <c:forEach items="${doctors}" var="doc">
                                            <option value="${doc.doctorId}" ${schedule.doctorId == doc.doctorId ? 'selected' : ''}>${doc.name} (${doc.deptName})</option>
                                        </c:forEach>
                                    </select>
                                    <i class="fas fa-user-md input-icon"></i>
                                    <i class="fas fa-chevron-down select-arrow"></i>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="scheduleDate" class="form-label required">排班日期</label>
                                <div class="input-wrapper">
                                    <input type="date" class="form-control" id="scheduleDate" name="scheduleDate" 
                                           value="${schedule.scheduleDate}" required style="padding-left: 40px;">
                                    <i class="fas fa-calendar-alt input-icon"></i>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="timeSlot" class="form-label required">工作时段</label>
                                <div class="input-wrapper">
                                    <select class="form-control" id="timeSlot" name="timeSlot" required>
                                        <option value="">-- 请选择时段 --</option>
                                        <optgroup label="上午时段">
                                            <option value="08:00-08:30" ${schedule.timeSlot == '08:00-08:30' ? 'selected' : ''}>08:00-08:30</option>
                                            <option value="08:30-09:00" ${schedule.timeSlot == '08:30-09:00' ? 'selected' : ''}>08:30-09:00</option>
                                            <option value="09:00-09:30" ${schedule.timeSlot == '09:00-09:30' ? 'selected' : ''}>09:00-09:30</option>
                                            <option value="09:30-10:00" ${schedule.timeSlot == '09:30-10:00' ? 'selected' : ''}>09:30-10:00</option>
                                            <option value="10:00-10:30" ${schedule.timeSlot == '10:00-10:30' ? 'selected' : ''}>10:00-10:30</option>
                                            <option value="10:30-11:00" ${schedule.timeSlot == '10:30-11:00' ? 'selected' : ''}>10:30-11:00</option>
                                            <option value="11:00-11:30" ${schedule.timeSlot == '11:00-11:30' ? 'selected' : ''}>11:00-11:30</option>
                                            <option value="11:30-12:00" ${schedule.timeSlot == '11:30-12:00' ? 'selected' : ''}>11:30-12:00</option>
                                        </optgroup>
                                        <optgroup label="下午时段">
                                            <option value="13:30-14:00" ${schedule.timeSlot == '13:30-14:00' ? 'selected' : ''}>13:30-14:00</option>
                                            <option value="14:00-14:30" ${schedule.timeSlot == '14:00-14:30' ? 'selected' : ''}>14:00-14:30</option>
                                            <option value="14:30-15:00" ${schedule.timeSlot == '14:30-15:00' ? 'selected' : ''}>14:30-15:00</option>
                                            <option value="15:00-15:30" ${schedule.timeSlot == '15:00-15:30' ? 'selected' : ''}>15:00-15:30</option>
                                            <option value="15:30-16:00" ${schedule.timeSlot == '15:30-16:00' ? 'selected' : ''}>15:30-16:00</option>
                                            <option value="16:00-16:30" ${schedule.timeSlot == '16:00-16:30' ? 'selected' : ''}>16:00-16:30</option>
                                            <option value="16:30-17:00" ${schedule.timeSlot == '16:30-17:00' ? 'selected' : ''}>16:30-17:00</option>
                                            <option value="17:00-17:30" ${schedule.timeSlot == '17:00-17:30' ? 'selected' : ''}>17:00-17:30</option>
                                        </optgroup>
                                    </select>
                                    <i class="fas fa-clock input-icon"></i>
                                    <i class="fas fa-chevron-down select-arrow"></i>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="maxPatients" class="form-label required">最大号源数</label>
                                <div class="input-wrapper">
                                    <input type="number" class="form-control" id="maxPatients" name="maxPatients" 
                                           value="${schedule.maxPatients != null ? schedule.maxPatients : 30}" 
                                           required min="1">
                                    <i class="fas fa-users input-icon"></i>
                                </div>
                            </div>
                            
                            <c:if test="${not empty schedule}">
                                <div class="form-group">
                                    <label for="status" class="form-label required">当前状态</label>
                                    <div class="input-wrapper">
                                        <select class="form-control" id="status" name="status" required>
                                            <option value="1" ${schedule.status == 1 ? 'selected' : ''}>可预约</option>
                                            <option value="0" ${schedule.status == 0 ? 'selected' : ''}>已满</option>
                                            <option value="-1" ${schedule.status == -1 ? 'selected' : ''}>停诊</option>
                                        </select>
                                        <i class="fas fa-toggle-on input-icon"></i>
                                        <i class="fas fa-chevron-down select-arrow"></i>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                        
                        <div class="form-actions">
                            <button type="submit" class="btn-submit">
                                <i class="fas fa-save"></i> 保存排班计划
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