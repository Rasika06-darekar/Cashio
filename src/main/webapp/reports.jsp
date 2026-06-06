<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Financial Reports</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>

* { box-sizing: border-box; margin: 0; padding: 0; font-family: Segoe UI, sans-serif; }

body {
    background: #f4f7fc;
    display: flex;
    min-height: 100vh;
}

/* ── Sidebar ── */
.sidebar{
    width:240px; min-height:100vh;
    background:#0B1F3A;
    padding:28px 16px;
    position:fixed; left:0; top:0;
    display:flex; flex-direction:column;
    gap:4px;
}
.sidebar-logo{
    display:flex; align-items:center;
    gap:10px; padding:0 8px;
    margin-bottom:32px;
}
.sidebar-logo span{
    font-size:22px; font-weight:800;
    color:white; letter-spacing:-.5px;
}
.sidebar-logo span b{ color:#4ade80; }
.nav-item{
    display:flex; align-items:center;
    gap:12px; padding:12px 14px;
    border-radius:12px; color:#9fb3c8;
    text-decoration:none; font-size:14px;
    font-weight:500; transition:all 0.2s;
}
.nav-item:hover{
    background:#1F3B5C; color:white;
}
.nav-item.active{
    background:#1F3B5C; color:white;
    font-weight:600;
}
.nav-item .nav-icon{
    width:36px; height:36px;
    border-radius:10px;
    display:flex; align-items:center;
    justify-content:center; font-size:17px;
    background:#ffffff10;
}
.nav-item.active .nav-icon{ background:#ffffff20; }

/* ── Main ── */
.main{
    margin-left:240px; flex:1;
    padding:35px 40px;
}

.page-header {
    margin-bottom:30px;
    padding-bottom:15px;
    border-bottom:2px solid #e2e8f0;
    display:flex;
    justify-content:space-between;
    align-items:center;
}

.page-header h1 {
    color: #0B1F3A;
    font-size: 26px;
    font-weight: 700;
}

.download-btn {
    display: inline-block;
    background: #0B1F3A;
    color: white;
    padding: 11px 20px;
    border-radius: 10px;
    text-decoration: none;
    font-weight: 600;
    transition: background 0.2s;
    font-size: 14px;
}

.download-btn:hover {
    background: #1F3B5C;
}

/* ── Filter Section ── */
.filter-section {
    background: white;
    padding: 20px;
    border-radius: 16px;
    box-shadow: 0 2px 12px rgba(0,0,0,0.07);
    border: 1px solid #e2e8f0;
    margin-bottom: 25px;
}

.filter-title {
    color: #0B1F3A;
    font-size: 14px;
    font-weight: 600;
    margin-bottom: 15px;
}

.radio-group {
    display: flex;
    gap: 20px;
    flex-wrap: wrap;
    margin-bottom: 15px;
}

.radio-item {
    display: flex;
    align-items: center;
    gap: 8px;
}

.radio-item input[type="radio"] {
    cursor: pointer;
    width: 18px;
    height: 18px;
    accent-color: #0B1F3A;
}

.radio-item label {
    cursor: pointer;
    font-size: 14px;
    font-weight: 500;
    color: #334155;
}

.date-inputs {
    display: flex;
    gap: 15px;
    flex-wrap: wrap;
    align-items: center;
}

.date-inputs label {
    font-size: 13px;
    font-weight: 600;
    color: #64748b;
}

.date-inputs input {
    padding: 10px 12px;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    font-size: 13px;
    outline: none;
}

.date-inputs input:focus {
    border-color: #0B1F3A;
}

.apply-btn {
    background: #0B1F3A;
    color: white;
    border: none;
    padding: 10px 18px;
    border-radius: 8px;
    cursor: pointer;
    font-size: 13px;
    font-weight: 600;
    transition: background 0.2s;
}

.apply-btn:hover {
    background: #1F3B5C;
}

.cards {
    display: flex;
    gap: 20px;
    flex-wrap: wrap;
    margin-bottom: 30px;
}

.card {
    flex: 1;
    min-width: 250px;
    background: white;
    padding: 25px;
    border-radius: 16px;
    box-shadow: 0 2px 12px rgba(0,0,0,0.07);
    border-left: 6px solid;
    border: 1px solid #e2e8f0;
    border-left: 6px solid;
}

.card.income { 
    border-left-color: #16a34a;
}
.card.expense { 
    border-left-color: #dc2626;
}
.card.savings { 
    border-left-color: #2563eb;
}

.card h3 {
    color: #64748b;
    font-size: 12px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 8px;
}

.amount {
    font-size: 26px;
    font-weight: 700;
    color: #0B1F3A;
    margin-top: 8px;
}

.card.income .amount { color: #16a34a; }
.card.expense .amount { color: #dc2626; }
.card.savings .amount { color: #2563eb; }

.chart-card {
    background: white;
    margin-bottom: 30px;
    padding: 30px;
    border-radius: 16px;
    box-shadow: 0 2px 12px rgba(0,0,0,0.07);
    border: 1px solid #e2e8f0;
}

.chart-card h2 {
    color: #0B1F3A;
    margin-bottom: 25px;
    font-size: 17px;
    font-weight: 700;
}

.chart-wrapper {
    width: 350px;
    height: 350px;
    margin: auto;
}

.line-chart-wrapper {
    position: relative;
    height: 400px;
    margin-top: 20px;
}

</style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <div class="sidebar-logo">
        <span>Cash<b>io</b></span>
    </div>
    <a href="dashboard" class="nav-item">
        <div class="nav-icon">🏠</div> Dashboard
    </a>
    <a href="income.jsp" class="nav-item">
        <div class="nav-icon">💵</div> Add Income
    </a>
    <a href="add-expense.jsp" class="nav-item">
        <div class="nav-icon">💸</div> Add Expense
    </a>
    <a href="incomeHistory" class="nav-item">
        <div class="nav-icon">📜</div> Income History
    </a>
    <a href="expenseHistory" class="nav-item">
        <div class="nav-icon">🧾</div> Expense History
    </a>
    <a href="reports" class="nav-item active">
        <div class="nav-icon">📊</div> Reports
    </a>
    <a href="settings.jsp" class="nav-item">
        <div class="nav-icon">⚙️</div> Settings
    </a>
    <a href="logout" class="nav-item" style="margin-top:auto;">
        <div class="nav-icon">🚪</div> Logout
    </a>
</div>

<!-- Main Content -->
<div class="main">
    <div class="page-header">
        <h1>Financial Reports</h1>
        <a href="downloadReport" class="download-btn">
            📄 Download PDF
        </a>
    </div>

    <!-- Filter Section -->
    <div class="filter-section">
        <div class="filter-title">📅 Select Report Period</div>
        
        <form id="reportForm" method="get" action="reports">
            <div class="radio-group">
                <div class="radio-item">
                    <input type="radio" id="weekly" name="period" value="weekly" 
                        <%= "weekly".equals(request.getParameter("period")) ? "checked" : "" %>
                        onchange="updateDateInputs()">
                    <label for="weekly">Weekly</label>
                </div>
                <div class="radio-item">
                    <input type="radio" id="monthly" name="period" value="monthly" 
                        <%= "monthly".equals(request.getParameter("period")) || request.getParameter("period") == null ? "checked" : "" %>
                        onchange="updateDateInputs()">
                    <label for="monthly">Monthly</label>
                </div>
                <div class="radio-item">
                    <input type="radio" id="annually" name="period" value="annually" 
                        <%= "annually".equals(request.getParameter("period")) ? "checked" : "" %>
                        onchange="updateDateInputs()">
                    <label for="annually">Annually</label>
                </div>
                <div class="radio-item">
                    <input type="radio" id="custom" name="period" value="custom" 
                        <%= "custom".equals(request.getParameter("period")) ? "checked" : "" %>
                        onchange="updateDateInputs()">
                    <label for="custom">Custom Range</label>
                </div>
            </div>

            <div class="date-inputs">
                <label for="startDate">From:</label>
                <input type="date" id="startDate" name="startDate" 
                    value="<%= request.getParameter("startDate") != null ? request.getParameter("startDate") : "" %>">
                <label for="endDate">To:</label>
                <input type="date" id="endDate" name="endDate" 
                    value="<%= request.getParameter("endDate") != null ? request.getParameter("endDate") : "" %>">
                <button type="submit" class="apply-btn">Apply Filter</button>
            </div>
        </form>
    </div>

    <!-- Summary Cards -->
    <div class="cards">
        <div class="card income">
            <h3>Total Income</h3>
            <div class="amount">
                Rs. <%= request.getAttribute("totalIncome") != null ? 
                    String.format("%.2f", Double.parseDouble(request.getAttribute("totalIncome").toString())) : "0.00" %>
            </div>
        </div>
        <div class="card expense">
            <h3>Total Expense</h3>
            <div class="amount">
                Rs. <%= request.getAttribute("totalExpense") != null ? 
                    String.format("%.2f", Double.parseDouble(request.getAttribute("totalExpense").toString())) : "0.00" %>
            </div>
        </div>
        <div class="card savings">
            <h3>Net Savings</h3>
            <div class="amount">
                Rs. <%= request.getAttribute("savings") != null ? 
                    String.format("%.2f", Double.parseDouble(request.getAttribute("savings").toString())) : "0.00" %>
            </div>
        </div>
    </div>

    <!-- Pie Chart -->
    <div class="chart-card">
        <h2>Income vs Expense Distribution</h2>
        <div class="chart-wrapper">
            <canvas id="pieChart"></canvas>
        </div>
    </div>

    <!-- Line Chart -->
    <div class="chart-card">
        <h2>Daily Trend</h2>
        <div class="line-chart-wrapper">
            <canvas id="lineChart"></canvas>
        </div>
    </div>
</div>

<script>

function updateDateInputs() {
    const period = document.querySelector('input[name="period"]:checked').value;
    const startDateInput = document.getElementById('startDate');
    const endDateInput = document.getElementById('endDate');
    const today = new Date();
    let start, end;

    console.log("Period selected: " + period);

    if (period === 'weekly') {
        end = new Date(today);
        start = new Date(today);
        start.setDate(today.getDate() - today.getDay());
        console.log("Weekly: " + start.toISOString().split('T')[0] + " to " + end.toISOString().split('T')[0]);
    } 
    else if (period === 'monthly') {
        start = new Date(today.getFullYear(), today.getMonth(), 1);
        end = new Date(today.getFullYear(), today.getMonth() + 1, 0);
        console.log("Monthly: " + start.toISOString().split('T')[0] + " to " + end.toISOString().split('T')[0]);
    } 
    else if (period === 'annually') {
        start = new Date(today.getFullYear(), 0, 1);
        end = new Date(today.getFullYear(), 11, 31);
        console.log("Annually: " + start.toISOString().split('T')[0] + " to " + end.toISOString().split('T')[0]);
    } 
    else if (period === 'custom') {
        console.log("Custom range selected");
        return; // Don't auto-fill for custom
    }
    
    // Set date values only if not custom
    if (period !== 'custom') {
        startDateInput.value = start.toISOString().split('T')[0];
        endDateInput.value = end.toISOString().split('T')[0];
    }
}

// Initialize on page load
window.addEventListener('load', function() {
    console.log("Page loaded");
    const currentPeriod = document.querySelector('input[name="period"]:checked').value;
    console.log("Current period: " + currentPeriod);
    
    // Only update dates if we have predefined periods (not custom)
    if (currentPeriod !== 'custom' && document.getElementById('startDate').value === '') {
        updateDateInputs();
    }
});

// Pie Chart
const pieCtx = document.getElementById("pieChart");
new Chart(pieCtx, {
    type: "pie",
    data: {
        labels: ["Income", "Expense"],
        datasets: [{
            data: [
                <%= request.getAttribute("totalIncome") != null ? request.getAttribute("totalIncome") : 0 %>,
                <%= request.getAttribute("totalExpense") != null ? request.getAttribute("totalExpense") : 0 %>
            ],
            backgroundColor: ["#16a34a", "#dc2626"]
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { 
            legend: { 
                position: "bottom",
                labels: { usePointStyle: true, padding: 15, font: { size: 12 } }
            }
        }
    }
});

// Line Chart
const lineCtx = document.getElementById("lineChart");
new Chart(lineCtx, {
    type: "line",
    data: {
        labels: [
            "1","2","3","4","5","6","7","8","9","10",
            "11","12","13","14","15","16","17","18","19","20",
            "21","22","23","24","25","26","27","28","29","30","31"
        ],
        datasets: [
        {
            label: "Income",
            data: [
                <%
                List<Double> monthlyIncomeData =
                    (List<Double>) request.getAttribute("monthlyIncomeData");
                if (monthlyIncomeData != null) {
                    for (int i = 0; i < monthlyIncomeData.size(); i++) {
                        out.print(monthlyIncomeData.get(i));
                        if (i != monthlyIncomeData.size() - 1) out.print(",");
                    }
                }
                %>
            ],
            borderColor: "#16a34a",
            backgroundColor: "rgba(22, 163, 74, 0.1)",
            borderWidth: 2,
            tension: 0.4,
            fill: true
        },
        {
            label: "Expense",
            data: [
                <%
                List<Double> monthlyExpenseData =
                    (List<Double>) request.getAttribute("monthlyExpenseData");
                if (monthlyExpenseData != null) {
                    for (int i = 0; i < monthlyExpenseData.size(); i++) {
                        out.print(monthlyExpenseData.get(i));
                        if (i != monthlyExpenseData.size() - 1) out.print(",");
                    }
                }
                %>
            ],
            borderColor: "#dc2626",
            backgroundColor: "rgba(220, 38, 38, 0.1)",
            borderWidth: 2,
            tension: 0.4,
            fill: true
        }
        ]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        interaction: { mode: "index", intersect: false },
        plugins: { 
            legend: { 
                position: "bottom",
                labels: { usePointStyle: true, padding: 15, font: { size: 12 } }
            }
        },
        scales: {
            y: {
                beginAtZero: true,
                grid: { color: "#f1f5f9" },
                ticks: { font: { size: 11 } }
            }
        }
    }
});
document.getElementById("reportForm").addEventListener("submit", function() {
    const selected =
        document.querySelector('input[name="period"]:checked').value;

    alert("Selected = " + selected);
});
</script>
</body>
</html>
