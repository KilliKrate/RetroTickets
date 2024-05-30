package com.bubble.retrotickets;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

// TODO: Implement session-based database connection instead of dedicated

public class EventsController extends HttpServlet {
    Connection dbConnection;

    public void init() {
        ServletContext context = getServletContext();
        dbConnection = Helpers.connectToDB(
                context.getInitParameter("DbUrl"),
                context.getInitParameter("DbUser"),
                context.getInitParameter("DbPassword")
        );
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String test = request.getQueryString();
        String category = request.getParameter("category");
        if (category == null) {
            category = "%";
        }

        String results = Helpers.queryResultsToJson(dbConnection, "SELECT * FROM APP.eventi WHERE categoria LIKE '"+ category + "'").toString();
        response.getWriter().write(results);
    }

    public void destroy() {
    }
}
