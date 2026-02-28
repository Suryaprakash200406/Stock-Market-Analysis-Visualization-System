<%@page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add New Company</title>

    <style>
        body {
            background:#0f172a;
            color:#e2e8f0;
            font-family:Segoe UI, Arial;
            margin:0;
        }

        a { text-decoration: none; color: inherit; }
        
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

        .container {
            width:80%;
            margin:40px auto;
            background:#1e293b;
            padding:30px;
            border-radius:10px;
            box-shadow:0 0 15px rgba(0,0,0,0.6);
        }

        h2 {
            margin-bottom:25px;
            color:#38bdf8;
        }

        label {
            display:block;
            margin-top:15px;
            margin-bottom:6px;
            font-weight:600;
        }

        input[type=text],
        textarea,
        select {
            width:100%;
            padding:10px;
            border:none;
            border-radius:6px;
            background:#0f172a;
            color:white;
        }

        textarea {
            resize:vertical;
            height:90px;
        }

        input[type=file] {
            margin-top:8px;
        }

        .error {
            color:#f87171;
            font-size:13px;
            margin-top:4px;
        }

        .btn {
            margin-top:25px;
            padding:12px 28px;
            background:#22c55e;
            border:none;
            border-radius:6px;
            color:white;
            font-weight:bold;
            cursor:pointer;
        }

        .btn:hover {
            background:#16a34a;
        }

        .success {
            color:#4ade80;
            margin-bottom:15px;
        }
    </style>
</head>

<body>
    
<div class="dashboard-header">
    <div class="dashboard-title">
        Stock Insight - Add New Company
    </div>

    <a href="index.jsp" class="back-link">
        Go Back
    </a>
</div>    

<div class="container">

    <h2>New Company Entry Form</h2>

    <% if(request.getAttribute("success") != null){ %>
        <div class="success"><%=request.getAttribute("success")%></div>
    <% } %>

    <form action="addCompany" method="post" enctype="multipart/form-data">

        <label>Symbol</label>
        <input type="text" name="symbol" required>

        <label>Name</label>
        <input type="text" name="name" required>

        <label>Sector</label>
        <select name="sector" required>
            <option>Auto</option>
            <option>Banking</option>
            <option>Cement</option>
            <option>Chemicals</option>
            <option>Electronics</option>
            <option>Energy</option>
            <option>FMCG</option>
            <option>Infrastructure</option>
            <option>Insurance</option>
            <option>IT</option>
            <option>Metals</option>
            <option>Pharma</option>
            <option>Power</option>
            <option>Telecom</option>
            <option>Others</option>
        </select>

        <label>Description</label>
        <textarea name="description" required></textarea>

        <label>Upload Raw CSV Files</label>
        <input type="file" name="csvFiles" accept=".csv" multiple required>

        <button type="submit" class="btn">Submit</button>

    </form>

</div>

</body>
</html>