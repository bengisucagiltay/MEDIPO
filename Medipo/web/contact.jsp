<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="java">

<head>
    <script src="https://code.jquery.com/jquery-1.10.2.js"></script>
    <link href="css/welcome.css" type="text/css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Cinzel+Decorative|Open+Sans:400,600i"
          rel="stylesheet">
    <title>..::Welcome to Medipo::..</title>

    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<body>
<h1 class="header">Medipo</h1>

<div id="navbar1">
</div>
<script>
    $(function () {
        $("#navbar1").load("navigationbar.jsp");
    });
</script>

<div class="centerclmn">

        <h2>Contact Us</h2>

    <div class="container">
        <form action="#">
            <label for="name">Your Name:</label>
            <input type="text" id="name" name="contactname" placeholder="Your full name...">

            <label for="cmail">Your e-mail:</label>
            <input type="text" id="cmail" name="contactmail" placeholder="Your e-mail...">

            <label for="subject">Subject</label>
            <input type="text" id="subject" name="subjectofmsg" placeholder="Subject of your message...">


            <label for="message">Your Message:</label>
            <textarea id="message" name="msg" placeholder="..." style="height:200px"></textarea>

            <input type="submit" value="Submit">
        </form>
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

