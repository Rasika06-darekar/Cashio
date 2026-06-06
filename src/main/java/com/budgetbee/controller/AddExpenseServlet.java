package com.budgetbee.controller;

import java.io.IOException;

import com.budgetbee.dao.ExpenseDAO;
import com.budgetbee.model.Expense;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/addExpense")
public class AddExpenseServlet extends HttpServlet {


@Override
protected void doPost(HttpServletRequest request,
                      HttpServletResponse response)
        throws ServletException, IOException {

    Expense expense = new Expense();

    expense.setUserId(1);

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

    boolean result =
            dao.addExpense(expense);

    if(result){

        response.sendRedirect(
        "add-expense.jsp?success=1");

    }else{

        response.sendRedirect(
        "add-expense.jsp?error=1");
    }
}


}
