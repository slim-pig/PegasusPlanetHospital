<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>预约须知 - 飞马星球医院</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        /* ============================
           预约须知页专属样式
           ============================ */
        body {
            background-color: #f8fafc;
        }

        .notice-container {
            max-width: 900px;
            margin: 40px auto;
        }

        /* 顶部标题区 */
        .notice-header {
            text-align: center;
            margin-bottom: 40px;
        }
        .notice-title {
            font-size: 2rem;
            color: #1e293b;
            font-weight: 800;
            margin-bottom: 10px;
            background: linear-gradient(135deg, var(--primary-color, #0056b3), var(--accent-color, #00c4cc));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .notice-subtitle {
            color: #64748b;
            font-size: 1rem;
        }

        /* 规则卡片 */
        .notice-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            padding: 40px;
            border: 1px solid #e2e8f0;
        }

        /* 规则列表 */
        .rule-list {
            display: flex;
            flex-direction: column;
            gap: 30px;
        }

        .rule-item {
            display: flex;
            gap: 20px;
            padding-bottom: 30px;
            border-bottom: 1px dashed #e2e8f0;
        }
        .rule-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        /* 左侧图标 */
        .rule-icon-box {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            background-color: #eff6ff;
            color: var(--primary-color, #0056b3);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            flex-shrink: 0;
        }

        /* 右侧内容 */
        .rule-content {
            flex: 1;
        }
        .rule-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
        }
        .rule-desc {
            color: #475569;
            font-size: 0.95rem;
            line-height: 1.8;
            margin: 0;
        }
        .rule-desc li {
            list-style: none;
            position: relative;
            padding-left: 15px;
            margin-bottom: 5px;
        }
        .rule-desc li::before {
            content: '';
            position: absolute;
            left: 0;
            top: 10px;
            width: 5px;
            height: 5px;
            border-radius: 50%;
            background-color: #cbd5e1;
        }

        /* 底部按钮 */
        .action-area {
            margin-top: 40px;
            text-align: center;
            padding-top: 30px;
            border-top: 1px solid #f1f5f9;
        }
        .btn-confirm {
            background: var(--primary-color, #0056b3);
            color: white;
            padding: 14px 50px;
            border-radius: 50px;
            font-size: 1.1rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s;
            box-shadow: 0 4px 6px rgba(0, 86, 179, 0.25);
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }
        .btn-confirm:hover {
            background: #004494;
            transform: translateY(-2px);
            box-shadow: 0 8px 15px rgba(0, 86, 179, 0.35);
        }
        
        /* 响应式 */
        @media (max-width: 600px) {
            .rule-item { flex-direction: column; gap: 10px; }
            .notice-card { padding: 20px; }
        }
    </style>
</head>
<body>
    <jsp:include page="/header.jsp" />

    <div class="notice-container">
        
        <div class="notice-header">
            <h1 class="notice-title">预约挂号须知</h1>
            <p class="notice-subtitle">为方便您顺利就诊，请在预约前仔细阅读以下服务指南</p>
        </div>

        <div class="notice-card">
            <div class="rule-list">
                
                <div class="rule-item">
                    <div class="rule-icon-box">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="rule-content">
                        <h3 class="rule-title">一、预约范围与时间</h3>
                        <ul class="rule-desc">
                            <li>我院提供 24 小时全天候网络预约挂号服务。</li>
                            <li>您可预约未来 <strong>14天内</strong> 的所有专家号和普通号源。</li>
                            <li>每日号源于早上 08:00 准时开放更新。</li>
                        </ul>
                    </div>
                </div>

                <div class="rule-item">
                    <div class="rule-icon-box">
                        <i class="fas fa-id-card"></i>
                    </div>
                    <div class="rule-content">
                        <h3 class="rule-title">二、实名制预约要求</h3>
                        <ul class="rule-desc">
                            <li>为保证就诊秩序，预约挂号严格实行 <strong>实名制</strong>。</li>
                            <li>请提供患者本人的真实姓名、有效身份证号及手机号码。</li>
                            <li>注册账号需年满 10 周岁；未满 10 周岁的儿童，请使用监护人账号进行预约或前往现场挂号。</li>
                        </ul>
                    </div>
                </div>

                <div class="rule-item">
                    <div class="rule-icon-box">
                        <i class="fas fa-hospital-user"></i>
                    </div>
                    <div class="rule-content">
                        <h3 class="rule-title">三、取号与就诊</h3>
                        <ul class="rule-desc">
                            <li>预约成功后，请于 <strong>就诊当日</strong> 携带身份证/医保卡到医院自助机或窗口取号。</li>
                            <li>建议您在预约时间段前 <strong>30分钟</strong> 到达医院候诊区。</li>
                            <li><span style="color: #ef4444;">注意：</span>超过预约时间段未取号者，该预约号将自动作废。</li>
                        </ul>
                    </div>
                </div>

                <div class="rule-item">
                    <div class="rule-icon-box">
                        <i class="fas fa-calendar-times"></i>
                    </div>
                    <div class="rule-content">
                        <h3 class="rule-title">四、取消预约与爽约</h3>
                        <ul class="rule-desc">
                            <li>如需取消预约，请至少 <strong>提前1天</strong> 在系统中进行操作。</li>
                            <li>就诊当日不可取消预约。</li>
                            <li>一年内无故爽约累计达到 <strong>3次</strong>，系统将限制您使用预约挂号服务 90 天。</li>
                        </ul>
                    </div>
                </div>

                <div class="rule-item">
                    <div class="rule-icon-box">
                        <i class="fas fa-bullhorn"></i>
                    </div>
                    <div class="rule-content">
                        <h3 class="rule-title">五、停诊通知</h3>
                        <ul class="rule-desc">
                            <li>如遇医生因突发情况临时停诊，系统将第一时间发送短信通知，请保持手机畅通。</li>
                            <li>医院将尽量为您安排同级别其他医生接诊，或者您可以选择改期/退号。</li>
                        </ul>
                    </div>
                </div>

            </div>

            <div class="action-area">
                <a href="${pageContext.request.contextPath}/department?action=list" class="btn-confirm">
                    我已阅读并同意，开始挂号 <i class="fas fa-arrow-right"></i>
                </a>
            </div>
        </div>
    </div>

    <jsp:include page="/footer.jsp" />
</body>
</html>