package com.bubble.retrotickets;

import org.jooq.tools.json.JSONArray;
import org.jooq.tools.json.JSONObject;

import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

public class AuthenticationFilter implements Filter {
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
        HttpServletRequest httpReq = (HttpServletRequest) request;
        HttpServletResponse httpRes = (HttpServletResponse) response;
        Cookie[] cookies = httpReq.getCookies();
        Map<String, Cookie> cookieMap = new HashMap<>();
        for (Cookie cookie : cookies) {
            cookieMap.put(cookie.getName(), cookie);
        }
        String sessionValue = null;
        Cookie authCookie = cookieMap.get("auth");
        HttpSession session = httpReq.getSession(false);

        if(authCookie != null){
            sessionValue = authCookie.getValue();
        } else if (session != null && session.getAttribute("auth") != null){
            sessionValue = (String) session.getAttribute("auth");
        }

        if(sessionValue == null){
            request.getRequestDispatcher("/auth/logout").forward(httpReq, httpRes);
        } else {
            String sql = "SELECT username, data_scadenza FROM sessioni WHERE sessione = '" + sessionValue + "'";
            JSONArray result = Helpers.queryResultsToJson(dbConnection, sql);
            if(result.size() == 0){
                request.getRequestDispatcher("/auth/logout").forward(httpReq, httpRes);
            } else {
                JSONObject resultObj = (JSONObject) result.get(0);
                long cookieExpireDate = (long) resultObj.get("DATA_SCADENZA");
                if(cookieExpireDate < (System.currentTimeMillis())){
                    request.getRequestDispatcher("/auth/logout").forward(httpReq, httpRes);
                } else {
                    String username = (String) resultObj.get("USERNAME");
                    request.setAttribute("username", username);
                    chain.doFilter(request, response);
                }
            }
        }


    }
}
