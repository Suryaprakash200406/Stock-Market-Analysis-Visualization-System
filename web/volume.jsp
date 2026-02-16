<%@page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    List<String> dates = (List<String>) request.getAttribute("dates");
    List<Double> volumes = (List<Double>) request.getAttribute("volumes");
    List<Double> volumeMAList = (List<Double>) request.getAttribute("volumeMA");

    String symbol = (String) request.getAttribute("symbol");
    String range = (String) request.getAttribute("range");

    if(range == null) range = "1M";   // ✅ Default 1M

    double latestVolume = (double) request.getAttribute("latestVolume");
    double volumeChangePercent = (double) request.getAttribute("volumeChangePercent");
    double highestVolume = (double) request.getAttribute("highestVolume");
    double averageVolume = (double) request.getAttribute("averageVolume");

    String changeColor = volumeChangePercent >= 0 ? "#22c55e" : "#ef4444";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Volume - <%=symbol%></title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body{
    font-family: 'Segoe UI', sans-serif;
    background:#0d1117;
    color:#e6edf3;
    margin:0;
}

/* HEADER */
.header{
    background:#161b22;
    padding:18px 40px;
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
    padding:8px 18px;
    border-radius:8px;
    background:#238636;
    color:white;
    text-decoration:none;
    font-size:14px;
}
.home-link:hover{ background:#2ea043; }

/* CONTAINER */
.container{
    width:1200px;
    margin:30px auto;
}

/* RANGE BUTTONS */
.range-buttons{
    margin-bottom:25px;
}

.range-buttons a{
    padding:8px 18px;
    margin-right:10px;
    text-decoration:none;
    border-radius:8px;
    border:1px solid #30363d;
    font-weight:600;
  
    transition:0.2s ease;
    background:#161b22;
    color:#e6edf3;
}

.range-buttons a:hover{
    background:#21262d;
}

.range-buttons a.active{
    background:#58a6ff;
    color:#0d1117;
    border:none;
}

/* LAYOUT */
.main-layout{
    display:flex;
    gap:30px;
}

.summary{
    width:300px;
    display:flex;
    flex-direction:column;
    gap:20px;
}

.card{
    background:#161b22;
    padding:20px;
    border-radius:12px;
    border:1px solid #30363d;
}

.card h4{
    margin:0;
    font-size:13px;
    color:#8b949e;
}

.card p{
    margin-top:8px;
    font-size:20px;
    font-weight:bold;
}

.chart-section{
    flex:1;
    background:#161b22;
    padding:25px;
    border-radius:12px;
    border:1px solid #30363d;
}

canvas{
    max-height:450px;
}

.insight{
    margin-top:30px;
    background:#161b22;
    padding:20px;
    border-radius:12px;
    border:1px solid #30363d;
}
.insight h3{
    margin-top:0;
    color:#58a6ff;
}
</style>
</head>

<body>

<div class="header">
    <h2><%=symbol%> Volume Analysis</h2>
    <a href="companyDashboard.jsp?symbol=<%=symbol%>" class="home-link">Go Back</a>
</div>

<div class="container">

<div class="range-buttons">
    <a href="volume?symbol=<%=symbol%>&range=1M" class="<%=range.equals("1M")?"active":""%>">1M</a>
    <a href="volume?symbol=<%=symbol%>&range=6M" class="<%=range.equals("6M")?"active":""%>">6M</a>
    <a href="volume?symbol=<%=symbol%>&range=1Y" class="<%=range.equals("1Y")?"active":""%>">1Y</a>
    <a href="volume?symbol=<%=symbol%>&range=5Y" class="<%=range.equals("5Y")?"active":""%>">5Y</a>
    <a href="volume?symbol=<%=symbol%>&range=MAX" class="<%=range.equals("MAX")?"active":""%>">MAX</a>
</div>

<div class="main-layout">

<div class="summary">
    <div class="card">
        <h4>Latest Volume</h4>
        <p><%=String.format("%,.0f", latestVolume)%></p>
    </div>

    <div class="card">
        <h4>Volume Change</h4>
        <p style="color:<%=changeColor%>;">
            <%=String.format("%.2f", volumeChangePercent)%>%
        </p>
    </div>

    <div class="card">
        <h4>Highest Volume</h4>
        <p><%=String.format("%,.0f", highestVolume)%></p>
    </div>

    <div class="card">
        <h4>Average Volume</h4>
        <p><%=String.format("%,.0f", averageVolume)%></p>
    </div>
</div>

<div class="chart-section">
    <canvas id="volumeChart"></canvas>
</div>

</div>

<div class="insight">
    <h3>Volume Insight</h3>
    <p>
        Rising price with increasing volume confirms bullish strength.
        Falling price with rising volume confirms bearish pressure.
        Low volume indicates weak participation.
    </p>
</div>

</div>

<script>

const labels = [
<%
for(int i=0;i<dates.size();i++){
%>
"<%=dates.get(i)%>"<%= (i<dates.size()-1?",":"") %>
<% } %>
];

const volumeData = [
<%
for(int i=0;i<volumes.size();i++){
%>
<%=volumes.get(i)%><%= (i<volumes.size()-1?",":"") %>
<% } %>
];

const volumeMA = [
<%
for(int i=0;i<volumeMAList.size();i++){
    Double val = volumeMAList.get(i);
%>
<%= val==null?"null":val %><%= (i<volumeMAList.size()-1?",":"") %>
<% } %>
];

new Chart(document.getElementById('volumeChart'), {
    data: {
        labels: labels,
        datasets: [
        {
           type:'bar',
           label:'Volume',
           data:volumeData,
           backgroundColor: volumeData.map((value, i) => {
           if(i === 0) return '#22c55e';
              return value >= volumeData[i-1] ? '#22c55e' : '#ef4444';
           })
        },
        
        {
            type:'line',
            label:'20 Day Volume MA',
            data:volumeMA,
            borderColor:'#faac15',
            borderWidth:2,
            tension:0.3,
            pointRadius:0
        }
        ]
    },
    options:{
        responsive:true,
        interaction:{ mode:'index', intersect:false },
        scales:{
            x:{ ticks:{color:'#e6edf3',maxTicksLimit:10}, grid:{color:'#21262d'} },
            y:{
                ticks:{color:'#e6edf3'},
                grid:{color:'#21262d'}
            }
        },
        plugins:{
            legend:{ labels:{color:'#e6edf3'} }
        }
    }
});
</script>


</body>
</html>
