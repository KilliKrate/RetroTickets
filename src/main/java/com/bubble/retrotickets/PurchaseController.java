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
import java.sql.Connection;

public class PurchaseController extends HttpServlet {

    Connection dbConnection;
    String appPath;

    public void init() {
        ServletContext context = getServletContext();
        appPath = context.getInitParameter("appPath");
        dbConnection = Helpers.connectToDB(
                context.getInitParameter("DbUrl"),
                context.getInitParameter("DbUser"),
                context.getInitParameter("DbPassword")
        );
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String name = request.getParameter("name");
        String event = request.getParameter("event");

        if (name != null || event != null) {
            request.setAttribute("event", EventsController.getEventResource(dbConnection, event, null).get(0));
            request.setAttribute("posto", SeatsController.getSeatResource(dbConnection, event, name).get(0));
            request.getRequestDispatcher("/views/purchase.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/").forward(request, response);
        }

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String eventId = (String) request.getParameter("event");
        String nomePosto = (String) request.getParameter("posto");
        String username = (String) request.getAttribute("username");

        if (eventId != null && nomePosto != null) {
            JSONObject posto = (JSONObject) SeatsController.getSeatResource(dbConnection, eventId, nomePosto).get(0);
            double prezzo = ((BigDecimal) posto.get("PREZZO")).doubleValue();

            JSONArray discounts = Helpers.apiResultsToJson(
                    getServletContext().getAttribute("root") + "/discounts",
                    "GET"
            );

            JSONObject discount = DiscountsController.getDiscountById(discounts, Integer.parseInt(eventId));

            if (discount != null) {
                Double percentage = (Double) discount.get("PERCENTUALE");
                prezzo = Double.parseDouble(DiscountsController.getDiscountedPrice(posto, percentage));
            }

            String sql = "INSERT INTO acquisti (evento, posto, utente, prezzo) VALUES" +
                    " (" + eventId + ", '" + nomePosto + "', '" + username + "', " + prezzo + ")";

            Helpers.executeUpdateResults(dbConnection, sql);
            request.getRequestDispatcher("/views/confirmation.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/").forward(request, response);
        }

    }
}
