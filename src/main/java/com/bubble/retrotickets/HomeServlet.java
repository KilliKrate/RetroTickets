package com.bubble.retrotickets;

import java.io.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class HomeServlet extends HttpServlet {
    private String message;

    public void init() {
        message = "Welcome to RetroTickets!";
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setAttribute("result", message);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    public void destroy() {
    }
}