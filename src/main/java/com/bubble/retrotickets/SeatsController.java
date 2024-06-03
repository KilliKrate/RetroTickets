package com.bubble.retrotickets;

import org.jooq.tools.json.JSONArray;
import org.jooq.tools.json.JSONObject;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;

public class SeatsController extends HttpServlet {

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

        JSONArray eventJSON = getSeatResource(
                request.getParameter("evento"),
                request.getParameter("nome"));
        response.getWriter().write(eventJSON.toString());
    }

    private JSONArray getSeatResource(String evento, String nome) {
        String sql = "SELECT * FROM posti";

        if (evento != null && nome != null) {
            sql = "SELECT * FROM eventi WHERE evento = " + evento + " AND nome = " + nome;
        }
        else if (evento != null) {
            sql = "SELECT * FROM eventi WHERE evento = " + evento;
        }
        return Helpers.queryResultsToJson(dbConnection, sql);
    }
}
