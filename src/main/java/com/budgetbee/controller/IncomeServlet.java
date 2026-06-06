package com.budgetbee.controller;

import java.io.IOException;

import com.budgetbee.dao.IncomeDAO;
import com.budgetbee.model.Income;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/addIncome")
public class IncomeServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        Income income = new Income();

        income.setUserId(1);

        income.setAmount(
                Double.parseDouble(
                        request.getParameter("amount")));

        income.setSource(
                request.getParameter("source"));

        income.setIncomeDate(
                request.getParameter("incomeDate"));

        income.setDescription(
                request.getParameter("description"));

        IncomeDAO dao = new IncomeDAO();

        if (dao.addIncome(income)) {

        	response.sendRedirect("dashboard");

        } else {

            response.getWriter().println("Income Save Failed");
        }
    }
}