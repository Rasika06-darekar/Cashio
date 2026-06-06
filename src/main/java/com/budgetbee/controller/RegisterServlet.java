package com.budgetbee.controller;

import java.io.IOException;

import com.budgetbee.dao.UserDAO;
import com.budgetbee.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        User user = new User();

        user.setFullName(fullName);
        user.setUsername(username);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPassword(password);

        UserDAO userDAO = new UserDAO();

        boolean status = userDAO.registerUser(user);

        if (status) {
            response.sendRedirect("success.jsp");
        } else {
            response.sendRedirect("register.jsp");
        }
    }
}