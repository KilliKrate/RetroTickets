package com.bubble.retrotickets;

import org.jooq.tools.json.JSONArray;
import org.jooq.tools.json.JSONObject;

import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

@WebFilter(filterName = "StatusFilter")
public class StatusFilter implements Filter {
    Connection dbConnection;
    String appPath;
    public void init(FilterConfig config) throws ServletException {
        dbConnection = Helpers.connectToDB(
                config.getInitParameter("DbUrl"),
                config.getInitParameter("DbUser"),
                config.getInitParameter("DbPassword")
        );
        appPath = config.getInitParameter("appPath");
    }

    public void destroy() {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws ServletException, IOException {
        request.setAttribute("authstatus", getStatus((HttpServletRequest) request));
        chain.doFilter(request, response);
    }

    private String getStatus(HttpServletRequest request){
        String status = "visitor";
        String sessionValue = null;
        Map<String, Cookie> cookieMap = null;
        Cookie authCookie = null;
        HttpSession session = null;

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            cookieMap = new HashMap<>();
            for (Cookie cookie : cookies) {
                cookieMap.put(cookie.getName(), cookie);
            }
            authCookie = cookieMap.get("auth");
        }

        session = request.getSession(false);

        if(authCookie != null){
            sessionValue = authCookie.getValue();
        } else if (session != null && session.getAttribute("auth") != null){
            sessionValue = (String) session.getAttribute("auth");
        }

        if(sessionValue != null){
            System.out.println(sessionValue);
            String sql = "SELECT username, data_scadenza FROM sessioni WHERE sessione = '" + sessionValue + "'";
            JSONArray result = Helpers.queryResultsToJson(dbConnection, sql);
            if(!result.isEmpty()){
                JSONObject resultObj = (JSONObject) result.get(0);
                long cookieExpireDate = (long) resultObj.get("DATA_SCADENZA");
                System.out.println(cookieExpireDate);
                if(cookieExpireDate > (System.currentTimeMillis())){
                    System.out.println("sessione valida");
                    String username = (String) resultObj.get("USERNAME");
                    sql = "SELECT admin FROM utenti WHERE username = '" + username + "'";
                    result = Helpers.queryResultsToJson(dbConnection, sql);
                    JSONObject userStatus = (JSONObject) result.get(0);
                    boolean isAdmin = (boolean) userStatus.get("ADMIN");
                    if(isAdmin){
                        status = "admin";
                    } else {
                        status = "user";
                    }
                }
            }
        }
        return status;
    }
}
