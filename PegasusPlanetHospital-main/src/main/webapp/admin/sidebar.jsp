<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    :root {
        --sidebar-bg: #1e293b;        /* 深蓝灰背景 */
        --sidebar-hover: #334155;     /* 悬停色 */
        --sidebar-active: #0f172a;    /* 选中色 */
        --accent-color: #3b82f6;      /* 品牌蓝 */
        --text-light: #e2e8f0;        /* 亮色文字 */
        --text-dim: #94a3b8;          /* 暗色文字 */
    }

    .sidebar {
        width: 260px;
        background: var(--sidebar-bg);
        color: var(--text-light);
        min-height: 100vh;
        display: flex;
        flex-direction: column;
        box-shadow: 4px 0 10px rgba(0,0,0,0.1);
        z-index: 100;
        transition: all 0.3s ease;
    }

    /* 顶部 LOGO 区 */
    .sidebar-header {
        height: 80px;
        display: flex;
        align-items: center;
        padding: 0 24px;
        background: rgba(0,0,0,0.1);
        border-bottom: 1px solid rgba(255,255,255,0.05);
    }
    .logo-icon {
        font-size: 28px;
        color: var(--accent-color);
        margin-right: 12px;
    }
    .logo-text {
        font-size: 18px;
        font-weight: 700;
        letter-spacing: 0.5px;
        color: #fff;
    }

    /* 用户信息区 */
    .user-profile {
        padding: 24px;
        border-bottom: 1px solid rgba(255,255,255,0.05);
        display: flex;
        align-items: center;
        gap: 15px;
    }
    .avatar-circle {
        width: 48px;
        height: 48px;
        border-radius: 50%;
        background: linear-gradient(135deg, var(--accent-color), #60a5fa);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
        color: #fff;
        box-shadow: 0 4px 6px rgba(0,0,0,0.2);
    }
    .user-info .name {
        font-weight: 600;
        font-size: 15px;
        color: #fff;
    }
    .user-info .role {
        font-size: 12px;
        color: var(--text-dim);
        margin-top: 2px;
        background: rgba(255,255,255,0.1);
        padding: 2px 8px;
        border-radius: 10px;
        display: inline-block;
    }

    /* 导航菜单 */
    .nav-menu {
        flex: 1;
        padding: 20px 12px;
        overflow-y: auto;
    }
    .nav-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    .nav-item {
        margin-bottom: 4px;
    }
    .nav-link {
        display: flex;
        align-items: center;
        padding: 12px 16px;
        color: var(--text-dim);
        text-decoration: none;
        border-radius: 8px;
        transition: all 0.2s ease;
        font-size: 14px;
        font-weight: 500;
    }
    .nav-link i {
        width: 24px;
        font-size: 16px;
        margin-right: 12px;
        text-align: center;
        transition: transform 0.2s;
    }
    
    /* 悬停态 */
    .nav-link:hover {
        background-color: var(--sidebar-hover);
        color: #fff;
        transform: translateX(4px);
    }
    .nav-link:hover i {
        transform: scale(1.1);
    }

    /* 选中态 */
    .nav-link.active-menu {
        background: var(--accent-color);
        color: #fff;
        box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
    }
    .nav-link.active-menu i {
        color: #fff;
    }

    /* 底部退出区 */
    .sidebar-footer {
        padding: 20px 24px;
        border-top: 1px solid rgba(255,255,255,0.05);
    }
    .logout-btn {
        display: flex;
        align-items: center;
        color: #ef4444; /* 红色 */
        text-decoration: none;
        font-size: 14px;
        font-weight: 500;
        transition: opacity 0.2s;
    }
    .logout-btn:hover {
        opacity: 0.8;
    }
    .logout-btn i {
        margin-right: 10px;
    }
</style>

<aside class="sidebar">
    <div class="sidebar-header">
        <i class="fas fa-hospital-alt logo-icon"></i>
        <span class="logo-text">医院管理系统</span>
    </div>
    
    <div class="user-profile">
        <div class="avatar-circle">
            <i class="fas fa-user-shield"></i>
        </div>
        <div class="user-info">
            <div class="name">${sessionScope.admin.username}</div>
            <div class="role">超级管理员</div>
        </div>
    </div>
    
    <nav class="nav-menu">
        <ul class="nav-list">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin?action=dashboard" class="nav-link ${param.action == 'dashboard' || param.action == null ? 'active-menu' : ''}">
                    <i class="fas fa-tachometer-alt"></i>
                    <span>仪表盘</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin?action=doctors" class="nav-link ${param.action == 'doctors' || param.action == 'doctorForm' ? 'active-menu' : ''}">
                    <i class="fas fa-user-md"></i>
                    <span>医生管理</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin?action=schedules" class="nav-link ${param.action == 'schedules' || param.action == 'scheduleForm' ? 'active-menu' : ''}">
                    <i class="fas fa-calendar-alt"></i>
                    <span>排班管理</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin?action=appointments" class="nav-link ${param.action == 'appointments' ? 'active-menu' : ''}">
                    <i class="fas fa-clipboard-list"></i>
                    <span>预约管理</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin?action=patients" class="nav-link ${param.action == 'patients' ? 'active-menu' : ''}">
                    <i class="fas fa-users"></i>
                    <span>患者管理</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin?action=statistics" class="nav-link ${param.action == 'statistics' ? 'active-menu' : ''}">
                    <i class="fas fa-chart-bar"></i>
                    <span>统计报表</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin?action=import" class="nav-link ${param.action == 'import' ? 'active-menu' : ''}">
                    <i class="fas fa-file-import"></i>
                    <span>数据导入</span>
                </a>
            </li>
        </ul>
    </nav>
    
    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/login?action=logout" class="logout-btn">
            <i class="fas fa-sign-out-alt"></i> 退出登录
        </a>
    </div>
</aside>