package com.bubble.retrotickets;

import org.jooq.tools.json.JSONArray;
import org.jooq.tools.json.JSONObject;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.Locale;

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

        String id = request.getParameter("id");
        String category = request.getParameter("category");

        if ( id != null || category != null) {
            JSONArray eventJSON = getEventResource(dbConnection, id, category);
            response.getWriter().write(eventJSON.toString());
        } else {
            String eventId = request.getPathInfo().substring(request.getPathInfo().lastIndexOf("/")+1);
            request.setAttribute("event", getEventResource(dbConnection, eventId, null).get(0));
            Helpers.executeUpdateResults(dbConnection, "UPDATE eventi SET clicks = clicks + 1 WHERE id = "+eventId);
            request.getRequestDispatcher("/views/event.jsp").forward(request, response);
        }
    }

    public static JSONArray getEventResource(Connection dbConnection, String id, String category) {
        String sql = "SELECT * FROM eventi";

        if (id != null) {
            sql = "SELECT * FROM eventi WHERE id = "+ id;
        }
        else if (category != null) {
            sql = "SELECT * FROM eventi WHERE categoria LIKE '"+ category + "'";
        }

        JSONArray result = Helpers.queryResultsToJson(dbConnection, sql);
        for (Object o : result) {
            JSONObject obj = (JSONObject) o;
            JSONArray seats = Helpers.queryResultsToJson(dbConnection, "SELECT * FROM posti WHERE evento = " + obj.get("ID"));
            obj.put("POSTI", seats);
        }

        return result;
    }
}
