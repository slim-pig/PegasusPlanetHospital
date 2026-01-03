<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>飞马星球医院 - 专业的医疗健康服务平台</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        /* =========================================
           企业级 UI 样式系统 - 飞马星球医院
           ========================================= */
        :root {
            /* 品牌色系 */
            --primary-color: #0056b3;       /* 深蓝：专业、稳重 */
            --primary-light: #e6f0fa;       /* 浅蓝背景 */
            --accent-color: #00c4cc;        /* 青绿：生机、健康 */
            --accent-hover: #00b0b8;
            
            /* 中性色系 */
            --text-dark: #1e293b;           /* 主标题色 */
            --text-gray: #64748b;           /* 正文色 */
            --bg-light: #f8fafc;            /* 页面背景 */
            --white: #ffffff;
            
            /* 阴影与圆角 */
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --radius-md: 8px;
            --radius-lg: 16px;
            --radius-pill: 50px;
        }

        /* 全局重置 */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: var(--bg-light);
            color: var(--text-dark);
            line-height: 1.6;
            -webkit-font-smoothing: antialiased;
        }
        a { text-decoration: none; transition: all 0.3s ease; }
        ul { list-style: none; }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* ====================
           导航栏 (Navbar)
           ==================== */
        header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(12px);
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: var(--shadow-sm);
            border-bottom: 1px solid rgba(0,0,0,0.05);
        }
        
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 80px;
        }

        .logo {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--primary-color);
            display: flex;
            align-items: center;
            gap: 10px;
            letter-spacing: -0.5px;
        }
        .logo i { font-size: 1.8rem; color: var(--accent-color); }

        .nav-links {
            display: flex;
            gap: 30px;
        }
        .nav-links a {
            color: var(--text-dark);
            font-weight: 500;
            font-size: 1rem;
            position: relative;
        }
        .nav-links a:hover, .nav-links a.active { color: var(--primary-color); }
        /* 导航下划线动画 */
        .nav-links a::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: -5px;
            left: 0;
            background-color: var(--accent-color);
            transition: width 0.3s;
        }
        .nav-links a:hover::after, .nav-links a.active::after { width: 100%; }

        .user-menu {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .user-text {
            font-size: 0.95rem;
            color: var(--text-gray);
            font-weight: 500;
        }
        
        /* 按钮通用样式 */
        .btn {
            padding: 0.6rem 1.5rem;
            border-radius: var(--radius-pill);
            font-weight: 600;
            font-size: 0.95rem;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color) 0%, #007bff 100%);
            color: white;
            box-shadow: 0 4px 10px rgba(0, 86, 179, 0.3);
            border: none;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0, 86, 179, 0.4);
        }
        .btn-outline {
            background: transparent;
            border: 1px solid #cbd5e1;
            color: var(--text-dark);
        }
        .btn-outline:hover {
            border-color: var(--primary-color);
            color: var(--primary-color);
            background-color: var(--primary-light);
        }

        /* ====================
           英雄区域 (Hero)
           ==================== */
        .hero-section {
            /* 使用更高级的科技感背景 */
            background: radial-gradient(circle at 10% 20%, rgb(239, 246, 255) 0%, rgb(255, 255, 255) 90%);
            padding: 8rem 0 10rem; /* 底部留白给统计条 */
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        /* 背景装饰圆圈 */
        .hero-section::before {
            content: '';
            position: absolute;
            top: -100px;
            right: -100px;
            width: 400px;
            height: 400px;
            background: rgba(0, 196, 204, 0.1);
            border-radius: 50%;
            filter: blur(80px);
            z-index: 0;
        }
        .hero-content {
            position: relative;
            z-index: 1;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .hero-title {
            font-size: 3.5rem;
            font-weight: 800;
            line-height: 1.2;
            margin-bottom: 1.5rem;
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            animation: fadeInUp 0.8s ease-out;
        }
        .hero-subtitle {
            font-size: 1.2rem;
            color: var(--text-gray);
            margin-bottom: 3rem;
            font-weight: 400;
            animation: fadeInUp 1s ease-out;
        }
        .hero-actions {
            display: flex;
            gap: 20px;
            justify-content: center;
            animation: fadeInUp 1.2s ease-out;
        }

        /* 动画定义 */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* 提示框美化 */
        .alert-success {
            background-color: #ecfdf5;
            color: #047857;
            border: 1px solid #a7f3d0;
            padding: 1rem 2rem;
            border-radius: var(--radius-pill);
            display: inline-flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-sm);
        }

        /* ====================
           统计数据条 (Stats)
           ==================== */
        .stats-container {
            margin-top: -5rem; /* 负边距上移 */
            position: relative;
            z-index: 10;
        }
        .stats-bar {
            background: white;
            border-radius: var(--radius-lg);
            padding: 3rem;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 2rem;
            box-shadow: var(--shadow-lg);
            border: 1px solid rgba(0,0,0,0.03);
        }
        .stat-item {
            text-align: center;
            border-right: 1px solid #f1f5f9;
        }
        .stat-item:last-child { border-right: none; }
        .stat-item h4 {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }
        .stat-item p {
            color: var(--text-gray);
            font-weight: 500;
            font-size: 1rem;
        }

        /* ====================
           特性区域 (Feature)
           ==================== */
        .feature-section { padding: 6rem 0; }
        .section-header {
            text-align: center;
            margin-bottom: 4rem;
        }
        .section-header h2 {
            font-size: 2.2rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 1rem;
        }
        .section-header p { color: var(--text-gray); font-size: 1.1rem; }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 2rem;
        }
        .feature-card {
            background: white;
            padding: 2.5rem;
            border-radius: var(--radius-lg);
            text-align: center;
            border: 1px solid #f1f5f9;
            transition: all 0.3s ease;
        }
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--shadow-lg);
            border-color: transparent;
        }
        .feature-icon-wrapper {
            width: 70px;
            height: 70px;
            background: var(--primary-light);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            transition: all 0.3s;
        }
        .feature-card:hover .feature-icon-wrapper {
            background: var(--primary-color);
            color: white;
        }
        .feature-icon-wrapper i {
            font-size: 1.8rem;
            color: var(--primary-color);
            transition: all 0.3s;
        }
        .feature-card:hover .feature-icon-wrapper i { color: white; }
        .feature-card h3 {
            font-size: 1.25rem;
            margin-bottom: 1rem;
            color: var(--text-dark);
        }
        .feature-card p {
            color: var(--text-gray);
            font-size: 0.95rem;
            line-height: 1.6;
        }

        /* ====================
           热门科室 (Dept)
           ==================== */
        .dept-section {
            background-color: #fff;
            padding: 6rem 0;
            background-image: linear-gradient(to top, #f8fafc 0%, #fff 100%);
        }
        .dept-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.5rem;
        }
        .dept-item {
            display: flex;
            align-items: flex-start;
            padding: 1.5rem;
            background: white;
            border-radius: var(--radius-md);
            border: 1px solid #e2e8f0;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .dept-item:hover {
            border-color: var(--accent-color);
            box-shadow: var(--shadow-md);
            transform: translateY(-2px);
        }
        .dept-icon {
            font-size: 1.8rem;
            color: var(--accent-color);
            margin-right: 1.2rem;
            background: #effcfc;
            padding: 12px;
            border-radius: 12px;
        }
        .dept-info h4 {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.3rem;
        }
        .dept-info p {
            font-size: 0.85rem;
            color: var(--text-gray);
        }
        
        /* 特殊的“查看所有”卡片 */
        .dept-item.view-all {
            background: var(--primary-color);
            border-color: var(--primary-color);
        }
        .dept-item.view-all .dept-icon {
            background: rgba(255,255,255,0.2);
            color: white;
        }
        .dept-item.view-all h4, .dept-item.view-all p {
            color: white;
        }
        .dept-item.view-all p { opacity: 0.8; }

        /* ====================
           页脚 (Footer)
           ==================== */
        footer {
            background: #0f172a; /* 深邃夜空色 */
            color: #94a3b8;
            padding: 5rem 0 2rem;
            margin-top: 0;
        }
        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 4rem;
            margin-bottom: 3rem;
        }
        .footer-section h3 {
            color: white;
            font-size: 1.2rem;
            margin-bottom: 1.5rem;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        .footer-desc {
            line-height: 1.8;
            margin-bottom: 1.5rem;
        }
        .social-links {
            display: flex;
            gap: 15px;
        }
        .social-links a {
            width: 40px;
            height: 40px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            transition: all 0.3s;
        }
        .social-links a:hover {
            background: var(--accent-color);
            transform: translateY(-3px);
        }
        .footer-links li { margin-bottom: 0.8rem; }
        .footer-links a {
            color: #94a3b8;
            transition: color 0.2s;
            display: inline-flex;
            align-items: center;
        }
        .footer-links a:hover {
            color: var(--accent-color);
            padding-left: 5px;
        }
        .contact-list li {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
        }
        .contact-list i {
            width: 25px;
            color: var(--accent-color);
        }
        .copyright {
            border-top: 1px solid #1e293b;
            padding-top: 2rem;
            text-align: center;
            font-size: 0.9rem;
        }

        /* 响应式适配 */
        @media (max-width: 768px) {
            .navbar { flex-direction: column; height: auto; padding: 15px 0; gap: 15px; }
            .nav-links { gap: 15px; flex-wrap: wrap; justify-content: center; }
            .stats-bar { grid-template-columns: repeat(2, 1fr); gap: 1.5rem; padding: 2rem; }
            .hero-title { font-size: 2.2rem; }
            .stat-item { border-right: none; }
        }
    </style>
</head>
<body>
    <header>
        <div class="container">
            <nav class="navbar">
                <a href="${pageContext.request.contextPath}/" class="logo">
                    <i class="fas fa-hospital-alt"></i>
                    飞马星球医院
                </a>
                
                <div class="nav-links">
                    <a href="${pageContext.request.contextPath}/" class="active">首页</a>
                    <a href="${pageContext.request.contextPath}/department?action=list">科室导航</a>
                    <a href="${pageContext.request.contextPath}/doctor?action=list">专家团队</a>
                    <a href="${pageContext.request.contextPath}/patient?action=notice">预约须知</a>
                </div>
                
                <div class="user-menu">
                    <c:choose>
                        <%-- 已登录：患者 --%>
                        <c:when test="${not empty sessionScope.patient}">
                            <span class="user-text">欢迎, ${sessionScope.patient.name}</span>
                            <a href="${pageContext.request.contextPath}/patient?action=index" class="btn btn-primary">个人中心</a>
                            <a href="${pageContext.request.contextPath}/login?action=logout" class="btn btn-outline">退出</a>
                        </c:when>
                        
                        <%-- 已登录：管理员 --%>
                        <c:when test="${not empty sessionScope.admin}">
                            <span class="user-text">管理员: ${sessionScope.admin.username}</span>
                            <a href="${pageContext.request.contextPath}/admin?action=dashboard" class="btn btn-primary">管理后台</a>
                            <a href="${pageContext.request.contextPath}/login?action=logout" class="btn btn-outline">退出</a>
                        </c:when>
                        
                        <%-- 未登录 --%>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline">登录</a>
                            <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-primary">注册预约</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </nav>
        </div>
    </header>

    <section class="hero-section">
        <div class="container hero-content">
            <c:if test="${param.msg == 'accountDeactivated'}">
                <div class="alert-success">
                    <i class="fas fa-check-circle"></i> 您的账号已成功注销，期待再次为您服务。
                </div>
            </c:if>
            <c:if test="${param.msg == 'registered'}">
                <div class="alert-success">
                    <i class="fas fa-check-circle"></i> 注册成功！欢迎加入飞马星球医院。
                </div>
            </c:if>

            <h1 class="hero-title">守护您的健康<br>从飞马星球开始</h1>
            <p class="hero-subtitle">汇聚顶尖医疗资源，提供全方位健康管理服务。<br>智能预约、专家问诊、电子病历，为您打造极致的就医体验。</p>
            
            <div class="hero-actions">
                <c:if test="${empty sessionScope.patient && empty sessionScope.admin}">
                    <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-primary" style="padding: 0.8rem 2.5rem; font-size: 1.1rem;">立即注册预约</a>
                    <a href="${pageContext.request.contextPath}/department?action=list" class="btn btn-outline" style="padding: 0.8rem 2.5rem; font-size: 1.1rem; background: white;">浏览科室</a>
                </c:if>
                <c:if test="${not empty sessionScope.patient}">
                    <a href="${pageContext.request.contextPath}/department?action=list" class="btn btn-primary" style="padding: 0.8rem 2.5rem; font-size: 1.1rem;">立即预约挂号</a>
                    <a href="${pageContext.request.contextPath}/patient?action=index" class="btn btn-outline" style="padding: 0.8rem 2.5rem; font-size: 1.1rem; background: white;">查看我的预约</a>
                </c:if>
            </div>
        </div>
    </section>

    <div class="container stats-container">
        <div class="stats-bar">
            <div class="stat-item">
                <h4>50+</h4>
                <p>专业科室</p>
            </div>
            <div class="stat-item">
                <h4>200+</h4>
                <p>专家医生</p>
            </div>
            <div class="stat-item">
                <h4>10k+</h4>
                <p>累计服务患者</p>
            </div>
            <div class="stat-item">
                <h4>99%</h4>
                <p>患者满意度</p>
            </div>
        </div>
    </div>

    <section class="feature-section">
        <div class="container">
            <div class="section-header">
                <h2>为什么选择飞马星球医院</h2>
                <p>我们致力于为您提供最优质、最便捷的医疗服务体验</p>
            </div>
            <div class="feature-grid">
                <div class="feature-card">
                    <div class="feature-icon-wrapper">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <h3>顶尖专家团队</h3>
                    <p>汇集国内外知名专家，覆盖各个专科领域，为您提供权威的诊疗方案。</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon-wrapper">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <h3>智能预约系统</h3>
                    <p>24小时在线预约，实时查看号源，告别排队烦恼，合理安排就诊时间。</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon-wrapper">
                        <i class="fas fa-file-medical-alt"></i>
                    </div>
                    <h3>电子健康档案</h3>
                    <p>全程数字化管理，病历、处方、检查报告永久保存，随时随地查阅。</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon-wrapper">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3>隐私安全保障</h3>
                    <p>采用银行级数据加密技术，严格的隐私保护机制，确保您的个人信息安全。</p>
                </div>
            </div>
        </div>
    </section>

    <section class="dept-section">
        <div class="container">
            <div class="section-header">
                <h2>重点特色科室</h2>
                <p>打造一流的特色专科，提供精细化的医疗服务</p>
            </div>
            <div class="dept-grid">
                <a href="${pageContext.request.contextPath}/doctor?action=byDept&deptId=1" class="dept-item">
                    <div class="dept-icon"><i class="fas fa-heartbeat"></i></div>
                    <div class="dept-info">
                        <h4>心血管内科</h4>
                        <p>国家级重点学科，心脏介入治疗</p>
                    </div>
                </a>
                
                <a href="${pageContext.request.contextPath}/doctor?action=byDept&deptId=2" class="dept-item">
                    <div class="dept-icon"><i class="fas fa-brain"></i></div>
                    <div class="dept-info">
                        <h4>神经外科</h4>
                        <p>微创神经外科手术中心</p>
                    </div>
                </a>
                
                <a href="${pageContext.request.contextPath}/doctor?action=byDept&deptId=3" class="dept-item">
                    <div class="dept-icon"><i class="fas fa-baby"></i></div>
                    <div class="dept-info">
                        <h4>儿科中心</h4>
                        <p>儿童全方位健康管理</p>
                    </div>
                </a>
                
                <a href="${pageContext.request.contextPath}/doctor?action=byDept&deptId=4" class="dept-item">
                    <div class="dept-icon"><i class="fas fa-tooth"></i></div>
                    <div class="dept-info">
                        <h4>口腔科</h4>
                        <p>数字化口腔诊疗中心</p>
                    </div>
                </a>
                
                <a href="${pageContext.request.contextPath}/doctor?action=byDept&deptId=5" class="dept-item">
                    <div class="dept-icon"><i class="fas fa-eye"></i></div>
                    <div class="dept-info">
                        <h4>眼科</h4>
                        <p>屈光手术与眼底病诊治</p>
                    </div>
                </a>
                
                <a href="${pageContext.request.contextPath}/doctor?action=byDept&deptId=6" class="dept-item">
                    <div class="dept-icon"><i class="fas fa-bone"></i></div>
                    <div class="dept-info">
                        <h4>骨科</h4>
                        <p>关节置换与运动医学</p>
                    </div>
                </a>
                
                <a href="${pageContext.request.contextPath}/doctor?action=byDept&deptId=7" class="dept-item">
                    <div class="dept-icon"><i class="fas fa-lungs"></i></div>
                    <div class="dept-info">
                        <h4>呼吸内科</h4>
                        <p>呼吸危重症与睡眠医学</p>
                    </div>
                </a>
                
                <a href="${pageContext.request.contextPath}/department?action=list" class="dept-item view-all">
                    <div class="dept-icon"><i class="fas fa-arrow-right"></i></div>
                    <div class="dept-info">
                        <h4>查看所有科室</h4>
                        <p>浏览全部50+科室</p>
                    </div>
                </a>
            </div>
        </div>
    </section>

    <footer>
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>关于飞马星球</h3>
                    <p class="footer-desc">飞马星球医院是一所集医疗、教学、科研、预防、保健、康复为一体的大型现代化综合性医院。我们始终坚持"以患者为中心"的服务理念。</p>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-weixin"></i></a>
                        <a href="#"><i class="fab fa-weibo"></i></a>
                        <a href="#"><i class="fab fa-tiktok"></i></a>
                    </div>
                </div>
                
                <div class="footer-section">
                    <h3>快速导航</h3>
                    <ul class="footer-links">
                        <li><a href="${pageContext.request.contextPath}/department?action=list">科室导航</a></li>
                        <li><a href="${pageContext.request.contextPath}/doctor?action=list">专家团队</a></li>
                        <li><a href="${pageContext.request.contextPath}/patient?action=notice">预约须知</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/login.jsp">管理员入口</a></li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h3>联系我们</h3>
                    <ul class="contact-list">
                        <li><i class="fas fa-map-marker-alt"></i> 飞马星球中央大道1号</li>
                        <li><i class="fas fa-phone"></i> 010-88888888 (预约热线)</li>
                        <li><i class="fas fa-ambulance"></i> 010-120 (急救中心)</li>
                        <li><i class="fas fa-envelope"></i> contact@pegasus-hospital.com</li>
                    </ul>
                </div>
            </div>
            
            <div class="copyright">
                <p>&copy; 2023 飞马星球医院 (Pegasus Planet Hospital) 版权所有 | 隐私政策 | 服务条款</p>
            </div>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>