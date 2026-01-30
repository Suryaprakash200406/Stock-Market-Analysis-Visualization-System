<%@ page import="java.util.ArrayList, java.util.LinkedHashMap" %>
<!DOCTYPE html>
<html>
<head>
    <title>Latest Stock Data</title>
    <style>
        table {
            border-collapse: collapse;
            width: 95%;
            margin: 20px auto;
            overflow-x: auto;
            display: block;
        }
        th, td {
            border: 1px solid #333;
            padding: 8px 10px;
            text-align: center;
            max-width: 250px;
            word-wrap: break-word;
        }
        th {
            background-color: #f2f2f2;
        }
        h2 {
            text-align: center;
        }
        tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .error {
            text-align: center;
            color: red;
            font-weight: bold;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<%
    ArrayList<LinkedHashMap<String, String>> dataList =
        (ArrayList<LinkedHashMap<String, String>>) request.getAttribute("dataList");

    String symbol = (String) request.getAttribute("symbol");
    String errorMsg = (String) request.getAttribute("errorMsg");
%>

<h2>Latest Stock Data - <%= symbol %></h2>

<%
if (errorMsg != null) {
%>
    <div class="error"><%= errorMsg %></div>
<%
}
%>

<%
if (dataList != null && !dataList.isEmpty()) {
%>

<table>
    <!-- TABLE HEADER -->
    <tr>
        <%
            LinkedHashMap<String, String> firstRow = dataList.get(0);
            for (String column : firstRow.keySet()) {
        %>
            <th><%= column %></th>
        <%
            }
        %>
    </tr>

    <!-- TABLE BODY -->
    <%
        for (LinkedHashMap<String, String> row : dataList) {
    %>
        <tr>
            <%
                for (String value : row.values()) {
                    // truncate very long JSON strings for nested objects
                    String displayValue = value != null ? value : "-";
                    if (displayValue.length() > 100) {
                        displayValue = displayValue.substring(0, 100) + "...";
                    }
            %>
                <td><%= displayValue %></td>
            <%
                }
            %>
        </tr>
    <%
        }
    %>
</table>

<%
} else if (errorMsg == null) {
%>
    <p style="text-align:center;">No stock data available.</p>
<%
}
%>

</body>
</html>
