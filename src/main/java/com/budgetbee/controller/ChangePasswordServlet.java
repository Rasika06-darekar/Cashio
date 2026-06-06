package com.budgetbee.controller;

import java.io.IOException;

import com.budgetbee.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/changePassword")
public class ChangePasswordServlet extends HttpServlet {

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

        String currentPassword =
                request.getParameter("currentPassword");

        String newPassword =
                request.getParameter("newPassword");

        String confirmPassword =
                request.getParameter("confirmPassword");

        UserDAO dao =
                new UserDAO();

        String dbPassword =
                dao.getPasswordByEmail(email);
        
        System.out.println("========== CHANGE PASSWORD ==========");
        System.out.println("Email : " + email);
        System.out.println("Current Password : " + currentPassword);
        System.out.println("DB Password : " + dbPassword);
        System.out.println("New Password : " + newPassword);
        
        if(!currentPassword.equals(dbPassword)){

            response.sendRedirect(
            "changePassword.jsp?wrongCurrent=1");

            return;
        }

        if(!newPassword.equals(confirmPassword)){

            response.sendRedirect(
            "changePassword.jsp?mismatch=1");

            return;
        }

        boolean updated =
                dao.updatePassword(
                        email,
                        newPassword);

        if(updated){

            response.sendRedirect(
            "settings.jsp?passwordUpdated=1");

        }else{

            response.sendRedirect(
            "changePassword.jsp?error=1");
        }

        System.out.println("Password Updated : " + updated);
    }
}
