package com.budgetbee.controller;

import java.io.IOException;
import com.budgetbee.dao.UserDAO;
import com.budgetbee.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO userDAO   = new UserDAO();
        boolean validUser = userDAO.validateUser(email, password);

        if (validUser) {
            HttpSession session = request.getSession();

            // Email
            session.setAttribute("userEmail", email);

            // Full name — "Welcome back, Rasika!" साठी
            User user = userDAO.getUserByEmail(email);
            if (user != null) {
                session.setAttribute("fullName",
                        user.getFullName());
                session.setAttribute("userName",
                        user.getUsername());
            }

            // Profile picture
            String profilePicture =
                    userDAO.getProfilePicture(email);
            session.setAttribute("profilePicture",
                    profilePicture);

            response.sendRedirect("dashboard");

        } else {
            response.sendRedirect("login.jsp?error=1");
        }
    }
}