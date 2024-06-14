<%@ page import="org.jooq.tools.json.JSONArray" %>
<%@ page import="org.jooq.tools.json.JSONObject" %><%--
  Created by IntelliJ IDEA.
  User: broken
  Date: 07/06/24
  Time: 11:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>RetroTickets</title>
    <%@include file="/partials/headTags.jsp" %>
</head>
<body>
<div class="container">
    <%@include file="/partials/navbar.jsp" %>

    <%
        JSONArray utenti = (JSONArray) request.getAttribute("utenti");

        if (utenti != null) { %>
    <table class="table table-hover my-4 ">
        <thead>
        <tr>
            <th scope="col">Username</th>
            <th scope="col">Nome</th>
            <th scope="col">Cognome</th>
            <th scope="col">Data di Nascita</th>
            <th scope="col">Email</th>
            <th scope="col">Numero di Telefono</th>
        </tr>
        </thead>
        <tbody id="events-table">
        <%
            for (Object o : utenti) {
                JSONObject utente = (JSONObject) o;
        %>
        <tr>
            <td><%= utente.get("USERNAME")%></td>
            <td><%= utente.get("NOME")%></td>
            <td><%= utente.get("COGNOME")%></td>
            <td><%= utente.get("DATA_NASCITA")%></td>
            <td><%= utente.get("EMAIL")%></td>
            <td><%= utente.get("NUM_TELEFONO")%></td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } else { %>
    Nothing to see here
    <% } %>
</div>

</body>
</html>
