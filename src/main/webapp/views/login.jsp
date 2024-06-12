<%@ page import="java.util.Objects" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><html>
<%@ page import="com.bubble.retrotickets.Helpers" %>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>RetroTickets</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
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
    <p class="mt-2">Non hai un profilo? <a href=<%=appPath%>>Registrati</a></p>
    <%
        Object requestError = request.getParameter("error");
        if(Objects.equals(requestError, "true")){
    %>
    <div class="alert alert-danger w-100" role="alert">
        Prima di accedere a questa pagina effettua il login!
    </div>
    <%}%>

</div>
<script>
    const tryLogin = async (username, password) => {
        return await fetch("<%=APIURL + "/auth/login"%>", {
            method: "POST",
            credentials: "include",
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
            console.log("fatto cazzata")
            let text = document.querySelector("#wrongCredentialsText");
            text.classList.remove("d-none");
        }
    });
</script>
</body>
</html>
