package com.bubble.retrotickets;

import org.jooq.tools.json.JSONArray;

import java.io.*;
import java.sql.*;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class HomeController extends HttpServlet {
    Connection dbConnection;
    public void init() {
        ServletContext context = getServletContext();
        dbConnection = Helpers.connectToDB(
                context.getInitParameter("DbUrl"),
                context.getInitParameter("DbUser"),
                context.getInitParameter("DbPassword")
        );
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        JSONArray events = Helpers.queryResultsToJson(dbConnection, "SELECT * FROM APP.eventi");
        JSONArray categories = Helpers.queryResultsToJson(dbConnection, "SELECT * FROM APP.categorie");
        request.setAttribute("events", events);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    public void destroy() {
    }
}