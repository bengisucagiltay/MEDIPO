<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="java">

<head>
    <link href="css/welcome.css" type="text/css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Cinzel+Decorative|Open+Sans:400,600i"
          rel="stylesheet">
    <title>..::Welcome to Medipo::..</title>

    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<body>
<h1 class="header">Medipo</h1>

<div class="topnav">
    <a href="welcome.jsp">Home</a>
    <a href="upload.jsp">Upload</a>
    <a href="login.jsp">Login</a>
    <a href="about.jsp">About</a>
    <a href="contact.jsp">Contact</a>

    <b>Welcome,
        <%
            if(session.getAttribute("fname")== null){	//user not registered (guest)
                out.println(" Guest");
            }
            else
                out.println(session.getAttribute("fname")); //to do: logout based on guest or registered
        %>
    </b>

    <a style="float: right" href="/Logout" ><u>Logout</u></a>
</div>

<div class="row">
    <div class="centerclmn" id="centd" align="center">
        <div class="modal-content2">
            <br>
            <h3>Medical Image Processing Online<br>(Medipo)</h3><br>
            <h3><u>Contact us</u></h3><br>

            <h2>Mert Ege Can</h2>
            <h4>m.egecan@gmail.com</h4><br>

            <h2>Bengisu Çağıltay</h2>
            <h4>bengisucagiltay@gmail.com</h4><br>

            <h2>İmge Gökalp</h2>
            <h4>imge.gokalp@gmail.com</h4><br>

            <h2>Caner Sezginer</h2>
            <h4>csezginer66@gmail.com</h4><br>
        </div>
    </div>
    <div class="rightclmn">
        <h2>Server ver.1</h2>
        <p class="updatec">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce sit amet ex ante. In at rhoncus ex. Nunc eu magna at turpis dapibus molestie. Sed ut mattis augue.</p>

        <h2>Update 1.2</h2>
        <p class="updatec">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce sit amet ex ante. In at rhoncus ex. Nunc eu magna at turpis dapibus molestie. Sed ut mattis augue.</p>

        <h2 class="updatc" >Maintenance on 21.12.22</h2><br>
        <p class="updatec">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce sit amet ex ante. In at rhoncus ex. Nunc eu magna at turpis dapibus molestie. Sed ut mattis augue.</p>

    </div>

    <img src="images/pulse1.png" alt="backg" width="80%">
</div>
</body>
</html>

