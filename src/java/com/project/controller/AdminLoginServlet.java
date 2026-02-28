package com.project.controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/adminLogin")
public class AdminLoginServlet extends HttpServlet {

    private static final String ADMIN_USER = "Stock@xyz";
    private static final String ADMIN_PASS = "surya#@093";

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (ADMIN_USER.equals(username) &&
            ADMIN_PASS.equals(password)) {

            // Login Success → Redirect to Admin Dashboard
            response.sendRedirect("index.jsp");

        } else {

            // Login Failed → Back to login page with error
            request.setAttribute("error",
                "Entered credentials are incorrect.");
            RequestDispatcher rd =
                request.getRequestDispatcher("admin_login.jsp");
            rd.forward(request, response);
        }
    }
}