package com.bubble.retrotickets;

import org.jooq.tools.json.JSONArray;
import org.jooq.tools.json.JSONObject;

import java.io.*;
import java.sql.*;
import java.sql.SQLException;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.validation.constraints.NotNull;

public class HomeServlet extends HttpServlet {
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
        /*  Q: Perché passi per un JSON piuttosto che mandare il result set direttamente alla pagina JSP?
            A: Perché non ti fai i fatti tuoi?
            A, continued: Perché ho già dovuto implementare la helper per un microservizio e usandola evito
            una marea di blocchi try-catch sia nelle servlet che nelle pagine JSP)  */

        JSONArray events = Helpers.queryResultsToJson(dbConnection, "SELECT * FROM APP.eventi");
        JSONArray categories = Helpers.queryResultsToJson(dbConnection, "SELECT * FROM APP.categorie");
        request.setAttribute("events", events);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    public void destroy() {
    }
}