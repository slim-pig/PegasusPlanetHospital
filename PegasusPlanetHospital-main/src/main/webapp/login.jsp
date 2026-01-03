<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户登录 - 飞马星球医院</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* =========================================
           企业级登录页样式 - 飞马星球医院
           ========================================= */
        :root {
            --primary-color: #0056b3;
            --primary-gradient: linear-gradient(135deg, #0056b3 0%, #007bff 100%);
            --accent-color: #00c4cc;
            --text-dark: #1e293b;
            --text-gray: #64748b;
            --bg-gradient: linear-gradient(135deg, #f0f7ff 0%, #e0eaff 100%);
            --white: #ffffff;
            --shadow-lg: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            --input-bg: #f8fafc;
            --input-border: #e2e8f0;
            --radius: 12px;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background: var(--bg-gradient);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        /* 背景装饰元素 */
        .bg-decoration {
            position: absolute;
            border-radius: 50%;
            z-index: 0;
            opacity: 0.6;
        }
        .circle-1 {
            width: 400px;
            height: 400px;
            background: rgba(0, 196, 204, 0.1);
            top: -100px;
            right: -100px;
            filter: blur(60px);
        }
        .circle-2 {
            width: 300px;
            height: 300px;
            background: rgba(0, 86, 179, 0.1);
            bottom: -50px;
            left: -50px;
            filter: blur(60px);
        }

        /* 登录卡片容器 */
        .login-wrapper {
            position: relative;
            z-index: 10;
            width: 100%;
            max-width: 420px;
            padding: 20px;
        }

        .card {
            background: var(--white);
            border-radius: 20px;
            box-shadow: var(--shadow-lg);
            padding: 40px;
            border: 1px solid rgba(255, 255, 255, 0.8);
        }

        /* 头部 LOGO */
        .auth-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .logo-area {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 60px;
            height: 60px;
            background: #eff6ff;
            color: var(--primary-color);
            border-radius: 50%;
            font-size: 28px;
            margin-bottom: 15px;
        }
        .auth-header h2 {
            color: var(--text-dark);
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 8px;
        }
        .auth-header p {
            color: var(--text-gray);
            font-size: 0.95rem;
        }

        /* 表单样式 */
        .form-group {
            margin-bottom: 20px;
            position: relative;
        }
        .form-label {
            display: block;
            margin-bottom: 8px;
            color: var(--text-dark);
            font-weight: 500;
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
            padding: 12px 15px 12px 45px; /* 左边距留给图标 */
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
            border-radius: var(--radius);
            font-size: 1rem;
            color: var(--text-dark);
            transition: all 0.3s;
            outline: none;
        }
        .form-control:focus {
            background-color: var(--white);
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(0, 86, 179, 0.1);
        }
        .form-control:focus + .input-icon {
            color: var(--primary-color);
        }

        /* 按钮样式 */
        .btn-primary {
            width: 100%;
            padding: 14px;
            background: var(--primary-gradient);
            color: white;
            border: none;
            border-radius: var(--radius);
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
            box-shadow: 0 4px 6px rgba(0, 86, 179, 0.2);
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 15px rgba(0, 86, 179, 0.3);
        }

        /* 提示框样式 */
        .alert {
            padding: 12px 16px;
            border-radius: var(--radius);
            margin-bottom: 20px;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-danger {
            background-color: #fef2f2;
            color: #ef4444;
            border: 1px solid #fee2e2;
        }
        .alert-success {
            background-color: #f0fdf4;
            color: #16a34a;
            border: 1px solid #dcfce7;
        }

        /* 底部链接 */
        .auth-footer {
            text-align: center;
            margin-top: 25px;
            font-size: 0.9rem;
            color: var(--text-gray);
        }
        .auth-footer a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }
        .auth-footer a:hover {
            color: #004494;
        }
        .divider {
            height: 1px;
            background: #e2e8f0;
            margin: 20px 0;
        }
        .admin-link {
            font-size: 0.85rem;
            color: #94a3b8 !important;
        }
        .admin-link:hover {
            color: var(--text-dark) !important;
        }
        
        .return-home {
            text-align: center;
            margin-bottom: 20px;
        }
        .return-home a {
            color: var(--text-gray);
            text-decoration: none;
            font-size: 0.9rem;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: color 0.3s;
        }
        .return-home a:hover { color: var(--primary-color); }
    </style>
</head>
<body>
    <div class="bg-decoration circle-1"></div>
    <div class="bg-decoration circle-2"></div>

    <div class="login-wrapper">
        <div class="return-home">
            <a href="${pageContext.request.contextPath}/">
                <i class="fas fa-arrow-left"></i> 返回首页
            </a>
        </div>

        <div class="card">
            <div class="auth-header">
                <div class="logo-area">
                    <i class="fas fa-hospital-user"></i>
                </div>
                <h2>用户登录</h2>
                <p>飞马星球医院 · 健康管理平台</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> 
                    <span>${error}</span>
                </div>
            </c:if>

            <c:if test="${not empty param.msg && param.msg == 'registerSuccess'}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span>注册成功，请登录您的账号</span>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post" class="needs-validation">
                <input type="hidden" name="role" value="patient">

                <div class="form-group">
                    <label for="username" class="form-label">患者ID / 账号</label>
                    <div class="input-wrapper">
                        <input type="text" class="form-control" id="username" name="username" required placeholder="请输入患者ID" autocomplete="off">
                        <i class="fas fa-user input-icon"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="password" class="form-label">登录密码</label>
                    <div class="input-wrapper">
                        <input type="password" class="form-control" id="password" name="password" required placeholder="请输入您的密码">
                        <i class="fas fa-lock input-icon"></i>
                    </div>
                </div>

                <div class="form-group">
                    <button type="submit" class="btn btn-primary">
                        立即登录 <i class="fas fa-sign-in-alt" style="margin-left:5px;"></i>
                    </button>
                </div>

                <div class="auth-footer">
                    <p>还没有账号？ <a href="${pageContext.request.contextPath}/register.jsp">立即注册</a></p>
                    
                    <div class="divider"></div>
                    
                    <p><a href="${pageContext.request.contextPath}/admin/login.jsp" class="admin-link">
                        <i class="fas fa-user-shield"></i> 管理员/医生登录入口
                    </a></p>
                </div>
            </form>
        </div>
    </div>
</body>
</html>