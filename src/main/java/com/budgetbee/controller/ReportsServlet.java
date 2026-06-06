package com.budgetbee.controller;

import java.io.IOException;
import com.budgetbee.dao.ExpenseDAO;
import com.budgetbee.dao.IncomeDAO;
import java.time.LocalDate;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/reports")
public class ReportsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        IncomeDAO incomeDAO = new IncomeDAO();
        ExpenseDAO expenseDAO = new ExpenseDAO();

        // Get period parameter
        String period = request.getParameter("period");
        if (period == null || period.isEmpty()) {
            period = "monthly";
        }

        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        LocalDate startDate = LocalDate.now();
        LocalDate endDate = LocalDate.now();

        // Calculate date range based on period
        if ("weekly".equals(period)) {
            // Last 7 days
            endDate = LocalDate.now();
            startDate = endDate.minusDays(6);
            System.out.println("[REPORT] Weekly: " + startDate + " to " + endDate);
        }
        else if ("monthly".equals(period)) {
            // Current month
            startDate = LocalDate.now().withDayOfMonth(1);
            endDate = LocalDate.now().withDayOfMonth(
                LocalDate.now().lengthOfMonth());
            System.out.println("[REPORT] Monthly: " + startDate + " to " + endDate);
        }
        else if ("annually".equals(period)) {
            // Current year
            startDate = LocalDate.now().withDayOfYear(1);
            endDate = LocalDate.now().withDayOfYear(
                LocalDate.now().lengthOfYear());
            System.out.println("[REPORT] Annually: " + startDate + " to " + endDate);
        }
        else if ("custom".equals(period)) {
            // Custom range
            if (startDateStr != null && !startDateStr.isEmpty()) {
                startDate = LocalDate.parse(startDateStr);
            }
            if (endDateStr != null && !endDateStr.isEmpty()) {
                endDate = LocalDate.parse(endDateStr);
            }
            System.out.println("[REPORT] Custom: " + startDate + " to " + endDate);
        }

        System.out.println("[REPORT] Period: " + period);
        System.out.println("[REPORT] Date Range: " + startDate + " to " + endDate);

        // Get filtered income and expense using date range
        double totalIncome = incomeDAO.getTotalIncomeByDateRange(
                startDate, endDate);
        double totalExpense = expenseDAO.getTotalExpenseByDateRange(
                startDate, endDate);

        double savings = totalIncome - totalExpense;

        System.out.println("[REPORT] Total Income: " + totalIncome);
        System.out.println("[REPORT] Total Expense: " + totalExpense);
        System.out.println("[REPORT] Savings: " + savings);

        request.setAttribute("totalIncome", totalIncome);
        request.setAttribute("totalExpense", totalExpense);
        request.setAttribute("savings", savings);
        request.setAttribute("period", period);
        request.setAttribute("startDate", startDate.toString());
        request.setAttribute("endDate", endDate.toString());

        // Get daily data for chart
        List<Double> dailyIncomeData =
                incomeDAO.getDailyIncomeByDateRange(startDate, endDate);
        List<Double> dailyExpenseData =
                expenseDAO.getDailyExpenseByDateRange(startDate, endDate);

        System.out.println("[REPORT] Daily Income records: " + dailyIncomeData.size());
        System.out.println("[REPORT] Daily Expense records: " + dailyExpenseData.size());

        request.setAttribute("monthlyIncomeData", dailyIncomeData);
        request.setAttribute("monthlyExpenseData", dailyExpenseData);

        request.getRequestDispatcher("reports.jsp").forward(request, response);
    }
}
