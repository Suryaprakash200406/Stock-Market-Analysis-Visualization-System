<%@page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    com.project.model.TrendResult result = 
        (com.project.model.TrendResult) request.getAttribute("result");

    List<String> dates = result.dates;
    List<Double> closeList = result.closeList;
    List<Double> movingAvg = result.movingAvg;
    List<Map<String, Object>> recentData = result.recentData;

    double latestClose = result.latestClose;
    double dailyChangePercent = result.dailyChangePercent;
    double oneYearHigh = result.oneYearHigh;
    double oneYearLow = result.oneYearLow;
    double oneYearReturn = result.oneYearReturn;
    Double latestMA = result.latestMA;

    String symbol = (String) request.getAttribute("symbol");
    String range = (String) request.getAttribute("range");

    String changeColor = dailyChangePercent >= 0 ? "#55e683" : "#ff7b72";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Trend - <%=symbol%></title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body{
    font-family: Arial, sans-serif;
    background:#0d1117;
    color:#e6edf3;
    margin:0;
    padding:0;
}

/* HEADER (Same as Risk Page) */
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

a{text-decoration:none; color:inherit;}

.container{
    max-width:1200px;
    margin:auto;
    padding:20px;
}

.price-box{
    font-size:24px;
    font-weight:bold;
    margin-top:15px;
}

.range-buttons{
    margin:20px 0;
}

.range-buttons a{
    padding:8px 14px;
    margin-right:5px;
    text-decoration:none;
    background:#161b22;
    color:#e6edf3;
    border-radius:6px;
    border:1px solid #30363d;
    font-weight:600;
}

.range-buttons a:hover{
    background:#21262d;
}

.range-buttons a.active{
    background:#58a6ff;
    color:#0d1117;
}

.summary{
    display:flex;
    gap:20px;
    margin:25px 0;
}

.card{
    flex:1;
    background:#161b22;
    padding:15px;
    border-radius:8px;
    border:1px solid #30363d;
}

.card h4{
    margin:0;
    font-size:14px;
    color:#8b949e;
}

.card p{
    font-size:18px;
    font-weight:bold;
    margin-top:5px;
}

.chart-container{
    background:#161b22;
    padding:15px;
    border-radius:8px;
    border:1px solid #30363d;
    overflow-x:auto;
}

canvas{
    min-width:1000px;
    max-height:400px;
}

table{
    width:100%;
    border-collapse:collapse;
    margin-top:30px;
    background:#161b22;
    border:1px solid #30363d;
}

th, td{
    padding:10px;
    text-align:center;
    border-bottom:1px solid #30363d;
}

th{
    background:#21262d;
    color:#58a6ff;
}

tr:nth-child(even){
    background:#1c2128;
}

tr:hover{
    background:#21262d;
}
</style>
</head>
<body>

<!-- ✅ NEW HEADER (Same Structure as Risk Page) -->
<div class="header">
    <h2><%=symbol%> Trend Analysis</h2>
    <a href="companyDashboard.jsp?symbol=<%=symbol%>" class="home-link">Go Back</a>
</div>

<div class="container">

<div class="price-box">
₹ <%=String.format("%.2f", latestClose)%>
<span style="color:<%=changeColor%>; font-size:18px;">
    (<%=String.format("%.2f", dailyChangePercent)%>%)
</span>
</div>

<!-- RANGE BUTTONS -->
<div class="range-buttons">
    <a href="trends?symbol=<%=symbol%>&range=1M" class="<%=range.equals("1M")?"active":""%>">1M</a>
    <a href="trends?symbol=<%=symbol%>&range=6M" class="<%=range.equals("6M")?"active":""%>">6M</a>
    <a href="trends?symbol=<%=symbol%>&range=1Y" class="<%=range.equals("1Y")?"active":""%>">1Y</a>
    <a href="trends?symbol=<%=symbol%>&range=5Y" class="<%=range.equals("5Y")?"active":""%>">5Y</a>
    <a href="trends?symbol=<%=symbol%>&range=MAX" class="<%=range.equals("MAX")?"active":""%>">MAX</a>
</div>

<!-- SUMMARY CARDS -->
<div class="summary">
    <div class="card">
        <h4>1Y High</h4>
        <p>₹ <%=String.format("%.2f", oneYearHigh)%></p>
    </div>
    <div class="card">
        <h4>1Y Low</h4>
        <p>₹ <%=String.format("%.2f", oneYearLow)%></p>
    </div>
    <div class="card">
        <h4>1Y Return</h4>
        <p style="color:<%=oneYearReturn>=0?"#55e683":"#ff7b72"%>;">
            <%=String.format("%.2f", oneYearReturn)%>%
        </p>
    </div>
    <div class="card">
        <h4>20 Day MA</h4>
        <p><%= latestMA != null ? "₹ " + String.format("%.2f", latestMA) : "N/A" %></p>
    </div>
</div>

<!-- CHART -->
<div class="chart-container">
    <canvas id="trendChart"></canvas>
</div>

<!-- RECENT TABLE -->
<h3 style="color:#58a6ff;">Recent Trading Data (Last 10 Days)</h3>
<table>
<tr>
    <th>Date</th>
    <th>Open</th>
    <th>High</th>
    <th>Low</th>
    <th>Close</th>
    <th>Volume</th>
</tr>
<%
for(int i = recentData.size() - 1; i >= 0; i--){
    Map<String,Object> row = recentData.get(i);
%>
<tr>
    <td><%=row.get("date")%></td>
    <td><%=row.get("open")%></td>
    <td><%=row.get("high")%></td>
    <td><%=row.get("low")%></td>
    <td><%=row.get("close")%></td>
    <td><%=row.get("volume")%></td>
</tr>
<%
}
%>
</table>
</div>

<script>
const labels = [<%
for(int i=0;i<dates.size();i++){ %>
"<%=dates.get(i)%>"<%= (i<dates.size()-1?",":"") %>
<% } %>];

const closeData = [<%
for(int i=0;i<closeList.size();i++){ %>
<%=closeList.get(i)%><%= (i<closeList.size()-1?",":"") %>
<% } %>];

const maData = [<%
for(int i=0;i<movingAvg.size();i++){
    Double val = movingAvg.get(i);
%>
<%= val==null?"null":val %><%= (i<movingAvg.size()-1?",":"") %>
<% } %>];

new Chart(document.getElementById('trendChart'), {
    type: 'line',
    data: {
        labels: labels,
        datasets: [
            {
                label: 'Closing Price',
                data: closeData,
                borderColor: '#58a6ff',
                borderWidth: 1.5,
                tension: 0.1,
                pointRadius: 0
            },
            {
                label: '20 Day MA',
                data: maData,
                borderColor: '#55e683',
                borderWidth: 1.2,
                borderDash:[5,5],
                tension: 0.1,
                pointRadius: 0
            }
        ]
    },
    options: {
        responsive: true,
        interaction: { mode: 'index', intersect: false },
        scales: {
            x: { ticks: { color:'#e6edf3', maxTicksLimit: 10 }, grid: { color:'#21262d' } },
            y: { ticks: { color:'#e6edf3' }, grid: { color:'#21262d' } }
        },
        plugins:{ legend:{ labels:{color:'#e6edf3'} } }
    }
});
</script>
</body>
</html>
