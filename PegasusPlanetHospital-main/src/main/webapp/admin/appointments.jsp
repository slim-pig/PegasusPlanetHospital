<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>预约管理 - 飞马星球医院</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        /* ============================
           预约管理页专属样式
           ============================ */
        :root {
            --bg-color: #f1f5f9;
            --card-bg: #ffffff;
            --text-main: #1e293b;
            --text-sub: #64748b;
            --border-color: #e2e8f0;
            --primary-color: #3b82f6;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.05);
            --radius: 10px;
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
        
        /* 导出按钮 */
        .btn-export {
            background-color: #10b981; /* Excel绿 */
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
            box-shadow: 0 2px 4px rgba(16, 185, 129, 0.2);
        }
        .btn-export:hover {
            background-color: #059669;
            transform: translateY(-1px);
        }

        /* 筛选栏卡片 */
        .filter-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 20px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
        }
        
        .search-form {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }

        /* 表单控件美化 */
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
            overflow: hidden; /* 圆角溢出隐藏 */
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

        /* 状态徽章 (Pill Style) */
        .badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        .badge-primary { /* 已预约 - 蓝色 */
            background-color: #eff6ff;
            color: #3b82f6;
            border: 1px solid #dbeafe;
        }
        .badge-success { /* 已完成 - 绿色 */
            background-color: #f0fdf4;
            color: #16a34a;
            border: 1px solid #dcfce7;
        }
        .badge-danger { /* 已取消 - 灰色/红色 */
            background-color: #fef2f2;
            color: #ef4444;
            border: 1px solid #fee2e2;
        }

        /* 操作按钮组 */
        .action-group {
            display: flex;
            gap: 8px;
        }
        .btn-sm {
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 0.8rem;
            cursor: pointer;
            border: 1px solid transparent;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: all 0.2s;
        }
        .btn-action-complete {
            background-color: #f0fdf4;
            color: #16a34a;
            border-color: #dcfce7;
        }
        .btn-action-complete:hover {
            background-color: #16a34a;
            color: white;
        }
        .btn-action-cancel {
            background-color: #fff;
            color: #ef4444;
            border-color: #fee2e2;
        }
        .btn-action-cancel:hover {
            background-color: #ef4444;
            color: white;
            border-color: #ef4444;
        }

        /* 时间段图标 */
        .time-slot {
            display: flex;
            align-items: center;
            gap: 6px;
            color: var(--text-sub);
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="sidebar.jsp" />
        
        <div class="admin-content">
            <div class="page-header">
                <div class="page-title">
                    <h2><i class="fas fa-calendar-check" style="color: #3b82f6;"></i> 预约管理</h2>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/export?type=all" class="btn-export">
                        <i class="fas fa-file-excel"></i> 导出Excel报表
                    </a>
                </div>
            </div>
            
            <div class="filter-card">
                <form action="${pageContext.request.contextPath}/admin" method="get" class="search-form">
                    <input type="hidden" name="action" value="appointments">
                    
                    <div style="position: relative;">
                        <input type="date" name="date" class="form-control" value="${param.date}" style="padding-left: 35px;">
                        <i class="fas fa-calendar-alt" style="position: absolute; left: 12px; top: 12px; color: #94a3b8;"></i>
                    </div>
                    
                    <select name="status" class="form-control" style="width: 140px;">
                        <option value="">所有状态</option>
                        <option value="BOOKED" ${param.status == 'BOOKED' ? 'selected' : ''}>已预约</option>
                        <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>已完成</option>
                        <option value="CANCELLED" ${param.status == 'CANCELLED' ? 'selected' : ''}>已取消</option>
                    </select>
                    
                    <div style="position: relative; width: 250px;">
                        <input type="text" name="keyword" class="form-control" 
                               placeholder="搜索患者姓名、医生姓名..." 
                               value="${param.keyword}" 
                               style="width: 100%; padding-left: 35px;">
                        <i class="fas fa-search" style="position: absolute; left: 12px; top: 12px; color: #94a3b8;"></i>
                    </div>
                    
                    <button type="submit" class="btn-search">
                        查询
                    </button>
                </form>
            </div>
            
            <div class="table-card">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>预约号</th>
                                <th>患者信息</th>
                                <th>预约医生</th>
                                <th>所属科室</th>
                                <th>预约日期</th>
                                <th>时段</th>
                                <th>当前状态</th>
                                <th>操作管理</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${appointments}" var="apt">
                                <tr>
                                    <td style="font-family: monospace; color: var(--text-sub);">#${apt.appointmentId}</td>
                                    <td>
                                        <div style="font-weight: 500;">${apt.patientName}</div>
                                    </td>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 8px;">
                                            <div style="width: 24px; height: 24px; background: #e0f2fe; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #0284c7; font-size: 10px;">
                                                <i class="fas fa-user-md"></i>
                                            </div>
                                            ${apt.doctorName}
                                        </div>
                                    </td>
                                    <td>${apt.deptName}</td>
                                    <td>${apt.appointmentDate}</td>
                                    <td>
                                        <div class="time-slot">
                                            <i class="far fa-clock"></i>
                                            ${apt.timeSlot == 'MORNING' ? '上午' : (apt.timeSlot == 'AFTERNOON' ? '下午' : '晚上')}
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge badge-${apt.status == 'BOOKED' ? 'primary' : (apt.status == 'COMPLETED' ? 'success' : 'danger')}">
                                            <i class="fas fa-circle" style="font-size: 6px;"></i>
                                            ${apt.status == 'BOOKED' ? '已预约' : (apt.status == 'COMPLETED' ? '已完成' : '已取消')}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-group">
                                            <c:if test="${apt.status == 'BOOKED'}">
                                                <button onclick="updateStatus('${apt.appointmentId}', 'COMPLETED')" class="btn-sm btn-action-complete" title="标记为完成">
                                                    <i class="fas fa-check"></i> 完成
                                                </button>
                                                <button onclick="updateStatus('${apt.appointmentId}', 'CANCELLED')" class="btn-sm btn-action-cancel" title="取消预约">
                                                    <i class="fas fa-times"></i> 取消
                                                </button>
                                            </c:if>
                                            <c:if test="${apt.status != 'BOOKED'}">
                                                <span style="color: #cbd5e1; font-size: 0.85rem;">-</span>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <%-- 空状态处理 (可选) --%>
                            <c:if test="${empty appointments}">
                                <tr>
                                    <td colspan="8" style="text-align: center; padding: 40px; color: var(--text-sub);">
                                        <i class="far fa-folder-open" style="font-size: 40px; margin-bottom: 10px; opacity: 0.5;"></i>
                                        <p>暂无符合条件的预约记录</p>
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
        function updateStatus(id, status) {
            // 增加 confirm 的文案优化
            const actionName = status === 'COMPLETED' ? '完成' : '取消';
            if (confirm('确认要将该预约标记为【' + actionName + '】吗？此操作不可撤销。')) {
                fetch('${pageContext.request.contextPath}/admin', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'Accept': 'application/json'
                    },
                    body: 'action=updateAppointmentStatus&id=' + id + '&status=' + status
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // 增加一个轻微的延迟刷新，体验更好
                        setTimeout(() => location.reload(), 200);
                    } else {
                        alert('操作失败: ' + data.message);
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