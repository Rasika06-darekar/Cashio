package com.budgetbee.controller;

import java.io.IOException;

import com.budgetbee.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/editProfile")
public class EditProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession();

        String email =
                (String) session.getAttribute("userEmail");

        String fullName =
                request.getParameter("fullName");

        String username =
                request.getParameter("username");

        System.out.println("========== EDIT PROFILE ==========");
        System.out.println("Email : " + email);
        System.out.println("Full Name : " + fullName);
        System.out.println("Username : " + username);

        UserDAO dao =
                new UserDAO();

        boolean updated =
                dao.updateProfile(
                        email,
                        fullName,
                        username);

        System.out.println("Profile Updated : " + updated);

        if(updated){

            // Session update
            session.setAttribute(
                    "fullName",
                    fullName);

            session.setAttribute(
                    "username",
                    username);

            response.sendRedirect(
                    "settings.jsp?profileUpdated=1");

        } else {

            response.sendRedirect(
                    "editProfile.jsp?error=1");
        }
    }
}