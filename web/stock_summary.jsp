<%@page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.project.model.StockSummaryResult" %>

<%
    String symbol = (String) request.getAttribute("symbol");
    StockSummaryResult result =
            (StockSummaryResult) request.getAttribute("summary");

    if(symbol == null) symbol = "N/A";
    if(result == null) return;

    int overallScore = result.overallScore;

    String overallColor = overallScore >= 75 ? "#3fb950" :
                          overallScore >= 50 ? "#facc15" :
                          "#ff7b72";

    // ================= RANKING STRUCTURE =================

    class Section {
        String name;
        int score;
        String link;

        Section(String name, int score, String link) {
            this.name = name;
            this.score = score;
            this.link = link;
        }
    }

    List<Section> sections = new ArrayList<>();

    sections.add(new Section("Trend", result.trendScore,
            "trends?symbol="+symbol+"&range=1Y"));

    sections.add(new Section("Momentum", result.momentumScore,
            "momentum?symbol="+symbol));

    sections.add(new Section("Volume", result.volumeScore,
            "volume?symbol="+symbol));

    sections.add(new Section("Risk", result.riskScore,
            "risk?symbol="+symbol));

    sections.sort((a,b) -> Integer.compare(b.score, a.score));
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%=symbol%> Stock Summary</title>

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
    font-size:22px;
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

/* CONTAINER */
.container{
    width:72%;
    margin:40px auto;
}

/* OVERALL SECTION */
.overall-section{
    display:flex;
    justify-content:space-between;
    align-items:center;
    padding:30px;
    background:linear-gradient(90deg,#161b22,#1c2128);
    border:1px solid #30363d;
    border-radius:12px;
    margin-bottom:40px;
}

.overall-text{
    flex:1;
}

.overall-text h3{
    margin:0 0 10px 0;
    font-size:22px;
}

.overall-text p{
    color:#8b949e;
    font-size:15px;
    line-height:1.6;
}

.summary-highlight{
    margin-top:15px;
    padding:12px 16px;
    background:#1c2128;
    border-left:4px solid #58a6ff;
    font-size:14px;
    color:#c9d1d9;
}

.overall-score{
    font-size:42px;
    font-weight:bold;
}

/* CARDS */
.summary-card{
    position:relative;
    display:flex;
    justify-content:space-between;
    background:#161b22;
    padding:35px;
    border-radius:14px;
    border:1px solid #30363d;
    margin-bottom:35px;
    transition:0.3s ease;
}

.summary-card:hover{
    box-shadow:0 8px 25px rgba(0,0,0,0.5);
    transform:translateY(-3px);
}

.position-badge{
    position:absolute;
    top:27px;
    left:20px;
    width:42px;
    height:42px;
    border-radius:50%;
    display:flex;
    align-items:center;
    justify-content:center;
    font-weight:bold;
    font-size:16px;
    color:#0d1117;
}

.card-left{
    flex:1;
    margin-left:50px;
}

.card-left h3{
    margin:0 0 18px 0;
    font-size:24px;
    font-weight:600;
}

.highlight{
    font-size:20px;
    font-weight:600;
    margin-bottom:8px;
}

.static-desc{
    margin-top:12px;
    font-size:14px;
    color:#8b949e;
    line-height:1.6;
}

.card-right{
    display:flex;
    flex-direction:column;
    align-items:flex-end;
    justify-content:center;
    min-width:130px;
}

.card-score{
    font-size:24px;
    font-weight:bold;
    opacity:0.85;
}

.score-note{
    font-size:12px;
    color:#8b949e;
}

.detail-btn{
    margin-top:18px;
    display:inline-block;
    padding:9px 18px;
    border-radius:6px;
    font-size:14px;
    text-decoration:none;
    font-weight:600;
}

/* ===== RANK BASED COLORS ===== */

.rank-1-title{ color:#3fb950; }
.rank-1-badge{ background:#3fb950; }
.rank-1-btn{ background:#238636; color:white; }
.rank-1-btn:hover{ background:#2ea043; }

.rank-2-title{ color:#58a6ff; }
.rank-2-badge{ background:#58a6ff; }
.rank-2-btn{ background:#1f6feb; color:white; }
.rank-2-btn:hover{ background:#388bfd; }

.rank-3-title{ color:#d2a8ff; }
.rank-3-badge{ background:#d2a8ff; }
.rank-3-btn{ background:#8957e5; color:white; }
.rank-3-btn:hover{ background:#a371f7; }

.rank-4-title{ color:#ff7b72; }
.rank-4-badge{ background:#ff7b72; }
.rank-4-btn{ background:#da3633; color:white; }
.rank-4-btn:hover{ background:#f85149; }

</style>
</head>

<body>

<div class="header">
    <h2><%=symbol%> Stock Summary</h2>
    <a href="companyDashboard.jsp?symbol=<%=symbol%>" class="home-link">Go Back</a>
</div>

<div class="container">

<!-- OVERALL SECTION -->
<div class="overall-section">

    <div class="overall-text">
        <h3>Overall Technical Summary</h3>

        <p>
            This page provides a ranked technical overview of the stock
            using Trend, Momentum, Volume and Risk analysis.
        </p>

        <div class="summary-highlight">
            Sections are automatically ranked based on their technical score.
            Rank 1 represents the strongest performing indicator,
            while Rank 4 indicates comparatively weaker technical strength.
        </div>

        <p style="margin-top:15px;">
            The overall score is calculated from all section scores
            and represents a combined technical outlook only.
        </p>
    </div>

    <div class="overall-score" style="color:<%=overallColor%>;">
        <%=overallScore%> / 100
    </div>

</div>

<!-- DYNAMIC RANKED CARDS -->
<%
int rank = 1;
for(Section s : sections){

    String titleClass = "rank-" + rank + "-title";
    String badgeClass = "rank-" + rank + "-badge";
    String btnClass   = "rank-" + rank + "-btn";
%>

<div class="summary-card">

    <div class="position-badge <%=badgeClass%>"><%=rank%></div>

    <div class="card-left">
        <h3 class="<%=titleClass%>"><%=s.name%></h3>

        <% if(s.name.equals("Trend")) { %>
            <div class="highlight">Latest Close: ₹ <%=String.format("%.2f", result.latestClose)%></div>
            <div class="highlight">20 Day MA: ₹ <%=String.format("%.2f", result.latestMA)%></div>
            <div class="static-desc">
                Trend analysis evaluates long-term direction using moving averages.
            </div>
        <% } %>

        <% if(s.name.equals("Momentum")) { %>
            <div class="highlight">14 Day RSI: <%=String.format("%.2f", result.rsi)%></div>
            <div class="static-desc">
                Momentum measures strength and speed of price movement.
            </div>
        <% } %>

        <% if(s.name.equals("Volume")) { %>
            <div class="highlight">Latest Volume: <%=String.format("%,.0f", result.latestVolume)%></div>
            <div class="highlight">Volume Change: <%=String.format("%.2f", result.volumeChangePercent)%>%</div>
            <div class="static-desc">
                Volume analysis identifies accumulation or distribution.
            </div>
        <% } %>

        <% if(s.name.equals("Risk")) { %>
            <div class="highlight">Volatility: <%=String.format("%.2f", result.volatility)%>%</div>
            <div class="static-desc">
                Risk analysis evaluates volatility and downside exposure.
            </div>
        <% } %>

        <a href="<%=s.link%>" target="blank" class="detail-btn <%=btnClass%>">
            View Detailed <%=s.name%> →
        </a>
    </div>

    <div class="card-right">
        <div class="card-score"><%=s.score%> / 100</div>
        <div class="score-note">Technical Score</div>
    </div>

</div>

<%
rank++;
}
%>

</div>
</body>
</html>
