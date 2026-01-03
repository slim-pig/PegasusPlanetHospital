<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>确认预约 - 飞马星球医院</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        /* ============================
           确认预约页专属样式
           ============================ */
        body {
            background-color: #f8fafc;
        }

        .booking-container {
            max-width: 700px;
            margin: 50px auto;
        }

        /* 步骤条 (装饰用) */
        .step-indicator {
            display: flex;
            justify-content: center;
            margin-bottom: 30px;
            color: #94a3b8;
            font-size: 0.9rem;
            font-weight: 500;
        }
        .step-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .step-item.active {
            color: var(--primary-color, #0056b3);
            font-weight: 700;
        }
        .step-line {
            width: 40px;
            height: 2px;
            background: #cbd5e1;
            margin: 0 15px;
            position: relative;
            top: 2px;
        }

        /* 主卡片 */
        .confirm-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            border: 1px solid #e2e8f0;
        }

        .card-header {
            background: linear-gradient(135deg, #eff6ff 0%, #ffffff 100%);
            padding: 30px;
            text-align: center;
            border-bottom: 1px solid #f1f5f9;
        }
        .card-title {
            font-size: 1.5rem;
            color: #1e293b;
            font-weight: 700;
            margin: 0;
        }
        .card-subtitle {
            color: #64748b;
            font-size: 0.95rem;
            margin-top: 8px;
        }

        .card-body {
            padding: 40px;
        }

        /* 提示框 */
        .notice-alert {
            background-color: #fff7ed;
            border: 1px solid #ffedd5;
            color: #c2410c;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 0.9rem;
            display: flex;
            align-items: start;
            gap: 10px;
            margin-bottom: 30px;
        }
        .error-alert {
            background-color: #fef2f2;
            border: 1px solid #fee2e2;
            color: #ef4444;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* 信息分组 - 票据样式 */
        .info-ticket {
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            position: relative;
        }
        /* 票据左侧装饰线 */
        .info-ticket::before {
            content: '';
            position: absolute;
            left: 0;
            top: 20px;
            bottom: 20px;
            width: 4px;
            background-color: var(--primary-color, #0056b3);
            border-radius: 0 4px 4px 0;
        }

        .ticket-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px dashed #cbd5e1;
            color: #1e293b;
            font-weight: 700;
            font-size: 1.1rem;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .info-item label {
            display: block;
            font-size: 0.85rem;
            color: #64748b;
            margin-bottom: 4px;
        }
        .info-item p {
            font-size: 1.05rem;
            color: #0f172a;
            font-weight: 500;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .info-icon {
            color: var(--primary-color, #0056b3);
            font-size: 0.9rem;
            opacity: 0.7;
        }

        /* 强调文本 */
        .highlight-text {
            color: var(--primary-color, #0056b3);
            font-weight: 700;
        }
        .sub-tag {
            font-size: 0.75rem;
            background: #e2e8f0;
            color: #475569;
            padding: 2px 6px;
            border-radius: 4px;
            font-weight: normal;
            vertical-align: middle;
        }

        /* 按钮区 */
        .action-area {
            margin-top: 40px;
            display: flex;
            justify-content: center;
            gap: 20px;
        }
        .btn-xl {
            padding: 12px 40px;
            font-size: 1rem;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.2s;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-confirm {
            background: linear-gradient(135deg, #0056b3 0%, #007bff 100%);
            color: white;
            border: none;
            box-shadow: 0 4px 6px rgba(0, 86, 179, 0.3);
        }
        .btn-confirm:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0, 86, 179, 0.4);
        }
        .btn-back {
            background: white;
            color: #64748b;
            border: 1px solid #cbd5e1;
        }
        .btn-back:hover {
            border-color: #94a3b8;
            color: #1e293b;
            background: #f1f5f9;
        }
        
        @media (max-width: 600px) {
            .info-grid { grid-template-columns: 1fr; }
            .action-area { flex-direction: column-reverse; }
            .btn-xl { width: 100%; justify-content: center; }
        }
    </style>
</head>
<body>
    <jsp:include page="/header.jsp" />

    <div class="booking-container">
        <div class="step-indicator">
            <div class="step-item">
                <i class="fas fa-check-circle"></i> 1. 选择号源
            </div>
            <div class="step-line"></div>
            <div class="step-item active">
                <i class="fas fa-dot-circle"></i> 2. 确认预约
            </div>
            <div class="step-line" style="border-style: dashed; opacity: 0.5;"></div>
            <div class="step-item" style="opacity: 0.5;">
                <i class="far fa-circle"></i> 3. 预约成功
            </div>
        </div>

        <div class="confirm-card">
            <div class="card-header">
                <h2 class="card-title">确认预约信息</h2>
                <p class="card-subtitle">Please confirm your appointment details</p>
            </div>
            
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="error-alert">
                        <i class="fas fa-exclamation-triangle"></i> ${error}
                    </div>
                </c:if>
                
                <div class="notice-alert">
                    <i class="fas fa-bell" style="margin-top: 3px;"></i>
                    <div>
                        <strong>温馨提示：</strong>
                        请仔细核对以下就诊信息，爽约 3 次将被列入黑名单。
                    </div>
                </div>
                
                <form action="${pageContext.request.contextPath}/appointment" method="post">
                    <input type="hidden" name="action" value="book">
                    <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">
                    
                    <div class="info-ticket">
                        <div class="ticket-header">
                            <i class="fas fa-file-medical-alt" style="color: var(--primary-color);"></i>
                            就诊挂号单
                        </div>
                        <div class="info-grid">
                            <div class="info-item">
                                <label>就诊科室</label>
                                <p><i class="far fa-hospital info-icon"></i> ${schedule.deptName}</p>
                            </div>
                            <div class="info-item">
                                <label>就诊专家</label>
                                <p>
                                    <i class="far fa-user-md info-icon"></i> 
                                    ${schedule.doctorName} 
                                    <span class="sub-tag">${schedule.doctorTitle}</span>
                                </p>
                            </div>
                            <div class="info-item">
                                <label>就诊日期</label>
                                <p class="highlight-text"><i class="far fa-calendar-alt info-icon"></i> ${schedule.scheduleDate}</p>
                            </div>
                            <div class="info-item">
                                <label>预约时段</label>
                                <p class="highlight-text"><i class="far fa-clock info-icon"></i> ${schedule.timeSlot}</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="info-ticket" style="border-left: none; border-top: 4px solid #10b981; background: white;">
                        <div class="ticket-header" style="border-bottom: none; margin-bottom: 10px;">
                            <i class="fas fa-user-check" style="color: #10b981;"></i>
                            就诊人核对
                        </div>
                        <div class="info-grid">
                            <div class="info-item">
                                <label>姓名</label>
                                <p>${sessionScope.patient.name}</p>
                            </div>
                            <div class="info-item">
                                <label>手机号码</label>
                                <p style="font-family: monospace;">${sessionScope.patient.phone}</p>
                            </div>
                            <div class="info-item" style="grid-column: 1 / -1;">
                                <label>身份证号</label>
                                <p style="font-family: monospace; letter-spacing: 1px;">${sessionScope.patient.idCard}</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="action-area">
                        <a href="javascript:history.back()" class="btn-xl btn-back">
                            <i class="fas fa-arrow-left"></i> 返回修改
                        </a>
                        <button type="submit" class="btn-xl btn-confirm">
                            确认提交预约 <i class="fas fa-check"></i>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="/footer.jsp" />
</body>
</html>