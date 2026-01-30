<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.*" %>
<html>
<head>
    <title>Retrieved Data</title>
    <style>
        table{
            border:5px solid brown;
            position:absolute;
            left:30em;
            top:10em;
        }
       
    </style>
</head>
<body>

<h2>Student Details</h2>

<table border="1" cellpadding="10">
    <tr>
        <th>Reg No</th>
        <th>Name</th>
        <th>Department</th>
        <th>College</th>
    </tr>

<%
    ArrayList<String[]> list = (ArrayList<String[]>) request.getAttribute("data");

    if (list != null) {
        for (String row[] : list) {
%>
    <tr>
        <td><%= row[0] %></td>
        <td><%= row[1] %></td>
        <td><%= row[2] %></td>
        <td><%= row[3] %></td>
    </tr>
<%
        }
    }
%>

</table>

</body>
</html>

