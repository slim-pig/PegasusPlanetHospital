<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>修改资料 - 飞马星球医院</title>
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

        /* 资料修改卡片 */
        .profile-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            border: 1px solid #e2e8f0;
            overflow: hidden;
        }
        
        .card-header {
            padding: 20px 30px;
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

        .card-body { padding: 30px; }

        /* 表单布局 */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
        }
        .form-full { grid-column: 1 / -1; }

        .form-group { margin-bottom: 5px; } /* Grid controls gap */
        
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
            background-color: #fff;
            outline: none;
            box-sizing: border-box;
        }
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        .form-control:focus + .input-icon { color: var(--primary-color); }

        /* 只读字段样式 */
        .form-control[readonly] {
            background-color: #f1f5f9;
            color: #64748b;
            cursor: not-allowed;
            border-color: #e2e8f0;
        }

        /* 性别选择：分段按钮样式 */
        .gender-group {
            display: flex;
            background: #f1f5f9;
            padding: 4px;
            border-radius: 8px;
            border: 1px solid #e2e8f0;
        }
        .gender-option { flex: 1; position: relative; }
        .gender-option input[type="radio"] {
            position: absolute; opacity: 0; width: 100%; height: 100%; cursor: pointer; z-index: 2;
        }
        .gender-label {
            display: flex; align-items: center; justify-content: center;
            padding: 10px; border-radius: 6px; color: #60a5fa; font-weight: 500;
            transition: all 0.2s; gap: 8px;
        }
        .gender-option input:checked + .gender-label {
            background: white; color: var(--primary-color);
            box-shadow: 0 2px 4px rgba(0,0,0,0.05); font-weight: 600;
        }

        /* 按钮 */
        .form-actions {
            margin-top: 30px;
            border-top: 1px solid #9fcbf7;
            padding-top: 20px;
            text-align: right;
        }
        .btn-save {
            background: #60a5fa;
            color: white;
            border: none;
            padding: 12px 32px;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 4px 6px rgba(59, 130, 246, 0.2);
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-save:hover {
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

        @media (max-width: 768px) {
            .form-grid { grid-template-columns: 1fr; }
        }
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
                            <a href="${pageContext.request.contextPath}/patient?action=profile" class="active">
                                <i class="fas fa-user-edit" style="width: 24px;"></i> 修改个人资料
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/patient?action=password">
                                <i class="fas fa-key" style="width: 24px;"></i> 修改登录密码
                            </a>
                        </li>
                    </ul>
                </div>
            </aside>

            <main style="flex: 1;">
                <div class="profile-card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-id-card" style="color: var(--primary-color);"></i>
                            基本资料设置
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
                            <input type="hidden" name="action" value="update">
                            
                            <div class="form-grid">
                                <div class="form-group">
                                    <label class="form-label">患者ID (不可修改)</label>
                                    <div class="input-wrapper">
                                        <input type="text" class="form-control" value="${sessionScope.patient.patientId}" readonly>
                                        <i class="fas fa-hashtag input-icon"></i>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">身份证号 (实名认证)</label>
                                    <div class="input-wrapper">
                                        <input type="text" class="form-control" name="idCard" value="${sessionScope.patient.idCard}" readonly>
                                        <i class="fas fa-address-card input-icon"></i>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="name" class="form-label">真实姓名</label>
                                    <div class="input-wrapper">
                                        <input type="text" class="form-control" id="name" name="name" value="${sessionScope.patient.name}" required>
                                        <i class="fas fa-user input-icon"></i>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">性别</label>
                                    <div class="gender-group">
                                        <div class="gender-option">
                                            <input type="radio" name="gender" value="男" id="gender-male" ${sessionScope.patient.gender == '男' ? 'checked' : ''}>
                                            <label for="gender-male" class="gender-label"><i class="fas fa-mars"></i> 男</label>
                                        </div>
                                        <div class="gender-option">
                                            <input type="radio" name="gender" value="女" id="gender-female" ${sessionScope.patient.gender == '女' ? 'checked' : ''}>
                                            <label for="gender-female" class="gender-label"><i class="fas fa-venus"></i> 女</label>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="phone" class="form-label">手机号码</label>
                                    <div class="input-wrapper">
                                        <input type="tel" class="form-control" id="phone" name="phone" value="${sessionScope.patient.phone}" required pattern="1[3-9]\d{9}">
                                        <i class="fas fa-mobile-alt input-icon"></i>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="email" class="form-label">电子邮箱 (选填)</label>
                                    <div class="input-wrapper">
                                        <input type="email" class="form-control" id="email" name="email" value="${sessionScope.patient.email}" placeholder="用于接收通知">
                                        <i class="fas fa-envelope input-icon"></i>
                                    </div>
                                </div>

                                <div class="form-group form-full">
                                    <label for="address" class="form-label">联系地址 (选填)</label>
                                    <div class="input-wrapper">
                                        <input type="text" class="form-control" id="address" name="address" value="${sessionScope.patient.address}" placeholder="请输入您的居住地址">
                                        <i class="fas fa-map-marker-alt input-icon"></i>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-actions">
                                <button type="submit" class="btn-save">
                                    <i class="fas fa-save"></i> 保存资料修改
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <jsp:include page="/footer.jsp" />
</body>
</html>