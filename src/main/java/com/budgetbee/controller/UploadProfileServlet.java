package com.budgetbee.controller;

import java.io.File;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import jakarta.servlet.http.HttpSession;
import com.budgetbee.dao.UserDAO;

@WebServlet("/uploadProfile")
@MultipartConfig
public class UploadProfileServlet extends HttpServlet {


    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        Part filePart =
                request.getPart("profilePic");

        String fileName =
                filePart.getSubmittedFileName();

        String uploadPath =
                getServletContext().getRealPath("")
                + File.separator
                + "uploads";

        File uploadDir =
                new File(uploadPath);

        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        filePart.write(
                uploadPath
                + File.separator
                + fileName);

        String imagePath =
                "uploads/" + fileName;

        System.out.println(
                "Uploaded Image Path = "
                + imagePath);

        // Get logged in user email
        HttpSession session =
                request.getSession();

        String email =
                (String) session.getAttribute("userEmail");

        // Save image path in DB
        UserDAO userDAO =
                new UserDAO();

        userDAO.updateProfilePicture(
                email,
                imagePath);

        // Save in session
        session.setAttribute(
                "profilePicture",
                imagePath);

        response.sendRedirect(
                "dashboard");
    }
}