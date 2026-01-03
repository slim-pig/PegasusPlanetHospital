<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>统计报表 - 飞马星球医院</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        /* ============================
           统计报表页专属样式
           ============================ */
        :root {
            --bg-color: #f1f5f9;
            --card-bg: #ffffff;
            --text-main: #1e293b;
            --text-sub: #64748b;
            --border-color: #e2e8f0;
            --primary-color: #3b82f6;
            --radius: 12px;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }

        body {
            background-color: var(--bg-color);
            margin: 0;
            font-family: 'Inter', sans-serif;
        }

        .admin-layout { display: flex; min-height: 100vh; }
        .admin-content { flex: 1; padding: 40px; overflow-y: auto; background-color: var(--bg-color); }

        /* 头部 */
        .page-header { margin-bottom: 32px; }
        .page-title h2 {
            font-size: 1.75rem;
            color: var(--text-main);
            font-weight: 700;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .page-title p { color: var(--text-sub); font-size: 0.95rem; }

        /* 报表下载区 */
        .download-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
            margin-bottom: 32px;
        }

        .report-link-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 24px;
            display: flex;
            align-items: flex-start;
            gap: 16px;
            text-decoration: none;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            transition: all 0.2s;
            position: relative;
            overflow: hidden;
        }
        .report-link-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-md);
            border-color: var(--primary-color);
        }

        .card-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            flex-shrink: 0;
        }
        .icon-blue { background: #eff6ff; color: #3b82f6; }
        .icon-green { background: #f0fdf4; color: #10b981; }
        .icon-orange { background: #fff7ed; color: #f97316; }

        .card-info h4 { margin: 0 0 6px 0; color: var(--text-main); font-size: 1.1rem; }
        .card-info span { color: var(--text-sub); font-size: 0.85rem; }
        .card-arrow {
            position: absolute; right: 20px; top: 24px; color: #cbd5e1; transition: transform 0.2s;
        }
        .report-link-card:hover .card-arrow { color: var(--primary-color); transform: translateX(4px); }

        /* 数据概览区 */
        .overview-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 32px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
        }
        .section-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--text-main);
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* 模拟进度条样式的表格 */
        .stats-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .stats-item {
            display: flex;
            align-items: center;
            padding: 16px 0;
            border-bottom: 1px solid #f1f5f9;
        }
        .stats-item:last-child { border-bottom: none; }
        
        .stat-label { width: 150px; color: var(--text-sub); font-weight: 500; font-size: 0.95rem; }
        .stat-bar-container { flex: 1; background: #f1f5f9; height: 8px; border-radius: 4px; margin: 0 20px; overflow: hidden; }
        .stat-bar { height: 100%; border-radius: 4px; animation: loadBar 1s ease-out; }
        .stat-value { width: 80px; text-align: right; font-weight: 700; color: var(--text-main); font-size: 1.1rem; font-family: monospace; }

        /* 不同的进度条颜色 */
        .bar-blue { background: #3b82f6; width: 60%; } /* 模拟宽度 */
        .bar-green { background: #10b981; width: 45%; }
        .bar-orange { background: #f97316; width: 25%; }
        .bar-purple { background: #8b5cf6; width: 80%; }

        @keyframes loadBar { from { width: 0; } }
    </style>
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="sidebar.jsp" />
        
        <div class="admin-content">
            <div class="page-header">
                <div class="page-title">
                    <h2><i class="fas fa-chart-line" style="color: var(--primary-color);"></i> 统计报表中心</h2>
                    <p>查看医院运营核心数据，支持导出多维度 PDF 报表。</p>
                </div>
            </div>
            
            <div class="download-section">
                <a href="${pageContext.request.contextPath}/report?type=monthly" target="_blank" class="report-link-card">
                    <div class="card-icon icon-blue">
                        <i class="fas fa-calendar-alt"></i>
                    </div>
                    <div class="card-info">
                        <h4>月度运营报表</h4>
                        <span>按月统计预约与就诊数据</span>
                    </div>
                    <i class="fas fa-chevron-right card-arrow"></i>
                </a>
                
                <a href="${pageContext.request.contextPath}/report?type=department" target="_blank" class="report-link-card">
                    <div class="card-icon icon-green">
                        <i class="fas fa-building"></i>
                    </div>
                    <div class="card-info">
                        <h4>科室统计报表</h4>
                        <span>各科室接诊量对比分析</span>
                    </div>
                    <i class="fas fa-chevron-right card-arrow"></i>
                </a>
                
                <a href="${pageContext.request.contextPath}/report?type=doctor" target="_blank" class="report-link-card">
                    <div class="card-icon icon-orange">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="card-info">
                        <h4>医生工作量报表</h4>
                        <span>专家出诊与服务人次统计</span>
                    </div>
                    <i class="fas fa-chevron-right card-arrow"></i>
                </a>
            </div>
            
            <div class="overview-card">
                <div class="section-title">
                    <i class="fas fa-database" style="color: #64748b;"></i> 核心数据概览
                </div>
                
                <ul class="stats-list">
                    <li class="stats-item">
                        <span class="stat-label">总医生数</span>
                        <div class="stat-bar-container">
                            <div class="stat-bar bar-blue"></div>
                        </div>
                        <span class="stat-value">${stats.totalDoctors}</span>
                    </li>
                    <li class="stats-item">
                        <span class="stat-label">注册患者数</span>
                        <div class="stat-bar-container">
                            <div class="stat-bar bar-green"></div>
                        </div>
                        <span class="stat-value">${stats.totalPatients}</span>
                    </li>
                    <li class="stats-item">
                        <span class="stat-label">今日预约量</span>
                        <div class="stat-bar-container">
                            <div class="stat-bar bar-orange"></div>
                        </div>
                        <span class="stat-value">${stats.todayAppointments}</span>
                    </li>
                    <li class="stats-item">
                        <span class="stat-label">累计服务人次</span>
                        <div class="stat-bar-container">
                            <div class="stat-bar bar-purple"></div>
                        </div>
                        <span class="stat-value">${stats.totalAppointments}</span>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>