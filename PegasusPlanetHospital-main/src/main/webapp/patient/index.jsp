<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人中心 - 飞马星球医院</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        body { background-color: #f8fafc; }

        /* 侧边栏样式 (保持统一) */
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
        .balance-pill {
            display: inline-block;
            background: #fff7ed;
            color: #c2410c;
            border: 1px solid #ffedd5;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            margin-top: 8px;
            font-weight: 500;
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
        .menu-danger { color: #ef4444 !important; }
        .menu-danger:hover { background-color: #fef2f2 !important; }

        /* 统计卡片样式 */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 24px;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: transform 0.2s;
        }
        .stat-card:hover { transform: translateY(-2px); box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        
        .stat-info h3 { font-size: 2rem; margin: 0 0 4px 0; font-weight: 700; color: #1e293b; line-height: 1; }
        .stat-info p { margin: 0; color: #64748b; font-size: 0.9rem; }
        
        .icon-box {
            width: 50px; height: 50px;
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem;
        }
        .icon-blue { background: #eff6ff; color: #3b82f6; }
        .icon-green { background: #f0fdf4; color: #10b981; }
        .icon-orange { background: #fff7ed; color: #f97316; }

        /* 主内容区域 */
        .main-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            border: 1px solid #e2e8f0;
            overflow: hidden;
        }
        .card-header {
            padding: 20px 24px;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-title { font-size: 1.1rem; color: #1e293b; font-weight: 700; margin: 0; }
        .link-more { color: var(--primary-color); text-decoration: none; font-size: 0.9rem; font-weight: 500; }
        .link-more:hover { text-decoration: underline; }

        /* 表格样式 */
        .table { width: 100%; border-collapse: collapse; }
        .table th {
            text-align: left; padding: 14px 24px;
            background: #f8fafc; color: #64748b; font-size: 0.85rem; font-weight: 600;
            border-bottom: 1px solid #e2e8f0;
        }
        .table td {
            padding: 14px 24px; border-bottom: 1px solid #f1f5f9;
            color: #334155; font-size: 0.95rem; vertical-align: middle;
        }
        .table tr:last-child td { border-bottom: none; }
        
        /* 状态徽章 */
        .status-badge {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 2px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: 600;
        }
        .badge-BOOKED { background: #eff6ff; color: #3b82f6; border: 1px solid #dbeafe; }
        .badge-COMPLETED { background: #f0fdf4; color: #16a34a; border: 1px solid #dcfce7; }
        .badge-CANCELLED { background: #fef2f2; color: #ef4444; border: 1px solid #fee2e2; }

        .btn-sm-outline {
            padding: 4px 12px; border-radius: 6px; font-size: 0.8rem;
            border: 1px solid #e2e8f0; background: white; color: #64748b;
            text-decoration: none; transition: all 0.2s;
        }
        .btn-sm-outline:hover { border-color: var(--primary-color); color: var(--primary-color); }
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
                        <div class="balance-pill">
                            <i class="fas fa-wallet"></i> 余额: ¥${sessionScope.patient.balance}
                        </div>
                    </div>
                    <ul class="side-menu" style="list-style: none; padding: 10px 0; margin: 0;">
                        <li>
                            <a href="${pageContext.request.contextPath}/patient?action=index" class="active">
                                <i class="fas fa-home" style="width: 24px;"></i> 个人中心概览
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/appointment?action=list">
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
                        <li style="margin-top: 10px; border-top: 1px solid #f1f5f9; padding-top: 5px;">
                            <a href="${pageContext.request.contextPath}/patient?action=deactivate" class="menu-danger" onclick="return confirm('确定要注销账号吗？注销后无法恢复！');">
                                <i class="fas fa-sign-out-alt" style="width: 24px;"></i> 注销当前账号
                            </a>
                        </li>
                    </ul>
                </div>
            </aside>

            <main style="flex: 1;">
                <h2 style="font-size: 1.5rem; color: #1e293b; margin-bottom: 20px; font-weight: 700;">欢迎回来, ${sessionScope.patient.name} 👋</h2>
                
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-info">
                            <h3>${appointmentCount}</h3>
                            <p>历史预约总数</p>
                        </div>
                        <div class="icon-box icon-blue">
                            <i class="fas fa-clipboard-list"></i>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-info">
                            <h3>${completedCount}</h3>
                            <p>已完成就诊</p>
                        </div>
                        <div class="icon-box icon-green">
                            <i class="fas fa-check-circle"></i>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-info">
                            <h3>${upcomingCount}</h3>
                            <p>待就诊预约</p>
                        </div>
                        <div class="icon-box icon-orange">
                            <i class="fas fa-clock"></i>
                        </div>
                    </div>
                </div>

                <div class="main-card">
                    <div class="card-header">
                        <h3 class="card-title">近期预约动态</h3>
                        <a href="${pageContext.request.contextPath}/appointment?action=list" class="link-more">
                            查看全部 <i class="fas fa-angle-right"></i>
                        </a>
                    </div>
                    
                    <c:choose>
                        <c:when test="${empty recentAppointments}">
                            <div style="text-align: center; padding: 60px 20px; color: #94a3b8;">
                                <i class="far fa-calendar-alt" style="font-size: 3rem; color: #cbd5e1; margin-bottom: 15px;"></i>
                                <p style="margin-bottom: 20px;">暂无近期的预约记录</p>
                                <a href="${pageContext.request.contextPath}/department?action=list" style="display: inline-block; background: var(--primary-color); color: white; padding: 10px 24px; border-radius: 50px; text-decoration: none; font-weight: 500;">
                                    立即去挂号
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="overflow-x: auto;">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>预约编号</th>
                                            <th>就诊科室</th>
                                            <th>医生</th>
                                            <th>就诊时间</th>
                                            <th>状态</th>
                                            <th style="text-align: right;">操作</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${recentAppointments}" var="apt">
                                            <tr>
                                                <td style="font-family: monospace;">#${apt.appointmentId}</td>
                                                <td>${apt.deptName}</td>
                                                <td>${apt.doctorName}</td>
                                                <td>${apt.appointmentDate} <span style="font-size: 0.8rem; color: #94a3b8;">${apt.timeSlot}</span></td>
                                                <td>
                                                    <span class="status-badge badge-${apt.status}">
                                                        <i class="fas fa-circle" style="font-size: 6px;"></i>
                                                        ${apt.status == 'BOOKED' ? '待就诊' : (apt.status == 'COMPLETED' ? '已完成' : '已取消')}
                                                    </span>
                                                </td>
                                                <td style="text-align: right;">
                                                    <a href="${pageContext.request.contextPath}/appointment?action=detail&id=${apt.appointmentId}" class="btn-sm-outline">
                                                        查看详情
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </main>
        </div>
    </div>

    <jsp:include page="/footer.jsp" />
</body>
</html>