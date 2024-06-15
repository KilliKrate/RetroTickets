<%@ page import="java.util.Objects" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><html>
<%@ page import="com.bubble.retrotickets.Helpers" %>
<head>
    <%@include file="/partials/headTags.jsp" %>
</head>
<body>
<%
    String appPath = (String)application.getInitParameter("appPath");
    String APIURL = Helpers.getAPIURL(request);
%>
<div class="container h-100 w-25 d-flex flex-column justify-content-center align-items-start">
    <h1>Login.</h1>
    <input class="w-100 mt-2 rounded-2" type="text" id="username" placeholder="username">
    <input class="w-100 mt-2 rounded-2" type="password" id="password" placeholder="password">
    <p class="text-danger d-none" id="wrongCredentialsText">Credenziali errate, riprova.</p>
    <button class="mt-2 rounded-2 bg-primary text-light" id="loginButton">Accedi</button>
    <p class="mt-2">Non hai un profilo? <a href=<%=appPath + "/register"%>>Registrati.</a></p>
    <%
        Object requestError = request.getParameter("error");
        if(Objects.equals(requestError, "true")){
    %>
    <div class="alert alert-danger w-100" role="alert">
        Effettua l'accesso prima di accedere a questa pagina.
    </div>
    <%}%>

</div>
<script>
    const tryLogin = async (username, password) => {
        return await fetch("<%=APIURL + "/auth/login"%>", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({
                action: "login",
                username: username,
                password: password,
            }),
        });
    }

    let loginButton = document.querySelector("#loginButton");
    loginButton.addEventListener("click", async (e) =>{
        let username = document.querySelector("#username").value;
        let password = document.querySelector("#password").value;
        let response = await tryLogin(username, password)
        if(response.status == 401){
            let text = document.querySelector("#wrongCredentialsText");
            text.classList.remove("d-none");
        } else if (response.status = 200){
            window.location.href = "<%=APIURL%>";
        }
    });
</script>
</body>
</html>
