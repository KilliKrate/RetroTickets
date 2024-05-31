package com.bubble.retrotickets;

import org.jooq.tools.json.JSONArray;

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

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getPathInfo();

        if (pathInfo == null) {
            JSONArray eventJSON = getEventResource(
                    request.getParameter("id"),
                    request.getParameter("category"));
            response.getWriter().write(eventJSON.toString());
        } else {
            request.setAttribute("event", getEventResource(pathInfo.substring(1), null).get(0));
            request.getRequestDispatcher("/views/event.jsp").forward(request, response);
        }
    }

    private JSONArray getEventResource(String id, String category) {
        String sql = "SELECT * FROM APP.eventi";

        if (id != null) {
            sql = "SELECT * FROM APP.eventi WHERE id = "+ id;
        }
        else if (category != null) {
            sql = "SELECT * FROM APP.eventi WHERE categoria LIKE '"+ category + "'";
        }

        return Helpers.queryResultsToJson(dbConnection, sql);

    }

    public void destroy() {
    }
}
