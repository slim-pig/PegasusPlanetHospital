<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理后台 - 飞马星球医院</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        /* ============================
           Dashboard 专属样式
           ============================ */
        :root {
            --bg-color: #f1f5f9;         /* 浅灰背景 */
            --card-bg: #ffffff;
            --text-main: #1e293b;
            --text-sub: #64748b;
            --border-color: #e2e8f0;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.05);
            --radius: 12px;
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

        /* 顶部欢迎区 */
        .page-header {
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .page-title h2 {
            font-size: 1.5rem;
            color: var(--text-main);
            font-weight: 700;
            margin-bottom: 5px;
        }
        .page-title p {
            color: var(--text-sub);
            font-size: 0.9rem;
        }
        .current-date {
            background: #fff;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.85rem;
            color: var(--text-sub);
            box-shadow: var(--shadow-sm);
        }

        /* 统计卡片网格 */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 24px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 24px;
            box-shadow: var(--shadow-sm);
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: transform 0.2s, box-shadow 0.2s;
            border: 1px solid transparent;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            border-color: #e2e8f0;
        }

        .stat-content h3 {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-main);
            margin-bottom: 4px;
            line-height: 1;
        }
        .stat-content p {
            color: var(--text-sub);
            font-size: 0.9rem;
            font-weight: 500;
        }

        .stat-icon {
            width: 56px;
            height: 56px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }
        /* 不同颜色的卡片图标 */
        .icon-blue { background: #eff6ff; color: #3b82f6; }
        .icon-green { background: #f0fdf4; color: #22c55e; }
        .icon-orange { background: #fff7ed; color: #f97316; }
        .icon-purple { background: #f5f3ff; color: #8b5cf6; }

        /* 内容双栏布局 */
        .dashboard-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 24px;
        }

        /* 通用卡片样式 */
        .card {
            background: var(--card-bg);
            border-radius: var(--radius);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            overflow: hidden;
        }
        
        .card-header {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #f8fafc;
        }
        .card-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-main);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .card-action {
            font-size: 0.85rem;
            color: #3b82f6;
            text-decoration: none;
            font-weight: 500;
        }
        .card-action:hover { text-decoration: underline; }

        /* 表格优化 */
        .table-responsive {
            width: 100%;
            overflow-x: auto;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        .table th {
            text-align: left;
            padding: 16px 24px;
            background: #f8fafc;
            color: var(--text-sub);
            font-weight: 600;
            font-size: 0.85rem;
            border-bottom: 1px solid var(--border-color);
        }
        .table td {
            padding: 16px 24px;
            border-bottom: 1px solid var(--border-color);
            color: var(--text-main);
            font-size: 0.9rem;
        }
        .table tr:last-child td { border-bottom: none; }
        .table tr:hover { background-color: #f8fafc; }

        /* 状态徽章 */
        .badge {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-block;
        }
        .badge-primary { background: #eff6ff; color: #3b82f6; }   /* 预约中 */
        .badge-success { background: #f0fdf4; color: #16a34a; }   /* 已完成 */
        .badge-danger  { background: #fef2f2; color: #dc2626; }   /* 已取消 */

        /* 科室列表 */
        .dept-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .dept-item {
            padding: 16px 24px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: background 0.2s;
        }
        .dept-item:last-child { border-bottom: none; }
        .dept-item:hover { background-color: #f8fafc; }
        
        .dept-name {
            font-weight: 500;
            color: var(--text-main);
        }
        
        .btn-outline {
            border: 1px solid var(--border-color);
            background: white;
            color: var(--text-sub);
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 0.8rem;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-outline:hover {
            border-color: #3b82f6;
            color: #3b82f6;
        }

        /* 响应式 */
        @media (max-width: 1200px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .dashboard-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="sidebar.jsp" />
        
        <div class="admin-content">
            <div class="page-header">
                <div class="page-title">
                    <h2>仪表盘概览</h2>
                    <p>欢迎回到管理中心，这里展示医院今日运营数据</p>
                </div>
                <div class="current-date">
                    <i class="far fa-clock"></i> 今日数据实时更新
                </div>
            </div>
            
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-content">
                        <h3>${stats.totalDoctors}</h3>
                        <p>在职专家医生</p>
                    </div>
                    <div class="stat-icon icon-blue">
                        <i class="fas fa-user-md"></i>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-content">
                        <h3>${stats.totalPatients}</h3>
                        <p>累计注册患者</p>
                    </div>
                    <div class="stat-icon icon-green">
                        <i class="fas fa-users"></i>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-content">
                        <h3>${stats.todayAppointments}</h3>
                        <p>今日预约数</p>
                    </div>
                    <div class="stat-icon icon-orange">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-content">
                        <h3>${stats.totalAppointments}</h3>
                        <p>历史服务总次</p>
                    </div>
                    <div class="stat-icon icon-purple">
                        <i class="fas fa-clipboard-list"></i>
                    </div>
                </div>
            </div>
            
            <div class="dashboard-grid">
                
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">
                            <i class="fas fa-history" style="color: #64748b;"></i> 最新预约动态
                        </div>
                        <a href="${pageContext.request.contextPath}/admin?action=appointments" class="card-action">
                            查看全部 <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>患者姓名</th>
                                    <th>预约科室</th>
                                    <th>专家医生</th>
                                    <th>预约日期</th>
                                    <th>当前状态</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${recentAppointments}" var="apt">
                                    <tr>
                                        <td><i class="fas fa-user-circle" style="color:#cbd5e1; margin-right:5px;"></i> ${apt.patientName}</td>
                                        <td>${apt.deptName}</td>
                                        <td>${apt.doctorName}</td>
                                        <td>${apt.appointmentDate}</td>
                                        <td>
                                            <span class="badge badge-${apt.status == 'BOOKED' ? 'primary' : (apt.status == 'COMPLETED' ? 'success' : 'danger')}">
                                                ${apt.status == 'BOOKED' ? '待就诊' : (apt.status == 'COMPLETED' ? '已完成' : '已取消')}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">
                            <i class="fas fa-clinic-medical" style="color: #64748b;"></i> 重点科室
                        </div>
                    </div>
                    <ul class="dept-list">
                        <c:forEach items="${stats.departments}" var="dept">
                            <li class="dept-item">
                                <span class="dept-name">${dept.deptName}</span>
                                <a href="${pageContext.request.contextPath}/admin?action=doctors&deptId=${dept.deptId}" class="btn-outline">
                                    管理医生
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
                
            </div> </div>
    </div>
</body>
</html>