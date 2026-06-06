package com.budgetbee.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

import com.budgetbee.dao.BudgetDAO;
import com.budgetbee.dao.ExpenseDAO;
import com.budgetbee.dao.IncomeDAO;
import com.budgetbee.model.Expense;
import com.budgetbee.model.Income;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        IncomeDAO  incomeDAO  = new IncomeDAO();
        ExpenseDAO expenseDAO = new ExpenseDAO();

        // ── Month / Year selector ──────────────────────────
        LocalDate today = LocalDate.now();

        int selectedMonth = today.getMonthValue();
        int selectedYear  = today.getYear();

        String monthParam = request.getParameter("month");
        String yearParam  = request.getParameter("year");

        if (monthParam != null && !monthParam.isEmpty()) {
            selectedMonth = Integer.parseInt(monthParam);
        }
        if (yearParam != null && !yearParam.isEmpty()) {
            selectedYear = Integer.parseInt(yearParam);
        }

        request.setAttribute("selectedMonth", selectedMonth);
        request.setAttribute("selectedYear",  selectedYear);

        // ── Date range filter for chart ────────────────────
        String startDateParam = request.getParameter("startDate");
        String endDateParam   = request.getParameter("endDate");

        // Default = first to last day of selected month
        LocalDate startDate = LocalDate.of(
                selectedYear, selectedMonth, 1);
        LocalDate endDate   = startDate.withDayOfMonth(
                startDate.lengthOfMonth());

        // If user gave custom date range, use that
        if (startDateParam != null && !startDateParam.isEmpty()) {
            startDate = LocalDate.parse(startDateParam);
        }
        if (endDateParam != null && !endDateParam.isEmpty()) {
            endDate = LocalDate.parse(endDateParam);
        }

        // Max 31 days safety
        long diffDays = java.time.temporal.ChronoUnit.DAYS
                .between(startDate, endDate);
        if (diffDays > 31) {
            endDate = startDate.plusDays(31);
        }

        request.setAttribute("startDate", startDate.toString());
        request.setAttribute("endDate",   endDate.toString());

        // ── Summary — selected month only ──────────────────
        double totalIncome  = incomeDAO
                .getMonthlyTotal(selectedMonth, selectedYear);
        double totalExpense = expenseDAO
                .getMonthlyTotal(selectedMonth, selectedYear);
        double balance      = totalIncome - totalExpense;

        double savingsRate = 0;
        if (totalIncome > 0) {
            savingsRate = (balance * 100) / totalIncome;
        }

        System.out.println("Month: " + selectedMonth +
                "/" + selectedYear);
        System.out.println("Income:  " + totalIncome);
        System.out.println("Expense: " + totalExpense);
        System.out.println("Balance: " + balance);

        // ── Budget ─────────────────────────────────────────
        BudgetDAO budgetDAO    = new BudgetDAO();
        double monthlyBudget   = budgetDAO.getCurrentBudget();
        double budgetUsed      = 0;
        double remainingBudget = 0;

        if (monthlyBudget > 0) {
            remainingBudget = monthlyBudget - totalExpense;
            budgetUsed = (totalExpense * 100) / monthlyBudget;
        }

        // ── Recent transactions — selected month ───────────
        List<Income> incomeList = incomeDAO
                .getLatestIncomeByMonth(
                        5, selectedMonth, selectedYear);
        List<Expense> expenseList = expenseDAO
                .getLatestExpenseByMonth(
                        5, selectedMonth, selectedYear);

        // ── Chart data — date range ────────────────────────
        List<Double> weeklyIncomeData  = incomeDAO
                .getIncomeByDateRange(startDate, endDate);
        List<Double> weeklyExpenseData = expenseDAO
                .getExpenseByDateRange(startDate, endDate);

        System.out.println("Chart range: " +
                startDate + " to " + endDate);
        System.out.println("Income data:  " + weeklyIncomeData);
        System.out.println("Expense data: " + weeklyExpenseData);

        // ── Monthly trend data ─────────────────────────────
        List<Double> monthlyIncomeData  = incomeDAO
                .getDailyIncomeByMonth(
                        selectedMonth, selectedYear);
        List<Double> monthlyExpenseData = expenseDAO
                .getDailyExpenseByMonth(
                        selectedMonth, selectedYear);

        // ── Set all attributes ─────────────────────────────
        request.setAttribute("totalIncome",        totalIncome);
        request.setAttribute("totalExpense",       totalExpense);
        request.setAttribute("balance",            balance);
        request.setAttribute("savingsRate",        savingsRate);
        request.setAttribute("monthlyBudget",      monthlyBudget);
        request.setAttribute("budgetUsed",         budgetUsed);
        request.setAttribute("remainingBudget",    remainingBudget);
        request.setAttribute("incomeList",         incomeList);
        request.setAttribute("expenseList",        expenseList);
        request.setAttribute("weeklyIncomeData",   weeklyIncomeData);
        request.setAttribute("weeklyExpenseData",  weeklyExpenseData);
        request.setAttribute("monthlyIncomeData",  monthlyIncomeData);
        request.setAttribute("monthlyExpenseData", monthlyExpenseData);

        request.getRequestDispatcher("dashboard.jsp")
               .forward(request, response);
    }
}