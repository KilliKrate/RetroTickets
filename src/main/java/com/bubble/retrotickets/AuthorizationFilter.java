package com.bubble.retrotickets;

import org.jooq.tools.json.JSONArray;
import org.jooq.tools.json.JSONObject;

import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;

public class AuthorizationFilter implements Filter {
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
        String username = (String) request.getAttribute("username");
        String sql = "SELECT admin FROM utenti WHERE username = '" + username + "'";
        JSONArray result = Helpers.queryResultsToJson(dbConnection, sql);
        JSONObject userStatus = (JSONObject) result.get(0);
        boolean isAdmin = (boolean) userStatus.get("ADMIN");
        if(isAdmin){
            chain.doFilter(request, response);
        } else {
            httpRes.setStatus(403);
        }
    }
}
