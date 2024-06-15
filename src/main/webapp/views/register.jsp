<%@ page import="java.util.Objects" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><html>
<%@ page import="com.bubble.retrotickets.Helpers" %>
<head>
  <title>RetroTickets</title>
  <%@include file="/partials/headTags.jsp" %>
</head>
<body>
  <%
    String appPath = (String)application.getInitParameter("appPath");
    String APIURL = Helpers.getAPIURL(request);
%>
  <jsp:include page="/partials/navbar.jsp" />

  <div class="container h-100 w-25 d-flex flex-column justify-content-center align-items-start">
  <h1>Registrati.</h1>
  <input class="w-100 mt-2 rounded-2" type="text" id="nome" placeholder="nome">
  <p class="text-danger" id="emptyFirstNameText">Il nome non può essere vuoto.</p>
  <input class="w-100 mt-2 rounded-2" type="text" id="cognome" placeholder="cognome">
  <p class="text-danger" id="emptyLastNameText">Il cognome non può essere vuoto.</p>
  <input class="w-100 mt-2 rounded-2" type="text" id="username" placeholder="username">
  <p class="text-danger" id="emptyUsernameText">Lo username non può essere vuoto.</p>
  <p class="text-danger" id="usernameTaken">Username non disponibile.</p>
  <input class="w-100 mt-2 rounded-2" type="password" id="password" placeholder="password">
  <p class="text-danger" id="passwordNotValid">La password deve essere lunga 9 caratteri di cui uno speciale e due cifre.</p>
  <input class="w-100 mt-2 rounded-2" type="text" id="email" placeholder="email">
  <p class="text-danger" id="emailNotValid">Inserire un email valida.</p>
  <input class="w-100 mt-2 rounded-2" type="number" id="num_telefono" placeholder="numero di telefono">
  <p class="text-danger" id="phoneNumberNotValid">Il numero di telefono deve essere lungo 10 caratteri.</p>
  <div class="row mt-2 px-2 d-flex">
    <input class="w-100 mx-1 col rounded-2" type="number" id="anno_nascita" placeholder="anno di nascita">
    <input class="w-100 mx-1 col rounded-2" type="number" id="mese_nascita" placeholder="mese di nascita">
    <input class="w-100 mx-1 col rounded-2" type="number" id="giorno_nascita" placeholder="giorno di nascita">
  </div>
  <p class="text-danger" id="birthDateNotValid">Inserire una data valida.</p>
  <div class="row mt-2 px-2 d-flex">
    <button class="mx-1 col rounded-2 bg-primary text-light" id="registerButton">Registrati</button>
    <button class="mx-1 col rounded-2 bg-primary text-light" id="resetButton">Reset</button>
  </div>
  <p class="mt-2">Hai già un profilo? <a href=<%=appPath + "/login"%>>Accedi.</a></p>
</div>
<script>
  const errorManager = (errorName, status) => {
    let text = document.querySelector("#" + errorName);
    status ? text.style.display = "block" : text.style.display = "none";
  }

  const validateData = (nome, cognome, username, password, email, num_telefono, anno_nascita, mese_nascita, giorno_nascita) => {
    let dataIsValid = true;
    if(nome.length == 0){
      errorManager("emptyFirstNameText", true);
      dataIsValid = false;
    } else {
      errorManager("emptyFirstNameText", false);
    }

    if(cognome.length == 0){
      errorManager("emptyLastNameText", true);
      dataIsValid = false;
    } else {
      errorManager("emptyLastNameText", false);
    }

    if(username.length == 0){
      errorManager("emptyUsernameText", true);
      dataIsValid = false;
    } else {
      errorManager("emptyUsernameText", false);
    }

    if(num_telefono.length != 10){
      errorManager("phoneNumberNotValid", true);
      dataIsValid = false;
    } else {
      errorManager("phoneNumberNotValid", false);
    }

    let specialCharacters = password.match(/[!£@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/g);
    let numberCharacters = password.match(/[0123456789]/g);
    let specialCharactersCount = 0;
    let numberCharactersCount = 0;
    if(specialCharacters != null) specialCharactersCount = specialCharacters.length;
    if(numberCharacters != null) numberCharactersCount = numberCharacters.length;
    if(password.length < 9 || specialCharactersCount < 1 || numberCharactersCount < 2){
      errorManager("passwordNotValid", true);
      dataIsValid = false;
    } else {
      errorManager("passwordNotValid", false);
    }

    if(email.length == 0){
      errorManager("emailNotValid", true);
      dataIsValid = false;
    } else {
      errorManager("emailNotValid", false);
    }

    data_nascita = new Date(anno_nascita, mese_nascita-1, giorno_nascita);
    data_maggiore_eta = new Date(parseInt(anno_nascita) + 18, mese_nascita-1, giorno_nascita);
    if(isNaN(data_nascita.valueOf()) || Date.now() - data_maggiore_eta.getTime() < 0){
      errorManager("birthDateNotValid", true);
      dataIsValid = false;
    } else {
      errorManager("birthDateNotValid", false);
    }
    return dataIsValid;
  }

  const tryRegister = async (nome, cognome, username, password, email, num_telefono, data_nascita) => {
    return await fetch("<%=APIURL + "/auth/register"%>", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        action: "register",
        nome: nome,
        cognome: cognome,
        username: username,
        password: password,
        email: email,
        num_telefono: num_telefono,
        data_nascita: data_nascita,
      }),
    });
  }

  errorManager("emptyFirstNameText", false);
  errorManager("emptyLastNameText", false);
  errorManager("emptyUsernameText", false);
  errorManager("usernameTaken", false);
  errorManager("passwordNotValid", false);
  errorManager("phoneNumberNotValid", false);
  errorManager("emailNotValid", false);
  errorManager("birthDateNotValid", false);
  let registerButton = document.querySelector("#registerButton");
  registerButton.addEventListener("click", async(e) =>{
    let nome = document.querySelector("#nome").value;
    let cognome = document.querySelector("#cognome").value;
    let username = document.querySelector("#username").value;
    let password = document.querySelector("#password").value;
    let email = document.querySelector("#email").value;
    let num_telefono = document.querySelector("#num_telefono").value;
    let anno_nascita = document.querySelector("#anno_nascita").value;
    let mese_nascita = document.querySelector("#mese_nascita").value;
    let giorno_nascita = document.querySelector("#giorno_nascita").value;
    let data_nascita = new Date(anno_nascita, mese_nascita, giorno_nascita);
    if(validateData(nome, cognome, username, password, email, num_telefono, anno_nascita, mese_nascita, giorno_nascita)){
      let response = await tryRegister(nome, cognome, username, password, email, num_telefono, data_nascita.getTime());
      if(response.status == 409){
        errorManager("usernameTaken", true);
      } else if (response.status == 200){
        window.location.href = "<%=APIURL%>";
      }
    }
  });


  let resetButton = document.querySelector("#resetButton");
  resetButton.addEventListener("click", async(e) =>{
    document.querySelector("#nome").value = "";
    document.querySelector("#cognome").value = "";
    document.querySelector("#username").value = "";
    document.querySelector("#password").value = "";
    document.querySelector("#email").value = "";
    document.querySelector("#num_telefono").value = "";
    document.querySelector("#anno_nascita").value = "";
    document.querySelector("#mese_nascita").value = "";
    document.querySelector("#giorno_nascita").value = "";
  });

</script>
</body>
</html>