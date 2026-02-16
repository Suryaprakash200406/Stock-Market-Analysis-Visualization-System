<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin Dashboard | Stock Insight</title>

<style>
/* ---------- GLOBAL ---------- */
body {
    margin: 0;
    font-family: 'Segoe UI', Arial, sans-serif;
    background-color: #0d1117;
    color: #e6edf3;
}

a {
    text-decoration: none;
    color: inherit;
}

/* ---------- NAVBAR ---------- */
.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px 40px;
    background-color: #161b22;
    box-shadow: 0 2px 10px rgba(0,0,0,0.5);
}

.home-link {
    padding: 8px 16px;
    border-radius: 8px;
    background-color: #238636;
    font-size: 14px;
}
.home-link:hover { background-color: #2ea043; }

.logo {
    font-size: 22px;
    font-weight: bold;
    color: #58a6ff;
}

/* ---------- PAGE ---------- */
.page {
    padding: 40px;
    display: grid;
    grid-template-columns: 1fr 2fr;
    gap: 30px;
}

/* ---------- UPDATE PANEL (SMALL) ---------- */
.update-panel {
    background-color: #161b22;
    border: 1px solid #30363d;
    border-radius: 10px;
    padding: 24px;
}

.update-panel h3 {
    margin-top: 0;
    color: #58a6ff;
}

.update-panel p a:hover{
    color:white;
}
.update-btn {
    margin-top: 16px;
    padding: 12px;
    text-align: center;
    background-color: #238636;
    border-radius: 8px;
    cursor: pointer;
    font-weight: bold;
}

.update-btn:hover {
    background-color: #2ea043;
}

/* ---------- LOADING ---------- */
.loading {
    margin-top: 16px;
    color: #8b949e;
    display: none;
}

/* ---------- SUCCESS ---------- */
.success {
    margin-top: 14px;
    color: #2ea043;
    font-weight: bold;
}

/* ---------- ACTIVATE PANEL (BIG) ---------- */
.activate-panel {
    background-color: #161b22;
    border: 1px solid #30363d;
    border-radius: 10px;
    padding: 32px;
}

.activate-panel h2 {
    margin-top: 0;
    color: #58a6ff;
}

.activate-panel p {
    color: #8b949e;
    line-height: 1.6;
    max-width: 700px;
}

.activate-btn {
    margin-top: 24px;
    display: inline-block;
    padding: 14px 26px;
    background-color: #58a6ff;
    color: #0d1117;
    border-radius: 8px;
    font-weight: bold;
    cursor: pointer;
}

.activate-btn:hover {
    background-color: #79c0ff;
}

/* ---------- FOOTER ---------- */
.footer {
    background-color: #161b22;
    padding: 20px;
    text-align: center;
    color: #8b949e;
    font-size: 13px;
    margin-top: 40px;
}
</style>

<script>
function startUpdate() {
    document.getElementById("loading").style.display = "block";
    window.location.href = "normalizeAll";
}
</script>

</head>

<body>

<!-- NAVBAR -->
<div class="navbar">
    <div class="logo">Stock Insight — Admin</div>
    <a href="sample.jsp" class="home-link">Go to Home</a>
</div>

<!-- MAIN PAGE -->
<div class="page">

    <!-- UPDATE ALL COMPANY (SMALL) -->
    <div class="update-panel">
        <h3>Update All Company Data</h3>
        <p style="color:#8b949e;">
            Update historical data and fetch latest NSE data
            for all registered companies. Make sure all the data 
            is exists in the required directory before updating data.
            If you want to download any historical data please visit
            <a href="https://www.nseindia.com/">https://www.nseindia.com/</a> and search the company with  
            valid symbol.
        </p>

        <div class="update-btn" onclick="startUpdate()">
            Run Update
        </div>

        <div id="loading" class="loading">
            Updating company data… please wait
        </div>

        <%
            String msg = (String) request.getAttribute("msg");
            if (msg != null) {
        %>
            <div class="success"><%= msg %></div>
        <%
            }
        %>
    </div>

    <!-- ACTIVATE COMPANY (BIG) -->
    <div class="activate-panel">
        <h2>Activate More Companies</h2>
        <p>
            Manage the list of companies available in the system by activating
            new datasets. This allows administrators to onboard additional
            companies, validate raw CSV structures, and make them accessible
            across analytics, comparisons, and dashboards.
        </p>

        <p>
            This section will later support:
            <br>• Company validation
            <br>• Dataset preview
            <br>• Activation status
        </p>

        <div class="activate-btn"
             onclick="window.location.href='activateCompany.html'">
            Activate New Company
        </div>
    </div>

</div>

<!-- FOOTER -->
<div class="footer">
    © 2026 Stock Insight Project | Admin Dashboard
</div>

</body>
</html>
