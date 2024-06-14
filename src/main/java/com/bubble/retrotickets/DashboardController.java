package com.bubble.retrotickets;

import org.jooq.tools.json.JSONArray;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

public class DashboardController extends HttpServlet {

    Connection dbConnection;
    public void init() {
        ServletContext context = getServletContext();
        dbConnection = Helpers.connectToDB(
                context.getInitParameter("DbUrl"),
                context.getInitParameter("DbUser"),
                context.getInitParameter("DbPassword")
        );
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String pathInfo = request.getServletPath();

        switch (pathInfo) {
            case "/manageUsers":
                JSONArray utenti = Helpers.queryResultsToJson(dbConnection, "SELECT * FROM utenti");
                request.setAttribute("utenti", utenti);
                request.getRequestDispatcher("/views/manageusers.jsp").forward(request, response);
                break;
            case "/manageEvents":
                JSONArray events = Helpers.queryResultsToJson(dbConnection, "SELECT * FROM eventi");
                request.setAttribute("events", events);
                request.getRequestDispatcher("/views/manageevents.jsp").forward(request, response);
                break;
        }
    }
}
