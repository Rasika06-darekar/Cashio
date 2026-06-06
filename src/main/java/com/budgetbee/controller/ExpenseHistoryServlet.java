package com.budgetbee.controller;

import java.io.IOException;
import java.util.List;

import com.budgetbee.dao.ExpenseDAO;
import com.budgetbee.model.Expense;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/expenseHistory")
public class ExpenseHistoryServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        ExpenseDAO dao =
                new ExpenseDAO();

        String category =
                request.getParameter("category");

        String expenseDate =
                request.getParameter("expenseDate");

        String amount =
                request.getParameter("amount");

        List<Expense> expenseList;

        if((category != null && !category.isEmpty())
                ||
           (expenseDate != null && !expenseDate.isEmpty())
                ||
           (amount != null && !amount.isEmpty())) {

            expenseList =
                    dao.searchExpense(
                            category,
                            expenseDate,
                            amount);

        } else {

            expenseList =
                    dao.getAllExpenses();
        }

        request.setAttribute(
                "expenseList",
                expenseList);

        request.getRequestDispatcher(
                "expense-history.jsp")
                .forward(request, response);
    }
}