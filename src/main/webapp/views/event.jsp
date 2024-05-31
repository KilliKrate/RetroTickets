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

<% JSONObject event = (JSONObject) request.getAttribute("event"); %>

<div class="container mt-5">
    <div class="d-flex align-items-center mb-3">
        <a href="../" class="pe-2 h1 my-0 text-decoration-none text-reset">￩</a>
        <a href="../" class="h5 my-0 py-1">Torna alla home</a>
    </div>
    <div class="mt-3 mb-4">
        <h1 class="display-5" id="titolo"><%=event.get("NOME")%>
        </h1>
    </div>

    <div class="row p-0">
        <div class="col-lg-6">
            <img src="https://placehold.co/600x400" class="mb-3 mb-md-0 mw-100 img-contain">
        </div>
        <div class="col-lg-6">
            <p class="lead mb-2">Dove: <span class="fw-normal"><%=event.get("LOCALITA")%></span></p>
            <p class="lead mb-2">Quando: <span class="fw-normal"><%=event.get("DATA")%></span></p>
            <p class="lead mb-2">Categoria evento: <span class="fw-normal"><%=event.get("CATEGORIA")%></span></p>
            <hr>
            <p class="h3 mt-3 mb-5" id="prezzo">100€</p>
            <div class="d-flex flex-row align-items-center mb-3">
                <button type="button" id="compra" class="btn btn-primary">Acquista</button>
                <div class="mx-4" style="width: 150px !important;">
                    <input type="number" class="form-control" id="quantita" placeholder="Quantità" value="1">
                </div>
                <p id="esito"></p>
                <p class="lead" id="disponibilita">Disponibilità: </p>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
</body>
</html>
