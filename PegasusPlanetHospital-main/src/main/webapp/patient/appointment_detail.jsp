<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>预约详情 - 飞马星球医院</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        /* 页面专属高级样式 */
        body { background-color: #f8fafc; }
        
        /* 侧边栏样式优化 */
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
        }
        .side-menu a:hover {
            background-color: #f8fafc;
            color: var(--primary-color);
        }
        .side-menu a.active {
            background-color: #eff6ff !important;
            color: var(--primary-color) !important;
            border-left-color: var(--primary-color);
            border-radius: 0 4px 4px 0;
        }

        /* 详情卡片样式 */
        .detail-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
            overflow: hidden;
        }
        .detail-header {
            padding: 20px 30px;
            background: white;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        /* 状态徽章 (Pill Style) */
        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 6px 16px;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            gap: 6px;
        }
        .badge-BOOKED { background-color: #eff6ff; color: #3b82f6; border: 1px solid #dbeafe; }
        .badge-COMPLETED { background-color: #f0fdf4; color: #16a34a; border: 1px solid #dcfce7; }
        .badge-CANCELLED { background-color: #fef2f2; color: #ef4444; border: 1px solid #fee2e2; }

        /* 信息分组标题 */
        .info-group-title {
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #94a3b8;
            font-weight: 700;
            margin-bottom: 15px;
            padding-bottom: 5px;
            border-bottom: 2px solid #f1f5f9;
        }

        /* 信息项 */
        .info-item {
            display: flex;
            margin-bottom: 12px;
            font-size: 0.95rem;
        }
        .info-label {
            width: 90px;
            color: #64748b;
            flex-shrink: 0;
        }
        .info-value {
            color: #1e293b;
            font-weight: 500;
        }

        /* 按钮 */
        .btn-action {
            padding: 10px 24px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.2s;
            cursor: pointer;
        }
        .btn-cancel {
            background: white;
            border: 1px solid #fee2e2;
            color: #ef4444;
        }
        .btn-cancel:hover {
            background: #fef2f2;
            border-color: #ef4444;
        }
        .btn-print {
            background: #f1f5f9;
            color: #475569;
            border: 1px solid #e2e8f0;
        }
        .btn-print:hover {
            background: #e2e8f0;
            color: #1e293b;
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
                            <a href="${pageContext.request.contextPath}/patient?action=index" style="display: flex; align-items: center; padding: 12px 20px; text-decoration: none;">
                                <i class="fas fa-home" style="width: 24px;"></i> 个人中心概览
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/appointment?action=list" class="active" style="display: flex; align-items: center; padding: 12px 20px; text-decoration: none;">
                                <i class="fas fa-calendar-check" style="width: 24px;"></i> 我的预约挂号
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/patient?action=profile" style="display: flex; align-items: center; padding: 12px 20px; text-decoration: none;">
                                <i class="fas fa-user-edit" style="width: 24px;"></i> 修改个人资料
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/patient?action=password" style="display: flex; align-items: center; padding: 12px 20px; text-decoration: none;">
                                <i class="fas fa-key" style="width: 24px;"></i> 修改登录密码
                            </a>
                        </li>
                    </ul>
                </div>
            </aside>

            <main style="flex: 1;">
                <c:if test="${not empty param.success}">
                    <div style="background: #f0fdf4; border: 1px solid #dcfce7; color: #166534; padding: 16px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                        <i class="fas fa-check-circle" style="font-size: 1.2rem;"></i> 
                        <div>
                            <strong>预约成功！</strong> 系统已为您锁定号源，请按时就诊。
                        </div>
                    </div>
                </c:if>
                
                <c:if test="${not empty error}">
                    <div style="background: #fef2f2; border: 1px solid #fee2e2; color: #991b1b; padding: 16px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                        <i class="fas fa-exclamation-circle" style="font-size: 1.2rem;"></i> ${error}
                    </div>
                </c:if>

                <div class="detail-card">
                    <div class="detail-header">
                        <div>
                            <h2 style="font-size: 1.25rem; font-weight: 700; color: #1e293b; margin: 0 0 5px 0;">预约详情单</h2>
                            <span style="font-size: 0.85rem; color: #64748b; font-family: monospace;">NO. ${appointment.appointmentId}</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/appointment?action=list" style="color: #64748b; text-decoration: none; font-size: 0.9rem; display: flex; align-items: center; gap: 5px;">
                            <i class="fas fa-arrow-left"></i> 返回列表
                        </a>
                    </div>
                    
                    <div style="padding: 30px;">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 30px; padding-bottom: 20px; border-bottom: 1px solid #f1f5f9;">
                            <div>
                                <div style="font-size: 0.85rem; color: #64748b; margin-bottom: 5px;">预约状态</div>
                                <div class="status-badge badge-${appointment.status}">
                                    <i class="fas fa-circle" style="font-size: 6px;"></i>
                                    ${appointment.status == 'BOOKED' ? '预约成功 (待就诊)' : (appointment.status == 'COMPLETED' ? '诊疗已完成' : '已取消')}
                                </div>
                            </div>
                            <div style="text-align: right;">
                                <div style="font-size: 0.85rem; color: #64748b; margin-bottom: 5px;">下单时间</div>
                                <div style="font-family: monospace; color: #334155;">${appointment.createTime}</div>
                            </div>
                        </div>
                        
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 40px;">
                            <div>
                                <div class="info-group-title"><i class="fas fa-hospital-symbol"></i> 就诊信息</div>
                                <div class="info-item">
                                    <span class="info-label">就诊科室</span>
                                    <span class="info-value" style="font-size: 1.1rem; color: var(--primary-color);">${appointment.deptName}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">预约专家</span>
                                    <span class="info-value">${appointment.doctorName} <span style="font-size: 0.8rem; color: #64748b; background: #f1f5f9; padding: 2px 6px; border-radius: 4px; margin-left: 5px;">${appointment.doctorTitle}</span></span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">就诊日期</span>
                                    <span class="info-value"><i class="far fa-calendar-alt" style="color: #94a3b8; margin-right: 5px;"></i> ${appointment.appointmentDate}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">预计时段</span>
                                    <span class="info-value"><i class="far fa-clock" style="color: #94a3b8; margin-right: 5px;"></i> ${appointment.timeSlot}</span>
                                </div>
                            </div>
                            
                            <div>
                                <div class="info-group-title"><i class="fas fa-user-injured"></i> 患者信息</div>
                                <div class="info-item">
                                    <span class="info-label">患者姓名</span>
                                    <span class="info-value">${appointment.patientName}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">性别</span>
                                    <span class="info-value">${sessionScope.patient.gender}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">联系电话</span>
                                    <span class="info-value" style="font-family: monospace;">${appointment.patientPhone}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">身份证号</span>
                                    <span class="info-value" style="font-family: monospace;">${sessionScope.patient.idCard}</span>
                                </div>
                            </div>
                        </div>
                        
                        <c:if test="${appointment.status == 'CANCELLED'}">
                            <div style="margin-top: 30px; padding: 20px; background-color: #fff1f2; border: 1px solid #fee2e2; border-radius: 8px; display: flex; gap: 15px;">
                                <i class="fas fa-info-circle" style="color: #e11d48; margin-top: 3px;"></i>
                                <div>
                                    <strong style="color: #9f1239; display: block; margin-bottom: 5px;">取消原因说明</strong>
                                    <span style="color: #881337;">${appointment.cancelReason}</span>
                                </div>
                            </div>
                        </c:if>
                        
                        <div style="margin-top: 40px; padding-top: 20px; border-top: 1px solid #f1f5f9; display: flex; justify-content: flex-end; gap: 15px;">
                            <button onclick="window.print()" class="btn-action btn-print">
                                <i class="fas fa-print"></i> 打印凭证
                            </button>
                            
                            <c:if test="${appointment.status == 'BOOKED'}">
                                <button onclick="cancelAppointment('${appointment.appointmentId}')" class="btn-action btn-cancel">
                                    <i class="fas fa-times-circle"></i> 取消预约
                                </button>
                            </c:if>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <jsp:include page="/footer.jsp" />
    <script src="${pageContext.request.contextPath}/js/main.js" charset="UTF-8"></script>
    <script>
        // 覆盖 main.js 中的同名函数，解决中文乱码问题
        function cancelAppointment(appointmentId) {
            const reason = prompt("请输入取消原因：");
            if (reason === null) return; 
            
            fetch('${pageContext.request.contextPath}/appointment', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Accept': 'application/json'
                },
                body: 'action=cancel&id=' + appointmentId + '&reason=' + encodeURIComponent(reason)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('预约已取消');
                    // 返回列表页或刷新
                    if (document.referrer.indexOf('appointment') > -1) {
                        location.href = '${pageContext.request.contextPath}/appointment?action=list&msg=cancelSuccess';
                    } else {
                        location.reload();
                    }
                } else {
                    alert('取消失败: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('操作失败，请检查网络连接');
            });
        }
    </script>
</body>
</html>