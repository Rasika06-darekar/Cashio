package com.budgetbee.controller;

import java.io.IOException;

import com.budgetbee.dao.IncomeDAO;
import com.budgetbee.model.Income;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/editIncome")
public class EditIncomeServlet extends HttpServlet {

    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

    	String id =
    			request.getParameter("id");

    			if(id == null){
    			    response.sendRedirect("incomeHistory");
    			    return;
    			}

    			int incomeId =
    			Integer.parseInt(id);
        IncomeDAO dao =
                new IncomeDAO();

        Income income =
                dao.getIncomeById(incomeId);

        request.setAttribute(
                "income",
                income);

        request.getRequestDispatcher(
                "editIncome.jsp")
                .forward(request, response);
    }
}