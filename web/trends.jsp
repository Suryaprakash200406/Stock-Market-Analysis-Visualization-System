<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>

<%
    String symbol = (String) request.getAttribute("symbol");
    List<String> dates = (List<String>) request.getAttribute("dates");
    List<Double> closePrices = (List<Double>) request.getAttribute("closePrices");
    List<Double> movingAvg = (List<Double>) request.getAttribute("movingAvg");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Trend Analysis - <%= symbol %></title>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body {
    background:#0d1117;
    color:#e6edf3;
    font-family:Segoe UI, Arial;
}
.container {
    width:90%;
    margin:40px auto;
}
h2 {
    color:#58a6ff;
}
canvas {
    background:#161b22;
    padding:20px;
    border-radius:12px;
}
</style>
</head>

<body>

<div class="container">
    <h2>Trend Analysis – <%= symbol %></h2>
    <canvas id="trendChart"></canvas>
</div>

<script>
const labels = <%= dates.toString() %>;
const closeData = <%= closePrices.toString() %>;
const maData = <%= movingAvg.toString() %>;

new Chart(document.getElementById('trendChart'), {
    type: 'line',
    data: {
        labels: labels,
        datasets: [
            {
                label: 'Close Price',
                data: closeData,
                borderWidth: 2,
                tension: 0.3
            },
            {
                label: '20-Day Moving Average',
                data: maData,
                borderDash: [5,5],
                borderWidth: 2,
                tension: 0.3
            }
        ]
    },
    options: {
        responsive: true,
        interaction: {
            mode: 'index',
            intersect: false
        },
        scales: {
            x: {
                ticks: {
                    maxTicksLimit: 15
                }
            }
        }
    }
});
</script>

</body>
</html>
