<%@ page import="org.jooq.tools.json.JSONArray" %>
<%@ page import="org.jooq.tools.json.JSONObject" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="it">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>RetroTickets</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">

</head>
<body>

<div class="container">
    <%@include file="partials/navbar.html" %>

    <div class="px-4 py-2 my-4 text-center">
        <img class="d-block mx-auto my-2" src="/RetroTickets_war_exploded/media/logo.png" alt="Retro Tickets">
        <div class="col-lg-6 mx-auto">
            <p class="lead mb-4">The best concerts and events straight from the 90's</p>
        </div>
    </div>

    <nav class="navbar bg-body-tertiary justify-content-center mb-3">
        <%
            JSONArray categories = (JSONArray) request.getAttribute("categories");
            for (Object o : categories) {
                JSONObject category = (JSONObject) o;
        %>
        <a href="#" class="p-2 mx-3" data-category="<%=category.get("NOME")%>"><%= category.get("NOME")%>
        </a>
        <% } %>
    </nav>


    <%
        JSONArray events = (JSONArray) request.getAttribute("events");

        if (events != null) { %>
    <table class="table">
        <thead>
        <tr>
            <th scope="col">#</th>
            <th scope="col">Nome</th>
            <th scope="col">Località</th>
            <th scope="col">Categoria</th>
            <th scope="col">Clicks</th>
            <th scope="col">Data</th>
        </tr>
        </thead>
        <tbody id="events-table">
        <%
            for (Object o : events) {
                JSONObject event = (JSONObject) o;
        %>
        <tr>
            <th scope="row"><%= event.get("ID")%></th>
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


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>

<script>

    function updateTable(events_list) {
        let old_tbody = document.getElementById("events-table");
        let new_tbody = document.createElement("tbody");
        new_tbody.id = "events-table";
        for (const event of events_list) {
            let row = document.createElement("tr");
            row.insertAdjacentHTML('beforeend', "<th scope=\"row\">" + event["ID"] + "</th>")
            row.insertAdjacentHTML('beforeend', "<td>" + event["NOME"] + "</td>")
            row.insertAdjacentHTML('beforeend', "<td>" + event["LOCALITA"] + "</td>")
            row.insertAdjacentHTML('beforeend', "<td>" + event["CATEGORIA"] + "</td>")
            row.insertAdjacentHTML('beforeend', "<td>" + event["CLICKS"] + "</td>")
            row.insertAdjacentHTML('beforeend', "<td>" + event["DATA"] + "</td>")
            new_tbody.appendChild(row);
        }
        old_tbody.parentNode.replaceChild(new_tbody, old_tbody);
    }

    let navLink = document.querySelectorAll('a[data-category]');
    for (const x of navLink) {
        x.addEventListener("click", async (e) => {
            const response = await fetch("/RetroTickets_war_exploded/events?category=" + x.dataset.category);
            const events = await response.json();
            updateTable(events);
        })
    }

</script>
</body>
</html>
