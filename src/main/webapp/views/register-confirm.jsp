<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
  <%@include file="/partials/headTags.jsp" %>
</head>
<body>
<div class="container d-flex justify-content-center align-items-center flex-column h-100">
  <h1>Registrazione avvenuta con successo!</h1>
  <a href=<%= application.getInitParameter("appPath") %>>Ritorna alla pagina principale</a>
</div>
</body>
</html>