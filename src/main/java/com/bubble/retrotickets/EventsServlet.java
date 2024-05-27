package com.bubble.retrotickets;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

// TODO: Implement session-based connection instead of dedicated

public class EventsServlet extends HttpServlet {
    Connection con;
    public void init() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }

        String url = "jdbc:derby://localhost:1527/RetroTicketsDB";

        try {
            con = DriverManager.getConnection(url, "admin", "admin");
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery( "SELECT * FROM APP.eventi");
            while (rs.next()) {
                request.setAttribute("result", rs.getString("username"));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    public void destroy() {
    }
}
