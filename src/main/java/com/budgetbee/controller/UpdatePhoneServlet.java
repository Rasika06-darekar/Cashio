package com.budgetbee.controller;

import java.io.IOException;

import com.budgetbee.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/updatePhone")
public class UpdatePhoneServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession();

        String email =
                (String)session.getAttribute("userEmail");

        String phone =
                request.getParameter("phone");

        UserDAO dao =
                new UserDAO();

        boolean updated =
                dao.updatePhone(
                        email,
                        phone);

        if(updated){

            response.sendRedirect(
            "settings.jsp?phoneUpdated=1");

        }else{

            response.sendRedirect(
            "updatePhone.jsp?error=1");
        }
    }
}