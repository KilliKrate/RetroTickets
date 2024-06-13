<%@ page import="org.jooq.tools.json.JSONObject" %>
<%@ page import="org.jooq.tools.json.JSONArray" %>
<%@ page import="com.bubble.retrotickets.DiscountsController" %>
<%@ page import="com.bubble.retrotickets.Helpers" %><%--
  Created by IntelliJ IDEA.
  User: Ovidi
  Date: 13/06/2024
  Time: 17:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>RetroTickets</title>
    <%@include file="/partials/headTags.jsp" %>
</head>
<body>
<%
    JSONObject posto = (JSONObject) request.getAttribute("posto");
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
<div class="d-flex justify-content-center align-items-center h-100 w-100">
    <form action="${pageContext.request.contextPath}/confirmation" method="post">
        <h1 class="mb-3"> Conferma acquisto </h1>

        <div class="card mb-2">
            <div class="card-body d-flex justify-content-between ">
                <p class="fw-bold mb-0"><%=posto.get("NOME")%></p>
                <div>
                    <% if (discount != null) {%>
                    <s class="me-1"><%=posto.get("PREZZO")%>€</s>
                    <%=DiscountsController.getDiscountedPrice(posto, percentage)%>€
                    <%} else {%>
                    <span><%=posto.get("PREZZO")%>€</span>
                <%}%>
                </div>
            </div>
        </div>
        <input type="hidden" name="event" value="<%= posto.get("EVENTO")%>">
        <input type="hidden" name="posto" value="<%= posto.get("NOME")%>">
        <!-- TODO: Questo href mantiene la sessione in caso di assenza di cookie? -->
        <div class="d-flex justify-content-end">
            <a class="btn btn-secondary me-2" href="${pageContext.request.contextPath}/"> Annulla </a>
            <button type="submit" class="btn btn-primary">Acquista</button>
        </div>
    </form>
</div>
</body>
</html>
