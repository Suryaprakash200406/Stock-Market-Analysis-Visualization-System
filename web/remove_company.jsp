<%@page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.*, java.io.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Remove Company</title>

    <style>
        body {
            background:#0f172a;
            color:#e2e8f0;
            font-family:Segoe UI, Arial;
            margin:0;
        }

        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 40px;
            background-color: #1c2431;
            border-bottom: 1px solid #30363d;
        }

        .dashboard-title {
            font-size: 22px;
            font-weight: bold;
            color: #58a6ff;
        }

        .back-link {
            padding: 8px 16px;
            border-radius: 8px;
            background-color: #238636;
            font-size: 14px;
            text-decoration: none;
            color: white;
        }
        .back-link:hover { background-color: #2ea043; }

        .container {
            width:60%;
            margin:40px auto;
            background:#1e293b;
            padding:30px;
            border-radius:10px;
            box-shadow:0 0 15px rgba(0,0,0,0.6);
        }

        h2 {
            margin-bottom:25px;
            color:#38bdf8;
        }

        label {
            display:block;
            margin-top:15px;
            margin-bottom:6px;
            font-weight:600;
        }

        select {
            width:100%;
            padding:10px;
            border:none;
            border-radius:6px;
            background:#0f172a;
            color:white;
        }

        .btn {
            margin-top:25px;
            padding:12px 28px;
            background:#ef4444;
            border:none;
            border-radius:6px;
            color:white;
            font-weight:bold;
            cursor:pointer;
        }

        .btn:hover {
            background:#dc2626;
        }

        .success {
            color:#4ade80;
            margin-bottom:15px;
        }

        .error {
            color:#f87171;
            margin-bottom:15px;
        }

    </style>

</head>
<body>

<div class="dashboard-header">
    <div class="dashboard-title">
        Stock Insight - Remove Company
    </div>

    <a href="index.jsp" class="back-link">Go Back</a>
</div>    

<div class="container">

    <h2>Remove Company</h2>

    <% if(request.getAttribute("message") != null){ %>
        <div class="<%=request.getAttribute("messageType")%>">
            <%=request.getAttribute("message")%>
        </div>
    <% } %>

    <form action="removeCompany" method="post">
        <label>Select Symbol</label>
        <select name="symbol" id="symbolSelect" required>
            <option value="">--Select Symbol--</option>
            <%
                // Populate from company_info.csv
                String basePath = "C:\\Users\\ELCOT\\Documents\\NetBeansProjects\\MyFirstServletProject\\data";
                File infoFile = new File(basePath, "company_info.csv");
                Map<String,String> symbolNameMap = new LinkedHashMap<>();
                if(infoFile.exists()){
                    try(BufferedReader br = new BufferedReader(new FileReader(infoFile))){
                        String line;
                        while((line = br.readLine()) != null){
                            String[] arr = line.split(",",4);
                            if(arr.length>=2){
                                symbolNameMap.put(arr[0].trim(), arr[1].trim());
                            }
                        }
                    }
                }

                for(Map.Entry<String,String> entry: symbolNameMap.entrySet()){
            %>
                <option value="<%=entry.getKey()%>"><%=entry.getKey()%></option>
            <% } %>
        </select>

        <label>Select Company Name</label>
        <select name="name" id="nameSelect" required>
            <option value="">--Select Company--</option>
            <% for(Map.Entry<String,String> entry: symbolNameMap.entrySet()){ %>
                <option value="<%=entry.getKey()%>"><%=entry.getValue()%></option>
            <% } %>
        </select>

        <button type="submit" class="btn">Remove Company</button>
    </form>

</div>

<script>
    const symbolSelect = document.getElementById('symbolSelect');
    const nameSelect = document.getElementById('nameSelect');

    symbolSelect.addEventListener('change', ()=>{
        nameSelect.value = symbolSelect.value;
    });

    nameSelect.addEventListener('change', ()=>{
        symbolSelect.value = nameSelect.value;
    });
</script>

</body>
</html>