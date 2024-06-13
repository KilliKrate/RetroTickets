<%--
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
<div class="d-flex justify-content-center align-items-center h-100 w-100">
    <div>
        <h1 class="mb-3"> Acquisto confermato! </h1>
        <p> Tornerai alla home in 4 secondi, altrimenti clicca <a href="${pageContext.request.contextPath}/">qui</a></p>
    </div>
</div>

<script>
    window.setTimeout(function(){
        window.location.href = "/RetroTickets_war_exploded/";
    }, 4000);

</script>
</body>
</html>
