package com.budgetbee.controller;

import java.io.IOException;
import java.util.List;

import com.budgetbee.dao.IncomeDAO;
import com.budgetbee.model.Income;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/incomeHistory")
public class IncomeHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        IncomeDAO dao = new IncomeDAO();

        String source =
                request.getParameter("source");

        String incomeDate =
                request.getParameter("incomeDate");

        String amount =
                request.getParameter("amount");

        List<Income> incomeList;

        if((source != null && !source.isEmpty())
                ||
           (incomeDate != null && !incomeDate.isEmpty())
                ||
           (amount != null && !amount.isEmpty())) {

            incomeList =
            dao.searchIncome(
                    source,
                    incomeDate,
                    amount);

        } else {

            incomeList =
            dao.getAllIncome();
        }

        request.setAttribute(
                "incomeList",
                incomeList);

        request.getRequestDispatcher(
                "income-history.jsp")
                .forward(request,response);
    }
}