<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>修改密码 - 飞马星球医院</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        body { background-color: #f8fafc; }

        /* 侧边栏样式 (保持全局统一) */
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

        /* 密码修改卡片 */
        .password-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            border: 1px solid #e2e8f0;
            max-width: 600px; /* 限制宽度，更聚拢 */
            margin: 0 auto; /* 居中显示 */
            overflow: hidden;
        }
        
        .card-header {
            padding: 24px 30px;
            border-bottom: 1px solid #e2e8f0;
            background: #fff;
        }
        .card-title {
            font-size: 1.25rem;
            color: #1e293b;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-body { padding: 30px 40px; }

        /* 表单控件 */
        .form-group { margin-bottom: 20px; }
        .form-label {
            display: block;
            margin-bottom: 8px;
            color: #1e293b;
            font-weight: 600;
            font-size: 0.9rem;
        }
        
        .input-wrapper { position: relative; }
        .input-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            pointer-events: none;
            transition: color 0.2s;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 16px 12px 42px; /* 左侧留出图标位置 */
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 0.95rem;
            color: #334155;
            transition: all 0.2s;
            background-color: #f8fafc;
            outline: none;
        }
        .form-control:focus {
            background-color: #fff;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        .form-control:focus + .input-icon { color: var(--primary-color); }

        /* 按钮 */
        .btn-submit {
            background: #60a5fa;
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            width: 100%;
            margin-top: 10px;
            box-shadow: 0 4px 6px rgba(59, 130, 246, 0.2);
        }
        .btn-submit:hover {
            background: #2563eb;
            transform: translateY(-1px);
            box-shadow: 0 6px 12px rgba(59, 130, 246, 0.3);
        }

        /* 提示框 */
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-success { background: #f0fdf4; border: 1px solid #dcfce7; color: #166534; }
        .alert-danger { background: #fef2f2; border: 1px solid #fee2e2; color: #991b1b; }
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
                        <p style="font-size: 0.85rem; color: #64748b; margin: 5px 0 0;">ID: ${sessionScope.patient.patientId}</p>
                    </div>
                    <ul class="side-menu" style="list-style: none; padding: 10px 0; margin: 0;">
                        <li>
                            <a href="${pageContext.request.contextPath}/patient?action=index">
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
                            <a href="${pageContext.request.contextPath}/patient?action=password" class="active">
                                <i class="fas fa-key" style="width: 24px;"></i> 修改登录密码
                            </a>
                        </li>
                    </ul>
                </div>
            </aside>

            <main style="flex: 1;">
                <div class="password-card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-shield-alt" style="color: var(--primary-color);"></i>
                            安全设置
                        </h2>
                    </div>
                    
                    <div class="card-body">
                        <c:if test="${not empty msg}">
                            <div class="alert alert-success">
                                <i class="fas fa-check-circle"></i> ${msg}
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">
                                <i class="fas fa-exclamation-circle"></i> ${error}
                            </div>
                        </c:if>
                        
                        <form action="${pageContext.request.contextPath}/patient" method="post" class="needs-validation">
                            <input type="hidden" name="action" value="password">
                            
                            <div class="form-group">
                                <label for="oldPassword" class="form-label">当前密码</label>
                                <div class="input-wrapper">
                                    <input type="password" class="form-control" id="oldPassword" name="oldPassword" required placeholder="请输入正在使用的密码">
                                    <i class="fas fa-lock input-icon"></i>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="newPassword" class="form-label">新密码</label>
                                <div class="input-wrapper">
                                    <input type="password" class="form-control" id="newPassword" name="newPassword" required minlength="4" placeholder="设置新密码 (至少4位字符)">
                                    <i class="fas fa-key input-icon"></i>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="confirmPassword" class="form-label">确认新密码</label>
                                <div class="input-wrapper">
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required minlength="4" placeholder="再次输入新密码">
                                    <i class="fas fa-check-circle input-icon"></i>
                                </div>
                            </div>
                            
                            <div class="form-group" style="margin-top: 30px;">
                                <button type="submit" class="btn-submit">
                                    确认修改密码
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <jsp:include page="/footer.jsp" />
    
    <script>
        document.querySelector('form').addEventListener('submit', function(e) {
            var pwd = document.getElementById('newPassword').value;
            var confirmPwd = document.getElementById('confirmPassword').value;
            if (pwd !== confirmPwd) {
                e.preventDefault();
                alert('两次输入的新密码不一致，请重新输入。');
            }
        });
    </script>
</body>
</html>