package com.bubble.retrotickets;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "AccessPagesServlet", value = "/AccessPagesServlet")
public class AccessPagesController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getServletPath();
        switch (pathInfo){
            case "/login":
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
                break;
            case "/register":
                request.getRequestDispatcher("/views/register.jsp").forward(request, response);
                break;
            case "/register-confirm":
                request.getRequestDispatcher("/views/register-confirm.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
