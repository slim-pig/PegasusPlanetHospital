<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的预约 - 飞马星球医院</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        body { background-color: #f8fafc; }

        /* 侧边栏样式 (保持与详情页一致) */
        .sidebar-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            border: 1px solid #e2e8f0;
        }
        .user-profile-header {
            background: linear-gradient(135deg, #eff6ff 0%, #ffffff 100%);
            padding: 30px 20px;
            text-align: center;
            border-bottom: 1px solid #f1f5f9;
        }
        .side-menu a {
            color: #64748b;
            font-weight: 500;
            transition: all 0.2s;
            border-left: 3px solid transparent;
            text-decoration: none;
            display: flex; 
            align-items: center; 
            padding: 12px 20px;
        }
        .side-menu a:hover {
            background-color: #f8fafc;
            color: var(--primary-color);
        }
        .side-menu a.active {
            background-color: #eff6ff !important;
            color: var(--primary-color) !important;
            border-left-color: var(--primary-color);
        }

        /* 主内容卡片 */
        .main-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            border: 1px solid #e2e8f0;
            overflow: hidden;
            min-height: 500px;
        }
        
        .card-header {
            padding: 20px 30px;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #fff;
        }
        .card-title {
            font-size: 1.25rem;
            color: #1e293b;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* 表格样式优化 */
        .table-responsive {
            padding: 0;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        .table th {
            background-color: #f8fafc;
            color: #64748b;
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            padding: 16px 24px;
            border-bottom: 1px solid #e2e8f0;
            text-align: left;
        }
        .table td {
            padding: 16px 24px;
            border-bottom: 1px solid #f1f5f9;
            color: #334155;
            vertical-align: middle;
            font-size: 0.95rem;
        }
        .table tr:last-child td { border-bottom: none; }
        .table tr:hover { background-color: #fcfcfc; }

        /* 状态胶囊 */
        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
            gap: 6px;
        }
        .badge-BOOKED { background-color: #eff6ff; color: #3b82f6; border: 1px solid #dbeafe; }
        .badge-COMPLETED { background-color: #f0fdf4; color: #16a34a; border: 1px solid #dcfce7; }
        .badge-CANCELLED { background-color: #fef2f2; color: #ef4444; border: 1px solid #fee2e2; }

        /* 按钮 */
        .btn-export {
            color: #166534;
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 0.9rem;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-export:hover { background: #dcfce7; }

        .btn-sm {
            padding: 6px 12px;
            font-size: 0.85rem;
            border-radius: 6px;
            text-decoration: none;
            cursor: pointer;
            border: 1px solid transparent;
            transition: all 0.2s;
        }
        .btn-outline-primary {
            color: var(--primary-color);
            border-color: #e2e8f0;
            background: white;
        }
        .btn-outline-primary:hover {
            border-color: var(--primary-color);
            background: #eff6ff;
        }
        .btn-outline-danger {
            color: #ef4444;
            border-color: #fee2e2;
            background: white;
        }
        .btn-outline-danger:hover {
            background: #fef2f2;
            border-color: #ef4444;
        }

        /* 辅助文本 */
        .text-muted { color: #94a3b8; font-size: 0.85rem; margin-top: 4px; display: block; }
        .font-mono { font-family: 'Menlo', 'Monaco', monospace; color: #64748b; }
        .doctor-name { font-weight: 600; color: #1e293b; }
    </style>
</head>
<body>
    <jsp:include page="/header.jsp" />

    <div class="container" style="padding: 40px 20px;">
        <div style="display: flex; gap: 30px; align-items: flex-start;">
            
            <aside style="width: 260px; flex-shrink: 0;">
                <div class="sidebar-card">
                    <div class="user-profile-header">
                        <div style="width: 72px; height: 72px; background: #e0f2fe; border-radius: 50%; margin: 0 auto 12px; display: flex; align-items: center; justify-content: center; font-size: 28px; color: #0284c7;">
                            <i class="fas fa-user-circle"></i>
                        </div>
                        <h3 style="font-size: 1.1rem; color: #1e293b; margin: 0;">${sessionScope.patient.name}</h3>
                        <p style="font-size: 0.85rem; color: #64748b; margin: 5px 0 0;">ID: ${sessionScope.patient.patientId}</p>
                    </div>
                    <ul class="side-menu" style="list-style: none; padding: 10px 0; margin: 0;">
                        <li>
                            <a href="${pageContext.request.contextPath}/patient?action=index">
                                <i class="fas fa-home" style="width: 24px;"></i> 个人中心概览
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/appointment?action=list" class="active">
                                <i class="fas fa-calendar-check" style="width: 24px;"></i> 我的预约挂号
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/patient?action=profile">
                                <i class="fas fa-user-edit" style="width: 24px;"></i> 修改个人资料
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/patient?action=password">
                                <i class="fas fa-key" style="width: 24px;"></i> 修改登录密码
                            </a>
                        </li>
                    </ul>
                </div>
            </aside>

            <main style="flex: 1;">
                <div class="main-card">
                    <div class="card-header">
                        <h2 class="card-title"><i class="fas fa-list-alt" style="color: var(--primary-color);"></i> 我的预约记录</h2>
                        <a href="${pageContext.request.contextPath}/export?type=myAppointments" class="btn-export">
                            <i class="fas fa-file-excel"></i> 导出记录
                        </a>
                    </div>
                    
                    <c:if test="${not empty param.msg && param.msg == 'cancelSuccess'}">
                        <div style="margin: 20px 30px; padding: 12px 16px; background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 8px; color: #166534; display: flex; align-items: center; gap: 8px;">
                            <i class="fas fa-check-circle"></i> 预约已成功取消。
                        </div>
                    </c:if>
                    
                    <c:if test="${empty appointments}">
                        <div style="text-align: center; padding: 80px 20px; color: #94a3b8;">
                            <div style="width: 80px; height: 80px; background: #f1f5f9; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;">
                                <i class="far fa-calendar-times" style="font-size: 32px; color: #cbd5e1;"></i>
                            </div>
                            <h3 style="color: #475569; font-size: 1.1rem; margin-bottom: 10px;">暂无预约记录</h3>
                            <p style="margin-bottom: 25px;">您还没有进行过任何预约，快去挂号吧。</p>
                            <a href="${pageContext.request.contextPath}/department?action=list" class="btn-sm" style="background: var(--primary-color); color: white; padding: 10px 24px; border-radius: 50px;">
                                立即前往挂号
                            </a>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty appointments}">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>预约编号</th>
                                        <th>就诊科室</th>
                                        <th>专家医生</th>
                                        <th>就诊时间</th>
                                        <th>当前状态</th>
                                        <th style="text-align: right;">操作</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${appointments}" var="apt">
                                        <tr>
                                            <td class="font-mono">#${apt.appointmentId}</td>
                                            <td style="font-weight: 500;">${apt.deptName}</td>
                                            <td>
                                                <div class="doctor-name">${apt.doctorName}</div>
                                                <span class="text-muted" style="font-size: 0.75rem;">${apt.doctorTitle}</span>
                                            </td>
                                            <td>
                                                <div><i class="far fa-calendar" style="color: #94a3b8; margin-right: 5px;"></i> ${apt.appointmentDate}</div>
                                                <span class="text-muted"><i class="far fa-clock" style="color: #94a3b8; margin-right: 5px;"></i> ${apt.timeSlot}</span>
                                            </td>
                                            <td>
                                                <span class="status-badge badge-${apt.status}">
                                                    <i class="fas fa-circle" style="font-size: 6px;"></i>
                                                    ${apt.status == 'BOOKED' ? '待就诊' : (apt.status == 'COMPLETED' ? '已完成' : '已取消')}
                                                </span>
                                            </td>
                                            <td style="text-align: right;">
                                                <div style="display: flex; gap: 8px; justify-content: flex-end;">
                                                    <a href="${pageContext.request.contextPath}/appointment?action=detail&id=${apt.appointmentId}" class="btn-sm btn-outline-primary">
                                                        详情
                                                    </a>
                                                    <c:if test="${apt.status == 'BOOKED'}">
                                                        <button onclick="cancelAppointment('${apt.appointmentId}')" class="btn-sm btn-outline-danger">
                                                            取消
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>
            </main>
        </div>
    </div>

    <jsp:include page="/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/js/main.js" charset="UTF-8"></script>
    <script>
        // 覆盖 main.js 中的同名函数，解决中文乱码问题
        function cancelAppointment(appointmentId) {
            const reason = prompt("请输入取消原因：");
            if (reason === null) return; 
            
            fetch('${pageContext.request.contextPath}/appointment', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Accept': 'application/json'
                },
                body: 'action=cancel&id=' + appointmentId + '&reason=' + encodeURIComponent(reason)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('预约已取消');
                    // 刷新页面以更新状态
                    location.reload();
                } else {
                    alert('取消失败: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('操作失败，请检查网络连接');
            });
        }
    </script>
</body>
</html>