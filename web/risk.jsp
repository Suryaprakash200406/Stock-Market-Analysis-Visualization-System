<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.*" %>

<%
    String symbol = (String) request.getAttribute("symbol");
    String range = (String) request.getAttribute("range");

    if(symbol == null) symbol = "N/A";
    if(range == null) range = "1Y";

    double volatility = request.getAttribute("volatility") != null ?
            (double) request.getAttribute("volatility") : 0.0;

    double maxDrawdown = request.getAttribute("maxDrawdown") != null ?
            (double) request.getAttribute("maxDrawdown") : 0.0;

    double high1Y = request.getAttribute("high1Y") != null ?
            (double) request.getAttribute("high1Y") : 0.0;

    double low1Y = request.getAttribute("low1Y") != null ?
            (double) request.getAttribute("low1Y") : 0.0;

    String riskCategory = (String) request.getAttribute("riskCategory");
    if(riskCategory == null) riskCategory = "Low";

    List<String> labels = (List<String>) request.getAttribute("labels");
    if(labels == null) labels = new ArrayList<>();

    List<Double> drawdownList = (List<Double>) request.getAttribute("drawdownList");
    if(drawdownList == null) drawdownList = new ArrayList<>();
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Risk Analysis</title>
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

/* RANGE */
.range-section{
    padding:25px 40px 10px 40px;
}

.range-buttons a{
    padding:7px 14px;
    margin-right:6px;
    text-decoration:none;
    background:#161b22;
    color:#e6edf3;
    border-radius:4px;
    border:1px solid #30363d;
    font-weight:600;
    font-size:13px;
}

.range-buttons a:hover{ background:#21262d; }

.range-buttons a.active{
    background:#58a6ff;
    color:#0d1117;
}

/* RISK STRIP */
.risk-strip{
    margin:20px 40px;
    padding:25px;
    background:linear-gradient(90deg,#161b22,#1c2128);
    border:1px solid #30363d;
    border-radius:10px;
    display:flex;
    justify-content:space-around;
    text-align:center;
}

.risk-box h4{
    margin:0;
    font-size:13px;
    color:#8b949e;
}

.risk-box p{
    margin-top:8px;
    font-size:26px;
    font-weight:bold;
}

/* CHART */
.chart-container{
    margin:30px 40px;
    padding:20px;
    background:#161b22;
    border:1px solid #30363d;
    border-radius:10px;
}

canvas{ max-height:420px; }

/* METER */
.meter-section{
    margin:30px 40px;
    padding:25px;
    background:#161b22;
    border:1px solid #30363d;
    border-radius:10px;
}

.meter-bar{
    height:14px;
    background:linear-gradient(to right,#22c55e,#facc15,#ef4444);
    border-radius:10px;
    position:relative;
}

.meter-pointer{
    position:absolute;
    top:-6px;
    width:20px;
    height:20px;
    border-radius:50%;
    background:#ffffff;
    border:3px solid #0d1117;
}

.meter-labels{
    display:flex;
    justify-content:space-between;
    margin-top:8px;
    font-size:12px;
    color:#8b949e;
}

/* INTERPRETATION */
.interpretation{
    margin:30px 40px 50px 40px;
    padding:20px;
    background:#161b22;
    border:1px solid #30363d;
    border-radius:10px;
}

.interpretation h3{
    margin-top:0;
    color:#58a6ff;
}
</style>
</head>

<body>

<div class="header">
    <h2><%= symbol %> Risk Analysis</h2>
    <a href="companyDashboard.jsp?symbol=<%=symbol%>" class="home-link">Go Back</a>
</div>

<div class="range-section">
    <div class="range-buttons">
        <a href="risk?symbol=<%=symbol%>&range=1M" class="<%=range.equals("1M")?"active":""%>">1M</a>
        <a href="risk?symbol=<%=symbol%>&range=6M" class="<%=range.equals("6M")?"active":""%>">6M</a>
        <a href="risk?symbol=<%=symbol%>&range=1Y" class="<%=range.equals("1Y")?"active":""%>">1Y</a>
        <a href="risk?symbol=<%=symbol%>&range=5Y" class="<%=range.equals("5Y")?"active":""%>">5Y</a>
        <a href="risk?symbol=<%=symbol%>&range=MAX" class="<%=range.equals("MAX")?"active":""%>">MAX</a>
    </div>
</div>

<!-- RISK STRIP -->
<div class="risk-strip">

    <div class="risk-box">
        <h4>Volatility (Annualized)</h4>
        <p style="color:<%= volatility > 25 ? "#ef4444" : "#22c55e" %>;">

            <%= String.format("%.2f", volatility) %>%
        </p>
    </div>

    <div class="risk-box">
        <h4>Max Drawdown</h4>
        <p style="color:#ef4444;">
            <%= String.format("%.2f", maxDrawdown) %>%
        </p>
    </div>

    <div class="risk-box">
        <h4>1Y High / Low</h4>
        <p>
            ₹ <%= String.format("%.2f", high1Y) %> /
            ₹ <%= String.format("%.2f", low1Y) %>
        </p>
    </div>

    <div class="risk-box">
        <h4>Risk Category</h4>
        <%
            String color="#22c55e";
            if("High".equals(riskCategory)) color="#ef4444";
            else if("Moderate".equals(riskCategory)) color="#facc15";
        %>
        <p style="color:<%=color%>;"><%= riskCategory %> Risk</p>
    </div>

</div>

<!-- DRAW DOWN CHART -->
<div class="chart-container">
    <canvas id="drawdownChart"></canvas>
</div>

<!-- RISK METER -->
<div class="meter-section">
    <h3>Risk Meter</h3>
    <div class="meter-bar">
        <%
            double meterPosition = 0;
           if(volatility > 0){
             meterPosition = volatility;

                if(meterPosition < 0) meterPosition = 0;
                if(meterPosition > 100) meterPosition = 100;
            }
        %>

        <div class="meter-pointer" style="left:<%= meterPosition %>%"></div>

    </div>
    <div class="meter-labels">
        <span>Low</span>
        <span>Moderate</span>
        <span>High</span>
    </div>
</div>

<!-- INTERPRETATION -->
<div class="interpretation">
    <h3>Risk Interpretation</h3>
    <p>
        <% if("High".equals(riskCategory)){ %>
            This stock shows high price fluctuation and deep corrections.
            Suitable for aggressive investors.
        <% } else if("Moderate".equals(riskCategory)){ %>
            This stock shows balanced volatility.
            Suitable for moderate risk investors.
        <% } else { %>
            This stock shows stable price movement.
            Suitable for conservative investors.
        <% } %>
    </p>
</div>

<script>

const labels = [
<%
for(int i=0;i<labels.size();i++){
    out.print("\"" + labels.get(i) + "\"");
    if(i<labels.size()-1) out.print(",");
}
%>
];

const drawdownData = [
<%
for(int i=0;i<drawdownList.size();i++){
    out.print(drawdownList.get(i));
    if(i<drawdownList.size()-1) out.print(",");
}
%>
];

new Chart(document.getElementById('drawdownChart'), {
    type:'line',
    data:{
        labels:labels,
        datasets:[{
            label:'Drawdown %',
            data:drawdownData,
            borderColor:'#ff7b72',
            borderWidth:2,
            fill:true,
            backgroundColor:'rgba(255,123,114,0.15)',
            tension:0.2,
            pointRadius:0
        }]
    },
    options:{
        responsive:true,
        interaction:{ mode:'index', intersect:false },
        scales:{
            x:{ ticks:{color:'#e6edf3'}, grid:{color:'#21262d'} },
            y:{ ticks:{color:'#e6edf3'}, grid:{color:'#21262d'} }
        },
        plugins:{
            legend:{ labels:{color:'#e6edf3'} }
        }
    }
});
</script>

</body>
</html>
