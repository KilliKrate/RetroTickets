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

    <style>
        tr {
            position: relative;
            background-clip: padding-box
        }
    </style>

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
        <a href="#" class="p-2 mx-3" data-category="<%=category.get("NOME")%>"><%= category.get("NOME") %>
        </a>
        <% } %>
    </nav>


    <%
        JSONArray events = (JSONArray) request.getAttribute("events");

        if (events != null) { %>
    <table class="table table-hover mb-4">
        <thead>
        <tr>
            <th scope="col">Nome</th>
            <th scope="col">Località</th>
            <th scope="col">Categoria</th>
            <th scope="col">Clicks</th>
            <th scope="col">Data e ora</th>
        </tr>
        </thead>
        <tbody id="events-table">
        <%
            for (Object o : events) {
                JSONObject event = (JSONObject) o;
        %>
        <tr>
            <td><a class="stretched-link" href="events/<%= event.get("ID") %>"><%= event.get("NOME")%></a></td>
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

    <div class="alert alert-warning" role="alert" id="discounts">

    </div>

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
            row.insertAdjacentHTML('beforeend', "<td><a class='stretched-link' href='events/"+ event["ID"] + "'>" + event["NOME"] + "</a></td>")
            row.insertAdjacentHTML('beforeend', "<td>" + event["LOCALITA"] + "</td>")
            row.insertAdjacentHTML('beforeend', "<td>" + event["CATEGORIA"] + "</td>")
            row.insertAdjacentHTML('beforeend', "<td>" + event["CLICKS"] + "</td>")
            row.insertAdjacentHTML('beforeend', "<td>" + event["DATA"] + "</td>")
            new_tbody.appendChild(row);
        }
        old_tbody.parentNode.replaceChild(new_tbody, old_tbody);
    }

    async function updateDiscounts() {
            const response = await fetch("/RetroTickets_war_exploded/discounts");
            const discounts = await response.json();
            console.log(discounts);

            let el = document.getElementById("discounts");
            el.innerHTML = "";

            const d = new Date();
            el.insertAdjacentHTML('beforeend', '<p class="lead mb-3">Ultimi sconti, aggiornati il '+d.toLocaleString()+'</p>')

            for (const discount of discounts) {
                let card = document.createElement("div")
                card.className += "card mb-2";

                let card_body = document.createElement("div")
                card_body.className += "card-body";

                card_body.insertAdjacentHTML('beforeend', 'Biglietti per <span class="fw-bold">'+discount["NOME"]+'</span>' +
                    ' in sconto del <span class="fw-bold">'+discount["PERCENTUALE"]+'</span>%!');
                card.appendChild(card_body);
                el.appendChild(card);
            }
    }

    let navLink = document.querySelectorAll('a[data-category]');
    for (const x of navLink) {
        x.addEventListener("click", async (e) => {
            const response = await fetch("/RetroTickets_war_exploded/events?category=" + x.dataset.category);
            const events = await response.json();
            updateTable(events);
        })
    }

    updateDiscounts();
    let interval = window.setInterval(updateDiscounts, 15000);


</script>
</body>
</html>
