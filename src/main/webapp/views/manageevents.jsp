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
        JSONArray events = (JSONArray) request.getAttribute("events");

        if (events != null) { %>
    <table class="table table-hover my-4">
        <thead>
        <tr>
            <th scope="col">Nome</th>
            <th scope="col">Località</th>
            <th scope="col">Categoria</th>
            <th scope="col">Clicks</th>
            <th scope="col">Inizio evento</th>
        </tr>
        </thead>
        <tbody id="events-table">
        <%
            for (Object o : events) {
                JSONObject event = (JSONObject) o;
        %>
        <tr>
            <td><%= event.get("NOME")%></td>
            <td><%= event.get("LOCALITA")%></td>
            <td><%= event.get("CATEGORIA")%></td>
            <td><%= event.get("CLICKS")%></td>
            <td><%= event.get("DATA")%></td>
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
