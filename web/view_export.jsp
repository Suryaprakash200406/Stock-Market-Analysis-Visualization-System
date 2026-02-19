<%@page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.project.model.ViewExportResult" %>
<%@ page import="java.util.*" %>

<%
    String symbol = (String) request.getAttribute("symbol");
    ViewExportResult result =
            (ViewExportResult) request.getAttribute("result");

    List<Map<String,String>> records =
            (result != null) ? result.getRecords() : new ArrayList<>();

    String range =
            (result != null && result.getRange()!=null)
            ? result.getRange()
            : "1M";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Historical Data - <%=symbol%></title>

<style>
body{
    font-family: Arial, sans-serif;
    background:#0d1117;
    color:#e6edf3;
    margin:0;
    padding:0;
}

/* SAME HEADER STYLE AS TRENDS */
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

/* FILTER BOX */
.filter-box{
    background:#161b22;
    padding:15px;
    border-radius:8px;
    border:1px solid #30363d;
    margin-bottom:20px;
}

input[type=date]{
    background:#0d1117;
    color:#e6edf3;
    border:1px solid #30363d;
    padding:6px;
    border-radius:6px;
}

button{
    padding:7px 14px;
    border-radius:6px;
    border:none;
    background:#238636;
    color:white;
    font-weight:600;
    cursor:pointer;
}

button:hover{ background:#2ea043; }

/* TABLE SAME AS TRENDS */
table{
    width:100%;
    border-collapse:collapse;
    margin-top:20px;
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

.info-box{
    margin-bottom:15px;
    color:#8b949e;
}
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
.header h2{ margin:0; color:#58a6ff; }
.home-link{
    padding:8px 16px;
    border-radius:6px;
    background:#238636;
    font-size:14px;
    text-decoration:none;
    color:white;
}
.home-link:hover{ background:#2ea043; }
.container{ max-width:1200px; margin:auto; padding:20px; }
.range-buttons{ margin:20px 0; }
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
.range-buttons a:hover{ background:#21262d; }
.range-buttons a.active{ background:#58a6ff; color:#0d1117; }
.filter-box{
    background:#161b22;
    padding:15px;
    border-radius:8px;
    border:1px solid #30363d;
    margin-bottom:20px;
}
input[type=date]{
    background:#0d1117;
    color:#e6edf3;
    border:1px solid #30363d;
    padding:6px;
    border-radius:6px;
}
button{
    padding:7px 14px;
    border-radius:6px;
    border:none;
    background:#238636;
    color:white;
    font-weight:600;
    cursor:pointer;
}
button:hover{ background:#2ea043; }
table{
    width:100%;
    border-collapse:collapse;
    margin-top:20px;
    background:#161b22;
    border:1px solid #30363d;
}
th, td{
    padding:10px;
    text-align:center;
    border-bottom:1px solid #30363d;
}
th{ background:#21262d; color:#58a6ff; }
tr:nth-child(even){ background:#1c2128; }
tr:hover{ background:#21262d; }
.info-box{ margin-bottom:15px; color:#8b949e; }
</style>
</head>

<body>

<!-- HEADER -->
<div class="header">
    <h2><%=symbol%> Historical Data</h2>
    <a href="companyDashboard.jsp?symbol=<%=symbol%>" class="home-link">
        Go Back
    </a>
</div>

<div class="container">

<div class="info-box">
View historical trading records.
Select a predefined range or custom dates to display data and download as CSV.
</div>

<!-- RANGE BUTTONS -->
<div class="range-buttons">
    <a href="view-export?symbol=<%=symbol%>&range=1M"
       class="<%="1M".equals(range)?"active":""%>">1M</a>

    <a href="view-export?symbol=<%=symbol%>&range=6M"
       class="<%="6M".equals(range)?"active":""%>">6M</a>

    <a href="view-export?symbol=<%=symbol%>&range=1Y"
       class="<%="1Y".equals(range)?"active":""%>">1Y</a>

    <a href="view-export?symbol=<%=symbol%>&range=5Y"
       class="<%="5Y".equals(range)?"active":""%>">5Y</a>

    <a href="view-export?symbol=<%=symbol%>&range=MAX"
       class="<%="MAX".equals(range)?"active":""%>">MAX</a>
</div>

<!-- FILTER + DOWNLOAD -->
<div class="filter-box">

<form method="get" action="view-export" style="display:inline;">
    <input type="hidden" name="symbol" value="<%=symbol%>">

    From:
    <input type="date" name="from"
           min="<%=result.getFirstDate()%>"
           max="<%=result.getLastDate()%>"
           value="<%=result.getFrom()!=null?result.getFrom():""%>">

    To:
    <input type="date" name="to"
           min="<%=result.getFirstDate()%>"
           max="<%=result.getLastDate()%>"
           value="<%=result.getTo()!=null?result.getTo():""%>">

    <button type="submit">Go</button>
</form>

<% if (!records.isEmpty()) { %>
<a href="view-export?symbol=<%=symbol%>&range=<%=range%>
<%= result.getFrom()!=null?"&from="+result.getFrom():"" %>
<%= result.getTo()!=null?"&to="+result.getTo():"" %>
&download=true">
    <button style="margin-left:50em;">Download CSV</button>
</a>
<% } %>

</div>

<!-- RECORD COUNT -->
<% if (!records.isEmpty()) { %>
<p style="color:#8b949e;">
Showing <b><%=records.size()%></b> records
</p>
<% } %>

<!-- TABLE -->
<% if (records.isEmpty()) { %>

<p>No records available for selected range.</p>

<% } else { %>

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
for (Map<String,String> row : records) {
%>
<tr>
    <td><%=row.get("date")%></td>
    <td><%=row.get("open")%></td>
    <td><%=row.get("high")%></td>
    <td><%=row.get("low")%></td>
    <td><%=row.get("close")%></td>
    <td><%=row.get("volume")%></td>
</tr>
<% } %>

</table>

<% } %>

</div>
</body>
</html>
