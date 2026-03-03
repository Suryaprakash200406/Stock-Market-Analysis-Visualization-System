<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sector Participation - ${sector}</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body{
    font-family: Arial, sans-serif;
    background:#0d1117;
    color:#e6edf3;
    margin:0;
    padding:0;
}

/* HEADER */
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

/* CENTER SUMMARY */
.center-box{
    text-align:center;
    margin-bottom:30px;
}

.big-percent{
    font-size:60px;
    font-weight:bold;
    margin:10px 0;
}

.status{
    padding:8px 18px;
    border-radius:20px;
    display:inline-block;
    font-size:14px;
    font-weight:600;
}

.strong{ background:#2e7d32; }
.moderate{ background:#f9a825; }
.weak{ background:#c62828; }

/* SUMMARY CARDS */
.summary{
    display:flex;
    gap:20px;
    margin-bottom:30px;
}

.card{
    flex:1;
    background:#161b22;
    padding:22px;
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
    font-size:20px;
    font-weight:bold;
    margin-top:6px;
}

/* CHART CONTAINERS */
.chart-container{
    background:#161b22;
    padding:25px;
    border-radius:8px;
    border:1px solid #30363d;
    margin-bottom:30px;
}

.chart-title{
    margin-bottom:20px;
    font-size:16px;
    color:#8b949e;
}

/* Smaller charts */
canvas{
    max-height:380px;
}
</style>
</head>

<body>

<div class="header">
    <h2>${sector} Sector Participation</h2>
    <a href="sectorDashboard.jsp?sector=${sector}" class="home-link">
        Go Back
    </a>
</div>

<div class="container">

<div class="center-box">
    <p style="color:#8b949e;">
        Data aligned till: ${alignedDate}
    </p>

    <div class="big-percent">
        ${participationPercent}%
    </div>

<%
    String status = (String) request.getAttribute("status");
    String statusClass = "weak";
    if ("Strong Participation".equals(status))
        statusClass = "strong";
    else if ("Moderate Participation".equals(status))
        statusClass = "moderate";
%>

    <div class="status <%=statusClass%>">
        ${status}
    </div>
</div>

<!-- SUMMARY CARDS -->
<div class="summary">
    <div class="card">
        <h4>Total Companies</h4>
        <p>${totalCompanies}</p>
    </div>

    <div class="card">
        <h4>Above 20 MA</h4>
        <p>${aboveCount}</p>
    </div>

    <div class="card">
        <h4>Below 20 MA</h4>
        <p>${belowCount}</p>
    </div>
</div>

<!-- BAR CHART -->
<div class="chart-container">
    <div class="chart-title">Latest Day Distribution</div>
    <canvas id="barChart"></canvas>
</div>

<!-- LINE CHART -->
<div class="chart-container">
    <div class="chart-title">
        Last 10 Trading Days Participation Trend
    </div>
    <canvas id="lineChart"></canvas>
</div>

</div>

<script>
const historyDates = [
<%
    List<String> dates =
            (List<String>) request.getAttribute("historyDates");
    if (dates != null) {
        for (int i = 0; i < dates.size(); i++) {
            out.print("'" + dates.get(i) + "'");
            if (i < dates.size() - 1) out.print(",");
        }
    }
%>
];

const participationHistory = [
<%
    List<Double> values =
            (List<Double>) request.getAttribute("participationHistory");
    if (values != null) {
        for (int i = 0; i < values.size(); i++) {
            out.print(values.get(i));
            if (i < values.size() - 1) out.print(",");
        }
    }
%>
];

// BAR CHART
new Chart(document.getElementById('barChart'), {
    type: 'bar',
    data: {
        labels: ['Above 20 MA', 'Below 20 MA'],
        datasets: [{
            data: [${aboveCount}, ${belowCount}],
            backgroundColor: ['#55e683', '#ff7b72']
        }]
    },
    options: {
        plugins:{ legend:{ display:false }},
        scales:{
            y:{
                beginAtZero:true,
                ticks:{color:'#e6edf3'},
                grid:{color:'#21262d'}
            },
            x:{
                ticks:{color:'#e6edf3'},
                grid:{color:'#21262d'}
            }
        }
    }
});

// LINE CHART
new Chart(document.getElementById('lineChart'), {
    type: 'line',
    data: {
        labels: historyDates,
        datasets: [{
            label: 'Participation %',
            data: participationHistory,
            borderColor: '#58a6ff',
            backgroundColor:'rgba(88,166,255,0.1)',
            tension: 0.3,

            // 🔥 BIGGER POINTS HERE
            pointRadius: 6,
            pointHoverRadius: 8,
            pointBackgroundColor:'#58a6ff'
        }]
    },
    options: {
        plugins:{
            legend:{ labels:{color:'#e6edf3'} }
        },
        scales:{
            y:{
                min:0,
                max:100,
                ticks:{color:'#e6edf3'},
                grid:{color:'#21262d'}
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