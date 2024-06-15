<%@ page import="org.jooq.tools.json.JSONArray" %>
<%@ page import="org.jooq.tools.json.JSONObject" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %><%--
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
    <jsp:include page="/partials/navbar.jsp" />

    <%
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        JSONArray utenti = (JSONArray) request.getAttribute("utenti");

        if (utenti != null) { %>

    <div class="form-check mt-4 mb-1">
        <input class="form-check-input" type="checkbox" value="" id="ordinamento">
        <label class="form-check-label" for="ordinamento">
            Ordinamento crescente/decrescente
        </label>
    </div>

    <table class="table table-hover mb-4 mt-1 ">
        <thead>
        <tr>
            <th scope="col">Username</th>
            <th scope="col">Nome</th>
            <th scope="col">Cognome</th>
            <th scope="col">Data di Nascita</th>
            <th scope="col">Email</th>
            <th scope="col">Numero di Telefono</th>
            <th scope="col">Numero Acquisti</th>
        </tr>
        </thead>
        <tbody id="users-table">
        <%
            for (Object o : utenti) {
                JSONObject utente = (JSONObject) o;
        %>
        <tr>
            <td><%= utente.get("USERNAME")%></td>
            <td><%= utente.get("NOME")%></td>
            <td><%= utente.get("COGNOME")%></td>
            <td><%= sdf.format(new Date(((long) utente.get("DATA_NASCITA"))*1000))%></td>
            <td><%= utente.get("EMAIL")%></td>
            <td><%= utente.get("NUM_TELEFONO")%></td>
            <td><%= utente.get("NUM_ACQUISTI")%></td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } else { %>
    Nothing to see here
    <% } %>
</div>

<script>
    async function updateTable(asc) {
        const response = await fetch("${pageContext.request.contextPath}/users");
        const users = await response.json();

        if (asc) {
            users.sort(function(a, b){
                return a["NUM_ACQUISTI"] - b["NUM_ACQUISTI"];
            });
        } else {
            users.sort(function(a, b){
                return b["NUM_ACQUISTI"] - a["NUM_ACQUISTI"];
            });
        }

        console.log(users);

        let old_tbody = document.getElementById("users-table");
        let new_tbody = document.createElement("tbody");
        new_tbody.id = "users-table";
        for (const user of users) {

            const today = new Date(user["DATA_NASCITA"]*1000)
            const yyyy = today.getFullYear();
            let mm = today.getMonth() + 1; // Months start at 0!
            let dd = today.getDate();
            if (dd < 10) dd = '0' + dd;
            if (mm < 10) mm = '0' + mm;
            const formattedToday = dd + '/' + mm + '/' + yyyy;


            let row = document.createElement("tr");
            row.insertAdjacentHTML('beforeend', "<td>"+user["USERNAME"]+"</td>")
            row.insertAdjacentHTML('beforeend', "<td>"+user["NOME"]+"</td>")
            row.insertAdjacentHTML('beforeend', "<td>"+user["COGNOME"]+"</td>")
            row.insertAdjacentHTML('beforeend', "<td>"+formattedToday+"</td>")
            row.insertAdjacentHTML('beforeend', "<td>"+user["EMAIL"]+"</td>")
            row.insertAdjacentHTML('beforeend', "<td>"+user["NUM_TELEFONO"]+"</td>")
            row.insertAdjacentHTML('beforeend', "<td>"+user["NUM_ACQUISTI"]+"</td>")
            new_tbody.appendChild(row);
        }
        old_tbody.parentNode.replaceChild(new_tbody, old_tbody);
    }

    const checkbox = document.getElementById("ordinamento");
    checkbox.indeterminate = true;

    checkbox.addEventListener("change", (e) => {
        if (e.currentTarget.checked) {
            updateTable(true)
        } else {
            updateTable(false);
        }
    })
</script>

</body>
</html>
