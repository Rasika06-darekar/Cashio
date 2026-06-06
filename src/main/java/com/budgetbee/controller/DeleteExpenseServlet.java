package com.budgetbee.controller;

import java.io.IOException;

import com.budgetbee.dao.ExpenseDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/deleteExpense")
public class DeleteExpenseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        int expenseId =
                Integer.parseInt(
                        request.getParameter("id"));

        ExpenseDAO dao = new ExpenseDAO();

        dao.deleteExpense(expenseId);

        response.sendRedirect("expenseHistory");
    }
}