<%@ page import="com.bubble.retrotickets.Helpers" %>
<%
    String status = (String) request.getAttribute("authstatus");
    String appPath = (String) application.getInitParameter("appPath");
    String APIURL = Helpers.getAPIURL(request);
%>
<nav class="navbar navbar-expand-lg bg-body-tertiary py-0 px-2">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">
            <img src="${pageContext.request.contextPath}/media/logo_small.svg" alt="Retro Tickets" height="64" class="d-inline-block align-text-center me-2">
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <div class="navbar-nav w-100 d-flex justify-content-between">
                <div class="d-flex">
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="#">Home</a>
                    </li>
                    <%if(status.equals("user") || status.equals("admin")){%>
                    <a class="nav-link active" aria-current="page" href=<%=appPath + "/profile"%>>Profilo</a>
                    <%}%>
                    <%if(status.equals("admin")){%>
                    <a class="nav-link active" aria-current="page" href=<%=appPath + "/manageUsers"%>>Amministra utenti</a>
                    <a class="nav-link active" aria-current="page" href=<%=appPath + "/manageEvents"%>>Amministra eventi</a>
                    <%}%>
                </div>
                <div class="d-flex">
                    <%if(status.equals("user") || status.equals("admin")){%>
                    <a class="nav-link active text-danger" aria-current="page" href=<%=appPath + "/auth/logout"%>>Logout</a>
                    <%}%>
                    <%if(status.equals("visitor")){%>
                    <a class="nav-link active text-secondary" aria-current="page" href=<%=appPath + "/login"%>>Login</a>
                    <a class="nav-link active text-secondary" aria-current="page" href=<%=appPath + "/register"%>>Registrati</a>
                    <%}%>
                </div>


            </ul>
        </div>
    </div>
</nav>
