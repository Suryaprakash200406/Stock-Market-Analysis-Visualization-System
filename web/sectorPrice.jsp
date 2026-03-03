<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>

<%
String sector = (String) request.getAttribute("sector");
String structureLabel = (String) request.getAttribute("structureLabel");
String structureClass = (String) request.getAttribute("structureClass");

Double currentPrice = (Double) request.getAttribute("currentPrice");
Double ma50 = (Double) request.getAttribute("ma50");
Double ma200 = (Double) request.getAttribute("ma200");
Double distFromHigh = (Double) request.getAttribute("distFromHigh");
Double distFromLow = (Double) request.getAttribute("distFromLow");

List<Double> series = (List<Double>) request.getAttribute("sectorCloseSeries");

if(series==null) series = new ArrayList<>();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sector Price - <%=sector%></title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body{
    font-family: Arial, sans-serif;
    background:#0d1117;
    color:#e6edf3;
    margin:0;
    padding:0;
}

/* HEADER (Same as Growth & Risk) */
.header{
    padding:20px 40px;
    background:#161b22;
    border-bottom:1px solid #30363d;
    display:flex;
    justify-content:space-between;
    align-items:center;
}

.header h2{
    margin:0;
    color:#58a6ff;
}

.home-link{
    padding:8px 16px;
    border-radius:6px;
    background:#238636;
    font-size:14px;
    text-decoration:none;
    color:white;
}
.home-link:hover{ background:#2ea043; }

.container{
    max-width:1200px;
    margin:auto;
    padding:30px 20px;
}

/* SUMMARY CARDS */
.summary{
    display:flex;
    gap:20px;
    margin:30px 0;
    flex-wrap:wrap;
}

.card{
    flex:1;
    min-width:180px;
    background:#161b22;
    padding:18px;
    border-radius:8px;
    border:1px solid #30363d;
    text-align:center;
}

.card h4{
    margin:0;
    font-size:14px;
    color:#8b949e;
}

.card p{
    font-size:18px;
    font-weight:bold;
    margin-top:6px;
}

/* TREND BADGE (Same color logic as Risk) */
.status{
    padding:10px 20px;
    border-radius:20px;
    display:inline-block;
    font-size:14px;
    font-weight:600;
    position:relative;
    right:510px;
}

.high{ background:#2e7d32; }       /* Strong Uptrend */
.moderate{ background:#f9a825; color:black; } /* Pullback */
.low{ background:#c62828; }        /* Downtrend */
.neutral{ background:#30363d; }

/* CHART CONTAINER */
.chart-container{
    background:#161b22;
    padding:25px;
    border-radius:8px;
    border:1px solid #30363d;
    margin-top:30px;
}

canvas{
    max-height:420px;
}
</style>
</head>

<body>

<!-- HEADER -->
<div class="header">
    <h2><%=sector%> Sector Price Structure</h2>
    <a href="sectorDashboard.jsp?sector=<%=sector%>" class="home-link">
        Go Back
    </a>
</div>

<div class="container">

<!-- SUMMARY CARDS -->
<div class="summary">

    <div class="card">
        <h4>Sector Index</h4>
        <p><%=String.format("%.2f", currentPrice)%></p>
    </div>

    <div class="card">
        <h4>50 DMA</h4>
        <p><%=String.format("%.2f", ma50)%></p>
    </div>

    <div class="card">
        <h4>200 DMA</h4>
        <p><%=String.format("%.2f", ma200)%></p>
    </div>

    <div class="card">
        <h4>% from 52W High</h4>
        <p><%=String.format("%.2f%%", distFromHigh)%></p>
    </div>

    <div class="card">
        <h4>% from 52W Low</h4>
        <p><%=String.format("%.2f%%", distFromLow)%></p>
    </div>

</div>

<!-- TREND INDICATION BELOW CARDS -->
<div style="text-align:center; margin-bottom:30px;">
    <%
    String statusClass="moderate";
    if("Strong Uptrend".equals(structureLabel)) statusClass="high";
    else if("Downtrend".equals(structureLabel)) statusClass="low";
    else if("Neutral".equals(structureLabel)) statusClass="neutral";
    %>

    <div class="status <%=statusClass%>">
        <%=structureLabel%>
    </div>
</div>

<!-- PRICE CHART -->
<div class="chart-container">
    <canvas id="structureChart"></canvas>
</div>

</div>

<script>

const data = <%=series.toString()%>;

new Chart(document.getElementById('structureChart'), {
    type: 'line',
    data: {
        labels: data.map((_,i)=>i),
        datasets: [{
            label: 'Sector Price',
            data: data,
            borderColor: '#58a6ff',
            backgroundColor:'rgba(88,166,255,0.1)',
            tension:0.3,
            pointRadius:3,
            fill:true
        }]
    },
    options:{
        plugins:{ legend:{display:false}},
        scales:{
            y:{
                ticks:{color:'#e6edf3'},   // Visible axis values
                grid:{color:'#21262d'}     // Mild grid lines
            },
            x:{
                ticks:{color:'#e6edf3'},
                grid:{color:'#21262d'}
            }
        }
    }
});

</script>

</body>
</html>