<%@ page import="java.util.List" %>
<%@ page import="com.budgetbee.model.Income" %>
<%@ page import="com.budgetbee.model.Expense" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
if(session.getAttribute("userEmail") == null){
    response.sendRedirect("login.jsp");
    return;
}

double totalIncome  = 0, totalExpense = 0;
double balance      = 0, savingsRate  = 0;
double monthlyBudget= 0, budgetUsed   = 0;
double remainingBudget = 0;

if(request.getAttribute("totalIncome")    != null)
    totalIncome    = Double.parseDouble(request.getAttribute("totalIncome").toString());
if(request.getAttribute("totalExpense")   != null)
    totalExpense   = Double.parseDouble(request.getAttribute("totalExpense").toString());
if(request.getAttribute("balance")        != null)
    balance        = Double.parseDouble(request.getAttribute("balance").toString());
if(request.getAttribute("savingsRate")    != null)
    savingsRate    = Double.parseDouble(request.getAttribute("savingsRate").toString());
if(request.getAttribute("monthlyBudget")  != null)
    monthlyBudget  = Double.parseDouble(request.getAttribute("monthlyBudget").toString());
if(request.getAttribute("budgetUsed")     != null)
    budgetUsed     = Double.parseDouble(request.getAttribute("budgetUsed").toString());
if(request.getAttribute("remainingBudget")!= null)
    remainingBudget= Double.parseDouble(request.getAttribute("remainingBudget").toString());

List<Income>  incomeList        = (List<Income>)  request.getAttribute("incomeList");
List<Expense> expenseList       = (List<Expense>) request.getAttribute("expenseList");
List<Double>  weeklyIncomeData  = (List<Double>)  request.getAttribute("weeklyIncomeData");
List<Double>  weeklyExpenseData = (List<Double>)  request.getAttribute("weeklyExpenseData");

int selMonth = request.getAttribute("selectedMonth") != null ?
    (Integer) request.getAttribute("selectedMonth") :
    java.time.LocalDate.now().getMonthValue();
int selYear = request.getAttribute("selectedYear") != null ?
    (Integer) request.getAttribute("selectedYear") :
    java.time.LocalDate.now().getYear();

String startDateStr = (String) request.getAttribute("startDate");
String endDateStr   = (String) request.getAttribute("endDate");

java.time.LocalDate chartStart = startDateStr != null ?
    java.time.LocalDate.parse(startDateStr) :
    java.time.LocalDate.of(selYear, selMonth, 1);
java.time.LocalDate chartEnd = endDateStr != null ?
    java.time.LocalDate.parse(endDateStr) :
    chartStart.withDayOfMonth(chartStart.lengthOfMonth());

String[] monthNames = {"","January","February","March",
    "April","May","June","July","August",
    "September","October","November","December"};

String fullName = (String) session.getAttribute("fullName");
if(fullName == null) fullName = "User";
String firstName = fullName.contains(" ") ?
    fullName.split(" ")[0] : fullName;

String today = java.time.LocalDate.now().format(
    java.time.format.DateTimeFormatter.ofPattern("dd MMMM yyyy"));
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Cashio Dashboard</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
*{ margin:0; padding:0; box-sizing:border-box;
   font-family:'Segoe UI', sans-serif; }
body{ background:#f0f2f8; display:flex; min-height:100vh; }

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
    padding:28px 32px;
    min-height:100vh;
}

/* ── Top bar ── */
.topbar{
    display:flex; justify-content:space-between;
    align-items:flex-start; margin-bottom:28px;
}
.topbar-left h1{
    font-size:26px; font-weight:700;
    color:#0B1F3A;
}
.topbar-left p{ color:#64748b; font-size:14px; margin-top:4px; }
.topbar-right{
    display:flex; align-items:center; gap:12px;
}
.date-chip{
    background:white; padding:8px 16px;
    border-radius:10px; font-size:13px;
    color:#64748b; font-weight:500;
    border:1px solid #e2e8f0;
    display:flex; align-items:center; gap:6px;
}
.profile-wrap{
    display:flex; align-items:center; gap:10px;
    background:white; padding:8px 14px 8px 8px;
    border-radius:12px; border:1px solid #e2e8f0;
    text-decoration:none;
}
.profile-img{
    width:36px; height:36px; border-radius:9px;
    object-fit:cover;
}
.profile-name{
    font-size:13px; font-weight:600;
    color:#0B1F3A;
}

/* ── Month Selector ── */
.month-bar{
    display:flex; align-items:center;
    gap:10px; flex-wrap:wrap;
    background:white; padding:14px 20px;
    border-radius:14px; margin-bottom:24px;
    border:1px solid #e2e8f0;
    box-shadow:0 1px 4px rgba(0,0,0,0.05);
}
.month-bar label{
    font-weight:700; color:#0B1F3A;
    font-size:13px;
}
.month-bar select{
    padding:8px 12px; border-radius:8px;
    border:1px solid #e2e8f0; font-size:13px;
    color:#0B1F3A; background:#f8fafc;
    cursor:pointer; outline:none;
}
.month-bar select:focus{ border-color:#0B1F3A; }
.btn-apply{
    background:#0B1F3A; color:white;
    border:none; padding:9px 20px;
    border-radius:8px; font-size:13px;
    font-weight:600; cursor:pointer;
    transition:background 0.2s;
}
.btn-apply:hover{ background:#1F3B5C; }
.month-badge{
    margin-left:auto; background:#ecfdf5;
    color:#16a34a; padding:6px 14px;
    border-radius:20px; font-size:13px;
    font-weight:600; border:1px solid #bbf7d0;
}

/* ── Summary Cards ── */
.cards-grid{
    display:grid;
    grid-template-columns:repeat(5,1fr);
    gap:16px; margin-bottom:24px;
}
.stat-card{
    background:white; border-radius:16px;
    padding:20px; border:1px solid #e2e8f0;
    box-shadow:0 1px 4px rgba(0,0,0,0.05);
    display:flex; flex-direction:column; gap:12px;
}
.stat-icon{
    width:44px; height:44px; border-radius:12px;
    display:flex; align-items:center;
    justify-content:center; font-size:20px;
}
.stat-label{
    font-size:12px; color:#64748b;
    font-weight:500; text-transform:uppercase;
    letter-spacing:.5px;
}
.stat-value{
    font-size:22px; font-weight:700;
    color:#0B1F3A; margin-top:2px;
}
.stat-sub{
    font-size:12px; color:#94a3b8; margin-top:2px;
}

/* Budget progress */
.budget-progress{
    height:6px; background:#f1f5f9;
    border-radius:6px; margin-top:6px;
    overflow:hidden;
}
.budget-fill{
    height:100%; border-radius:6px;
    transition:width 0.5s;
}

/* ── Two column layout ── */
.two-col{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:20px; margin-bottom:24px;
}

/* ── Chart card ── */
.chart-card{
    background:white; border-radius:16px;
    padding:22px; border:1px solid #e2e8f0;
    box-shadow:0 1px 4px rgba(0,0,0,0.05);
}
.card-header{
    display:flex; justify-content:space-between;
    align-items:center; margin-bottom:16px;
}
.card-title{
    font-size:15px; font-weight:700; color:#0B1F3A;
}

/* Date filter */
.date-filter{
    display:flex; align-items:center;
    gap:8px; flex-wrap:wrap;
    margin-bottom:16px;
    padding:12px 14px;
    background:#f8fafc; border-radius:10px;
    border:1px solid #e2e8f0;
}
.date-filter label{
    font-size:12px; font-weight:600;
    color:#64748b;
}
.date-filter input{
    padding:6px 10px; border-radius:7px;
    border:1px solid #e2e8f0; font-size:12px;
    color:#0B1F3A; background:white; outline:none;
}
.btn-search{
    background:#0B1F3A; color:white;
    border:none; padding:7px 16px;
    border-radius:7px; font-size:12px;
    font-weight:600; cursor:pointer;
}
.btn-search:hover{ background:#1F3B5C; }

/* ── Transactions card ── */
.trans-card{
    background:white; border-radius:16px;
    padding:22px; border:1px solid #e2e8f0;
    box-shadow:0 1px 4px rgba(0,0,0,0.05);
}
.view-all-btn{
    background:#f1f5f9; color:#0B1F3A;
    border:none; padding:7px 16px;
    border-radius:8px; font-size:12px;
    font-weight:600; cursor:pointer;
    text-decoration:none;
}
table{ width:100%; border-collapse:collapse; }
th{
    font-size:12px; color:#94a3b8;
    font-weight:600; padding:10px 12px;
    text-align:left; border-bottom:1px solid #f1f5f9;
    text-transform:uppercase; letter-spacing:.4px;
}
td{
    padding:12px; font-size:13px;
    color:#334155; border-bottom:1px solid #f8fafc;
}
tr:last-child td{ border-bottom:none; }
.badge-in{
    background:#dcfce7; color:#16a34a;
    padding:4px 10px; border-radius:20px;
    font-size:11px; font-weight:700;
}
.badge-out{
    background:#fee2e2; color:#dc2626;
    padding:4px 10px; border-radius:20px;
    font-size:11px; font-weight:700;
}
.amount-in { color:#16a34a; font-weight:700; }
.amount-out{ color:#dc2626; font-weight:700; }
.no-data{
    text-align:center; color:#94a3b8;
    padding:24px; font-size:13px;
}

/* ── Bottom banner ── */
.overview-banner{
    background:linear-gradient(135deg,#0B1F3A,#1e3a5f);
    color:white; padding:24px 28px;
    border-radius:16px;
    display:flex; align-items:center;
    justify-content:space-between;
}
.overview-banner h3{ font-size:16px; margin-bottom:6px; }
.overview-banner p{ color:#9fb3c8; font-size:13px; }

/* ── Budget Modal ── */
.modal-overlay{
    display:none; position:fixed;
    top:0; left:0; width:100%; height:100%;
    background:rgba(0,0,0,0.45);
    z-index:1000; justify-content:center;
    align-items:center;
}
.modal-box{
    background:white; padding:28px;
    border-radius:20px; width:380px;
}
.modal-box h3{
    color:#0B1F3A; margin-bottom:18px;
    font-size:17px;
}
.modal-box input{
    width:100%; padding:11px 14px;
    border:1px solid #e2e8f0; border-radius:10px;
    font-size:14px; margin-bottom:14px; outline:none;
}
.modal-box input:focus{ border-color:#0B1F3A; }
.modal-btns{ display:flex; gap:10px; }
.modal-btns button{
    flex:1; padding:11px; border:none;
    border-radius:10px; cursor:pointer;
    font-size:14px; font-weight:600;
}
.btn-save  { background:#0B1F3A; color:white; }
.btn-cancel{ background:#f1f5f9; color:#334155; }

@media(max-width:1200px){
    .cards-grid{ grid-template-columns:repeat(3,1fr); }
}
@media(max-width:900px){
    .two-col{ grid-template-columns:1fr; }
    .cards-grid{ grid-template-columns:repeat(2,1fr); }
}
</style>
</head>
<body>

<%
String msg = (String) session.getAttribute("msg");
if(msg != null){ %>
<script>
Swal.fire({
    icon:'success', title:'Success',
    text:'<%= msg %>',
    timer:2000, showConfirmButton:false
});
</script>
<% session.removeAttribute("msg"); } %>

<!-- ── Sidebar ── -->
<div class="sidebar">
    <div class="sidebar-logo">
        <span>Cash<b>io</b></span>
    </div>
    <a href="dashboard" class="nav-item active">
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
    <a href="reports" class="nav-item">
        <div class="nav-icon">📊</div> Reports
    </a>
    <a href="settings.jsp" class="nav-item">
        <div class="nav-icon">⚙️</div> Settings
    </a>
    <a href="logout" class="nav-item"
        style="margin-top:auto;">
        <div class="nav-icon">🚪</div> Logout
    </a>
</div>

<!-- ── Main ── -->
<div class="main">

    <!-- Topbar -->
    <div class="topbar">
        <div class="topbar-left">
            <h1>Dashboard</h1>
            <p>Welcome back, <strong><%= firstName %>!</strong></p>
        </div>
        <div class="topbar-right">
            <div class="date-chip">
                📅 <%= today %>
            </div>
            <a href="settings.jsp" class="profile-wrap">
                <%
                String pic =
                    (String)session.getAttribute("profilePicture");
                if(pic != null && !pic.isEmpty()){ %>
                    <img src="<%= pic %>"
                        class="profile-img" alt="Profile">
                <% } else { %>
                    <img src="profile.png"
                        class="profile-img" alt="Profile">
                <% } %>
                <span class="profile-name">
                    <%= firstName %>
                </span>
            </a>
        </div>
    </div>

    <!-- Month Selector -->
    <div class="month-bar">
        <label>📅 View Month:</label>
        <select id="monthSelect">
            <% for(int m=1;m<=12;m++){ %>
            <option value="<%= m %>"
                <%= m==selMonth?"selected":"" %>>
                <%= monthNames[m] %>
            </option>
            <% } %>
        </select>
        <select id="yearSelect">
            <% for(int y=2023;y<=2027;y++){ %>
            <option value="<%= y %>"
                <%= y==selYear?"selected":"" %>>
                <%= y %>
            </option>
            <% } %>
        </select>
        <button class="btn-apply"
            onclick="applyMonthFilter()">
            Apply
        </button>
        <span class="month-badge">
            <%= monthNames[selMonth] %> <%= selYear %>
        </span>
    </div>

    <!-- Summary Cards -->
    <div class="cards-grid">

        <div class="stat-card">
            <div class="stat-icon"
                style="background:#dcfce7;">💰</div>
            <div>
                <div class="stat-label">Total Income</div>
                <div class="stat-value"
                    style="color:#16a34a;">
                    Rs. <%= String.format("%.2f",totalIncome) %>
                </div>
                <div class="stat-sub">
                    <%= monthNames[selMonth] %> <%= selYear %>
                </div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon"
                style="background:#fee2e2;">🛒</div>
            <div>
                <div class="stat-label">Total Expense</div>
                <div class="stat-value"
                    style="color:#dc2626;">
                    Rs. <%= String.format("%.2f",totalExpense) %>
                </div>
                <div class="stat-sub">
                    <%= monthNames[selMonth] %> <%= selYear %>
                </div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon"
                style="background:#dbeafe;">💳</div>
            <div>
                <div class="stat-label">Current Balance</div>
                <div class="stat-value"
                    style="color:#2563eb;">
                    Rs. <%= String.format("%.2f",balance) %>
                </div>
                <div class="stat-sub">Income - Expense</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon"
                style="background:#f3e8ff;">📈</div>
            <div>
                <div class="stat-label">Savings Rate</div>
                <div class="stat-value"
                    style="color:<%= savingsRate<0?"#dc2626":"#7c3aed" %>">
                    <%= String.format("%.1f",savingsRate) %>%
                </div>
                <div class="stat-sub">of your income</div>
            </div>
        </div>

        <div class="stat-card">
            <div style="display:flex;
                justify-content:space-between;
                align-items:center;">
                <div class="stat-icon"
                    style="background:#fff7ed;">🎯</div>
                <button onclick="document.getElementById(
                    'budgetModal').style.display='flex'"
                    style="background:#0B1F3A;color:white;
                    border:none;border-radius:8px;
                    width:28px;height:28px;font-size:18px;
                    cursor:pointer;line-height:1;">+
                </button>
            </div>
            <div>
                <div class="stat-label">Monthly Budget</div>
                <div class="stat-value"
                    style="color:#ea580c;">
                    Rs. <%= String.format("%.2f",monthlyBudget) %>
                </div>
                <div class="stat-sub">
                    Used <%= String.format("%.1f",budgetUsed) %>%
                    · Remaining Rs.
                    <%= String.format("%.2f",remainingBudget) %>
                </div>
                <div class="budget-progress">
                    <div class="budget-fill"
                        style="width:<%= Math.min(budgetUsed,100) %>%;
                        background:<%= budgetUsed>90?"#dc2626":"#ea580c" %>;">
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- Two Column: Chart + Transactions -->
    <div class="two-col">

        <!-- Chart -->
        <div class="chart-card">
            <div class="card-header">
                <span class="card-title">
                    Income vs Expense
                </span>
            </div>

            <div class="date-filter">
                <label>From:</label>
                <input type="date" id="startDate">
                <label>To:</label>
                <input type="date" id="endDate">
                <button class="btn-search"
                    onclick="filterChart()">
                    Search
                </button>
                <span id="dateError"
                    style="color:red;font-size:11px;
                    display:none;"></span>
            </div>

            <div style="height:260px;">
                <canvas id="financeChart"></canvas>
            </div>
        </div>

        <!-- Transactions -->
        <div class="trans-card">
            <div class="card-header">
                <span class="card-title">
                    Recent Transactions —
                    <%= monthNames[selMonth] %>
                    <%= selYear %>
                </span>
                <a href="incomeHistory"
                    class="view-all-btn">
                    View All
                </a>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>Type</th>
                        <th>Category / Source</th>
                        <th>Amount</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                <%
                int cnt = 0;
                boolean hasData = false;
                if(incomeList != null){
                    for(Income inc : incomeList){
                        if(cnt >= 4) break;
                        hasData = true;
                %>
                <tr>
                    <td><span class="badge-in">IN</span></td>
                    <td><%= inc.getSource() %></td>
                    <td class="amount-in">
                        + Rs. <%= String.format("%.2f",
                            inc.getAmount()) %>
                    </td>
                    <td><%= inc.getIncomeDate() %></td>
                </tr>
                <% cnt++; } }
                if(expenseList != null){
                    for(Expense exp : expenseList){
                        if(cnt >= 8) break;
                        hasData = true;
                %>
                <tr>
                    <td><span class="badge-out">OUT</span></td>
                    <td><%= exp.getCategory() %></td>
                    <td class="amount-out">
                        - Rs. <%= String.format("%.2f",
                            exp.getAmount()) %>
                    </td>
                    <td><%= exp.getExpenseDate() %></td>
                </tr>
                <% cnt++; } }
                if(!hasData){ %>
                <tr>
                    <td colspan="4" class="no-data">
                        No transactions for
                        <%= monthNames[selMonth] %>
                        <%= selYear %>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>

    </div>

    <!-- Financial Overview Banner -->
    <div class="overview-banner">
        <div>
            <h3>Financial Overview —
                <%= monthNames[selMonth] %>
                <%= selYear %></h3>
            <p>Track your income, monitor expenses and
                achieve your savings goals with Cashio.</p>
        </div>
        <div style="font-size:40px;">📊</div>
    </div>

</div>

<!-- Budget Modal -->
<div id="budgetModal" class="modal-overlay">
    <div class="modal-box">
        <h3>Set Monthly Budget</h3>
        <form action="setBudget" method="post">
            <input type="number" name="budget"
                placeholder="Enter amount (Rs.)"
                step="0.01" required>
            <div class="modal-btns">
                <button type="submit"
                    class="btn-save">Save</button>
                <button type="button"
                    class="btn-cancel"
                    onclick="document.getElementById(
                    'budgetModal').style.display='none'">
                    Cancel
                </button>
            </div>
        </form>
    </div>
</div>

<script>
// Set default dates
window.onload = function() {
    const end   = new Date();
    const start = new Date();
    start.setDate(end.getDate() - 6);
    document.getElementById("endDate").value =
        end.toISOString().split("T")[0];
    document.getElementById("startDate").value =
        start.toISOString().split("T")[0];
};

// Month filter
function applyMonthFilter() {
    const m = document.getElementById("monthSelect").value;
    const y = document.getElementById("yearSelect").value;
    window.location.href =
        "dashboard?month=" + m + "&year=" + y;
}

// Date range filter
function filterChart() {
    const s  = document.getElementById("startDate").value;
    const e  = document.getElementById("endDate").value;
    const er = document.getElementById("dateError");
    if(!s || !e){
        er.textContent = "⚠ Select both dates";
        er.style.display = "inline"; return;
    }
    if(new Date(e) < new Date(s)){
        er.textContent = "⚠ End > Start";
        er.style.display = "inline"; return;
    }
    const diff = (new Date(e)-new Date(s))
        / (1000*60*60*24);
    if(diff > 31){
        er.textContent = "⚠ Max 1 month";
        er.style.display = "inline"; return;
    }
    er.style.display = "none";
    window.location.href =
        "dashboard?month=<%= selMonth %>" +
        "&year=<%= selYear %>" +
        "&startDate=" + s + "&endDate=" + e;
}

// Chart
const ctx = document.getElementById("financeChart");
new Chart(ctx, {
    type:"bar",
    data:{
        labels:[
        <%
        java.time.LocalDate d = chartStart;
        boolean first = true;
        while(!d.isAfter(chartEnd)){
            if(!first) out.print(",");
            out.print("\"" + d.getDayOfMonth() + " " +
                d.getMonth().toString().substring(0,3)+"\"");
            first = false;
            d = d.plusDays(1);
        }
        %>
        ],
        datasets:[
        {
            label:"Income",
            data:[
            <%
            if(weeklyIncomeData!=null){
                for(int i=0;i<weeklyIncomeData.size();i++){
                    out.print(weeklyIncomeData.get(i));
                    if(i!=weeklyIncomeData.size()-1)
                        out.print(",");
                }
            }
            %>
            ],
            backgroundColor:"rgba(22,163,74,0.8)",
            borderRadius:6, borderSkipped:false
        },
        {
            label:"Expense",
            data:[
            <%
            if(weeklyExpenseData!=null){
                for(int i=0;i<weeklyExpenseData.size();i++){
                    out.print(weeklyExpenseData.get(i));
                    if(i!=weeklyExpenseData.size()-1)
                        out.print(",");
                }
            }
            %>
            ],
            backgroundColor:"rgba(220,38,38,0.8)",
            borderRadius:6, borderSkipped:false
        }]
    },
    options:{
        responsive:true,
        maintainAspectRatio:false,
        interaction:{ mode:"index", intersect:false },
        animation:{ duration:1200, easing:"easeOutQuart" },
        plugins:{
            legend:{ position:"bottom",
                labels:{ usePointStyle:true,
                    padding:16, font:{size:12} }
            },
            tooltip:{
                backgroundColor:"#0B1F3A",
                padding:12, cornerRadius:8
            }
        },
        scales:{
            x:{ grid:{ display:false },
                ticks:{ font:{size:11} }
            },
            y:{ beginAtZero:true,
                grid:{ color:"#f1f5f9" },
                ticks:{ font:{size:11} }
            }
        }
    }
});
</script>
</body>
</html>