<%@ page import="java.util.*, com.project.util.CompanyRegistry" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Stock Insight Portal</title>

<style>
/* ---------- GLOBAL ---------- */
body {
    margin: 0;
    font-family: 'Segoe UI', Arial, sans-serif;
    background-color: #0d1117;
    color: #e6edf3;
}

a { text-decoration: none; color: inherit; }

/* ---------- NAVBAR ---------- */
.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px 40px;
    background-color: #161b22;
    box-shadow: 0 2px 10px rgba(0,0,0,0.5);
}

.logo { font-size: 22px; font-weight: bold; color: #58a6ff; }

.nav-links a {
    margin-left: 16px;
    padding: 8px 14px;
    color: #c9d1d9;
    font-size: 14px;
    border-radius: 8px;
    transition: background-color 0.15s ease, color 0.15s ease;
}

.nav-links a:hover { background-color: #58a6ff; color:white; }

/* ---------- HERO ---------- */
.hero {
    padding: 70px 40px;
    text-align: center;
    background: linear-gradient(135deg, #0d1117, #161b22);
}

.hero h1 { font-size: 36px; margin-bottom: 10px; }
.hero p { font-size: 16px; color: #8b949e; max-width: 700px; margin: auto; }

/* ---------- MAIN SECTIONS ---------- */
.container { padding: 50px 40px; }
.section-title { font-size: 24px; margin-bottom: 25px; color: #58a6ff; }
.card-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
    gap: 25px;
}
.card {
    background-color: #161b22;
    border-radius: 14px;
    padding: 25px;
    box-shadow: 0 6px 20px rgba(0,0,0,0.4);
    transition: transform 0.3s;
}
.card:hover { transform: translateY(-6px); }
.card h3 { margin-top: 0; margin-bottom: 15px; color: #e6edf3; }
.card p { color: #8b949e; font-size: 14px; line-height: 1.4; }

/* ---------- BUTTON ---------- */
.btn {
    display: inline-block;
    padding: 10px 18px;
    background-color: #238636;
    color: #ffffff;
    border-radius: 8px;
    font-size: 14px;
    border: none;
    cursor: pointer;
}
.btn:hover { background-color: #2ea043; }

/* ---------- SELECT ---------- */
select {
    width: 100%;
    padding: 10px;
    margin-bottom: 15px;
    background-color: #0d1117;
    color: #e6edf3;
    border: 1px solid #30363d;
    border-radius: 6px;
}

/* ---------- FOOTER ---------- */
.footer {
    background-color: #161b22;
    padding: 20px;
    text-align: center;
    color: #8b949e;
    font-size: 13px;
}
</style>

<script>
function enableViewButton() {
    const select = document.getElementById("companySelect");
    document.getElementById("viewBtn").disabled = (select.value === "");
}

function goToCompanyPage() {
    const company = document.getElementById("companySelect").value;
    if (company !== "") {
        window.location.href = "companyDashboard.jsp?symbol=" + company;
    }
}

function enableSectorButton() {
    const select = document.getElementById("sectorSelect");
    document.getElementById("sectorBtn").disabled = (select.value === "");
}

function goToSectorPage() {
    const sector = document.getElementById("sectorSelect").value;
    if (sector !== "") {
        window.location.href = "sectorDashboard.jsp?sector=" + sector;
    }
}
</script>

</head>
<body>

<!-- NAVBAR -->
<div class="navbar">
    <div class="logo">Stock Insight</div>
    <div class="nav-links">
        <a href="sample.jsp">Home</a>
        <a href="admin_login.jsp">Admin Login</a>
    </div>
</div>

<!-- HERO -->
<div class="hero">
    <h1>Smart Stock Analysis Made Simple</h1>
    <p>A beginner-friendly stock analytics platform with clean dashboards, trend insights, and risk analysis.</p>
</div>

<!-- USER SECTION -->
<div class="container">
    <div class="section-title">User Section</div>

    <div class="card-grid">
        <!-- SELECT COMPANY -->
        <%
            List<CompanyRegistry.CompanyInfo> companies =
                    CompanyRegistry.getAllCompanies();

            // Sort alphabetically by company name (case-insensitive)
            companies.sort(Comparator.comparing(
                    c -> c.name.toLowerCase()
            ));
        %>

        <div class="card">
            <h3>Select Company</h3>

            <select id="companySelect" onchange="enableViewButton()">
                <option value="">-- Choose Company --</option>

                <% for (CompanyRegistry.CompanyInfo c : companies) { %>
                    <option value="<%= c.symbol %>">
                        <%= c.name %>
                    </option>
                <% } %>

            </select>

            <button id="viewBtn"
                    class="btn"
                    disabled
                    onclick="goToCompanyPage()">
                View Details
            </button>
        </div>
        <!-- Sector wise analysis -->
        <div class="card">
            <h3>Select Sector</h3>

            <select id="sectorSelect" onchange="enableSectorButton()">
                <option value="">-- Choose Sector --</option>
                <option value="Auto">Auto</option>  
                <option value="Banking">Banking</option>
                <option value="Cement">Cement</option>
                <option value="Chemicals">Chemicals</option>
                <option value="Electronics">Electronics</option>
                <option value="Energy">Energy</option>
                <option value="FMGC">FMGC</option>
                <option value="Infrastructure">Infrastructure</option>
                <option value="Insurance">Insurance</option>
                <option value="IT">IT</option>
                <option value="Metals">Metals</option>
                <option value="Pharma">Pharma</option>
                <option value="Power">Power</option>
                <option value="Telecom">Telecom</option>
                <option value="Others">Others</option>
            </select>

            <button id="sectorBtn"
                    class="btn"
                    disabled
                    onclick="goToSectorPage()">
                Explore Sectors
            </button>
        </div>
    </div>
</div>

<div class="footer">
    © 2026 Stock Insight Project | Educational Use Only
</div>

</body>
</html>
