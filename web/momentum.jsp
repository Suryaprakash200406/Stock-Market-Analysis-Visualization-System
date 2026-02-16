<%@page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Momentum Analysis</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body{
    font-family: Arial, sans-serif;
    background:#0d1117;
    color:#e6edf3;
    margin:0;
    padding:0;
}

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
    margin:30px 40px;
}

.momentum-grid{
    display:grid;
    grid-template-columns: 1fr 1fr;
    gap:30px;
}

.rsi-card, .momentum-card, .chart-section{
    background:#161b22;
    padding:30px;
    border:1px solid #30363d;
    border-radius:12px;
}

.rsi-value{
    font-size:60px;
    font-weight:bold;
    margin:0;
}

.rsi-label{
    font-size:14px;
    color:#8b949e;
}

.signal-badge{
    display:inline-block;
    margin-top:15px;
    padding:8px 16px;
    border-radius:20px;
    font-weight:bold;
    font-size:13px;
}

.momentum-item{
    margin-bottom:25px;
}

.momentum-item h4{
    margin:0;
    font-size:14px;
    color:#8b949e;
}

.momentum-item p{
    margin-top:6px;
    font-size:28px;
    font-weight:bold;
}

.chart-section{
    margin-top:40px;
}

canvas{
    max-height:420px;
}
</style>
</head>

<body>

<%
Double rsi = (Double)request.getAttribute("rsi");
Double momentum10 = (Double)request.getAttribute("momentum10");
Double momentum20 = (Double)request.getAttribute("momentum20");
String signal = (String)request.getAttribute("rsiSignal");

String rsiColor = "#58a6ff"; // neutral blue
if(rsi > 70){
    rsiColor = "#ef4444"; // red
} else if(rsi < 30){
    rsiColor = "#22c55e"; // green
}

String m10Color = momentum10 >= 0 ? "#22c55e" : "#ef4444";
String m20Color = momentum20 >= 0 ? "#22c55e" : "#ef4444";

String m10Sign = momentum10 > 0 ? "+" : "";
String m20Sign = momentum20 > 0 ? "+" : "";
%>

<div class="header">
    <h2>${symbol} Momentum Analysis</h2>
    <a href="companyDashboard.jsp?symbol=${symbol}" class="home-link">Go Back</a>

</div>

<div class="container">

    <div class="momentum-grid">

        <!-- RSI -->
        <div class="rsi-card">

            <div class="rsi-label">14-Day RSI</div>
            <p class="rsi-value" style="color:<%=rsiColor%>;">
                <%= String.format("%.2f", rsi) %>
            </p>

            <div class="signal-badge" style="background:<%=rsiColor%>; color:white;">
                <%= signal %>
            </div>

        </div>

        <!-- Momentum -->
        <div class="momentum-card">

            <div class="momentum-item">
                <h4>10-Day Momentum</h4>
                <p style="color:<%=m10Color%>;">
                    <%= m10Sign + String.format("%.2f", momentum10) %>%
                </p>
            </div>

            <div class="momentum-item">
                <h4>20-Day Momentum</h4>
                <p style="color:<%=m20Color%>;">
                    <%= m20Sign + String.format("%.2f", momentum20) %>%
                </p>
            </div>

        </div>

    </div>

    <!-- Chart -->
    <div class="chart-section">
        <canvas id="rsiChart"></canvas>
    </div>

</div>

<script>

const labels = [
<%
List<String> dates = (List<String>)request.getAttribute("chartDates");
for(int i=0;i<dates.size();i++){
%>
"<%=dates.get(i)%>",
<% } %>
];

const rsiData = [
<%
List<Double> rsiValues = (List<Double>)request.getAttribute("rsiValues");
for(int i=0;i<rsiValues.size();i++){
%>
<%=rsiValues.get(i)%>,
<% } %>
];

new Chart(document.getElementById('rsiChart'), {
    type:'line',
    data:{
        labels:labels,
        datasets:[{
            label:'RSI (14)',
            data:rsiData,
            borderColor:'#58a6ff',
            borderWidth:2,
            tension:0.3,
            pointRadius:0
        }]
    },
    options:{
        responsive:true,
        interaction:{ mode:'index', intersect:false },
        scales:{
            x:{
                ticks:{color:'#e6edf3'},
                grid:{color:'#21262d'}
            },
            y:{
                min:0,
                max:100,
                ticks:{color:'#e6edf3'},
                grid:{color:'#21262d'}
            }
        },
        plugins:{
            legend:{
                labels:{color:'#e6edf3'}
            }
        }
    }
});

</script>

</body>
</html>
