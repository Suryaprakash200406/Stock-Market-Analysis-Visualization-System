<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.project.util.CompanyRegistry" %>
<%
    String symbol = request.getParameter("symbol");

    CompanyRegistry.CompanyInfo company = CompanyRegistry.getCompany(symbol);

    if (company == null) {
        company = new CompanyRegistry.CompanyInfo("Unknown", "N/A", "No data available for this symbol.");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Company Dashboard - <%= symbol %></title>

<style>
/* ---------- GLOBAL ---------- */
body {
    margin: 0;
    font-family: 'Segoe UI', Arial, sans-serif;
    background-color: #0f1621;
    color: #e6edf3;
}

a { text-decoration: none; color: inherit; }

/* ---------- DASHBOARD HEADER ---------- */
.dashboard-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 40px;
    background-color: #1c2431;
    border-bottom: 1px solid #30363d;
}

.dashboard-title { font-size: 22px; font-weight: bold; color: #58a6ff; }

.home-link {
    padding: 8px 16px;
    border-radius: 8px;
    background-color: #238636;
    font-size: 14px;
}
.home-link:hover { background-color: #2ea043; }

/* ---------- COMPANY INFO PANEL ---------- */
.company-panel {
    margin: 30px 40px;
    padding: 25px;
    background-color: #161b22;
    border-radius: 14px;
    box-shadow: 0 6px 18px rgba(0,0,0,0.4);
}

.company-panel h1 { margin: 0; font-size: 28px; }
.company-panel p { margin-top: 10px; color: #8b949e; font-size: 14px; }

/* ---------- DASHBOARD GRID ---------- */
.container { padding: 20px 40px 50px; }
.card-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 30px;
}

/* ---------- DASHBOARD CARDS ---------- */
.card {
    background: linear-gradient(145deg, #161b22, #1f2937);
    border-radius: 18px;
    padding: 30px;
    min-height: 220px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.5);
    position: relative;
    overflow: hidden;
    transition: all 0.35s ease;
}
.card::before {
    content: "";
    position: absolute;
    inset: 0;
    background: linear-gradient(120deg, transparent, rgba(88,166,255,0.15), transparent);
    opacity: 0;
    transition: opacity 0.35s ease;
}
.card:hover::before { opacity: 1; }
.card:hover { transform: translateY(-10px) scale(1.02); }

.card h3 { margin-top: 0; margin-bottom: 15px; font-size: 20px; }
.card p { font-size: 14px; color: #9da7b3; line-height: 1.6; }

/* ---------- BUTTON ---------- */
.btn {
    position: absolute;
    bottom: 25px;
    left: 30px;
    padding: 10px 20px;
    background-color: #238636;
    border-radius: 10px;
    font-size: 14px;
}
.btn:hover { background-color: #2ea043; }

/* ---------- FOOTER ---------- */
.footer {
    background-color: #1c2431;
    padding: 18px;
    text-align: center;
    color: #8b949e;
    font-size: 13px;
}
</style>
</head>

<body>

<div class="dashboard-header">
    <div class="dashboard-title">Stock Insight - <%= symbol %> Dashboard</div>
    <a href="sample.jsp" class="home-link">Go to Home</a>
</div>

<div class="company-panel">
    <h1><%= symbol %> (<%= company.name %>)</h1>
    <p>
        Sector: <%= company.sector %> | Symbol: <%= symbol %><br>
        <%= company.description %>
    </p>
</div>

<div class="container">
    <div class="card-grid">
        <div class="card">
            <h3>Trend Analysis</h3>
            <p>Analyzes historical price movements using trend indicators to identify the overall 
                 market direction. This section helps users understand whether the stock is showing 
                 a stable uptrend, downtrend, or sideways movement over time.</p>
            <a class="btn" href="trends?symbol=<%= symbol %>">View Trend</a>
        </div>

        <div class="card">
            <h3>Volume Analysis</h3>
            <p>Examines trading volume patterns to evaluate market participation and strength behind 
                price movements. This section helps determine whether price changes are supported by 
                strong buying or selling activity.</p>
            <a class="btn" href="volume?symbol=<%=symbol%>&range=1Y">View Volume</a>

        </div>

        <div class="card">
            <h3>Risk Analysis</h3>
            <p>Evaluates the risk level of the stock by analyzing price volatility and fluctuations 
                over time. This helps users understand how stable or unpredictable the stock is,
                 making it easier to align investment decisions with their risk tolerance.</p>
            <a class="btn" href="risk?symbol=<%= symbol %>">View Risk</a>

        </div>

        <div class="card">
            <h3>Momentum Indicator</h3>
            <p>Uses momentum-based indicators to measure the speed and strength of price changes. 
                This helps identify potential entry and exit points by highlighting overbought or 
                oversold conditions and shifts in market momentum..</p>
            <a class="btn" href="momentum?symbol=<%= symbol %>">View Momentum</a>
        </div>

        <div class="card">
            <h3>Stock Summary</h3>
            <p>Provides a consolidated overview of the stock’s key characteristics by applying
               predefined thresholds. This section categorizes the stock based on trend strength, 
               risk level, and general behavior to give users a quick, easy-to-understand snapshot.</p>
            <span class="btn">View Summary</span>
        </div>

        <div class="card">
            <h3>Export Data</h3>
            <p>Allows users to download historical price data and analytical results for offline review. 
                This feature is useful for further analysis, academic purposes, reporting, or maintaining
                personal investment records.</p>
            <span class="btn">Export CSV</span>
        </div>
    </div>
</div>

<div class="footer">
    © 2026 Stock Insight Project | Educational Use Only
</div>

</body>
</html>
