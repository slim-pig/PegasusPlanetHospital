<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - 服务器内部错误</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body {
            background-color: #f5f6fa;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            text-align: center;
        }
        .error-container {
            background: #fff;
            padding: 50px;
            border-radius: 8px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            max-width: 600px;
            width: 90%;
        }
        .error-code {
            font-size: 100px;
            font-weight: bold;
            color: #e74c3c;
            line-height: 1;
            margin-bottom: 20px;
        }
        .error-message {
            font-size: 24px;
            color: #2c3e50;
            margin-bottom: 10px;
        }
        .error-desc {
            color: #7f8c8d;
            margin-bottom: 30px;
        }
        .error-details {
            text-align: left;
            background: #f8f9fa;
            padding: 15px;
            border-radius: 4px;
            font-family: monospace;
            font-size: 12px;
            color: #e74c3c;
            max-height: 200px;
            overflow-y: auto;
            margin-bottom: 20px;
            display: none;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">500</div>
        <div class="error-message">服务器出错了</div>
        <p class="error-desc">服务器遇到了一些问题，请稍后再试。</p>
        
        <% if (exception != null) { %>
            <button onclick="document.getElementById('details').style.display = 'block'" class="btn btn-outline" style="margin-bottom: 20px; font-size: 12px;">查看错误详情</button>
            <div id="details" class="error-details">
                <%= exception.getMessage() %><br>
                <% 
                    java.io.StringWriter sw = new java.io.StringWriter();
                    java.io.PrintWriter pw = new java.io.PrintWriter(sw);
                    exception.printStackTrace(pw);
                    out.print(sw.toString().replace("\n", "<br>"));
                %>
            </div>
        <% } %>
        
        <div>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">返回首页</a>
        </div>
    </div>
</body>
</html>
