<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>

<%
String sector = (String) request.getAttribute("sector");
String selectedRange = (String) request.getAttribute("selectedRange");

Double avgVolatility1Y = (Double) request.getAttribute("avgVolatility1Y");
Double avgDrawdown1Y = (Double) request.getAttribute("avgDrawdown1Y");
String stabilityLevel = (String) request.getAttribute("stabilityLevel");

List<String> symbols = (List<String>) request.getAttribute("symbols");
List<Double> companyVolList = (List<Double>) request.getAttribute("companyVolList");
List<Double> companyDDList = (List<Double>) request.getAttribute("companyDDList");

List<Double> sectorAvgDrawdown = (List<Double>) request.getAttribute("sectorAvgDrawdown");
List<String> drawdownDates = (List<String>) request.getAttribute("drawdownDates");

Integer totalCompanies = (Integer) request.getAttribute("totalCompanies");

if(symbols==null) symbols=new ArrayList<>();
if(companyVolList==null) companyVolList=new ArrayList<>();
if(companyDDList==null) companyDDList=new ArrayList<>();
if(sectorAvgDrawdown==null) sectorAvgDrawdown=new ArrayList<>();
if(drawdownDates==null) drawdownDates=new ArrayList<>();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sector Risk - <%=sector%></title>
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

/* RANGE BUTTONS */
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

/* SUMMARY CARDS */
.summary{
    display:flex;
    gap:20px;
    margin:25px 0;
}

.card{
    flex:1;
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

/* STABILITY BADGE */
.status{
    padding:8px 18px;
    border-radius:20px;
    display:inline-block;
    font-size:14px;
    font-weight:600;
    position:relative;
    right:500px;
}

.high{ background:#2e7d32; }
.moderate{ background:#f9a825; color:black; }
.low{ background:#c62828; }

/* CHART CONTAINER */
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

/* TABLE */
table{
    width:100%;
    border-collapse:collapse;
    background:#161b22;
    border:1px solid #30363d;
    border-radius:8px;
    overflow:hidden;
}

th, td{
    padding:12px;
    text-align:center;
    border-bottom:1px solid #30363d;
}

th{
    background:#21262d;
    color:#58a6ff;
}

tr:hover{
    background:#21262d;
}

canvas{
    max-height:380px;
}
</style>
</head>

<body>

<div class="header">
    <h2><%=sector%> Sector Risk</h2>
    <a href="sectorDashboard.jsp?sector=<%=sector%>" class="home-link">
        Go Back
    </a>
</div>

<div class="container">

<!-- RANGE -->
<div class="range-buttons">
    <a href="?sector=<%=sector%>&range=1M" class="<%= "1M".equals(selectedRange)?"active":"" %>">1M</a>
    <a href="?sector=<%=sector%>&range=6M" class="<%= "6M".equals(selectedRange)?"active":"" %>">6M</a>
    <a href="?sector=<%=sector%>&range=1Y" class="<%= "1Y".equals(selectedRange)?"active":"" %>">1Y</a>
    <a href="?sector=<%=sector%>&range=5Y" class="<%= "5Y".equals(selectedRange)?"active":"" %>">5Y</a>
</div>

<!-- SUMMARY -->
<div class="summary">
    <div class="card">
        <h4>1Y Avg Volatility</h4>
        <p><%=avgVolatility1Y==null?"N/A":String.format("%.2f%%",avgVolatility1Y)%></p>
    </div>
    <div class="card">
        <h4>1Y Avg Max Drawdown</h4>
        <p><%=avgDrawdown1Y==null?"N/A":String.format("%.2f%%",avgDrawdown1Y)%></p>
    </div>
    <div class="card">
        <h4>Total Companies</h4>
        <p><%=totalCompanies==null?0:totalCompanies%></p>
    </div>
</div>

<!-- STABILITY -->
<%
String statusClass="moderate";
if("High Stability".equals(stabilityLevel)) statusClass="high";
else if("Low Stability (High Risk)".equals(stabilityLevel)) statusClass="low";
%>

<div style="text-align:center; margin-bottom:30px;">
    <div class="status <%=statusClass%>">
        <%=stabilityLevel%>
    </div>
</div>

<!-- VOLATILITY CHART -->
<div class="chart-container">
    <div class="chart-title">Company Volatility Comparison</div>
    <canvas id="volChart"></canvas>
</div>

<!-- DRAWDOWN CHART -->
<div class="chart-container">
    <div class="chart-title">Sector Average Drawdown Trend</div>
    <canvas id="ddChart"></canvas>
</div>

<!-- TABLE -->
<div class="chart-container">
    <div class="chart-title">Risk Breakdown Table</div>
    <table>
        <tr>
            <th>Symbol</th>
            <th>Volatility (%)</th>
            <th>Max Drawdown (%)</th>
        </tr>
        <%
        for(int i=0;i<symbols.size();i++){
        %>
        <tr>
            <td><%=symbols.get(i)%></td>
            <td><%=String.format("%.2f",companyVolList.get(i))%></td>
            <td><%=String.format("%.2f",companyDDList.get(i))%></td>
        </tr>
        <% } %>
    </table>
</div>

</div>

<script>

const symbols = [
<% for(int i=0;i<symbols.size();i++){
   out.print("'"+symbols.get(i)+"'");
   if(i<symbols.size()-1) out.print(",");
}%>
];

const volData = [
<% for(int i=0;i<companyVolList.size();i++){
   out.print(companyVolList.get(i));
   if(i<companyVolList.size()-1) out.print(",");
}%>
];

const ddDates = [
<% for(int i=0;i<drawdownDates.size();i++){
   out.print("'"+drawdownDates.get(i)+"'");
   if(i<drawdownDates.size()-1) out.print(",");
}%>
];

const ddData = [
<% for(int i=0;i<sectorAvgDrawdown.size();i++){
   out.print(sectorAvgDrawdown.get(i));
   if(i<sectorAvgDrawdown.size()-1) out.print(",");
}%>
];

// VOL BAR CHART
new Chart(document.getElementById('volChart'),{
    type:'bar',
    data:{
        labels:symbols,
        datasets:[{
            data:volData,
            backgroundColor:'#58a6ff'
        }]
    },
    options:{
        plugins:{ legend:{display:false}},
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

// DRAW DOWN LINE CHART
new Chart(document.getElementById('ddChart'),{
    type:'line',
    data:{
        labels:ddDates,
        datasets:[{
            data:ddData,
            borderColor:'#ff7b72',
            backgroundColor:'rgba(255,123,114,0.1)',
            tension:0.3,
            pointRadius:4,
            pointBackgroundColor:'#ff7b72'
        }]
    },
    options:{
        plugins:{ legend:{display:false}},
        scales:{
            y:{
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