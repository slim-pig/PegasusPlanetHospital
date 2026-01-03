<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>科室导航 - 飞马星球医院</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        /* ============================
           科室列表页专属样式
           ============================ */
        body {
            background-color: #f8fafc;
        }

        /* 顶部 Hero 区域 */
        .page-banner {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            padding: 60px 0;
            text-align: center;
            color: white;
            margin-bottom: 50px;
            position: relative;
            overflow: hidden;
        }
        /* 背景装饰 */
        .page-banner::before {
            content: '';
            position: absolute;
            top: -50px; right: -50px;
            width: 300px; height: 300px;
            background: radial-gradient(circle, rgba(59, 130, 246, 0.15) 0%, rgba(0,0,0,0) 70%);
            border-radius: 50%;
        }
        .banner-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
            position: relative;
            z-index: 1;
        }
        .banner-subtitle {
            font-size: 1.1rem;
            color: #94a3b8;
            font-weight: 300;
            max-width: 600px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }

        /* 网格布局 */
        .dept-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 30px;
            padding-bottom: 60px;
        }

        /* 科室卡片 */
        .dept-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
            border: 1px solid #f1f5f9;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
            position: relative;
            display: flex;
            flex-direction: column;
        }

        /* 顶部装饰条 */
        .dept-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 6px;
            background: linear-gradient(90deg, var(--primary-color, #0056b3), var(--accent-color, #00c4cc));
            opacity: 0;
            transition: opacity 0.3s;
        }

        /* 卡片悬停效果 */
        .dept-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            border-color: transparent;
        }
        .dept-card:hover::before {
            opacity: 1;
        }

        /* 图标区域 */
        .card-icon-area {
            padding: 30px 30px 10px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .icon-box {
            width: 60px;
            height: 60px;
            background-color: #eff6ff;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-color, #0056b3);
            font-size: 28px;
            transition: all 0.3s;
        }
        .dept-card:hover .icon-box {
            background-color: var(--primary-color, #0056b3);
            color: white;
            transform: scale(1.1) rotate(-5deg);
        }

        /* 内容区域 */
        .card-content {
            padding: 20px 30px 30px;
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .dept-name {
            font-size: 1.25rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 12px;
            transition: color 0.3s;
        }
        .dept-card:hover .dept-name {
            color: var(--primary-color, #0056b3);
        }
        
        .dept-desc {
            font-size: 0.95rem;
            color: #64748b;
            line-height: 1.6;
            margin-bottom: 20px;
            flex: 1;
            /* 限制显示3行，超出省略 */
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        /* 底部链接 */
        .card-footer {
            border-top: 1px solid #f1f5f9;
            padding-top: 15px;
            margin-top: auto;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            color: var(--primary-color, #0056b3);
            font-weight: 600;
            font-size: 0.9rem;
        }
        .link-text { margin-right: 8px; }
        .link-icon { transition: transform 0.3s; }
        
        .dept-card:hover .link-icon {
            transform: translateX(5px);
        }
    </style>
</head>
<body>
    <jsp:include page="/header.jsp" />
    
    <div class="page-banner">
        <div class="container">
            <h1 class="banner-title">特色重点科室</h1>
            <p class="banner-subtitle">汇聚顶尖医疗资源，打造 50+ 个标准化诊疗中心，为您提供专业、全面、精准的健康服务。</p>
        </div>
    </div>
    
    <div class="container">
        <div class="dept-grid">
            <c:forEach items="${departments}" var="dept">
                <div class="dept-card" onclick="location.href='${pageContext.request.contextPath}/doctor?action=list&deptId=${dept.deptId}'">
                    
                    <div class="card-icon-area">
                        <div class="icon-box">
                            <i class="fas fa-stethoscope"></i>
                        </div>
                    </div>
                    
                    <div class="card-content">
                        <h3 class="dept-name">${dept.deptName}</h3>
                        <p class="dept-desc">${dept.description}</p>
                        
                        <div class="card-footer">
                            <span class="link-text">查看专家团队</span>
                            <i class="fas fa-arrow-right link-icon"></i>
                        </div>
                    </div>
                    
                </div>
            </c:forEach>
        </div>
    </div>
    
    <jsp:include page="/footer.jsp" />
</body>
</html>