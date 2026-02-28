<%@page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login - Stock Insight</title>

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #0f1621;
            color: #e6edf3;
        }

        a { text-decoration: none; color: inherit; }

        /* ---------- HEADER ---------- */
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 40px;
            background-color: #1c2431;
            border-bottom: 1px solid #30363d;
        }

        .dashboard-title {
            font-size: 22px;
            font-weight: bold;
            color: #58a6ff;
        }

        .back-link {
            padding: 8px 16px;
            border-radius: 8px;
            background-color: #238636;
            font-size: 14px;
        }

        .back-link:hover { background-color: #2ea043; }

        /* ---------- LOGIN BOX ---------- */
        .container {
            width: 400px;
            margin: 80px auto;
            background-color: #161b22;
            padding: 40px;
            border-radius: 14px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        }

        h2 {
            margin-top: 0;
            text-align: center;
            color: #58a6ff;
        }

        label {
            display: block;
            margin-top: 20px;
            margin-bottom: 6px;
            font-weight: 600;
        }

        input[type=text],
        input[type=password] {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 6px;
            background-color: #0f1621;
            color: white;
        }

        .btn {
            width: 100%;
            margin-top: 30px;
            padding: 12px;
            background-color: #238636;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
        }

        .btn:hover { background-color: #2ea043; }

        .error {
            margin-top: 15px;
            color: #f87171;
            text-align: center;
            font-size: 14px;
        }
    </style>
</head>

<body>

<div class="dashboard-header">
    <div class="dashboard-title">Stock Insight — Admin Login</div>
    <a href="sample.jsp" class="back-link">Go Back</a>
</div>

<div class="container">

    <h2>Admin Authentication</h2>

    <% if(request.getAttribute("error") != null) { %>
        <div class="error">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>

    <form action="adminLogin" method="post">

        <label>User ID</label>
        <input type="text" name="username" required>

        <label>Password</label>
        <input type="password" name="password" required>

        <button type="submit" class="btn">Login</button>

    </form>

</div>

</body>
</html>