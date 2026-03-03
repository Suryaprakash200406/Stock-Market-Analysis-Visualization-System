<%@ page contentType="text/html;charset=UTF-8" %>
<%
String sector = request.getParameter("sector");
if (sector == null) {
    response.sendRedirect("sample.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Sector Dashboard - Stock Insight</title>

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

.dashboard-title {
    font-size: 22px;
    font-weight: bold;
    color: #58a6ff;
}

.dashboard-title span{color:#38bdf8;}

.home-link {
    padding: 8px 16px;
    border-radius: 8px;
    background-color: #238636;
    font-size: 14px;
}
.home-link:hover {
    background-color: #2ea043;
}

/* ---------- MAIN CONTAINER ---------- */
.container {
    display: flex;
    justify-content: center;
    padding: 40px 0 40px 0;
}

/* ---------- CARD GRID (70% WIDTH CENTERED) ---------- */
.card-grid {
    width: 85%;
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 25px;
    column-gap:70px;
}

/* ---------- CARDS ---------- */
.card {
    background: linear-gradient(145deg, #161b22, #1f2937);
    border-radius: 16px;
    padding: 25px 28px;
    min-height: 170px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.5);
    transition: all 0.3s ease;
    cursor: pointer;
    display: flex;
    flex-direction: column;
    justify-content: center;
}

.card:hover {
    transform: translateY(-6px);
    box-shadow: 0 12px 30px rgba(0,0,0,0.6);
    border: 1px solid rgba(88,166,255,0.4);
}

.card h3 {
    margin: 0 0 10px 0;
    font-size: 20px;
}

.card p {
    font-size: 13px;
    color: #9da7b3;
    line-height: 1.6;
    margin: 0;
}

/* ---------- FOOTER ---------- */
.footer {
    background-color: #1c2431;
    padding: 18px;
    text-align: center;
    color: #8b949e;
    font-size: 13px;
    margin-top: 40px;
}

</style>
</head>

<body>

<!-- HEADER -->
<div class="dashboard-header">
    <div class="dashboard-title">Stock Insight - Sector Dashboard <span>(<%= sector %>)</span></div>
    <a href="sample.jsp" class="home-link">Go to Home</a>
</div>

<!-- MAIN CONTENT -->
<div class="container">
    <div class="card-grid">

        <!-- Sector Growth -->
        <div class="card" onclick="location.href='sectorGrowth?sector=<%= sector %>'">
            <h3>Sector Growth Performance</h3>
               <p>
                    Assess the overall performance of a sector by calculating average 
                    return percentages across 1 Month, 6 Month, 1 Year and 5 Year 
                    periods. This section provides a consolidated view of sector-wide 
                    growth trends and highlights the strongest and weakest performing 
                    stock based on recent return analysis. It helps determine whether 
                    the sector is expanding, slowing down, or maintaining consistent 
                    growth over time.
               </p>
        </div>

        <!-- Sector Participation -->
        <div class="card" onclick="location.href='sectorParticipation?sector=<%= sector %>'">
            <h3>Sector Participation Strength</h3>
                <p>
                    Evaluate sector activity by analyzing total traded volume and 
                    average volume per company over selected periods. This section 
                    measures the level of market participation and identifies the 
                    most actively traded stock within the sector. Strong participation 
                    typically indicates investor interest, liquidity strength, and 
                    potential capital flow concentration.
                </p>
        </div>

        <!-- Sector Risk -->
        <div class="card" onclick="location.href='sectorRisk?sector=<%= sector %>'">
            <h3>Sector Risk & Stability</h3>
                <p>
                    Analyze the volatility and price fluctuation behavior of companies 
                    within the sector using statistical dispersion measures derived 
                    from historical closing prices. This section helps determine 
                    whether the sector exhibits stable, predictable movement or 
                    frequent and wide price swings, enabling better understanding 
                    of relative investment risk.
                </p>
        </div>

        <!-- Sector Price Structure -->
        <div class="card" onclick="location.href='sectorPrice?sector=<%= sector %>'">
            <h3>Sector Price Structure</h3>
                <p>
                    Examine the sector’s structural positioning by comparing current 
                    price levels against historical 52-week highs and lows. This 
                    analysis reveals whether the sector is trading near peak levels, 
                    bottom ranges, or mid-cycle consolidation zones. It provides 
                    insight into potential upside capacity or downside exposure 
                    within its long-term price range.
                </p>
        </div>

    </div>
</div>

<!-- FOOTER -->
<div class="footer">
    © 2026 Stock Insight Project | Educational Use Only
</div>

</body>
</html>