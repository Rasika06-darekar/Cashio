package com.budgetbee.controller;

import java.io.IOException;

import com.budgetbee.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/updateEmail")
public class UpdateEmailServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession();

        String oldEmail =
                (String)session.getAttribute("userEmail");

        String newEmail =
                request.getParameter("newEmail");

        String confirmEmail =
                request.getParameter("confirmEmail");

        if(!newEmail.equals(confirmEmail)) {

            response.sendRedirect(
                    "updateEmail.jsp?mismatch=1");
            return;
        }

        UserDAO dao =
                new UserDAO();
        System.out.println("Old Email : " + oldEmail);
        System.out.println("New Email : " + newEmail);

        boolean updated =
                dao.updateEmail(
                        oldEmail,
                        newEmail);

        System.out.println("Updated : " + updated);

        if(updated) {

            session.setAttribute(
                    "userEmail",
                    newEmail);

            response.sendRedirect(
                    "settings.jsp?emailUpdated=1");

        } else {

            response.sendRedirect(
                    "updateEmail.jsp?error=1");
        }
    }
}