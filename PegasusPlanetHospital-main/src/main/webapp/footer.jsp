<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
    /* Footer 专属样式 */
    footer {
        background-color: #0f172a; /* 深邃夜空蓝 */
        color: #94a3b8;
        padding: 60px 0 20px;
        margin-top: 60px;
        font-size: 0.9rem;
    }
    
    .footer-content {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 40px;
        margin-bottom: 40px;
    }
    
    .footer-section h3 {
        color: #fff;
        font-size: 1.1rem;
        font-weight: 600;
        margin-bottom: 20px;
        position: relative;
        display: inline-block;
    }
    
    /* 标题下划线装饰 */
    .footer-section h3::after {
        content: '';
        position: absolute;
        left: 0;
        bottom: -8px;
        width: 30px;
        height: 2px;
        background-color: var(--accent-color, #00c4cc);
    }
    
    .footer-section p {
        line-height: 1.6;
    }
    
    .footer-section ul {
        list-style: none;
        padding: 0;
    }
    
    .footer-section ul li {
        margin-bottom: 12px;
    }
    
    .footer-section a {
        color: #94a3b8;
        text-decoration: none;
        transition: all 0.2s;
        display: inline-flex;
        align-items: center;
    }
    
    .footer-section a:hover {
        color: #fff;
        padding-left: 5px;
    }
    
    .footer-section i {
        margin-right: 10px;
        color: var(--accent-color, #00c4cc);
        width: 20px;
        text-align: center;
    }
    
    .copyright {
        border-top: 1px solid #1e293b;
        padding-top: 20px;
        text-align: center;
        color: #64748b;
        font-size: 0.85rem;
    }
</style>

<footer>
    <div class="container">
        <div class="footer-content">
            <div class="footer-section">
                <h3>关于我们</h3>
                <p>飞马星球医院致力于为患者提供最优质的医疗服务，拥有先进的医疗设备和专业的医疗团队。我们始终坚持“以患者为中心”的服务理念。</p>
            </div>
            <div class="footer-section">
                <h3>快速链接</h3>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/department?action=list">科室导航</a></li>
                    <li><a href="${pageContext.request.contextPath}/doctor?action=list">专家介绍</a></li>
                    <li><a href="${pageContext.request.contextPath}/patient?action=notice">就医指南</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/login.jsp">管理员登录入口</a></li>
                </ul>
            </div>
            <div class="footer-section">
                <h3>联系方式</h3>
                <ul>
                    <li><i class="fas fa-map-marker-alt"></i> 飞马星球中央大道1号</li>
                    <li><i class="fas fa-phone"></i> 010-88888888 (24小时)</li>
                    <li><i class="fas fa-envelope"></i> contact@pegasus-hospital.com</li>
                </ul>
            </div>
        </div>
        <div class="copyright">
            <p>&copy; 2023 飞马星球医院 (Pegasus Planet Hospital) 版权所有</p>
        </div>
    </div>
</footer>