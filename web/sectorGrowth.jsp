<%@page contentType="text/html;charset=UTF-8"%>

<%
String sector = (String) request.getAttribute("sector");
String selectedRange = (String) request.getAttribute("selectedRange");

Double avg1M = (Double) request.getAttribute("avg1M");
Double avg6M = (Double) request.getAttribute("avg6M");
Double avg1Y = (Double) request.getAttribute("avg1Y");
Double avg5Y = (Double) request.getAttribute("avg5Y");

String bestStock = (String) request.getAttribute("bestStock");
Double bestReturn = (Double) request.getAttribute("bestReturn");

String worstStock = (String) request.getAttribute("worstStock");
Double worstReturn = (Double) request.getAttribute("worstReturn");

Double positivePercent = (Double) request.getAttribute("positivePercent");
Double negativePercent = (Double) request.getAttribute("negativePercent");

Integer totalCompanies = (Integer) request.getAttribute("totalCompanies");
Integer positiveCount = (Integer) request.getAttribute("positiveCount");
Integer negativeCount = (Integer) request.getAttribute("negativeCount");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sector Growth - <%=sector%></title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body{
    font-family: Arial, sans-serif;
    background:#0d1117;
    color:#e6edf3;
    margin:0;
    padding:0;
}

/* HEADER (Same style as trends.jsp) */
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
    padding:20px;
}

/* RANGE BUTTONS (Left aligned like trends.jsp) */
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
    padding:15px;
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
    margin-top:5px;
}

/* CHART BOX */
.chart-container{
    background:#161b22;
    padding:20px;
    border-radius:8px;
    border:1px solid #30363d;
    margin-top:30px;
}

.stats-box{
    position:absolute;
        right:30px;
        bottom:20px;
        text-align:left;
        font-size:14px;
        line-height:1.8;
        background:#0d1117;
        padding:20px;
        border-radius:8px;
        border:3px solid #30363d;
        min-width:220px;
}

canvas{
    max-height:400px;
}
</style>
</head>

<body>

<div class="header">
    <h2><%=sector%> Sector Growth</h2>
    <a href="sectorDashboard.jsp?sector=<%=sector%>" class="home-link">Go Back</a>
</div>

<div class="container">

<!-- RANGE SELECTOR -->
<div class="range-buttons">
    <a href="?sector=<%=sector%>&range=1M" class="<%= "1M".equals(selectedRange)?"active":"" %>">1M</a>
    <a href="?sector=<%=sector%>&range=6M" class="<%= "6M".equals(selectedRange)?"active":"" %>">6M</a>
    <a href="?sector=<%=sector%>&range=1Y" class="<%= "1Y".equals(selectedRange)?"active":"" %>">1Y</a>
    <a href="?sector=<%=sector%>&range=5Y" class="<%= "5Y".equals(selectedRange)?"active":"" %>">5Y</a>
</div>

<!-- STATIC SUMMARY CARDS -->
<div class="summary">
    <div class="card">
        <h4>1M</h4>
        <p><%=avg1M==null?"N/A":String.format("%.2f%%",avg1M)%></p>
    </div>
    <div class="card">
        <h4>6M</h4>
        <p><%=avg6M==null?"N/A":String.format("%.2f%%",avg6M)%></p>
    </div>
    <div class="card">
        <h4>1Y</h4>
        <p><%=avg1Y==null?"N/A":String.format("%.2f%%",avg1Y)%></p>
    </div>
    <div class="card">
        <h4>5Y</h4>
        <p><%=avg5Y==null?"N/A":String.format("%.2f%%",avg5Y)%></p>
    </div>
</div>

<!-- BEST & WORST -->
<div class="summary">
    <div class="card">
        <h4>Best Performer (<%=selectedRange%>)</h4>
        <p>
            <%=bestStock==null?"N/A":
            bestStock+" ("+String.format("%.2f%%",bestReturn)+")"%>
        </p>
    </div>

    <div class="card">
        <h4>Worst Performer (<%=selectedRange%>)</h4>
        <p>
            <%=worstStock==null?"N/A":
            worstStock+" ("+String.format("%.2f%%",worstReturn)+")"%>
        </p>
    </div>
</div>

<!-- BAR CHART -->
<div class="chart-container">
    <canvas id="sectorChart"></canvas>
</div>

<!-- DOUGHNUT DESCRIPTION -->
<div class="chart-container" style="position:relative;">

    <p style="text-align:center;color:#8b949e;margin-bottom:20px;">
        This chart represents sector breadth — the percentage of companies 
        delivering positive vs negative returns for the selected time range.
    </p>

    <div style="width:55%; margin:auto;">
        <canvas id="distributionChart"></canvas>
    </div>

    <!-- NEW INFO (Right Bottom Side) -->
    <div class="stats-box">   
        <div >Total Companies: <b><%=totalCompanies==null?"0":totalCompanies%></b></div>
        <div style="color:#55e683;">Positive Returns: <b><%=positiveCount==null?"0":positiveCount%></b></div>
        <div style="color:#ff7b72;">Negative Returns: <b><%=negativeCount==null?"0":negativeCount%></b></div>
    </div>

</div>

<script>
// BAR CHART
new Chart(document.getElementById('sectorChart'), {
    type:'bar',
    data:{
        labels:['1M','6M','1Y','5Y'],
        datasets:[{
            label:'Average Growth (%)',
            data:[
                <%=avg1M==null?"null":avg1M%>,
                <%=avg6M==null?"null":avg6M%>,
                <%=avg1Y==null?"null":avg1Y%>,
                <%=avg5Y==null?"null":avg5Y%>
            ],
            backgroundColor:[
                '#58a6ff',
                '#55e683',
                '#ffb86c',
                '#ff7b72'
            ],
            borderWidth:0
        }]
    },
    options:{
        plugins:{
            legend:{ display:false }   // removes color legend box
        },
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

// DOUGHNUT CHART (Reduced Size)
    new Chart(document.getElementById('distributionChart'),{
    type:'doughnut',
        data:{
            labels:['Positive','Negative'],
            datasets:[{
                data:[
                    <%=positivePercent==null?0:positivePercent%>,
                    <%=negativePercent==null?0:negativePercent%>
                ],
                backgroundColor:['#55e683','#ff7b72']
            }]
        },
        options:{
            cutout:'55%',
            radius:'95%',
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