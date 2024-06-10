package com.bubble.retrotickets;

import org.jooq.tools.json.JSONArray;
import org.jooq.tools.json.JSONObject;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.util.Random;

public class AccessController extends HttpServlet {
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getServletPath();
        String operation = pathInfo.substring(6);

        switch (operation) {
            case "login":
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                if (tryLogin(username, password)) {
                    String session = generateSession(255);
                    long expire_date = System.currentTimeMillis() + (1000 * 60 * 60 * 24);

                    String sql = "INSERT INTO sessioni (sessione, data_scadenza, username) VALUES ('" + session + "', " + expire_date + ", '" + username + "')";
                    Helpers.executeUpdateResults(dbConnection, sql);

                    Cookie authCookie = new Cookie("auth", session);
                    HttpSession authSession = request.getSession(true);
                    authSession.setAttribute("auth", session);
                    response.encodeURL(appPath);
                    authCookie.setMaxAge(60*60*24);
                    authCookie.setPath(appPath);
                    response.addCookie(authCookie);
                    request.getRequestDispatcher("/").forward(request, response);
                } else {
                    response.setStatus(401);
                }
                break;
            case "register":
                //get register data
                //call register function
                //add session to db
                request.getRequestDispatcher("/").forward(request, response);
                break;
            case "logout":
                Cookie authCookieRemove = new Cookie("auth", "");
                authCookieRemove.setPath(appPath);
                authCookieRemove.setMaxAge(0);
                HttpSession session = request.getSession(false);
                if(session != null){
                    System.out.println("invalidando sessione");
                    session.invalidate();
                }
                //TODO: sarebbe buona pratica rimuovere tutti i cookie di questo utente dal db
                //TODO: (prev) per evitare che la gente si salvi sessioni che non dovrebbero più essere valide
                //TODO: (prev) e per non appesantire il db con sessioni scadute
                response.addCookie(authCookieRemove);
                request.getRequestDispatcher("/").forward(request, response);
                break;
        }
    }

    private boolean tryLogin(String username, String password){
        if(username == null || password == null){
            return false;
        }
        String sql = "SELECT * FROM utenti WHERE username = '" + username + "'";
        JSONArray result = Helpers.queryResultsToJson(dbConnection, sql);
        if(result.size() == 0){
            return false;
        }

        JSONObject user = (JSONObject) result.get(0);
        return user.get("PASSWORD").equals(password);
    }

    private String generateSession(int length){
        String SALTCHARS = "abcdefghijklmnopqrtsuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        StringBuilder salt = new StringBuilder();
        Random rnd = new Random();
        while (salt.length() < length) { // length of the random string.
            int index = (int) (rnd.nextFloat() * SALTCHARS.length());
            salt.append(SALTCHARS.charAt(index));
        }
        return salt.toString();
    }
}
