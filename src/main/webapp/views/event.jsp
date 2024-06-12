<%@ page import="org.jooq.tools.json.JSONObject" %>
<%@ page import="org.jooq.tools.json.JSONArray" %>
<%@ page import="com.bubble.retrotickets.Helpers" %>
<%@ page import="com.bubble.retrotickets.DiscountsController" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="it">
<head>
    <%@include file="/partials/headTags.jsp" %>
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

<%
    JSONObject event = (JSONObject) request.getAttribute("event");

    JSONArray discounts = Helpers.apiResultsToJson(
            pageContext.getServletContext().getAttribute("root") + "/discounts",
            "GET"
    );
    JSONObject discount = DiscountsController.getDiscountById(discounts, (int) event.get("ID"));
    Double percentage = null;

    if (discount != null) {
        percentage = (Double) discount.get("PERCENTUALE");
    }
%>

<div class="container mt-5">
    <div class="d-flex align-items-center mb-3">
        <a href="../" class="pe-2 h1 my-0 text-decoration-none text-reset">￩</a>
        <a href="../" class="h5 my-0 py-1">Torna alla home</a>
    </div>
    <div class="mt-3 mb-4">
        <h1 class="display-5"><%=event.get("NOME")%>
        </h1>
    </div>

    <div class="row p-0">
        <div class="col-lg-6">
            <div class="image-container mb-3 mb-md-0"
                 style="background-image: url('${pageContext.request.contextPath}/event_images/<%= event.get("IMAGE")%>');"></div>
        </div>
        <div class="col-lg-6">
            <p class="lead mb-2">Dove: <span class="fw-normal"><%=event.get("LOCALITA")%></span></p>
            <p class="lead mb-2">Quando: <span class="fw-normal"><%=event.get("DATA")%></span></p>
            <p class="lead mb-2">Categoria evento: <span class="fw-normal"><%=event.get("CATEGORIA")%></span></p>
            <hr class="my-4">
            <h5> Biglietti disponibili </h5>

            <div class="my-3">
                <%
                    JSONArray posti = (JSONArray) event.get("POSTI");

                    for (Object o : posti) {
                        JSONObject posto = (JSONObject) o;
                %>
                <div class="card my-2">
                    <form class="card-body p-0 ps-3 d-flex align-items-center justify-content-between">
                        <div class="h-100">
                            <p class="m-0"><span class="fw-bold me-3"><%=posto.get("NOME")%>
                                <% if (discount != null) {%>
                            </span> <s class="me-2"><%=posto.get("PREZZO")%>€</s>
                                <%=DiscountsController.getDiscountedPrice(posto, percentage)%>€</p>
                            <%} else {%>
                                </span><%=posto.get("PREZZO")%>€</span>
                            <%}%>
                            <input type="hidden" name="name" value="<%=posto.get("NOME")%>">
                        </div>
                        <button type="submit" class="btn btn-primary p-3">Acquista</button>
                    </form>
                </div>
                <% } %>
            </div>

        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
</body>
</html>
