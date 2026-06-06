package com.budgetbee.controller;

import java.io.IOException;

import com.budgetbee.dao.ExpenseDAO;
import com.budgetbee.model.Expense;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/updateExpense")
public class UpdateExpenseServlet extends HttpServlet {

    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Expense expense =
        new Expense();

        expense.setExpenseId(
        Integer.parseInt(
        request.getParameter("expenseId")));

        expense.setAmount(
        Double.parseDouble(
        request.getParameter("amount")));

        expense.setCategory(
        request.getParameter("category"));

        expense.setExpenseDate(
        request.getParameter("expenseDate"));

        expense.setDescription(
        request.getParameter("description"));

        ExpenseDAO dao =
        new ExpenseDAO();

        dao.updateExpense(expense);

        response.sendRedirect(
        "expenseHistory");
    }
}