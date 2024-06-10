package com.bubble.retrotickets;

import org.jooq.tools.json.JSONArray;
import org.jooq.tools.json.JSONObject;
import org.jooq.tools.json.JSONParser;
import org.jooq.tools.json.ParseException;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.*;
import java.util.Arrays;
import java.util.Optional;
import java.util.Scanner;

public class Helpers {

    public static Connection connectToDB(String dbUrl, String dbUser, String dbPass) {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }

        try {
            return DriverManager.getConnection(dbUrl,dbUser,dbPass);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public static JSONArray queryResultsToJson(Connection dbConnection, String sql) {
        try {
            Statement stmt = dbConnection.createStatement();
            ResultSet resultSet = stmt.executeQuery(sql);

            JSONArray json = new JSONArray();
            ResultSetMetaData rsmd = resultSet.getMetaData();
            while(resultSet.next()) {
                int numColumns = rsmd.getColumnCount();
                JSONObject obj = new JSONObject();
                for (int i=1; i<=numColumns; i++) {
                    String column_name = rsmd.getColumnName(i);
                    obj.put(column_name, resultSet.getObject(column_name));
                }
                json.add(obj);
            }
            return json;

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public static int executeUpdateResults(Connection dbConnection, String sql) {
        try {
            //TODO: parameter sanitization
            Statement stmt = dbConnection.createStatement();
            return stmt.executeUpdate(sql);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public static JSONArray apiResultsToJson(String apiUrl, String method) {
        try {
            URL url = new URL(apiUrl);

            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod(method);
            conn.connect();

            //Getting the response code
            int responsecode = conn.getResponseCode();

            if (responsecode != 200) {
                throw new RuntimeException("HttpResponseCode: " + responsecode);
            }
            return getJsonArray(url);

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private static JSONArray getJsonArray(URL url) throws IOException, ParseException {
        String inline = "";
        Scanner scanner = new Scanner(url.openStream());

        //Write all the JSON data into a string using a scanner
        while (scanner.hasNext()) {
            inline += scanner.nextLine();
        }

        //Close the scanner
        scanner.close();

        //Using the JSON simple library parse the string into a json object
        JSONParser parse = new JSONParser();
        JSONArray data_obj = (JSONArray) parse.parse(inline);
        return data_obj;
    }

    public Optional<String> readCookie(HttpServletRequest request, String key) {
        return Arrays.stream(request.getCookies())
                .filter(c -> key.equals(c.getName()))
                .map(Cookie::getValue)
                .findAny();
    }
}
