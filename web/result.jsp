<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<html>
<head>
    <title>Result</title>
</head>
<body>

<h2>Normalization Status</h2>

<%
java.util.Map errors =
        (java.util.Map) request.getAttribute("errors");
%>

<% if (errors == null || errors.isEmpty()) { %>
    <p style="color:green">
        Records updated successfully
    </p>
<% } else { %>
    <p style="color:red">Errors occurred:</p>
    <ul>
    <%
        java.util.Iterator it = errors.entrySet().iterator();
        while (it.hasNext()) {
            java.util.Map.Entry e =
                    (java.util.Map.Entry) it.next();
    %>
        <li><%= e.getKey() %> : <%= e.getValue() %></li>
    <%
        }
    %>
    </ul>
<% } %>

<a href="index.jsp">Go Back</a>

</body>
</html>
