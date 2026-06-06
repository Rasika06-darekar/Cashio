package com.budgetbee.controller;

import java.io.IOException;

import com.budgetbee.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/forgotPassword")
public class ForgotPasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String email =
                request.getParameter("email");

        String newPassword =
                request.getParameter("newPassword");

        String confirmPassword =
                request.getParameter("confirmPassword");

        UserDAO dao =
                new UserDAO();

        if(!dao.emailExists(email)) {

            response.sendRedirect(
            "forgotPassword.jsp?emailNotFound=1");

            return;
        }

        if(!newPassword.equals(confirmPassword)) {

            response.sendRedirect(
            "forgotPassword.jsp?mismatch=1");

            return;
        }

        boolean updated =
                dao.updatePassword(
                        email,
                        newPassword);

        if(updated) {

            response.sendRedirect(
            "login.jsp?passwordReset=1");

        } else {

            response.sendRedirect(
            "forgotPassword.jsp?error=1");
        }
    }
}