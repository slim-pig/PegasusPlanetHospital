<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>系统管理后台 - 飞马星球医院</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* =========================================
           企业级后台登录样式
           ========================================= */
        :root {
            /* 后台专属深色系 */
            --admin-bg: #f0f2f5;
            --sidebar-bg: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            --accent-color: #3b82f6; /* 科技蓝 */
            --accent-hover: #2563eb;
            --text-main: #1e293b;
            --text-sub: #64748b;
            --border-color: #e2e8f0;
            --shadow-card: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: var(--admin-bg);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* 主容器：左右分栏布局 */
        .login-container {
            width: 900px;
            height: 550px;
            background: #fff;
            border-radius: 20px;
            box-shadow: var(--shadow-card);
            display: flex;
            overflow: hidden;
            position: relative;
        }

        /* 左侧：品牌展示区 */
        .brand-side {
            flex: 1;
            background: var(--sidebar-bg);
            color: white;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: flex-start;
            position: relative;
            overflow: hidden;
        }
        
        /* 左侧背景装饰 */
        .brand-side::before {
            content: '';
            position: absolute;
            top: -50px;
            right: -50px;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(59, 130, 246, 0.2) 0%, rgba(0,0,0,0) 70%);
            border-radius: 50%;
        }
        .brand-side::after {
            content: '';
            position: absolute;
            bottom: -50px;
            left: -50px;
            width: 200px;
            height: 200px;
            background: radial-gradient(circle, rgba(6, 182, 212, 0.15) 0%, rgba(0,0,0,0) 70%);
            border-radius: 50%;
        }

        .brand-content {
            position: relative;
            z-index: 2;
        }
        .brand-logo {
            font-size: 3rem;
            margin-bottom: 20px;
            color: var(--accent-color);
        }
        .brand-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 10px;
            line-height: 1.2;
        }
        .brand-desc {
            font-size: 1rem;
            color: #94a3b8;
            margin-top: 15px;
            line-height: 1.6;
        }

        /* 右侧：表单区 */
        .form-side {
            flex: 1.2;
            padding: 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background: #fff;
        }

        .form-header {
            margin-bottom: 30px;
        }
        .form-header h2 {
            font-size: 1.5rem;
            color: var(--text-main);
            margin-bottom: 5px;
        }
        .form-header p {
            color: var(--text-sub);
            font-size: 0.9rem;
        }

        /* 表单控件 */
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            display: block;
            margin-bottom: 8px;
            color: var(--text-main);
            font-weight: 600;
            font-size: 0.9rem;
        }

        .input-wrapper {
            position: relative;
        }
        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            transition: color 0.3s;
        }
        .form-control {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 0.95rem;
            transition: all 0.3s;
            background: #f8fafc;
        }
        .form-control:focus {
            outline: none;
            border-color: var(--accent-color);
            background: #fff;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        .form-control:focus + .input-icon {
            color: var(--accent-color);
        }

        /* 登录按钮 */
        .btn-submit {
            width: 100%;
            padding: 12px;
            background: var(--accent-color);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }
        .btn-submit:hover {
            background: var(--accent-hover);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }

        /* 错误提示 */
        .alert {
            padding: 12px;
            background: #fee2e2;
            border: 1px solid #fecaca;
            color: #ef4444;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* 底部链接 */
        .back-link {
            text-align: center;
            margin-top: 25px;
            font-size: 0.85rem;
        }
        .back-link a {
            color: var(--text-sub);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: color 0.3s;
        }
        .back-link a:hover {
            color: var(--accent-color);
        }

        /* 响应式适配 */
        @media (max-width: 960px) {
            .login-container { width: 90%; height: auto; flex-direction: column; }
            .brand-side { padding: 30px; }
            .form-side { padding: 40px 30px; }
            .brand-logo { font-size: 2rem; margin-bottom: 10px; }
            .brand-title { font-size: 1.5rem; }
        }
    </style>
</head>
<body>

    <div class="login-container">
        <div class="brand-side">
            <div class="brand-content">
                <div class="brand-logo">
                    <i class="fas fa-user-shield"></i>
                </div>
                <h1 class="brand-title">Pegasus<br>Management</h1>
                <p class="brand-desc">飞马星球医院 · 核心管理系统<br>安全、高效、专业的数据中心</p>
            </div>
        </div>

        <div class="form-side">
            <div class="form-header">
                <h2>管理员登录</h2>
                <p>请输入您的管理账号以继续</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle"></i> ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post" autocomplete="off">
                <input type="hidden" name="role" value="admin">

                <div class="form-group">
                    <label for="username" class="form-label">管理员账号</label>
                    <div class="input-wrapper">
                        <input type="text" class="form-control" id="username" name="username" 
                               required placeholder="请输入管理员ID" value="${param.username}">
                        <i class="fas fa-id-badge input-icon"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="password" class="form-label">安全密码</label>
                    <div class="input-wrapper">
                        <input type="password" class="form-control" id="password" name="password" 
                               required placeholder="请输入密码">
                        <i class="fas fa-key input-icon"></i>
                    </div>
                </div>

                <div class="form-group">
                    <button type="submit" class="btn-submit">
                        进入管理后台 <i class="fas fa-arrow-right" style="margin-left: 5px; font-size: 0.8rem;"></i>
                    </button>
                </div>

                <div class="back-link">
                    <a href="${pageContext.request.contextPath}/login.jsp">
                        <i class="fas fa-exchange-alt"></i> 切换至用户/医生登录
                    </a>
                </div>
            </form>
        </div>
    </div>

</body>
</html>