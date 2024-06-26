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
                JSONArray utenti = Helpers.queryResultsToJson(dbConnection,
                        "SELECT U.*, A.num_acquisti FROM utenti AS U JOIN ACQUISTI_UTENTE AS A" +
                                " ON A.username = U.username");
                request.setAttribute("utenti", utenti);
                request.getRequestDispatcher("/views/manageusers.jsp").forward(request, response);
                break;
            case "/manageEvents":
                JSONArray events = Helpers.queryResultsToJson(dbConnection, "SELECT * FROM eventi");
                request.setAttribute("events", events);
                request.getRequestDispatcher("/views/manageevents.jsp").forward(request, response);
                break;
            case "/users":
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                JSONArray users = Helpers.queryResultsToJson(dbConnection,
                        "SELECT U.*, A.num_acquisti FROM utenti AS U JOIN ACQUISTI_UTENTE AS A" +
                                " ON A.username = U.username");
                response.getWriter().print(users);
                break;
        }
    }

    public void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String id = request.getPathInfo().substring(request.getPathInfo().lastIndexOf("/")+1);
        int result = Helpers.executeUpdateResults(dbConnection, "DELETE FROM eventi WHERE id = "+id);
        response.setStatus(result > 0 ? HttpServletResponse.SC_OK : HttpServletResponse.SC_NOT_FOUND);
    }
}
