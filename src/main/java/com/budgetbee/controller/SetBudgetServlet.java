package com.budgetbee.controller;

import java.io.IOException;

import com.budgetbee.dao.BudgetDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/setBudget")
public class SetBudgetServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        double budgetAmount =
                Double.parseDouble(
                request.getParameter("budget"));

        BudgetDAO dao =
                new BudgetDAO();

        dao.saveBudget(budgetAmount);

        response.sendRedirect("dashboard");
        
    }
}