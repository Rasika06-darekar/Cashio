package com.budgetbee.controller;

import java.io.IOException;

import com.budgetbee.dao.IncomeDAO;
import com.budgetbee.model.Income;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/updateIncome")
public class UpdateIncomeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Income income = new Income();

        income.setIncomeId(
                Integer.parseInt(
                request.getParameter("incomeId")));

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

        boolean status =
                dao.updateIncome(income);

        if(status) {

            response.sendRedirect(
                    "incomeHistory");

        } else {

            response.getWriter().println(
                    "Update Failed");
        }
    }
}