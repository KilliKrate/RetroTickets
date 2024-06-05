package com.bubble.retrotickets;

import org.jooq.tools.json.JSONArray;
import org.jooq.tools.json.JSONObject;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.util.Locale;
import java.util.concurrent.ThreadLocalRandom;


public class DiscountsController extends HttpServlet {
    Connection dbConnection;
    JSONArray discounts;

    public void init() {
        ServletContext context = getServletContext();
        dbConnection = Helpers.connectToDB(
                context.getInitParameter("DbUrl"),
                context.getInitParameter("DbUser"),
                context.getInitParameter("DbPassword")
        );

        JSONArray events = Helpers.queryResultsToJson(dbConnection, "SELECT * FROM eventi");
        discounts = generateDiscounts(events);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        response.getWriter().write(discounts.toString());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    private static JSONArray generateDiscounts(JSONArray events) {
        JSONArray discounts = new JSONArray();
        boolean[] discount_ids = new boolean[events.size()];
        int num_discounts = ThreadLocalRandom.current().nextInt(1, 4);

        for (int i = 0; i < num_discounts; i++) {
            JSONObject discount = new JSONObject();

            int index;
            do {
                index = ThreadLocalRandom.current().nextInt(1, events.size());
            }
            while (discount_ids[index]);
            discount_ids[index] = true;

            JSONObject event = (JSONObject) events.get(index);
            float discount_percentage = ThreadLocalRandom.current().nextInt(5, 25);

            discount.put("ID_EVENTO", event.get("ID"));
            discount.put("NOME", event.get("NOME"));
            discount.put("PERCENTUALE", discount_percentage);

            discounts.add(discount);
        }
        return discounts;
    }

    public static String getDiscountedPrice(JSONObject posto, Double percentage) {
        return String.format(
                Locale.US,
                "%.2f",
                ((((BigDecimal) posto.get("PREZZO")).floatValue()/100 * (100 - percentage))));
    }

    public static JSONObject getDiscountById(JSONArray discounts, int id) {
        for (Object o : discounts) {
            JSONObject tmp = (JSONObject) o;
            if ((long)tmp.get("ID_EVENTO") == id) {

                return tmp;
            }
        }
        return null;
    }
}
