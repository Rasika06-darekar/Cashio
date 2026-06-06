package com.budgetbee.controller;

import java.io.IOException;

import com.budgetbee.dao.ExpenseDAO;
import com.budgetbee.model.Expense;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/editExpense")
public class EditExpenseServlet extends HttpServlet {

    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String id =
        request.getParameter("id");

        if(id == null){
            response.sendRedirect("expenseHistory");
            return;
        }

        int expenseId =
        Integer.parseInt(id);

        ExpenseDAO dao =
        new ExpenseDAO();

        Expense expense =
        dao.getExpenseById(expenseId);

        request.setAttribute(
        "expense",
        expense);

        request.getRequestDispatcher(
        "editExpense.jsp")
        .forward(request,response);
    }
}