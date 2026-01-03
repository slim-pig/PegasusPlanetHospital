<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${doctor.name} - 医生详情 - 飞马星球医院</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        /* ============================
           医生详情页专属样式
           ============================ */
        body {
            background-color: #f8fafc;
        }

        /* 主容器 */
        .doctor-detail-container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 20px;
        }

        /* 顶部资料卡片 */
        .profile-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            border: 1px solid #e2e8f0;
            overflow: hidden;
            margin-bottom: 30px;
        }

        .profile-header {
            background: linear-gradient(135deg, #eff6ff 0%, #ffffff 100%);
            padding: 40px;
            display: flex;
            gap: 40px;
            align-items: center;
            border-bottom: 1px solid #f1f5f9;
        }

        /* 左侧头像区 */
        .avatar-area {
            flex-shrink: 0;
            text-align: center;
        }
        .avatar-box {
            width: 160px;
            height: 160px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 70px;
            color: var(--primary-color, #0056b3);
            border: 4px solid #fff;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .btn-book-now {
            display: block;
            background: var(--primary-color, #0056b3);
            color: white;
            padding: 12px 0;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            box-shadow: 0 4px 6px rgba(0, 86, 179, 0.2);
            transition: all 0.2s;
        }
        .btn-book-now:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 10px rgba(0, 86, 179, 0.3);
        }

        /* 右侧信息区 */
        .info-area {
            flex: 1;
        }
        .doctor-name {
            font-size: 2rem;
            color: #1e293b;
            font-weight: 800;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .title-badge {
            font-size: 0.9rem;
            color: #0369a1;
            background: #e0f2fe;
            padding: 4px 12px;
            border-radius: 20px;
            font-weight: 600;
            vertical-align: middle;
        }
        .dept-name {
            font-size: 1.1rem;
            color: #64748b;
            margin-bottom: 20px;
            font-weight: 500;
        }

        /* 擅长领域模块 */
        .specialty-section {
            background: #f8fafc;
            padding: 20px;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
        }
        .section-title {
            font-size: 1rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .specialty-text {
            color: #475569;
            line-height: 1.7;
            font-size: 0.95rem;
        }

        /* 排班表格卡片 */
        .schedule-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border: 1px solid #e2e8f0;
            padding: 30px;
        }
        .schedule-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 20px;
            border-left: 4px solid var(--primary-color, #0056b3);
            padding-left: 12px;
        }

        /* 表格样式 */
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        .table th {
            text-align: left;
            padding: 16px;
            background: #f8fafc;
            color: #64748b;
            font-weight: 600;
            font-size: 0.9rem;
            border-bottom: 1px solid #e2e8f0;
        }
        .table td {
            padding: 16px;
            border-bottom: 1px solid #f1f5f9;
            color: #334155;
            vertical-align: middle;
        }
        .table tr:last-child td { border-bottom: none; }
        .table tr:hover { background-color: #fcfcfc; }

        /* 状态徽章 */
        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            gap: 6px;
        }
        .badge-success { /* 有号 */
            background-color: #f0fdf4;
            color: #16a34a;
            border: 1px solid #dcfce7;
        }
        .badge-danger { /* 停诊/已满 */
            background-color: #fef2f2;
            color: #ef4444;
            border: 1px solid #fee2e2;
        }

        /* 操作按钮 */
        .btn-sm-primary {
            background-color: var(--primary-color, #0056b3);
            color: white;
            padding: 6px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.85rem;
            transition: all 0.2s;
            display: inline-block;
        }
        .btn-sm-primary:hover {
            background-color: #004494;
            transform: translateY(-1px);
        }
        .btn-sm-disabled {
            background-color: #e2e8f0;
            color: #94a3b8;
            padding: 6px 16px;
            border-radius: 6px;
            font-size: 0.85rem;
            border: none;
            cursor: not-allowed;
        }

        @media (max-width: 768px) {
            .profile-header { flex-direction: column; text-align: center; }
            .info-area { text-align: left; }
            .doctor-name { justify-content: center; }
        }
    </style>
</head>
<body>
    <jsp:include page="/header.jsp" />
    
    <div class="doctor-detail-container">
        
        <div class="profile-card">
            <div class="profile-header">
                <div class="avatar-area">
                    <div class="avatar-box">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <a href="#schedule-section" class="btn-book-now">
                        立即预约 <i class="fas fa-arrow-down" style="font-size: 0.8rem; margin-left: 5px;"></i>
                    </a>
                </div>
                
                <div class="info-area">
                    <h1 class="doctor-name">
                        ${doctor.name} 
                        <span class="title-badge">${doctor.title}</span>
                    </h1>
                    <p class="dept-name">
                        <i class="far fa-hospital" style="margin-right: 6px;"></i> ${doctor.deptName}
                    </p>
                    
                    <div class="specialty-section">
                        <div class="section-title">
                            <i class="fas fa-star" style="color: #f59e0b;"></i> 擅长领域
                        </div>
                        <p class="specialty-text">
                            ${doctor.specialty}
                        </p>
                    </div>
                </div>
            </div>
        </div>
        
        <div id="schedule-section" class="schedule-card">
            <h3 class="schedule-title">近期出诊排班表</h3>
            
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th style="width: 30%;">出诊日期</th>
                            <th style="width: 30%;">出诊时段</th>
                            <th style="width: 20%;">号源状态</th>
                            <th style="width: 20%;">操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${schedules}" var="schedule">
                            <tr>
                                <td>
                                    <i class="far fa-calendar-alt" style="color: #94a3b8; margin-right: 8px;"></i>
                                    ${schedule.scheduleDate}
                                </td>
                                <td>
                                    <i class="far fa-clock" style="color: #94a3b8; margin-right: 8px;"></i>
                                    ${schedule.timeSlot}
                                </td>
                                <td>
                                    <span class="status-badge badge-${schedule.status == 1 ? 'success' : 'danger'}">
                                        <i class="fas fa-circle" style="font-size: 6px;"></i>
                                        ${schedule.status == 1 ? '号源充足' : (schedule.status == 0 ? '已约满' : '停诊')}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${schedule.status == 1}">
                                            <a href="${pageContext.request.contextPath}/appointment?action=book&scheduleId=${schedule.scheduleId}" class="btn-sm-primary">
                                                挂号预约
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn-sm-disabled" disabled>不可预约</button>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty schedules}">
                            <tr>
                                <td colspan="4" style="text-align: center; padding: 40px; color: #94a3b8;">
                                    <i class="far fa-calendar-times" style="font-size: 32px; margin-bottom: 10px; display: block;"></i>
                                    近期暂无出诊计划，请关注后续更新。
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
        
    </div>
    
    <jsp:include page="/footer.jsp" />
    
    <script>
        // 平滑滚动支持
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });
    </script>
</body>
</html>