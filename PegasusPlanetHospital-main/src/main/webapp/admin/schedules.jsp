<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>排班管理 - 飞马星球医院</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        /* ============================
           排班管理页专属样式
           ============================ */
        :root {
            --bg-color: #f1f5f9;
            --card-bg: #ffffff;
            --text-main: #1e293b;
            --text-sub: #64748b;
            --border-color: #e2e8f0;
            --primary-color: #3b82f6;
            --success-color: #10b981;
            --info-color: #8b5cf6; /* 紫色用于批量生成 */
            --radius: 10px;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.05);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }

        body {
            background-color: var(--bg-color);
            margin: 0;
            font-family: 'Inter', sans-serif;
        }

        .admin-layout { display: flex; min-height: 100vh; }
        .admin-content { flex: 1; padding: 30px 40px; overflow-y: auto; background-color: var(--bg-color); }

        /* 顶部标题与操作区 */
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
            border: none;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .btn-primary { background-color: var(--primary-color); color: white; }
        .btn-primary:hover { background-color: #2563eb; transform: translateY(-1px); }
        
        .btn-info { background-color: var(--info-color); color: white; }
        .btn-info:hover { background-color: #7c3aed; transform: translateY(-1px); }
        
        .btn-success { background-color: var(--success-color); color: white; }
        .btn-success:hover { background-color: #059669; transform: translateY(-1px); }

        /* 筛选工具栏 */
        .filter-toolbar {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 16px 20px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
        }
        .search-form { display: flex; gap: 15px; align-items: center; }

        .form-control {
            padding: 10px 15px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 0.9rem;
            color: var(--text-main);
            background-color: #f8fafc;
            transition: all 0.2s;
            outline: none;
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
        }

        /* 表格样式 */
        .table-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            overflow: hidden;
        }
        .table-responsive { width: 100%; overflow-x: auto; }
        .table { width: 100%; border-collapse: collapse; white-space: nowrap; }
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
        .table tbody tr:hover { background-color: #f8fafc; }
        .table tbody tr:last-child td { border-bottom: none; }

        /* 状态徽章 */
        .badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        .badge-success { background-color: #f0fdf4; color: #16a34a; border: 1px solid #dcfce7; }
        .badge-danger { background-color: #fef2f2; color: #ef4444; border: 1px solid #fee2e2; }

        /* 号源显示 */
        .patient-count {
            font-family: monospace;
            font-weight: 600;
        }
        .count-current { color: var(--primary-color); }
        .count-divider { color: #cbd5e1; margin: 0 2px; }
        .count-max { color: var(--text-sub); }

        /* 操作按钮 */
        .action-group { display: flex; gap: 8px; }
        .btn-sm {
            padding: 6px 10px;
            border-radius: 6px;
            font-size: 0.8rem;
            cursor: pointer;
            border: 1px solid var(--border-color);
            background: white;
            color: var(--text-sub);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: all 0.2s;
        }
        .btn-sm:hover { border-color: var(--primary-color); color: var(--primary-color); }
        .btn-sm-delete:hover { border-color: #ef4444; color: #ef4444; background: #fef2f2; }

        /* 模态框样式 (Modal) */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            z-index: 1000;
            animation: fadeIn 0.2s ease-out;
        }
        .modal-content {
            background: #fff;
            width: 500px;
            margin: 40px auto;
            border-radius: 16px;
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            animation: slideDown 0.3s ease-out;
            max-height: 85vh;
            display: flex;
            flex-direction: column;
        }
        .modal-header {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border-color);
            background: #f8fafc;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .modal-title { margin: 0; font-size: 1.1rem; font-weight: 700; color: var(--text-main); }
        
        #generateForm {
            display: flex;
            flex-direction: column;
            flex: 1;
            overflow: hidden;
        }
        
        .modal-body { 
            padding: 24px; 
            overflow-y: auto;
            flex: 1;
        }
        .modal-footer {
            padding: 16px 24px;
            border-top: 1px solid var(--border-color);
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            background: #f8fafc;
        }

        .form-group { margin-bottom: 16px; }
        .form-label { display: block; margin-bottom: 8px; font-weight: 600; color: var(--text-main); font-size: 0.9rem; }
        
        /* 模态框复选框样式 */
        .checkbox-group { display: flex; gap: 20px; }
        .checkbox-label {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            font-size: 0.95rem;
            color: var(--text-main);
        }
        .checkbox-label input[type="checkbox"] {
            width: 18px; height: 18px; cursor: pointer; accent-color: var(--info-color);
        }

        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes slideDown { from { transform: translateY(-20px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

        /* 提示框 */
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-success { background-color: #f0fdf4; color: #16a34a; border: 1px solid #dcfce7; }
    </style>
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="sidebar.jsp" />
        
        <div class="admin-content">
            <div class="page-header">
                <div class="page-title">
                    <h2><i class="fas fa-calendar-alt" style="color: var(--primary-color);"></i> 排班管理</h2>
                </div>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/admin?action=scheduleForm" class="btn-action btn-primary">
                        <i class="fas fa-plus"></i> 添加单条排班
                    </a>
                    <button onclick="showGenerateModal()" class="btn-action btn-info">
                        <i class="fas fa-magic"></i> 批量自动生成
                    </button>
                    <a href="${pageContext.request.contextPath}/admin?action=import" class="btn-action btn-success">
                        <i class="fas fa-file-import"></i> 导入排班表
                    </a>
                </div>
            </div>
            
            <div class="filter-toolbar">
                <form action="${pageContext.request.contextPath}/admin" method="get" class="search-form">
                    <input type="hidden" name="action" value="schedules">
                    
                    <div style="position: relative; width: 300px;">
                        <select name="doctorId" class="form-control" style="width: 100%; padding-left: 35px; appearance: none;" onchange="this.form.submit()">
                            <option value="">查看所有医生排班</option>
                            <c:forEach items="${doctors}" var="doc">
                                <option value="${doc.doctorId}" ${selectedDoctorId == doc.doctorId ? 'selected' : ''}>${doc.name} (${doc.deptName})</option>
                            </c:forEach>
                        </select>
                        <i class="fas fa-user-md" style="position: absolute; left: 12px; top: 12px; color: #94a3b8; pointer-events: none;"></i>
                        <i class="fas fa-chevron-down" style="position: absolute; right: 12px; top: 12px; font-size: 0.8rem; color: #94a3b8; pointer-events: none;"></i>
                    </div>
                    
                    <button type="submit" class="btn-action btn-primary" style="padding: 8px 20px;">
                        筛选
                    </button>
                </form>
            </div>
            
            <c:if test="${not empty param.msg}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> 
                    <span>
                        <c:if test="${param.msg == 'addSuccess'}">排班添加成功</c:if>
                        <c:if test="${param.msg == 'updateSuccess'}">排班信息更新成功</c:if>
                    </span>
                </div>
            </c:if>
            
            <div class="table-card">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>编号 ID</th>
                                <th>执勤医生</th>
                                <th>所属科室</th>
                                <th>排班日期</th>
                                <th>工作时段</th>
                                <th>号源情况 (已约/限号)</th>
                                <th>当前状态</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${schedules}" var="schedule">
                                <tr>
                                    <td style="font-family: monospace; color: var(--text-sub);">#${schedule.scheduleId}</td>
                                    <td style="font-weight: 600;">${schedule.doctorName}</td>
                                    <td>${schedule.deptName}</td>
                                    <td>
                                        <i class="far fa-calendar" style="color: var(--text-sub); margin-right: 4px;"></i>
                                        ${schedule.scheduleDate}
                                    </td>
                                    <td>
                                        <i class="far fa-clock" style="color: var(--text-sub); margin-right: 4px;"></i>
                                        ${schedule.timeSlot}
                                    </td>
                                    <td>
                                        <span class="patient-count">
                                            <span class="count-current">${schedule.currentPatients}</span>
                                            <span class="count-divider">/</span>
                                            <span class="count-max">${schedule.maxPatients}</span>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge badge-${schedule.status == 1 ? 'success' : 'danger'}">
                                            <i class="fas fa-circle" style="font-size: 6px;"></i>
                                            ${schedule.status == 1 ? '可预约' : (schedule.status == 0 ? '已满' : '停诊')}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-group">
                                            <a href="${pageContext.request.contextPath}/admin?action=scheduleForm&id=${schedule.scheduleId}" class="btn-sm" title="编辑排班">
                                                <i class="fas fa-edit"></i> 编辑
                                            </a>
                                            <button onclick="deleteSchedule('${schedule.scheduleId}')" class="btn-sm btn-sm-delete" title="删除排班">
                                                <i class="fas fa-trash-alt"></i> 删除
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <%-- 空状态 --%>
                            <c:if test="${empty schedules}">
                                <tr>
                                    <td colspan="8" style="text-align: center; padding: 50px; color: var(--text-sub);">
                                        <i class="fas fa-calendar-times" style="font-size: 40px; margin-bottom: 10px; opacity: 0.5;"></i>
                                        <p>暂无排班记录，请点击上方按钮添加或批量生成。</p>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <div id="generateModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title"><i class="fas fa-magic" style="color: var(--info-color); margin-right: 8px;"></i> 批量生成排班</h3>
                <button type="button" onclick="closeGenerateModal()" style="border:none; background:none; cursor:pointer; font-size: 1.2rem; color: #94a3b8;">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <form id="generateForm">
                <div class="modal-body">
                    <div class="form-group">
                        <label class="form-label">选择医生</label>
                        <select name="doctorId" class="form-control" required>
                            <c:forEach items="${doctors}" var="doc">
                                <option value="${doc.doctorId}">${doc.name} (${doc.deptName})</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                        <div class="form-group">
                            <label class="form-label">开始日期</label>
                            <input type="date" name="startDate" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">结束日期</label>
                            <input type="date" name="endDate" class="form-control" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">生成时段 <span style="font-weight: normal; color: #64748b; font-size: 0.85rem; margin-left: 10px;">(可多选)</span></label>
                        
                        <div style="margin-bottom: 8px; font-weight: 600; font-size: 0.85rem; color: var(--text-sub); display: flex; justify-content: space-between;">
                            <span>上午时段</span>
                            <a href="javascript:void(0)" onclick="toggleCheckboxes('morning', true)" style="font-size: 0.8rem;">全选</a>
                        </div>
                        <div class="checkbox-grid" id="morning-slots" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-bottom: 15px;">
                            <label class="checkbox-label"><input type="checkbox" name="timeSlots" value="08:00-08:30" checked> 08:00-08:30</label>
                            <label class="checkbox-label"><input type="checkbox" name="timeSlots" value="08:30-09:00" checked> 08:30-09:00</label>
                            <label class="checkbox-label"><input type="checkbox" name="timeSlots" value="09:00-09:30" checked> 09:00-09:30</label>
                            <label class="checkbox-label"><input type="checkbox" name="timeSlots" value="09:30-10:00" checked> 09:30-10:00</label>
                            <label class="checkbox-label"><input type="checkbox" name="timeSlots" value="10:00-10:30" checked> 10:00-10:30</label>
                            <label class="checkbox-label"><input type="checkbox" name="timeSlots" value="10:30-11:00" checked> 10:30-11:00</label>
                            <label class="checkbox-label"><input type="checkbox" name="timeSlots" value="11:00-11:30" checked> 11:00-11:30</label>
                            <label class="checkbox-label"><input type="checkbox" name="timeSlots" value="11:30-12:00" checked> 11:30-12:00</label>
                        </div>
                        
                        <div style="margin-bottom: 8px; font-weight: 600; font-size: 0.85rem; color: var(--text-sub); display: flex; justify-content: space-between;">
                            <span>下午时段</span>
                            <a href="javascript:void(0)" onclick="toggleCheckboxes('afternoon', true)" style="font-size: 0.8rem;">全选</a>
                        </div>
                        <div class="checkbox-grid" id="afternoon-slots" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px;">
                            <label class="checkbox-label"><input type="checkbox" name="timeSlots" value="14:00-14:30" checked> 14:00-14:30</label>
                            <label class="checkbox-label"><input type="checkbox" name="timeSlots" value="14:30-15:00" checked> 14:30-15:00</label>
                            <label class="checkbox-label"><input type="checkbox" name="timeSlots" value="15:00-15:30" checked> 15:00-15:30</label>
                            <label class="checkbox-label"><input type="checkbox" name="timeSlots" value="15:30-16:00" checked> 15:30-16:00</label>
                            <label class="checkbox-label"><input type="checkbox" name="timeSlots" value="16:00-16:30" checked> 16:00-16:30</label>
                            <label class="checkbox-label"><input type="checkbox" name="timeSlots" value="16:30-17:00" checked> 16:30-17:00</label>
                            <label class="checkbox-label"><input type="checkbox" name="timeSlots" value="17:00-17:30" checked> 17:00-17:30</label>
                            <label class="checkbox-label"><input type="checkbox" name="timeSlots" value="17:30-18:00" checked> 17:30-18:00</label>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">每时段号源数量</label>
                        <input type="number" name="maxPatients" class="form-control" value="30" required min="1">
                    </div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" onclick="closeGenerateModal()" class="btn-action" style="background: white; border: 1px solid #cbd5e1; color: var(--text-main);">取消</button>
                    <button type="button" onclick="submitGenerate()" class="btn-action btn-info">
                        <i class="fas fa-check"></i> 立即生成
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        function deleteSchedule(id) {
            if (confirm('警告：确定要删除该排班吗？此操作不可恢复。')) {
                fetch('${pageContext.request.contextPath}/admin', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'Accept': 'application/json'
                    },
                    body: 'action=deleteSchedule&id=' + id
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        setTimeout(() => location.reload(), 200);
                    } else {
                        alert('删除失败: ' + data.message);
                    }
                })
                .catch(error => {
                    alert('网络请求失败');
                });
            }
        }
        
        function showGenerateModal() {
            document.getElementById('generateModal').style.display = 'block';
        }
        
        function closeGenerateModal() {
            document.getElementById('generateModal').style.display = 'none';
        }
        
        function toggleCheckboxes(type, checked) {
            const container = document.getElementById(type + '-slots');
            const checkboxes = container.querySelectorAll('input[type="checkbox"]');
            let allChecked = true;
            checkboxes.forEach(cb => {
                if (!cb.checked) allChecked = false;
            });
            
            // 如果已经全选，则全不选；否则全选
            const newState = !allChecked;
            checkboxes.forEach(cb => cb.checked = newState);
        }
        
        // 点击遮罩层关闭
        document.getElementById('generateModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeGenerateModal();
            }
        });
        
        function submitGenerate() {
            const form = document.getElementById('generateForm');
            // 简单的前端校验
            if(!form.checkValidity()){
                alert("请填写所有必填项");
                return;
            }

            const formData = new FormData(form);
            const params = new URLSearchParams();
            
            params.append('action', 'generateSchedules');
            for (const pair of formData.entries()) {
                params.append(pair[0], pair[1]);
            }
            
            // 增加加载状态提示
            const btn = document.querySelector('#generateModal .btn-info');
            const originalText = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 生成中...';
            btn.disabled = true;
            
            fetch('${pageContext.request.contextPath}/admin', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Accept': 'application/json'
                },
                body: params.toString()
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(data.message);
                    location.reload();
                } else {
                    alert('生成失败: ' + data.message);
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                }
            })
            .catch(error => {
                alert('网络请求失败');
                btn.innerHTML = originalText;
                btn.disabled = false;
            });
        }
    </script>
</body>
</html>