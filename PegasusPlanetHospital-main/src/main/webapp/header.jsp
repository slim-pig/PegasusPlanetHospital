<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
    /* Header 专属样式 */
    .site-header {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
        box-shadow: 0 2px 15px rgba(0,0,0,0.05);
        position: sticky;
        top: 0;
        z-index: 1000;
        height: 70px;
        display: flex;
        align-items: center;
    }
    
    .site-header .container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        width: 100%;
    }

    .navbar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        width: 100%;
    }

    .logo {
        font-size: 1.5rem;
        font-weight: 800;
        color: var(--primary-color, #0056b3);
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .nav-links {
        display: flex;
        gap: 30px;
    }

    .nav-links a {
        text-decoration: none;
        color: #334155;
        font-weight: 500;
        font-size: 0.95rem;
        position: relative;
        transition: color 0.3s;
    }

    .nav-links a:hover, .nav-links a.active {
        color: var(--primary-color, #0056b3);
    }

    /* 底部游标动画 */
    .nav-links a::after {
        content: '';
        position: absolute;
        width: 0;
        height: 2px;
        bottom: -5px;
        left: 0;
        background-color: var(--primary-color, #0056b3);
        transition: width 0.3s;
    }
    .nav-links a:hover::after, .nav-links a.active::after {
        width: 100%;
    }

    .user-menu {
        display: flex;
        align-items: center;
        gap: 15px;
    }
    .user-welcome {
        font-size: 0.9rem;
        color: #64748b;
        font-weight: 500;
    }

    .btn-header {
        padding: 6px 18px;
        border-radius: 20px;
        font-size: 0.9rem;
        text-decoration: none;
        transition: all 0.2s;
    }
    .btn-header-outline {
        border: 1px solid #cbd5e1;
        color: #334155;
    }
    .btn-header-outline:hover {
        border-color: var(--primary-color, #0056b3);
        color: var(--primary-color, #0056b3);
    }
    .btn-header-primary {
        background: var(--primary-color, #0056b3);
        color: white;
        border: 1px solid var(--primary-color, #0056b3);
        box-shadow: 0 4px 6px rgba(0, 86, 179, 0.2);
    }
    .btn-header-primary:hover {
        transform: translateY(-1px);
        box-shadow: 0 6px 8px rgba(0, 86, 179, 0.3);
    }
    .btn-header-danger {
        color: #ef4444;
        font-size: 0.9rem;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 5px;
    }
    .btn-header-danger:hover {
        color: #dc2626;
    }
</style>

<header class="site-header">
    <div class="container">
        <nav class="navbar">
            <a href="${pageContext.request.contextPath}/" class="logo">
                <i class="fas fa-hospital-alt" style="color: var(--accent-color, #00c4cc);"></i>
                飞马星球医院
            </a>
            
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/" class="${pageContext.request.servletPath == '/index.jsp' ? 'active' : ''}">首页</a>
                <a href="${pageContext.request.contextPath}/department?action=list" class="${param.action == 'list' && pageContext.request.servletPath.contains('department') ? 'active' : ''}">科室导航</a>
                <a href="${pageContext.request.contextPath}/doctor?action=list" class="${param.action == 'list' && pageContext.request.servletPath.contains('doctor') ? 'active' : ''}">专家团队</a>
                <a href="${pageContext.request.contextPath}/patient?action=notice" class="${param.action == 'notice' ? 'active' : ''}">预约须知</a>
            </div>
            
            <div class="user-menu">
                <c:choose>
                    <c:when test="${not empty sessionScope.patient}">
                        <span class="user-welcome">欢迎, ${sessionScope.patient.name}</span>
                        <a href="${pageContext.request.contextPath}/patient?action=index" class="btn-header btn-header-outline">个人中心</a>
                        <a href="${pageContext.request.contextPath}/login?action=logout" class="btn-header-danger"><i class="fas fa-sign-out-alt"></i></a>
                    </c:when>
                    <c:when test="${not empty sessionScope.admin}">
                        <span class="user-welcome">管理员: ${sessionScope.admin.username}</span>
                        <a href="${pageContext.request.contextPath}/admin?action=dashboard" class="btn-header btn-header-outline">管理后台</a>
                        <a href="${pageContext.request.contextPath}/login?action=logout" class="btn-header-danger"><i class="fas fa-sign-out-alt"></i></a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login.jsp" class="btn-header btn-header-outline">登录</a>
                        <a href="${pageContext.request.contextPath}/register.jsp" class="btn-header btn-header-primary">注册</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </nav>
    </div>
</header>