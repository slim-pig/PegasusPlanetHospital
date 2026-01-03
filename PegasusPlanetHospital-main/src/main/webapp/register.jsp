<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册 - 飞马星球医院</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* =========================================
           企业级注册页样式 - 飞马星球医院
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
            --error-color: #ef4444;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background: var(--bg-gradient);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px; /* 增加上下内边距，防止高度不够 */
        }

        /* 注册卡片容器 */
        .auth-container {
            width: 100%;
            max-width: 520px; /*稍微加宽一点 */
            position: relative;
            z-index: 10;
        }

        .card {
            background: var(--white);
            border-radius: 20px;
            box-shadow: var(--shadow-lg);
            padding: 40px;
            border: 1px solid rgba(255, 255, 255, 0.8);
        }

        /* 头部样式 */
        .auth-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .auth-header h2 {
            color: var(--text-dark);
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 10px;
        }
        .auth-header p {
            color: var(--text-gray);
            font-size: 0.95rem;
        }

        /* 表单通用样式 */
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            display: block;
            margin-bottom: 8px;
            color: var(--text-dark);
            font-weight: 600;
            font-size: 0.9rem;
        }
        .form-text {
            font-size: 0.8rem;
            color: var(--text-gray);
            margin-top: 5px;
            margin-left: 5px;
        }

        /* 输入框包装器（用于放图标） */
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
            pointer-events: none;
        }
        .form-control {
            width: 100%;
            padding: 12px 15px 12px 45px; /* 左侧留出图标位置 */
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

        /* 性别单选按钮美化 (Button Group) */
        .gender-group {
            display: flex;
            gap: 15px;
        }
        /* 隐藏原始radio */
        .gender-group input[type="radio"] {
            display: none;
        }
        .gender-label {
            flex: 1;
            padding: 10px;
            text-align: center;
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
            border-radius: var(--radius);
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 500;
            color: var(--text-gray);
        }
        .gender-label:hover {
            background-color: #e6effd;
            border-color: #cbd5e1;
        }
        /* 选中状态 */
        .gender-group input[type="radio"]:checked + .gender-label {
            background-color: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
            box-shadow: 0 4px 6px rgba(0, 86, 179, 0.2);
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

        /* 提示框美化 */
        .alert {
            padding: 12px 16px;
            border-radius: var(--radius);
            margin-bottom: 25px;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-danger {
            background-color: #fef2f2;
            color: var(--error-color);
            border: 1px solid #fee2e2;
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
        .auth-footer a:hover { text-decoration: underline; }

        /* 返回首页浮动按钮 */
        .back-home {
            position: absolute;
            top: -40px;
            left: 0;
            font-size: 0.9rem;
        }
        .back-home a {
            color: var(--text-gray);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 5px;
            transition: color 0.3s;
        }
        .back-home a:hover { color: var(--primary-color); }

        /* 错误反馈文字 */
        .invalid-feedback {
            color: var(--error-color);
            font-size: 0.85rem;
            margin-top: 5px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .invalid-feedback::before {
            content: '\f06a';
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
        }
    </style>
</head>
<body>

    <div class="auth-container">
        <div class="back-home">
            <a href="${pageContext.request.contextPath}/">
                <i class="fas fa-arrow-left"></i> 返回首页
            </a>
        </div>

        <div class="card">
            <div class="auth-header">
                <h2><i class="fas fa-user-plus" style="color: var(--accent-color); margin-right: 10px;"></i>用户注册</h2>
                <p>创建您的个人账号，开启飞马星球便捷就医之旅</p>
            </div>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> 
                    <span>${error}</span>
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/register" method="post" class="needs-validation" autocomplete="off">
                
                <div class="form-group">
                    <label for="name" class="form-label">真实姓名</label>
                    <div class="input-wrapper">
                        <input type="text" class="form-control" id="name" name="name" required value="${param.name}" placeholder="请输入您的真实姓名">
                        <i class="fas fa-user input-icon"></i>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">性别</label>
                    <div class="gender-group">
                        <input type="radio" id="gender-male" name="gender" value="男" checked>
                        <label for="gender-male" class="gender-label"><i class="fas fa-mars"></i> 男</label>
                        
                        <input type="radio" id="gender-female" name="gender" value="女">
                        <label for="gender-female" class="gender-label"><i class="fas fa-venus"></i> 女</label>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="idCard" class="form-label">身份证号</label>
                    <div class="input-wrapper">
                        <input type="text" class="form-control" id="idCard" name="idCard" required 
                               pattern="\d{17}[\dXx]" title="请输入18位身份证号" value="${param.idCard}" placeholder="请输入18位身份证号码">
                        <i class="fas fa-id-card input-icon"></i>
                    </div>
                    <div class="form-text"><i class="fas fa-info-circle"></i> 必须年满10周岁方可注册</div>
                </div>
                
                <div class="form-group">
                    <label for="phone" class="form-label">手机号码</label>
                    <div class="input-wrapper">
                        <input type="tel" class="form-control" id="phone" name="phone" required 
                               pattern="1[3-9]\d{9}" title="请输入11位手机号" value="${param.phone}" 
                               onblur="checkPhone(this)" placeholder="请输入11位手机号码">
                        <i class="fas fa-mobile-alt input-icon"></i>
                    </div>
                    <div id="phone-feedback" class="invalid-feedback" style="display:none;"></div>
                </div>
                
                <div class="form-group">
                    <label for="password" class="form-label">设置密码</label>
                    <div class="input-wrapper">
                        <input type="password" class="form-control" id="password" name="password" 
                               required minlength="4" placeholder="请设置登录密码（至少4位）">
                        <i class="fas fa-lock input-icon"></i>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword" class="form-label">确认密码</label>
                    <div class="input-wrapper">
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                               required minlength="4" placeholder="请再次输入密码">
                        <i class="fas fa-check-circle input-icon"></i>
                    </div>
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">立即注册</button>
                </div>
                
                <div class="auth-footer">
                    <p>已有账号？ <a href="${pageContext.request.contextPath}/login.jsp">直接登录 <i class="fas fa-angle-right"></i></a></p>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js" charset="UTF-8"></script>
    
    <script>
        // 覆盖 main.js 中的 checkPhone，解决中文乱码问题
        function checkPhone(phoneInput) {
            const phone = phoneInput.value;
            const feedback = document.getElementById('phone-feedback');
            
            if (phone.length === 11) {
                fetch('${pageContext.request.contextPath}/api?resource=checkPhone&phone=' + phone)
                    .then(response => response.json())
                    .then(data => {
                        if (data.exists) {
                            phoneInput.setCustomValidity('该手机号已注册');
                            feedback.textContent = '该手机号已注册';
                            feedback.style.display = 'block';
                            feedback.style.color = '#dc3545';
                        } else {
                            phoneInput.setCustomValidity('');
                            feedback.style.display = 'none';
                        }
                    })
                    .catch(error => console.error('Error:', error));
            }
        }

        document.querySelector('form').addEventListener('submit', function(e) {
            var pwd = document.getElementById('password').value;
            var confirmPwd = document.getElementById('confirmPassword').value;
            if (pwd !== confirmPwd) {
                e.preventDefault();
                alert('两次输入的密码不一致');
            }
        });
    </script>
</body>
</html>