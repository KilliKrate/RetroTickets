<%@ page import="org.jooq.tools.json.JSONObject" %>
<%@ page import="org.jooq.JSONArrayAggNullStep" %>
<%@ page import="org.jooq.tools.json.JSONArray" %>
<%@ page import="org.jooq.JSON" %>
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
        .image-container {
            position: relative;
            width: 100%;
            padding-top: 70%;
            background-repeat: no-repeat;
            background-size: cover;
            background-position: center;
        }
    </style>
</head>
<body>

<% JSONObject event = (JSONObject) request.getAttribute("event"); %>

<div class="container mt-5">
    <div class="d-flex align-items-center mb-3">
        <a href="../" class="pe-2 h1 my-0 text-decoration-none text-reset">￩</a>
        <a href="../" class="h5 my-0 py-1">Torna alla home</a>
    </div>
    <div class="mt-3 mb-4">
        <h1 class="display-5"><%=event.get("NOME")%></h1>
    </div>

    <div class="row p-0">
        <div class="col-lg-6">
            <div class="image-container mb-3 mb-md-0"
                 style="background-image: url('/RetroTickets_war_exploded/event_images/<%= event.get("IMAGE")%>');"></div>
        </div>
        <div class="col-lg-6">
            <p class="lead mb-2">Dove: <span class="fw-normal"><%=event.get("LOCALITA")%></span></p>
            <p class="lead mb-2">Quando: <span class="fw-normal"><%=event.get("DATA")%></span></p>
            <p class="lead mb-2">Categoria evento: <span class="fw-normal"><%=event.get("CATEGORIA")%></span></p>
            <hr class="my-3">
            <form class="mt-3">
                <fieldset>
                    <legend>Compra biglietti</legend>
                    <div class="mb-3">
                        <label for="posto" class="form-label">Posto</label>
                        <select class="form-select" id="posto">
                            <% JSONArray posti = (JSONArray) event.get("POSTI");
                                JSONObject primoposto = (JSONObject) posti.get(0);
                            %>
                            <option selected value="<%=primoposto.get("NOME")%>"><%=primoposto.get("NOME")%>
                            </option>
                            <%
                                for (int i = 1; i < posti.size(); i++) {
                                    JSONObject posto = (JSONObject) posti.get(i);
                            %>
                            <option value="<%=posto.get("NOME")%>"><%=posto.get("NOME")%>
                            </option>
                            <% } %>
                        </select>
                    </div>
                    <div>
                        <p class="lead mb-2">Prezzo per biglietto: <span class="fw-normal" id="prezzo"><%=primoposto.get("PREZZO")%>€</span></p>
                        <p class="lead">Biglietti disponibili: <span class="fw-normal" id="posti_disponibili"><%=primoposto.get("QUANTITA")%></span></p>
                        <label for="numero_biglietti" class="form-label">Numero biglietti</label>
                        <div class="row">
                            <div class="col">
                                <input type="number" id="numero_biglietti" class="form-control" min="1" max="<%=primoposto.get("QUANTITA")%>" placeholder="1" value="1">
                            </div>
                            <div class="col">
                                <button type="submit" class="btn btn-primary">Acquista</button>
                            </div>
                        </div>
                    </div>
                </fieldset>
            </form>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
<script>

    let posti = <%=posti.toString()%>;

    let select = document.getElementById("posto");
    let prezzo = document.getElementById("prezzo");
    let posti_disp = document.getElementById("posti_disponibili");
    let num_biglietti = document.getElementById("numero_biglietti");

    select.onchange = async function() {
        prezzo.innerHTML = posti[select.selectedIndex]["PREZZO"]+"€";
        posti_disp.innerHTML = posti[select.selectedIndex]["QUANTITA"]
        num_biglietti.setAttribute("max", posti[select.selectedIndex]["QUANTITA"])
        num_biglietti.value = 1;
    };
</script>
</body>
</html>
