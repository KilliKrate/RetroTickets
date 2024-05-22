package com.bubble.retrotickets;

import java.io.*;
import java.sql.*;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.*;


public class HomeServlet extends HttpServlet {

    public void init() {

    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }

        String url = "jdbc:derby://localhost:1527/RetroTicketsDB";

        Connection con;
        try {
            con = DriverManager.getConnection(url, "admin", "admin");

            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery( "SELECT * FROM APP.utenti");
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