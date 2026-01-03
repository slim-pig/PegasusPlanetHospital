<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>专家团队 - 飞马星球医院</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        /* ============================
           医生列表页专属样式
           ============================ */
        body {
            background-color: #f8fafc;
        }

        /* 顶部 Hero 区域 */
        .page-banner {
            background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
            padding: 50px 0;
            text-align: center;
            color: white;
            margin-bottom: 40px;
            position: relative;
            overflow: hidden;
        }
        .page-banner::after {
            content: '';
            position: absolute;
            bottom: -50px; left: -50px;
            width: 200px; height: 200px;
            background: rgba(255,255,255,0.05);
            border-radius: 50%;
        }
        .banner-title {
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 8px;
            position: relative;
            z-index: 1;
        }
        .banner-subtitle {
            font-size: 1rem;
            color: #94a3b8;
            font-weight: 300;
            position: relative;
            z-index: 1;
        }

        /* 筛选栏容器 */
        .filter-container {
            margin-bottom: 40px;
            text-align: center;
        }
        .filter-scroll {
            display: inline-flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 12px;
            padding: 10px;
        }
        
        /* 胶囊筛选器 */
        .filter-chip {
            padding: 8px 20px;
            border-radius: 50px;
            background: white;
            color: #64748b;
            font-size: 0.95rem;
            font-weight: 500;
            text-decoration: none;
            border: 1px solid #e2e8f0;
            transition: all 0.2s ease;
            box-shadow: 0 1px 2px rgba(0,0,0,0.05);
        }
        .filter-chip:hover {
            border-color: var(--primary-color, #0056b3);
            color: var(--primary-color, #0056b3);
            transform: translateY(-1px);
        }
        .filter-chip.active {
            background: var(--primary-color, #0056b3);
            color: white;
            border-color: var(--primary-color, #0056b3);
            box-shadow: 0 4px 6px rgba(0, 86, 179, 0.2);
        }

        /* 医生卡片网格 */
        .doctor-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 30px;
            padding-bottom: 60px;
        }

        /* 医生卡片 */
        .doc-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
            border: 1px solid #f1f5f9;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            cursor: pointer;
            text-decoration: none;
            display: block; /* 让a标签变成块级 */
        }
        .doc-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            border-color: transparent;
        }

        /* 卡片顶部装饰 */
        .card-top-bg {
            height: 80px;
            background: linear-gradient(135deg, #eff6ff 0%, #e0f2fe 100%);
            position: relative;
        }
        
        /* 头像区域 */
        .avatar-wrapper {
            width: 90px;
            height: 90px;
            background: white;
            border-radius: 50%;
            margin: -45px auto 15px; /* 负边距上移 */
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 5px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            position: relative;
            z-index: 2;
        }
        .avatar-inner {
            width: 100%;
            height: 100%;
            background: #f1f5f9;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            color: #94a3b8;
            transition: all 0.3s;
        }
        .doc-card:hover .avatar-inner {
            background: var(--primary-color, #0056b3);
            color: white;
        }

        /* 文本内容 */
        .doc-info {
            text-align: center;
            padding: 0 20px 25px;
        }
        .doc-name {
            font-size: 1.25rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 8px;
        }
        
        /* 职称标签 */
        .title-badge {
            display: inline-block;
            padding: 4px 12px;
            background: #fff7ed;
            color: #c2410c;
            border: 1px solid #ffedd5;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            margin-bottom: 12px;
        }
        
        .dept-name {
            color: #64748b;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        /* 底部按钮模拟 */
        .card-action {
            border-top: 1px solid #f1f5f9;
            padding: 15px;
            text-align: center;
            color: var(--primary-color, #0056b3);
            font-size: 0.9rem;
            font-weight: 600;
            background: #fff;
            transition: background 0.3s;
        }
        .doc-card:hover .card-action {
            background: #eff6ff;
        }

        /* 空状态 */
        .empty-state {
            text-align: center;
            padding: 80px 0;
            color: #94a3b8;
        }
        .empty-icon {
            font-size: 4rem;
            color: #cbd5e1;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="/header.jsp" />
    
    <div class="page-banner">
        <div class="container">
            <h1 class="banner-title">专家医生团队</h1>
            <p class="banner-subtitle">汇聚各领域顶尖医疗专家，为您提供最权威的诊疗服务</p>
        </div>
    </div>
    
    <div class="container">
        
        <div class="filter-container">
            <div class="filter-scroll">
                <a href="${pageContext.request.contextPath}/doctor?action=list" 
                   class="filter-chip ${empty param.deptId ? 'active' : ''}">
                   全部专家
                </a>
                
                <c:forEach items="${departments}" var="dept">
                    <a href="${pageContext.request.contextPath}/doctor?action=list&deptId=${dept.deptId}" 
                       class="filter-chip ${param.deptId == dept.deptId ? 'active' : ''}">
                        ${dept.deptName}
                    </a>
                </c:forEach>
            </div>
        </div>
        
        <div class="doctor-grid">
            <c:forEach items="${doctors}" var="doctor">
                <a href="${pageContext.request.contextPath}/doctor?action=detail&id=${doctor.doctorId}" class="doc-card">
                    <div class="card-top-bg"></div>
                    
                    <div class="avatar-wrapper">
                        <div class="avatar-inner">
                            <i class="fas fa-user-md"></i>
                        </div>
                    </div>
                    
                    <div class="doc-info">
                        <h3 class="doc-name">${doctor.name}</h3>
                        <span class="title-badge">${doctor.title}</span>
                        <div class="dept-name">
                            <i class="far fa-hospital"></i> ${doctor.deptName}
                        </div>
                    </div>
                    
                    <div class="card-action">
                        查看详情及预约 <i class="fas fa-angle-right" style="margin-left: 5px;"></i>
                    </div>
                </a>
            </c:forEach>
        </div>
        
        <c:if test="${empty doctors}">
            <div class="empty-state">
                <i class="fas fa-user-nurse empty-icon"></i>
                <h3 style="color: #475569; margin-bottom: 10px;">暂无相关医生</h3>
                <p>当前科室下暂无医生排班信息，请切换其他科室查看。</p>
                <a href="${pageContext.request.contextPath}/doctor?action=list" class="btn btn-primary" style="margin-top: 20px; border-radius: 50px; padding: 10px 30px;">
                    查看所有医生
                </a>
            </div>
        </c:if>
        
    </div>
    
    <jsp:include page="/footer.jsp" />
</body>
</html>